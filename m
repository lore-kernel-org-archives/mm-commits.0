Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 552A5C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 03:09:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E56C6154B
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 03:09:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbhJVDLv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Oct 2021 23:11:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:36776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230349AbhJVDLu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 21 Oct 2021 23:11:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E248E613B1;
        Fri, 22 Oct 2021 03:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634872061;
        bh=KBlICRULSAvos+s1klr9NW+EsPupor6b6qJpdSsr+3Y=;
        h=Date:From:To:Subject:From;
        b=nhI92Z66GG/SpoqLm4RRWWS3MFcFkHfOkchUa89CU4wUt5KtvCRNk0yrs19esABFt
         nDmzGRfLviauaDaF2+PLJ9k47QXDFvolX3mLPS1ssD/pukY3N3rmOjF/0NWYrG1Saz
         b8x4HpELLgvNhsnbrOtPxLvzo/Mwysza4ThIoeFA=
Date:   Thu, 21 Oct 2021 20:07:40 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, andrew.cooper3@citrix.com,
        dave.hansen@linux.intel.com, luto@kernel.org,
        mm-commits@vger.kernel.org, namit@vmware.com, npiggin@gmail.com,
        peterz@infradead.org, tglx@linutronix.de, will@kernel.org,
        yuzhao@google.com
Subject:  + mm-use-correct-vma-flags-when-freeing-page-tables.patch
 added to -mm tree
Message-ID: <20211022030740.FBNXKAygo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: use correct VMA flags when freeing page-tables
has been added to the -mm tree.  Its filename is
     mm-use-correct-vma-flags-when-freeing-page-tables.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-use-correct-vma-flags-when-freeing-page-tables.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-use-correct-vma-flags-when-freeing-page-tables.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-use-correct-vma-flags-when-freeing-page-tables.patch

