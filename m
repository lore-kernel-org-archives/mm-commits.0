Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DCAFC2B9F4
	for <mm-commits@archiver.kernel.org>; Thu, 17 Jun 2021 04:04:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA829613E7
	for <mm-commits@archiver.kernel.org>; Thu, 17 Jun 2021 04:04:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbhFQEG1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Jun 2021 00:06:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:56936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229447AbhFQEG0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 17 Jun 2021 00:06:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DACD5611CE;
        Thu, 17 Jun 2021 04:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623902659;
        bh=rR45cGcI8pZbJl8s59j6S0RNgeHhR+jYem8JmZOZNA0=;
        h=Date:From:To:Subject:From;
        b=zqxVrLJd5nktF3wzCK26iZT1vdAYfdd7JSIscC5PVOvlxhZN8uVprTcwAqbfh5g0G
         xEft/2QiPuuF5SPcy9IUeS04uSf20dqVVd5jbL5fhDDHy0nyb9ej8sgigz2PAh/aFz
         +2U0UBpdc1hTEOndQKmB8Kh74zXUZLvnGchfu65I=
Date:   Wed, 16 Jun 2021 21:04:18 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, christophe.leroy@csgroup.eu,
        hughd@google.com, joel@joelfernandes.org, kaleshsingh@google.com,
        kirill.shutemov@linux.intel.com, kirill@shutemov.name,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com,
        sfr@canb.auug.org.au, stable@vger.kernel.org
Subject:  +
 =?US-ASCII?Q?mm-mremap-hold-the-rmap-lock-in-write-mode-when-moving-page?=
 =?US-ASCII?Q?-table-entries.patch?= added to -mm tree
Message-ID: <20210617040418.z3vLPx-r9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap: hold the rmap lock in write mode when moving page table entries.
has been added to the -mm tree.  Its filename is
     mm-mremap-hold-the-rmap-lock-in-write-mode-when-moving-page-table-entries.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mremap-hold-the-rmap-lock-in-write-mode-when-moving-page-table-entries.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mremap-hold-the-rmap-lock-in-write-mode-when-moving-page-table-entries.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/mremap: hold the rmap lock in write mode when moving page table entries.

To avoid a race between rmap walk and mremap, mremap does
take_rmap_locks().  The lock was taken to ensure that rmap walk don't miss
a page table entry due to PTE moves via move_pagetables().  The kernel
does further optimization of this lock such that if we are going to find
the newly added vma after the old vma, the rmap lock is not taken.  This
is because rmap walk would find the vmas in the same order and if we don't
find the page table attached to older vma we would find it with the new
vma which we would iterate later.

As explained in commit eb66ae030829 ("mremap: properly flush TLB before
releasing the page") mremap is special in that it doesn't take ownership
of the page.  The optimized version for PUD/PMD aligned mremap also
doesn't hold the ptl lock.  This can result in stale TLB entries as show
below.

This patch updates the rmap locking requirement in mremap to handle the race condition
explained below with optimized mremap::

Optmized PMD move

    CPU 1                           CPU 2                                   CPU 3

    mremap(old_addr, new_addr)      page_shrinker/try_to_unmap_one

    mmap_write_lock_killable()

                                    addr = old_addr
                                    lock(pte_ptl)
    lock(pmd_ptl)
    pmd = *old_pmd
    pmd_clear(old_pmd)
    flush_tlb_range(old_addr)

    *new_pmd = pmd
                                                                            *new_addr = 10; and fills
                                                                            TLB with new addr
                                                                            and old pfn

    unlock(pmd_ptl)
                                    ptep_clear_flush()
                                    old pfn is free.
                                                                            Stale TLB entry

Optimized PUD move also suffers from a similar race.  Both the above race
condition can be fixed if we force mremap path to take rmap lock.

Link: https://lkml.kernel.org/r/20210616045239.370802-7-aneesh.kumar@linux.ibm.com
Fixes: 2c91bd4a4e2e ("mm: speed up mremap by 20x on large regions")
Fixes: c49dd3401802 ("mm: speedup mremap on 1GB or larger regions")
Link: https://lore.kernel.org/linux-mm/CAHk-=wgXVR04eBNtxQfevontWnP6FDm+oj5vauQXP3S-huwbPw@mail.gmail.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mremap.c~mm-mremap-hold-the-rmap-lock-in-write-mode-when-moving-page-table-entries
+++ a/mm/mremap.c
@@ -503,7 +503,7 @@ unsigned long move_page_tables(struct vm
 		} else if (IS_ENABLED(CONFIG_HAVE_MOVE_PUD) && extent == PUD_SIZE) {
 
 			if (move_pgt_entry(NORMAL_PUD, vma, old_addr, new_addr,
-					   old_pud, new_pud, need_rmap_locks))
+					   old_pud, new_pud, true))
 				continue;
 		}
 
@@ -530,7 +530,7 @@ unsigned long move_page_tables(struct vm
 			 * moving at the PMD level if possible.
 			 */
 			if (move_pgt_entry(NORMAL_PMD, vma, old_addr, new_addr,
-					   old_pmd, new_pmd, need_rmap_locks))
+					   old_pmd, new_pmd, true))
 				continue;
 		}
 
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

mm-rename-pud_page_vaddr-to-pud_pgtable-and-make-it-return-pmd_t.patch
mm-rename-pud_page_vaddr-to-pud_pgtable-and-make-it-return-pmd_t-fix-2.patch
mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t.patch
mm-rename-p4d_page_vaddr-to-p4d_pgtable-and-make-it-return-pud_t-fix.patch
selftest-mremap_test-update-the-test-to-handle-pagesize-other-than-4k.patch
selftest-mremap_test-avoid-crash-with-static-build.patch
mm-mremap-convert-huge-pud-move-to-separate-helper.patch
mm-mremap-dont-enable-optimized-pud-move-if-page-table-levels-is-2.patch
mm-mremap-use-pmd-pud_poplulate-to-update-page-table-entries.patch
mm-mremap-hold-the-rmap-lock-in-write-mode-when-moving-page-table-entries.patch
mm-mremap-allow-arch-runtime-override.patch
powerpc-book3s64-mm-update-flush_tlb_range-to-flush-page-walk-cache.patch
powerpc-mm-enable-have_move_pmd-support.patch

