From: akpm@linux-foundation.org
Subject: [merged] x86-mm-support-huge-i-o-mapping-capability-i-f.patch
 removed from -mm tree
Date: Wed, 15 Apr 2015 12:11:25 -0700
Message-ID: <552eb7dd.ATs9TNf42SZ3YkSB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48361 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933597AbbDOTL0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:11:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: toshi.kani@hp.com, Elliott@hp.com, arnd@arndb.de, dave.hansen@intel.com, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86, mm: support huge I/O mapping capability I/F
has been removed from the -mm tree.  Its filename was
     x86-mm-support-huge-i-o-mapping-capability-i-f.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Toshi Kani <toshi.kani@hp.com>
Subject: x86, mm: support huge I/O mapping capability I/F

Implement huge I/O mapping capability interfaces for ioremap() on x86.

IOREMAP_MAX_ORDER is defined to PUD_SHIFT on x86/64 and PMD_SHIFT on
x86/32, which overrides the default value defined in <linux/vmalloc.h>.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Robert Elliott <Elliott@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/page_types.h |    2 ++
 arch/x86/mm/ioremap.c             |   23 +++++++++++++++++++++--
 2 files changed, 23 insertions(+), 2 deletions(-)

diff -puN arch/x86/include/asm/page_types.h~x86-mm-support-huge-i-o-mapping-capability-i-f arch/x86/include/asm/page_types.h
--- a/arch/x86/include/asm/page_types.h~x86-mm-support-huge-i-o-mapping-capability-i-f
+++ a/arch/x86/include/asm/page_types.h
@@ -40,8 +40,10 @@
 
 #ifdef CONFIG_X86_64
 #include <asm/page_64_types.h>
+#define IOREMAP_MAX_ORDER       (PUD_SHIFT)
 #else
 #include <asm/page_32_types.h>
+#define IOREMAP_MAX_ORDER       (PMD_SHIFT)
 #endif	/* CONFIG_X86_64 */
 
 #ifndef __ASSEMBLY__
diff -puN arch/x86/mm/ioremap.c~x86-mm-support-huge-i-o-mapping-capability-i-f arch/x86/mm/ioremap.c
--- a/arch/x86/mm/ioremap.c~x86-mm-support-huge-i-o-mapping-capability-i-f
+++ a/arch/x86/mm/ioremap.c
@@ -67,8 +67,13 @@ static int __ioremap_check_ram(unsigned
 
 /*
  * Remap an arbitrary physical address space into the kernel virtual
- * address space. Needed when the kernel wants to access high addresses
- * directly.
+ * address space. It transparently creates kernel huge I/O mapping when
+ * the physical address is aligned by a huge page size (1GB or 2MB) and
+ * the requested size is at least the huge page size.
+ *
+ * NOTE: MTRRs can override PAT memory types with a 4KB granularity.
+ * Therefore, the mapping code falls back to use a smaller page toward 4KB
+ * when a mapping range is covered by non-WB type of MTRRs.
  *
  * NOTE! We need to allow non-page-aligned mappings too: we will obviously
  * have to convert them into an offset in a page-aligned mapping, but the
@@ -326,6 +331,20 @@ void iounmap(volatile void __iomem *addr
 }
 EXPORT_SYMBOL(iounmap);
 
+int arch_ioremap_pud_supported(void)
+{
+#ifdef CONFIG_X86_64
+	return cpu_has_gbpages;
+#else
+	return 0;
+#endif
+}
+
+int arch_ioremap_pmd_supported(void)
+{
+	return cpu_has_pse;
+}
+
 /*
  * Convert a physical pointer to a virtual kernel pointer for /dev/mem
  * access
_

Patches currently in -mm which might be from toshi.kani@hp.com are

origin.patch
mm-x86-document-return-values-of-mapping-funcs.patch
mtrr-x86-fix-mtrr-lookup-to-handle-inclusive-entry.patch
mtrr-x86-remove-a-wrong-address-check-in-__mtrr_type_lookup.patch
mtrr-x86-fix-mtrr-state-checks-in-mtrr_type_lookup.patch
mtrr-x86-define-mtrr_type_invalid-for-mtrr_type_lookup.patch
mtrr-x86-clean-up-mtrr_type_lookup.patch
mtrr-mm-x86-enhance-mtrr-checks-for-kva-huge-page-mapping.patch

