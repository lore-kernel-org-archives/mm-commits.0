Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91910C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 03:13:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233492AbiBVDNd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 22:13:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239579AbiBVDN3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 22:13:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 060ED5FA0
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 19:13:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83526612C8
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 03:13:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC4EBC340E9;
        Tue, 22 Feb 2022 03:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645499584;
        bh=d1Vc1DXSLGBNt0HNb2ALYmY4BJcz1vDKrjKlbNhFjOo=;
        h=Date:To:From:Subject:From;
        b=eL+KrHqLPrwyTaou6q0tSxk/AaVGEv7PDn+04WvbvWGLk/88sdQBJGG3ZBUfVtxnf
         wqWLJYsPK0tpCMhPxEUPJjVK4kmStH67UCiV+5bqCrN1Vj8JVTms8n3WSkAoJcThuu
         8k/ITJqMSvunwkBGHgN46XDkawKqb/N8T7Mtie5g=
Date:   Mon, 21 Feb 2022 19:13:03 -0800
To:     mm-commits@vger.kernel.org, khalid.aziz@oracle.com,
        davem@davemloft.net, anshuman.khandual@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + sparc-mm-enable-arch_has_vm_get_page_prot.patch added to -mm tree
Message-Id: <20220222031303.DC4EBC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sparc/mm: enable ARCH_HAS_VM_GET_PAGE_PROT
has been added to the -mm tree.  Its filename is
     sparc-mm-enable-arch_has_vm_get_page_prot.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/sparc-mm-enable-arch_has_vm_get_page_prot.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/sparc-mm-enable-arch_has_vm_get_page_prot.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: sparc/mm: enable ARCH_HAS_VM_GET_PAGE_PROT

This defines and exports a platform specific custom vm_get_page_prot() via
subscribing ARCH_HAS_VM_GET_PAGE_PROT.  Subsequently all __SXXX and __PXXX
macros can be dropped which are no longer needed.  This also localizes the
helper arch_vm_get_page_prot() as sparc_vm_get_page_prot() and moves near
vm_get_page_prot().

Link: https://lkml.kernel.org/r/1645425519-9034-7-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Khalid Aziz <khalid.aziz@oracle.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/Kconfig                  |    2 
 arch/sparc/include/asm/mman.h       |    6 --
 arch/sparc/include/asm/pgtable_32.h |   19 -------
 arch/sparc/include/asm/pgtable_64.h |   19 -------
 arch/sparc/mm/init_32.c             |   35 +++++++++++++
 arch/sparc/mm/init_64.c             |   70 ++++++++++++++++++--------
 6 files changed, 88 insertions(+), 63 deletions(-)

--- a/arch/sparc/include/asm/mman.h~sparc-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/sparc/include/asm/mman.h
@@ -46,12 +46,6 @@ static inline unsigned long sparc_calc_v
 	}
 }
 
