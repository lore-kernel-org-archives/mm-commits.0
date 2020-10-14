Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 776B8C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:04:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BC7022261
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709487;
	bh=DZSIvUGhDEW4Z6x+HV48flrp9HuwoYaCrdcCrS/boec=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=MGhGOqTcA/n11lGx12al00cAmL74oLi2jf17/5BZzt9Ics8gchkDEeX+18BWN78Wg
	 tYgbQaBjiZMCCY0mHjxQSD0FPFR+9bCtMJJXzGr4OL+PSWoWy0PzlCGU1nDGyzR1/P
	 eWqeUGJB0n2bBeoGC2iChKnFyf1wQVrga1m8bObI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728923AbgJNVEq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:04:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728536AbgJNVEq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:04:46 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07DA12225C;
        Wed, 14 Oct 2020 21:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709485;
        bh=DZSIvUGhDEW4Z6x+HV48flrp9HuwoYaCrdcCrS/boec=;
        h=Date:From:To:Subject:From;
        b=S+jZPez+M1VsT5cVm4Wmp6PwXl96pYUXCXVaTacEOWTFu4BG0QTPztw6fmiusRPim
         UYr4pITOgpQmowZuBgos22f14jR0t9D5udecTkhu1RzWbxbAXuNWeGmywocHXnes+S
         ZIPU3DzWNR0l0sJqiKYuV46d5pS4U5RXQoPrgXm8=
Date:   Wed, 14 Oct 2020 14:04:43 -0700
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
 memblock-make-memblock_debug-and-related-functionality-private.patch
 removed from -mm tree
Message-ID: <20201014210443.QmTMFr4jV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memblock: make memblock_debug and related functionality private
has been removed from the -mm tree.  Its filename was
     memblock-make-memblock_debug-and-related-functionality-private.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: memblock: make memblock_debug and related functionality private

The only user of memblock_dbg() outside memblock was s390 setup code and
it is converted to use pr_debug() instead.  This allows to stop exposing
memblock_debug and memblock_dbg() to the rest of the kernel.

[akpm@linux-foundation.org: make memblock_dbg() safer and neater]
Link: https://lkml.kernel.org/r/20200818151634.14343-10-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
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
Cc: Ingo Molnar <mingo@kernel.org>
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

 arch/s390/kernel/setup.c |    4 ++--
 include/linux/memblock.h |   12 +-----------
 mm/memblock.c            |   16 ++++++++++++++--
 3 files changed, 17 insertions(+), 15 deletions(-)

--- a/arch/s390/kernel/setup.c~memblock-make-memblock_debug-and-related-functionality-private
+++ a/arch/s390/kernel/setup.c
@@ -776,8 +776,8 @@ static void __init memblock_add_mem_dete
 	unsigned long start, end;
 	int i;
 
-	memblock_dbg("physmem info source: %s (%hhd)\n",
-		     get_mem_info_source(), mem_detect.info_source);
+	pr_debug("physmem info source: %s (%hhd)\n",
+		 get_mem_info_source(), mem_detect.info_source);
 	/* keep memblock lists close to the kernel */
 	memblock_set_bottom_up(true);
 	for_each_mem_detect_block(i, &start, &end) {
--- a/include/linux/memblock.h~memblock-make-memblock_debug-and-related-functionality-private
+++ a/include/linux/memblock.h
@@ -86,7 +86,6 @@ struct memblock {
 };
 
 extern struct memblock memblock;
-extern int memblock_debug;
 
 #ifndef CONFIG_ARCH_KEEP_MEMBLOCK
 #define __init_memblock __meminit
@@ -98,9 +97,6 @@ void memblock_discard(void);
 static inline void memblock_discard(void) {}
 #endif
 
-#define memblock_dbg(fmt, ...) \
-	if (memblock_debug) printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
-
 phys_addr_t memblock_find_in_range(phys_addr_t start, phys_addr_t end,
 				   phys_addr_t size, phys_addr_t align);
 void memblock_allow_resize(void);
@@ -476,13 +472,7 @@ bool memblock_is_region_memory(phys_addr
 bool memblock_is_reserved(phys_addr_t addr);
 bool memblock_is_region_reserved(phys_addr_t base, phys_addr_t size);
 
-extern void __memblock_dump_all(void);
-
-static inline void memblock_dump_all(void)
-{
-	if (memblock_debug)
-		__memblock_dump_all();
-}
+void memblock_dump_all(void);
 
 /**
  * memblock_set_current_limit - Set the current allocation limit to allow
--- a/mm/memblock.c~memblock-make-memblock_debug-and-related-functionality-private
+++ a/mm/memblock.c
@@ -137,7 +137,13 @@ struct memblock_type physmem = {
 	     i < memblock_type->cnt;					\
 	     i++, rgn = &memblock_type->regions[i])
 
-int memblock_debug __initdata_memblock;
+#define memblock_dbg(fmt, ...)						\
+	do {								\
+		if (memblock_debug)					\
+			pr_info(fmt, ##__VA_ARGS__);			\
+	} while (0)
+
+static int memblock_debug __initdata_memblock;
 static bool system_has_some_mirror __initdata_memblock = false;
 static int memblock_can_resize __initdata_memblock;
 static int memblock_memory_in_slab __initdata_memblock = 0;
@@ -1920,7 +1926,7 @@ static void __init_memblock memblock_dum
 	}
 }
 
-void __init_memblock __memblock_dump_all(void)
+static void __init_memblock __memblock_dump_all(void)
 {
 	pr_info("MEMBLOCK configuration:\n");
 	pr_info(" memory size = %pa reserved size = %pa\n",
@@ -1934,6 +1940,12 @@ void __init_memblock __memblock_dump_all
 #endif
 }
 
+void __init_memblock memblock_dump_all(void)
+{
+	if (memblock_debug)
+		__memblock_dump_all();
+}
+
 void __init memblock_allow_resize(void)
 {
 	memblock_can_resize = 1;
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-remove-unused-early_pfn_valid.patch

