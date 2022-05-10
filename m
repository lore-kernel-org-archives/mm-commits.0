Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 240B6C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:13:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236032AbiEJERJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236080AbiEJEQ1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:16:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6610615E623
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:12:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02F5261735
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:12:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584DAC385C7;
        Tue, 10 May 2022 04:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155919;
        bh=EWa+zk4es3DfL4iuwDn1M2C4le8sVaTJjGzUMYoNX5c=;
        h=Date:To:From:Subject:From;
        b=iGSxi2y6nbJMVMN3wWdXVCjUqsFARwT8unPTV2UWgHL3moRrffj8macoxlczVJ6u8
         zV0QHShBawj/slpaEWj/Y1h6PStgkM3CRGDaZVpowydAJjaa1Zbb3KbLw6FM/vtfhy
         M2PlwI6XB+tLymYDtCYgyawIqRy5oebmcAshvIpk=
Date:   Mon, 09 May 2022 21:11:58 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, tglx@linutronix.de,
        paulus@samba.org, mpe@ellerman.id.au, mingo@redhat.com,
        khalid.aziz@oracle.com, davem@davemloft.net,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com,
        anshuman.khandual@arm.com, hch@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-mm-enable-arch_has_vm_get_page_prot.patch removed from -mm tree
Message-Id: <20220510041159.584DAC385C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: x86/mm: enable ARCH_HAS_VM_GET_PAGE_PROT
has been removed from the -mm tree.  Its filename was
     x86-mm-enable-arch_has_vm_get_page_prot.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Christoph Hellwig <hch@infradead.org>
Subject: x86/mm: enable ARCH_HAS_VM_GET_PAGE_PROT

This defines and exports a platform specific custom vm_get_page_prot() via
subscribing ARCH_HAS_VM_GET_PAGE_PROT.  This also unsubscribes from config
ARCH_HAS_FILTER_PGPROT, after dropping off arch_filter_pgprot() and
arch_vm_get_page_prot().

Link: https://lkml.kernel.org/r/20220414062125.609297-6-anshuman.khandual@arm.com
Signed-off-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David S. Miller <davem@davemloft.net>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig                 |    2 -
 arch/x86/include/asm/pgtable.h   |    5 ----
 arch/x86/include/uapi/asm/mman.h |   14 -----------
 arch/x86/mm/Makefile             |    2 -
 arch/x86/mm/pgprot.c             |   35 +++++++++++++++++++++++++++++
 5 files changed, 37 insertions(+), 21 deletions(-)

--- a/arch/x86/include/asm/pgtable.h~x86-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/x86/include/asm/pgtable.h
@@ -649,11 +649,6 @@ static inline pgprot_t pgprot_modify(pgp
 
 #define canon_pgprot(p) __pgprot(massage_pgprot(p))
 
-static inline pgprot_t arch_filter_pgprot(pgprot_t prot)
-{
-	return canon_pgprot(prot);
-}
-
 static inline int is_new_memtype_allowed(u64 paddr, unsigned long size,
 					 enum page_cache_mode pcm,
 					 enum page_cache_mode new_pcm)
--- a/arch/x86/include/uapi/asm/mman.h~x86-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/x86/include/uapi/asm/mman.h
@@ -5,20 +5,6 @@
 #define MAP_32BIT	0x40		/* only give out 32bit addresses */
 
 #ifdef CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS
-/*
- * Take the 4 protection key bits out of the vma->vm_flags
- * value and turn them in to the bits that we can put in
- * to a pte.
- *
- * Only override these if Protection Keys are available
- * (which is only on 64-bit).
- */
-#define arch_vm_get_page_prot(vm_flags)	__pgprot(	\
-		((vm_flags) & VM_PKEY_BIT0 ? _PAGE_PKEY_BIT0 : 0) |	\
-		((vm_flags) & VM_PKEY_BIT1 ? _PAGE_PKEY_BIT1 : 0) |	\
-		((vm_flags) & VM_PKEY_BIT2 ? _PAGE_PKEY_BIT2 : 0) |	\
-		((vm_flags) & VM_PKEY_BIT3 ? _PAGE_PKEY_BIT3 : 0))
-
 #define arch_calc_vm_prot_bits(prot, key) (		\
 		((key) & 0x1 ? VM_PKEY_BIT0 : 0) |      \
 		((key) & 0x2 ? VM_PKEY_BIT1 : 0) |      \
--- a/arch/x86/Kconfig~x86-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/x86/Kconfig
@@ -76,7 +76,6 @@ config X86
 	select ARCH_HAS_EARLY_DEBUG		if KGDB
 	select ARCH_HAS_ELF_RANDOMIZE
 	select ARCH_HAS_FAST_MULTIPLIER
-	select ARCH_HAS_FILTER_PGPROT
 	select ARCH_HAS_FORTIFY_SOURCE
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_KCOV			if X86_64
@@ -95,6 +94,7 @@ config X86
 	select ARCH_HAS_SYNC_CORE_BEFORE_USERMODE
 	select ARCH_HAS_SYSCALL_WRAPPER
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
+	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_HAS_DEBUG_WX
 	select ARCH_HAS_ZONE_DMA_SET if EXPERT
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
--- a/arch/x86/mm/Makefile~x86-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/x86/mm/Makefile
@@ -20,7 +20,7 @@ CFLAGS_REMOVE_mem_encrypt_identity.o	= -
 endif
 
 obj-y				:=  init.o init_$(BITS).o fault.o ioremap.o extable.o mmap.o \
-				    pgtable.o physaddr.o setup_nx.o tlb.o cpu_entry_area.o maccess.o
+				    pgtable.o physaddr.o setup_nx.o tlb.o cpu_entry_area.o maccess.o pgprot.o
 
 obj-y				+= pat/
 
--- /dev/null
+++ a/arch/x86/mm/pgprot.c
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/export.h>
+#include <linux/mm.h>
+#include <asm/pgtable.h>
+
+pgprot_t vm_get_page_prot(unsigned long vm_flags)
+{
+	unsigned long val = pgprot_val(protection_map[vm_flags &
+				      (VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)]);
+
+#ifdef CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS
+	/*
+	 * Take the 4 protection key bits out of the vma->vm_flags value and
+	 * turn them in to the bits that we can put in to a pte.
+	 *
+	 * Only override these if Protection Keys are available (which is only
+	 * on 64-bit).
+	 */
+	if (vm_flags & VM_PKEY_BIT0)
+		val |= _PAGE_PKEY_BIT0;
+	if (vm_flags & VM_PKEY_BIT1)
+		val |= _PAGE_PKEY_BIT1;
+	if (vm_flags & VM_PKEY_BIT2)
+		val |= _PAGE_PKEY_BIT2;
+	if (vm_flags & VM_PKEY_BIT3)
+		val |= _PAGE_PKEY_BIT3;
+#endif
+
+	val = __sme_set(val);
+	if (val & _PAGE_PRESENT)
+		val &= __supported_pte_mask;
+	return __pgprot(val);
+}
+EXPORT_SYMBOL(vm_get_page_prot);
_

Patches currently in -mm which might be from hch@infradead.org are


