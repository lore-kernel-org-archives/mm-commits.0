From: akpm@linux-foundation.org
Subject: [patch 12/41] parisc: get rid of superfluous __GFP_REPEAT
Date: Fri, 24 Jun 2016 14:49:06 -0700
Message-ID: <576daad2.zpqu5GGBXDUW2hCr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40928 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbcFXVtH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2016 17:49:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, deller@gmx.de, jejb@parisc-linux.org

From: Michal Hocko <mhocko@suse.com>
Subject: parisc: get rid of superfluous __GFP_REPEAT

__GFP_REPEAT has a rather weak semantic but since it has been introduced
around 2.6.12 it has been ignored for low order allocations.

pmd_alloc_one allocate PMD_ORDER which is 1.  This means that this flag
has never been actually useful here because it has always been used only
for PAGE_ALLOC_COSTLY requests.

Link: http://lkml.kernel.org/r/1464599699-30131-10-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/include/asm/pgalloc.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/parisc/include/asm/pgalloc.h~parisc-get-rid-of-superfluous-__gfp_repeat arch/parisc/include/asm/pgalloc.h
--- a/arch/parisc/include/asm/pgalloc.h~parisc-get-rid-of-superfluous-__gfp_repeat
+++ a/arch/parisc/include/asm/pgalloc.h
@@ -63,8 +63,7 @@ static inline void pgd_populate(struct m
 
 static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
 {
-	pmd_t *pmd = (pmd_t *)__get_free_pages(GFP_KERNEL|__GFP_REPEAT,
-					       PMD_ORDER);
+	pmd_t *pmd = (pmd_t *)__get_free_pages(GFP_KERNEL, PMD_ORDER);
 	if (pmd)
 		memset(pmd, 0, PAGE_SIZE<<PMD_ORDER);
 	return pmd;
_
