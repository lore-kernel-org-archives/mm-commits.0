From: akpm@linux-foundation.org
Subject: - ps3-disk-storage-driver-use-correct-bio-vector-size.patch removed from -mm tree
Date: Sat, 21 Jul 2007 04:34:38 -0700
Message-ID: <200707211134.l6LBYciw014239@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34052 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757466AbXGULfy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 21 Jul 2007 07:35:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, James.Bottomley@steeleye.com, benh@kernel.crashing.org, geoffrey.levand@am.sony.com, jens.axboe@oracle.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     ps3disk: use correct bio vector size
has been removed from the -mm tree.  Its filename was
     ps3-disk-storage-driver-use-correct-bio-vector-size.patch

This patch was dropped because it was folded into ps3-disk-storage-driver.patch

------------------------------------------------------
Subject: ps3disk: use correct bio vector size
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

This fixes the O_DIRECT corruptions, as reported by Olaf Hering (triggered by
e.g.  parted >= 1.8.0).

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Geoff Levand <geoffrey.levand@am.sony.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/ps3disk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/ps3disk.c~ps3-disk-storage-driver-use-correct-bio-vector-size drivers/block/ps3disk.c
--- a/drivers/block/ps3disk.c~ps3-disk-storage-driver-use-correct-bio-vector-size
+++ a/drivers/block/ps3disk.c
@@ -108,7 +108,7 @@ static void ps3disk_scatter_gather(struc
 			__func__, __LINE__, i, bio_segments(bio),
 			bio_sectors(bio), sector);
 		bio_for_each_segment(bvec, bio, j) {
-			size = bio_cur_sectors(bio)*KERNEL_SECTOR_SIZE;
+			size = bvec->bv_len;
 			buf = __bio_kmap_atomic(bio, j, KM_IRQ0);
 			if (gather)
 				memcpy(dev->bounce_buf+offset, buf, size);
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
ps3-disk-storage-driver.patch
ps3-disk-storage-driver-use-correct-bio-vector-size.patch
ps3-disk-storage-driver-updates-after-final-review.patch
ps3-bd-dvd-cd-rom-storage-driver.patch
ps3-bd-dvd-cd-rom-storage-driver-updates-after-final-review.patch
ps3-flash-rom-storage-driver.patch
ps3-flash-rom-storage-driver-updates-after-final-review.patch
ps3fb-enable-vt_hw_console_binding-for-proper-kexec.patch
ps3fb-shrink-default-virtual-frame-buffer-size-from-18-to-9-mib.patch
ps3fb-set-fbinfo_reads_fast-to-speed-up-text-console-scrolling.patch
