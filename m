From: akpm@linux-foundation.org
Subject: - binfmt_miscc-avoid-potential-kernel-stack-overflow.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:40:39 -0700
Message-ID: <200804300540.m3U5edKI028987@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42522 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754942AbYD3FlL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:41:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     binfmt_misc.c: avoid potential kernel stack overflow
has been removed from the -mm tree.  Its filename was
     binfmt_miscc-avoid-potential-kernel-stack-overflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: binfmt_misc.c: avoid potential kernel stack overflow
From: Pavel Emelyanov <xemul@openvz.org>

This can be triggered with root help only, but...

Register the ":text:E::txt::/root/cat.txt:' rule in binfmt_misc (by root) and
try launching the cat.txt file (by anyone) :) The result is - the endless
recursion in the load_misc_binary -> open_exec -> load_misc_binary chain and
stack overflow.

There's a similar problem with binfmt_script, and there's a sh_bang memner on
linux_binprm structure to handle this, but simply raising this in binfmt_misc
may break some setups when the interpreter of some misc binaries is a script.

So the proposal is to turn sh_bang into a bit, add a new one (the misc_bang)
and raise it in load_misc_binary.  After this, even if we set up the misc ->
script -> misc loop for binfmts one of them will step on its own bang and
exit.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_em86.c        |    2 +-
 fs/binfmt_misc.c        |    6 ++++++
 fs/binfmt_script.c      |    2 +-
 include/linux/binfmts.h |    3 ++-
 4 files changed, 10 insertions(+), 3 deletions(-)

diff -puN fs/binfmt_em86.c~binfmt_miscc-avoid-potential-kernel-stack-overflow fs/binfmt_em86.c
--- a/fs/binfmt_em86.c~binfmt_miscc-avoid-potential-kernel-stack-overflow
+++ a/fs/binfmt_em86.c
@@ -43,7 +43,7 @@ static int load_em86(struct linux_binprm
 			return -ENOEXEC;
 	}
 
-	bprm->sh_bang++;	/* Well, the bang-shell is implicit... */
+	bprm->sh_bang = 1;	/* Well, the bang-shell is implicit... */
 	allow_write_access(bprm->file);
 	fput(bprm->file);
 	bprm->file = NULL;
diff -puN fs/binfmt_misc.c~binfmt_miscc-avoid-potential-kernel-stack-overflow fs/binfmt_misc.c
--- a/fs/binfmt_misc.c~binfmt_miscc-avoid-potential-kernel-stack-overflow
+++ a/fs/binfmt_misc.c
@@ -115,6 +115,12 @@ static int load_misc_binary(struct linux
 	if (!enabled)
 		goto _ret;
 
+	retval = -ENOEXEC;
+	if (bprm->misc_bang)
+		goto _ret;
+
+	bprm->misc_bang = 1;
+
 	/* to keep locking time low, we copy the interpreter string */
 	read_lock(&entries_lock);
 	fmt = check_file(bprm);
diff -puN fs/binfmt_script.c~binfmt_miscc-avoid-potential-kernel-stack-overflow fs/binfmt_script.c
--- a/fs/binfmt_script.c~binfmt_miscc-avoid-potential-kernel-stack-overflow
+++ a/fs/binfmt_script.c
@@ -29,7 +29,7 @@ static int load_script(struct linux_binp
 	 * Sorta complicated, but hopefully it will work.  -TYT
 	 */
 
-	bprm->sh_bang++;
+	bprm->sh_bang = 1;
 	allow_write_access(bprm->file);
 	fput(bprm->file);
 	bprm->file = NULL;
diff -puN include/linux/binfmts.h~binfmt_miscc-avoid-potential-kernel-stack-overflow include/linux/binfmts.h
--- a/include/linux/binfmts.h~binfmt_miscc-avoid-potential-kernel-stack-overflow
+++ a/include/linux/binfmts.h
@@ -34,7 +34,8 @@ struct linux_binprm{
 #endif
 	struct mm_struct *mm;
 	unsigned long p; /* current top of mem */
-	int sh_bang;
+	unsigned int sh_bang:1,
+		     misc_bang:1;
 	struct file * file;
 	int e_uid, e_gid;
 	kernel_cap_t cap_inheritable, cap_permitted;
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
disable-the-memory-controller-by-default-v3.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-consolidate-checks-for-whether-or-not-to-ignore-a-signal.patch
signals-clean-dequeue_signal-from-excess-checks-and-assignments.patch
signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch
signals-cleanup-security_task_kill-usage-implementation.patch
signals-use-__group_complete_signal-for-the-specific-signals-too.patch
signals-fold-complete_signal-into-send_signal-do_send_sigqueue.patch
signals-unify-send_sigqueue-send_group_sigqueue-completely.patch
ptrace-allow-to-ptrace-sbin-init.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
deprecate-find_task_by_pid-warning-fix.patch
pids-de_thread-dont-clear-session-pgrp-pids-for-the-old-leader.patch
pids-introduce-change_pid-helper.patch
pids-sys_setpgid-use-change_pid-helper.patch
pids-__set_special_pids-use-change_pid-helper.patch
pidns-make-pid-level-and-pid_ns-level-unsigned.patch
reiser4.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

