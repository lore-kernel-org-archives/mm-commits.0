Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE283C433E9
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 01:54:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C47522583
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 01:54:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgLWByJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Dec 2020 20:54:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:38098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726361AbgLWByI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Dec 2020 20:54:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C69022583;
        Wed, 23 Dec 2020 01:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608688407;
        bh=WoGGl5Fw3tm5+MXUS1LywxBdJ0GnLSiX8oGh9lDydRk=;
        h=Date:From:To:Subject:From;
        b=KoVC5/GjB5GSAFp84Ab1ek+cXdV2TQK7yjzUG+Cvv8ZmPadyLfYpqZN3nqfvLtwyY
         IsM5fjXIF+n0oTjR5FNP4PHXMoNQDkIFyZqgLf/65Nfnh30EFNjqvrNGvMstObJFLz
         2gHUDQAoc2Od4bSnWsK8+bfqJ24tno+nqU6yKVj8=
Date:   Tue, 22 Dec 2020 17:53:27 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vvghjk1234@gmail.com,
        rppt@linux.ibm.com, riel@surriel.com, mhocko@kernel.org,
        iamjoonsoo.kim@lge.com, guro@fb.com
Subject:  +
 memblock-do-not-start-bottom-up-allocations-with-kernel_end.patch added to
 -mm tree
Message-ID: <20201223015327.oDktL%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memblock: do not start bottom-up allocations with kernel_end
has been added to the -mm tree.  Its filename is
     memblock-do-not-start-bottom-up-allocations-with-kernel_end.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memblock-do-not-start-bottom-up-allocations-with-kernel_end.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memblock-do-not-start-bottom-up-allocations-with-kernel_end.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: memblock: do not start bottom-up allocations with kernel_end

With kaslr the kernel image is placed at a random place, so starting the
bottom-up allocation with the kernel_end can result in an allocation
failure and a warning like this one:

[    0.002920] hugetlb_cma: reserve 2048 MiB, up to 2048 MiB per node
[    0.002921] ------------[ cut here ]------------
[    0.002922] memblock: bottom-up allocation failed, memory hotremove may be affected
[    0.002937] WARNING: CPU: 0 PID: 0 at mm/memblock.c:332 memblock_find_in_range_node+0x178/0x25a
[    0.002937] Modules linked in:
[    0.002939] CPU: 0 PID: 0 Comm: swapper Not tainted 5.10.0+ #1169
[    0.002940] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-1.fc33 04/01/2014
[    0.002942] RIP: 0010:memblock_find_in_range_node+0x178/0x25a
[    0.002944] Code: e9 6d ff ff ff 48 85 c0 0f 85 da 00 00 00 80 3d 9b 35 df 00 00 75 15 48 c7 c7 c0 75 59 88 c6 05 8b 35 df 00 01 e8 25 8a fa ff <0f> 0b 48 c7 44 24 20 ff ff ff ff 44 89 e6 44 89 ea 48 c7 c1 70 5c
[    0.002945] RSP: 0000:ffffffff88803d18 EFLAGS: 00010086 ORIG_RAX: 0000000000000000
[    0.002947] RAX: 0000000000000000 RBX: 0000000240000000 RCX: 00000000ffffdfff
[    0.002948] RDX: 00000000ffffdfff RSI: 00000000ffffffea RDI: 0000000000000046
[    0.002948] RBP: 0000000100000000 R08: ffffffff88922788 R09: 0000000000009ffb
[    0.002949] R10: 00000000ffffe000 R11: 3fffffffffffffff R12: 0000000000000000
[    0.002950] R13: 0000000000000000 R14: 0000000080000000 R15: 00000001fb42c000
[    0.002952] FS:  0000000000000000(0000) GS:ffffffff88f71000(0000) knlGS:0000000000000000
[    0.002953] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.002954] CR2: ffffa080fb401000 CR3: 00000001fa80a000 CR4: 00000000000406b0
[    0.002956] Call Trace:
[    0.002961]  ? memblock_alloc_range_nid+0x8d/0x11e
[    0.002963]  ? cma_declare_contiguous_nid+0x2c4/0x38c
[    0.002964]  ? hugetlb_cma_reserve+0xdc/0x128
[    0.002968]  ? flush_tlb_one_kernel+0xc/0x20
[    0.002969]  ? native_set_fixmap+0x82/0xd0
[    0.002971]  ? flat_get_apic_id+0x5/0x10
[    0.002973]  ? register_lapic_address+0x8e/0x97
[    0.002975]  ? setup_arch+0x8a5/0xc3f
[    0.002978]  ? start_kernel+0x66/0x547
[    0.002980]  ? load_ucode_bsp+0x4c/0xcd
[    0.002982]  ? secondary_startup_64_no_verify+0xb0/0xbb
[    0.002986] random: get_random_bytes called from __warn+0xab/0x110 with crng_init=0
[    0.002988] ---[ end trace f151227d0b39be70 ]---

