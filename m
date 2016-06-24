From: akpm@linux-foundation.org
Subject: [patch 13/41] score: get rid of superfluous __GFP_REPEAT
Date: Fri, 24 Jun 2016 14:49:09 -0700
Message-ID: <576daad5.EgCeF9u7n3a7hlOB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40931 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbcFXVtK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2016 17:49:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, lennox.wu@gmail.com, liqin.linux@gmail.com

From: Michal Hocko <mhocko@suse.com>
Subject: score: get rid of superfluous __GFP_REPEAT

__GFP_REPEAT has a rather weak semantic but since it has been introduced
around 2.6.12 it has been ignored for low order allocations.

pte_alloc_one{_kernel} allocate PTE_ORDER which is 0.  This means that
this flag has never been actually useful here because it has always been
used only for PAGE_ALLOC_COSTLY requests.

Link: http://lkml.kernel.org/r/1464599699-30131-11-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Chen Liqin <liqin.linux@gmail.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/score/include/asm/pgalloc.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN arch/score/include/asm/pgalloc.h~score-get-rid-of-superfluous-__gfp_repeat arch/score/include/asm/pgalloc.h
--- a/arch/score/include/asm/pgalloc.h~score-get-rid-of-superfluous-__gfp_repeat
+++ a/arch/score/include/asm/pgalloc.h
@@ -42,8 +42,7 @@ static inline pte_t *pte_alloc_one_kerne
 {
 	pte_t *pte;
 
-	pte = (pte_t *) __get_free_pages(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO,
-					PTE_ORDER);
+	pte = (pte_t *) __get_free_pages(GFP_KERNEL|__GFP_ZERO, PTE_ORDER);
 
 	return pte;
 }
@@ -53,7 +52,7 @@ static inline struct page *pte_alloc_one
 {
 	struct page *pte;
 
-	pte = alloc_pages(GFP_KERNEL | __GFP_REPEAT, PTE_ORDER);
+	pte = alloc_pages(GFP_KERNEL, PTE_ORDER);
 	if (!pte)
 		return NULL;
 	clear_highpage(pte);
_
