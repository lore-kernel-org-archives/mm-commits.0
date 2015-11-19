From: akpm@linux-foundation.org
Subject: +
 firmware-bcm47xx_nvram-use-__ioread32_copy-instead-of-open-coding.patch
 added to -mm tree
Date: Thu, 19 Nov 2015 12:12:18 -0800
Message-ID: <564e2d22.7Jo927LMZag5PRfU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48712 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161183AbbKSUMT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Nov 2015 15:12:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sboyd@codeaurora.org, bjorn.andersson@sonymobile.com, dhowells@redhat.com, hauke@hauke-m.de, paul@pwsan.com, zajec5@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/firmware/broadcom/bcm47xx_nvram.c: use __ioread32_copy() instead of open-coding
has been added to the -mm tree.  Its filename is
     firmware-bcm47xx_nvram-use-__ioread32_copy-instead-of-open-coding.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/firmware-bcm47xx_nvram-use-__ioread32_copy-instead-of-open-coding.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/firmware-bcm47xx_nvram-use-__ioread32_copy-instead-of-open-coding.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Boyd <sboyd@codeaurora.org>
Subject: drivers/firmware/broadcom/bcm47xx_nvram.c: use __ioread32_copy() instead of open-coding

Now that we have a generic library function for this, replace the
open-coded instance.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Cc: <zajec5@gmail.com>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/broadcom/bcm47xx_nvram.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff -puN drivers/firmware/broadcom/bcm47xx_nvram.c~firmware-bcm47xx_nvram-use-__ioread32_copy-instead-of-open-coding drivers/firmware/broadcom/bcm47xx_nvram.c
--- a/drivers/firmware/broadcom/bcm47xx_nvram.c~firmware-bcm47xx_nvram-use-__ioread32_copy-instead-of-open-coding
+++ a/drivers/firmware/broadcom/bcm47xx_nvram.c
@@ -56,9 +56,7 @@ static u32 find_nvram_size(void __iomem
 static int nvram_find_and_copy(void __iomem *iobase, u32 lim)
 {
 	struct nvram_header __iomem *header;
-	int i;
 	u32 off;
-	u32 *src, *dst;
 	u32 size;
 
 	if (nvram_len) {
@@ -95,10 +93,7 @@ static int nvram_find_and_copy(void __io
 	return -ENXIO;
 
 found:
-	src = (u32 *)header;
-	dst = (u32 *)nvram_buf;
-	for (i = 0; i < sizeof(struct nvram_header); i += 4)
-		*dst++ = __raw_readl(src++);
+	__ioread32_copy(nvram_buf, header, sizeof(*header) / 4);
 	header = (struct nvram_header *)nvram_buf;
 	nvram_len = header->len;
 	if (nvram_len > size) {
@@ -111,8 +106,8 @@ found:
 		nvram_len = NVRAM_SPACE - 1;
 	}
 	/* proceed reading data after header */
-	for (; i < nvram_len; i += 4)
-		*dst++ = readl(src++);
+	__ioread32_copy(nvram_buf + sizeof(*header), header + 1,
+			DIV_ROUND_UP(nvram_len, 4));
 	nvram_buf[NVRAM_SPACE - 1] = '\0';
 
 	return 0;
_

Patches currently in -mm which might be from sboyd@codeaurora.org are

frv-io-accept-const-void-pointers-for-readbwl.patch
lib-iomap_copy-add-__ioread32_copy.patch
soc-qcom-smd-use-__ioread32_copy-instead-of-open-coding-it.patch
firmware-bcm47xx_nvram-use-__ioread32_copy-instead-of-open-coding.patch

