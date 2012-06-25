From: akpm@linux-foundation.org
Subject: + fs-make-dumpable=2-require-fully-qualified-path.patch added to -mm tree
Date: Mon, 25 Jun 2012 15:14:17 -0700
Message-ID: <20120625221418.069D4A00B0@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:39605 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757638Ab2FYWOV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jun 2012 18:14:21 -0400
Received: by wibhr14 with SMTP id hr14so98071wib.1
        for <mm-commits@vger.kernel.org>; Mon, 25 Jun 2012 15:14:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: keescook@chromium.org, alan@linux.intel.com, dledford@redhat.com, ebiederm@xmission.com, james.l.morris@oracle.com, serge.hallyn@canonical.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: fs: make dumpable=2 require fully qualified path
has been added to the -mm tree.  Its filename is
     fs-make-dumpable=2-require-fully-qualified-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: fs: make dumpable=2 require fully qualified path

When the suid_dumpable sysctl is set to "2", and there is no core dump
pipe defined in the core_pattern sysctl, a local user can cause core files
to be written to root-writable directories, potentially with
user-controlled content.  This means an admin can unknowningly reintroduce
a variation of CVE-2006-2451, allowing local users to gain root
privileges.

$ cat /proc/sys/fs/suid_dumpable
2
$ cat /proc/sys/kernel/core_pattern
core
$ ulimit -c unlimited
$ cd /
$ ls -l core
ls: cannot access core: No such file or directory
$ touch core
touch: cannot touch `core': Permission denied
$ OHAI="evil-string-here" ping localhost >/dev/null 2>&1 &
$ pid=$!
$ sleep 1
$ kill -SEGV $pid
$ ls -l core
-rw------- 1 root kees 458752 Jun 21 11:35 core
$ sudo strings core | grep evil
OHAI=evil-string-here

While cron has been fixed to abort reading a file when there is any parse
error, there are still other sensitive directories that will read any file
present and skip unparsable lines.

Instead of introducing a suid_dumpable=3 mode and breaking all users of
mode 2, this only disables the unsafe portion of mode 2 (writing to disk
via relative path).  Most users of mode 2 (e.g.  Chrome OS) already use a
core dump pipe handler, so this change will not break them.  For the
situations where a pipe handler is not defined but mode 2 is still active,
crash dumps will only be written to fully qualified paths.  If a relative
path is defined (e.g.  the default "core" pattern), dump attempts will
trigger a printk yelling about the lack of a fully qualified path.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alan Cox <alan@linux.intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: James Morris <james.l.morris@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/fs.txt |   18 ++++++++++++------
 fs/exec.c                   |   17 ++++++++++++++---
 2 files changed, 26 insertions(+), 9 deletions(-)

diff -puN Documentation/sysctl/fs.txt~fs-make-dumpable=2-require-fully-qualified-path Documentation/sysctl/fs.txt
--- a/Documentation/sysctl/fs.txt~fs-make-dumpable=2-require-fully-qualified-path
+++ a/Documentation/sysctl/fs.txt
@@ -205,16 +205,22 @@ This value can be used to query and set 
 or otherwise protected/tainted binaries. The modes are
 
 0 - (default) - traditional behaviour. Any process which has changed
-	privilege levels or is execute only will not be dumped
+	privilege levels or is execute only will not be dumped.
 1 - (debug) - all processes dump core when possible. The core dump is
 	owned by the current user and no security is applied. This is
 	intended for system debugging situations only. Ptrace is unchecked.
+	This is insecure as it allows regular users to examine the memory
+	contents of privileged processes.
 2 - (suidsafe) - any binary which normally would not be dumped is dumped
-	readable by root only. This allows the end user to remove
-	such a dump but not access it directly. For security reasons
-	core dumps in this mode will not overwrite one another or
-	other files. This mode is appropriate when administrators are
-	attempting to debug problems in a normal environment.
+	anyway, but only if the "core_pattern" kernel sysctl is set to
+	either a pipe handler or a fully qualified path. (For more details
+	on this limitation, see CVE-2006-2451.) This mode is appropriate
+	when administrators are attempting to debug problems in a normal
+	environment, and either have a core dump pipe handler that knows
+	to treat privileged core dumps with care, or specific directory
+	defined for catching core dumps. If a core dump happens without
+	a pipe handler or fully qualifid path, a message will be emitted
+	to syslog warning about the lack of a correct setting.
 
 ==============================================================
 
diff -puN fs/exec.c~fs-make-dumpable=2-require-fully-qualified-path fs/exec.c
--- a/fs/exec.c~fs-make-dumpable=2-require-fully-qualified-path
+++ a/fs/exec.c
@@ -2111,6 +2111,7 @@ void do_coredump(long signr, int exit_co
 	int retval = 0;
 	int flag = 0;
 	int ispipe;
+	bool need_nonrelative = false;
 	static atomic_t core_dump_count = ATOMIC_INIT(0);
 	struct coredump_params cprm = {
 		.signr = signr,
@@ -2136,14 +2137,16 @@ void do_coredump(long signr, int exit_co
 	if (!cred)
 		goto fail;
 	/*
-	 *	We cannot trust fsuid as being the "true" uid of the
-	 *	process nor do we know its entire history. We only know it
-	 *	was tainted so we dump it as root in mode 2.
+	 * We cannot trust fsuid as being the "true" uid of the process
+	 * nor do we know its entire history. We only know it was tainted
+	 * so we dump it as root in mode 2, and only into a controlled
+	 * environment (pipe handler or fully qualified path).
 	 */
 	if (__get_dumpable(cprm.mm_flags) == 2) {
 		/* Setuid core dump mode */
 		flag = O_EXCL;		/* Stop rewrite attacks */
 		cred->fsuid = GLOBAL_ROOT_UID;	/* Dump root private */
+		need_nonrelative = true;
 	}
 
 	retval = coredump_wait(exit_code, &core_state);
@@ -2223,6 +2226,14 @@ void do_coredump(long signr, int exit_co
 		if (cprm.limit < binfmt->min_coredump)
 			goto fail_unlock;
 
+		if (need_nonrelative && cn.corename[0] != '/') {
+			printk(KERN_WARNING "Pid %d(%s) can only dump core "\
+				"to fully qualified path!\n",
+				task_tgid_vnr(current), current->comm);
+			printk(KERN_WARNING "Skipping core dump\n");
+			goto fail_unlock;
+		}
+
 		cprm.file = filp_open(cn.corename,
 				 O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE | flag,
 				 0600);
_
Subject: Subject: fs: make dumpable=2 require fully qualified path

Patches currently in -mm which might be from keescook@chromium.org are

linux-next.patch
c-r-prctl-less-paranoid-prctl_set_mm_exe_file.patch
fs-add-link-restrictions.patch
fs-add-link-restriction-audit-reporting.patch
fs-make-dumpable=2-require-fully-qualified-path.patch

