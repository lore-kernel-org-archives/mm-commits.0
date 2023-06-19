Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12653EB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:21:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbjFSXVS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbjFSXUu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:20:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF369E61
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:20:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D3D760F56
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:20:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF450C433C8;
        Mon, 19 Jun 2023 23:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216848;
        bh=x+/217ngAHaVuNOgN3mQ3Ge/hTWlf1Wb5bAhTXG7QMg=;
        h=Date:To:From:Subject:From;
        b=FhQgf2NFnqWLTnZ2ayYM3CSzwBjPb94c+m7rLmGUaTrZB+xknNSNTPPWEiUTWXELg
         GCJ6r5etn2B5AnQZN9U0uJmIEfWYhH1LSzH+SD8keVYNcUSR6VjpD733l5PyxWCY2R
         RGDE8nfYX2U7lh1TZSgcOVnGfNNnoEjJGT8nL0qs=
Date:   Mon, 19 Jun 2023 16:20:47 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        willy@infradead.org, will@kernel.org, tsbogend@alpha.franken.de,
        tglx@linutronix.de, surenb@google.com, rppt@kernel.org,
        peterz@infradead.org, palmer@dabbelt.com, mpe@ellerman.id.au,
        monstr@monstr.eu, mingo@kernel.org, mike.kravetz@oracle.com,
        linux@armlinux.org.uk, kirill.shutemov@linux.intel.com,
        jcmvbkbc@gmail.com, imbrenda@linux.ibm.com, hpa@zytor.com,
        hca@linux.ibm.com, glaubitz@physik.fu-berlin.de,
        gerg@linux-m68k.org, geert@linux-m68k.org, deller@gmx.de,
        david@redhat.com, davem@davemloft.net, dave.anglin@bell.net,
        chris@zankel.net, catalin.marinas@arm.com,
        borntraeger@linux.ibm.com, aneesh.kumar@linux.ibm.com,
        alexghiti@rivosinc.com, agordeev@linux.ibm.com, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm-allow-pte_offset_map-to-fail.patch removed from -mm tree
Message-Id: <20230619232047.DF450C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: arm: allow pte_offset_map[_lock]() to fail
has been removed from the -mm tree.  Its filename was
     arm-allow-pte_offset_map-to-fail.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: arm: allow pte_offset_map[_lock]() to fail
Date: Thu, 8 Jun 2023 12:10:57 -0700 (PDT)

Patch series "arch: allow pte_offset_map[_lock]() to fail", v2.

What is it all about?  Some mmap_lock avoidance i.e.  latency reduction. 
Initially just for the case of collapsing shmem or file pages to THPs; but
likely to be relied upon later in other contexts e.g.  freeing of empty
page tables (but that's not work I'm doing).  mmap_write_lock avoidance
when collapsing to anon THPs?  Perhaps, but again that's not work I've
done: a quick attempt was not as easy as the shmem/file case.

I would much prefer not to have to make these small but wide-ranging
changes for such a niche case; but failed to find another way, and have
heard that shmem MADV_COLLAPSE's usefulness is being limited by that
mmap_write_lock it currently requires.

These changes (though of course not these exact patches, and not all of
these architectures!) have been in Google's data centre kernel for three
years now: we do rely upon them.

What are the per-arch changes about?  Generally, two things.

One: the current mmap locking may not be enough to guard against that
tricky transition between pmd entry pointing to page table, and empty pmd
entry, and pmd entry pointing to huge page: pte_offset_map() will have to
validate the pmd entry for itself, returning NULL if no page table is
there.  What to do about that varies: often the nearby error handling
indicates just to skip it; but in some cases a "goto again" looks
appropriate (and if that risks an infinite loop, then there must have been
an oops, or pfn 0 mistaken for page table, before).

Deeper study of each site might show that 90% of them here in arch code
could only fail if there's corruption e.g.  a transition to THP would be
surprising on an arch without HAVE_ARCH_TRANSPARENT_HUGEPAGE.  But given
the likely extension to freeing empty page tables, I have not limited this
set of changes to THP; and it has been easier, and sets a better example,
if each site is given appropriate handling.

Two: pte_offset_map() will need to do an rcu_read_lock(), with the
corresponding rcu_read_unlock() in pte_unmap().  But most architectures
never supported CONFIG_HIGHPTE, so some don't always call pte_unmap()
after pte_offset_map(), or have used userspace pte_offset_map() where
pte_offset_kernel() is more correct.  No problem in the current tree, but
a problem once an rcu_read_unlock() will be needed to keep balance.

A common special case of that comes in arch/*/mm/hugetlbpage.c, if the
architecture supports hugetlb pages down at the lowest PTE level. 
huge_pte_alloc() uses pte_alloc_map(), but generic hugetlb code does no
corresponding pte_unmap(); similarly for huge_pte_offset().

In rare transient cases, not yet made possible, pte_offset_map() and
pte_offset_map_lock() may not find a page table: handle appropriately.

Link: https://lkml.kernel.org/r/a4963be9-7aa6-350-66d0-2ba843e1af44@google.com
Link: https://lkml.kernel.org/r/813429a1-204a-1844-eeae-7fd72826c28@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: John David Anglin <dave.anglin@bell.net>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Will Deacon <will@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/lib/uaccess_with_memcpy.c |    3 +++
 arch/arm/mm/fault-armv.c           |    5 ++++-
 arch/arm/mm/fault.c                |    3 +++
 3 files changed, 10 insertions(+), 1 deletion(-)

--- a/arch/arm/lib/uaccess_with_memcpy.c~arm-allow-pte_offset_map-to-fail
+++ a/arch/arm/lib/uaccess_with_memcpy.c
@@ -74,6 +74,9 @@ pin_page_for_write(const void __user *_a
 		return 0;
 
 	pte = pte_offset_map_lock(current->mm, pmd, addr, &ptl);
+	if (unlikely(!pte))
+		return 0;
+
 	if (unlikely(!pte_present(*pte) || !pte_young(*pte) ||
 	    !pte_write(*pte) || !pte_dirty(*pte))) {
 		pte_unmap_unlock(pte, ptl);
--- a/arch/arm/mm/fault-armv.c~arm-allow-pte_offset_map-to-fail
+++ a/arch/arm/mm/fault-armv.c
@@ -117,8 +117,11 @@ static int adjust_pte(struct vm_area_str
 	 * must use the nested version.  This also means we need to
 	 * open-code the spin-locking.
 	 */
-	ptl = pte_lockptr(vma->vm_mm, pmd);
 	pte = pte_offset_map(pmd, address);
+	if (!pte)
+		return 0;
+
+	ptl = pte_lockptr(vma->vm_mm, pmd);
 	do_pte_lock(ptl);
 
 	ret = do_adjust_pte(vma, address, pfn, pte);
--- a/arch/arm/mm/fault.c~arm-allow-pte_offset_map-to-fail
+++ a/arch/arm/mm/fault.c
@@ -85,6 +85,9 @@ void show_pte(const char *lvl, struct mm
 			break;
 
 		pte = pte_offset_map(pmd, addr);
+		if (!pte)
+			break;
+
 		pr_cont(", *pte=%08llx", (long long)pte_val(*pte));
 #ifndef CONFIG_ARM_LPAE
 		pr_cont(", *ppte=%08llx",
_

Patches currently in -mm which might be from hughd@google.com are


