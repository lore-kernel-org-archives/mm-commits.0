From: akpm@linux-foundation.org
Subject: + input-strict_strtoul-takes-unsigned-long.patch added to -mm tree
Date: Tue, 02 Dec 2008 23:14:55 -0800
Message-ID: <200812030714.mB37EtLK007090@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57114 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753039AbYLCHP3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2008 02:15:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, dtor@mail.ru


The patch titled
     input: strict_strtoul takes unsigned long
has been added to the -mm tree.  Its filename is
     input-strict_strtoul-takes-unsigned-long.patch

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
Subject: input: strict_strtoul takes unsigned long
From: Harvey Harrison <harvey.harrison@gmail.com>

Fix sparse warning introduced by: commit
160f1fef7e52e974489b3c70fbd4e094c06965c2 Input: convert drivers to use
strict_strtoul()

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/ads7846.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/input/touchscreen/ads7846.c~input-strict_strtoul-takes-unsigned-long drivers/input/touchscreen/ads7846.c
--- a/drivers/input/touchscreen/ads7846.c~input-strict_strtoul-takes-unsigned-long
+++ a/drivers/input/touchscreen/ads7846.c
@@ -472,7 +472,7 @@ static ssize_t ads7846_disable_store(str
 				     const char *buf, size_t count)
 {
 	struct ads7846 *ts = dev_get_drvdata(dev);
-	long i;
+	unsigned long i;
 
 	if (strict_strtoul(buf, 10, &i))
 		return -EINVAL;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

linux-next.patch
arm-use-the-new-byteorder-headers.patch
i2c-misannotation-in-i2c-pmcmspc.patch
i2c-trivial-endian-casting-fixes-in-i2c-highlanderc.patch
ia64-use-the-new-byteorder-headers.patch
input-ads7846c-sparse-lock-annotation.patch
input-strict_strtoul-takes-unsigned-long.patch
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
byteorder-add-load_-store_endian-api.patch
unaligned-consolidate-unaligned-headers-add-load_-store_endian_noalign.patch
unaligned-wire-up-trivial-arches-for-new-common-unaligned-header.patch
sh-wire-up-arch-overrides-for-unaligned-access-on-the-sh4a.patch
unaligned-wire-up-h8300-and-m32r-arches.patch
unaligned-wire-up-arm-arch-overrides-for-unaligned-access.patch
unaligned-remove-the-old-implementation.patch

