From: akpm@linux-foundation.org
Subject: [merged] xtensa-s6000-variant-core-definitions.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:39:36 -0700
Message-ID: <200904061939.n36Jda0d013978@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52526 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752045AbZDFUbr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 16:31:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jw@emlix.com, chris@zankel.net, dg@emlix.com, os@emlix.com, mm-commits@vger.kernel.org


The patch titled
     xtensa: s6000 variant core definitions
has been removed from the -mm tree.  Its filename was
     xtensa-s6000-variant-core-definitions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xtensa: s6000 variant core definitions
From: Johannes Weiner <jw@emlix.com>

S6000 core configuration files from Tensilica.

Signed-off-by: Johannes Weiner <jw@emlix.com>
Cc: Oskar Schirmer <os@emlix.com>
Cc: Daniel Glockner <dg@emlix.com>
Cc: Christian Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/variants/s6000/include/variant/core.h    |  431 ++++++++++
 arch/xtensa/variants/s6000/include/variant/tie-asm.h |  304 +++++++
 arch/xtensa/variants/s6000/include/variant/tie.h     |  191 ++++
 3 files changed, 926 insertions(+)

diff -puN /dev/null arch/xtensa/variants/s6000/include/variant/core.h
--- /dev/null
+++ a/arch/xtensa/variants/s6000/include/variant/core.h
@@ -0,0 +1,431 @@
+/*
+ * Xtensa processor core configuration information.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (c) 1999-2008 Tensilica Inc.
+ */
+
+#ifndef _XTENSA_CORE_CONFIGURATION_H
+#define _XTENSA_CORE_CONFIGURATION_H
+
+
+/****************************************************************************
+	    Parameters Useful for Any Code, USER or PRIVILEGED
+ ****************************************************************************/
+
+/*
+ *  Note:  Macros of the form XCHAL_HAVE_*** have a value of 1 if the option is
+ *  configured, and a value of 0 otherwise.  These macros are always defined.
+ */
+
+
+/*----------------------------------------------------------------------
+				ISA
+  ----------------------------------------------------------------------*/
+
+#define XCHAL_HAVE_BE			0	/* big-endian byte ordering */
+#define XCHAL_HAVE_WINDOWED		1	/* windowed registers option */
+#define XCHAL_NUM_AREGS			64	/* num of physical addr regs */
+#define XCHAL_NUM_AREGS_LOG2		6	/* log2(XCHAL_NUM_AREGS) */
+#define XCHAL_MAX_INSTRUCTION_SIZE	8	/* max instr bytes (3..8) */
+#define XCHAL_HAVE_DEBUG		1	/* debug option */
+#define XCHAL_HAVE_DENSITY		1	/* 16-bit instructions */
+#define XCHAL_HAVE_LOOPS		1	/* zero-overhead loops */
+#define XCHAL_HAVE_NSA			1	/* NSA/NSAU instructions */
+#define XCHAL_HAVE_MINMAX		1	/* MIN/MAX instructions */
+#define XCHAL_HAVE_SEXT			1	/* SEXT instruction */
+#define XCHAL_HAVE_CLAMPS		1	/* CLAMPS instruction */
+#define XCHAL_HAVE_MUL16		1	/* MUL16S/MUL16U instructions */
+#define XCHAL_HAVE_MUL32		1	/* MULL instruction */
+#define XCHAL_HAVE_MUL32_HIGH		1	/* MULUH/MULSH instructions */
+#define XCHAL_HAVE_DIV32		0	/* QUOS/QUOU/REMS/REMU instructions */
+#define XCHAL_HAVE_L32R			1	/* L32R instruction */
+#define XCHAL_HAVE_ABSOLUTE_LITERALS	1	/* non-PC-rel (extended) L32R */
+#define XCHAL_HAVE_CONST16		0	/* CONST16 instruction */
+#define XCHAL_HAVE_ADDX			1	/* ADDX#/SUBX# instructions */
+#define XCHAL_HAVE_WIDE_BRANCHES	0	/* B*.W18 or B*.W15 instr's */
+#define XCHAL_HAVE_PREDICTED_BRANCHES	0	/* B[EQ/EQZ/NE/NEZ]T instr's */
+#define XCHAL_HAVE_CALL4AND12		1	/* (obsolete option) */
+#define XCHAL_HAVE_ABS			1	/* ABS instruction */
+/*#define XCHAL_HAVE_POPC		0*/	/* POPC instruction */
+/*#define XCHAL_HAVE_CRC		0*/	/* CRC instruction */
+#define XCHAL_HAVE_RELEASE_SYNC		0	/* L32AI/S32RI instructions */
+#define XCHAL_HAVE_S32C1I		0	/* S32C1I instruction */
+#define XCHAL_HAVE_SPECULATION		0	/* speculation */
+#define XCHAL_HAVE_FULL_RESET		0	/* all regs/state reset */
+#define XCHAL_NUM_CONTEXTS		1	/* */
+#define XCHAL_NUM_MISC_REGS		4	/* num of scratch regs (0..4) */
+#define XCHAL_HAVE_TAP_MASTER		0	/* JTAG TAP control instr's */
+#define XCHAL_HAVE_PRID			0	/* processor ID register */
+#define XCHAL_HAVE_THREADPTR		0	/* THREADPTR register */
+#define XCHAL_HAVE_BOOLEANS		1	/* boolean registers */
+#define XCHAL_HAVE_CP			1	/* CPENABLE reg (coprocessor) */
+#define XCHAL_CP_MAXCFG			8	/* max allowed cp id plus one */
+#define XCHAL_HAVE_MAC16		0	/* MAC16 package */
+#define XCHAL_HAVE_VECTORFPU2005	0	/* vector floating-point pkg */
+#define XCHAL_HAVE_FP			1	/* floating point pkg */
+#define XCHAL_HAVE_VECTRA1		0	/* Vectra I  pkg */
+#define XCHAL_HAVE_VECTRALX		0	/* Vectra LX pkg */
+#define XCHAL_HAVE_HIFI2		0	/* HiFi2 Audio Engine pkg */
+
+
+/*----------------------------------------------------------------------
+				MISC
+  ----------------------------------------------------------------------*/
+
+#define XCHAL_NUM_WRITEBUFFER_ENTRIES	8	/* size of write buffer */
+#define XCHAL_INST_FETCH_WIDTH		8	/* instr-fetch width in bytes */
+#define XCHAL_DATA_WIDTH		16	/* data width in bytes */
+/*  In T1050, applies to selected core load and store instructions (see ISA): */
+#define XCHAL_UNALIGNED_LOAD_EXCEPTION	1	/* unaligned loads cause exc. */
+#define XCHAL_UNALIGNED_STORE_EXCEPTION	1	/* unaligned stores cause exc.*/
+
+#define XCHAL_SW_VERSION		701001	/* sw version of this header */
+
+#define XCHAL_CORE_ID			"stretch_bali"	/* alphanum core name
+						   (CoreID) set in the Xtensa
+						   Processor Generator */
+
+#define XCHAL_BUILD_UNIQUE_ID		0x000104B9	/* 22-bit sw build ID */
+
+/*
+ *  These definitions describe the hardware targeted by this software.
+ */
+#define XCHAL_HW_CONFIGID0		0xC2F3F9FE	/* ConfigID hi 32 bits*/
+#define XCHAL_HW_CONFIGID1		0x054104B9	/* ConfigID lo 32 bits*/
+#define XCHAL_HW_VERSION_NAME		"LX1.0.2"	/* full version name */
+#define XCHAL_HW_VERSION_MAJOR		2100	/* major ver# of targeted hw */
+#define XCHAL_HW_VERSION_MINOR		2	/* minor ver# of targeted hw */
+#define XCHAL_HW_VERSION		210002	/* major*100+minor */
+#define XCHAL_HW_REL_LX1		1
+#define XCHAL_HW_REL_LX1_0		1
+#define XCHAL_HW_REL_LX1_0_2		1
+#define XCHAL_HW_CONFIGID_RELIABLE	1
+/*  If software targets a *range* of hardware versions, these are the bounds: */
+#define XCHAL_HW_MIN_VERSION_MAJOR	2100	/* major v of earliest tgt hw */
+#define XCHAL_HW_MIN_VERSION_MINOR	2	/* minor v of earliest tgt hw */
+#define XCHAL_HW_MIN_VERSION		210002	/* earliest targeted hw */
+#define XCHAL_HW_MAX_VERSION_MAJOR	2100	/* major v of latest tgt hw */
+#define XCHAL_HW_MAX_VERSION_MINOR	2	/* minor v of latest tgt hw */
+#define XCHAL_HW_MAX_VERSION		210002	/* latest targeted hw */
+
+
+/*----------------------------------------------------------------------
+				CACHE
+  ----------------------------------------------------------------------*/
+
+#define XCHAL_ICACHE_LINESIZE		16	/* I-cache line size in bytes */
+#define XCHAL_DCACHE_LINESIZE		16	/* D-cache line size in bytes */
+#define XCHAL_ICACHE_LINEWIDTH		4	/* log2(I line size in bytes) */
+#define XCHAL_DCACHE_LINEWIDTH		4	/* log2(D line size in bytes) */
+
+#define XCHAL_ICACHE_SIZE		32768	/* I-cache size in bytes or 0 */
+#define XCHAL_DCACHE_SIZE		32768	/* D-cache size in bytes or 0 */
+
+#define XCHAL_DCACHE_IS_WRITEBACK	1	/* writeback feature */
+
+
+
+
+/****************************************************************************
+    Parameters Useful for PRIVILEGED (Supervisory or Non-Virtualized) Code
+ ****************************************************************************/
+
+
+#ifndef XTENSA_HAL_NON_PRIVILEGED_ONLY
+
+/*----------------------------------------------------------------------
+				CACHE
+  ----------------------------------------------------------------------*/
+
+#define XCHAL_HAVE_PIF			1	/* any outbound PIF present */
+
+/*  If present, cache size in bytes == (ways * 2^(linewidth + setwidth)).  */
+
+/*  Number of cache sets in log2(lines per way):  */
+#define XCHAL_ICACHE_SETWIDTH		9
+#define XCHAL_DCACHE_SETWIDTH		10
+
+/*  Cache set associativity (number of ways):  */
+#define XCHAL_ICACHE_WAYS		4
+#define XCHAL_DCACHE_WAYS		2
+
+/*  Cache features:  */
+#define XCHAL_ICACHE_LINE_LOCKABLE	1
+#define XCHAL_DCACHE_LINE_LOCKABLE	0
+#define XCHAL_ICACHE_ECC_PARITY		0
+#define XCHAL_DCACHE_ECC_PARITY		0
+
+/*  Number of encoded cache attr bits (see <xtensa/hal.h> for decoded bits):  */
+#define XCHAL_CA_BITS			4
+
+
+/*----------------------------------------------------------------------
+			INTERNAL I/D RAM/ROMs and XLMI
+  ----------------------------------------------------------------------*/
+
+#define XCHAL_NUM_INSTROM		0	/* number of core instr. ROMs */
+#define XCHAL_NUM_INSTRAM		0	/* number of core instr. RAMs */
+#define XCHAL_NUM_DATAROM		0	/* number of core data ROMs */
+#define XCHAL_NUM_DATARAM		1	/* number of core data RAMs */
+#define XCHAL_NUM_URAM			0	/* number of core unified RAMs*/
+#define XCHAL_NUM_XLMI			1	/* number of core XLMI ports */
+
+/*  Data RAM 0:  */
+#define XCHAL_DATARAM0_VADDR		0x3FFF0000
+#define XCHAL_DATARAM0_PADDR		0x3FFF0000
+#define XCHAL_DATARAM0_SIZE		65536
+#define XCHAL_DATARAM0_ECC_PARITY	0
+
+/*  XLMI Port 0:  */
+#define XCHAL_XLMI0_VADDR		0x37F80000
+#define XCHAL_XLMI0_PADDR		0x37F80000
+#define XCHAL_XLMI0_SIZE		262144
+#define XCHAL_XLMI0_ECC_PARITY	0
+
+
+/*----------------------------------------------------------------------
+			INTERRUPTS and TIMERS
+  ----------------------------------------------------------------------*/
+
+#define XCHAL_HAVE_INTERRUPTS		1	/* interrupt option */
+#define XCHAL_HAVE_HIGHPRI_INTERRUPTS	1	/* med/high-pri. interrupts */
+#define XCHAL_HAVE_NMI			1	/* non-maskable interrupt */
+#define XCHAL_HAVE_CCOUNT		1	/* CCOUNT reg. (timer option) */
+#define XCHAL_NUM_TIMERS		3	/* number of CCOMPAREn regs */
+#define XCHAL_NUM_INTERRUPTS		27	/* number of interrupts */
+#define XCHAL_NUM_INTERRUPTS_LOG2	5	/* ceil(log2(NUM_INTERRUPTS)) */
+#define XCHAL_NUM_EXTINTERRUPTS		20	/* num of external interrupts */
+#define XCHAL_NUM_INTLEVELS		4	/* number of interrupt levels
+						   (not including level zero) */
+#define XCHAL_EXCM_LEVEL		1	/* level masked by PS.EXCM */
+	/* (always 1 in XEA1; levels 2 .. EXCM_LEVEL are "medium priority") */
+
+/*  Masks of interrupts at each interrupt level:  */
+#define XCHAL_INTLEVEL1_MASK		0x01F07FFF
+#define XCHAL_INTLEVEL2_MASK		0x02018000
+#define XCHAL_INTLEVEL3_MASK		0x04060000
+#define XCHAL_INTLEVEL4_MASK		0x00000000
+#define XCHAL_INTLEVEL5_MASK		0x00080000
+#define XCHAL_INTLEVEL6_MASK		0x00000000
+#define XCHAL_INTLEVEL7_MASK		0x00000000
+
+/*  Masks of interrupts at each range 1..n of interrupt levels:  */
+#define XCHAL_INTLEVEL1_ANDBELOW_MASK	0x01F07FFF
+#define XCHAL_INTLEVEL2_ANDBELOW_MASK	0x03F1FFFF
+#define XCHAL_INTLEVEL3_ANDBELOW_MASK	0x07F7FFFF
+#define XCHAL_INTLEVEL4_ANDBELOW_MASK	0x07F7FFFF
+#define XCHAL_INTLEVEL5_ANDBELOW_MASK	0x07FFFFFF
+#define XCHAL_INTLEVEL6_ANDBELOW_MASK	0x07FFFFFF
+#define XCHAL_INTLEVEL7_ANDBELOW_MASK	0x07FFFFFF
+
+/*  Level of each interrupt:  */
+#define XCHAL_INT0_LEVEL		1
+#define XCHAL_INT1_LEVEL		1
+#define XCHAL_INT2_LEVEL		1
+#define XCHAL_INT3_LEVEL		1
+#define XCHAL_INT4_LEVEL		1
+#define XCHAL_INT5_LEVEL		1
+#define XCHAL_INT6_LEVEL		1
+#define XCHAL_INT7_LEVEL		1
+#define XCHAL_INT8_LEVEL		1
+#define XCHAL_INT9_LEVEL		1
+#define XCHAL_INT10_LEVEL		1
+#define XCHAL_INT11_LEVEL		1
+#define XCHAL_INT12_LEVEL		1
+#define XCHAL_INT13_LEVEL		1
+#define XCHAL_INT14_LEVEL		1
+#define XCHAL_INT15_LEVEL		2
+#define XCHAL_INT16_LEVEL		2
+#define XCHAL_INT17_LEVEL		3
+#define XCHAL_INT18_LEVEL		3
+#define XCHAL_INT19_LEVEL		5
+#define XCHAL_INT20_LEVEL		1
+#define XCHAL_INT21_LEVEL		1
+#define XCHAL_INT22_LEVEL		1
+#define XCHAL_INT23_LEVEL		1
+#define XCHAL_INT24_LEVEL		1
+#define XCHAL_INT25_LEVEL		2
+#define XCHAL_INT26_LEVEL		3
+#define XCHAL_DEBUGLEVEL		4	/* debug interrupt level */
+#define XCHAL_HAVE_DEBUG_EXTERN_INT	1	/* OCD external db interrupt */
+#define XCHAL_NMILEVEL			5	/* NMI "level" (for use with
+						   EXCSAVE/EPS/EPC_n, RFI n) */
+
+/*  Type of each interrupt:  */
+#define XCHAL_INT0_TYPE 	XTHAL_INTTYPE_EXTERN_LEVEL
+#define XCHAL_INT1_TYPE 	XTHAL_INTTYPE_EXTERN_LEVEL
+#define XCHAL_INT2_TYPE 	XTHAL_INTTYPE_EXTERN_LEVEL
+#define XCHAL_INT3_TYPE 	XTHAL_INTTYPE_EXTERN_LEVEL
+#define XCHAL_INT4_TYPE 	XTHAL_INTTYPE_EXTERN_LEVEL
+#define XCHAL_INT5_TYPE 	XTHAL_INTTYPE_EXTERN_LEVEL
+#define XCHAL_INT6_TYPE 	XTHAL_INTTYPE_EXTERN_LEVEL
+#define XCHAL_INT7_TYPE 	XTHAL_INTTYPE_EXTERN_LEVEL
+#define XCHAL_INT8_TYPE 	XTHAL_INTTYPE_EXTERN_LEVEL
+#define XCHAL_INT9_TYPE 	XTHAL_INTTYPE_EXTERN_LEVEL
+#define XCHAL_INT10_TYPE 	XTHAL_INTTYPE_EXTERN_LEVEL
+#define XCHAL_INT11_TYPE 	XTHAL_INTTYPE_EXTERN_LEVEL
+#define XCHAL_INT12_TYPE 	XTHAL_INTTYPE_EXTERN_LEVEL
+#define XCHAL_INT13_TYPE 	XTHAL_INTTYPE_EXTERN_LEVEL
+#define XCHAL_INT14_TYPE 	XTHAL_INTTYPE_EXTERN_LEVEL
+#define XCHAL_INT15_TYPE 	XTHAL_INTTYPE_EXTERN_LEVEL
+#define XCHAL_INT16_TYPE 	XTHAL_INTTYPE_EXTERN_LEVEL
+#define XCHAL_INT17_TYPE 	XTHAL_INTTYPE_EXTERN_LEVEL
+#define XCHAL_INT18_TYPE 	XTHAL_INTTYPE_EXTERN_LEVEL
+#define XCHAL_INT19_TYPE 	XTHAL_INTTYPE_NMI
+#define XCHAL_INT20_TYPE 	XTHAL_INTTYPE_SOFTWARE
+#define XCHAL_INT21_TYPE 	XTHAL_INTTYPE_SOFTWARE
+#define XCHAL_INT22_TYPE 	XTHAL_INTTYPE_SOFTWARE
+#define XCHAL_INT23_TYPE 	XTHAL_INTTYPE_SOFTWARE
+#define XCHAL_INT24_TYPE 	XTHAL_INTTYPE_TIMER
+#define XCHAL_INT25_TYPE 	XTHAL_INTTYPE_TIMER
+#define XCHAL_INT26_TYPE 	XTHAL_INTTYPE_TIMER
+
+/*  Masks of interrupts for each type of interrupt:  */
+#define XCHAL_INTTYPE_MASK_UNCONFIGURED	0xF8000000
+#define XCHAL_INTTYPE_MASK_SOFTWARE	0x00F00000
+#define XCHAL_INTTYPE_MASK_EXTERN_EDGE	0x00000000
+#define XCHAL_INTTYPE_MASK_EXTERN_LEVEL	0x0007FFFF
+#define XCHAL_INTTYPE_MASK_TIMER	0x07000000
+#define XCHAL_INTTYPE_MASK_NMI		0x00080000
+#define XCHAL_INTTYPE_MASK_WRITE_ERROR	0x00000000
+
+/*  Interrupt numbers assigned to specific interrupt sources:  */
+#define XCHAL_TIMER0_INTERRUPT		24	/* CCOMPARE0 */
+#define XCHAL_TIMER1_INTERRUPT		25	/* CCOMPARE1 */
+#define XCHAL_TIMER2_INTERRUPT		26	/* CCOMPARE2 */
+#define XCHAL_TIMER3_INTERRUPT		XTHAL_TIMER_UNCONFIGURED
+#define XCHAL_NMI_INTERRUPT		19	/* non-maskable interrupt */
+
+/*  Interrupt numbers for levels at which only one interrupt is configured:  */
+#define XCHAL_INTLEVEL5_NUM		19
+/*  (There are many interrupts each at level(s) 1, 2, 3.)  */
+
+
+/*
+ *  External interrupt vectors/levels.
+ *  These macros describe how Xtensa processor interrupt numbers
+ *  (as numbered internally, eg. in INTERRUPT and INTENABLE registers)
+ *  map to external BInterrupt<n> pins, for those interrupts
+ *  configured as external (level-triggered, edge-triggered, or NMI).
+ *  See the Xtensa processor databook for more details.
+ */
+
+/*  Core interrupt numbers mapped to each EXTERNAL interrupt number:  */
+#define XCHAL_EXTINT0_NUM		0	/* (intlevel 1) */
+#define XCHAL_EXTINT1_NUM		1	/* (intlevel 1) */
+#define XCHAL_EXTINT2_NUM		2	/* (intlevel 1) */
+#define XCHAL_EXTINT3_NUM		3	/* (intlevel 1) */
+#define XCHAL_EXTINT4_NUM		4	/* (intlevel 1) */
+#define XCHAL_EXTINT5_NUM		5	/* (intlevel 1) */
+#define XCHAL_EXTINT6_NUM		6	/* (intlevel 1) */
+#define XCHAL_EXTINT7_NUM		7	/* (intlevel 1) */
+#define XCHAL_EXTINT8_NUM		8	/* (intlevel 1) */
+#define XCHAL_EXTINT9_NUM		9	/* (intlevel 1) */
+#define XCHAL_EXTINT10_NUM		10	/* (intlevel 1) */
+#define XCHAL_EXTINT11_NUM		11	/* (intlevel 1) */
+#define XCHAL_EXTINT12_NUM		12	/* (intlevel 1) */
+#define XCHAL_EXTINT13_NUM		13	/* (intlevel 1) */
+#define XCHAL_EXTINT14_NUM		14	/* (intlevel 1) */
+#define XCHAL_EXTINT15_NUM		15	/* (intlevel 2) */
+#define XCHAL_EXTINT16_NUM		16	/* (intlevel 2) */
+#define XCHAL_EXTINT17_NUM		17	/* (intlevel 3) */
+#define XCHAL_EXTINT18_NUM		18	/* (intlevel 3) */
+#define XCHAL_EXTINT19_NUM		19	/* (intlevel 5) */
+
+
+/*----------------------------------------------------------------------
+			EXCEPTIONS and VECTORS
+  ----------------------------------------------------------------------*/
+
+#define XCHAL_XEA_VERSION		2	/* Xtensa Exception Architecture
+						   number: 1 == XEA1 (old)
+							   2 == XEA2 (new)
+							   0 == XEAX (extern) */
+#define XCHAL_HAVE_XEA1			0	/* Exception Architecture 1 */
+#define XCHAL_HAVE_XEA2			1	/* Exception Architecture 2 */
+#define XCHAL_HAVE_XEAX			0	/* External Exception Arch. */
+#define XCHAL_HAVE_EXCEPTIONS		1	/* exception option */
+#define XCHAL_HAVE_MEM_ECC_PARITY	0	/* local memory ECC/parity */
+#define XCHAL_HAVE_VECTOR_SELECT	0	/* relocatable vectors */
+#define XCHAL_HAVE_VECBASE		0	/* relocatable vectors */
+
+#define XCHAL_RESET_VECOFS		0x00000000
+#define XCHAL_RESET_VECTOR_VADDR	0x3FFE03D0
+#define XCHAL_RESET_VECTOR_PADDR	0x3FFE03D0
+#define XCHAL_USER_VECOFS		0x00000000
+#define XCHAL_USER_VECTOR_VADDR		0x40000220
+#define XCHAL_USER_VECTOR_PADDR		0x40000220
+#define XCHAL_KERNEL_VECOFS		0x00000000
+#define XCHAL_KERNEL_VECTOR_VADDR	0x40000200
+#define XCHAL_KERNEL_VECTOR_PADDR	0x40000200
+#define XCHAL_DOUBLEEXC_VECOFS		0x00000000
+#define XCHAL_DOUBLEEXC_VECTOR_VADDR	0x400002A0
+#define XCHAL_DOUBLEEXC_VECTOR_PADDR	0x400002A0
+#define XCHAL_WINDOW_OF4_VECOFS		0x00000000
+#define XCHAL_WINDOW_UF4_VECOFS		0x00000040
+#define XCHAL_WINDOW_OF8_VECOFS		0x00000080
+#define XCHAL_WINDOW_UF8_VECOFS		0x000000C0
+#define XCHAL_WINDOW_OF12_VECOFS	0x00000100
+#define XCHAL_WINDOW_UF12_VECOFS	0x00000140
+#define XCHAL_WINDOW_VECTORS_VADDR	0x40000000
+#define XCHAL_WINDOW_VECTORS_PADDR	0x40000000
+#define XCHAL_INTLEVEL2_VECOFS		0x00000000
+#define XCHAL_INTLEVEL2_VECTOR_VADDR	0x40000240
+#define XCHAL_INTLEVEL2_VECTOR_PADDR	0x40000240
+#define XCHAL_INTLEVEL3_VECOFS		0x00000000
+#define XCHAL_INTLEVEL3_VECTOR_VADDR	0x40000260
+#define XCHAL_INTLEVEL3_VECTOR_PADDR	0x40000260
+#define XCHAL_INTLEVEL4_VECOFS		0x00000000
+#define XCHAL_INTLEVEL4_VECTOR_VADDR	0x40000390
+#define XCHAL_INTLEVEL4_VECTOR_PADDR	0x40000390
+#define XCHAL_DEBUG_VECOFS		XCHAL_INTLEVEL4_VECOFS
+#define XCHAL_DEBUG_VECTOR_VADDR	XCHAL_INTLEVEL4_VECTOR_VADDR
+#define XCHAL_DEBUG_VECTOR_PADDR	XCHAL_INTLEVEL4_VECTOR_PADDR
+#define XCHAL_NMI_VECOFS		0x00000000
+#define XCHAL_NMI_VECTOR_VADDR		0x400003B0
+#define XCHAL_NMI_VECTOR_PADDR		0x400003B0
+#define XCHAL_INTLEVEL5_VECOFS		XCHAL_NMI_VECOFS
+#define XCHAL_INTLEVEL5_VECTOR_VADDR	XCHAL_NMI_VECTOR_VADDR
+#define XCHAL_INTLEVEL5_VECTOR_PADDR	XCHAL_NMI_VECTOR_PADDR
+
+
+/*----------------------------------------------------------------------
+				DEBUG
+  ----------------------------------------------------------------------*/
+
+#define XCHAL_HAVE_OCD			1	/* OnChipDebug option */
+#define XCHAL_NUM_IBREAK		2	/* number of IBREAKn regs */
+#define XCHAL_NUM_DBREAK		2	/* number of DBREAKn regs */
+#define XCHAL_HAVE_OCD_DIR_ARRAY	1	/* faster OCD option */
+
+
+/*----------------------------------------------------------------------
+				MMU
+  ----------------------------------------------------------------------*/
+
+/*  See core-matmap.h header file for more details.  */
+
+#define XCHAL_HAVE_TLBS			1	/* inverse of HAVE_CACHEATTR */
+#define XCHAL_HAVE_SPANNING_WAY		1	/* one way maps I+D 4GB vaddr */
+#define XCHAL_HAVE_IDENTITY_MAP		1	/* vaddr == paddr always */
+#define XCHAL_HAVE_CACHEATTR		0	/* CACHEATTR register present */
+#define XCHAL_HAVE_MIMIC_CACHEATTR	1	/* region protection */
+#define XCHAL_HAVE_XLT_CACHEATTR	0	/* region prot. w/translation */
+#define XCHAL_HAVE_PTP_MMU		0	/* full MMU (with page table
+						   [autorefill] and protection)
+						   usable for an MMU-based OS */
+/*  If none of the above last 4 are set, it's a custom TLB configuration.  */
+
+#define XCHAL_MMU_ASID_BITS		0	/* number of bits in ASIDs */
+#define XCHAL_MMU_RINGS			1	/* number of rings (1..4) */
+#define XCHAL_MMU_RING_BITS		0	/* num of bits in RING field */
+
+#endif /* !XTENSA_HAL_NON_PRIVILEGED_ONLY */
+
+
+#endif /* _XTENSA_CORE_CONFIGURATION_H */
+
diff -puN /dev/null arch/xtensa/variants/s6000/include/variant/tie-asm.h
--- /dev/null
+++ a/arch/xtensa/variants/s6000/include/variant/tie-asm.h
@@ -0,0 +1,304 @@
+/*
+ * This header file contains assembly-language definitions (assembly
+ * macros, etc.) for this specific Xtensa processor's TIE extensions
+ * and options.  It is customized to this Xtensa processor configuration.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 1999-2008 Tensilica Inc.
+ */
+
+#ifndef _XTENSA_CORE_TIE_ASM_H
+#define _XTENSA_CORE_TIE_ASM_H
+
+/*  Selection parameter values for save-area save/restore macros:  */
+/*  Option vs. TIE:  */
+#define XTHAL_SAS_TIE	0x0001	/* custom extension or coprocessor */
+#define XTHAL_SAS_OPT	0x0002	/* optional (and not a coprocessor) */
+/*  Whether used automatically by compiler:  */
+#define XTHAL_SAS_NOCC	0x0004	/* not used by compiler w/o special opts/code */
+#define XTHAL_SAS_CC	0x0008	/* used by compiler without special opts/code */
+/*  ABI handling across function calls:  */
+#define XTHAL_SAS_CALR	0x0010	/* caller-saved */
+#define XTHAL_SAS_CALE	0x0020	/* callee-saved */
+#define XTHAL_SAS_GLOB	0x0040	/* global across function calls (in thread) */
+/*  Misc  */
+#define XTHAL_SAS_ALL	0xFFFF	/* include all default NCP contents */
+
+
+
+/* Macro to save all non-coprocessor (extra) custom TIE and optional state
+ * (not including zero-overhead loop registers).
+ * Save area ptr (clobbered):  ptr  (16 byte aligned)
+ * Scratch regs  (clobbered):  at1..at4  (only first XCHAL_NCP_NUM_ATMPS needed)
+ */
+	.macro xchal_ncp_store  ptr at1 at2 at3 at4  continue=0 ofs=-1 select=XTHAL_SAS_ALL
+	xchal_sa_start	\continue, \ofs
+	.ifeq (XTHAL_SAS_OPT | XTHAL_SAS_NOCC | XTHAL_SAS_CALR) & ~\select
+	xchal_sa_align	\ptr, 0, 1024-4, 4, 4
+	rsr	\at1, BR		// boolean option
+	s32i	\at1, \ptr, .Lxchal_ofs_ + 0
+	.set	.Lxchal_ofs_, .Lxchal_ofs_ + 4
+	.endif
+	.endm	// xchal_ncp_store
+
+/* Macro to save all non-coprocessor (extra) custom TIE and optional state
+ * (not including zero-overhead loop registers).
+ * Save area ptr (clobbered):  ptr  (16 byte aligned)
+ * Scratch regs  (clobbered):  at1..at4  (only first XCHAL_NCP_NUM_ATMPS needed)
+ */
+	.macro xchal_ncp_load  ptr at1 at2 at3 at4  continue=0 ofs=-1 select=XTHAL_SAS_ALL
+	xchal_sa_start	\continue, \ofs
+	.ifeq (XTHAL_SAS_OPT | XTHAL_SAS_NOCC | XTHAL_SAS_CALR) & ~\select
+	xchal_sa_align	\ptr, 0, 1024-4, 4, 4
+	l32i	\at1, \ptr, .Lxchal_ofs_ + 0
+	wsr	\at1, BR		// boolean option
+	.set	.Lxchal_ofs_, .Lxchal_ofs_ + 4
+	.endif
+	.endm	// xchal_ncp_load
+
+
+
+#define XCHAL_NCP_NUM_ATMPS	1
+
+
+
+/* Macro to save the state of TIE coprocessor FPU.
+ * Save area ptr (clobbered):  ptr  (16 byte aligned)
+ * Scratch regs  (clobbered):  at1..at4  (only first XCHAL_CP0_NUM_ATMPS needed)
+ */
+#define xchal_cp_FPU_store	xchal_cp0_store
+/* #define xchal_cp_FPU_store_a2	xchal_cp0_store a2 a3 a4 a5 a6 */
+	.macro	xchal_cp0_store  ptr at1 at2 at3 at4  continue=0 ofs=-1 select=XTHAL_SAS_ALL
+	xchal_sa_start \continue, \ofs
+	.ifeq (XTHAL_SAS_TIE | XTHAL_SAS_NOCC | XTHAL_SAS_CALR) & ~\select
+	xchal_sa_align	\ptr, 0, 0, 1, 16
+	rur232	\at1		// FCR
+	s32i	\at1, \ptr, 0
+	rur233	\at1		// FSR
+	s32i	\at1, \ptr, 4
+	SSI f0, \ptr,  8
+	SSI f1, \ptr,  12
+	SSI f2, \ptr,  16
+	SSI f3, \ptr,  20
+	SSI f4, \ptr,  24
+	SSI f5, \ptr,  28
+	SSI f6, \ptr,  32
+	SSI f7, \ptr,  36
+	SSI f8, \ptr,  40
+	SSI f9, \ptr,  44
+	SSI f10, \ptr,  48
+	SSI f11, \ptr,  52
+	SSI f12, \ptr,  56
+	SSI f13, \ptr,  60
+	SSI f14, \ptr,  64
+	SSI f15, \ptr,  68
+	.set	.Lxchal_ofs_, .Lxchal_ofs_ + 72
+	.endif
+	.endm	// xchal_cp0_store
+
+/* Macro to restore the state of TIE coprocessor FPU.
+ * Save area ptr (clobbered):  ptr  (16 byte aligned)
+ * Scratch regs  (clobbered):  at1..at4  (only first XCHAL_CP0_NUM_ATMPS needed)
+ */
+#define xchal_cp_FPU_load	xchal_cp0_load
+/* #define xchal_cp_FPU_load_a2	xchal_cp0_load a2 a3 a4 a5 a6 */
+	.macro	xchal_cp0_load  ptr at1 at2 at3 at4  continue=0 ofs=-1 select=XTHAL_SAS_ALL
+	xchal_sa_start \continue, \ofs
+	.ifeq (XTHAL_SAS_TIE | XTHAL_SAS_NOCC | XTHAL_SAS_CALR) & ~\select
+	xchal_sa_align	\ptr, 0, 0, 1, 16
+	l32i	\at1, \ptr, 0
+	wur232	\at1		// FCR
+	l32i	\at1, \ptr, 4
+	wur233	\at1		// FSR
+	LSI f0, \ptr,  8
+	LSI f1, \ptr,  12
+	LSI f2, \ptr,  16
+	LSI f3, \ptr,  20
+	LSI f4, \ptr,  24
+	LSI f5, \ptr,  28
+	LSI f6, \ptr,  32
+	LSI f7, \ptr,  36
+	LSI f8, \ptr,  40
+	LSI f9, \ptr,  44
+	LSI f10, \ptr,  48
+	LSI f11, \ptr,  52
+	LSI f12, \ptr,  56
+	LSI f13, \ptr,  60
+	LSI f14, \ptr,  64
+	LSI f15, \ptr,  68
+	.set	.Lxchal_ofs_, .Lxchal_ofs_ + 72
+	.endif
+	.endm	// xchal_cp0_load
+
+#define XCHAL_CP0_NUM_ATMPS	1
+
+/* Macro to save the state of TIE coprocessor XAD.
+ * Save area ptr (clobbered):  ptr  (16 byte aligned)
+ * Scratch regs  (clobbered):  at1..at4  (only first XCHAL_CP6_NUM_ATMPS needed)
+ */
+#define xchal_cp_XAD_store	xchal_cp6_store
+/* #define xchal_cp_XAD_store_a2	xchal_cp6_store a2 a3 a4 a5 a6 */
+	.macro	xchal_cp6_store  ptr at1 at2 at3 at4  continue=0 ofs=-1 select=XTHAL_SAS_ALL
+	xchal_sa_start \continue, \ofs
+	.ifeq (XTHAL_SAS_TIE | XTHAL_SAS_NOCC | XTHAL_SAS_CALR) & ~\select
+	xchal_sa_align	\ptr, 0, 0, 1, 16
+	rur0	\at1		// LDCBHI
+	s32i	\at1, \ptr, 0
+	rur1	\at1		// LDCBLO
+	s32i	\at1, \ptr, 4
+	rur2	\at1		// STCBHI
+	s32i	\at1, \ptr, 8
+	rur3	\at1		// STCBLO
+	s32i	\at1, \ptr, 12
+	rur8	\at1		// LDBRBASE
+	s32i	\at1, \ptr, 16
+	rur9	\at1		// LDBROFF
+	s32i	\at1, \ptr, 20
+	rur10	\at1		// LDBRINC
+	s32i	\at1, \ptr, 24
+	rur11	\at1		// STBRBASE
+	s32i	\at1, \ptr, 28
+	rur12	\at1		// STBROFF
+	s32i	\at1, \ptr, 32
+	rur13	\at1		// STBRINC
+	s32i	\at1, \ptr, 36
+	rur24	\at1		// SCRATCH0
+	s32i	\at1, \ptr, 40
+	rur25	\at1		// SCRATCH1
+	s32i	\at1, \ptr, 44
+	rur26	\at1		// SCRATCH2
+	s32i	\at1, \ptr, 48
+	rur27	\at1		// SCRATCH3
+	s32i	\at1, \ptr, 52
+	WRAS128I wra0, \ptr,  64
+	WRAS128I wra1, \ptr,  80
+	WRAS128I wra2, \ptr,  96
+	WRAS128I wra3, \ptr,  112
+	WRAS128I wra4, \ptr,  128
+	WRAS128I wra5, \ptr,  144
+	WRAS128I wra6, \ptr,  160
+	WRAS128I wra7, \ptr,  176
+	WRAS128I wra8, \ptr,  192
+	WRAS128I wra9, \ptr,  208
+	WRAS128I wra10, \ptr,  224
+	WRAS128I wra11, \ptr,  240
+	WRAS128I wra12, \ptr,  256
+	WRAS128I wra13, \ptr,  272
+	WRAS128I wra14, \ptr,  288
+	WRAS128I wra15, \ptr,  304
+	WRBS128I wrb0, \ptr,  320
+	WRBS128I wrb1, \ptr,  336
+	WRBS128I wrb2, \ptr,  352
+	WRBS128I wrb3, \ptr,  368
+	WRBS128I wrb4, \ptr,  384
+	WRBS128I wrb5, \ptr,  400
+	WRBS128I wrb6, \ptr,  416
+	WRBS128I wrb7, \ptr,  432
+	WRBS128I wrb8, \ptr,  448
+	WRBS128I wrb9, \ptr,  464
+	WRBS128I wrb10, \ptr,  480
+	WRBS128I wrb11, \ptr,  496
+	WRBS128I wrb12, \ptr,  512
+	WRBS128I wrb13, \ptr,  528
+	WRBS128I wrb14, \ptr,  544
+	WRBS128I wrb15, \ptr,  560
+	.set	.Lxchal_ofs_, .Lxchal_ofs_ + 576
+	.endif
+	.endm	// xchal_cp6_store
+
+/* Macro to restore the state of TIE coprocessor XAD.
+ * Save area ptr (clobbered):  ptr  (16 byte aligned)
+ * Scratch regs  (clobbered):  at1..at4  (only first XCHAL_CP6_NUM_ATMPS needed)
+ */
+#define xchal_cp_XAD_load	xchal_cp6_load
+/* #define xchal_cp_XAD_load_a2	xchal_cp6_load a2 a3 a4 a5 a6 */
+	.macro	xchal_cp6_load  ptr at1 at2 at3 at4  continue=0 ofs=-1 select=XTHAL_SAS_ALL
+	xchal_sa_start \continue, \ofs
+	.ifeq (XTHAL_SAS_TIE | XTHAL_SAS_NOCC | XTHAL_SAS_CALR) & ~\select
+	xchal_sa_align	\ptr, 0, 0, 1, 16
+	l32i	\at1, \ptr, 0
+	wur0	\at1		// LDCBHI
+	l32i	\at1, \ptr, 4
+	wur1	\at1		// LDCBLO
+	l32i	\at1, \ptr, 8
+	wur2	\at1		// STCBHI
+	l32i	\at1, \ptr, 12
+	wur3	\at1		// STCBLO
+	l32i	\at1, \ptr, 16
+	wur8	\at1		// LDBRBASE
+	l32i	\at1, \ptr, 20
+	wur9	\at1		// LDBROFF
+	l32i	\at1, \ptr, 24
+	wur10	\at1		// LDBRINC
+	l32i	\at1, \ptr, 28
+	wur11	\at1		// STBRBASE
+	l32i	\at1, \ptr, 32
+	wur12	\at1		// STBROFF
+	l32i	\at1, \ptr, 36
+	wur13	\at1		// STBRINC
+	l32i	\at1, \ptr, 40
+	wur24	\at1		// SCRATCH0
+	l32i	\at1, \ptr, 44
+	wur25	\at1		// SCRATCH1
+	l32i	\at1, \ptr, 48
+	wur26	\at1		// SCRATCH2
+	l32i	\at1, \ptr, 52
+	wur27	\at1		// SCRATCH3
+	WRBL128I wrb0, \ptr,  320
+	WRBL128I wrb1, \ptr,  336
+	WRBL128I wrb2, \ptr,  352
+	WRBL128I wrb3, \ptr,  368
+	WRBL128I wrb4, \ptr,  384
+	WRBL128I wrb5, \ptr,  400
+	WRBL128I wrb6, \ptr,  416
+	WRBL128I wrb7, \ptr,  432
+	WRBL128I wrb8, \ptr,  448
+	WRBL128I wrb9, \ptr,  464
+	WRBL128I wrb10, \ptr,  480
+	WRBL128I wrb11, \ptr,  496
+	WRBL128I wrb12, \ptr,  512
+	WRBL128I wrb13, \ptr,  528
+	WRBL128I wrb14, \ptr,  544
+	WRBL128I wrb15, \ptr,  560
+	WRAL128I wra0, \ptr,  64
+	WRAL128I wra1, \ptr,  80
+	WRAL128I wra2, \ptr,  96
+	WRAL128I wra3, \ptr,  112
+	WRAL128I wra4, \ptr,  128
+	WRAL128I wra5, \ptr,  144
+	WRAL128I wra6, \ptr,  160
+	WRAL128I wra7, \ptr,  176
+	WRAL128I wra8, \ptr,  192
+	WRAL128I wra9, \ptr,  208
+	WRAL128I wra10, \ptr,  224
+	WRAL128I wra11, \ptr,  240
+	WRAL128I wra12, \ptr,  256
+	WRAL128I wra13, \ptr,  272
+	WRAL128I wra14, \ptr,  288
+	WRAL128I wra15, \ptr,  304
+	.set	.Lxchal_ofs_, .Lxchal_ofs_ + 576
+	.endif
+	.endm	// xchal_cp6_load
+
+#define XCHAL_CP6_NUM_ATMPS	1
+#define XCHAL_SA_NUM_ATMPS	1
+
+	/*  Empty macros for unconfigured coprocessors:  */
+	.macro xchal_cp1_store	p a b c d continue=0 ofs=-1 select=-1 ; .endm
+	.macro xchal_cp1_load	p a b c d continue=0 ofs=-1 select=-1 ; .endm
+	.macro xchal_cp2_store	p a b c d continue=0 ofs=-1 select=-1 ; .endm
+	.macro xchal_cp2_load	p a b c d continue=0 ofs=-1 select=-1 ; .endm
+	.macro xchal_cp3_store	p a b c d continue=0 ofs=-1 select=-1 ; .endm
+	.macro xchal_cp3_load	p a b c d continue=0 ofs=-1 select=-1 ; .endm
+	.macro xchal_cp4_store	p a b c d continue=0 ofs=-1 select=-1 ; .endm
+	.macro xchal_cp4_load	p a b c d continue=0 ofs=-1 select=-1 ; .endm
+	.macro xchal_cp5_store	p a b c d continue=0 ofs=-1 select=-1 ; .endm
+	.macro xchal_cp5_load	p a b c d continue=0 ofs=-1 select=-1 ; .endm
+	.macro xchal_cp7_store	p a b c d continue=0 ofs=-1 select=-1 ; .endm
+	.macro xchal_cp7_load	p a b c d continue=0 ofs=-1 select=-1 ; .endm
+
+#endif /*_XTENSA_CORE_TIE_ASM_H*/
+
diff -puN /dev/null arch/xtensa/variants/s6000/include/variant/tie.h
--- /dev/null
+++ a/arch/xtensa/variants/s6000/include/variant/tie.h
@@ -0,0 +1,191 @@
+/*
+ * This header file describes this specific Xtensa processor's TIE extensions
+ * that extend basic Xtensa core functionality.  It is customized to this
+ * Xtensa processor configuration.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 1999-2008 Tensilica Inc.
+ */
+
+#ifndef _XTENSA_CORE_TIE_H
+#define _XTENSA_CORE_TIE_H
+
+#define XCHAL_CP_NUM			2	/* number of coprocessors */
+#define XCHAL_CP_MAX			7	/* max CP ID + 1 (0 if none) */
+#define XCHAL_CP_MASK			0x41	/* bitmask of all CPs by ID */
+#define XCHAL_CP_PORT_MASK		0x00	/* bitmask of only port CPs */
+
+/*  Basic parameters of each coprocessor:  */
+#define XCHAL_CP0_NAME			"FPU"
+#define XCHAL_CP0_IDENT			FPU
+#define XCHAL_CP0_SA_SIZE		72	/* size of state save area */
+#define XCHAL_CP0_SA_ALIGN		4	/* min alignment of save area */
+#define XCHAL_CP_ID_FPU			0	/* coprocessor ID (0..7) */
+#define XCHAL_CP6_NAME			"XAD"
+#define XCHAL_CP6_IDENT			XAD
+#define XCHAL_CP6_SA_SIZE		576	/* size of state save area */
+#define XCHAL_CP6_SA_ALIGN		16	/* min alignment of save area */
+#define XCHAL_CP_ID_XAD			6	/* coprocessor ID (0..7) */
+
+/*  Filler info for unassigned coprocessors, to simplify arrays etc:  */
+#define XCHAL_CP1_SA_SIZE		0
+#define XCHAL_CP1_SA_ALIGN		1
+#define XCHAL_CP2_SA_SIZE		0
+#define XCHAL_CP2_SA_ALIGN		1
+#define XCHAL_CP3_SA_SIZE		0
+#define XCHAL_CP3_SA_ALIGN		1
+#define XCHAL_CP4_SA_SIZE		0
+#define XCHAL_CP4_SA_ALIGN		1
+#define XCHAL_CP5_SA_SIZE		0
+#define XCHAL_CP5_SA_ALIGN		1
+#define XCHAL_CP7_SA_SIZE		0
+#define XCHAL_CP7_SA_ALIGN		1
+
+/*  Save area for non-coprocessor optional and custom (TIE) state:  */
+#define XCHAL_NCP_SA_SIZE		4
+#define XCHAL_NCP_SA_ALIGN		4
+
+/*  Total save area for optional and custom state (NCP + CPn):  */
+#define XCHAL_TOTAL_SA_SIZE		672	/* with 16-byte align padding */
+#define XCHAL_TOTAL_SA_ALIGN		16	/* actual minimum alignment */
+
+/*
+ * Detailed contents of save areas.
+ * NOTE:  caller must define the XCHAL_SA_REG macro (not defined here)
+ * before expanding the XCHAL_xxx_SA_LIST() macros.
+ *
+ * XCHAL_SA_REG(s,ccused,abikind,kind,opt,name,galign,align,asize,
+ *		dbnum,base,regnum,bitsz,gapsz,reset,x...)
+ *
+ *	s = passed from XCHAL_*_LIST(s), eg. to select how to expand
+ *	ccused = set if used by compiler without special options or code
+ *	abikind = 0 (caller-saved), 1 (callee-saved), or 2 (thread-global)
+ *	kind = 0 (special reg), 1 (TIE user reg), or 2 (TIE regfile reg)
+ *	opt = 0 (custom TIE extension or coprocessor), or 1 (optional reg)
+ *	name = lowercase reg name (no quotes)
+ *	galign = group byte alignment (power of 2) (galign >= align)
+ *	align = register byte alignment (power of 2)
+ *	asize = allocated size in bytes (asize*8 == bitsz + gapsz + padsz)
+ *	  (not including any pad bytes required to galign this or next reg)
+ *	dbnum = unique target number f/debug (see <xtensa-libdb-macros.h>)
+ *	base = reg shortname w/o index (or sr=special, ur=TIE user reg)
+ *	regnum = reg index in regfile, or special/TIE-user reg number
+ *	bitsz = number of significant bits (regfile width, or ur/sr mask bits)
+ *	gapsz = intervening bits, if bitsz bits not stored contiguously
+ *	(padsz = pad bits at end [TIE regfile] or at msbits [ur,sr] of asize)
+ *	reset = register reset value (or 0 if undefined at reset)
+ *	x = reserved for future use (0 until then)
+ *
+ *  To filter out certain registers, e.g. to expand only the non-global
+ *  registers used by the compiler, you can do something like this:
+ *
+ *  #define XCHAL_SA_REG(s,ccused,p...)	SELCC##ccused(p)
+ *  #define SELCC0(p...)
+ *  #define SELCC1(abikind,p...)	SELAK##abikind(p)
+ *  #define SELAK0(p...)		REG(p)
+ *  #define SELAK1(p...)		REG(p)
+ *  #define SELAK2(p...)
+ *  #define REG(kind,tie,name,galn,aln,asz,csz,dbnum,base,rnum,bsz,rst,x...) \
+ *		...what you want to expand...
+ */
+
+#define XCHAL_NCP_SA_NUM	1
+#define XCHAL_NCP_SA_LIST(s)	\
+ XCHAL_SA_REG(s,0,0,0,1,             br, 4, 4, 4,0x0204,  sr,4  , 16,0,0,0)
+
+#define XCHAL_CP0_SA_NUM	18
+#define XCHAL_CP0_SA_LIST(s)	\
+ XCHAL_SA_REG(s,0,0,1,0,            fcr, 4, 4, 4,0x03E8,  ur,232, 32,0,0,0) \
+ XCHAL_SA_REG(s,0,0,1,0,            fsr, 4, 4, 4,0x03E9,  ur,233, 32,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,             f0, 4, 4, 4,0x0030,   f,0  , 32,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,             f1, 4, 4, 4,0x0031,   f,1  , 32,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,             f2, 4, 4, 4,0x0032,   f,2  , 32,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,             f3, 4, 4, 4,0x0033,   f,3  , 32,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,             f4, 4, 4, 4,0x0034,   f,4  , 32,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,             f5, 4, 4, 4,0x0035,   f,5  , 32,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,             f6, 4, 4, 4,0x0036,   f,6  , 32,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,             f7, 4, 4, 4,0x0037,   f,7  , 32,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,             f8, 4, 4, 4,0x0038,   f,8  , 32,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,             f9, 4, 4, 4,0x0039,   f,9  , 32,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,            f10, 4, 4, 4,0x003A,   f,10 , 32,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,            f11, 4, 4, 4,0x003B,   f,11 , 32,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,            f12, 4, 4, 4,0x003C,   f,12 , 32,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,            f13, 4, 4, 4,0x003D,   f,13 , 32,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,            f14, 4, 4, 4,0x003E,   f,14 , 32,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,            f15, 4, 4, 4,0x003F,   f,15 , 32,0,0,0)
+
+#define XCHAL_CP1_SA_NUM	0
+#define XCHAL_CP1_SA_LIST(s)	/* empty */
+
+#define XCHAL_CP2_SA_NUM	0
+#define XCHAL_CP2_SA_LIST(s)	/* empty */
+
+#define XCHAL_CP3_SA_NUM	0
+#define XCHAL_CP3_SA_LIST(s)	/* empty */
+
+#define XCHAL_CP4_SA_NUM	0
+#define XCHAL_CP4_SA_LIST(s)	/* empty */
+
+#define XCHAL_CP5_SA_NUM	0
+#define XCHAL_CP5_SA_LIST(s)	/* empty */
+
+#define XCHAL_CP6_SA_NUM	46
+#define XCHAL_CP6_SA_LIST(s)	\
+ XCHAL_SA_REG(s,0,0,1,0,         ldcbhi,16, 4, 4,0x0300,  ur,0  , 32,0,0,0) \
+ XCHAL_SA_REG(s,0,0,1,0,         ldcblo, 4, 4, 4,0x0301,  ur,1  , 32,0,0,0) \
+ XCHAL_SA_REG(s,0,0,1,0,         stcbhi, 4, 4, 4,0x0302,  ur,2  , 32,0,0,0) \
+ XCHAL_SA_REG(s,0,0,1,0,         stcblo, 4, 4, 4,0x0303,  ur,3  , 32,0,0,0) \
+ XCHAL_SA_REG(s,0,0,1,0,       ldbrbase, 4, 4, 4,0x0308,  ur,8  , 32,0,0,0) \
+ XCHAL_SA_REG(s,0,0,1,0,        ldbroff, 4, 4, 4,0x0309,  ur,9  , 32,0,0,0) \
+ XCHAL_SA_REG(s,0,0,1,0,        ldbrinc, 4, 4, 4,0x030A,  ur,10 , 32,0,0,0) \
+ XCHAL_SA_REG(s,0,0,1,0,       stbrbase, 4, 4, 4,0x030B,  ur,11 , 32,0,0,0) \
+ XCHAL_SA_REG(s,0,0,1,0,        stbroff, 4, 4, 4,0x030C,  ur,12 , 32,0,0,0) \
+ XCHAL_SA_REG(s,0,0,1,0,        stbrinc, 4, 4, 4,0x030D,  ur,13 , 32,0,0,0) \
+ XCHAL_SA_REG(s,0,0,1,0,       scratch0, 4, 4, 4,0x0318,  ur,24 , 32,0,0,0) \
+ XCHAL_SA_REG(s,0,0,1,0,       scratch1, 4, 4, 4,0x0319,  ur,25 , 32,0,0,0) \
+ XCHAL_SA_REG(s,0,0,1,0,       scratch2, 4, 4, 4,0x031A,  ur,26 , 32,0,0,0) \
+ XCHAL_SA_REG(s,0,0,1,0,       scratch3, 4, 4, 4,0x031B,  ur,27 , 32,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,           wra0,16,16,16,0x1010, wra,0  ,128,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,           wra1,16,16,16,0x1011, wra,1  ,128,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,           wra2,16,16,16,0x1012, wra,2  ,128,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,           wra3,16,16,16,0x1013, wra,3  ,128,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,           wra4,16,16,16,0x1014, wra,4  ,128,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,           wra5,16,16,16,0x1015, wra,5  ,128,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,           wra6,16,16,16,0x1016, wra,6  ,128,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,           wra7,16,16,16,0x1017, wra,7  ,128,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,           wra8,16,16,16,0x1018, wra,8  ,128,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,           wra9,16,16,16,0x1019, wra,9  ,128,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,          wra10,16,16,16,0x101A, wra,10 ,128,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,          wra11,16,16,16,0x101B, wra,11 ,128,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,          wra12,16,16,16,0x101C, wra,12 ,128,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,          wra13,16,16,16,0x101D, wra,13 ,128,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,          wra14,16,16,16,0x101E, wra,14 ,128,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,          wra15,16,16,16,0x101F, wra,15 ,128,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,           wrb0,16,16,16,0x1020, wrb,0  ,128,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,           wrb1,16,16,16,0x1021, wrb,1  ,128,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,           wrb2,16,16,16,0x1022, wrb,2  ,128,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,           wrb3,16,16,16,0x1023, wrb,3  ,128,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,           wrb4,16,16,16,0x1024, wrb,4  ,128,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,           wrb5,16,16,16,0x1025, wrb,5  ,128,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,           wrb6,16,16,16,0x1026, wrb,6  ,128,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,           wrb7,16,16,16,0x1027, wrb,7  ,128,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,           wrb8,16,16,16,0x1028, wrb,8  ,128,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,           wrb9,16,16,16,0x1029, wrb,9  ,128,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,          wrb10,16,16,16,0x102A, wrb,10 ,128,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,          wrb11,16,16,16,0x102B, wrb,11 ,128,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,          wrb12,16,16,16,0x102C, wrb,12 ,128,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,          wrb13,16,16,16,0x102D, wrb,13 ,128,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,          wrb14,16,16,16,0x102E, wrb,14 ,128,0,0,0) \
+ XCHAL_SA_REG(s,0,0,2,0,          wrb15,16,16,16,0x102F, wrb,15 ,128,0,0,0)
+
+#define XCHAL_CP7_SA_NUM	0
+#define XCHAL_CP7_SA_LIST(s)	/* empty */
+
+/* Byte length of instruction from its first nibble (op0 field), per FLIX.  */
+#define XCHAL_OP0_FORMAT_LENGTHS	3,3,3,3,3,3,3,3,2,2,2,2,2,2,8,8
+
+#endif /*_XTENSA_CORE_TIE_H*/
+
_

Patches currently in -mm which might be from jw@emlix.com are

origin.patch
xtensa-add-flat-support-checkpatch-fixes.patch
xtensa-variant-specific-code.patch
xtensa-cache-inquiry-and-unaligned-cache-handling-functions.patch
xtensa-allow-platform-and-variant-to-initialize-own-irq-chips.patch
xtensa-support-s6000-gpio-irqs-and-alternate-function-selection.patch
s6gmac-xtensa-s6000-on-chip-ethernet-driver.patch
xtensa-s6105-specific-configuration-for-s6gmac.patch
xtensa-enable-s6gmac-in-s6105_defconfig.patch
flat-fix-data-sections-alignment.patch

