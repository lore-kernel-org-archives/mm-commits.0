From: akpm@linux-foundation.org
Subject: + mm-use-read_once-for-non-scalar-types.patch added to -mm tree
Date: Tue, 24 Mar 2015 15:45:41 -0700
Message-ID: <5511e915.7Uo38LG8Ayt9ZEUp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38165 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbbCXWpm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Mar 2015 18:45:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jason.low2@hp.com, borntraeger@de.ibm.com, dave@stgolabs.net, mhocko@suse.cz, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use READ_ONCE() for non-scalar types
has been added to the -mm tree.  Its filename is
     mm-use-read_once-for-non-scalar-types.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-read_once-for-non-scalar-types.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-read_once-for-non-scalar-types.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-use-read_once-for-non-scalar-types.patch
mm-remove-rest-of-access_once-usages.patch
linux-next.patch

