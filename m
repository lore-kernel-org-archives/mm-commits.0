From: akpm@linux-foundation.org
Subject: [alternative-merged]
 x86-efi-print-size-and-base-in-binary-units-in-efi_print_memmap.patch
 removed from -mm tree
Date: Tue, 09 Feb 2016 10:48:15 -0800
Message-ID: <56ba346f.h0eDm8oBJqiu19yZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35800 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801AbcBISsQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Feb 2016 13:48:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elliott@hpe.com, andriy.shevchenko@linux.intel.com, hpa@zytor.com, linux@rasmusvillemoes.dk, matt@codeblueprint.co.uk, mingo@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86/efi: print size and base in binary units in efi_print_memmap
has been removed from the -mm tree.  Its filename was
     x86-efi-print-size-and-base-in-binary-units-in-efi_print_memmap.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Robert Elliott <elliott@hpe.com>
Subject: x86/efi: print size and base in binary units in efi_print_memmap

Print the base in the best-fit B, KiB, MiB, etc. units rather than
always MiB. This avoids rounding, which can be misleading.

Use proper IEC binary units (KiB, MiB, etc.) rather than misuse SI
decimal units (KB, MB, etc.).

old:
    efi: mem61: [Persistent Memory  |   |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c7fffffff) (16384MB)

new:
    efi: mem61: [Persistent Memory  |   |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c7fffffff] (16 GiB)

Signed-off-by: Robert Elliott <elliott@hpe.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/platform/efi/efi.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff -puN arch/x86/platform/efi/efi.c~x86-efi-print-size-and-base-in-binary-units-in-efi_print_memmap arch/x86/platform/efi/efi.c
--- a/arch/x86/platform/efi/efi.c~x86-efi-print-size-and-base-in-binary-units-in-efi_print_memmap
+++ a/arch/x86/platform/efi/efi.c
@@ -35,10 +35,12 @@
 #include <linux/efi.h>
 #include <linux/efi-bgrt.h>
 #include <linux/export.h>
+#include <linux/bitops.h>
 #include <linux/bootmem.h>
 #include <linux/slab.h>
 #include <linux/memblock.h>
 #include <linux/spinlock.h>
+#include <linux/string_helpers.h>
 #include <linux/uaccess.h>
 #include <linux/time.h>
 #include <linux/io.h>
@@ -117,6 +119,14 @@ void efi_get_time(struct timespec *now)
 	now->tv_nsec = 0;
 }
 
+static char * __init efi_size_format(char *buf, size_t size, u64 bytes)
+{
+	unsigned long i = bytes ? __ffs64(bytes) / 10 : 0;
+
+	snprintf(buf, size, "%llu %s", bytes >> (i * 10), string_units_2[i]);
+	return buf;
+}
+
 void __init efi_find_mirror(void)
 {
 	void *p;
@@ -225,21 +235,20 @@ int __init efi_memblock_x86_reserve_rang
 void __init efi_print_memmap(void)
 {
 #ifdef EFI_DEBUG
-	efi_memory_desc_t *md;
 	void *p;
 	int i;
 
 	for (p = memmap.map, i = 0;
 	     p < memmap.map_end;
 	     p += memmap.desc_size, i++) {
-		char buf[64];
+		efi_memory_desc_t *md = p;
+		u64 size = md->num_pages << EFI_PAGE_SHIFT;
+		char buf[64], buf3[32];
 
-		md = p;
-		pr_info("mem%02u: %s range=[0x%016llx-0x%016llx) (%lluMB)\n",
+		pr_info("mem%02u: %s range=[0x%016llx-0x%016llx] (%s)\n",
 			i, efi_md_typeattr_format(buf, sizeof(buf), md),
-			md->phys_addr,
-			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
-			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
+			md->phys_addr, md->phys_addr + size,
+			efi_size_format(buf3, sizeof(buf3), size));
 	}
 #endif  /*  EFI_DEBUG  */
 }
_

Patches currently in -mm which might be from elliott@hpe.com are


