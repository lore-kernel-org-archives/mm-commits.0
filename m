From: akpm@linux-foundation.org
Subject: [patch 4/7] mm: thp: broken page count after commit aa88b68c
Date: Wed, 08 Jun 2016 15:33:50 -0700
Message-ID: <57589d4e.LcL9Qjzs1+pi9a+U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37708 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161279AbcFHWdw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jun 2016 18:33:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, gerald.schaefer@de.ibm.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, borntraeger@de.ibm.com, dave.hansen@intel.com, hannes@cmpxchg.org, heiko.carstens@de.ibm.com, hughd@google.com, kirill@shutemov.name, mgorman@techsingularity.net, schwidefsky@de.ibm.com, stable@vger.kernel.org, vbabka@suse.cz

From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: mm: thp: broken page count after commit aa88b68c

Christian Borntraeger reported a kernel panic after corrupt page counts,
and it turned out to be a regression introduced with commit aa88b68c
("thp: keep huge zero page pinned until tlb flush"), at least on s390.

put_huge_zero_page() was moved over from zap_huge_pmd() to
release_pages(), and it was replaced by tlb_remove_page().  However,
release_pages() might not always be triggered by (the arch-specific)
tlb_remove_page().

On s390 we call free_page_and_swap_cache() from tlb_remove_page(), and not
tlb_flush_mmu() -> free_pages_and_swap_cache() like the generic version,
because we don't use the MMU-gather logic.  Although both functions have
very similar names, they are doing very unsimilar things, in particular
free_page_xxx is just doing a put_page(), while free_pages_xxx calls
release_pages().

This of course results in very harmful put_page()s on the huge zero page,
on architectures where tlb_remove_page() is implemented in this way.  It
seems to affect only s390 and sh, but sh doesn't have THP support, so the
problem (currently) probably only exists on s390.

The following quick hack fixed the issue:

Link: http://lkml.kernel.org/r/20160602172141.75c006a9@thinkpad
Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: <stable@vger.kernel.org>	[4.6.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/swap_state.c~thp-broken-page-count-after-commit-aa88b68c mm/swap_state.c
--- a/mm/swap_state.c~thp-broken-page-count-after-commit-aa88b68c
+++ a/mm/swap_state.c
@@ -252,7 +252,10 @@ static inline void free_swap_cache(struc
 void free_page_and_swap_cache(struct page *page)
 {
 	free_swap_cache(page);
-	put_page(page);
+	if (is_huge_zero_page(page))
+		put_huge_zero_page();
+	else
+		put_page(page);
 }
 
 /*
_
