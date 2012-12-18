From: akpm@linux-foundation.org
Subject: [withdrawn] core_pattern-set-core-helpers-root-and-namespace-to-crashing-process.patch removed from -mm tree
Date: Tue, 18 Dec 2012 14:07:02 -0800
Message-ID: <20121218220703.505F6200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f201.google.com ([209.85.212.201]:51453 "EHLO
	mail-wi0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab2LRWHH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 17:07:07 -0500
Received: by mail-wi0-f201.google.com with SMTP id hm2so67460wib.4
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 14:07:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nhorman@tuxdriver.com, berrange@redhat.com, ebiederm@xmission.com, serge.hallyn@canonical.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: core_pattern: set core helpers root and namespace to crashing process
has been removed from the -mm tree.  Its filename was
     core_pattern-set-core-helpers-root-and-namespace-to-crashing-process.patch

This patch was dropped because it was withdrawn

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

[akpm@linux-foundation.org: fix doc typo, simplify format_corename()]
[akpm@linux-foundation.org: checkpatch fixes]
Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Reported-by: Daniel Berrange <berrange@redhat.com>
Cc: Daniel Berrange <berrange@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/kernel.txt |    7 ++++++-
 fs/coredump.c                   |   21 +++++++++++++++++++++
 include/linux/binfmts.h         |    2 ++
 3 files changed, 29 insertions(+), 1 deletion(-)

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
+  first two characters of the core_pattern sysctl, the kernel will perform the
+  same pipe operation, but the core pipe reader will be executed using the
+  namespace and root fs of the crashing process.
 
 ==============================================================
 
diff -puN fs/coredump.c~core_pattern-set-core-helpers-root-and-namespace-to-crashing-process fs/coredump.c
--- a/fs/coredump.c~core_pattern-set-core-helpers-root-and-namespace-to-crashing-process
+++ a/fs/coredump.c
@@ -164,6 +164,16 @@ static int format_corename(struct core_n
 	if (!cn->corename)
 		return -ENOMEM;
 
+	if (ispipe && pat_ptr[1] == '|') {
+		/*
+		 * We have 2 | tokens at the head of core_pattern which
+		 * indicates we are a pipe and the reader should inherit the
+		 * namespaces of the crashing process
+		 */
+		cprm->switch_ns = true;
+		pat_ptr++;
+	}
+
 	/* Repeat as long as we have more pattern to process and more output
 	   space */
 	while (*pat_ptr) {
@@ -443,6 +453,7 @@ static void wait_for_dump_helpers(struct
 static int umh_pipe_setup(struct subprocess_info *info, struct cred *new)
 {
 	struct file *files[2];
+	struct path root;
 	struct coredump_params *cp = (struct coredump_params *)info->data;
 	int err = create_pipe_files(files, 0);
 	if (err)
@@ -455,6 +466,14 @@ static int umh_pipe_setup(struct subproc
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
 
@@ -476,6 +495,8 @@ void do_coredump(siginfo_t *siginfo)
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
@@ -59,6 +59,8 @@ struct coredump_params {
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
documentation-sysctl-kerneltxt-document-proc-sys-shmall.patch

