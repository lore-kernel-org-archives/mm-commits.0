Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50935C43457
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:05:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2BBC22248
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709504;
	bh=kVaZj84nVzWSsHtrvV1jtN6300z63RBfIRJh+Y1koqI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Vu5EPKJ+9vzfP4ZfMvTIfnBtW+7fIt7Q4aZiqo0uTsr00ccyTZu0ABUfU/i5u161U
	 a9oQszrh2gf/u26gNN69IAbyo33ow9xTafsL/6G2y7lMwZazHwdIGRBKv49DvIQ3mr
	 fOfMURatH2l4NgSRs+gnn2S9oNWz7VTcD95jJBT4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388253AbgJNVFD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:05:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:55682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387703AbgJNVFD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:05:03 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0ED0F214D8;
        Wed, 14 Oct 2020 21:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709502;
        bh=kVaZj84nVzWSsHtrvV1jtN6300z63RBfIRJh+Y1koqI=;
        h=Date:From:To:Subject:From;
        b=UmOAe1A/n+LslSC9UvjVpJLbT1zqYFsNVqTwaEUBEoUPZ771lOGDG3i6cBfUpsiSV
         KjzfrxkGUJeInSC7UYBLojK1xhdgmTdxfTsj7zyI3Kl0LQbAhRYf9y7qBpIkqf2IkN
         FzdKK8k+TQRHMnjAT1Yi89RaIsZ6r/WEtaGR6cr0=
Date:   Wed, 14 Oct 2020 14:05:00 -0700
From:   akpm@linux-foundation.org
To:     benh@kernel.crashing.org, bhe@redhat.com, bp@alien8.de,
        catalin.marinas@arm.com, dave.hansen@linux.intel.com,
        dja@axtens.net, hbathini@linux.ibm.com, hch@lst.de,
        jcmvbkbc@gmail.com, Jonathan.Cameron@huawei.com, kernel@esmil.dk,
        linux@armlinux.org.uk, luto@kernel.org, m.szyprowski@samsung.com,
        miguel.ojeda.sandonis@gmail.com, mingo@kernel.org,
        mingo@redhat.com, mm-commits@vger.kernel.org, monstr@monstr.eu,
        mpe@ellerman.id.au, palmer@dabbelt.com, paul.walmsley@sifive.com,
        paulus@samba.org, peterz@infradead.org, rppt@linux.ibm.com,
        shorne@gmail.com, tglx@linutronix.de, tsbogend@alpha.franken.de,
        will@kernel.org, ysato@users.sourceforge.jp
Subject:  [merged]
 x86-setup-simplify-initrd-relocation-and-reservation.patch removed from -mm
 tree
Message-ID: <20201014210500.el_a5Qujy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86/setup: simplify initrd relocation and reservation
has been removed from the -mm tree.  Its filename was
     x86-setup-simplify-initrd-relocation-and-reservation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-remove-unused-early_pfn_valid.patch

