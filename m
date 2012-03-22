From: akpm@linux-foundation.org
Subject: [merged] thp-allow-a-hwpoisoned-head-page-to-be-put-back-to-lru.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:18:33 -0700
Message-ID: <20120322201833.8FA9BA024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:48025 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759036Ab2CVUSf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:18:35 -0400
Received: by wejx9 with SMTP id x9so134901wej.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:18:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dnelson@redhat.com, aarcange@redhat.com, andi@firstfloor.org, jin.dongming@np.css.fujitsu.com, seto.hidetoshi@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: allow a hwpoisoned head page to be put back to LRU
has been removed from the -mm tree.  Its filename was
     thp-allow-a-hwpoisoned-head-page-to-be-put-back-to-lru.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Dean Nelson <dnelson@redhat.com>
Subject: thp: allow a hwpoisoned head page to be put back to LRU

Andrea Arcangeli pointed out to me that a check in __memory_failure()
which was intended to prevent THP tail pages from being checked for the
absence of the PG_lru flag (something that is always the case), was also
preventing THP head pages from being checked.

A THP head page could actually benefit from the call to shake_page() by
ending up being put back to a LRU, provided it had been waiting in a
pagevec array.

Andrea suggested that the "!PageTransCompound(p)" in the if-statement
should be replaced by a "!PageTransTail(p)", thus allowing THP head pages
to be checked and possibly shaken.

Signed-off-by: Dean Nelson <dnelson@redhat.com>
Cc: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   20 ++++++++++++++++++++
 mm/memory-failure.c        |    2 +-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff -puN include/linux/page-flags.h~thp-allow-a-hwpoisoned-head-page-to-be-put-back-to-lru include/linux/page-flags.h
--- a/include/linux/page-flags.h~thp-allow-a-hwpoisoned-head-page-to-be-put-back-to-lru
+++ a/include/linux/page-flags.h
@@ -414,11 +414,26 @@ static inline int PageTransHuge(struct p
 	return PageHead(page);
 }
 
+/*
+ * PageTransCompound returns true for both transparent huge pages
+ * and hugetlbfs pages, so it should only be called when it's known
+ * that hugetlbfs pages aren't involved.
+ */
 static inline int PageTransCompound(struct page *page)
 {
 	return PageCompound(page);
 }
 
+/*
+ * PageTransTail returns true for both transparent huge pages
+ * and hugetlbfs pages, so it should only be called when it's known
+ * that hugetlbfs pages aren't involved.
+ */
+static inline int PageTransTail(struct page *page)
+{
+	return PageTail(page);
+}
+
 #else
 
 static inline int PageTransHuge(struct page *page)
@@ -430,6 +445,11 @@ static inline int PageTransCompound(stru
 {
 	return 0;
 }
+
+static inline int PageTransTail(struct page *page)
+{
+	return 0;
+}
 #endif
 
 #ifdef CONFIG_MMU
diff -puN mm/memory-failure.c~thp-allow-a-hwpoisoned-head-page-to-be-put-back-to-lru mm/memory-failure.c
--- a/mm/memory-failure.c~thp-allow-a-hwpoisoned-head-page-to-be-put-back-to-lru
+++ a/mm/memory-failure.c
@@ -1063,7 +1063,7 @@ int __memory_failure(unsigned long pfn, 
 	 * The check (unnecessarily) ignores LRU pages being isolated and
 	 * walked by the page reclaim code, however that's not a big loss.
 	 */
-	if (!PageHuge(p) && !PageTransCompound(p)) {
+	if (!PageHuge(p) && !PageTransTail(p)) {
 		if (!PageLRU(p))
 			shake_page(p, 0);
 		if (!PageLRU(p)) {
_

Patches currently in -mm which might be from dnelson@redhat.com are

origin.patch

