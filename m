Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F370C47082
	for <mm-commits@archiver.kernel.org>; Wed, 26 May 2021 23:39:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7371F613DA
	for <mm-commits@archiver.kernel.org>; Wed, 26 May 2021 23:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234517AbhEZXkz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 May 2021 19:40:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:36888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234145AbhEZXkz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 26 May 2021 19:40:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2AA28613BE;
        Wed, 26 May 2021 23:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622072362;
        bh=GeFUNM1Sml6ZQgiZ0X3ooW5Ai9cgNBv2C0kVQZsdvQc=;
        h=Date:From:To:Subject:From;
        b=FL5JtIURCTEEJx1xoDIiE9AvyCNN1ZTE7xWxwI/uJKGNk/GuDJV86j6+4zVvyzzNg
         mkbTRCvsct/dQecpuEhnndFyUS6Qoqik6Q+8/adhkHXud2gh8aZEu2sEzSuaMhjyhC
         yg4nyLyJpYBczDmjNXafWLp/gqk6L+irvC5hHe6U=
Date:   Wed, 26 May 2021 16:39:21 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, andrii.nakryiko@gmail.com,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org
Subject:  +
 =?US-ASCII?Q?mm-page=5Falloc-convert-per-cpu-list-protection-to-local?=
 =?US-ASCII?Q?=5Flock-fix-checkpatch-fixes.patch?= added to -mm tree
Message-ID: <20210526233921.BMDqcHSDO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix-checkpatch-fixes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix-checkpatch-fixes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix-checkpatch-fixes.patch

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
Subject: mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix-checkpatch-fixes

WARNING: Non-standard signature: Debugged-by:
#77: 
Debugged-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>

WARNING: please, no spaces at the start of a line
#117: FILE: mm/page_alloc.c:128:
+    !defined(CONFIG_DEBUG_LOCK_ALLOC) &&^I^I\$

WARNING: please, no spaces at the start of a line
#118: FILE: mm/page_alloc.c:129:
+    !defined(CONFIG_PAHOLE_HAS_ZEROSIZE_PERCPU_SUPPORT)$

total: 0 errors, 3 warnings, 26 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix-checkpatch-fixes
+++ a/mm/page_alloc.c
@@ -124,9 +124,9 @@ static DEFINE_MUTEX(pcp_batch_high_lock)
 
 struct pagesets {
 	local_lock_t lock;
-#if defined(CONFIG_DEBUG_INFO_BTF) &&			\
-    !defined(CONFIG_DEBUG_LOCK_ALLOC) &&		\
-    !defined(CONFIG_PAHOLE_HAS_ZEROSIZE_PERCPU_SUPPORT)
+#if defined(CONFIG_DEBUG_INFO_BTF) &&				\
+	!defined(CONFIG_DEBUG_LOCK_ALLOC) &&			\
+	!defined(CONFIG_PAHOLE_HAS_ZEROSIZE_PERCPU_SUPPORT)
 	/*
 	 * pahole 1.21 and earlier gets confused by zero-sized per-CPU
 	 * variables and produces invalid BTF. Ensure that
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
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix-checkpatch-fixes.patch
mm-memory-failure-use-a-mutex-to-avoid-memory_failure-races-fix.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
mm-userfaultfd-fix-uffd-wp-special-cases-for-fork-fix.patch
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

