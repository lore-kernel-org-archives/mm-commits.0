Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47F14C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  5 Dec 2022 19:59:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbiLET7R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Dec 2022 14:59:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232492AbiLET6v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Dec 2022 14:58:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E52D9585
        for <mm-commits@vger.kernel.org>; Mon,  5 Dec 2022 11:58:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D340FB8120C
        for <mm-commits@vger.kernel.org>; Mon,  5 Dec 2022 19:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A138C433D6;
        Mon,  5 Dec 2022 19:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670270326;
        bh=iS+vgkWayKby381F8BfBW4FZeEAA63qayDoNSAGPrN8=;
        h=Date:To:From:Subject:From;
        b=VTqxv++dP+Bh3+cNx4nb9q7SzVDJZaYLiwrEE3lvHxW9VHPisJecGXQ5YjGHTjQhR
         dSeakpN6Y3igPcpdT/gWV4kWrGulru7lalSMT9lRYFjtZIlkJ47ZUsfi7cFI5CPGxA
         ogrwmGKxwZYhUo/Mw04CV/bdmYIjSKlYRD4NNQ+w=
Date:   Mon, 05 Dec 2022 11:58:45 -0800
To:     mm-commits@vger.kernel.org, shy828301@gmail.com, peterx@redhat.com,
        hughd@google.com, aarcange@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-fix-swp_pfn_bits-with-config_phys_addr_t_64bit-on-32bit.patch added to mm-hotfixes-unstable branch
Message-Id: <20221205195846.8A138C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: fix SWP_PFN_BITS with CONFIG_PHYS_ADDR_T_64BIT on 32bit
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-swap-fix-swp_pfn_bits-with-config_phys_addr_t_64bit-on-32bit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-fix-swp_pfn_bits-with-config_phys_addr_t_64bit-on-32bit.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/swap: fix SWP_PFN_BITS with CONFIG_PHYS_ADDR_T_64BIT on 32bit
Date: Mon, 5 Dec 2022 16:08:57 +0100

We use "unsigned long" to store a PFN in the kernel and phys_addr_t to
store a physical address.

On a 64bit system, both are 64bit wide. However, on a 32bit system, the
latter might be 64bit wide. This is, for example, the case on x86 with
PAE: phys_addr_t and PTEs are 64bit wide, while "unsigned long" only
spans 32bit.

The current definition of SWP_PFN_BITS without MAX_PHYSMEM_BITS misses
that case, and assumes that the maximum PFN is limited by a 32bit
phys_addr_t.  This implies, that SWP_PFN_BITS will currently only be able
to cover 4 GiB - 1 on any 32bit system, which is wrong.  We can end up
masking off valid PFN bits from the swap offset.

Ideally, we'd use something like "sizeof(phys_addr_t) * 8 - PAGE_SHIFT",
however, we might exceed SWP_TYPE_SHIFT and make the BUILD_BUG_ON() in
is_pfn_swap_entry() unhappy.  Note that swp_entry_t is effectively an
unsigned long.

Consequently, simply rely on SWP_TYPE_SHIFT in case we're on 32bit and
CONFIG_PHYS_ADDR_T_64BIT is defined.

For example, on an 8 GiB x86 PAE system, we currently fail removing
migration entries (remove_migration_ptes()) that target PFNs above 4 GiB,
because mm/page_vma_mapped.c:check_pte() will fail to identify a PFN match
as swp_offset_pfn() wrongly masks off valid PFN bits.

With THP, split_huge_page_to_list()->...->remap_page() will leave
migration entries in place and continue to unlock the page, which is
wrong.  Later, when we stumble over these migration entries (e.g., via
/proc/self/pagemap), pfn_swap_entry_to_page() will BUG_ON() because these
migration entries shouldn't exist anymore and the page was unlocked.

