Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 850E4C352B3
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A8BE22EBD
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbgLOX7b (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:60878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727847AbgLOXZF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:25:05 -0500
Date:   Tue, 15 Dec 2020 15:22:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074538;
        bh=G6J43/+ykQG/G4Ur9ZDtF/hlwKCBxJC79O/QiKmCcFE=;
        h=From:To:Subject:From;
        b=SAWCvAC3Lz8Xy/SGC05p2or9g0OUZo3GFMfU6CobVtKkSHKaFh6MiW4vuq/cP9TbW
         qduzEuJ1LrA3i6ve8bGQxyJ85jXo6QoS6ZuIPKYNQKuQC1MOW8tsJ8HdRW7lJcdg0T
         fVQTB9oNjuTMXOUgDpeOhTr5+yJr3O3Ya+oDh2Xc=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, qcai@redhat.com, vbabka@suse.cz
Subject:  [merged]
 mmhwpoison-disable-pcplists-before-grabbing-a-refcount.patch removed from
 -mm tree
Message-ID: <20201215232218.JgIUBylch%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: disable pcplists before grabbing a refcount
has been removed from the -mm tree.  Its filename was
     mmhwpoison-disable-pcplists-before-grabbing-a-refcount.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hwpoison: disable pcplists before grabbing a refcount

Currently, we have a sort of retry mechanism to make sure pages in
pcp-lists are spilled to the buddy system, so we can handle those.

We can save us this extra checks with the new disable-pcplist mechanism
that is available with [1].

zone_pcplist_disable makes sure to 1) disable pcplists, so any page that
is freed up from that point onwards will end up in the buddy system and 2)
drain pcplists, so those pages that already in pcplists are spilled to
buddy.

With that, we can make a common entry point for grabbing a refcount from
both soft_offline and memory_failure paths that is guarded by
zone_pcplist_disable/zone_pcplist_enable.

[1] https://patchwork.kernel.org/project/linux-mm/cover/20201111092812.11329-1-vbabka@suse.cz/

Link: https://lkml.kernel.org/r/20201204102558.31607-3-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Qian Cai <qcai@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |  132 ++++++++++++++++++++----------------------
 1 file changed, 65 insertions(+), 67 deletions(-)

--- a/mm/memory-failure.c~mmhwpoison-disable-pcplists-before-grabbing-a-refcount
+++ a/mm/memory-failure.c
@@ -985,26 +985,73 @@ static int __get_hwpoison_page(struct pa
 	return 0;
 }
 
