Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FB0EC47089
	for <mm-commits@archiver.kernel.org>; Wed, 26 May 2021 20:28:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A02D613CA
	for <mm-commits@archiver.kernel.org>; Wed, 26 May 2021 20:28:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232696AbhEZUaU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 May 2021 16:30:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232201AbhEZUaU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 26 May 2021 16:30:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5C46613DE;
        Wed, 26 May 2021 20:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622060927;
        bh=cEKGryvw30+i+XvTmcs0YCpYKN+IBD/jjkhkTzAK4VY=;
        h=Date:From:To:Subject:From;
        b=dDC28R1/Wle/4QC+Fjmpf3nKDubGaOzMntAmUEVo/Sdv/ULry1i80/MRUvvkS9yag
         16/Ykb34Q5Nr9AKgiD6qh2tKjJ9sKoJGmuS+BWD6F41suHfiSfAAzbhY2yr62KClNW
         hCLISp+xMK7MMCl04OlfRRK6EXZiShK864oSowVI=
Date:   Wed, 26 May 2021 13:28:47 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, hughd@google.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com
Subject:  + mm-rmap-make-try_to_unmap-void-function-fix.patch added
 to -mm tree
Message-ID: <20210526202847.QO-1S03Am%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-rmap-make-try_to_unmap-void-function-fix
has been added to the -mm tree.  Its filename is
     mm-rmap-make-try_to_unmap-void-function-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-rmap-make-try_to_unmap-void-function-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-rmap-make-try_to_unmap-void-function-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-rmap-make-try_to_unmap-void-function-fix

fix comment grammar

Cc: Hugh Dickins <hughd@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/rmap.c~mm-rmap-make-try_to_unmap-void-function-fix
+++ a/mm/rmap.c
@@ -1660,8 +1660,8 @@ static int page_not_mapped(struct page *
  * page and the compound page it belongs to, used in the pageout path.
  * Caller must hold the page lock.
  *
- * It is the callers' responsibility to check if the page is still
- * mapped when needed.
+ * It is the caller's responsibility to check if the page is still mapped when
+ * needed.
  */
 void try_to_unmap(struct page *page, enum ttu_flags flags)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-hugetlb-fix-resv_huge_pages-underflow-on-uffdio_copy-fix.patch
mm.patch
mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5-fix.patch
binfmt-remove-in-tree-usage-of-map_executable-fix.patch
mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
powerpc-mm-book3s64-update-tlb-flush-routines-to-take-a-page-walk-cache-flush-argument-fix.patch
mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush-fix.patch
mm-memory-failure-use-a-mutex-to-avoid-memory_failure-races-fix.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
mm-userfaultfd-fix-uffd-wp-special-cases-for-fork-fix.patch
mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix.patch
mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix-fix.patch
nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
mm-rmap-make-try_to_unmap-void-function-fix.patch
mm-early_ioremap-add-prototype-for-early_memremap_pgprot_adjust-fix.patch
kernelh-split-out-panic-and-oops-helpers-fix.patch
lib-math-rational-add-kunit-test-cases-fix.patch
lib-decompressors-remove-set-but-not-used-variabled-level-fix.patch
linux-next-pre.patch
linux-next-post.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

