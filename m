Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FBD1C001B0
	for <mm-commits@archiver.kernel.org>; Mon, 17 Jul 2023 18:59:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbjGQS7W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Jul 2023 14:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231715AbjGQS6n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Jul 2023 14:58:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C3891738
        for <mm-commits@vger.kernel.org>; Mon, 17 Jul 2023 11:58:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D72326120F
        for <mm-commits@vger.kernel.org>; Mon, 17 Jul 2023 18:58:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37446C433C7;
        Mon, 17 Jul 2023 18:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689620310;
        bh=rRaZ59FfjLmNPlZyUgV+3KSQhyFAB+Of5U327EWJwUI=;
        h=Date:To:From:Subject:From;
        b=scX3wi1lqGVNSvKEwuP+KtyvO3V8YNPx+V4Q3InjPFDsUgvPWqnpPuZJZ1ZB4VOdl
         rznNQvs0mjZixOWmlwLn2W3nCwFYU7Op3STdTMfxQAcJoLsOzH9rbIZQsA0wA/JydU
         otvBVgjeZOa+9HkWQKeh3JTdu+sb+1Q2DFZnhQZs=
Date:   Mon, 17 Jul 2023 11:58:29 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        vitaly.wool@konsulko.com, nphamcs@gmail.com, hch@infradead.org,
        hannes@cmpxchg.org, cerasuolodomenico@gmail.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zswap-make-zswap_load-take-a-folio.patch added to mm-unstable branch
Message-Id: <20230717185830.37446C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zswap: make zswap_load() take a folio
has been added to the -mm mm-unstable branch.  Its filename is
     zswap-make-zswap_load-take-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zswap-make-zswap_load-take-a-folio.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: zswap: make zswap_load() take a folio
Date: Sat, 15 Jul 2023 05:23:43 +0100

Only convert a few easy parts of this function to use the folio passed in;
convert back to struct page for the majority of it.  Removes three hidden
calls to compound_head().

Link: https://lkml.kernel.org/r/20230715042343.434588-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zswap.h |    4 ++--
 mm/page_io.c          |    2 +-
 mm/zswap.c            |   11 ++++++-----
 3 files changed, 9 insertions(+), 8 deletions(-)

--- a/include/linux/zswap.h~zswap-make-zswap_load-take-a-folio
+++ a/include/linux/zswap.h
@@ -11,7 +11,7 @@ extern atomic_t zswap_stored_pages;
 #ifdef CONFIG_ZSWAP
 
 bool zswap_store(struct folio *folio);
-bool zswap_load(struct page *page);
+bool zswap_load(struct folio *folio);
 void zswap_invalidate(int type, pgoff_t offset);
 void zswap_swapon(int type);
 void zswap_swapoff(int type);
@@ -23,7 +23,7 @@ static inline bool zswap_store(struct fo
 	return false;
 }
 
-static inline bool zswap_load(struct page *page)
+static inline bool zswap_load(struct folio *folio)
 {
 	return false;
 }
--- a/mm/page_io.c~zswap-make-zswap_load-take-a-folio
+++ a/mm/page_io.c
@@ -516,7 +516,7 @@ void swap_readpage(struct page *page, bo
 	}
 	delayacct_swapin_start();
 
-	if (zswap_load(page)) {
+	if (zswap_load(folio)) {
 		folio_mark_uptodate(folio);
 		folio_unlock(folio);
 	} else if (data_race(sis->flags & SWP_FS_OPS)) {
--- a/mm/zswap.c~zswap-make-zswap_load-take-a-folio
+++ a/mm/zswap.c
@@ -1405,11 +1405,12 @@ shrink:
 	goto reject;
 }
 
-bool zswap_load(struct page *page)
+bool zswap_load(struct folio *folio)
 {
-	swp_entry_t swp = { .val = page_private(page), };
+	swp_entry_t swp = folio_swap_entry(folio);
 	int type = swp_type(swp);
 	pgoff_t offset = swp_offset(swp);
+	struct page *page = &folio->page;
 	struct zswap_tree *tree = zswap_trees[type];
 	struct zswap_entry *entry;
 	struct scatterlist input, output;
@@ -1419,8 +1420,8 @@ bool zswap_load(struct page *page)
 	unsigned int dlen;
 	bool ret;
 
-	VM_WARN_ON_ONCE(!PageLocked(page));
-	VM_WARN_ON_ONCE(!PageSwapCache(page));
+	VM_WARN_ON_ONCE(!folio_test_locked(folio));
+	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
 
 	/* find */
 	spin_lock(&tree->lock);
@@ -1483,7 +1484,7 @@ freeentry:
 	spin_lock(&tree->lock);
 	if (ret && zswap_exclusive_loads_enabled) {
 		zswap_invalidate_entry(tree, entry);
-		SetPageDirty(page);
+		folio_mark_dirty(folio);
 	} else if (entry->length) {
 		spin_lock(&entry->pool->lru_lock);
 		list_move(&entry->lru, &entry->pool->lru);
_

Patches currently in -mm which might be from willy@infradead.org are

rmap-pass-the-folio-to-__page_check_anon_rmap.patch
highmem-add-memcpy_to_folio-and-memcpy_from_folio.patch
affs-convert-affs_symlink_read_folio-to-use-the-folio.patch
affs-convert-data-read-and-write-to-use-folios.patch
migrate-use-folio_set_bh-instead-of-set_bh_page.patch
ntfs3-convert-ntfs_get_block_vbo-to-use-a-folio.patch
jbd2-use-a-folio-in-jbd2_journal_write_metadata_buffer.patch
buffer-remove-set_bh_page.patch
zswap-make-zswap_store-take-a-folio.patch
memcg-convert-get_obj_cgroup_from_page-to-get_obj_cgroup_from_folio.patch
swap-remove-some-calls-to-compound_head-in-swap_readpage.patch
zswap-make-zswap_load-take-a-folio.patch

