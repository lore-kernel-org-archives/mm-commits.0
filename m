From: akpm@linux-foundation.org
Subject: + sys_time-use-barrier-instead-of-smp_rmb.patch added to -mm tree
Date: Tue, 17 Jul 2007 17:41:40 -0700
Message-ID: <200707180041.l6I0feIx015962@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53425 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759243AbXGRAmK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 20:42:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, csnook@redhat.com, mingo@elte.hu


The patch titled
     sys_time: use barrier() instead of smp_rmb()
has been added to the -mm tree.  Its filename is
     sys_time-use-barrier-instead-of-smp_rmb.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sys_time: use barrier() instead of smp_rmb()
From: Oleg Nesterov <oleg@tv-sign.ru>

There is no reason to use rmb(), we don't do any LOADs which could be
reordered.  What we need is a simple compiler barrier, to prevent the
reading of the "volatile" xtime.tv_sec twice.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Chris Snook <csnook@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/time.c~sys_time-use-barrier-instead-of-smp_rmb kernel/time.c
--- a/kernel/time.c~sys_time-use-barrier-instead-of-smp_rmb
+++ a/kernel/time.c
@@ -64,7 +64,7 @@ asmlinkage long sys_time(time_t __user *
 	 */
 	time_t i = xtime.tv_sec;
 
-	smp_rmb(); /* sys_time() results are coherent */
+	barrier(); /* sys_time() results are coherent */
 
 	if (tloc) {
 		if (put_user(i, tloc))
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
git-sparc64.patch
freezer-run-show_state-when-freezing-times-out.patch
hibernation-prepare-to-enter-the-low-power-state.patch
freezer-avoid-freezing-kernel-threads-prematurely.patch
freezer-use-__set_current_state-in-refrigerator.patch
freezer-return-int-from-freeze_processes.patch
freezer-remove-redundant-check-in-try_to_freeze_tasks.patch
pm-prevent-frozen-user-mode-helpers-from-failing-the-freezing-of-tasks-rev-2.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
sys_time-use-barrier-instead-of-smp_rmb.patch
drivers-edac-fix-workq-reset-deadlock.patch
