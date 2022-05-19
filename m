Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDD73C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 22:26:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245440AbiESWZx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 18:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245454AbiESWZo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 18:25:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EACC22F6
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 15:25:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8462461693
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 22:25:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D38C385B8;
        Thu, 19 May 2022 22:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652999141;
        bh=LLdZimyfJ3CxZXPjo3xgBLNL53YyKOXIsWyOFenZSI0=;
        h=Date:To:From:Subject:From;
        b=NX1tCqp6Vz6BS1g6VYx7A23pMAqfWg5RTghblLNADdBjTI4HIUvRIpPgm0fQ7ASgv
         S0SHLSYQbI93yHZvika8g1UBAsz1V/RhyBC3RuyeZ6707GQ6OlDa6AabM1WiXBfP7m
         e6GU1THXlpnqp5a4amJb/VyGvjIVpin2Tltn5Rtw=
Date:   Thu, 19 May 2022 15:25:41 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, peterx@redhat.com, osalvador@suse.de,
        neilb@suse.de, naoya.horiguchi@nec.com, dhowells@redhat.com,
        david@redhat.com, apopple@nvidia.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-make-page_swapcount-and-__lru_add_drain_all.patch removed from -mm tree
Message-Id: <20220519222541.D9D38C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swap: make page_swapcount and __lru_add_drain_all static
has been removed from the -mm tree.  Its filename was
     mm-swap-make-page_swapcount-and-__lru_add_drain_all.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swap: make page_swapcount and __lru_add_drain_all static

Make page_swapcount and __lru_add_drain_all static.  They are only used
within the file now.

Link: https://lkml.kernel.org/r/20220509131416.17553-9-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    7 -------
 mm/swap.c            |    2 +-
 mm/swapfile.c        |    2 +-
 3 files changed, 2 insertions(+), 9 deletions(-)

--- a/include/linux/swap.h~mm-swap-make-page_swapcount-and-__lru_add_drain_all
+++ a/include/linux/swap.h
@@ -485,7 +485,6 @@ int swap_type_of(dev_t device, sector_t
 int find_first_swap(dev_t *device);
 extern unsigned int count_swap_pages(int, int);
 extern sector_t swapdev_block(int, pgoff_t);
-extern int page_swapcount(struct page *);
 extern int __swap_count(swp_entry_t entry);
 extern int __swp_swapcount(swp_entry_t entry);
 extern int swp_swapcount(swp_entry_t entry);
@@ -557,12 +556,6 @@ static inline void put_swap_page(struct
 {
 }
 
-
-static inline int page_swapcount(struct page *page)
-{
-	return 0;
-}
-
 static inline int __swap_count(swp_entry_t entry)
 {
 	return 0;
--- a/mm/swap.c~mm-swap-make-page_swapcount-and-__lru_add_drain_all
+++ a/mm/swap.c
@@ -748,7 +748,7 @@ static void lru_add_drain_per_cpu(struct
  * Calling this function with cpu hotplug locks held can actually lead
  * to obscure indirect dependencies via WQ context.
  */
-inline void __lru_add_drain_all(bool force_all_cpus)
+static inline void __lru_add_drain_all(bool force_all_cpus)
 {
 	/*
 	 * lru_drain_gen - Global pages generation number
--- a/mm/swapfile.c~mm-swap-make-page_swapcount-and-__lru_add_drain_all
+++ a/mm/swapfile.c
@@ -1429,7 +1429,7 @@ void swapcache_free_entries(swp_entry_t
  * This does not give an exact answer when swap count is continued,
  * but does include the high COUNT_CONTINUED flag to allow for that.
  */
-int page_swapcount(struct page *page)
+static int page_swapcount(struct page *page)
 {
 	int count = 0;
 	struct swap_info_struct *p;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-z3fold-fix-sheduling-while-atomic.patch
mm-z3fold-fix-possible-null-pointer-dereferencing.patch
mm-z3fold-remove-buggy-use-of-stale-list-for-allocation.patch
mm-z3fold-throw-warning-on-failure-of-trylock_page-in-z3fold_alloc.patch
revert-mm-z3foldc-allow-__gfp_highmem-in-z3fold_alloc.patch
mm-z3fold-put-z3fold-page-back-into-unbuddied-list-when-reclaim-or-migration-fails.patch
mm-z3fold-always-clear-page_claimed-under-z3fold-page-lock.patch
mm-z3fold-fix-z3fold_reclaim_page-races-with-z3fold_free.patch
mm-z3fold-fix-z3fold_page_migrate-races-with-z3fold_map.patch
mm-swapfile-unuse_pte-can-map-random-data-if-swap-read-fails.patch
mm-swapfile-fix-lost-swap-bits-in-unuse_pte.patch
mm-madvise-free-hwpoison-and-swapin-error-entry-in-madvise_free_pte_range.patch
mm-shmem-fix-infinite-loop-when-swap-in-shmem-error-at-swapoff-time.patch
mm-filter-out-swapin-error-entry-in-shmem-mapping.patch

