Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45EE4C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:11:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235950AbiEJEP2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235970AbiEJEOu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:14:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A248201AB
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:10:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7A0AB81AF5
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:10:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74F3CC385C2;
        Tue, 10 May 2022 04:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155850;
        bh=8dJs3HkiZi403vM2kf+HN+fSs5JjcjnZSCn+W3hRefs=;
        h=Date:To:From:Subject:From;
        b=NVWovhIN5rvfrzAqguJpfxL+If3zyWX9N8l46pwOERCLW5gW9aGra68NkdBScIh6z
         M+Z6qW69cSzhpubwTQxaUSUS2oL3qsufvLh+D1aUwBetXNPjDdifh2Z8j6/4ji5DUq
         xpFgYZpdSDRl9jixMeCylQqDnCPUaXQ6AYoXL6ic=
Date:   Mon, 09 May 2022 21:10:49 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        robin.murphy@arm.com, npiggin@gmail.com, mark.rutland@arm.com,
        linux@armlinux.org.uk, dingtianhong@huawei.com,
        catalin.marinas@arm.com, anshuman.khandual@arm.com,
        aklimov@redhat.com, yury.norov@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] vmap-dont-allow-invalid-pages.patch removed from -mm tree
Message-Id: <20220510041050.74F3CC385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: vmap(): don't allow invalid pages
has been removed from the -mm tree.  Its filename was
     vmap-dont-allow-invalid-pages.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: vmap(): don't allow invalid pages

vmap() takes struct page *pages as one of arguments, and user may provide
an invalid pointer which may lead to corrupted translation table.

An example of such behaviour is erroneous usage of virt_to_page():

	vaddr1 = dma_alloc_coherent()
	page = virt_to_page()	// Wrong here
	...
	vaddr2 = vmap(page)
	memset(vaddr2)		// Faulting here

virt_to_page() returns a wrong pointer if vaddr1 is not a linear kernel
address.  The problem is that vmap() populates pte with bad pfn
successfully, and it's much harder to debug at memory access time.  This
case should be caught by DEBUG_VIRTUAL being that enabled, but it's not
enabled in popular distros.

Kernel already checks the pages against NULL.  In the case mentioned
above, however, the address is not NULL, and it's big enough so that the
hardware generated Address Size Abort on arm64:

	[  665.484101] Unhandled fault at 0xffff8000252cd000
	[  665.488807] Mem abort info:
	[  665.491617]   ESR = 0x96000043
	[  665.494675]   EC = 0x25: DABT (current EL), IL = 32 bits
	[  665.499985]   SET = 0, FnV = 0
	[  665.503039]   EA = 0, S1PTW = 0
	[  665.506167] Data abort info:
	[  665.509047]   ISV = 0, ISS = 0x00000043
	[  665.512882]   CM = 0, WnR = 1
	[  665.515851] swapper pgtable: 4k pages, 48-bit VAs, pgdp=00000000818cb000
	[  665.522550] [ffff8000252cd000] pgd=000000affcfff003, pud=000000affcffe003, pmd=0000008fad8c3003, pte=00688000a5217713
	[  665.533160] Internal error: level 3 address size fault: 96000043 [#1] SMP
	[  665.539936] Modules linked in: [...]
	[  665.616212] CPU: 178 PID: 13199 Comm: test Tainted: P           OE 5.4.0-84-generic #94~18.04.1-Ubuntu
	[  665.626806] Hardware name: HPE Apollo 70             /C01_APACHE_MB , BIOS L50_5.13_1.0.6 07/10/2018
	[  665.636618] pstate: 80400009 (Nzcv daif +PAN -UAO)
	[  665.641407] pc : __memset+0x38/0x188
	[  665.645146] lr : test+0xcc/0x3f8
	[  665.650184] sp : ffff8000359bb840
	[  665.653486] x29: ffff8000359bb840 x28: 0000000000000000
	[  665.658785] x27: 0000000000000000 x26: 0000000000231000
	[  665.664083] x25: ffff00ae660f6110 x24: ffff00ae668cb800
	[  665.669382] x23: 0000000000000001 x22: ffff00af533e5000
	[  665.674680] x21: 0000000000001000 x20: 0000000000000000
	[  665.679978] x19: ffff00ae66950000 x18: ffffffffffffffff
	[  665.685276] x17: 00000000588636a5 x16: 0000000000000013
	[  665.690574] x15: ffffffffffffffff x14: 000000000007ffff
	[  665.695872] x13: 0000000080000000 x12: 0140000000000000
	[  665.701170] x11: 0000000000000041 x10: ffff8000652cd000
	[  665.706468] x9 : ffff8000252cf000 x8 : ffff8000252cd000
	[  665.711767] x7 : 0303030303030303 x6 : 0000000000001000
	[  665.717065] x5 : ffff8000252cd000 x4 : 0000000000000000
	[  665.722363] x3 : ffff8000252cdfff x2 : 0000000000000001
	[  665.727661] x1 : 0000000000000003 x0 : ffff8000252cd000
	[  665.732960] Call trace:
	[  665.735395]  __memset+0x38/0x188
	[...]

Interestingly, this abort happens even if copy_from_kernel_nofault() is
used, which is quite inconvenient for debugging purposes.

This patch adds a pfn_valid() check into vmap() path, so that invalid
mapping will not be created; WARN_ON() is used to let client code know
that something goes wrong, and it's not a regular EINVAL situation.

Link: https://lkml.kernel.org/r/20220422220410.1308706-1-yury.norov@gmail.com
Signed-off-by: Yury Norov (NVIDIA) <yury.norov@gmail.com>
Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Alexey Klimov <aklimov@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ding Tianhong <dingtianhong@huawei.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/vmalloc.c~vmap-dont-allow-invalid-pages
+++ a/mm/vmalloc.c
@@ -478,6 +478,9 @@ static int vmap_pages_pte_range(pmd_t *p
 			return -EBUSY;
 		if (WARN_ON(!page))
 			return -ENOMEM;
+		if (WARN_ON(!pfn_valid(page_to_pfn(page))))
+			return -EINVAL;
+
 		set_pte_at(&init_mm, addr, pte, mk_pte(page, prot));
 		(*nr)++;
 	} while (pte++, addr += PAGE_SIZE, addr != end);
_

Patches currently in -mm which might be from yury.norov@gmail.com are


