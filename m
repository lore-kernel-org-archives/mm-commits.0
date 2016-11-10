From: akpm@linux-foundation.org
Subject: [patch 05/15] mm/cma.c: check the max limit for cma allocation
Date: Thu, 10 Nov 2016 10:46:16 -0800
Message-ID: <5824c078.1EnuiC4+kqS3xfr3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49294 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755789AbcKJSqS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Nov 2016 13:46:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, shashim@codeaurora.org, catalin.marinas@arm.com, sfr@canb.auug.org.au

From: Shiraz Hashim <shashim@codeaurora.org>
Subject: mm/cma.c: check the max limit for cma allocation

CMA allocation request size is represented by size_t that gets truncated
when same is passed as int to bitmap_find_next_zero_area_off.

We observe that during fuzz testing when cma allocation request is too
high, bitmap_find_next_zero_area_off still returns success due to the
truncation.  This leads to kernel crash, as subsequent code assumes that
requested memory is available.

Fail cma allocation in case the request breaches the corresponding cma
region size.

Link: http://lkml.kernel.org/r/1478189211-3467-1-git-send-email-shashim@codeaurora.org
Signed-off-by: Shiraz Hashim <shashim@codeaurora.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/cma.c~mm-cma-check-the-max-limit-for-cma-allocation mm/cma.c
--- a/mm/cma.c~mm-cma-check-the-max-limit-for-cma-allocation
+++ a/mm/cma.c
@@ -385,6 +385,9 @@ struct page *cma_alloc(struct cma *cma,
 	bitmap_maxno = cma_bitmap_maxno(cma);
 	bitmap_count = cma_bitmap_pages_to_bits(cma, count);
 
+	if (bitmap_count > bitmap_maxno)
+		return NULL;
+
 	for (;;) {
 		mutex_lock(&cma->lock);
 		bitmap_no = bitmap_find_next_zero_area_off(cma->bitmap,
_
