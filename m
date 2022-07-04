Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80972C43334
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:12:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233074AbiGDBMI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233000AbiGDBLG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:11:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E5C7638F
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:10:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43DAEB80BD1
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:10:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB4B6C341C6;
        Mon,  4 Jul 2022 01:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656897037;
        bh=kKM0s0snptL0ybvlernladkR/riT93VLj4FuM1uJ6As=;
        h=Date:To:From:Subject:From;
        b=I1EoVzxDwQYgqiMYxGAOvsJ4SR2VQ3CzMiS3ZyqP9t6+36voLCROtuZnPsKEPEDho
         WCIUOPM/QjK7G/FWPnOlSQD9a5LzfmLKaiVRxMY4BIhSyYHar7Fb/zjVvPm1Xjt/sE
         1qB03HZ/op+/Temli023VMBQfADm3ScA/PePyu8M=
Date:   Sun, 03 Jul 2022 18:10:36 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-convert-__put_single_page-to-__folio_put_small.patch removed from -mm tree
Message-Id: <20220704011036.EB4B6C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swap: convert __put_single_page() to __folio_put_small()
has been removed from the -mm tree.  Its filename was
     mm-swap-convert-__put_single_page-to-__folio_put_small.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/swap: convert __put_single_page() to __folio_put_small()
Date: Fri, 17 Jun 2022 18:50:14 +0100

Saves 56 bytes of text by removing a call to compound_head().

Link: https://lkml.kernel.org/r/20220617175020.717127-17-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/swap.c~mm-swap-convert-__put_single_page-to-__folio_put_small
+++ a/mm/swap.c
@@ -99,11 +99,11 @@ static void __page_cache_release(struct
 	}
 }
 
-static void __put_single_page(struct page *page)
+static void __folio_put_small(struct folio *folio)
 {
-	__page_cache_release(page);
-	mem_cgroup_uncharge(page_folio(page));
-	free_unref_page(page, 0);
+	__page_cache_release(&folio->page);
+	mem_cgroup_uncharge(folio);
+	free_unref_page(&folio->page, 0);
 }
 
 static void __put_compound_page(struct page *page)
@@ -126,7 +126,7 @@ void __folio_put(struct folio *folio)
 	else if (unlikely(folio_test_large(folio)))
 		__put_compound_page(&folio->page);
 	else
-		__put_single_page(&folio->page);
+		__folio_put_small(folio);
 }
 EXPORT_SYMBOL(__folio_put);
 
_

Patches currently in -mm which might be from willy@infradead.org are

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

