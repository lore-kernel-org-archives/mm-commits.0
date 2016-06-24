From: akpm@linux-foundation.org
Subject: [patch 09/41] arc: get rid of superfluous __GFP_REPEAT
Date: Fri, 24 Jun 2016 14:48:58 -0700
Message-ID: <576daaca.QrrPxRZRdclSNHif%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40911 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbcFXVtE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2016 17:49:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, vgupta@synopsys.com

From: Michal Hocko <mhocko@suse.com>
Subject: arc: get rid of superfluous __GFP_REPEAT

__GFP_REPEAT has a rather weak semantic but since it has been introduced
around 2.6.12 it has been ignored for low order allocations.

pte_alloc_one_kernel uses __get_order_pte but this is obviously always
zero because BITS_FOR_PTE is not larger than 9 yet the page size is always
larger than 4K.  This means that this flag has never been actually useful
here because it has always been used only for PAGE_ALLOC_COSTLY requests.

Link: http://lkml.kernel.org/r/1464599699-30131-7-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/include/asm/pgalloc.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/arc/include/asm/pgalloc.h~arc-get-rid-of-superfluous-__gfp_repeat arch/arc/include/asm/pgalloc.h
--- a/arch/arc/include/asm/pgalloc.h~arc-get-rid-of-superfluous-__gfp_repeat
+++ a/arch/arc/include/asm/pgalloc.h
@@ -95,7 +95,7 @@ static inline pte_t *pte_alloc_one_kerne
 {
 	pte_t *pte;
 
-	pte = (pte_t *) __get_free_pages(GFP_KERNEL | __GFP_REPEAT | __GFP_ZERO,
+	pte = (pte_t *) __get_free_pages(GFP_KERNEL | __GFP_ZERO,
 					 __get_order_pte());
 
 	return pte;
@@ -107,7 +107,7 @@ pte_alloc_one(struct mm_struct *mm, unsi
 	pgtable_t pte_pg;
 	struct page *page;
 
-	pte_pg = (pgtable_t)__get_free_pages(GFP_KERNEL | __GFP_REPEAT, __get_order_pte());
+	pte_pg = (pgtable_t)__get_free_pages(GFP_KERNEL, __get_order_pte());
 	if (!pte_pg)
 		return 0;
 	memzero((void *)pte_pg, PTRS_PER_PTE * sizeof(pte_t));
_
