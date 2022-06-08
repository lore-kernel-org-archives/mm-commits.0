Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9DC7C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Jun 2022 18:32:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234374AbiFHScz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Jun 2022 14:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233196AbiFHScz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jun 2022 14:32:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F24DE2ED41
        for <mm-commits@vger.kernel.org>; Wed,  8 Jun 2022 11:32:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A379DB82997
        for <mm-commits@vger.kernel.org>; Wed,  8 Jun 2022 18:32:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410E5C34116;
        Wed,  8 Jun 2022 18:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654713170;
        bh=Fcltey9waUjzqJJH9Hw0foXWoExHl/ZFkdfYpGh/5og=;
        h=Date:To:From:Subject:From;
        b=HLrkTMwgny3Oj0Ou+SLpCNVLglM0amy+oUMUhJ5+pmVMHEtaFRUqsyHgH/qowB2Rv
         FtcvB/DOvmHN+uo5qRL9CpGi6lbs++OsTHNJZdYxmll3iaPOkZcQtCf1wVxeD78s2v
         yUXXXQ8QrWFPMwO/W6ZDjzIp2bo2S4qbbOzYZx1M=
Date:   Wed, 08 Jun 2022 11:32:49 -0700
To:     mm-commits@vger.kernel.org, hughd@google.com, david@redhat.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-remove-swap_cache_info-statistics.patch added to mm-unstable branch
Message-Id: <20220608183250.410E5C34116@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: remove swap_cache_info statistics
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-remove-swap_cache_info-statistics.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-remove-swap_cache_info-statistics.patch

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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swap: remove swap_cache_info statistics
Date: Wed, 8 Jun 2022 22:40:31 +0800

swap_cache_info are not statistics that could be easily used to tune
system performance because they are not easily accessile.  Also they can't
provide really useful info when OOM occurs.  Remove these statistics can
also help mitigate unneeded global swap_cache_info cacheline contention.

Link: https://lkml.kernel.org/r/20220608144031.829-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |   17 -----------------
 1 file changed, 17 deletions(-)

--- a/mm/swap_state.c~mm-swap-remove-swap_cache_info-statistics
+++ a/mm/swap_state.c
@@ -59,24 +59,11 @@ static bool enable_vma_readahead __read_
 #define GET_SWAP_RA_VAL(vma)					\
 	(atomic_long_read(&(vma)->swap_readahead_info) ? : 4)
 
-#define INC_CACHE_INFO(x)	data_race(swap_cache_info.x++)
-#define ADD_CACHE_INFO(x, nr)	data_race(swap_cache_info.x += (nr))
-
-static struct {
-	unsigned long add_total;
-	unsigned long del_total;
-	unsigned long find_success;
-	unsigned long find_total;
-} swap_cache_info;
-
 static atomic_t swapin_readahead_hits = ATOMIC_INIT(4);
 
 void show_swap_cache_info(void)
 {
 	printk("%lu pages in swap cache\n", total_swapcache_pages());
-	printk("Swap cache stats: add %lu, delete %lu, find %lu/%lu\n",
-		swap_cache_info.add_total, swap_cache_info.del_total,
-		swap_cache_info.find_success, swap_cache_info.find_total);
 	printk("Free swap  = %ldkB\n",
 		get_nr_swap_pages() << (PAGE_SHIFT - 10));
 	printk("Total swap = %lukB\n", total_swap_pages << (PAGE_SHIFT - 10));
@@ -133,7 +120,6 @@ int add_to_swap_cache(struct page *page,
 		address_space->nrpages += nr;
 		__mod_node_page_state(page_pgdat(page), NR_FILE_PAGES, nr);
 		__mod_lruvec_page_state(page, NR_SWAPCACHE, nr);
-		ADD_CACHE_INFO(add_total, nr);
 unlock:
 		xas_unlock_irq(&xas);
 	} while (xas_nomem(&xas, gfp));
@@ -172,7 +158,6 @@ void __delete_from_swap_cache(struct pag
 	address_space->nrpages -= nr;
 	__mod_node_page_state(page_pgdat(page), NR_FILE_PAGES, -nr);
 	__mod_lruvec_page_state(page, NR_SWAPCACHE, -nr);
-	ADD_CACHE_INFO(del_total, nr);
 }
 
 /**
@@ -348,12 +333,10 @@ struct page *lookup_swap_cache(swp_entry
 	page = find_get_page(swap_address_space(entry), swp_offset(entry));
 	put_swap_device(si);
 
-	INC_CACHE_INFO(find_total);
 	if (page) {
 		bool vma_ra = swap_use_vma_readahead();
 		bool readahead;
 
-		INC_CACHE_INFO(find_success);
 		/*
 		 * At the moment, we don't support PG_readahead for anon THP
 		 * so let's bail out rather than confusing the readahead stat.
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

maintainers-add-myself-as-a-memory-failure-reviewer.patch
mm-shmemc-clean-up-comment-of-shmem_swapin_folio.patch
mm-reduce-the-rcu-lock-duration.patch
mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch
mm-migration-return-errno-when-isolate_huge_page-failed.patch
mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-memremap-fix-wrong-function-name-above-memremap_pages.patch
mm-swapfile-make-security_vm_enough_memory_mm-work-as-expected.patch
mm-swapfile-fix-possible-data-races-of-inuse_pages.patch
mm-swap-remove-swap_cache_info-statistics.patch

