Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D6DBC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:13:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236044AbiEJERR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236081AbiEJEQ1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:16:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D06081D3D59
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:12:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87E75B81AFA
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:11:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38274C385A6;
        Tue, 10 May 2022 04:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155918;
        bh=sSHzgP8RV10K2wHaFRX0VoIKsHTCmc8H9+gUKnoIQgY=;
        h=Date:To:From:Subject:From;
        b=KGQoQ9whLm0cOsvt6BGgEwJ7RyObiMDBplKqisCI8sFUJ4nL/MWLWj3xpUww8smuT
         m9lCohQRTHDB0LiwHfsgCNIxPEFFgtVaI1zTphVLer+ZErYgOF+gtpK8DguFvdzJOS
         nkKI9mNCqAqzbjU/XNtOuOySOEve32iYNCbOJTlU=
Date:   Mon, 09 May 2022 21:11:57 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, tglx@linutronix.de,
        paulus@samba.org, mpe@ellerman.id.au, mingo@redhat.com,
        khalid.aziz@oracle.com, hch@infradead.org, davem@davemloft.net,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com,
        anshuman.khandual@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sparc-mm-enable-arch_has_vm_get_page_prot.patch removed from -mm tree
Message-Id: <20220510041158.38274C385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: sparc/mm: enable ARCH_HAS_VM_GET_PAGE_PROT
has been removed from the -mm tree.  Its filename was
     sparc-mm-enable-arch_has_vm_get_page_prot.patch

This patch was dropped because it was merged into mm-stable

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

 arch/sparc/Kconfig            |    1 +
 arch/sparc/include/asm/mman.h |    6 ------
 arch/sparc/mm/init_64.c       |   12 ++++++++++++
 3 files changed, 13 insertions(+), 6 deletions(-)

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


