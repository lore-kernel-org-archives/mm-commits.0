From: akpm@linux-foundation.org
Subject: +
 fs-if-a-coredump-already-exists-unlink-and-recreate-with-o_excl.patch added to -mm tree
Date: Wed, 05 Aug 2015 15:05:12 -0700
Message-ID: <55c28898.ccJbKWbKginlLNja%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39216 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867AbbHEWFN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Aug 2015 18:05:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jann@thejh.net, keescook@chromium.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: if a coredump already exists, unlink and recreate with O_EXCL
has been added to the -mm tree.  Its filename is
     fs-if-a-coredump-already-exists-unlink-and-recreate-with-o_excl.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-if-a-coredump-already-exists-unlink-and-recreate-with-o_excl.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-if-a-coredump-already-exists-unlink-and-recreate-with-o_excl.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jann Horn <jann@thejh.net>
Subject: fs: if a coredump already exists, unlink and recreate with O_EXCL

It was possible for an attacking user to trick root (or another user) into
writing his coredumps into an attacker-readable, pre-existing file using
rename() or link(), causing the disclosure of secret data from the victim
process' virtual memory.  Depending on the configuration, it was also
possible to trick root into overwriting system files with coredumps.  Fix
that issue by never writing coredumps into existing files.

Requirements for the attack:
 - The attack only applies if the victim's process has a nonzero
   RLIMIT_CORE and is dumpable.
 - The attacker can trick the victim into coredumping into an
   attacker-writable directory D, either because the core_pattern is
   relative and the victim's cwd is attacker-writable or because an
   absolute core_pattern pointing to a world-writable directory is used.
 - The attacker has one of these:
  A: on a system with protected_hardlinks=0:
     execute access to a folder containing a victim-owned,
     attacker-readable file on the same partition as D, and the
     victim-owned file will be deleted before the main part of the attack
     takes place. (In practice, there are lots of files that fulfill
     this condition, e.g. entries in Debian's /var/lib/dpkg/info/.)
     This does not apply to most Linux systems because most distros set
     protected_hardlinks=1.
  B: on a system with protected_hardlinks=1:
     execute access to a folder containing a victim-owned,
     attacker-readable and attacker-writable file on the same partition
     as D, and the victim-owned file will be deleted before the main part
     of the attack takes place.
     (This seems to be uncommon.)
  C: on any system, independent of protected_hardlinks:
     write access to a non-sticky folder containing a victim-owned,
     attacker-readable file on the same partition as D
     (This seems to be uncommon.)

The basic idea is that the attacker moves the victim-owned file to where
he expects the victim process to dump its core.  The victim process dumps
its core into the existing file, and the attacker reads the coredump from
it.

If the attacker can't move the file because he does not have write access
to the containing directory, he can instead link the file to a directory
he controls, then wait for the original link to the file to be deleted
(because the kernel checks that the link count of the corefile is 1).

A less reliable variant that requires D to be non-sticky works with link()
and does not require deletion of the original link: link() the file into
D, but then unlink() it directly before the kernel performs the link count
check.

On systems with protected_hardlinks=0, this variant allows an attacker to
not only gain information from coredumps, but also clobber existing,
victim-writable files with coredumps.  (This could theoretically lead to a
privilege escalation.)

Signed-off-by: Jann Horn <jann@thejh.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c |   38 ++++++++++++++++++++++++++++++++------
 1 file changed, 32 insertions(+), 6 deletions(-)

diff -puN fs/coredump.c~fs-if-a-coredump-already-exists-unlink-and-recreate-with-o_excl fs/coredump.c
--- a/fs/coredump.c~fs-if-a-coredump-already-exists-unlink-and-recreate-with-o_excl
+++ a/fs/coredump.c
@@ -513,10 +513,10 @@ void do_coredump(const siginfo_t *siginf
 	const struct cred *old_cred;
 	struct cred *cred;
 	int retval = 0;
-	int flag = 0;
 	int ispipe;
 	struct files_struct *displaced;
-	bool need_nonrelative = false;
+	/* require nonrelative corefile path and be extra careful */
+	bool need_suid_safe = false;
 	bool core_dumped = false;
 	static atomic_t core_dump_count = ATOMIC_INIT(0);
 	struct coredump_params cprm = {
@@ -550,9 +550,8 @@ void do_coredump(const siginfo_t *siginf
 	 */
 	if (__get_dumpable(cprm.mm_flags) == SUID_DUMP_ROOT) {
 		/* Setuid core dump mode */
-		flag = O_EXCL;		/* Stop rewrite attacks */
 		cred->fsuid = GLOBAL_ROOT_UID;	/* Dump root private */
-		need_nonrelative = true;
+		need_suid_safe = true;
 	}
 
 	retval = coredump_wait(siginfo->si_signo, &core_state);
@@ -633,7 +632,7 @@ void do_coredump(const siginfo_t *siginf
 		if (cprm.limit < binfmt->min_coredump)
 			goto fail_unlock;
 
-		if (need_nonrelative && cn.corename[0] != '/') {
+		if (need_suid_safe && cn.corename[0] != '/') {
 			printk(KERN_WARNING "Pid %d(%s) can only dump core "\
 				"to fully qualified path!\n",
 				task_tgid_vnr(current), current->comm);
@@ -641,8 +640,35 @@ void do_coredump(const siginfo_t *siginf
 			goto fail_unlock;
 		}
 
+		/*
+		 * Unlink the file if it exists unless this is a SUID
+		 * binary - in that case, we're running around with root
+		 * privs and don't want to unlink another user's coredump.
+		 */
+		if (!need_suid_safe) {
+			mm_segment_t old_fs;
+
+			old_fs = get_fs();
+			set_fs(KERNEL_DS);
+			/*
+			 * If it doesn't exist, that's fine. If there's some
+			 * other problem, we'll catch it at the filp_open().
+			 */
+			(void) sys_unlink((const char __user *)cn.corename);
+			set_fs(old_fs);
+		}
+
+		/*
+		 * There is a race between unlinking and creating the
+		 * file, but if that causes an EEXIST here, that's
+		 * fine - another process raced with us while creating
+		 * the corefile, and the other process won. To userspace,
+		 * what matters is that at least one of the two processes
+		 * writes its coredump successfully, not which one.
+		 */
 		cprm.file = filp_open(cn.corename,
-				 O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE | flag,
+				 O_CREAT | 2 | O_NOFOLLOW |
+				 O_LARGEFILE | O_EXCL,
 				 0600);
 		if (IS_ERR(cprm.file))
 			goto fail_unlock;
_

Patches currently in -mm which might be from jann@thejh.net are

fs-if-a-coredump-already-exists-unlink-and-recreate-with-o_excl.patch
fs-dont-dump-core-if-the-corefile-would-become-world-readable.patch

