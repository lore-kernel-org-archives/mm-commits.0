From: akpm@linux-foundation.org
Subject: + gru-delete-user-request-for-fetching-chiplet-status.patch added to -mm tree
Date: Mon, 08 Jun 2009 16:11:22 -0700
Message-ID: <200906082311.n58NBNDP031060@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43759 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756049AbZFHXL0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jun 2009 19:11:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com


The patch titled
     gru: delete user request for fetching chiplet status
has been added to the -mm tree.  Its filename is
     gru-delete-user-request-for-fetching-chiplet-status.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
-
 /* For dumpping GRU chiplet state */
 #define GRU_DUMP_CHIPLET_STATE		_IOWR(GRU_IOCTL_NUM, 11, void *)
 
_

Patches currently in -mm which might be from steiner@sgi.com are

linux-next.patch
page-allocator-clear-n_high_memory-map-before-se-set-it-again.patch
gru-bug-fixes-for-gru-exception-handling.patch
gru-dump-chiplet-state.patch
gru-dump-chiplet-state-update.patch
gru-dynamic-allocation-of-kernel-contexts.patch
gru-dynamic-allocation-of-kernel-contexts-update.patch
gru-change-context-load-and-unload.patch
gru-support-cch_allocate-for-kernel-threads.patch
gru-change-resource-assignment-for-kernel-threads.patch
gru-support-contexts-with-zero-dsrs-or-cbrs.patch
gru-fix-handling-of-mesq-failures.patch
gru-check-context-state-on-reload.patch
gru-support-instruction-completion-interrupts.patch
gru-support-for-asynchronous-gru-instructions.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
gru-update-gru-kernel-self-tests.patch
gru-update-gru-kernel-self-tests-fix.patch
gru-update-to-rev-09-of-gru-spec.patch
gru-fix-cache-coherency-issues-with-instruction-retry.patch
gru-add-user-request-to-explicitly-unload-a-gru-context.patch
gru-fix-automatic-retry-of-gru-instruction-failures.patch
gru-collect-per-context-user-statistics.patch
gru-delete-user-request-for-fetching-chiplet-status.patch
gru-cleanup-gru-inline-functions.patch
gru-generic-infrastructure-for-context-options.patch
gru-add-user-request-to-specify-gru-slice.patch
gru-fix-potential-use-after-free-when-purging-gru-tlbs.patch
gru-fixes-to-grudump-utility.patch
gru-remove-references-to-the-obsolete-global-status-handle.patch
gru-copyright-fixes.patch

