Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96E02C433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:58:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5956D2222F
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633482;
	bh=gfe26F/mARuL0P86p3YTT5wmBI/GNkJtv62Q0MAv1cw=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=FZq87C9iP2eRlaz0cBkVkG8pdtYIP+4ZTl0Y3TfezNfI37LdTbKFEkQqlcSqD3Stj
	 oSN9n5R+nbaEpbHPAt56upNR0mGOvAgoSOyxREJ10oJHCab7AwNYBWRc7nZSStPO4t
	 r+4dVdF5jM/P6g6xvHM9h29IyNRJeekooeN6IDp4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389244AbgJMX6C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:58:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:44316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387851AbgJMX6B (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:58:01 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD39E22247;
        Tue, 13 Oct 2020 23:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633480;
        bh=gfe26F/mARuL0P86p3YTT5wmBI/GNkJtv62Q0MAv1cw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=MacGK16LTJiVmUzrNqrlwyXH9h1R3iWpFwsGiCD4nB7VVWQdMWte6UNhdwvm9mg0i
         VbBCvJjAAJ6taNzhCAgJWMZeqopC1vSRwVVpw8EHtKk7P3IJIUpI7sLWgAzuzoQnEN
         xeuZYWBGlmlqaeHBrbg15tJGk+UlbdDRrNgJHUWA=
Date:   Tue, 13 Oct 2020 16:57:59 -0700
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
Subject:  [patch 171/181] memblock: reduce number of parameters in
 for_each_mem_range()
Message-ID: <20201013235759.T9bqVMV-9%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: memblock: reduce number of parameters in for_each_mem_range()

Currently for_each_mem_range() and for_each_mem_range_rev() iterators are
the most generic way to traverse memblock regions.  As such, they have 8
parameters and they are hardly convenient to users.  Most users choose to
utilize one of their wrappers and the only user that actually needs most
of the parameters is memblock itself.

To avoid yet another naming for memblock iterators, rename the existing
for_each_mem_range[_rev]() to __for_each_mem_range[_rev]() and add a new
for_each_mem_range[_rev]() wrappers with only index, start and end
parameters.

The new wrapper nicely fits into init_unavailable_mem() and will be used
in upcoming changes to simplify memblock traversals.

Link: https://lkml.kernel.org/r/20200818151634.14343-11-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>	[MIPS]
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
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
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .clang-format                          |    2 +
 arch/arm64/kernel/machine_kexec_file.c |    6 +--
 arch/powerpc/kexec/file_load_64.c      |    6 +--
 include/linux/memblock.h               |   41 +++++++++++++++++------
 mm/page_alloc.c                        |    3 -
 5 files changed, 38 insertions(+), 20 deletions(-)

--- a/arch/arm64/kernel/machine_kexec_file.c~memblock-reduce-number-of-parameters-in-for_each_mem_range
+++ a/arch/arm64/kernel/machine_kexec_file.c
@@ -215,8 +215,7 @@ static int prepare_elf_headers(void **ad
 	phys_addr_t start, end;
 
 	nr_ranges = 1; /* for exclusion of crashkernel region */
-	for_each_mem_range(i, &memblock.memory, NULL, NUMA_NO_NODE,
-					MEMBLOCK_NONE, &start, &end, NULL)
+	for_each_mem_range(i, &start, &end)
 		nr_ranges++;
 
 	cmem = kmalloc(struct_size(cmem, ranges, nr_ranges), GFP_KERNEL);
@@ -225,8 +224,7 @@ static int prepare_elf_headers(void **ad
 
 	cmem->max_nr_ranges = nr_ranges;
 	cmem->nr_ranges = 0;
-	for_each_mem_range(i, &memblock.memory, NULL, NUMA_NO_NODE,
-					MEMBLOCK_NONE, &start, &end, NULL) {
+	for_each_mem_range(i, &start, &end) {
 		cmem->ranges[cmem->nr_ranges].start = start;
 		cmem->ranges[cmem->nr_ranges].end = end - 1;
 		cmem->nr_ranges++;
--- a/arch/powerpc/kexec/file_load_64.c~memblock-reduce-number-of-parameters-in-for_each_mem_range
+++ a/arch/powerpc/kexec/file_load_64.c
@@ -250,8 +250,7 @@ static int __locate_mem_hole_top_down(st
 	phys_addr_t start, end;
 	u64 i;
 
-	for_each_mem_range_rev(i, &memblock.memory, NULL, NUMA_NO_NODE,
-			       MEMBLOCK_NONE, &start, &end, NULL) {
+	for_each_mem_range_rev(i, &start, &end) {
 		/*
 		 * memblock uses [start, end) convention while it is
 		 * [start, end] here. Fix the off-by-one to have the
@@ -350,8 +349,7 @@ static int __locate_mem_hole_bottom_up(s
 	phys_addr_t start, end;
 	u64 i;
 
-	for_each_mem_range(i, &memblock.memory, NULL, NUMA_NO_NODE,
-			   MEMBLOCK_NONE, &start, &end, NULL) {
+	for_each_mem_range(i, &start, &end) {
 		/*
 		 * memblock uses [start, end) convention while it is
 		 * [start, end] here. Fix the off-by-one to have the
--- a/.clang-format~memblock-reduce-number-of-parameters-in-for_each_mem_range
+++ a/.clang-format
@@ -207,7 +207,9 @@ ForEachMacros:
   - 'for_each_memblock_type'
   - 'for_each_memcg_cache_index'
   - 'for_each_mem_pfn_range'
+  - '__for_each_mem_range'
   - 'for_each_mem_range'
+  - '__for_each_mem_range_rev'
   - 'for_each_mem_range_rev'
   - 'for_each_migratetype_order'
   - 'for_each_msi_entry'
--- a/include/linux/memblock.h~memblock-reduce-number-of-parameters-in-for_each_mem_range
+++ a/include/linux/memblock.h
@@ -162,7 +162,7 @@ static inline void __next_physmem_range(
 #endif /* CONFIG_HAVE_MEMBLOCK_PHYS_MAP */
 
 /**
- * for_each_mem_range - iterate through memblock areas from type_a and not
+ * __for_each_mem_range - iterate through memblock areas from type_a and not
  * included in type_b. Or just type_a if type_b is NULL.
  * @i: u64 used as loop variable
  * @type_a: ptr to memblock_type to iterate
@@ -173,7 +173,7 @@ static inline void __next_physmem_range(
  * @p_end: ptr to phys_addr_t for end address of the range, can be %NULL
  * @p_nid: ptr to int for nid of the range, can be %NULL
  */
-#define for_each_mem_range(i, type_a, type_b, nid, flags,		\
+#define __for_each_mem_range(i, type_a, type_b, nid, flags,		\
 			   p_start, p_end, p_nid)			\
 	for (i = 0, __next_mem_range(&i, nid, flags, type_a, type_b,	\
 				     p_start, p_end, p_nid);		\
@@ -182,7 +182,7 @@ static inline void __next_physmem_range(
 			      p_start, p_end, p_nid))
 
 /**
- * for_each_mem_range_rev - reverse iterate through memblock areas from
+ * __for_each_mem_range_rev - reverse iterate through memblock areas from
  * type_a and not included in type_b. Or just type_a if type_b is NULL.
  * @i: u64 used as loop variable
  * @type_a: ptr to memblock_type to iterate
@@ -193,16 +193,37 @@ static inline void __next_physmem_range(
  * @p_end: ptr to phys_addr_t for end address of the range, can be %NULL
  * @p_nid: ptr to int for nid of the range, can be %NULL
  */
-#define for_each_mem_range_rev(i, type_a, type_b, nid, flags,		\
-			       p_start, p_end, p_nid)			\
+#define __for_each_mem_range_rev(i, type_a, type_b, nid, flags,		\
+				 p_start, p_end, p_nid)			\
 	for (i = (u64)ULLONG_MAX,					\
-		     __next_mem_range_rev(&i, nid, flags, type_a, type_b,\
+		     __next_mem_range_rev(&i, nid, flags, type_a, type_b, \
 					  p_start, p_end, p_nid);	\
 	     i != (u64)ULLONG_MAX;					\
 	     __next_mem_range_rev(&i, nid, flags, type_a, type_b,	\
 				  p_start, p_end, p_nid))
 
 /**
+ * for_each_mem_range - iterate through memory areas.
+ * @i: u64 used as loop variable
+ * @p_start: ptr to phys_addr_t for start address of the range, can be %NULL
+ * @p_end: ptr to phys_addr_t for end address of the range, can be %NULL
+ */
+#define for_each_mem_range(i, p_start, p_end) \
+	__for_each_mem_range(i, &memblock.memory, NULL, NUMA_NO_NODE,	\
+			     MEMBLOCK_NONE, p_start, p_end, NULL)
+
+/**
+ * for_each_mem_range_rev - reverse iterate through memblock areas from
+ * type_a and not included in type_b. Or just type_a if type_b is NULL.
+ * @i: u64 used as loop variable
+ * @p_start: ptr to phys_addr_t for start address of the range, can be %NULL
+ * @p_end: ptr to phys_addr_t for end address of the range, can be %NULL
+ */
+#define for_each_mem_range_rev(i, p_start, p_end)			\
+	__for_each_mem_range_rev(i, &memblock.memory, NULL, NUMA_NO_NODE, \
+				 MEMBLOCK_NONE, p_start, p_end, NULL)
+
+/**
  * for_each_reserved_mem_region - iterate over all reserved memblock areas
  * @i: u64 used as loop variable
  * @p_start: ptr to phys_addr_t for start address of the range, can be %NULL
@@ -307,8 +328,8 @@ int __init deferred_page_init_max_thread
  * soon as memblock is initialized.
  */
 #define for_each_free_mem_range(i, nid, flags, p_start, p_end, p_nid)	\
-	for_each_mem_range(i, &memblock.memory, &memblock.reserved,	\
-			   nid, flags, p_start, p_end, p_nid)
+	__for_each_mem_range(i, &memblock.memory, &memblock.reserved,	\
+			     nid, flags, p_start, p_end, p_nid)
 
 /**
  * for_each_free_mem_range_reverse - rev-iterate through free memblock areas
@@ -324,8 +345,8 @@ int __init deferred_page_init_max_thread
  */
 #define for_each_free_mem_range_reverse(i, nid, flags, p_start, p_end,	\
 					p_nid)				\
-	for_each_mem_range_rev(i, &memblock.memory, &memblock.reserved,	\
-			       nid, flags, p_start, p_end, p_nid)
+	__for_each_mem_range_rev(i, &memblock.memory, &memblock.reserved, \
+				 nid, flags, p_start, p_end, p_nid)
 
 int memblock_set_node(phys_addr_t base, phys_addr_t size,
 		      struct memblock_type *type, int nid);
--- a/mm/page_alloc.c~memblock-reduce-number-of-parameters-in-for_each_mem_range
+++ a/mm/page_alloc.c
@@ -6990,8 +6990,7 @@ static void __init init_unavailable_mem(
 	 * Loop through unavailable ranges not covered by memblock.memory.
 	 */
 	pgcnt = 0;
-	for_each_mem_range(i, &memblock.memory, NULL,
-			NUMA_NO_NODE, MEMBLOCK_NONE, &start, &end, NULL) {
+	for_each_mem_range(i, &start, &end) {
 		if (next < start)
 			pgcnt += init_unavailable_range(PFN_DOWN(next),
 							PFN_UP(start));
_
