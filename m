From: akpm@linux-foundation.org
Subject: [merged] usb-use-kzfree.patch removed from -mm tree
Date: Thu, 12 Mar 2009 13:16:50 -0700
Message-ID: <200903122016.n2CKGoEM032591@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47948 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750813AbZCLUS7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Mar 2009 16:18:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, gregkh@suse.de, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     usb: use kzfree()
has been removed from the -mm tree.  Its filename was
     usb-use-kzfree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: use kzfree()
From: Johannes Weiner <hannes@cmpxchg.org>

Use kzfree() instead of memset() + kfree().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/hwa-hc.c   |    3 +--
 drivers/usb/wusbcore/cbaf.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/usb/host/hwa-hc.c~usb-use-kzfree drivers/usb/host/hwa-hc.c
--- a/drivers/usb/host/hwa-hc.c~usb-use-kzfree
+++ a/drivers/usb/host/hwa-hc.c
@@ -464,8 +464,7 @@ static int __hwahc_dev_set_key(struct wu
 			port_idx << 8 | iface_no,
 			keyd, keyd_len, 1000 /* FIXME: arbitrary */);
 
-	memset(keyd, 0, sizeof(*keyd));	/* clear keys etc. */
-	kfree(keyd);
+	kzfree(keyd); /* clear keys etc. */
 	return result;
 }
 
diff -puN drivers/usb/wusbcore/cbaf.c~usb-use-kzfree drivers/usb/wusbcore/cbaf.c
--- a/drivers/usb/wusbcore/cbaf.c~usb-use-kzfree
+++ a/drivers/usb/wusbcore/cbaf.c
@@ -638,8 +638,7 @@ static void cbaf_disconnect(struct usb_i
 	usb_put_intf(iface);
 	kfree(cbaf->buffer);
 	/* paranoia: clean up crypto keys */
-	memset(cbaf, 0, sizeof(*cbaf));
-	kfree(cbaf);
+	kzfree(cbaf);
 }
 
 static struct usb_device_id cbaf_id_table[] = {
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

linux-next.patch
cifs-use-kzfree.patch
s390-use-kzfree.patch
crypto-use-kzfree.patch
nommu-ramfs-pages-allocated-to-an-inodes-pagecache-may-get-wrongly-discarded.patch
nommu-ramfs-pages-allocated-to-an-inodes-pagecache-may-get-wrongly-discarded-fix.patch
nommu-ramfs-dont-leak-pages-when-adding-to-page-cache-fails.patch
vmscan-rename-scmay_swap-to-may_unmap.patch
mm-introduce-for_each_populated_zone-macro.patch
mm-introduce-for_each_populated_zone-macro-cleanup.patch
mm-shrink_all_memory-use-scnr_reclaimed.patch
mm-shrink_all_memory-use-scnr_reclaimed-checkpatch-fixes.patch
vmscan-clip-swap_cluster_max-in-shrink_all_memory.patch
vmscan-respect-higher-order-in-zone_reclaim.patch
mm-move-pagevec-stripping-to-save-unlock-relock.patch
mm-dont-free-swap-slots-on-page-deactivation.patch
mm-remove-pagevec_swap_free.patch
ecryptfs-use-kzfree.patch
memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch

