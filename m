Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40ED7C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 10 Nov 2023 17:42:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235142AbjKJRmw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Nov 2023 12:42:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234986AbjKJRl5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Nov 2023 12:41:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B489C446C6
        for <mm-commits@vger.kernel.org>; Fri, 10 Nov 2023 09:25:45 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45794C433C7;
        Fri, 10 Nov 2023 17:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699637145;
        bh=YNZRZ0Z4AJMhqfATX1B6h5ejSsnTIJfc4xmh5G3qf/A=;
        h=Date:To:From:Subject:From;
        b=VxEmTS/G6RvCwDf7UGybdbGR4IADunPb1ENRUmfx02B4ddhLYV2QaAOSNJ3exfDIF
         0SjhmP/glKs4+uXyYBhx9KghVYxLVnIKISytXzqcfpMJXtGxXDl6LGzTBrLlxdOpfB
         tVAA8kQ/Baqbqv2A2rD/KlOoNS4lGTBI7SWX55yA=
Date:   Fri, 10 Nov 2023 09:25:44 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        gregory.price@memverge.com, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-page-use-a-folio-in-stable_page_flags.patch added to mm-unstable branch
Message-Id: <20231110172545.45794C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/page: use a folio in stable_page_flags()
has been added to the -mm mm-unstable branch.  Its filename is
     fs-proc-page-use-a-folio-in-stable_page_flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-page-use-a-folio-in-stable_page_flags.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: fs/proc/page: use a folio in stable_page_flags()
Date: Fri, 10 Nov 2023 11:33:19 +0800

Replace nine compound_head() calls with one page_folio().

Link: https://lkml.kernel.org/r/20231110033324.2455523-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gregory Price <gregory.price@memverge.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/fs/proc/page.c~fs-proc-page-use-a-folio-in-stable_page_flags
+++ a/fs/proc/page.c
@@ -109,6 +109,7 @@ static inline u64 kpf_copy_bit(u64 kflag
 
 u64 stable_page_flags(struct page *page)
 {
+	struct folio *folio;
 	u64 k;
 	u64 u;
 
@@ -119,6 +120,7 @@ u64 stable_page_flags(struct page *page)
 	if (!page)
 		return 1 << KPF_NOPAGE;
 
+	folio = page_folio(page);
 	k = page->flags;
 	u = 0;
 
@@ -128,11 +130,11 @@ u64 stable_page_flags(struct page *page)
 	 * Note that page->_mapcount is overloaded in SLAB, so the
 	 * simple test in page_mapped() is not enough.
 	 */
-	if (!PageSlab(page) && page_mapped(page))
+	if (!folio_test_slab(folio) && folio_mapped(folio))
 		u |= 1 << KPF_MMAP;
-	if (PageAnon(page))
+	if (folio_test_anon(folio))
 		u |= 1 << KPF_ANON;
-	if (PageKsm(page))
+	if (folio_test_ksm(folio))
 		u |= 1 << KPF_KSM;
 
 	/*
@@ -152,11 +154,9 @@ u64 stable_page_flags(struct page *page)
 	 * to make sure a given page is a thp, not a non-huge compound page.
 	 */
 	else if (PageTransCompound(page)) {
-		struct page *head = compound_head(page);
-
-		if (PageLRU(head) || PageAnon(head))
+		if (folio_test_lru(folio) || folio_test_anon(folio))
 			u |= 1 << KPF_THP;
-		else if (is_huge_zero_page(head)) {
+		else if (is_huge_zero_page(&folio->page)) {
 			u |= 1 << KPF_ZERO_PAGE;
 			u |= 1 << KPF_THP;
 		}
@@ -170,7 +170,7 @@ u64 stable_page_flags(struct page *page)
 	 */
 	if (PageBuddy(page))
 		u |= 1 << KPF_BUDDY;
-	else if (page_count(page) == 0 && is_free_buddy_page(page))
+	else if (folio_ref_count(folio) == 0 && is_free_buddy_page(page))
 		u |= 1 << KPF_BUDDY;
 
 	if (PageOffline(page))
@@ -178,7 +178,7 @@ u64 stable_page_flags(struct page *page)
 	if (PageTable(page))
 		u |= 1 << KPF_PGTABLE;
 
-	if (page_is_idle(page))
+	if (folio_test_idle(folio))
 		u |= 1 << KPF_IDLE;
 
 	u |= kpf_copy_bit(k, KPF_LOCKED,	PG_locked);
@@ -194,7 +194,7 @@ u64 stable_page_flags(struct page *page)
 	u |= kpf_copy_bit(k, KPF_ACTIVE,	PG_active);
 	u |= kpf_copy_bit(k, KPF_RECLAIM,	PG_reclaim);
 
-	if (PageSwapCache(page))
+	if (folio_test_swapcache(folio))
 		u |= 1 << KPF_SWAPCACHE;
 	u |= kpf_copy_bit(k, KPF_SWAPBACKED,	PG_swapbacked);
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

fs-proc-page-remove-unneeded-pagetail-pageslab-check.patch
fs-proc-page-use-a-folio-in-stable_page_flags.patch
fs-proc-page-respect-folio-head-page-flag-placement.patch
mm-huge_memory-use-more-folio-api-in-__split_huge_page_tail.patch
mm-task_mmu-use-a-folio-in-smaps_account.patch
mm-task_mmu-use-a-folio-in-clear_refs_pte_range.patch
page_idle-kill-page-idle-and-young-wrapper.patch

