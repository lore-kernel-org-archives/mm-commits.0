Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 327BCC433F5
	for <mm-commits@archiver.kernel.org>; Mon,  8 Nov 2021 19:09:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18F8D61506
	for <mm-commits@archiver.kernel.org>; Mon,  8 Nov 2021 19:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236664AbhKHTMZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 14:12:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:53442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236660AbhKHTMZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 14:12:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 841E6610CB;
        Mon,  8 Nov 2021 19:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636398580;
        bh=U1NYqvPe/dGDteDtFCHgsrQPwYQPBNsODIIWN33Wcr8=;
        h=Date:From:To:Subject:From;
        b=Xow2ggivmZ/fXShFlEsReZcs0BKe9ncqV5/bmYPLuXb9B+aDPs/5wYEJ0WGESZW28
         pDtwYvZPRsQUEiQssisPIZ3AgaN5NRwCm2rZwAKB20EUfd04Qt6pLUzcQGSLsUIgye
         OKqzuyTqlbyEoa71UvNw5lM/vbOzkaoYMiXH4Pn0=
Date:   Mon, 08 Nov 2021 11:09:40 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, andrew.cooper3@citrix.com,
        dave.hansen@linux.intel.com, luto@kernel.org,
        mm-commits@vger.kernel.org, namit@vmware.com, npiggin@gmail.com,
        peterz@infradead.org, tglx@linutronix.de, will@kernel.org,
        yuzhao@google.com
Subject:  [to-be-updated]
 mm-use-correct-vma-flags-when-freeing-page-tables.patch removed from -mm
 tree
Message-ID: <20211108190940.OTiiia_PL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: use correct VMA flags when freeing page-tables
has been removed from the -mm tree.  Its filename was
     mm-use-correct-vma-flags-when-freeing-page-tables.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Nadav Amit <namit@vmware.com>
Subject: mm/memory.c: use correct VMA flags when freeing page-tables

Consistent use of the mmu_gather interface requires a call to
tlb_start_vma() and tlb_end_vma() for each VMA.  free_pgtables() does not
follow this pattern.

Certain architectures need tlb_start_vma() to be called in order for
tlb_update_vma_flags() to update the VMA flags (tlb->vma_exec and
tlb->vma_huge), which are later used for the proper TLB flush to be
issued.  Since tlb_start_vma() is not called, this can lead to the wrong
VMA flags being used when the flush is performed.

Specifically, the munmap syscall would call unmap_region(), which unmaps
the VMAs and then frees the page-tables.  A flush is needed after the
page-tables are removed to prevent page-walk caches from holding stale
entries, but this flush would use the flags of the VMA flags of the last
VMA that was flushed.  This does not appear to be right.

Use tlb_start_vma() and tlb_end_vma() to prevent this from happening. 
This might lead to unnecessary calls to flush_cache_range() on certain
arch's.  If needed, a new flag can be added to mmu_gather to indicate that
the flush is not needed.

Link: https://lkml.kernel.org/r/20211021122322.592822-1-namit@vmware.com
Signed-off-by: Nadav Amit <namit@vmware.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Nick Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/memory.c~mm-use-correct-vma-flags-when-freeing-page-tables
+++ a/mm/memory.c
@@ -412,6 +412,8 @@ void free_pgtables(struct mmu_gather *tl
 		unlink_anon_vmas(vma);
 		unlink_file_vma(vma);
 
+		tlb_start_vma(tlb, vma);
+
 		if (is_vm_hugetlb_page(vma)) {
 			hugetlb_free_pgd_range(tlb, addr, vma->vm_end,
 				floor, next ? next->vm_start : ceiling);
@@ -429,6 +431,8 @@ void free_pgtables(struct mmu_gather *tl
 			free_pgd_range(tlb, addr, vma->vm_end,
 				floor, next ? next->vm_start : ceiling);
 		}
+
+		tlb_end_vma(tlb, vma);
 		vma = next;
 	}
 }
_

Patches currently in -mm which might be from namit@vmware.com are


