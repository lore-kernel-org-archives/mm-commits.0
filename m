From: akpm@linux-foundation.org
Subject: [patch 15/41] sparc: get rid of superfluous __GFP_REPEAT
Date: Fri, 24 Jun 2016 14:49:14 -0700
Message-ID: <576daada.OfqVVk0YYIXmaxKs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40940 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbcFXVtP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2016 17:49:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, davem@davemloft.net

From: Michal Hocko <mhocko@suse.com>
Subject: sparc: get rid of superfluous __GFP_REPEAT

__GFP_REPEAT has a rather weak semantic but since it has been introduced
around 2.6.12 it has been ignored for low order allocations.

{pud,pmd}_alloc_one is using __GFP_REPEAT but it always allocates from
pgtable_cache which is initialzed to PAGE_SIZE objects.  This means that
this flag has never been actually useful here because it has always been
used only for PAGE_ALLOC_COSTLY requests.

Link: http://lkml.kernel.org/r/1464599699-30131-13-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/pgalloc_64.h |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN arch/sparc/include/asm/pgalloc_64.h~sparc-get-rid-of-superfluous-__gfp_repeat arch/sparc/include/asm/pgalloc_64.h
--- a/arch/sparc/include/asm/pgalloc_64.h~sparc-get-rid-of-superfluous-__gfp_repeat
+++ a/arch/sparc/include/asm/pgalloc_64.h
@@ -41,8 +41,7 @@ static inline void __pud_populate(pud_t
 
 static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
-	return kmem_cache_alloc(pgtable_cache,
-				GFP_KERNEL|__GFP_REPEAT);
+	return kmem_cache_alloc(pgtable_cache, GFP_KERNEL);
 }
 
 static inline void pud_free(struct mm_struct *mm, pud_t *pud)
@@ -52,8 +51,7 @@ static inline void pud_free(struct mm_st
 
 static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
-	return kmem_cache_alloc(pgtable_cache,
-				GFP_KERNEL|__GFP_REPEAT);
+	return kmem_cache_alloc(pgtable_cache, GFP_KERNEL);
 }
 
 static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
_
