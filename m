Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5A67C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 14 Apr 2022 21:10:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346852AbiDNVMz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Apr 2022 17:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346828AbiDNVMk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Apr 2022 17:12:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EAC0CEE26
        for <mm-commits@vger.kernel.org>; Thu, 14 Apr 2022 14:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 325B8B82762
        for <mm-commits@vger.kernel.org>; Thu, 14 Apr 2022 21:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA29DC385A1;
        Thu, 14 Apr 2022 21:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649970611;
        bh=dctO9w7og//waRphxrnDJpwgU/rxMTtwVsH17TuPTt8=;
        h=Date:To:From:Subject:From;
        b=Gd7ju2YCWnzbAzObdeNftNkmyysSMx7vB7w/KpcVYJ9XqYfSPmsl83waK0QoF2iOM
         rknQK+m7wsBWWYxsUAeZKm30azVINNifo0YoDr0+dGmjD6VgYCS12wXQwV2KMA5ADP
         wheRu3+hoJdj3MKTtikG4D7rPH2Omp6HZzrjscX8=
Date:   Thu, 14 Apr 2022 14:10:10 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, tglx@linutronix.de,
        paulus@samba.org, mpe@ellerman.id.au, mingo@redhat.com,
        khalid.aziz@oracle.com, hch@infradead.org, davem@davemloft.net,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com,
        anshuman.khandual@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + sparc-mm-enable-arch_has_vm_get_page_prot.patch added to -mm tree
Message-Id: <20220414211010.DA29DC385A1@smtp.kernel.org>
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
subscribing ARCH_HAS_VM_GET_PAGE_PROT.  It localizes
arch_vm_get_page_prot() as sparc_vm_get_page_prot() and moves near
vm_get_page_prot().

Link: https://lkml.kernel.org/r/20220414062125.609297-5-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: David S. Miller <davem@davemloft.net>
Reviewed-by: Khalid Aziz <khalid.aziz@oracle.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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
--- a/arch/sparc/Kconfig~sparc-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/sparc/Kconfig
@@ -84,6 +84,7 @@ config SPARC64
 	select PERF_USE_VMALLOC
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select HAVE_C_RECORDMCOUNT
+	select ARCH_HAS_VM_GET_PAGE_PROT
 	select HAVE_ARCH_AUDITSYSCALL
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_SUPPORTS_DEBUG_PAGEALLOC
--- a/arch/sparc/mm/init_64.c~sparc-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/sparc/mm/init_64.c
@@ -3184,3 +3184,15 @@ void copy_highpage(struct page *to, stru
 	}
 }
 EXPORT_SYMBOL(copy_highpage);
+
+pgprot_t vm_get_page_prot(unsigned long vm_flags)
+{
+	unsigned long prot = pgprot_val(protection_map[vm_flags &
+					(VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)]);
+
+	if (vm_flags & VM_SPARC_ADI)
+		prot |= _PAGE_MCD_4V;
+
+	return __pgprot(prot);
+}
+EXPORT_SYMBOL(vm_get_page_prot);
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-debug_vm_pgtable-drop-protection_map-usage.patch
mm-mmap-clarify-protection_map-indices.patch
mm-mmap-add-new-config-arch_has_vm_get_page_prot.patch
powerpc-mm-enable-arch_has_vm_get_page_prot.patch
arm64-mm-enable-arch_has_vm_get_page_prot.patch
sparc-mm-enable-arch_has_vm_get_page_prot.patch
mm-mmap-drop-arch_filter_pgprot.patch
mm-mmap-drop-arch_vm_get_page_pgprot.patch

