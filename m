From: akpm@linux-foundation.org
Subject: [merged] scsi-fix-sign-extension-with-15tb-usb-storage-lbd=y.patch removed from -mm tree
Date: Tue, 28 Apr 2009 12:25:38 -0700
Message-ID: <200904281925.n3SJPcdt020934@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43391 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755828AbZD1T2o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Apr 2009 15:28:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@linux.vnet.ibm.com, James.Bottomley@HansenPartnership.com, viro@zeniv.linux.org.uk, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     scsi: fix sign extension with 1.5TB usb-storage LBD=y
has been removed from the -mm tree.  Its filename was
     scsi-fix-sign-extension-with-15tb-usb-storage-lbd=y.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi: fix sign extension with 1.5TB usb-storage LBD=y
From: Dave Hansen <dave@linux.vnet.ibm.com>

Shifting an unsigned char implicitly casts it to a signed int.  This
caused 'lba' to sign-extend and Linux would then try READ CAPACITY 16
which was not supported by at least one drive.  Using the
get_unaligned_be*() helpers keeps us from having to worry about how the
extension might occur.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sd.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff -puN drivers/scsi/sd.c~scsi-fix-sign-extension-with-15tb-usb-storage-lbd=y drivers/scsi/sd.c
--- a/drivers/scsi/sd.c~scsi-fix-sign-extension-with-15tb-usb-storage-lbd=y
+++ a/drivers/scsi/sd.c
@@ -50,6 +50,7 @@
 #include <linux/string_helpers.h>
 #include <linux/async.h>
 #include <asm/uaccess.h>
+#include <asm/unaligned.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -1345,12 +1346,8 @@ static int read_capacity_16(struct scsi_
 		return -EINVAL;
 	}
 
-	sector_size =	(buffer[8] << 24) | (buffer[9] << 16) |
-			(buffer[10] << 8) | buffer[11];
-	lba =  (((u64)buffer[0] << 56) | ((u64)buffer[1] << 48) |
-		((u64)buffer[2] << 40) | ((u64)buffer[3] << 32) |
-		((u64)buffer[4] << 24) | ((u64)buffer[5] << 16) |
-		((u64)buffer[6] << 8) | (u64)buffer[7]);
+	sector_size = get_unaligned_be32(&buffer[8]);
+	lba = get_unaligned_be64(&buffer[0]);
 
 	sd_read_protection_type(sdkp, buffer);
 
@@ -1401,10 +1398,8 @@ static int read_capacity_10(struct scsi_
 		return -EINVAL;
 	}
 
-	sector_size =	(buffer[4] << 24) | (buffer[5] << 16) |
-			(buffer[6] << 8) | buffer[7];
-	lba =	(buffer[0] << 24) | (buffer[1] << 16) |
-		(buffer[2] << 8) | buffer[3];
+	sector_size = get_unaligned_be32(&buffer[4]);
+	lba = get_unaligned_be32(&buffer[0]);
 
 	if ((sizeof(sdkp->capacity) == 4) && (lba == 0xffffffff)) {
 		sd_printk(KERN_ERR, sdkp, "Too big for this kernel. Use a "
_

Patches currently in -mm which might be from dave@linux.vnet.ibm.com are

linux-next.patch
page-allocator-replace-__alloc_pages_internal-with-__alloc_pages_nodemask.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid.patch
page-allocator-check-only-once-if-the-zonelist-is-suitable-for-the-allocation.patch
page-allocator-break-up-the-allocator-entry-point-into-fast-and-slow-paths.patch
page-allocator-move-check-for-disabled-anti-fragmentation-out-of-fastpath.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-calculate-the-migratetype-for-allocation-only-once.patch
page-allocator-calculate-the-alloc_flags-for-allocation-only-once.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
page-allocator-inline-__rmqueue_smallest.patch
page-allocator-inline-buffered_rmqueue.patch
page-allocator-inline-__rmqueue_fallback.patch
page-allocator-do-not-call-get_pageblock_migratetype-more-than-necessary.patch
page-allocator-do-not-disable-interrupts-in-free_page_mlock.patch
page-allocator-do-not-setup-zonelist-cache-when-there-is-only-one-node.patch
page-allocator-do-not-check-for-compound-pages-during-the-page-allocator-sanity-checks.patch
page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark.patch
page-allocator-update-nr_free_pages-only-as-necessary.patch
page-allocator-get-the-pageblock-migratetype-without-disabling-interrupts.patch
page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths.patch
page-allocator-slab-use-nr_online_nodes-to-check-for-a-numa-platform.patch
page-allocator-move-free_page_mlock-to-page_allocc.patch
page-allocator-sanity-check-order-in-the-page-allocator-slow-path.patch

