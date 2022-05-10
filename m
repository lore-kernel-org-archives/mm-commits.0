Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7A9AC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:13:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235967AbiEJERG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236032AbiEJEQZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:16:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFFF65A594
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:11:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87C8F61738
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:11:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD14BC385C5;
        Tue, 10 May 2022 04:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155916;
        bh=Aa5V3GeYIKtuazZaxmI/wMgJmg66lVBDmhVxKoi2POI=;
        h=Date:To:From:Subject:From;
        b=WPTOv37s7HGymwroYHyI0SoHrUIgC3C4m5qaGnyQvBRe5wd7onTyZT6A9V/3ChsOX
         P0GjyrkMfxvnZ98WmnCL5Ua7NVngOnkQBbGDLoKEKozwXUmIQ8Xpkn2Uk5bp3155aM
         5lm0xfvt1vO+TUfu33CFxXgTknB7mlvwTBrCU0YI=
Date:   Mon, 09 May 2022 21:11:55 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, tglx@linutronix.de,
        paulus@samba.org, mpe@ellerman.id.au, mingo@redhat.com,
        khalid.aziz@oracle.com, hch@infradead.org, davem@davemloft.net,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com,
        anshuman.khandual@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] powerpc-mm-enable-arch_has_vm_get_page_prot.patch removed from -mm tree
Message-Id: <20220510041155.DD14BC385C5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: powerpc/mm: enable ARCH_HAS_VM_GET_PAGE_PROT
has been removed from the -mm tree.  Its filename was
     powerpc-mm-enable-arch_has_vm_get_page_prot.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: powerpc/mm: enable ARCH_HAS_VM_GET_PAGE_PROT

This defines and exports a platform specific custom vm_get_page_prot() via
subscribing ARCH_HAS_VM_GET_PAGE_PROT.  While here, this also localizes
arch_vm_get_page_prot() as __vm_get_page_prot() and moves it near
vm_get_page_prot().

Link: https://lkml.kernel.org/r/20220414062125.609297-3-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig               |    1 +
 arch/powerpc/include/asm/mman.h    |   12 ------------
 arch/powerpc/mm/book3s64/pgtable.c |   17 +++++++++++++++++
 3 files changed, 18 insertions(+), 12 deletions(-)

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
--- a/arch/powerpc/Kconfig~powerpc-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/powerpc/Kconfig
@@ -140,6 +140,7 @@ config PPC
 	select ARCH_HAS_TICK_BROADCAST		if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAS_UACCESS_FLUSHCACHE
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
+	select ARCH_HAS_VM_GET_PAGE_PROT	if PPC_BOOK3S_64
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select ARCH_KEEP_MEMBLOCK
 	select ARCH_MIGHT_HAVE_PC_PARPORT
--- a/arch/powerpc/mm/book3s64/pgtable.c~powerpc-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/powerpc/mm/book3s64/pgtable.c
@@ -7,6 +7,7 @@
 #include <linux/mm_types.h>
 #include <linux/memblock.h>
 #include <linux/memremap.h>
+#include <linux/pkeys.h>
 #include <linux/debugfs.h>
 #include <misc/cxl-base.h>
 
@@ -549,3 +550,19 @@ unsigned long memremap_compat_align(void
 }
 EXPORT_SYMBOL_GPL(memremap_compat_align);
 #endif
+
+pgprot_t vm_get_page_prot(unsigned long vm_flags)
+{
+	unsigned long prot = pgprot_val(protection_map[vm_flags &
+					(VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)]);
+
+	if (vm_flags & VM_SAO)
+		prot |= _PAGE_SAO;
+
+#ifdef CONFIG_PPC_MEM_KEYS
+	prot |= vmflag_to_pte_pkey_bits(vm_flags);
+#endif
+
+	return __pgprot(prot);
+}
+EXPORT_SYMBOL(vm_get_page_prot);
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are


