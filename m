Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AB7EC11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:29:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F8E7611F1
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:29:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232173AbhF2Abs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 20:31:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:60764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232170AbhF2Abr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 20:31:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A6D661CE5;
        Tue, 29 Jun 2021 00:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624926561;
        bh=nmpM2SbWS6winCOuu2arZVd6h+b9RczVi/FAdh+TfW8=;
        h=Date:From:To:Subject:From;
        b=xYpTjvvQxq8Brnynyy8mpxtwtC5UyaoHMrZSm6pmAdE0pE6MaKcH/rapMOw/urinF
         xMJMrfbn1DypYhGx8Bwy9Hcg9R8uKQO8HTnduLvbNIamp0jVtZKEe/OcSot6ZIo0ln
         pQEWB2lmIbIdiByd9q5MggIc2z3hL8zgXqEK6xGE=
Date:   Mon, 28 Jun 2021 17:29:21 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, liam.howlett@oracle.com,
        mm-commits@vger.kernel.org, willy@infradead.org
Subject:  [folded-merged]
 mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch removed from -mm
 tree
Message-ID: <20210629002921.TCr6iuRPl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mmap-introduce-unlock_range-for-code-cleanup-fix
has been removed from the -mm tree.  Its filename was
     mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch

This patch was dropped because it was folded into mm-mmap-introduce-unlock_range-for-code-cleanup.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-mmap-introduce-unlock_range-for-code-cleanup-fix

tweak code layout

Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mmap.c~mm-mmap-introduce-unlock_range-for-code-cleanup-fix
+++ a/mm/mmap.c
@@ -2802,8 +2802,8 @@ int split_vma(struct mm_struct *mm, stru
 	return __split_vma(mm, vma, addr, new_below);
 }
 
-static inline
-void unlock_range(struct vm_area_struct *start, unsigned long limit)
+static inline void
+unlock_range(struct vm_area_struct *start, unsigned long limit)
 {
 	struct mm_struct *mm = start->vm_mm;
 	struct vm_area_struct *tmp = start;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mmap-introduce-unlock_range-for-code-cleanup.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix-checkpatch-fixes.patch
mm.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
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
kernel-cgroup-cgroupc-dont-export-cgroup_get_e_css-twice.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

