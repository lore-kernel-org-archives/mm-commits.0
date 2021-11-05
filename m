Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A34BEC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:38:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FFCC61262
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:38:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233277AbhKEUlC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:41:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:35770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232476AbhKEUlC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:41:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C457C60174;
        Fri,  5 Nov 2021 20:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144702;
        bh=/5P1kFsDt2rnxtQraJN9QoS2RlQR3nyp2CXKI0+oaHw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=KeV+hYAGxCpYKI9ECVB5KlYlEoNOivfvMPUE1KHHntJs8ZCyAClWepw7phznmJEYE
         9c/vnj6gymOID0vKwUcEd66y0PIwneU4Fq7bYprnEyGYFgSRLIfkWqslNPS227eGYj
         43N+dWR3JO/jYVdnhRqjh8nSAEDIU3PLWjV38WEY=
Date:   Fri, 05 Nov 2021 13:38:21 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org,
        andrew.cooper3@citrix.com, dave.hansen@linux.intel.com,
        linux-mm@kvack.org, luto@kernel.org, mm-commits@vger.kernel.org,
        namit@vmware.com, npiggin@gmail.com, peterz@infradead.org,
        tglx@linutronix.de, torvalds@linux-foundation.org, will@kernel.org,
        yuzhao@google.com
Subject:  [patch 071/262] mm/memory.c: use correct VMA flags when
 freeing page-tables
Message-ID: <20211105203821.mV5HWKCGr%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
