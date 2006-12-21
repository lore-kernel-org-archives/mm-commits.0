From: akpm@osdl.org
Subject: - fix-collie-compilation.patch removed from -mm tree
Date: Thu, 21 Dec 2006 12:09:55 -0800
Message-ID: <200612212009.kBLK9tCo003509@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36498 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423070AbWLUUKE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 15:10:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@ucw.cz, pavel@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fix collie compilation
has been removed from the -mm tree.  Its filename was
     fix-collie-compilation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix collie compilation
From: Pavel Machek <pavel@ucw.cz>

Thanks to Al Viro, here's fix to 2.6.20-rc1-git, so that collie compiles,
again.  It was broken by INIT_WORK changes.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/sa1100fb.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/sa1100fb.c~fix-collie-compilation drivers/video/sa1100fb.c
--- a/drivers/video/sa1100fb.c~fix-collie-compilation
+++ a/drivers/video/sa1100fb.c
@@ -1200,9 +1200,9 @@ static void set_ctrlr_state(struct sa110
  * Our LCD controller task (which is called when we blank or unblank)
  * via keventd.
  */
-static void sa1100fb_task(void *dummy)
+static void sa1100fb_task(struct work_struct *w)
 {
-	struct sa1100fb_info *fbi = dummy;
+	struct sa1100fb_info *fbi = container_of(w, struct sa1100fb_info, task);
 	u_int state = xchg(&fbi->task_state, -1);
 
 	set_ctrlr_state(fbi, state);
@@ -1444,7 +1444,7 @@ static struct sa1100fb_info * __init sa1
 					  fbi->max_bpp / 8;
 
 	init_waitqueue_head(&fbi->ctrlr_wait);
-	INIT_WORK(&fbi->task, sa1100fb_task, fbi);
+	INIT_WORK(&fbi->task, sa1100fb_task);
 	init_MUTEX(&fbi->ctrlr_sem);
 
 	return fbi;
_

Patches currently in -mm which might be from pavel@ucw.cz are

origin.patch
fix-swapped-parameters-in-mm-vmscanc.patch
shrink_all_memory-fix-lru_pages-handling.patch
git-acpi.patch
pm-change-code-ordering-in-mainc.patch
swsusp-change-code-ordering-in-diskc.patch
swsusp-change-code-ordering-in-userc.patch
swsusp-change-code-ordering-in-userc-sanity.patch
swsusp-change-pm_ops-handling-by-userland-interface.patch

