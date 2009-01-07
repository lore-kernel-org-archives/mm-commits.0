From: akpm@linux-foundation.org
Subject: - fb-carminefb-trivial-annotation-packing-color-register.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:19:42 -0800
Message-ID: <200901072219.n07MJgF7019014@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56943 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763192AbZAGWgS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:36:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, bigeasy@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     fb: carminefb: trivial annotation packing color register
has been removed from the -mm tree.  Its filename was
     fb-carminefb-trivial-annotation-packing-color-register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fb: carminefb: trivial annotation packing color register
From: Harvey Harrison <harvey.harrison@gmail.com>

drivers/video/carminefb.c:171:41: warning: cast to restricted __be32

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Sebastian Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/carminefb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/carminefb.c~fb-carminefb-trivial-annotation-packing-color-register drivers/video/carminefb.c
--- a/drivers/video/carminefb.c~fb-carminefb-trivial-annotation-packing-color-register
+++ a/drivers/video/carminefb.c
@@ -168,7 +168,7 @@ static int carmine_setcolreg(unsigned re
 	blue >>= 8;
 	transp >>= 8;
 
-	((u32 *)info->pseudo_palette)[regno] = be32_to_cpu(transp << 24 |
+	((__be32 *)info->pseudo_palette)[regno] = cpu_to_be32(transp << 24 |
 		red << 0 | green << 8 | blue << 16);
 	return 0;
 }
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
input-ads7846c-sparse-lock-annotation.patch
scsi-replace-__inline-with-inline.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
memstick-annotate-endianness-of-attribute-structs.patch
byteorder-add-load_-store_endian-api.patch
unaligned-consolidate-unaligned-headers-add-load_-store_endian_noalign.patch
unaligned-wire-up-trivial-arches-for-new-common-unaligned-header.patch
sh-wire-up-arch-overrides-for-unaligned-access-on-the-sh4a.patch
unaligned-wire-up-h8300-and-m32r-arches.patch
unaligned-wire-up-arm-arch-overrides-for-unaligned-access.patch
unaligned-remove-the-old-implementation.patch
ata-replace-byteshifting-with-unaligned-endian-helpers.patch
usb-use-unaligned-endian-helpers-in-storage-drivers.patch

