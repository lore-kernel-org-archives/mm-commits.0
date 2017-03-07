From: akpm@linux-foundation.org
Subject: + mm-do-not-use-double-negation-for-testing-page-flags.patch
 added to -mm tree
Date: Tue, 07 Mar 2017 15:39:46 -0800
Message-ID: <58bf44c2.huzjPCxokfcGlwNb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47462 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755985AbdCGXlK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Mar 2017 18:41:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, gang.chen.5i5j@gmail.com, hannes@cmpxchg.org, khandual@linux.vnet.ibm.com, kirill@shutemov.name, mhocko@suse.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: do not use double negation for testing page flags
has been added to the -mm tree.  Its filename is
     mm-do-not-use-double-negation-for-testing-page-flags.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-do-not-use-double-negation-for-testing-page-flags.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-do-not-use-double-negation-for-testing-page-flags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: do not use double negation for testing page flags

With the discussion[1], I found it seems there are every PageFlags
functions return bool at this moment so we don't need double
negation any more.
Although it's not a problem to keep it, it makes future users
confused to use dobule negation for them, too.

Remove such possibility.

[1] https://marc.info/?l=linux-kernel&m=148881578820434

Frankly sepaking, I like every PageFlags return bool instead of int.
It will make it clear. AFAIR, Chen Gang had tried it but don't know
why it was not merged at that time.

http://lkml.kernel.org/r/1469336184-1904-1-git-send-email-chengang@emindsoft.com.cn

Link: http://lkml.kernel.org/r/1488868597-32222-1-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/khugepaged.c~mm-do-not-use-double-negation-for-testing-page-flags mm/khugepaged.c
--- a/mm/khugepaged.c~mm-do-not-use-double-negation-for-testing-page-flags
+++ a/mm/khugepaged.c
@@ -548,7 +548,7 @@ static int __collapse_huge_page_isolate(
 		 * The page must only be referenced by the scanned process
 		 * and page swap cache.
 		 */
-		if (page_count(page) != 1 + !!PageSwapCache(page)) {
+		if (page_count(page) != 1 + PageSwapCache(page)) {
 			unlock_page(page);
 			result = SCAN_PAGE_COUNT;
 			goto out;
@@ -1181,7 +1181,7 @@ static int khugepaged_scan_pmd(struct mm
 		 * The page must only be referenced by the scanned process
 		 * and page swap cache.
 		 */
-		if (page_count(page) != 1 + !!PageSwapCache(page)) {
+		if (page_count(page) != 1 + PageSwapCache(page)) {
 			result = SCAN_PAGE_COUNT;
 			goto out_unmap;
 		}
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-reclaim-madv_free-pages-fix.patch
mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one.patch
mm-do-not-use-double-negation-for-testing-page-flags.patch

