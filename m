From: akpm@linux-foundation.org
Subject: - i2c-misannotation-in-i2c-pmcmspc.patch removed from -mm tree
Date: Mon, 15 Dec 2008 12:01:58 -0800
Message-ID: <200812152001.mBFK1wr6030614@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752946AbYLOUCl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Dec 2008 15:02:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, Marc_St-Jean@pmc-sierra.com, ben-linux@fluff.org, mm-commits@vger.kernel.org


The patch titled
     i2c: misannotation in i2c-pmcmsp.c
has been removed from the -mm tree.  Its filename was
     i2c-misannotation-in-i2c-pmcmspc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: i2c: misannotation in i2c-pmcmsp.c
From: Harvey Harrison <harvey.harrison@gmail.com>

tmp is used as host-endian and is loaded from a be64, fix the cast and the
endian accessor used.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/i2c-pmcmsp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/i2c/busses/i2c-pmcmsp.c~i2c-misannotation-in-i2c-pmcmspc drivers/i2c/busses/i2c-pmcmsp.c
--- a/drivers/i2c/busses/i2c-pmcmsp.c~i2c-misannotation-in-i2c-pmcmspc
+++ a/drivers/i2c/busses/i2c-pmcmsp.c
@@ -486,7 +486,7 @@ static enum pmcmsptwi_xfer_result pmcmsp
 
 	if (cmd->type == MSP_TWI_CMD_WRITE ||
 	    cmd->type == MSP_TWI_CMD_WRITE_READ) {
-		__be64 tmp = cpu_to_be64p((u64 *)cmd->write_data);
+		u64 tmp = be64_to_cpup((__be64 *)cmd->write_data);
 		tmp >>= (MSP_MAX_BYTES_PER_RW - cmd->write_len) * 8;
 		dev_dbg(&pmcmsptwi_adapter.dev, "Writing 0x%016llx\n", tmp);
 		pmcmsptwi_writel(tmp & 0x00000000ffffffffLL,
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
arm-use-the-new-byteorder-headers.patch
ia64-use-the-new-byteorder-headers.patch
input-ads7846c-sparse-lock-annotation.patch
input-strict_strtoul-takes-unsigned-long.patch
m32r-use-the-new-byteorder-headers.patch
blackfin-use-the-new-byteorder-headers.patch
scsi-replace-__inline-with-inline.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
frv-use-the-new-byteorder-headers.patch
m68knommu-use-the-new-byteorder-headers.patch
h8300-use-the-new-byteorder-headers.patch
alpha-use-the-new-byteorder-headers.patch
lib-fix-sparse-shadowed-variable-warning.patch
lib-radix_treec-make-percpu-variable-static.patch
lib-proportionsc-trivial-sparse-lock-annotation.patch
ibmpex-add-endian-annotation-to-extract_data-helper.patch
blackfin-remove-__function__-in-video-driver.patch
fb-carminefb-trivial-annotation-packing-color-register.patch
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

