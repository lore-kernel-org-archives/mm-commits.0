From: akpm@linux-foundation.org
Subject: - mm-speed-up-writeback-ramp-up-on-clean-systems.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:09:08 -0800
Message-ID: <200711152109.lAFL98P1015420@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56437 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932259AbXKOVRn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:17:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peterz@infradead.org, a.p.zijlstra@chello.nl, wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     mm: speed up writeback ramp-up on clean systems
has been removed from the -mm tree.  Its filename was
     mm-speed-up-writeback-ramp-up-on-clean-systems.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm: speed up writeback ramp-up on clean systems
From: Peter Zijlstra <peterz@infradead.org>

We allow violation of bdi limits if there is a lot of room on the system. 
Once we hit half the total limit we start enforcing bdi limits and bdi
ramp-up should happen.  Doing it this way avoids many small writeouts on an
otherwise idle system and should also speed up the ramp-up.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-by: Fengguang Wu <wfg@mail.ustc.edu.cn> 
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff -puN mm/page-writeback.c~mm-speed-up-writeback-ramp-up-on-clean-systems mm/page-writeback.c
--- a/mm/page-writeback.c~mm-speed-up-writeback-ramp-up-on-clean-systems
+++ a/mm/page-writeback.c
@@ -355,8 +355,8 @@ get_dirty_limits(long *pbackground, long
  */
 static void balance_dirty_pages(struct address_space *mapping)
 {
-	long bdi_nr_reclaimable;
-	long bdi_nr_writeback;
+	long nr_reclaimable, bdi_nr_reclaimable;
+	long nr_writeback, bdi_nr_writeback;
 	long background_thresh;
 	long dirty_thresh;
 	long bdi_thresh;
@@ -376,11 +376,26 @@ static void balance_dirty_pages(struct a
 
 		get_dirty_limits(&background_thresh, &dirty_thresh,
 				&bdi_thresh, bdi);
+
+		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
+					global_page_state(NR_UNSTABLE_NFS);
+		nr_writeback = global_page_state(NR_WRITEBACK);
+
 		bdi_nr_reclaimable = bdi_stat(bdi, BDI_RECLAIMABLE);
 		bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
+
 		if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh)
 			break;
 
+		/*
+		 * Throttle it only when the background writeback cannot
+		 * catch-up. This avoids (excessively) small writeouts
+		 * when the bdi limits are ramping up.
+		 */
+		if (nr_reclaimable + nr_writeback <
+				(background_thresh + dirty_thresh) / 2)
+			break;
+
 		if (!bdi->dirty_exceeded)
 			bdi->dirty_exceeded = 1;
 
_

Patches currently in -mm which might be from peterz@infradead.org are

origin.patch
