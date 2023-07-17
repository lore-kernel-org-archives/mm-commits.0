Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E794DEB64DC
	for <mm-commits@archiver.kernel.org>; Mon, 17 Jul 2023 18:59:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbjGQS7P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Jul 2023 14:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231672AbjGQS6l (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Jul 2023 14:58:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EFB31709
        for <mm-commits@vger.kernel.org>; Mon, 17 Jul 2023 11:58:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14A2A611E7
        for <mm-commits@vger.kernel.org>; Mon, 17 Jul 2023 18:58:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA65C433C7;
        Mon, 17 Jul 2023 18:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689620303;
        bh=L6758YoSXofttiXsVf1YOG2Xo+WqJo+R4FgwybCP+xQ=;
        h=Date:To:From:Subject:From;
        b=W/FTqb04pH4Eq3EaXCWKMu1mXwyzBCddq1Ytp9u2ww2fAvJ1XXdwemhaFR+uCpebR
         fKDOTUy5w5hc3zNmSxffScWAl7dog+j+6luh3tMNKYdbv3wAbpQ8EriaQGi7pnn/5h
         DsrQUbs1Bxr/6PxcK7RT+DDlO8vXmoIvjF+dpGhs=
Date:   Mon, 17 Jul 2023 11:58:22 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        vitaly.wool@konsulko.com, nphamcs@gmail.com, hch@infradead.org,
        hannes@cmpxchg.org, cerasuolodomenico@gmail.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-convert-get_obj_cgroup_from_page-to-get_obj_cgroup_from_folio.patch added to mm-unstable branch
Message-Id: <20230717185823.6BA65C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: convert get_obj_cgroup_from_page to get_obj_cgroup_from_folio
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-convert-get_obj_cgroup_from_page-to-get_obj_cgroup_from_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-convert-get_obj_cgroup_from_page-to-get_obj_cgroup_from_folio.patch

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
Subject: memcg: convert get_obj_cgroup_from_page to get_obj_cgroup_from_folio
Date: Sat, 15 Jul 2023 05:23:41 +0100

As the one caller now has a folio, pass it in and use it.  Removes three
calls to compound_head().

Link: https://lkml.kernel.org/r/20230715042343.434588-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ++--
 mm/memcontrol.c            |    8 ++++----
 mm/zswap.c                 |    2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

--- a/include/linux/memcontrol.h~memcg-convert-get_obj_cgroup_from_page-to-get_obj_cgroup_from_folio
+++ a/include/linux/memcontrol.h
@@ -1759,7 +1759,7 @@ int __memcg_kmem_charge_page(struct page
 void __memcg_kmem_uncharge_page(struct page *page, int order);
 
 struct obj_cgroup *get_obj_cgroup_from_current(void);
-struct obj_cgroup *get_obj_cgroup_from_page(struct page *page);
+struct obj_cgroup *get_obj_cgroup_from_folio(struct folio *folio);
 
 int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size);
 void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size);
@@ -1843,7 +1843,7 @@ static inline void __memcg_kmem_uncharge
 {
 }
 
-static inline struct obj_cgroup *get_obj_cgroup_from_page(struct page *page)
+static inline struct obj_cgroup *get_obj_cgroup_from_folio(struct folio *folio)
 {
 	return NULL;
 }
--- a/mm/memcontrol.c~memcg-convert-get_obj_cgroup_from_page-to-get_obj_cgroup_from_folio
+++ a/mm/memcontrol.c
@@ -3036,21 +3036,21 @@ __always_inline struct obj_cgroup *get_o
 	return objcg;
 }
 
-struct obj_cgroup *get_obj_cgroup_from_page(struct page *page)
+struct obj_cgroup *get_obj_cgroup_from_folio(struct folio *folio)
 {
 	struct obj_cgroup *objcg;
 
 	if (!memcg_kmem_online())
 		return NULL;
 
-	if (PageMemcgKmem(page)) {
-		objcg = __folio_objcg(page_folio(page));
+	if (folio_memcg_kmem(folio)) {
+		objcg = __folio_objcg(folio);
 		obj_cgroup_get(objcg);
 	} else {
 		struct mem_cgroup *memcg;
 
 		rcu_read_lock();
-		memcg = __folio_memcg(page_folio(page));
+		memcg = __folio_memcg(folio);
 		if (memcg)
 			objcg = __get_obj_cgroup_from_memcg(memcg);
 		else
--- a/mm/zswap.c~memcg-convert-get_obj_cgroup_from_page-to-get_obj_cgroup_from_folio
+++ a/mm/zswap.c
@@ -1258,7 +1258,7 @@ bool zswap_store(struct folio *folio)
 	 * cgroup-aware entry LRU, we will push out entries system-wide based on
 	 * local cgroup limits.
 	 */
-	objcg = get_obj_cgroup_from_page(page);
+	objcg = get_obj_cgroup_from_folio(folio);
 	if (objcg && !obj_cgroup_may_zswap(objcg))
 		goto reject;
 
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

