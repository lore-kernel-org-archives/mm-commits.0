From: akpm@linux-foundation.org
Subject: + x86-mm-support-huge-i-o-mapping-capability-i-f.patch added to
 -mm tree
Date: Tue, 03 Mar 2015 14:46:04 -0800
Message-ID: <54f639ac.r3gDEcioc85vf1tA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36544 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756618AbbCCWqF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Mar 2015 17:46:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: toshi.kani@hp.com, Elliott@hp.com, arnd@arndb.de, dave.hansen@intel.com, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86, mm: support huge I/O mapping capability I/F
has been added to the -mm tree.  Its filename is
     x86-mm-support-huge-i-o-mapping-capability-i-f.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-mm-support-huge-i-o-mapping-capability-i-f.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-mm-support-huge-i-o-mapping-capability-i-f.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-change-__get_vm_area_node-to-use-fls_long.patch
lib-add-huge-i-o-map-capability-interfaces.patch
mm-change-ioremap-to-set-up-huge-i-o-mappings.patch
mm-change-vunmap-to-tear-down-huge-kva-mappings.patch
x86-mm-support-huge-i-o-mapping-capability-i-f.patch
x86-mm-support-huge-kva-mappings-on-x86.patch

