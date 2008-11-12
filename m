From: akpm@linux-foundation.org
Subject: + fb-carminefb-trivial-annotation-packing-color-register.patch added to -mm tree
Date: Tue, 11 Nov 2008 16:36:38 -0800
Message-ID: <200811120036.mAC0acVs016552@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756315AbYKLAhG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Nov 2008 19:37:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, bigeasy@linutronix.de


The patch titled
     fb: carminefb: trivial annotation packing color register
has been added to the -mm tree.  Its filename is
     fb-carminefb-trivial-annotation-packing-color-register.patch

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

linux-next.patch
arm-use-the-new-byteorder-headers.patch
cifs-remove-global_extern-macro.patch
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
ibmpex-add-endian-annotation-to-extract_data-helper.patch
blackfin-remove-__function__-in-video-driver.patch
fb-carminefb-trivial-annotation-packing-color-register.patch
memstick-annotate-endianness-of-attribute-structs.patch

