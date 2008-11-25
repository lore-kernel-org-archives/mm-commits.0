From: akpm@linux-foundation.org
Subject: + i2c-misannotation-in-i2c-pmcmspc.patch added to -mm tree
Date: Tue, 25 Nov 2008 14:54:06 -0800
Message-ID: <200811252254.mAPMs6rB026243@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39556 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752240AbYKYWyf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Nov 2008 17:54:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     i2c: misannotation in i2c-pmcmsp.c
has been added to the -mm tree.  Its filename is
     i2c-misannotation-in-i2c-pmcmspc.patch

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

linux-next.patch
arm-use-the-new-byteorder-headers.patch
i2c-misannotation-in-i2c-pmcmspc.patch
i2c-trivial-endian-casting-fixes-in-i2c-highlanderc.patch
ia64-use-the-new-byteorder-headers.patch
input-ads7846c-sparse-lock-annotation.patch
m32r-use-the-new-byteorder-headers.patch
blackfin-remove-__function__-in-new-serial-driver.patch
blackfin-use-the-new-byteorder-headers.patch
parisc-use-the-new-byteorder-headers.patch
s390-use-the-new-byteorder-headers.patch
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
unaligned-introduce-common-header.patch
unaligned-introduce-common-header-fix.patch
unaligned-introduce-common-header-fix-2.patch
unaligned-convert-arches-where-unaligned-access-is-ok.patch
unaligned-use-generic-implementation-on-packed-struct-arches.patch
unaligned-remove-packed-struct-and-unaligned-access_ok-headers.patch
unaligned-pack-the-struct-not-the-struct-members.patch
unaligned-move-arm-m32r-h8300-to-the-asm-generic-version.patch
unaligned-remove-last-bits-of-the-unaligned-access-helpers.patch

