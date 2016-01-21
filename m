From: akpm@linux-foundation.org
Subject: [merged]
 soc-qcom-smd-use-__ioread32_copy-instead-of-open-coding-it.patch removed
 from -mm tree
Date: Thu, 21 Jan 2016 14:58:47 -0800
Message-ID: <56a162a7.4wSpaHCSqBEajm91%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33815 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbcAUW6s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 17:58:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sboyd@codeaurora.org, bjorn.andersson@sonymobile.com, dhowells@redhat.com, hauke@hauke-m.de, paul@pwsan.com, zajec5@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/soc/qcom/smd.c: use __ioread32_copy() instead of open-coding it
has been removed from the -mm tree.  Its filename was
     soc-qcom-smd-use-__ioread32_copy-instead-of-open-coding-it.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stephen Boyd <sboyd@codeaurora.org>
Subject: drivers/soc/qcom/smd.c: use __ioread32_copy() instead of open-coding it

Now that we have a generic library function for this, replace the
open-coded instance.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: <zajec5@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/soc/qcom/smd.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff -puN drivers/soc/qcom/smd.c~soc-qcom-smd-use-__ioread32_copy-instead-of-open-coding-it drivers/soc/qcom/smd.c
--- a/drivers/soc/qcom/smd.c~soc-qcom-smd-use-__ioread32_copy-instead-of-open-coding-it
+++ a/drivers/soc/qcom/smd.c
@@ -434,20 +434,15 @@ static void smd_copy_to_fifo(void __iome
 /*
  * Copy count bytes of data using 32bit accesses, if that is required.
  */
-static void smd_copy_from_fifo(void *_dst,
-			       const void __iomem *_src,
+static void smd_copy_from_fifo(void *dst,
+			       const void __iomem *src,
 			       size_t count,
 			       bool word_aligned)
 {
-	u32 *dst = (u32 *)_dst;
-	u32 *src = (u32 *)_src;
