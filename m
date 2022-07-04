Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B962CCA473
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:11:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232848AbiGDBLL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232738AbiGDBKP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:10:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74EE16274
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BD91B80C73
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6713C341C7;
        Mon,  4 Jul 2022 01:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656897011;
        bh=lhyXFE586y1tfvTiXmJlUuswS10ShjqO0+I9k7UTDWA=;
        h=Date:To:From:Subject:From;
        b=i8XJ5gUvAbUMCon+ezVXT2+zjYsh1AAudsaYAT4c5cieTN44AGTvYW/WW3BVrhNFp
         oWmMQVjaQD6w0uKQmg8QXwTc3XfbBAh8fW2QEeQWrVep9fkMFaWMGslLjVPm23u3B7
         cwvt1xoKKuYRT54bC0eV1JqbAivMPfSqqTgJlyGI=
Date:   Sun, 03 Jul 2022 18:10:11 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-folios_put.patch removed from -mm tree
Message-Id: <20220704011011.B6713C341C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: add folios_put()
has been removed from the -mm tree.  Its filename was
     mm-add-folios_put.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add folios_put()
Date: Fri, 17 Jun 2022 18:49:59 +0100

Patch series "Convert the swap code to be more folio-based".

There's still more to do with the swap code, but this reaps a lot of the
folio benefit.  More than 4kB of kernel text saved (with the UEK7 kernel
config).  I don't know how much that's going to translate into CPU
savings, but some of those compound_head() calls are on every page free,
so it should be noticable.  It might even be noticable just from an
I-cache consumption perspective.


This patch (of 22):

This is just a wrapper around release_pages() for now.  Place the
prototype in mm.h along with folio_put() and folio_put_refs().

Link: https://lkml.kernel.org/r/20220617175020.717127-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20220617175020.717127-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h      |   19 +++++++++++++++++++
 include/linux/pagemap.h |    2 --
 2 files changed, 19 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-add-folios_put
+++ a/include/linux/mm.h
@@ -1220,6 +1220,25 @@ static inline void folio_put_refs(struct
 		__put_page(&folio->page);
 }
 
+void release_pages(struct page **pages, int nr);
+
+/**
+ * folios_put - Decrement the reference count on an array of folios.
+ * @folios: The folios.
+ * @nr: How many folios there are.
+ *
+ * Like folio_put(), but for an array of folios.  This is more efficient
+ * than writing the loop yourself as it will optimise the locks which
+ * need to be taken if the folios are freed.
+ *
+ * Context: May be called in process or interrupt context, but not in NMI
+ * context.  May be called while holding a spinlock.
+ */
+static inline void folios_put(struct folio **folios, unsigned int nr)
+{
+	release_pages((struct page **)folios, nr);
+}
+
 static inline void put_page(struct page *page)
 {
 	struct folio *folio = page_folio(page);
--- a/include/linux/pagemap.h~mm-add-folios_put
+++ a/include/linux/pagemap.h
@@ -345,8 +345,6 @@ static inline void filemap_nr_thps_dec(s
 #endif
 }
 
-void release_pages(struct page **pages, int nr);
-
 struct address_space *page_mapping(struct page *);
 struct address_space *folio_mapping(struct folio *);
 struct address_space *swapcache_mapping(struct folio *);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-swap-add-folio_batch_move_lru.patch
mm-swap-make-__pagevec_lru_add-static.patch
mm-swap-convert-lru_add-to-a-folio_batch.patch
mm-swap-convert-lru_deactivate_file-to-a-folio_batch.patch
mm-swap-convert-lru_deactivate-to-a-folio_batch.patch
mm-swap-convert-lru_lazyfree-to-a-folio_batch.patch
mm-swap-convert-activate_page-to-a-folio_batch.patch
mm-swap-rename-lru_pvecs-to-cpu_fbatches.patch
mm-swap-pull-the-cpu-conditional-out-of-__lru_add_drain_all.patch
mm-swap-optimise-lru_add_drain_cpu.patch
mm-swap-convert-try_to_free_swap-to-use-a-folio.patch
mm-swap-convert-release_pages-to-use-a-folio-internally.patch
mm-swap-convert-put_pages_list-to-use-folios.patch
mm-swap-convert-__put_page-to-__folio_put.patch
mm-swap-convert-__put_single_page-to-__folio_put_small.patch
mm-swap-convert-__put_compound_page-to-__folio_put_large.patch
mm-swap-convert-__page_cache_release-to-use-a-folio.patch
mm-convert-destroy_compound_page-to-destroy_large_folio.patch
mm-convert-page_swap_flags-to-folio_swap_flags.patch
mm-swap-convert-delete_from_swap_cache-to-take-a-folio.patch
mm-swap-convert-__delete_from_swap_cache-to-a-folio.patch
mm-add-vma-iterator.patch
mmap-use-the-vma-iterator-in-count_vma_pages_range.patch
proc-remove-vma-rbtree-use-from-nommu.patch
arm64-remove-mmap-linked-list-from-vdso.patch
parisc-remove-mmap-linked-list-from-cache-handling.patch
powerpc-remove-mmap-linked-list-walks.patch
s390-remove-vma-linked-list-walks.patch
x86-remove-vma-linked-list-walks.patch
xtensa-remove-vma-linked-list-walks.patch
cxl-remove-vma-linked-list-walk.patch
optee-remove-vma-linked-list-walk.patch
um-remove-vma-linked-list-walk.patch
coredump-remove-vma-linked-list-walk.patch
exec-use-vma-iterator-instead-of-linked-list.patch
fs-proc-task_mmu-stop-using-linked-list-and-highest_vm_end.patch
acct-use-vma-iterator-instead-of-linked-list.patch
perf-use-vma-iterator.patch
sched-use-maple-tree-iterator-to-walk-vmas.patch
fork-use-vma-iterator.patch
mm-khugepaged-stop-using-vma-linked-list.patch
mm-ksm-use-vma-iterators-instead-of-vma-linked-list.patch
mm-mlock-use-vma-iterator-and-maple-state-instead-of-vma-linked-list.patch
mm-pagewalk-use-vma_find-instead-of-vma-linked-list.patch
i915-use-the-vma-iterator.patch
nommu-remove-uses-of-vma-linked-list.patch
mips-rename-pmd_order-to-pmd_table_order.patch

