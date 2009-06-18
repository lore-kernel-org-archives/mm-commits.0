From: akpm@linux-foundation.org
Subject: [merged] gru-delete-user-request-for-fetching-chiplet-status.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:49:02 -0700
Message-ID: <200906182249.n5IMn2kM008143@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48889 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758249AbZFRWta (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:49:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru: delete user request for fetching chiplet status
has been removed from the -mm tree.  Its filename was
     gru-delete-user-request-for-fetching-chiplet-status.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru: delete user request for fetching chiplet status
From: Jack Steiner <steiner@sgi.com>

Delete the user request for fetching the status of a GRU chiplet.  This
request has been made obsolete by other changes.  Note: this is not a
change to a user API - there are no compatibility issues with this change.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufile.c |   38 -------------------------------
 drivers/misc/sgi-gru/grulib.h  |    3 --
 2 files changed, 41 deletions(-)

diff -puN drivers/misc/sgi-gru/grufile.c~gru-delete-user-request-for-fetching-chiplet-status drivers/misc/sgi-gru/grufile.c
--- a/drivers/misc/sgi-gru/grufile.c~gru-delete-user-request-for-fetching-chiplet-status
+++ a/drivers/misc/sgi-gru/grufile.c
@@ -183,41 +183,6 @@ static long gru_get_config_info(unsigned
 }
 
 /*
- * Get GRU chiplet status
- */
-static long gru_get_chiplet_status(unsigned long arg)
-{
-	struct gru_state *gru;
-	struct gru_chiplet_info info;
-
-	if (copy_from_user(&info, (void __user *)arg, sizeof(info)))
-		return -EFAULT;
-
-	if (info.node == -1)
-		info.node = numa_node_id();
-	if (info.node >= num_possible_nodes() ||
-			info.chiplet >= GRU_CHIPLETS_PER_HUB ||
-			info.node < 0 || info.chiplet < 0)
-		return -EINVAL;
-
-	info.blade = uv_node_to_blade_id(info.node);
-	gru = get_gru(info.blade, info.chiplet);
-
-	info.total_dsr_bytes = GRU_NUM_DSR_BYTES;
-	info.total_cbr = GRU_NUM_CB;
-	info.total_user_dsr_bytes = GRU_NUM_DSR_BYTES -
-		gru->gs_reserved_dsr_bytes;
-	info.total_user_cbr = GRU_NUM_CB - gru->gs_reserved_cbrs;
-	info.free_user_dsr_bytes = hweight64(gru->gs_dsr_map) *
-			GRU_DSR_AU_BYTES;
-	info.free_user_cbr = hweight64(gru->gs_cbr_map) * GRU_CBR_AU_SIZE;
-
-	if (copy_to_user((void __user *)arg, &info, sizeof(info)))
-		return -EFAULT;
-	return 0;
-}
-
-/*
  * gru_file_unlocked_ioctl
  *
  * Called to update file attributes via IOCTL calls.
@@ -242,9 +207,6 @@ static long gru_file_unlocked_ioctl(stru
 	case GRU_USER_UNLOAD_CONTEXT:
 		err = gru_user_unload_context(arg);
 		break;
-	case GRU_GET_CHIPLET_STATUS:
-		err = gru_get_chiplet_status(arg);
-		break;
 	case GRU_USER_FLUSH_TLB:
 		err = gru_user_flush_tlb(arg);
 		break;
diff -puN drivers/misc/sgi-gru/grulib.h~gru-delete-user-request-for-fetching-chiplet-status drivers/misc/sgi-gru/grulib.h
--- a/drivers/misc/sgi-gru/grulib.h~gru-delete-user-request-for-fetching-chiplet-status
+++ a/drivers/misc/sgi-gru/grulib.h
@@ -44,9 +44,6 @@
 /* For user unload context */
 #define GRU_USER_UNLOAD_CONTEXT		_IOWR(GRU_IOCTL_NUM, 9, void *)
 
-/* For fetching GRU chiplet status */
-#define GRU_GET_CHIPLET_STATUS		_IOWR(GRU_IOCTL_NUM, 10, void *)