-#define arch_vm_get_page_prot(vm_flags) sparc_vm_get_page_prot(vm_flags)
-static inline pgprot_t sparc_vm_get_page_prot(unsigned long vm_flags)
-{
-	return (vm_flags & VM_SPARC_ADI) ? __pgprot(_PAGE_MCD_4V) : __pgprot(0);
-}
-
 #define arch_validate_prot(prot, addr) sparc_validate_prot(prot, addr)
 static inline int sparc_validate_prot(unsigned long prot, unsigned long addr)
 {
--- a/arch/sparc/include/asm/pgtable_32.h~sparc-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/sparc/include/asm/pgtable_32.h
@@ -64,25 +64,6 @@ void paging_init(void);
 
 extern unsigned long ptr_in_current_pgd;
 
-/*         xwr */
-#define __P000  PAGE_NONE
-#define __P001  PAGE_READONLY
-#define __P010  PAGE_COPY
-#define __P011  PAGE_COPY
-#define __P100  PAGE_READONLY
-#define __P101  PAGE_READONLY
-#define __P110  PAGE_COPY
-#define __P111  PAGE_COPY
-
-#define __S000	PAGE_NONE
-#define __S001	PAGE_READONLY
-#define __S010	PAGE_SHARED
-#define __S011	PAGE_SHARED
-#define __S100	PAGE_READONLY
-#define __S101	PAGE_READONLY
-#define __S110	PAGE_SHARED
-#define __S111	PAGE_SHARED
-
 /* First physical page can be anywhere, the following is needed so that
  * va-->pa and vice versa conversions work properly without performance
  * hit for all __pa()/__va() operations.
--- a/arch/sparc/include/asm/pgtable_64.h~sparc-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -187,25 +187,6 @@ bool kern_addr_valid(unsigned long addr)
 #define _PAGE_SZHUGE_4U	_PAGE_SZ4MB_4U
 #define _PAGE_SZHUGE_4V	_PAGE_SZ4MB_4V
 
-/* These are actually filled in at boot time by sun4{u,v}_pgprot_init() */
-#define __P000	__pgprot(0)
-#define __P001	__pgprot(0)
-#define __P010	__pgprot(0)
-#define __P011	__pgprot(0)
-#define __P100	__pgprot(0)
-#define __P101	__pgprot(0)
-#define __P110	__pgprot(0)
-#define __P111	__pgprot(0)
-
-#define __S000	__pgprot(0)
-#define __S001	__pgprot(0)
-#define __S010	__pgprot(0)
-#define __S011	__pgprot(0)
-#define __S100	__pgprot(0)
-#define __S101	__pgprot(0)
-#define __S110	__pgprot(0)
-#define __S111	__pgprot(0)
-
 #ifndef __ASSEMBLY__
 
 pte_t mk_pte_io(unsigned long, pgprot_t, int, unsigned long);
--- a/arch/sparc/Kconfig~sparc-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/sparc/Kconfig
@@ -59,6 +59,7 @@ config SPARC32
 	select HAVE_UID16
 	select OLD_SIGACTION
 	select ZONE_DMA
+	select ARCH_HAS_VM_GET_PAGE_PROT
 
 config SPARC64
 	def_bool 64BIT
@@ -84,6 +85,7 @@ config SPARC64
 	select PERF_USE_VMALLOC
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select HAVE_C_RECORDMCOUNT
+	select ARCH_HAS_VM_GET_PAGE_PROT
 	select HAVE_ARCH_AUDITSYSCALL
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_SUPPORTS_DEBUG_PAGEALLOC
--- a/arch/sparc/mm/init_32.c~sparc-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/sparc/mm/init_32.c
@@ -302,3 +302,38 @@ void sparc_flush_page_to_ram(struct page
 		__flush_page_to_ram(vaddr);
 }
 EXPORT_SYMBOL(sparc_flush_page_to_ram);
+
+pgprot_t vm_get_page_prot(unsigned long vm_flags)
+{
+	switch (vm_flags & (VM_READ | VM_WRITE | VM_EXEC | VM_SHARED)) {
+	case VM_NONE:
+		return PAGE_NONE;
+	case VM_READ:
+		return PAGE_READONLY;
+	case VM_WRITE:
+	case VM_WRITE | VM_READ:
+		return PAGE_COPY;
+	case VM_EXEC:
+	case VM_EXEC | VM_READ:
+		return PAGE_READONLY;
+	case VM_EXEC | VM_WRITE:
+	case VM_EXEC | VM_WRITE | VM_READ:
+		return PAGE_COPY;
+	case VM_SHARED:
+		return PAGE_NONE;
+	case VM_SHARED | VM_READ:
+		return PAGE_READONLY;
+	case VM_SHARED | VM_WRITE:
+	case VM_SHARED | VM_WRITE | VM_READ:
+		return PAGE_SHARED;
+	case VM_SHARED | VM_EXEC:
+	case VM_SHARED | VM_EXEC | VM_READ:
+		return PAGE_READONLY;
+	case VM_SHARED | VM_EXEC | VM_WRITE:
+	case VM_SHARED | VM_EXEC | VM_WRITE | VM_READ:
+		return PAGE_SHARED;
+	default:
+		BUILD_BUG();
+	}
+}
+EXPORT_SYMBOL(vm_get_page_prot);
--- a/arch/sparc/mm/init_64.c~sparc-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/sparc/mm/init_64.c
@@ -50,6 +50,7 @@
 #include <asm/cpudata.h>
 #include <asm/setup.h>
 #include <asm/irq.h>
+#include <asm/mman.h>
 
 #include "init_64.h"
 
@@ -2641,29 +2642,13 @@ static void prot_init_common(unsigned lo
 {
 	PAGE_COPY = __pgprot(page_copy);
 	PAGE_SHARED = __pgprot(page_shared);
-
-	protection_map[0x0] = __pgprot(page_none);
-	protection_map[0x1] = __pgprot(page_readonly & ~page_exec_bit);
-	protection_map[0x2] = __pgprot(page_copy & ~page_exec_bit);
-	protection_map[0x3] = __pgprot(page_copy & ~page_exec_bit);
-	protection_map[0x4] = __pgprot(page_readonly);
-	protection_map[0x5] = __pgprot(page_readonly);
-	protection_map[0x6] = __pgprot(page_copy);
-	protection_map[0x7] = __pgprot(page_copy);
-	protection_map[0x8] = __pgprot(page_none);
-	protection_map[0x9] = __pgprot(page_readonly & ~page_exec_bit);
-	protection_map[0xa] = __pgprot(page_shared & ~page_exec_bit);
-	protection_map[0xb] = __pgprot(page_shared & ~page_exec_bit);
-	protection_map[0xc] = __pgprot(page_readonly);
-	protection_map[0xd] = __pgprot(page_readonly);
-	protection_map[0xe] = __pgprot(page_shared);
-	protection_map[0xf] = __pgprot(page_shared);
 }
 
+static unsigned long page_none, page_shared, page_copy, page_readonly;
+static unsigned long page_exec_bit;
+
 static void __init sun4u_pgprot_init(void)
 {
-	unsigned long page_none, page_shared, page_copy, page_readonly;
-	unsigned long page_exec_bit;
 	int i;
 
 	PAGE_KERNEL = __pgprot (_PAGE_PRESENT_4U | _PAGE_VALID |
@@ -3183,3 +3168,50 @@ void copy_highpage(struct page *to, stru
 	}
 }
 EXPORT_SYMBOL(copy_highpage);
+
+static inline pgprot_t __vm_get_page_prot(unsigned long vm_flags)
+{
+	switch (vm_flags & (VM_READ | VM_WRITE | VM_EXEC | VM_SHARED)) {
+	case VM_NONE:
+		return __pgprot(page_none);
+	case VM_READ:
+		return __pgprot(page_readonly & ~page_exec_bit);
+	case VM_WRITE:
+	case VM_WRITE | VM_READ:
+		return __pgprot(page_copy & ~page_exec_bit);
+	case VM_EXEC:
+	case VM_EXEC | VM_READ:
+		return __pgprot(page_readonly);
+	case VM_EXEC | VM_WRITE:
+	case VM_EXEC | VM_WRITE | VM_READ:
+		return __pgprot(page_copy);
+	case VM_SHARED:
+		return __pgprot(page_none);
+	case VM_SHARED | VM_READ:
+		return __pgprot(page_readonly & ~page_exec_bit);
+	case VM_SHARED | VM_WRITE:
+	case VM_SHARED | VM_WRITE | VM_READ:
+		return __pgprot(page_shared & ~page_exec_bit);
+	case VM_SHARED | VM_EXEC:
+	case VM_SHARED | VM_EXEC | VM_READ:
+		return __pgprot(page_readonly);
+	case VM_SHARED | VM_EXEC | VM_WRITE:
+	case VM_SHARED | VM_EXEC | VM_WRITE | VM_READ:
+		return __pgprot(page_shared);
+	default:
+		BUILD_BUG();
+	}
+}
+
+static pgprot_t sparc_vm_get_page_prot(unsigned long vm_flags)
+{
+	return (vm_flags & VM_SPARC_ADI) ? __pgprot(_PAGE_MCD_4V) : __pgprot(0);
+}
+
+pgprot_t vm_get_page_prot(unsigned long vm_flags)
+{
+	return __pgprot(pgprot_val(__vm_get_page_prot(vm_flags)) |
+	       pgprot_val(sparc_vm_get_page_prot(vm_flags)));
+
+}
+EXPORT_SYMBOL(vm_get_page_prot);
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-generalize-arch_has_filter_pgprot.patch
mm-merge-pte_mkhuge-call-into-arch_make_huge_pte.patch
mm-debug_vm_pgtable-drop-protection_map-usage.patch
mm-mmap-clarify-protection_map-indices.patch
mm-mmap-add-new-config-arch_has_vm_get_page_prot.patch
powerpc-mm-enable-arch_has_vm_get_page_prot.patch
arm64-mm-enable-arch_has_vm_get_page_prot.patch
sparc-mm-enable-arch_has_vm_get_page_prot.patch
mips-mm-enable-arch_has_vm_get_page_prot.patch
m68k-mm-enable-arch_has_vm_get_page_prot.patch
arm-mm-enable-arch_has_vm_get_page_prot.patch
mm-mmap-drop-protection_map.patch
mm-mmap-drop-arch_filter_pgprot.patch
mm-mmap-drop-arch_vm_get_page_pgprot.patch
s390-mm-enable-arch_has_vm_get_page_prot.patch
riscv-mm-enable-arch_has_vm_get_page_prot.patch
alpha-mm-enable-arch_has_vm_get_page_prot.patch
sh-mm-enable-arch_has_vm_get_page_prot.patch
arc-mm-enable-arch_has_vm_get_page_prot.patch
csky-mm-enable-arch_has_vm_get_page_prot.patch
extensa-mm-enable-arch_has_vm_get_page_prot.patch
parisc-mm-enable-arch_has_vm_get_page_prot.patch
openrisc-mm-enable-arch_has_vm_get_page_prot.patch
um-mm-enable-arch_has_vm_get_page_prot.patch
microblaze-mm-enable-arch_has_vm_get_page_prot.patch
nios2-mm-enable-arch_has_vm_get_page_prot.patch
hexagon-mm-enable-arch_has_vm_get_page_prot.patch
nds32-mm-enable-arch_has_vm_get_page_prot.patch
ia64-mm-enable-arch_has_vm_get_page_prot.patch
mm-mmap-drop-generic-vm_get_page_prot.patch
mm-mmap-drop-arch_has_vm_get_page_prot.patch
mm-hugetlb-generalize-arch_want_general_hugetlb.patch
mm-migration-add-trace-events-for-thp-migrations.patch
mm-migration-add-trace-events-for-base-page-and-hugetlb-migrations.patch

