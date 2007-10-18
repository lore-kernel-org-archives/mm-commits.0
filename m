From: akpm@linux-foundation.org
Subject: - writeback-remove-unnecessary-wait-in-throttle_vm_writeout.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:02:43 -0700
Message-ID: <200710180702.l9I72hi2031301@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42982 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761497AbXJRHqb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:46:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, galak@kernel.crashing.org, greg@kroah.com, hirofumi@mail.parknet.co.jp, nickpiggin@yahoo.com.au, riel@redhat.com, zaitcev@redhat.com, mm-commits@vger.kernel.org


The patch titled
     writeback: remove unnecessary wait in throttle_vm_writeout()
has been removed from the -mm tree.  Its filename was
     writeback-remove-unnecessary-wait-in-throttle_vm_writeout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: writeback: remove unnecessary wait in throttle_vm_writeout()
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

We don't want to introduce pointless delays in throttle_vm_writeout() when
the writeback limits are not yet exceeded, do we?

Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Pete Zaitcev <zaitcev@redhat.com>
Cc: Greg KH <greg@kroah.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN mm/page-writeback.c~writeback-remove-unnecessary-wait-in-throttle_vm_writeout mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-remove-unnecessary-wait-in-throttle_vm_writeout
+++ a/mm/page-writeback.c
@@ -502,16 +502,6 @@ void throttle_vm_writeout(gfp_t gfp_mask
 	long background_thresh;
 	long dirty_thresh;
 
-	if ((gfp_mask & (__GFP_FS|__GFP_IO)) != (__GFP_FS|__GFP_IO)) {
-		/*
-		 * The caller might hold locks which can prevent IO completion
-		 * or progress in the filesystem.  So we cannot just sit here
-		 * waiting for IO to complete.
-		 */
-		congestion_wait(WRITE, HZ/10);
-		return;
-	}
-
         for ( ; ; ) {
 		get_dirty_limits(&background_thresh, &dirty_thresh, NULL, NULL);
 
@@ -525,6 +515,14 @@ void throttle_vm_writeout(gfp_t gfp_mask
 			global_page_state(NR_WRITEBACK) <= dirty_thresh)
                         	break;
                 congestion_wait(WRITE, HZ/10);
+
+		/*
+		 * The caller might hold locks which can prevent IO completion
+		 * or progress in the filesystem.  So we cannot just sit here
+		 * waiting for IO to complete.
+		 */
+		if ((gfp_mask & (__GFP_FS|__GFP_IO)) != (__GFP_FS|__GFP_IO))
+			break;
         }
 }
 
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
