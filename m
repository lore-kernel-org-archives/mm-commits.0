Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D98DC2B9F2
	for <mm-commits@archiver.kernel.org>; Sat, 22 May 2021 19:54:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C039F61163
	for <mm-commits@archiver.kernel.org>; Sat, 22 May 2021 19:54:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbhEVT4W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 May 2021 15:56:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:36398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231311AbhEVT4V (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 22 May 2021 15:56:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F14D61003;
        Sat, 22 May 2021 19:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621713295;
        bh=nGE1qKAEcIhhL98RKyfHNI1LfbsSkZlXOzZNB0qI9RA=;
        h=Date:From:To:Subject:From;
        b=C3e6qLvd/zm5c91JY+xXGQrLfZaFUblS+n7d4SmP7IzSsw81PwztLRYd8gOufcDYY
         CPMc3kvTHM/WMI9L+X8sBImRp8W9Dlo1Z+GgFuDC6L/3beR/EBkZ99eDdio6pOb2se
         gl6LbjqSsJ7mhEwufNBYeb1PNF4tRB889sa7KWcQ=
Date:   Sat, 22 May 2021 12:54:54 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, eugenis@google.com,
        mm-commits@vger.kernel.org, pcc@google.com
Subject:  [folded-merged]
 mm-improve-mprotectrw-efficiency-on-pages-referenced-once-fix.patch removed
 from -mm tree
Message-ID: <20210522195454.qO-oQRC72%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-improve-mprotectrw-efficiency-on-pages-referenced-once-fix
has been removed from the -mm tree.  Its filename was
     mm-improve-mprotectrw-efficiency-on-pages-referenced-once-fix.patch

This patch was dropped because it was folded into mm-improve-mprotectrw-efficiency-on-pages-referenced-once.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-improve-mprotectrw-efficiency-on-pages-referenced-once-fix

avoid 80-column tricks

Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/mprotect.c~mm-improve-mprotectrw-efficiency-on-pages-referenced-once-fix
+++ a/mm/mprotect.c
@@ -47,8 +47,9 @@ static unsigned long change_pte_range(st
 	bool prot_numa = cp_flags & MM_CP_PROT_NUMA;
 	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
 	bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
-	bool anon_writable =
-		vma_is_anonymous(vma) && (vma->vm_flags & VM_WRITE);
+	bool anon_writable;
+
+	anon_writable = vma_is_anonymous(vma) && (vma->vm_flags & VM_WRITE);
 
 	/*
 	 * Can be called with only the mmap_lock for reading by
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5-fix.patch
mm-improve-mprotectrw-efficiency-on-pages-referenced-once.patch
binfmt-remove-in-tree-usage-of-map_executable-fix.patch
mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
powerpc-mm-book3s64-update-tlb-flush-routines-to-take-a-page-walk-cache-flush-argument-fix.patch
mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush-fix.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix.patch
nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
kernelh-split-out-panic-and-oops-helpers-fix.patch
lib-decompressors-remove-set-but-not-used-variabled-level-fix.patch
linux-next-git-rejects.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

