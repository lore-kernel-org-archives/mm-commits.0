From: akpm@linux-foundation.org
Subject: [patch 16/41] s390: get rid of superfluous __GFP_REPEAT
Date: Fri, 24 Jun 2016 14:49:17 -0700
Message-ID: <576daadd.HcQNOeV/zJdg3y6H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40944 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbcFXVtS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2016 17:49:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com

From: Michal Hocko <mhocko@suse.com>
Subject: s390: get rid of superfluous __GFP_REPEAT

__GFP_REPEAT has a rather weak semantic but since it has been introduced
around 2.6.12 it has been ignored for low order allocations.

page_table_alloc then uses the flag for a single page allocation.  This
means that this flag has never been actually useful here because it has
always been used only for PAGE_ALLOC_COSTLY requests.

Link: http://lkml.kernel.org/r/1464599699-30131-14-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/pgalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/s390/mm/pgalloc.c~s390-get-rid-of-superfluous-__gfp_repeat arch/s390/mm/pgalloc.c
--- a/arch/s390/mm/pgalloc.c~s390-get-rid-of-superfluous-__gfp_repeat
+++ a/arch/s390/mm/pgalloc.c
@@ -169,7 +169,7 @@ unsigned long *page_table_alloc(struct m
 			return table;
 	}
 	/* Allocate a fresh page */
-	page = alloc_page(GFP_KERNEL|__GFP_REPEAT);
+	page = alloc_page(GFP_KERNEL);
 	if (!page)
 		return NULL;
 	if (!pgtable_page_ctor(page)) {
_
