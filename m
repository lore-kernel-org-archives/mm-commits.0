Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B82A5C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:22:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383696AbiEMTWg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383807AbiEMTWT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:22:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B1ED3B01E
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C74FE6225A
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC4AC34113;
        Fri, 13 May 2022 19:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469703;
        bh=H6ifKKoKeBUa6ZcjKxdu8Wnjnvbe0phA9pzTA1haXMc=;
        h=Date:To:From:Subject:From;
        b=Fs8TBBs4SzKU+DReepalPf3QWme2q9kqYUf5J0P7L6Awkjdj7mir/ZCvOkt5FkkOA
         JoTn6WyjA866YVN0Vsbh2VteGG/7kzSLPcy2oNbOWrZ+O847OD4z8z49OK/Q1Ml5gW
         +8jPZvsrwLvMFSWwANEImjvVTbr53ovchDY2MLE8=
Date:   Fri, 13 May 2022 12:21:42 -0700
To:     mm-commits@vger.kernel.org, lkp@intel.com, hch@lst.de,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] alpha-fix-alloc_zeroed_user_highpage_movable.patch removed from -mm tree
Message-Id: <20220513192143.2AC4AC34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: alpha: fix alloc_zeroed_user_highpage_movable()
has been removed from the -mm tree.  Its filename was
     alpha-fix-alloc_zeroed_user_highpage_movable.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: alpha: fix alloc_zeroed_user_highpage_movable()

Due to a typo, the final argument to alloc_page_vma() didn't refer to a
real variable.  This only affected CONFIG_NUMA, which was marked BROKEN in
2006 and removed from alpha in 2021.  Found due to a refactoring patch.

Link: https://lkml.kernel.org/r/20220504182857.4013401-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/page.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/alpha/include/asm/page.h~alpha-fix-alloc_zeroed_user_highpage_movable
+++ a/arch/alpha/include/asm/page.h
@@ -18,7 +18,7 @@ extern void clear_page(void *page);
 #define clear_user_page(page, vaddr, pg)	clear_page(page)
 
 #define alloc_zeroed_user_highpage_movable(vma, vaddr) \
-	alloc_page_vma(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, vma, vmaddr)
+	alloc_page_vma(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, vma, vaddr)
 #define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE_MOVABLE
 
 extern void copy_page(void * _to, void * _from);
_

Patches currently in -mm which might be from willy@infradead.org are

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

