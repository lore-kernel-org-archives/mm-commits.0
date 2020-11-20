Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDDDFC6379F
	for <mm-commits@archiver.kernel.org>; Fri, 20 Nov 2020 23:59:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A137B24137
	for <mm-commits@archiver.kernel.org>; Fri, 20 Nov 2020 23:59:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cwZfb6lN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbgKTX7H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Nov 2020 18:59:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:54494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726587AbgKTX7G (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 20 Nov 2020 18:59:06 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E382B22470;
        Fri, 20 Nov 2020 23:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1605916746;
        bh=rwfBwFgOAqAuXecgLT6TUPPOT1S6bPM8P959MWb6dFo=;
        h=Date:From:To:Subject:From;
        b=cwZfb6lNkVnXr5Kakd38ftrS+hthnojrJ7RZ0JKPoHkUNfTxcgg4whYSCCn2o/HE9
         MAYToPN2bM6h62pVK0ED5i3sYO3dzV9CePmR+5X964WT8Zuhuqs9L+Pb85xNZnUczN
         28MNHKy/DusswcPRa3M2jL7iPPf+qPwAAWI0iGxE=
Date:   Fri, 20 Nov 2020 15:59:05 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de
Subject:  +
 mmhwpoison-disable-pcplists-before-grabbing-a-refcount.patch added to -mm
 tree
Message-ID: <20201120235905.HdFTTONiw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: disable pcplists before grabbing a refcount
has been added to the -mm tree.  Its filename is
     mmhwpoison-disable-pcplists-before-grabbing-a-refcount.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-disable-pcplists-before-grabbing-a-refcount.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-disable-pcplists-before-grabbing-a-refcount.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Link: https://lkml.kernel.org/r/20201119105716.5962-7-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |  120 ++++++++++++++++++++----------------------
 1 file changed, 58 insertions(+), 62 deletions(-)

--- a/mm/memory-failure.c~mmhwpoison-disable-pcplists-before-grabbing-a-refcount
+++ a/mm/memory-failure.c
@@ -985,26 +985,67 @@ static int __get_hwpoison_page(struct pa
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
+static int get_any_page(struct page *p)
 {
-	int ret;
-	bool drained = false;
+	int ret = 0, pass = 0;
 
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
+try_again:
+	if (!__get_hwpoison_page(p)) {
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
+				goto try_again;
+			}
+			put_page(p);
+			ret = -EIO;
+		}
 	}
 
 	return ret;
 }
 
+static int get_hwpoison_page(struct page *p, enum mf_flags ctxt)
+{
+	int ret;
+
+	zone_pcp_disable(page_zone(p));
+	if (ctxt == MF_SOFT_OFFLINE)
+		ret = get_any_page(p);
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
@@ -1185,7 +1226,7 @@ static int memory_failure_hugetlb(unsign
 
 	num_poisoned_pages_inc();
 
-	if (!get_hwpoison_page(p)) {
+	if (!get_hwpoison_page(p, 0)) {
 		/*
 		 * Check "filter hit" and "race with other subpage."
 		 */
@@ -1387,7 +1428,7 @@ try_again:
 	 * In fact it's dangerous to directly bump up page count from 0,
 	 * that may make page_ref_freeze()/page_ref_unfreeze() mismatch.
 	 */
-	if (!get_hwpoison_page(p)) {
+	if (!get_hwpoison_page(p, 0)) {
 		if (is_free_buddy_page(p)) {
 			if (take_page_off_buddy(p)) {
 				page_ref_inc(p);
@@ -1674,7 +1715,7 @@ int unpoison_memory(unsigned long pfn)
 		return 0;
 	}
 
-	if (!get_hwpoison_page(p)) {
+	if (!get_hwpoison_page(p, 0)) {
 		if (TestClearPageHWPoison(p))
 			num_poisoned_pages_dec();
 		unpoison_pr_info("Unpoison: Software-unpoisoned free page %#lx\n",
@@ -1705,51 +1746,6 @@ int unpoison_memory(unsigned long pfn)
 }
 EXPORT_SYMBOL(unpoison_memory);
 
-/*
- * Safely get reference count of an arbitrary page.
- * Returns 0 for a free page, 1 for an in-use page, -EIO for a page-type we
- * cannot handle and -EBUSY if we raced with an allocation.
- * We only incremented refcount in case the page was already in-use and it is
- * a known type we can handle.
- */
-static int get_any_page(struct page *p)
-{
-	int ret = 0, pass = 0;
-
-try_again:
-	if (!get_hwpoison_page(p)) {
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
@@ -1920,7 +1916,7 @@ int soft_offline_page(unsigned long pfn)
 
 retry:
 	get_online_mems();
-	ret = get_any_page(page);
+	ret = get_hwpoison_page(page, MF_SOFT_OFFLINE);
 	put_online_mems();
 
 	if (ret > 0) {
_

Patches currently in -mm which might be from osalvador@suse.de are

mmhwpoison-drain-pcplists-before-bailing-out-for-non-buddy-zero-refcount-page.patch
mmhwpoison-take-free-pages-off-the-buddy-freelists.patch
mmhwpoison-take-free-pages-off-the-buddy-freelists-for-hugetlb.patch
mmhwpoison-drop-unneeded-pcplist-draining.patch
mmhwpoison-refactor-get_any_page.patch
mmhwpoison-drop-pfn-parameter.patch
mmhwpoison-disable-pcplists-before-grabbing-a-refcount.patch
mmhwpoison-remove-drain_all_pages-from-shake_page.patch
mmhugetlb-remove-unneded-initialization.patch

