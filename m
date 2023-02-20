Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FB92C677F1
	for <mm-commits@archiver.kernel.org>; Mon, 20 Feb 2023 20:47:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbjBTUrJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Feb 2023 15:47:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231865AbjBTUrB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Feb 2023 15:47:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D31D9192
        for <mm-commits@vger.kernel.org>; Mon, 20 Feb 2023 12:46:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6568A60F19
        for <mm-commits@vger.kernel.org>; Mon, 20 Feb 2023 20:46:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4DA8C4339C;
        Mon, 20 Feb 2023 20:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676926018;
        bh=8VSZrYaH0GaiZ3bAHoujb7crlHyLVXQJtmcw/IaSDmM=;
        h=Date:To:From:Subject:From;
        b=uklN8u1mZkIiJgCf5tDsQJhhBSXANSX0NDIrWFQUQlUEnXZxzduiC8AtAvy73Ur/B
         C4HZMNvBGvl8PPD4DCIvevYlIvGjWCiVxWYJRkJWgWIQp2hR1QNmghJjSVIUD5vh6b
         a+0LUeqnRrPVTQNeJX5sgmaGDIY7Mdoc0aRuPZ4g=
Date:   Mon, 20 Feb 2023 12:46:58 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        torvalds@linux-foundation.org, sj@kernel.org, shakeelb@google.com,
        roman.gushchin@linux.dev, osalvador@suse.de,
        naoya.horiguchi@nec.com, muchun.song@linux.dev,
        mike.kravetz@oracle.com, mhocko@kernel.org, linmiaohe@huawei.com,
        hannes@cmpxchg.org, david@redhat.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-change-to-return-bool-for-folio_isolate_lru.patch removed from -mm tree
Message-Id: <20230220204658.B4DA8C4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: change to return bool for folio_isolate_lru()
has been removed from the -mm tree.  Its filename was
     mm-change-to-return-bool-for-folio_isolate_lru.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: change to return bool for folio_isolate_lru()
Date: Wed, 15 Feb 2023 18:39:34 +0800

Patch series "Change the return value for page isolation functions", v3.

Now the page isolation functions did not return a boolean to indicate
success or not, instead it will return a negative error when failed
to isolate a page. So below code used in most places seem a boolean
success/failure thing, which can confuse people whether the isolation
is successful.

if (folio_isolate_lru(folio))
        continue;

Moreover the page isolation functions only return 0 or -EBUSY, and
most users did not care about the negative error except for few users,
thus we can convert all page isolation functions to return a boolean
value, which can remove the confusion to make code more clear.

No functional changes intended in this patch series.


This patch (of 4):

Now the folio_isolate_lru() did not return a boolean value to indicate
isolation success or not, however below code checking the return value can
make people think that it was a boolean success/failure thing, which makes
people easy to make mistakes (see the fix patch[1]).

if (folio_isolate_lru(folio))
	continue;

Thus it's better to check the negative error value expilictly returned by
folio_isolate_lru(), which makes code more clear per Linus's
suggestion[2].  Moreover Matthew suggested we can convert the isolation
functions to return a boolean[3], since most users did not care about the
negative error value, and can also remove the confusing of checking return
value.

So this patch converts the folio_isolate_lru() to return a boolean value,
which means return 'true' to indicate the folio isolation is successful,
and 'false' means a failure to isolation.  Meanwhile changing all users'
logic of checking the isolation state.

No functional changes intended.

[1] https://lore.kernel.org/all/20230131063206.28820-1-Kuan-Ying.Lee@mediatek.com/T/#u
[2] https://lore.kernel.org/all/CAHk-=wiBrY+O-4=2mrbVyxR+hOqfdJ=Do6xoucfJ9_5az01L4Q@mail.gmail.com/
[3] https://lore.kernel.org/all/Y+sTFqwMNAjDvxw3@casper.infradead.org/