[   33.067591] kernel BUG at include/linux/swapops.h:497!
[   33.067597] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
[   33.067602] CPU: 3 PID: 742 Comm: cow Tainted: G            E      6.1.0-rc8+ #16
[   33.067605] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.0-1.fc36 04/01/2014
[   33.067606] EIP: pagemap_pmd_range+0x644/0x650
[   33.067612] Code: 00 00 00 00 66 90 89 ce b9 00 f0 ff ff e9 ff fb ...
[   33.067615] EAX: ee394000 EBX: 00000002 ECX: ee394000 EDX: 00000000
[   33.067617] ESI: c1b0ded4 EDI: 00024a00 EBP: c1b0ddb4 ESP: c1b0dd68
[   33.067619] DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068 EFLAGS: 00010246
[   33.067624] CR0: 80050033 CR2: b7a00000 CR3: 01bbbd20 CR4: 00350ef0
[   33.067625] Call Trace:
[   33.067628]  ? madvise_free_pte_range+0x720/0x720
[   33.067632]  ? smaps_pte_range+0x4b0/0x4b0
[   33.067634]  walk_pgd_range+0x325/0x720
[   33.067637]  ? mt_find+0x1d6/0x3a0
[   33.067641]  ? mt_find+0x1d6/0x3a0
[   33.067643]  __walk_page_range+0x164/0x170
[   33.067646]  walk_page_range+0xf9/0x170
[   33.067648]  ? __kmem_cache_alloc_node+0x2a8/0x340
[   33.067653]  pagemap_read+0x124/0x280
[   33.067658]  ? default_llseek+0x101/0x160
[   33.067662]  ? smaps_account+0x1d0/0x1d0
[   33.067664]  vfs_read+0x90/0x290
[   33.067667]  ? do_madvise.part.0+0x24b/0x390
[   33.067669]  ? debug_smp_processor_id+0x12/0x20
[   33.067673]  ksys_pread64+0x58/0x90
[   33.067675]  __ia32_sys_ia32_pread64+0x1b/0x20
[   33.067680]  __do_fast_syscall_32+0x4c/0xc0
[   33.067683]  do_fast_syscall_32+0x29/0x60
[   33.067686]  do_SYSENTER_32+0x15/0x20
[   33.067689]  entry_SYSENTER_32+0x98/0xf1

Link: https://lkml.kernel.org/r/20221205150857.167583-1-david@redhat.com
Fixes: 0d206b5d2e0d ("mm/swap: add swp_offset_pfn() to fetch PFN from swap entry")
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapops.h |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/include/linux/swapops.h~mm-swap-fix-swp_pfn_bits-with-config_phys_addr_t_64bit-on-32bit
+++ a/include/linux/swapops.h
@@ -32,11 +32,13 @@
  * store PFN, we only need SWP_PFN_BITS bits.  Each of the pfn swap entries
  * can use the extra bits to store other information besides PFN.
  */
-#ifdef MAX_PHYSMEM_BITS
+#if defined(MAX_PHYSMEM_BITS)
 #define SWP_PFN_BITS			(MAX_PHYSMEM_BITS - PAGE_SHIFT)
-#else  /* MAX_PHYSMEM_BITS */
+#elif !defined(CONFIG_64BIT) && defined(CONFIG_PHYS_ADDR_T_64BIT)
+#define SWP_PFN_BITS			SWP_TYPE_SHIFT
+#else
 #define SWP_PFN_BITS			(BITS_PER_LONG - PAGE_SHIFT)
-#endif	/* MAX_PHYSMEM_BITS */
+#endif	/* defined(MAX_PHYSMEM_BITS) */
 #define SWP_PFN_MASK			(BIT(SWP_PFN_BITS) - 1)
 
 /**
_

Patches currently in -mm which might be from david@redhat.com are

mm-swap-fix-swp_pfn_bits-with-config_phys_addr_t_64bit-on-32bit.patch
selftests-vm-add-ksm-unmerge-tests.patch
mm-pagewalk-dont-trigger-test_walk-in-walk_page_vma.patch
selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch
mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch
mm-remove-vm_fault_write.patch
mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch
mm-pagewalk-add-walk_page_range_vma.patch
mm-ksm-convert-break_ksm-to-use-walk_page_range_vma.patch
mm-gup-remove-foll_migration.patch

