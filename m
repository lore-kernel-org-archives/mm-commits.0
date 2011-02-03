From: akpm@linux-foundation.org
Subject: [merged] thp-fix-unsuitable-behavior-for-hwpoisoned-tail-page.patch removed from -mm tree
Date: Thu, 03 Feb 2011 11:46:19 -0800
Message-ID: <201102031946.p13JkJZD020999@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34040 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756453Ab1BCTqe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2011 14:46:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jin.dongming@np.css.fujitsu.com, aarcange@redhat.com, andi@firstfloor.org, seto.hidetoshi@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     thp: fix unsuitable behavior for hwpoisoned tail page
has been removed from the -mm tree.  Its filename was
     thp-fix-unsuitable-behavior-for-hwpoisoned-tail-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: fix unsuitable behavior for hwpoisoned tail page
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>

When a tail page of THP is poisoned, memory-failure will do nothing except
setting PG_hwpoison, while the expected behavior is that the process, who
is using the poisoned tail page, should be killed.

The above problem is caused by lru check of the poisoned tail page of THP.
Because PG_lru flag is only set on the head page of THP, the check always
consider the poisoned tail page as NON lru page.

So the lru check for the tail page of THP should be avoided, as like as
hugetlb.

This patch adds !PageTransCompound() before lru check for THP, because of
the check (!PageHuge() && !PageTransCompound()) the whole branch could be
optimized away at build time when both hugetlbfs and THP are set with "N"
(or in archs not supporting either of those).

[akpm@linux-foundation.org: fix unrelated typo in shake_page() comment]
Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff -puN mm/memory-failure.c~thp-fix-unsuitable-behavior-for-hwpoisoned-tail-page mm/memory-failure.c
--- a/mm/memory-failure.c~thp-fix-unsuitable-behavior-for-hwpoisoned-tail-page
+++ a/mm/memory-failure.c
@@ -233,8 +233,8 @@ void shake_page(struct page *p, int acce
 	}
 
 	/*
-	 * Only all shrink_slab here (which would also
-	 * shrink other caches) if access is not potentially fatal.
+	 * Only call shrink_slab here (which would also shrink other caches) if
+	 * access is not potentially fatal.
 	 */
 	if (access) {
 		int nr;
@@ -1065,19 +1065,22 @@ int __memory_failure(unsigned long pfn, 
 	 * The check (unnecessarily) ignores LRU pages being isolated and
 	 * walked by the page reclaim code, however that's not a big loss.
 	 */
-	if (!PageLRU(p) && !PageHuge(p))
-		shake_page(p, 0);
-	if (!PageLRU(p) && !PageHuge(p)) {
-		/*
-		 * shake_page could have turned it free.
-		 */
-		if (is_free_buddy_page(p)) {
-			action_result(pfn, "free buddy, 2nd try", DELAYED);
-			return 0;
+	if (!PageHuge(p) && !PageTransCompound(p)) {
+		if (!PageLRU(p))
+			shake_page(p, 0);
+		if (!PageLRU(p)) {
+			/*
+			 * shake_page could have turned it free.
+			 */
+			if (is_free_buddy_page(p)) {
+				action_result(pfn, "free buddy, 2nd try",
+						DELAYED);
+				return 0;
+			}
+			action_result(pfn, "non LRU", IGNORED);
+			put_page(p);
+			return -EBUSY;
 		}
-		action_result(pfn, "non LRU", IGNORED);
-		put_page(p);
-		return -EBUSY;
 	}
 
 	/*
_

Patches currently in -mm which might be from jin.dongming@np.css.fujitsu.com are

origin.patch

