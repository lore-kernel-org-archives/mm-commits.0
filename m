Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A77B5C001B0
	for <mm-commits@archiver.kernel.org>; Mon, 17 Jul 2023 18:58:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbjGQS6n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Jul 2023 14:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbjGQS6j (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Jul 2023 14:58:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F25A10C7
        for <mm-commits@vger.kernel.org>; Mon, 17 Jul 2023 11:58:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64E1A6120A
        for <mm-commits@vger.kernel.org>; Mon, 17 Jul 2023 18:58:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA69DC433C9;
        Mon, 17 Jul 2023 18:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689620299;
        bh=95yi9/x9uhVv8rmsqhQAAscsEeqsbgmSdbAVPOpGD1Q=;
        h=Date:To:From:Subject:From;
        b=uPId3Tt2CaxYSjDKM5V2Ik/EavZ8h4lJm9HAO3u4avcpS1qjQ2deN75dvtFEjRoD7
         YI8JFhZ8Jq81j06jrxAGmGb33+DZwc4kLh4vY2bCar+aaqq33u5qY9Dw2IAzqwyz5o
         rr2zkTYai2ZMMGzcqOJFshx9WFbRUi4JMs6sq2Qk=
Date:   Mon, 17 Jul 2023 11:58:19 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        vitaly.wool@konsulko.com, nphamcs@gmail.com, hch@infradead.org,
        hannes@cmpxchg.org, cerasuolodomenico@gmail.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zswap-make-zswap_store-take-a-folio.patch added to mm-unstable branch
Message-Id: <20230717185819.BA69DC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zswap: make zswap_store() take a folio
has been added to the -mm mm-unstable branch.  Its filename is
     zswap-make-zswap_store-take-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zswap-make-zswap_store-take-a-folio.patch

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
Subject: zswap: make zswap_store() take a folio
Date: Sat, 15 Jul 2023 05:23:40 +0100

Patch series "Followup folio conversions for zswap".

With frontswap killed, it's worth converting the zswap_load() and
zswap_store() functions to take a folio instead of a page pointer.  They
aren't converted to support large folios, but there are a lot of
unnecessary calls to compound_head() that are removed by these patches.


This patch (of 4):

Only convert a few easy parts of this function to use the folio passed in;
convert back to struct page for the majority of it.  This does remove a
few hidden calls to compound_head().

Link: https://lkml.kernel.org/r/20230715042343.434588-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20230715042343.434588-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zswap.h |    4 ++--
 mm/page_io.c          |    2 +-
 mm/zswap.c            |   13 +++++++------
 3 files changed, 10 insertions(+), 9 deletions(-)

--- a/include/linux/zswap.h~zswap-make-zswap_store-take-a-folio
+++ a/include/linux/zswap.h
@@ -10,7 +10,7 @@ extern atomic_t zswap_stored_pages;
 
 #ifdef CONFIG_ZSWAP
 
-bool zswap_store(struct page *page);
+bool zswap_store(struct folio *folio);
 bool zswap_load(struct page *page);
 void zswap_invalidate(int type, pgoff_t offset);
 void zswap_swapon(int type);
@@ -18,7 +18,7 @@ void zswap_swapoff(int type);
 
 #else
 
-static inline bool zswap_store(struct page *page)
+static inline bool zswap_store(struct folio *folio)
 {
 	return false;
 }
--- a/mm/page_io.c~zswap-make-zswap_store-take-a-folio
+++ a/mm/page_io.c
@@ -198,7 +198,7 @@ int swap_writepage(struct page *page, st
 		folio_unlock(folio);
 		return ret;
 	}
-	if (zswap_store(&folio->page)) {
+	if (zswap_store(folio)) {
 		folio_start_writeback(folio);
 		folio_unlock(folio);
 		folio_end_writeback(folio);
--- a/mm/zswap.c~zswap-make-zswap_store-take-a-folio
+++ a/mm/zswap.c
@@ -1223,11 +1223,12 @@ static void zswap_fill_page(void *ptr, u
 	memset_l(page, value, PAGE_SIZE / sizeof(unsigned long));
 }
 
-bool zswap_store(struct page *page)
+bool zswap_store(struct folio *folio)
 {
-	swp_entry_t swp = { .val = page_private(page), };
+	swp_entry_t swp = folio_swap_entry(folio);
 	int type = swp_type(swp);
 	pgoff_t offset = swp_offset(swp);
+	struct page *page = &folio->page;
 	struct zswap_tree *tree = zswap_trees[type];
 	struct zswap_entry *entry, *dupentry;
 	struct scatterlist input, output;
@@ -1242,11 +1243,11 @@ bool zswap_store(struct page *page)
 	gfp_t gfp;
 	int ret;
 
-	VM_WARN_ON_ONCE(!PageLocked(page));
-	VM_WARN_ON_ONCE(!PageSwapCache(page));
+	VM_WARN_ON_ONCE(!folio_test_locked(folio));
+	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
 
-	/* THP isn't supported */
-	if (PageTransHuge(page))
+	/* Large folios aren't supported */
+	if (folio_test_large(folio))
 		return false;
 
 	if (!zswap_enabled || !tree)
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

