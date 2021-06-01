Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BF1BC47082
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 03:18:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39E696135D
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 03:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232515AbhFADUi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 May 2021 23:20:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232503AbhFADUi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 31 May 2021 23:20:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD0D460FEE;
        Tue,  1 Jun 2021 03:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622517538;
        bh=DYfX77a1pD/rFYis6LMUVpdhyLXLOfQ9BjdJ4RDJbPc=;
        h=Date:From:To:Subject:From;
        b=bqFP5A8svMhXfkHQe8Wk1hYPohV/NtyuJRiPyZeOA40IiujKYzYqsKKj5oEz0sR3R
         M+3sRcy+b0Cq4JAZ5vrKD/9Uvo2SsR8xqA5OMrEeFwZEXKJFc3x3xLkS9ou/cgmY1D
         YwmBsRJ6v7S6L6RbW7VoGIGv1g02Zdbq0nhaIErk=
Date:   Mon, 31 May 2021 20:18:57 -0700
From:   akpm@linux-foundation.org
To:     aisheng.dong@nxp.com, akpm@linux-foundation.org, bhe@redhat.com,
        dyoung@redhat.com, mm-commits@vger.kernel.org, vgoyal@redhat.com
Subject:  +
 mm-rename-the-global-section-array-to-mem_sections-fix-fix.patch added to
 -mm tree
Message-ID: <20210601031857.gcJs1AqgY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-rename-the-global-section-array-to-mem_sections-fix-fix
has been added to the -mm tree.  Its filename is
     mm-rename-the-global-section-array-to-mem_sections-fix-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-rename-the-global-section-array-to-mem_sections-fix-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-rename-the-global-section-array-to-mem_sections-fix-fix.patch

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
Subject: mm-rename-the-global-section-array-to-mem_sections-fix-fix

fix another site

Cc: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Dong Aisheng <aisheng.dong@nxp.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/sparse.c~mm-rename-the-global-section-array-to-mem_sections-fix-fix
+++ a/mm/sparse.c
@@ -254,7 +254,7 @@ static void __init memory_present(int ni
 	unsigned long pfn;
 
 #ifdef CONFIG_SPARSEMEM_EXTREME
-	if (unlikely(!mem_section)) {
+	if (unlikely(!mem_sections)) {
 		unsigned long size, align;
 
 		size = sizeof(struct mem_section *) * NR_SECTION_ROOTS;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5-fix.patch
binfmt-remove-in-tree-usage-of-map_executable-fix.patch
mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
powerpc-mm-book3s64-update-tlb-flush-routines-to-take-a-page-walk-cache-flush-argument-fix.patch
mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush-fix.patch
mm-rename-the-global-section-array-to-mem_sections-fix.patch
mm-rename-the-global-section-array-to-mem_sections-fix-fix.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix-checkpatch-fixes.patch
mm-memory-failure-use-a-mutex-to-avoid-memory_failure-races-fix.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
mm-userfaultfd-fix-uffd-wp-special-cases-for-fork-fix.patch
mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix-fix.patch
nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
mm-rmap-make-try_to_unmap-void-function-fix.patch
mm-rmap-make-try_to_unmap-void-function-fix-fix.patch
mm-early_ioremap-add-prototype-for-early_memremap_pgprot_adjust-fix.patch
kernelh-split-out-panic-and-oops-helpers-fix.patch
lib-math-rational-add-kunit-test-cases-fix.patch
lib-decompressors-remove-set-but-not-used-variabled-level-fix.patch
ipc-utilc-use-binary-search-for-max_idx-fix.patch
linux-next-pre.patch
linux-next-post.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

