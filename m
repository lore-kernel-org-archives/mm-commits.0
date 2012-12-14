From: akpm@linux-foundation.org
Subject: + core_pattern-set-core-helpers-root-and-namespace-to-crashing-process.patch added to -mm tree
Date: Fri, 14 Dec 2012 13:49:23 -0800
Message-ID: <20121214214925.3F95E100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:42401 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932376Ab2LNVt1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 16:49:27 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so399059vbi.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 13:49:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nhorman@tuxdriver.com, berrange@redhat.com, serge.hallyn@canonical.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: core_pattern: set core helpers root and namespace to crashing process
has been added to the -mm tree.  Its filename is
     core_pattern-set-core-helpers-root-and-namespace-to-crashing-process.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Neil Horman <nhorman@tuxdriver.com>
Subject: core_pattern: set core helpers root and namespace to crashing process

As it is currently implemented, redirection of core dumps to a pipe reader
should be executed such that the reader runs in the namespace of the
crashing process, and it currently does not.  This is the only sane way to
deal with namespaces properly it seems to me, and this patch implements
that functionality.

There's one problem I currently see with it, and that is that I'm not sure
we can change the current behavior of how the root fs is set for the pipe
reader, lest we break some user space expectations.  As such I've made the
switching of namespaces configurable based on the addition of an extra '|'
token in the core_pattern sysctl.  1 '|' indicates a pipe using the global
namespace, while 2 '|' indicates that the namespace and root of the
crashing process should be used.

I've tested this using both settings for the new sysctl, and it works well.

For the sake of history, this was discussed before:
http://www.spinics.net/lists/linux-containers/msg21531.html

It seems there was some modicum of consensus as to how this should work, but
there was no action taken on it.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Reported-by: Daniel Berrange <berrange@redhat.com>
Cc: Daniel Berrange <berrange@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/kernel.txt |    7 ++++++-
 fs/coredump.c                   |   23 +++++++++++++++++++++++
 include/linux/binfmts.h         |    2 ++
 3 files changed, 31 insertions(+), 1 deletion(-)

diff -puN Documentation/sysctl/kernel.txt~core_pattern-set-core-helpers-root-and-namespace-to-crashing-process Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~core_pattern-set-core-helpers-root-and-namespace-to-crashing-process
+++ a/Documentation/sysctl/kernel.txt
@@ -191,7 +191,12 @@ core_pattern is used to specify a core d
 	%<OTHER> both are dropped
 . If the first character of the pattern is a '|', the kernel will treat
   the rest of the pattern as a command to run.  The core dump will be
-  written to the standard input of that program instead of to a file.
+  written to the standard input of that program instead of to a file.  Note that
+  when using |, the core pipe reader that is executed will be run in the global
+  namespace and root filesystem.  If two | tokens (i.e. ||) are supplied as the
+  first two characters of the core_pattern sysctl, the kernel will preform the
+  same pipe operation, but the core pipe reader will be executed using the
+  namespace and root fs of the crashing process.
 
 ==============================================================
 
diff -puN fs/coredump.c~core_pattern-set-core-helpers-root-and-namespace-to-crashing-process fs/coredump.c
--- a/fs/coredump.c~core_pattern-set-core-helpers-root-and-namespace-to-crashing-process
+++ a/fs/coredump.c
@@ -164,6 +164,18 @@ static int format_corename(struct core_n
 	if (!cn->corename)
 		return -ENOMEM;
 
+	if (ispipe) {
+		/*
+ 		 * If we have 2 | tokens at the head of core_pattern, it
+ 		 * indicates we are a pipe and the reader should inherit the
+ 		 * namespaces of the crashing process
+ 		 */
+		cprm->switch_ns = (*(pat_ptr+1) == '|') ? true : false;
+		if (cprm->switch_ns)
+			/* Advance pat_ptr so as not to mess up corename */
+			pat_ptr++;
+	}
+
 	/* Repeat as long as we have more pattern to process and more output
 	   space */
 	while (*pat_ptr) {
@@ -443,6 +455,7 @@ static void wait_for_dump_helpers(struct
 static int umh_pipe_setup(struct subprocess_info *info, struct cred *new)
 {
 	struct file *files[2];
+	struct path root;
 	struct coredump_params *cp = (struct coredump_params *)info->data;
 	int err = create_pipe_files(files, 0);
 	if (err)
@@ -455,6 +468,14 @@ static int umh_pipe_setup(struct subproc
 	/* and disallow core files too */
 	current->signal->rlim[RLIMIT_CORE] = (struct rlimit){1, 1};
 
+
+	if (cp->switch_ns) {
+		get_fs_root(cp->cprocess->fs, &root);
+		set_fs_root(current->fs, &root);
+		switch_task_namespaces(current, cp->cprocess->nsproxy);
+	}
+
+
 	return err;
 }
 
@@ -476,6 +497,8 @@ void do_coredump(siginfo_t *siginfo)
 		.siginfo = siginfo,
 		.regs = signal_pt_regs(),
 		.limit = rlimit(RLIMIT_CORE),
+		.cprocess = current,
+		.switch_ns = false,
 		/*
 		 * We must use the same mm->flags while dumping core to avoid
 		 * inconsistency of bit flags, since this flag is not protected
diff -puN include/linux/binfmts.h~core_pattern-set-core-helpers-root-and-namespace-to-crashing-process include/linux/binfmts.h
--- a/include/linux/binfmts.h~core_pattern-set-core-helpers-root-and-namespace-to-crashing-process
+++ a/include/linux/binfmts.h
@@ -61,6 +61,8 @@ struct coredump_params {
 	siginfo_t *siginfo;
 	struct pt_regs *regs;
 	struct file *file;
+	struct task_struct *cprocess;
+	bool switch_ns;
 	unsigned long limit;
 	unsigned long mm_flags;
 };
_

Patches currently in -mm which might be from nhorman@tuxdriver.com are

origin.patch
linux-next.patch
core_pattern-set-core-helpers-root-and-namespace-to-crashing-process.patch
core_pattern-set-core-helpers-root-and-namespace-to-crashing-process-fix.patch
documentation-sysctl-kerneltxt-document-proc-sys-shmall.patch

