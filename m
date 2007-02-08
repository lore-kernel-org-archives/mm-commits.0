From: akpm@linux-foundation.org
Subject: - md-fix-various-bugs-with-aligned-reads-in-raid5-fix.patch removed from -mm tree
Date: Thu, 08 Feb 2007 14:17:24 -0800
Message-ID: <200702082217.l18MHOuo028384@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42273 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423421AbXBHWRj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 17:17:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, epimetreus@fastmail.fm, jens.axboe@oracle.com, neilb@suse.de, org@suse.de, stable@suse.de, mm-commits@vger.kernel.org


The patch titled
     md-fix-various-bugs-with-aligned-reads-in-raid5-fix
has been removed from the -mm tree.  Its filename was
     md-fix-various-bugs-with-aligned-reads-in-raid5-fix.patch

This patch was dropped because it was folded into md-fix-various-bugs-with-aligned-reads-in-raid5.patch

------------------------------------------------------
Subject: md-fix-various-bugs-with-aligned-reads-in-raid5-fix
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: "blk_recount_segments" [drivers/md/raid456.ko] undefined!

Cc: Neil Brown <neilb@suse.de>
Cc: "Kai" <epimetreus@fastmail.fm>
Cc: <stable@suse.de>
Cc: <org@suse.de>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/ll_rw_blk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN block/ll_rw_blk.c~md-fix-various-bugs-with-aligned-reads-in-raid5-fix block/ll_rw_blk.c
--- a/block/ll_rw_blk.c~md-fix-various-bugs-with-aligned-reads-in-raid5-fix
+++ a/block/ll_rw_blk.c
@@ -1264,7 +1264,7 @@ new_hw_segment:
 	bio->bi_hw_segments = nr_hw_segs;
 	bio->bi_flags |= (1 << BIO_SEG_VALID);
 }
-
+EXPORT_SYMBOL(blk_recount_segments);
 
 static int blk_phys_contig_segment(request_queue_t *q, struct bio *bio,
 				   struct bio *nxt)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
md-fix-various-bugs-with-aligned-reads-in-raid5.patch
md-fix-various-bugs-with-aligned-reads-in-raid5-fix.patch
acpi-bay-driver-warning-fix.patch
fix-warning-in-device_add_attrs.patch
git-dvb.patch
kthread-api-conversion-for-dvb_frontend-and-av7110-fix.patch
git-libata-all.patch
sis-warning-fixes.patch
git-libata-all-lib-iomapc-fix-for-config_pci=n.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
git-net.patch
git-sh.patch
git-scsi-misc.patch
git-scsi-misc-fixup.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block.patch
x86_64-survive-having-no-irq-mapping-for-a-vector-fix.patch
git-cryptodev-fixup.patch
mm-vm_insert_pfn-tidy.patch
swiotlb-uninlinings.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
revert-x86_64-mm-putreg-check.patch
fix-utrace-utrace-ptrace-compat.patch
utrace-i386-build-fix.patch
