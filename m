Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9856C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 22 Apr 2022 23:02:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233933AbiDVXFM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 22 Apr 2022 19:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234261AbiDVXEm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2022 19:04:42 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF10913FB53
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 15:33:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 064C1CE2D8D
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 22:33:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DCA3C385A0;
        Fri, 22 Apr 2022 22:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650666816;
        bh=1/arZm9wIts5GSpxmhmld05CnCH5wsS71jsMafpXKbM=;
        h=Date:To:From:Subject:From;
        b=MxrMTyJM6V8GRTY37aaL9tExq5/WdwPSj+16jmBdiRGskx0+8OzoVocHlSbYqdyPQ
         pqLWoLpvyNfJgrz/miD1Z4rdqIfq0oDaigyEi/QQMV7Y2Jr1gxlakbJi1Cns56gk6k
         7yCC+H1BXDy/Om8+t4X/my/jLURqnZ0PL0NiHxTg=
Date:   Fri, 22 Apr 2022 15:33:35 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        robin.murphy@arm.com, npiggin@gmail.com, mark.rutland@arm.com,
        linux@armlinux.org.uk, dingtianhong@huawei.com,
        catalin.marinas@arm.com, anshuman.khandual@arm.com,
        aklimov@redhat.com, yury.norov@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + vmap-dont-allow-invalid-pages.patch added to -mm tree
Message-Id: <20220422223336.0DCA3C385A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: vmap(): don't allow invalid pages
has been added to the -mm tree.  Its filename is
     vmap-dont-allow-invalid-pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/vmap-dont-allow-invalid-pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/vmap-dont-allow-invalid-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-gup-fix-comments-to-pin_user_pages_.patch
vmap-dont-allow-invalid-pages.patch

