From: akpm@linux-foundation.org
Subject: + thp-allow-a-hwpoisoned-head-page-to-be-put-back-to-lru.patch added to -mm tree
Date: Mon, 27 Feb 2012 15:47:55 -0800
Message-ID: <20120227234755.9E00BA011D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:64356 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754851Ab2B0Xr6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Feb 2012 18:47:58 -0500
Received: by laai8 with SMTP id i8so58651laa.1
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2012 15:47:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dnelson@redhat.com, aarcange@redhat.com, andi@firstfloor.org, jin.dongming@np.css.fujitsu.com, seto.hidetoshi@jp.fujitsu.com


The patch titled
     Subject: thp: allow a hwpoisoned head page to be put back to LRU
has been added to the -mm tree.  Its filename is
     thp-allow-a-hwpoisoned-head-page-to-be-put-back-to-lru.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -415,11 +415,26 @@ static inline int PageTransHuge(struct p
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
@@ -431,6 +446,11 @@ static inline int PageTransCompound(stru
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
@@ -1089,7 +1089,7 @@ int memory_failure(unsigned long pfn, in
 	 * The check (unnecessarily) ignores LRU pages being isolated and
 	 * walked by the page reclaim code, however that's not a big loss.
 	 */
-	if (!PageHuge(p) && !PageTransCompound(p)) {
+	if (!PageHuge(p) && !PageTransTail(p)) {
 		if (!PageLRU(p))
 			shake_page(p, 0);
 		if (!PageLRU(p)) {
_
Subject: Subject: thp: allow a hwpoisoned head page to be put back to LRU

Patches currently in -mm which might be from dnelson@redhat.com are

thp-allow-a-hwpoisoned-head-page-to-be-put-back-to-lru.patch