-static int get_hwpoison_page(struct page *p)
+/*
+ * Safely get reference count of an arbitrary page.
+ *
+ * Returns 0 for a free page, 1 for an in-use page,
+ * -EIO for a page-type we cannot handle and -EBUSY if we raced with an
+ * allocation.
+ * We only incremented refcount in case the page was already in-use and it
+ * is a known type we can handle.
+ */
+static int get_any_page(struct page *p, unsigned long flags)
 {
-	int ret;
-	bool drained = false;
+	int ret = 0, pass = 0;
+	bool count_increased = false;
 
-retry:
-	ret = __get_hwpoison_page(p);
-	if (!ret && !is_free_buddy_page(p) && !page_count(p) && !drained) {
-		/*
-		 * The page might be in a pcplist, so try to drain those
-		 * and see if we are lucky.
-		 */
-		drain_all_pages(page_zone(p));
-		drained = true;
-		goto retry;
+	if (flags & MF_COUNT_INCREASED)
+		count_increased = true;
+
+try_again:
+	if (!count_increased && !__get_hwpoison_page(p)) {
+		if (page_count(p)) {
+			/* We raced with an allocation, retry. */
+			if (pass++ < 3)
+				goto try_again;
+			ret = -EBUSY;
+		} else if (!PageHuge(p) && !is_free_buddy_page(p)) {
+			/* We raced with put_page, retry. */
+			if (pass++ < 3)
+				goto try_again;
+			ret = -EIO;
+		}
+	} else {
+		if (PageHuge(p) || PageLRU(p) || __PageMovable(p)) {
+			ret = 1;
+		} else {
+			/*
+			 * A page we cannot handle. Check whether we can turn
+			 * it into something we can handle.
+			 */
+			if (pass++ < 3) {
+				put_page(p);
+				shake_page(p, 1);
+				count_increased = false;
+				goto try_again;
+			}
+			put_page(p);
+			ret = -EIO;
+		}
 	}
 
 	return ret;
 }
 
+static int get_hwpoison_page(struct page *p, unsigned long flags,
+			     enum mf_flags ctxt)
+{
+	int ret;
+
+	zone_pcp_disable(page_zone(p));
+	if (ctxt == MF_SOFT_OFFLINE)
+		ret = get_any_page(p, flags);
+	else
+		ret = __get_hwpoison_page(p);
+	zone_pcp_enable(page_zone(p));
+
+	return ret;
+}
+
 /*
  * Do all that is necessary to remove user space mappings. Unmap
  * the pages and send SIGBUS to the processes if the data was dirty.
@@ -1185,7 +1232,7 @@ static int memory_failure_hugetlb(unsign
 
 	num_poisoned_pages_inc();
 
-	if (!(flags & MF_COUNT_INCREASED) && !get_hwpoison_page(p)) {
+	if (!(flags & MF_COUNT_INCREASED) && !get_hwpoison_page(p, flags, 0)) {
 		/*
 		 * Check "filter hit" and "race with other subpage."
 		 */
@@ -1387,7 +1434,7 @@ try_again:
 	 * In fact it's dangerous to directly bump up page count from 0,
 	 * that may make page_ref_freeze()/page_ref_unfreeze() mismatch.
 	 */
-	if (!(flags & MF_COUNT_INCREASED) && !get_hwpoison_page(p)) {
+	if (!(flags & MF_COUNT_INCREASED) && !get_hwpoison_page(p, flags, 0)) {
 		if (is_free_buddy_page(p)) {
 			if (take_page_off_buddy(p)) {
 				page_ref_inc(p);
@@ -1630,6 +1677,7 @@ int unpoison_memory(unsigned long pfn)
 	struct page *page;
 	struct page *p;
 	int freeit = 0;
+	unsigned long flags = 0;
 	static DEFINE_RATELIMIT_STATE(unpoison_rs, DEFAULT_RATELIMIT_INTERVAL,
 					DEFAULT_RATELIMIT_BURST);
 
@@ -1674,7 +1722,7 @@ int unpoison_memory(unsigned long pfn)
 		return 0;
 	}
 
-	if (!get_hwpoison_page(p)) {
+	if (!get_hwpoison_page(p, flags, 0)) {
 		if (TestClearPageHWPoison(p))
 			num_poisoned_pages_dec();
 		unpoison_pr_info("Unpoison: Software-unpoisoned free page %#lx\n",
@@ -1705,56 +1753,6 @@ int unpoison_memory(unsigned long pfn)
 }
 EXPORT_SYMBOL(unpoison_memory);
 
-/*
- * Safely get reference count of an arbitrary page.
- * Returns 0 for a free page, 1 for an in-use page, -EIO for a page-type we
- * cannot handle and -EBUSY if we raced with an allocation.
- * We only incremented refcount in case the page was already in-use and it is
- * a known type we can handle.
- */
-static int get_any_page(struct page *p, int flags)
-{
-	int ret = 0, pass = 0;
-	bool count_increased = false;
-
-	if (flags & MF_COUNT_INCREASED)
-		count_increased = true;
-
-try_again:
-	if (!count_increased && !get_hwpoison_page(p)) {
-		if (page_count(p)) {
-			/* We raced with an allocation, retry. */
-			if (pass++ < 3)
-				goto try_again;
-			ret = -EBUSY;
-		} else if (!PageHuge(p) && !is_free_buddy_page(p)) {
-			/* We raced with put_page, retry. */
-			if (pass++ < 3)
-				goto try_again;
-			ret = -EIO;
-		}
-	} else {
-		if (PageHuge(p) || PageLRU(p) || __PageMovable(p)) {
-			ret = 1;
-		} else {
-			/*
-			 * A page we cannot handle. Check whether we can turn
-			 * it into something we can handle.
-			 */
-			if (pass++ < 3) {
-				put_page(p);
-				shake_page(p, 1);
-				count_increased = false;
-				goto try_again;
-			}
-			put_page(p);
-			ret = -EIO;
-		}
-	}
-
-	return ret;
-}
-
 static bool isolate_page(struct page *page, struct list_head *pagelist)
 {
 	bool isolated = false;
@@ -1928,7 +1926,7 @@ int soft_offline_page(unsigned long pfn,
 
 retry:
 	get_online_mems();
-	ret = get_any_page(page, flags);
+	ret = get_hwpoison_page(page, flags, MF_SOFT_OFFLINE);
 	put_online_mems();
 
 	if (ret > 0) {
_

Patches currently in -mm which might be from osalvador@suse.de are


