From: akpm@linux-foundation.org
Subject: + mm-cma-check-the-max-limit-for-cma-allocation.patch added to
 -mm tree
Date: Thu, 03 Nov 2016 15:25:40 -0700
Message-ID: <581bb964.lTcgXbE47bDWQeT8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59118 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753620AbcKCWZl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Nov 2016 18:25:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shashim@codeaurora.org, catalin.marinas@arm.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/cma.c: check the max limit for cma allocation
has been added to the -mm tree.  Its filename is
     mm-cma-check-the-max-limit-for-cma-allocation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma-check-the-max-limit-for-cma-allocation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-check-the-max-limit-for-cma-allocation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from shashim@codeaurora.org are

mm-cma-check-the-max-limit-for-cma-allocation.patch

