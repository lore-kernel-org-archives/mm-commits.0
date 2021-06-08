Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E77AC48BCF
	for <mm-commits@archiver.kernel.org>; Tue,  8 Jun 2021 00:27:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 377DD61260
	for <mm-commits@archiver.kernel.org>; Tue,  8 Jun 2021 00:27:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbhFHA2y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Jun 2021 20:28:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:45356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230516AbhFHA2x (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Jun 2021 20:28:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CF9260FDA;
        Tue,  8 Jun 2021 00:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623112006;
        bh=l5x1CjGKYMS6wWQ6H+6vlDN2JpKqiAYzyHhROXdTJ5g=;
        h=Date:From:To:Subject:From;
        b=niiJi9jw8Sy2cr/mmyX5JjtQla5QUIWN9zUMV7ElZeSHd0ZilIpcey1hNP1rSmjW6
         PNInI9sy1Scm8N4W/HnexQRt7+N2ZS+LX9gVsVMzSGSt/UjU0HBWwzg1FW18xp28HI
         bX8jTp80lIzKuIxlxPkz0oBQ4NDdEvt9YxodocQk=
Date:   Mon, 07 Jun 2021 17:26:46 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        rppt@kernel.org, wangkefeng.wang@huawei.com
Subject:  [failures]
 mm-add-setup_initial_init_mm-helper-v3-fix.patch removed from -mm tree
Message-ID: <20210608002646.l8Uvj3C8M%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-add-setup_initial_init_mm-helper-v3-fix
has been removed from the -mm tree.  Its filename was
     mm-add-setup_initial_init_mm-helper-v3-fix.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-setup_initial_init_mm-helper-v3-fix

fix merge thing

Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    8 --------
 1 file changed, 8 deletions(-)

--- a/include/linux/mm_types.h~mm-add-setup_initial_init_mm-helper-v3-fix
+++ a/include/linux/mm_types.h
@@ -562,14 +562,6 @@ struct mm_struct {
 };
 
 extern struct mm_struct init_mm;
-static inline void setup_initial_init_mm(void *start_code, void *end_code,
-					 void *end_data, void *brk)
-{
-	init_mm.start_code = (unsigned long)start_code;
-	init_mm.end_code = (unsigned long)end_code;
-	init_mm.end_data = (unsigned long)end_data;
-	init_mm.brk = (unsigned long)brk;
-}
 
 /* Pointer magic because the dynamic array size confuses some compilers. */
 static inline void mm_init_cpumask(struct mm_struct *mm)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2.patch
slub-force-on-no_hash_pointers-when-slub_debug-is-enabled-fix.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5-fix.patch
binfmt-remove-in-tree-usage-of-map_executable-fix.patch
mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix-checkpatch-fixes.patch
mm-memory-failure-use-a-mutex-to-avoid-memory_failure-races-fix.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
mm-userfaultfd-fix-uffd-wp-special-cases-for-fork-fix.patch
nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
mmmemory_hotplug-drop-unneeded-locking-fix.patch
fs-proc-kcorec-add-mmap-interface-fix.patch
kernelh-split-out-panic-and-oops-helpers-fix.patch
lib-math-rational-add-kunit-test-cases-fix.patch
lib-decompressors-remove-set-but-not-used-variabled-level-fix.patch
ipc-utilc-use-binary-search-for-max_idx-fix.patch
linux-next-pre.patch
linux-next-post.patch
linux-next-rejects.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

