From: akpm@linux-foundation.org
Subject: +
 soc-qcom-smd-use-__ioread32_copy-instead-of-open-coding-it.patch added to
 -mm tree
Date: Thu, 19 Nov 2015 12:12:16 -0800
Message-ID: <564e2d20.4D+ILoy/icgzuKup%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48707 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161183AbbKSUMR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Nov 2015 15:12:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sboyd@codeaurora.org, bjorn.andersson@sonymobile.com, dhowells@redhat.com, hauke@hauke-m.de, paul@pwsan.com, zajec5@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/soc/qcom/smd.c: use __ioread32_copy() instead of open-coding it
has been added to the -mm tree.  Its filename is
     soc-qcom-smd-use-__ioread32_copy-instead-of-open-coding-it.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/soc-qcom-smd-use-__ioread32_copy-instead-of-open-coding-it.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/soc-qcom-smd-use-__ioread32_copy-instead-of-open-coding-it.patch

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
