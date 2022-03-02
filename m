Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D551C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  2 Mar 2022 23:52:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbiCBXxT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Mar 2022 18:53:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiCBXxS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Mar 2022 18:53:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC84A41B4
        for <mm-commits@vger.kernel.org>; Wed,  2 Mar 2022 15:52:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0DACAB8228B
        for <mm-commits@vger.kernel.org>; Wed,  2 Mar 2022 23:27:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98192C004E1;
        Wed,  2 Mar 2022 23:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646263644;
        bh=lKzeu9o264Wcq2fQDIq+exJtAZDn6Guw74g5AMdy+nQ=;
        h=Date:To:From:Subject:From;
        b=l+atkKNZyfE5UBV6iaxESLR2IOpICALbqcpDmJGI0FFhv5TRWjDXSaFNcU4mZQ/o6
         ZJhdXIgzi+ZCM31j+3kYrzDzX9Fu5EuuOkcE1PSG4KYI3mOYzpE3Ze6LV7mGUofLaG
         ++ge4649/8AeqRudeT4rbveE1CdF4IA0zoGJ3D14=
Date:   Wed, 02 Mar 2022 15:27:23 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        william.kucharski@oracle.com, songmuchun@bytedance.com,
        shy828301@gmail.com, peterx@redhat.com, hughd@google.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-make-is_transparent_hugepage-static.patch added to -mm tree
Message-Id: <20220302232724.98192C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory: make is_transparent_hugepage() static
has been added to the -mm tree.  Its filename is
     mm-huge_memory-make-is_transparent_hugepage-static.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-huge_memory-make-is_transparent_hugepage-static.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-huge_memory-make-is_transparent_hugepage-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/huge_memory: make is_transparent_hugepage() static

It's only used inside the huge_memory.c now. Don't export it and make
it static. We can thus reduce the size of huge_memory.o a bit.

Without this patch:
   text	   data	    bss	    dec	    hex	filename
  32319	   2965	      4	  35288	   89d8	mm/huge_memory.o

With this patch:
   text	   data	    bss	    dec	    hex	filename
  32042	   2957	      4	  35003	   88bb	mm/huge_memory.o

Link: https://lkml.kernel.org/r/20220302082145.12028-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    6 ------
 mm/huge_memory.c        |    3 +--
 2 files changed, 1 insertion(+), 8 deletions(-)

--- a/include/linux/huge_mm.h~mm-huge_memory-make-is_transparent_hugepage-static
+++ a/include/linux/huge_mm.h
@@ -183,7 +183,6 @@ unsigned long thp_get_unmapped_area(stru
 
 void prep_transhuge_page(struct page *page);
 void free_transhuge_page(struct page *page);
-bool is_transparent_hugepage(struct page *page);
 
 bool can_split_folio(struct folio *folio, int *pextra_pins);
 int split_huge_page_to_list(struct page *page, struct list_head *list);
@@ -341,11 +340,6 @@ static inline bool transhuge_vma_enabled
 
 static inline void prep_transhuge_page(struct page *page) {}
 
-static inline bool is_transparent_hugepage(struct page *page)
-{
-	return false;
-}
-
 #define transparent_hugepage_flags 0UL
 
 #define thp_get_unmapped_area	NULL
--- a/mm/huge_memory.c~mm-huge_memory-make-is_transparent_hugepage-static
+++ a/mm/huge_memory.c
@@ -533,7 +533,7 @@ void prep_transhuge_page(struct page *pa
 	set_compound_page_dtor(page, TRANSHUGE_PAGE_DTOR);
 }
 
-bool is_transparent_hugepage(struct page *page)
+static inline bool is_transparent_hugepage(struct page *page)
 {
 	if (!PageCompound(page))
 		return false;
@@ -542,7 +542,6 @@ bool is_transparent_hugepage(struct page
 	return is_huge_zero_page(page) ||
 	       page[1].compound_dtor == TRANSHUGE_PAGE_DTOR;
 }
-EXPORT_SYMBOL_GPL(is_transparent_hugepage);
 
 static unsigned long __thp_get_unmapped_area(struct file *filp,
 		unsigned long addr, unsigned long len,
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memremap-avoid-calling-kasan_remove_zero_shadow-for-device-private-memory.patch
filemap-remove-find_get_pages.patch
mm-writeback-minor-clean-up-for-highmem_dirtyable_memory.patch
mm-use-helper-function-range_in_vma.patch
mm-use-helper-macro-min-and-max-in-unmap_mapping_range_tree.patch
mm-sparse-make-mminit_validate_memmodel_limits-static.patch
mm-vmalloc-remove-unneeded-function-forward-declaration.patch
mm-mmzoneh-remove-unused-macros.patch
mm-memory-failurec-minor-clean-up-for-memory_failure_dev_pagemap.patch
mm-memory-failurec-catch-unexpected-efault-from-vma_address.patch
mm-memory-failurec-rework-the-signaling-logic-in-kill_proc.patch
mm-memory-failurec-fix-race-with-changing-page-more-robustly.patch
mm-memory-failurec-remove-pageslab-check-in-hwpoison_filter_dev.patch
mm-memory-failurec-rework-the-try_to_unmap-logic-in-hwpoison_user_mappings.patch
mm-memory-failurec-remove-obsolete-comment-in-__soft_offline_page.patch
mm-memory-failurec-remove-unnecessary-pagetranstail-check.patch
mm-hwpoison-inject-support-injecting-hwpoison-to-free-page.patch
mm-memory-failurec-fix-race-with-changing-page-compound-again.patch
mm-memory-failurec-fix-wrong-user-reference-report.patch
mm-memory-failurec-avoid-calling-invalidate_inode_page-with-unexpected-pages.patch
mm-memory-failurec-fix-potential-vm_bug_on_page-in-split_huge_page_to_list.patch
mm-hugetlb-use-helper-macro-__attr_rw.patch
mm-oom_kill-remove-unneeded-is_memcg_oom-check.patch
mm-ksm-use-helper-macro-__attr_rw.patch
mm-balloon_compaction-make-balloon-page-compaction-callbacks-static.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages.patch
mm-memory_hotplug-avoid-calling-zone_intersects-for-zone_normal.patch
mm-memory_hotplug-clean-up-try_offline_node.patch
mm-memory_hotplug-fix-misplaced-comment-in-offline_pages.patch
mm-highmem-remove-unnecessary-done-label.patch
mm-hmmc-remove-unneeded-local-variable-ret.patch
kernel-ksysfsc-use-helper-macro-__attr_rw.patch
kernel-resource-fix-kfree-of-bootmem-memory-again.patch
mm-huge_memory-make-is_transparent_hugepage-static.patch