At the same time, the kernel image is protected with memblock_reserve(),
so we can just start searching at PAGE_SIZE.  In this case the bottom-up
allocation has the same chances to success as a top-down allocation, so
there is no reason to fallback in the case of a failure.  All together it
simplifies the logic.

Link: https://lkml.kernel.org/r/20201217201214.3414100-2-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Wonhyuk Yang <vvghjk1234@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |   49 +++++-------------------------------------------
 1 file changed, 6 insertions(+), 43 deletions(-)

--- a/mm/memblock.c~memblock-do-not-start-bottom-up-allocations-with-kernel_end
+++ a/mm/memblock.c
@@ -275,14 +275,6 @@ __memblock_find_range_top_down(phys_addr
  *
  * Find @size free area aligned to @align in the specified range and node.
  *
- * When allocation direction is bottom-up, the @start should be greater
- * than the end of the kernel image. Otherwise, it will be trimmed. The
- * reason is that we want the bottom-up allocation just near the kernel
- * image so it is highly likely that the allocated memory and the kernel
- * will reside in the same node.
- *
- * If bottom-up allocation failed, will try to allocate memory top-down.
- *
  * Return:
  * Found address on success, 0 on failure.
  */
@@ -291,8 +283,6 @@ static phys_addr_t __init_memblock membl
 					phys_addr_t end, int nid,
 					enum memblock_flags flags)
 {
-	phys_addr_t kernel_end, ret;
-
 	/* pump up @end */
 	if (end == MEMBLOCK_ALLOC_ACCESSIBLE ||
 	    end == MEMBLOCK_ALLOC_KASAN)
@@ -301,40 +291,13 @@ static phys_addr_t __init_memblock membl
 	/* avoid allocating the first page */
 	start = max_t(phys_addr_t, start, PAGE_SIZE);
 	end = max(start, end);
-	kernel_end = __pa_symbol(_end);
-
-	/*
-	 * try bottom-up allocation only when bottom-up mode
-	 * is set and @end is above the kernel image.
-	 */
-	if (memblock_bottom_up() && end > kernel_end) {
-		phys_addr_t bottom_up_start;
-
-		/* make sure we will allocate above the kernel */
-		bottom_up_start = max(start, kernel_end);
-
-		/* ok, try bottom-up allocation first */
-		ret = __memblock_find_range_bottom_up(bottom_up_start, end,
-						      size, align, nid, flags);
-		if (ret)
-			return ret;
-
-		/*
-		 * we always limit bottom-up allocation above the kernel,
-		 * but top-down allocation doesn't have the limit, so
-		 * retrying top-down allocation may succeed when bottom-up
-		 * allocation failed.
-		 *
-		 * bottom-up allocation is expected to be fail very rarely,
-		 * so we use WARN_ONCE() here to see the stack trace if
-		 * fail happens.
-		 */
-		WARN_ONCE(IS_ENABLED(CONFIG_MEMORY_HOTREMOVE),
-			  "memblock: bottom-up allocation failed, memory hotremove may be affected\n");
-	}
 
-	return __memblock_find_range_top_down(start, end, size, align, nid,
-					      flags);
+	if (memblock_bottom_up())
+		return __memblock_find_range_bottom_up(start, end, size, align,
+						       nid, flags);
+	else
+		return __memblock_find_range_top_down(start, end, size, align,
+						      nid, flags);
 }
 
 /**
_

Patches currently in -mm which might be from guro@fb.com are

mm-slub-call-account_slab_page-after-slab-page-initialization.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account.patch
mm-cma-allocate-cma-areas-bottom-up.patch
mm-cma-allocate-cma-areas-bottom-up-fix.patch
memblock-do-not-start-bottom-up-allocations-with-kernel_end.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch

