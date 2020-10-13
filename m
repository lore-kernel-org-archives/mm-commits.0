Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77B76C433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:58:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4547422246
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633496;
	bh=kAwmqyqC8z2rI6LUnrEWVdp4eZMcPwxemHFL6FQySXU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=fqoV6ozbcl6goxxdKmQlx5qSpi9QLJZcH9kxx2QOeyjwKEJNzsNb9RApoDrVpVfyv
	 YWNilWGu4Xx2GRni1mFS1DWctLv/JR4F/7W+CT9QKZj042lHlu+S9dJChs27GFrKnV
	 O8+QAbBrEwd1CmA0+/aGj+wjUfpXaK9wjtO4szrQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730361AbgJMX6Q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:58:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:44654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730360AbgJMX6P (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:58:15 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD45121D7A;
        Tue, 13 Oct 2020 23:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633493;
        bh=kAwmqyqC8z2rI6LUnrEWVdp4eZMcPwxemHFL6FQySXU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ejQd1zdsIDHEAwnFqrToNTrHl3rQLs0b4/+TKRC5/SEhvdN1ZoYGhxkKRylMUIe91
         fjjhvsQMPP3rXL3gDmT+rPps/dB+vInE9O+cbshPRc1JhlobXOZIYg/kk1yfcaZQ+8
         8AA5jVyPVfRItHzNpM44yQSRR6HaTbp2vI5iLNbk=
Date:   Tue, 13 Oct 2020 16:58:12 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, benh@kernel.crashing.org,
        bhe@redhat.com, bp@alien8.de, catalin.marinas@arm.com,
        dave.hansen@linux.intel.com, dja@axtens.net,
        hbathini@linux.ibm.com, hch@lst.de, jcmvbkbc@gmail.com,
        Jonathan.Cameron@huawei.com, kernel@esmil.dk, linux-mm@kvack.org,
        linux@armlinux.org.uk, luto@kernel.org, m.szyprowski@samsung.com,
        miguel.ojeda.sandonis@gmail.com, mingo@kernel.org,
        mingo@redhat.com, mm-commits@vger.kernel.org, monstr@monstr.eu,
        mpe@ellerman.id.au, palmer@dabbelt.com, paul.walmsley@sifive.com,
        paulus@samba.org, peterz@infradead.org, rppt@linux.ibm.com,
        shorne@gmail.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, tsbogend@alpha.franken.de,
        will@kernel.org, ysato@users.sourceforge.jp
Subject:  [patch 174/181] x86/setup: simplify initrd relocation and
 reservation
Message-ID: <20201013235812.wMUxIxsbN%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: x86/setup: simplify initrd relocation and reservation

Currently, initrd image is reserved very early during setup and then it
might be relocated and re-reserved after the initial physical memory
mapping is created.  The "late" reservation of memblock verifies that
mapped memory size exceeds the size of initrd, then checks whether the
relocation required and, if yes, relocates inirtd to a new memory
allocated from memblock and frees the old location.

The check for memory size is excessive as memblock allocation will anyway
fail if there is not enough memory.  Besides, there is no point to
allocate memory from memblock using memblock_find_in_range() +
memblock_reserve() when there exists memblock_phys_alloc_range() with
required functionality.

Remove the redundant check and simplify memblock allocation.

Link: https://lkml.kernel.org/r/20200818151634.14343-14-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Daniel Axtens <dja@axtens.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Emil Renner Berthing <kernel@esmil.dk>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/setup.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

--- a/arch/x86/kernel/setup.c~x86-setup-simplify-initrd-relocation-and-reservation
+++ a/arch/x86/kernel/setup.c
@@ -264,16 +264,12 @@ static void __init relocate_initrd(void)
 	u64 area_size     = PAGE_ALIGN(ramdisk_size);
 
 	/* We need to move the initrd down into directly mapped mem */
-	relocated_ramdisk = memblock_find_in_range(0, PFN_PHYS(max_pfn_mapped),
-						   area_size, PAGE_SIZE);
-
+	relocated_ramdisk = memblock_phys_alloc_range(area_size, PAGE_SIZE, 0,
+						      PFN_PHYS(max_pfn_mapped));
 	if (!relocated_ramdisk)
 		panic("Cannot find place for new RAMDISK of size %lld\n",
 		      ramdisk_size);
 
-	/* Note: this includes all the mem currently occupied by
-	   the initrd, we rely on that fact to keep the data intact. */
-	memblock_reserve(relocated_ramdisk, area_size);
 	initrd_start = relocated_ramdisk + PAGE_OFFSET;
 	initrd_end   = initrd_start + ramdisk_size;
 	printk(KERN_INFO "Allocated new RAMDISK: [mem %#010llx-%#010llx]\n",
@@ -300,13 +296,13 @@ static void __init early_reserve_initrd(
 
 	memblock_reserve(ramdisk_image, ramdisk_end - ramdisk_image);
 }
+
 static void __init reserve_initrd(void)
 {
 	/* Assume only end is not page aligned */
 	u64 ramdisk_image = get_ramdisk_image();
 	u64 ramdisk_size  = get_ramdisk_size();
 	u64 ramdisk_end   = PAGE_ALIGN(ramdisk_image + ramdisk_size);
-	u64 mapped_size;
 
 	if (!boot_params.hdr.type_of_loader ||
 	    !ramdisk_image || !ramdisk_size)
@@ -314,12 +310,6 @@ static void __init reserve_initrd(void)
 
 	initrd_start = 0;
 
-	mapped_size = memblock_mem_size(max_pfn_mapped);
-	if (ramdisk_size >= (mapped_size>>1))
-		panic("initrd too large to handle, "
-		       "disabling initrd (%lld needed, %lld available)\n",
-		       ramdisk_size, mapped_size>>1);
-
 	printk(KERN_INFO "RAMDISK: [mem %#010llx-%#010llx]\n", ramdisk_image,
 			ramdisk_end - 1);
 
_
