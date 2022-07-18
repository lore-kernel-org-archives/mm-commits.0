Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C757C43334
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:21:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbiGRAVS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232361AbiGRATq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:19:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65807140AE
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:18:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B218DB80E27
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:18:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66193C341C0;
        Mon, 18 Jul 2022 00:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103504;
        bh=b5cpEmD9qjmu72p6gxykVziCh/pXFRHMLEhcHRRjezI=;
        h=Date:To:From:Subject:From;
        b=F/J5hhmpX54SpM3fAfiN3NZebGIEV9SAUkxiH4kzTqlLzk2Pknc8Fy0AIUk+uSoHG
         EOkwMVPIjg5txuK+aM95Mm5FmAs8jcW9TE2SX+1D01hslYBzzkCGd7rub0io3g7kBK
         huoswwHePdt8xA4VW3rWLLlQaMaBAJIQC07WHlAc=
Date:   Sun, 17 Jul 2022 17:18:23 -0700
To:     mm-commits@vger.kernel.org, rmk+kernel@armlinux.org.uk,
        rppt@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm-heads-rename-pmd_order-to-pmd_entry_order.patch removed from -mm tree
Message-Id: <20220718001824.66193C341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ARM: head.S: rename PMD_ORDER to PMD_ENTRY_ORDER
has been removed from the -mm tree.  Its filename was
     arm-heads-rename-pmd_order-to-pmd_entry_order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: ARM: head.S: rename PMD_ORDER to PMD_ENTRY_ORDER
Date: Tue, 5 Jul 2022 18:47:08 +0300

PMD_ORDER denotes order of magnitude for a PMD entry, i.e PMD entry size
is 2 ^ PMD_ORDER.

Rename PMD_ORDER to PMD_ENTRY_ORDER to allow a generic definition of
PMD_ORDER as order of a PMD allocation: (PMD_SHIFT - PAGE_SHIFT).

Link: https://lkml.kernel.org/r/20220705154708.181258-16-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/head.S |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

--- a/arch/arm/kernel/head.S~arm-heads-rename-pmd_order-to-pmd_entry_order
+++ a/arch/arm/kernel/head.S
@@ -38,10 +38,10 @@
 #ifdef CONFIG_ARM_LPAE
 	/* LPAE requires an additional page for the PGD */
 #define PG_DIR_SIZE	0x5000
-#define PMD_ORDER	3
+#define PMD_ENTRY_ORDER	3	/* PMD entry size is 2^PMD_ENTRY_ORDER */
 #else
 #define PG_DIR_SIZE	0x4000
-#define PMD_ORDER	2
+#define PMD_ENTRY_ORDER	2
 #endif
 
 	.globl	swapper_pg_dir
@@ -240,7 +240,7 @@ __create_page_tables:
 	mov	r6, r6, lsr #SECTION_SHIFT
 
 1:	orr	r3, r7, r5, lsl #SECTION_SHIFT	@ flags + kernel base
