Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6F43C636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 05:41:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbjBCFlz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 00:41:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbjBCFly (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 00:41:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4960885D4
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 21:41:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AA2361D7A
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 05:41:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8C2EC4339B;
        Fri,  3 Feb 2023 05:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675402912;
        bh=s8tXC06xG7vzMX44zbnBJoH4r1oTKTBsdQ/S5rgGQis=;
        h=Date:To:From:Subject:From;
        b=j93xuBqiBWK8GEGOo04LSIVvytU+1iFxG6XFHJJA9abliA/D66SGjqsR9ZdL7EWBH
         aRmPXT/b1KqsY9yPFazbL/1zybAvLXYpD3JjR/6j+4o4yk2XH0Y77+iRHqGuH67INS
         HLEYq8VPpfLkUl3rN1tbZWaSH/jYU51NwfNAfCU4=
Date:   Thu, 02 Feb 2023 21:41:52 -0800
To:     mm-commits@vger.kernel.org, lkp@intel.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-debug_vm_pgtable-more-pte_swp_exclusive-sanity-checks-fix.patch removed from -mm tree
Message-Id: <20230203054152.A8C2EC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fixup: mm/debug_vm_pgtable: more pte_swp_exclusive() sanity checks
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtable-more-pte_swp_exclusive-sanity-checks-fix.patch

This patch was dropped because it was folded into mm-debug_vm_pgtable-more-pte_swp_exclusive-sanity-checks.patch

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: fixup: mm/debug_vm_pgtable: more pte_swp_exclusive() sanity checks
Date: Sat, 14 Jan 2023 16:47:12 +0100

generic_max_swapfile_size() is only available with CONFIG_SWAP -- which
makes sense, because without SWAP there are no swap files. Let's
simply probe manually which bits we can obtain after storing them in a
PTE, and properly call it "max swap offset", which is more generic for
a swap entry.

Link: https://lkml.kernel.org/r/6aaad548-cf48-77fa-9d6c-db83d724b2eb@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-more-pte_swp_exclusive-sanity-checks-fix
+++ a/mm/debug_vm_pgtable.c
@@ -811,15 +811,17 @@ static void __init pmd_swap_soft_dirty_t
 static void __init pte_swap_exclusive_tests(struct pgtable_debug_args *args)
 {
 #ifdef __HAVE_ARCH_PTE_SWP_EXCLUSIVE
-	unsigned long max_swapfile_size = generic_max_swapfile_size();
+	unsigned long max_swap_offset;
 	swp_entry_t entry, entry2;
 	pte_t pte;
 
 	pr_debug("Validating PTE swap exclusive\n");
 
+	/* See generic_max_swapfile_size(): probe the maximum offset */
+	max_swap_offset = swp_offset(pte_to_swp_entry(swp_entry_to_pte(swp_entry(0, ~0UL))));
+
 	/* Create a swp entry with all possible bits set */
-	entry = swp_entry((1 << MAX_SWAPFILES_SHIFT) - 1,
-			  max_swapfile_size - 1);
+	entry = swp_entry((1 << MAX_SWAPFILES_SHIFT) - 1, max_swap_offset);
 
 	pte = swp_entry_to_pte(entry);
 	WARN_ON(pte_swp_exclusive(pte));
_

Patches currently in -mm which might be from david@redhat.com are

mm-debug_vm_pgtable-more-pte_swp_exclusive-sanity-checks.patch
alpha-mm-support-__have_arch_pte_swp_exclusive.patch
arc-mm-support-__have_arch_pte_swp_exclusive.patch
arm-mm-support-__have_arch_pte_swp_exclusive.patch
csky-mm-support-__have_arch_pte_swp_exclusive.patch
hexagon-mm-support-__have_arch_pte_swp_exclusive.patch
ia64-mm-support-__have_arch_pte_swp_exclusive.patch
loongarch-mm-support-__have_arch_pte_swp_exclusive.patch
m68k-mm-remove-dummy-__swp-definitions-for-nommu.patch
m68k-mm-support-__have_arch_pte_swp_exclusive.patch
microblaze-mm-support-__have_arch_pte_swp_exclusive.patch
mips-mm-support-__have_arch_pte_swp_exclusive.patch
nios2-mm-refactor-swap-pte-layout.patch
nios2-mm-support-__have_arch_pte_swp_exclusive.patch
openrisc-mm-support-__have_arch_pte_swp_exclusive.patch
parisc-mm-support-__have_arch_pte_swp_exclusive.patch
powerpc-mm-support-__have_arch_pte_swp_exclusive-on-32bit-book3s.patch
powerpc-nohash-mm-support-__have_arch_pte_swp_exclusive.patch
riscv-mm-support-__have_arch_pte_swp_exclusive.patch
sh-mm-support-__have_arch_pte_swp_exclusive.patch
sparc-mm-support-__have_arch_pte_swp_exclusive-on-32bit.patch
sparc-mm-support-__have_arch_pte_swp_exclusive-on-64bit.patch
um-mm-support-__have_arch_pte_swp_exclusive.patch
x86-mm-support-__have_arch_pte_swp_exclusive-also-on-32bit.patch
xtensa-mm-support-__have_arch_pte_swp_exclusive.patch
mm-remove-__have_arch_pte_swp_exclusive.patch

