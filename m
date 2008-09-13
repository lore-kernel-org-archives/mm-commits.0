From: akpm@linux-foundation.org
Subject: - x86-64-reduce-boot-fixmap-space.patch removed from -mm tree
Date: Sat, 13 Sep 2008 00:45:29 -0700
Message-ID: <200809130745.m8D7jTsx026770@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47142 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753056AbYIMHpx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 13 Sep 2008 03:45:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86-64: reduce boot fixmap space
has been removed from the -mm tree.  Its filename was
     x86-64-reduce-boot-fixmap-space.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86-64: reduce boot fixmap space
From: Jan Beulich <jbeulich@novell.com>

Just like for 32-bit - as 256 entries are needed, aligning to a 256-entry
boundary is sufficient and still guarantees the single pte table
requirement.

Likewise move up __end_of_permanent_fixed_addresses, to match 32-bit.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/fixmap_64.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN include/asm-x86/fixmap_64.h~x86-64-reduce-boot-fixmap-space include/asm-x86/fixmap_64.h
--- a/include/asm-x86/fixmap_64.h~x86-64-reduce-boot-fixmap-space
+++ a/include/asm-x86/fixmap_64.h
@@ -49,6 +49,7 @@ enum fixed_addresses {
 #ifdef CONFIG_PARAVIRT
 	FIX_PARAVIRT_BOOTMAP,
 #endif
+	__end_of_permanent_fixed_addresses,
 #ifdef CONFIG_ACPI
 	FIX_ACPI_BEGIN,
 	FIX_ACPI_END = FIX_ACPI_BEGIN + FIX_ACPI_PAGES - 1,
@@ -56,18 +57,17 @@ enum fixed_addresses {
 #ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
 	FIX_OHCI1394_BASE,
 #endif
-	__end_of_permanent_fixed_addresses,
 	/*
 	 * 256 temporary boot-time mappings, used by early_ioremap(),
 	 * before ioremap() is functional.
 	 *
-	 * We round it up to the next 512 pages boundary so that we
+	 * We round it up to the next 256 pages boundary so that we
 	 * can have a single pgd entry and a single pte table:
 	 */
 #define NR_FIX_BTMAPS		64
 #define FIX_BTMAPS_NESTING	4
-	FIX_BTMAP_END = __end_of_permanent_fixed_addresses + 512 -
-			(__end_of_permanent_fixed_addresses & 511),
+	FIX_BTMAP_END = __end_of_permanent_fixed_addresses + 256 -
+			(__end_of_permanent_fixed_addresses & 255),
 	FIX_BTMAP_BEGIN = FIX_BTMAP_END + NR_FIX_BTMAPS*FIX_BTMAPS_NESTING - 1,
 	__end_of_fixed_addresses
 };
_

Patches currently in -mm which might be from jbeulich@novell.com are

linux-next.patch
adjust-init-section-definitions.patch
kconfig-eliminate-def_bool-n-constructs.patch

