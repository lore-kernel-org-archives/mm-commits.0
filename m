From: akpm@linux-foundation.org
Subject: [patch 040/102] mm: do not use double negation for testing
 page flags
Date: Wed, 03 May 2017 14:53:35 -0700
Message-ID: <20170503215335.SrQimNCb-%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48952 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751074AbdECVyT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:54:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gang.chen.5i5j@gmail.com, hannes@cmpxchg.org, khandual@linux.vnet.ibm.com, kirill@shutemov.name, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, vbabka@suse.cz

From: Minchan Kim <minchan@kernel.org>
Subject: mm: do not use double negation for testing page flags

With the discussion[1], I found it seems there are every PageFlags
functions return bool at this moment so we don't need double negation
any more.  Although it's not a problem to keep it, it makes future
users confused to use double negation for them, too.

Remove such possibility.

[1] https://marc.info/?l=linux-kernel&m=148881578820434

Frankly sepaking, I like every PageFlags to return bool instead of int.
It will make it clear.  AFAIR, Chen Gang had tried it but don't know
why it was not merged at that time.

http://lkml.kernel.org/r/1469336184-1904-1-git-send-email-chengang@emindsoft.com.cn

Link: http://lkml.kernel.org/r/1488868597-32222-1-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
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
