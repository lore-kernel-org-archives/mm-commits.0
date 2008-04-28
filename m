From: akpm@linux-foundation.org
Subject: - mfd-use-shorter-set_current_state.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:56:03 -0700
Message-ID: <200804282156.m3SLu3Mb018183@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44674 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935971AbYD1V4V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:56:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, dtor@mail.ru, nico@cam.org, rmk+kernel@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     mfd: use shorter set_current_state()
has been removed from the -mm tree.  Its filename was
     mfd-use-shorter-set_current_state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mfd: use shorter set_current_state()
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Since this routine declares a separate "tsk" pointer for no other reason than
to call set_task_state(), get rid of it and just invoke set_current_state().

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Nicolas Pitre <nico@cam.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/ucb1x00-ts.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/mfd/ucb1x00-ts.c~mfd-use-shorter-set_current_state drivers/mfd/ucb1x00-ts.c
--- a/drivers/mfd/ucb1x00-ts.c~mfd-use-shorter-set_current_state
+++ a/drivers/mfd/ucb1x00-ts.c
@@ -204,8 +204,7 @@ static inline int ucb1x00_ts_pen_down(st
 static int ucb1x00_thread(void *_ts)
 {
 	struct ucb1x00_ts *ts = _ts;
-	struct task_struct *tsk = current;
-	DECLARE_WAITQUEUE(wait, tsk);
+	DECLARE_WAITQUEUE(wait, current);
 	int valid = 0;
 
 	set_freezable();
@@ -234,7 +233,7 @@ static int ucb1x00_thread(void *_ts)
 
 
 		if (ucb1x00_ts_pen_down(ts)) {
-			set_task_state(tsk, TASK_INTERRUPTIBLE);
+			set_current_state(TASK_INTERRUPTIBLE);
 
 			ucb1x00_enable_irq(ts->ucb, UCB_IRQ_TSPX, machine_is_collie() ? UCB_RISING : UCB_FALLING);
 			ucb1x00_disable(ts->ucb);
@@ -262,7 +261,7 @@ static int ucb1x00_thread(void *_ts)
 				valid = 1;
 			}
 
-			set_task_state(tsk, TASK_INTERRUPTIBLE);
+			set_current_state(TASK_INTERRUPTIBLE);
 			timeout = HZ / 100;
 		}
 
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
git-mtd.patch
git-nfsd.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
kernel-explicitly-include-required-header-files-under-kernel.patch
remove-superfluous-include-of-stringh-from-percpuh.patch
kbuild-remove-duplicate-conflicting-entry-for-oomh.patch
kbuild-move-files-that-dont-check-__kernel__.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations-checkpatch-fixes.patch
maintainers-clarify-status-of-mn10300-mailing-list-as-moderated.patch
ipmi-make-comment-match-actual-preprocessor-check.patch
keys-explicitly-include-required-slabh-header-file.patch
nbd-delete-superfluous-test-for-__gnuc__.patch
generalize-asm-generic-ioctlh-to-allow-overriding-values.patch
edac-use-the-shorter-list_head-for-brevity.patch
afs-use-the-shorter-list_head-for-brevity.patch
sysv-fs-remove-superfluous-check-for-__gnuc__-compiler.patch
remove-ifdef-__kernel__-checks-from-unexported-headers.patch
remove-__kernel__-tests-of-unexported-headers-under-asm-generic.patch
drop-the-exporting-of-empty-linux-byteorder-generich.patch