-	str	r3, [r4, r5, lsl #PMD_ORDER]	@ identity mapping
+	str	r3, [r4, r5, lsl #PMD_ENTRY_ORDER]	@ identity mapping
 	cmp	r5, r6
 	addlo	r5, r5, #1			@ next section
 	blo	1b
@@ -250,7 +250,7 @@ __create_page_tables:
 	 * set two variables to indicate the physical start and end of the
 	 * kernel.
 	 */
-	add	r0, r4, #KERNEL_OFFSET >> (SECTION_SHIFT - PMD_ORDER)
+	add	r0, r4, #KERNEL_OFFSET >> (SECTION_SHIFT - PMD_ENTRY_ORDER)
 	ldr	r6, =(_end - 1)
 	adr_l	r5, kernel_sec_start		@ _pa(kernel_sec_start)
 #if defined CONFIG_CPU_ENDIAN_BE8 || defined CONFIG_CPU_ENDIAN_BE32
@@ -259,8 +259,8 @@ __create_page_tables:
 	str	r8, [r5]			@ Save physical start of kernel (LE)
 #endif
 	orr	r3, r8, r7			@ Add the MMU flags
-	add	r6, r4, r6, lsr #(SECTION_SHIFT - PMD_ORDER)
-1:	str	r3, [r0], #1 << PMD_ORDER
+	add	r6, r4, r6, lsr #(SECTION_SHIFT - PMD_ENTRY_ORDER)
+1:	str	r3, [r0], #1 << PMD_ENTRY_ORDER
 	add	r3, r3, #1 << SECTION_SHIFT
 	cmp	r0, r6
 	bls	1b
@@ -280,14 +280,14 @@ __create_page_tables:
 	mov	r3, pc
 	mov	r3, r3, lsr #SECTION_SHIFT
 	orr	r3, r7, r3, lsl #SECTION_SHIFT
-	add	r0, r4,  #(XIP_START & 0xff000000) >> (SECTION_SHIFT - PMD_ORDER)
-	str	r3, [r0, #((XIP_START & 0x00f00000) >> SECTION_SHIFT) << PMD_ORDER]!
+	add	r0, r4,  #(XIP_START & 0xff000000) >> (SECTION_SHIFT - PMD_ENTRY_ORDER)
+	str	r3, [r0, #((XIP_START & 0x00f00000) >> SECTION_SHIFT) << PMD_ENTRY_ORDER]!
 	ldr	r6, =(_edata_loc - 1)
-	add	r0, r0, #1 << PMD_ORDER
-	add	r6, r4, r6, lsr #(SECTION_SHIFT - PMD_ORDER)
+	add	r0, r0, #1 << PMD_ENTRY_ORDER
+	add	r6, r4, r6, lsr #(SECTION_SHIFT - PMD_ENTRY_ORDER)
 1:	cmp	r0, r6
 	add	r3, r3, #1 << SECTION_SHIFT
-	strls	r3, [r0], #1 << PMD_ORDER
+	strls	r3, [r0], #1 << PMD_ENTRY_ORDER
 	bls	1b
 #endif
 
@@ -297,10 +297,10 @@ __create_page_tables:
 	 */
 	mov	r0, r2, lsr #SECTION_SHIFT
 	cmp	r2, #0
-	ldrne	r3, =FDT_FIXED_BASE >> (SECTION_SHIFT - PMD_ORDER)
+	ldrne	r3, =FDT_FIXED_BASE >> (SECTION_SHIFT - PMD_ENTRY_ORDER)
 	addne	r3, r3, r4
 	orrne	r6, r7, r0, lsl #SECTION_SHIFT
-	strne	r6, [r3], #1 << PMD_ORDER
+	strne	r6, [r3], #1 << PMD_ENTRY_ORDER
 	addne	r6, r6, #1 << SECTION_SHIFT
 	strne	r6, [r3]
 
@@ -319,7 +319,7 @@ __create_page_tables:
 	addruart r7, r3, r0
 
 	mov	r3, r3, lsr #SECTION_SHIFT
-	mov	r3, r3, lsl #PMD_ORDER
+	mov	r3, r3, lsl #PMD_ENTRY_ORDER
 
 	add	r0, r4, r3
 	mov	r3, r7, lsr #SECTION_SHIFT
@@ -349,7 +349,7 @@ __create_page_tables:
 	 * If we're using the NetWinder or CATS, we also need to map
 	 * in the 16550-type serial port for the debug messages
 	 */
-	add	r0, r4, #0xff000000 >> (SECTION_SHIFT - PMD_ORDER)
+	add	r0, r4, #0xff000000 >> (SECTION_SHIFT - PMD_ENTRY_ORDER)
 	orr	r3, r7, #0x7c000000
 	str	r3, [r0]
 #endif
@@ -359,10 +359,10 @@ __create_page_tables:
 	 * Similar reasons here - for debug.  This is
 	 * only for Acorn RiscPC architectures.
 	 */
-	add	r0, r4, #0x02000000 >> (SECTION_SHIFT - PMD_ORDER)
+	add	r0, r4, #0x02000000 >> (SECTION_SHIFT - PMD_ENTRY_ORDER)
 	orr	r3, r7, #0x02000000
 	str	r3, [r0]
-	add	r0, r4, #0xd8000000 >> (SECTION_SHIFT - PMD_ORDER)
+	add	r0, r4, #0xd8000000 >> (SECTION_SHIFT - PMD_ENTRY_ORDER)
 	str	r3, [r0]
 #endif
 #endif
_

Patches currently in -mm which might be from rppt@linux.ibm.com are


