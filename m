From: akpm@linux-foundation.org
Subject: [merged] mm-use-read_once-for-non-scalar-types.patch removed from -mm tree
Date: Thu, 16 Apr 2015 09:52:08 -0700
Message-ID: <552fe8b8.Jfp227BF8pdqDlie%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42720 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820AbbDPQqj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:46:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jason.low2@hp.com, borntraeger@de.ibm.com, dave@stgolabs.net, mhocko@suse.cz, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use READ_ONCE() for non-scalar types
has been removed from the -mm tree.  Its filename was
     mm-use-read_once-for-non-scalar-types.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jason Low <jason.low2@hp.com>
Subject: mm: use READ_ONCE() for non-scalar types

Commit 38c5ce936a08 ("mm/gup: Replace ACCESS_ONCE with READ_ONCE")
converted ACCESS_ONCE usage in gup_pmd_range() to READ_ONCE, since
ACCESS_ONCE doesn't work reliably on non-scalar types.

This patch also fixes the other ACCESS_ONCE usages in gup_pte_range()
and __get_user_pages_fast() in mm/gup.c

Signed-off-by: Jason Low <jason.low2@hp.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Davidlohr Bueso <dave@stgolabs.net>
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/gup.c~mm-use-read_once-for-non-scalar-types mm/gup.c
--- a/mm/gup.c~mm-use-read_once-for-non-scalar-types
+++ a/mm/gup.c
@@ -1019,7 +1019,7 @@ static int gup_pte_range(pmd_t pmd, unsi
 		 *
 		 * for an example see gup_get_pte in arch/x86/mm/gup.c
 		 */
-		pte_t pte = ACCESS_ONCE(*ptep);
+		pte_t pte = READ_ONCE(*ptep);
 		struct page *page;
 
 		/*
@@ -1309,7 +1309,7 @@ int __get_user_pages_fast(unsigned long
 	local_irq_save(flags);
 	pgdp = pgd_offset(mm, addr);
 	do {
-		pgd_t pgd = ACCESS_ONCE(*pgdp);
+		pgd_t pgd = READ_ONCE(*pgdp);
 
 		next = pgd_addr_end(addr, end);
 		if (pgd_none(pgd))
_

Patches currently in -mm which might be from jason.low2@hp.com are

origin.patch

