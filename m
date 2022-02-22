Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E2D0C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 03:13:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbiBVDNb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 22:13:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239715AbiBVDN2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 22:13:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30EFB858
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 19:13:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4FC9CB8184D
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 03:12:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFCA8C340E9;
        Tue, 22 Feb 2022 03:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645499577;
        bh=I/KwQXaHWHPZNBqCZIUuCWLQng3pbVsi1GYuCpFj1bY=;
        h=Date:To:From:Subject:From;
        b=IZmGLXXHArtQd9gRpjiY5X8lz61ZW2cAgrm3CyR9vpdbrakF4oYmc2bBtKhBCIzSL
         Z0pc5qLf8La9m8x3GwkjyM/yjJ85KyFz3TsLTSvBQM+yA78CA3OTuZl3sgqb4QtY8A
         bLlU4/q/vPvs8Zk6V0oQlp1UdrFdHiuK2N0tzpn4=
Date:   Mon, 21 Feb 2022 19:12:57 -0800
To:     mm-commits@vger.kernel.org, paulus@samba.org, mpe@ellerman.id.au,
        anshuman.khandual@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-mm-enable-arch_has_vm_get_page_prot.patch added to -mm tree
Message-Id: <20220222031257.CFCA8C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/mm: enable ARCH_HAS_VM_GET_PAGE_PROT
has been added to the -mm tree.  Its filename is
     powerpc-mm-enable-arch_has_vm_get_page_prot.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/powerpc-mm-enable-arch_has_vm_get_page_prot.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/powerpc-mm-enable-arch_has_vm_get_page_prot.patch

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
Subject: powerpc/mm: enable ARCH_HAS_VM_GET_PAGE_PROT

This defines and exports a platform specific custom vm_get_page_prot() via
subscribing ARCH_HAS_VM_GET_PAGE_PROT.  Subsequently all __SXXX and __PXXX
macros can be dropped which are no longer needed.  While here, this also
localizes arch_vm_get_page_prot() as powerpc_vm_get_page_prot() and moves
it near vm_get_page_prot().

Link: https://lkml.kernel.org/r/1645425519-9034-5-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig               |    1 
 arch/powerpc/include/asm/mman.h    |   12 -----
 arch/powerpc/include/asm/pgtable.h |   19 --------
 arch/powerpc/mm/mmap.c             |   59 +++++++++++++++++++++++++++
 4 files changed, 60 insertions(+), 31 deletions(-)

--- a/arch/powerpc/include/asm/mman.h~powerpc-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/powerpc/include/asm/mman.h
@@ -24,18 +24,6 @@ static inline unsigned long arch_calc_vm
 }
 #define arch_calc_vm_prot_bits(prot, pkey) arch_calc_vm_prot_bits(prot, pkey)
 
-static inline pgprot_t arch_vm_get_page_prot(unsigned long vm_flags)
-{
-#ifdef CONFIG_PPC_MEM_KEYS
-	return (vm_flags & VM_SAO) ?
-		__pgprot(_PAGE_SAO | vmflag_to_pte_pkey_bits(vm_flags)) :
-		__pgprot(0 | vmflag_to_pte_pkey_bits(vm_flags));
-#else
-	return (vm_flags & VM_SAO) ? __pgprot(_PAGE_SAO) : __pgprot(0);
-#endif
-}
-#define arch_vm_get_page_prot(vm_flags) arch_vm_get_page_prot(vm_flags)
-
 static inline bool arch_validate_prot(unsigned long prot, unsigned long addr)
 {
 	if (prot & ~(PROT_READ | PROT_WRITE | PROT_EXEC | PROT_SEM | PROT_SAO))
--- a/arch/powerpc/include/asm/pgtable.h~powerpc-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/powerpc/include/asm/pgtable.h
@@ -20,25 +20,6 @@ struct mm_struct;
 #include <asm/nohash/pgtable.h>
 #endif /* !CONFIG_PPC_BOOK3S */
 
-/* Note due to the way vm flags are laid out, the bits are XWR */
-#define __P000	PAGE_NONE
-#define __P001	PAGE_READONLY
-#define __P010	PAGE_COPY
-#define __P011	PAGE_COPY
-#define __P100	PAGE_READONLY_X
-#define __P101	PAGE_READONLY_X
-#define __P110	PAGE_COPY_X
-#define __P111	PAGE_COPY_X
-
-#define __S000	PAGE_NONE
-#define __S001	PAGE_READONLY
-#define __S010	PAGE_SHARED
-#define __S011	PAGE_SHARED
-#define __S100	PAGE_READONLY_X
-#define __S101	PAGE_READONLY_X
-#define __S110	PAGE_SHARED_X
-#define __S111	PAGE_SHARED_X
-
 #ifndef __ASSEMBLY__
 
 #ifndef MAX_PTRS_PER_PGD
--- a/arch/powerpc/Kconfig~powerpc-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/powerpc/Kconfig
@@ -135,6 +135,7 @@ config PPC
 	select ARCH_HAS_TICK_BROADCAST		if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAS_UACCESS_FLUSHCACHE
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
+	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select ARCH_KEEP_MEMBLOCK
 	select ARCH_MIGHT_HAVE_PC_PARPORT
--- a/arch/powerpc/mm/mmap.c~powerpc-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/powerpc/mm/mmap.c
@@ -254,3 +254,62 @@ void arch_pick_mmap_layout(struct mm_str
 		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
 	}
 }
+
+static inline pgprot_t __vm_get_page_prot(unsigned long vm_flags)
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
+		return PAGE_READONLY_X;
+	case VM_EXEC | VM_WRITE:
+	case VM_EXEC | VM_WRITE | VM_READ:
+		return PAGE_COPY_X;
+	case VM_SHARED:
+		return PAGE_NONE;
+	case VM_SHARED | VM_READ:
+		return PAGE_READONLY;
+	case VM_SHARED | VM_WRITE:
+	case VM_SHARED | VM_WRITE | VM_READ:
+		return PAGE_SHARED;
+	case VM_SHARED | VM_EXEC:
+	case VM_SHARED | VM_EXEC | VM_READ:
+		return PAGE_READONLY_X;
+	case VM_SHARED | VM_EXEC | VM_WRITE:
+	case VM_SHARED | VM_EXEC | VM_WRITE | VM_READ:
+		return PAGE_SHARED_X;
+	default:
+		BUILD_BUG();
+	}
+}
+
+#ifdef CONFIG_PPC64
+static pgprot_t powerpc_vm_get_page_prot(unsigned long vm_flags)
+{
+#ifdef CONFIG_PPC_MEM_KEYS
+	return (vm_flags & VM_SAO) ?
+		__pgprot(_PAGE_SAO | vmflag_to_pte_pkey_bits(vm_flags)) :
+		__pgprot(0 | vmflag_to_pte_pkey_bits(vm_flags));
+#else
+	return (vm_flags & VM_SAO) ? __pgprot(_PAGE_SAO) : __pgprot(0);
+#endif
+}
+#else
+static pgprot_t powerpc_vm_get_page_prot(unsigned long vm_flags)
+{
+	return __pgprot(0);
+}
+#endif /* CONFIG_PPC64 */
+
+pgprot_t vm_get_page_prot(unsigned long vm_flags)
+{
+	return __pgprot(pgprot_val(__vm_get_page_prot(vm_flags)) |
+	       pgprot_val(powerpc_vm_get_page_prot(vm_flags)));
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