Link: https://lkml.kernel.org/r/cover.1676424378.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/8a4e3679ed4196168efadf7ea36c038f2f7d5aa9.1676424378.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/damon/paddr.c~mm-change-to-return-bool-for-folio_isolate_lru
+++ a/mm/damon/paddr.c
@@ -246,7 +246,7 @@ static unsigned long damon_pa_pageout(st
 
 		folio_clear_referenced(folio);
 		folio_test_clear_young(folio);
-		if (folio_isolate_lru(folio)) {
+		if (!folio_isolate_lru(folio)) {
 			folio_put(folio);
 			continue;
 		}
--- a/mm/folio-compat.c~mm-change-to-return-bool-for-folio_isolate_lru
+++ a/mm/folio-compat.c
@@ -115,9 +115,15 @@ EXPORT_SYMBOL(grab_cache_page_write_begi
 
 int isolate_lru_page(struct page *page)
 {
+	bool ret;
+
 	if (WARN_RATELIMIT(PageTail(page), "trying to isolate tail page"))
 		return -EBUSY;
-	return folio_isolate_lru((struct folio *)page);
+	ret = folio_isolate_lru((struct folio *)page);
+	if (ret)
+		return 0;
+
+	return -EBUSY;
 }
 
 void putback_lru_page(struct page *page)
--- a/mm/gup.c~mm-change-to-return-bool-for-folio_isolate_lru
+++ a/mm/gup.c
@@ -1939,7 +1939,7 @@ static unsigned long collect_longterm_un
 			drain_allow = false;
 		}
 
-		if (folio_isolate_lru(folio))
+		if (!folio_isolate_lru(folio))
 			continue;
 
 		list_add_tail(&folio->lru, movable_page_list);
--- a/mm/internal.h~mm-change-to-return-bool-for-folio_isolate_lru
+++ a/mm/internal.h
@@ -188,7 +188,7 @@ pgprot_t __init early_memremap_pgprot_ad
  * in mm/vmscan.c:
  */
 int isolate_lru_page(struct page *page);
-int folio_isolate_lru(struct folio *folio);
+bool folio_isolate_lru(struct folio *folio);
 void putback_lru_page(struct page *page);
 void folio_putback_lru(struct folio *folio);
 extern void reclaim_throttle(pg_data_t *pgdat, enum vmscan_throttle_state reason);
--- a/mm/khugepaged.c~mm-change-to-return-bool-for-folio_isolate_lru
+++ a/mm/khugepaged.c
@@ -1950,7 +1950,7 @@ static int collapse_file(struct mm_struc
 			goto out_unlock;
 		}
 
-		if (folio_isolate_lru(folio)) {
+		if (!folio_isolate_lru(folio)) {
 			result = SCAN_DEL_PAGE_LRU;
 			goto out_unlock;
 		}
--- a/mm/madvise.c~mm-change-to-return-bool-for-folio_isolate_lru
+++ a/mm/madvise.c
@@ -406,7 +406,7 @@ static int madvise_cold_or_pageout_pte_r
 		folio_clear_referenced(folio);
 		folio_test_clear_young(folio);
 		if (pageout) {
-			if (!folio_isolate_lru(folio)) {
+			if (folio_isolate_lru(folio)) {
 				if (folio_test_unevictable(folio))
 					folio_putback_lru(folio);
 				else
@@ -500,7 +500,7 @@ regular_folio:
 		folio_clear_referenced(folio);
 		folio_test_clear_young(folio);
 		if (pageout) {
-			if (!folio_isolate_lru(folio)) {
+			if (folio_isolate_lru(folio)) {
 				if (folio_test_unevictable(folio))
 					folio_putback_lru(folio);
 				else
--- a/mm/mempolicy.c~mm-change-to-return-bool-for-folio_isolate_lru
+++ a/mm/mempolicy.c
@@ -1033,7 +1033,7 @@ static int migrate_folio_add(struct foli
 	 * expensive, so check the estimated mapcount of the folio instead.
 	 */
 	if ((flags & MPOL_MF_MOVE_ALL) || folio_estimated_sharers(folio) == 1) {
-		if (!folio_isolate_lru(folio)) {
+		if (folio_isolate_lru(folio)) {
 			list_add_tail(&folio->lru, foliolist);
 			node_stat_mod_folio(folio,
 				NR_ISOLATED_ANON + folio_is_file_lru(folio),
--- a/mm/vmscan.c~mm-change-to-return-bool-for-folio_isolate_lru
+++ a/mm/vmscan.c
@@ -2337,12 +2337,12 @@ move:
  * (2) The lru_lock must not be held.
  * (3) Interrupts must be enabled.
  *
- * Return: 0 if the folio was removed from an LRU list.
- * -EBUSY if the folio was not on an LRU list.
+ * Return: true if the folio was removed from an LRU list.
+ * false if the folio was not on an LRU list.
  */
-int folio_isolate_lru(struct folio *folio)
+bool folio_isolate_lru(struct folio *folio)
 {
-	int ret = -EBUSY;
+	bool ret = false;
 
 	VM_BUG_ON_FOLIO(!folio_ref_count(folio), folio);
 
@@ -2353,7 +2353,7 @@ int folio_isolate_lru(struct folio *foli
 		lruvec = folio_lruvec_lock_irq(folio);
 		lruvec_del_folio(lruvec, folio);
 		unlock_page_lruvec_irq(lruvec);
-		ret = 0;
+		ret = true;
 	}
 
 	return ret;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


