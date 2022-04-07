Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D9E3C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  7 Apr 2022 23:26:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiDGX2r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Apr 2022 19:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiDGX2r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Apr 2022 19:28:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C02919C81C
        for <mm-commits@vger.kernel.org>; Thu,  7 Apr 2022 16:26:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C487D61354
        for <mm-commits@vger.kernel.org>; Thu,  7 Apr 2022 23:26:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ECB2C385A4;
        Thu,  7 Apr 2022 23:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649374004;
        bh=eDlgNHIU8PQPLs/gotwlDZw6FrBoZsZt83RN2XXAg58=;
        h=Date:To:From:Subject:From;
        b=pjVwUzNc8fyg6KdZV4deW7oP2OeSL0DGtm5Z430nMpMDy2plObexaR5DEaCrxhC1v
         ssclol4mM82ML3F6X058W2lzNj6vfhxh2Ru8YzdyeWd5dciw5ddTH15rLa6KNIVYyZ
         PoFXD3f3xOU7mrhdCKSlTfYXaY6LOXoCI3CKMRmA=
Date:   Thu, 07 Apr 2022 16:26:43 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, tglx@linutronix.de,
        paulus@samba.org, mpe@ellerman.id.au, mingo@redhat.com,
        khalid.aziz@oracle.com, hch@infradead.org, davem@davemloft.net,
        catalin.marinas@arm.com, anshuman.khandual@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-add-new-config-arch_has_vm_get_page_prot.patch added to -mm tree
Message-Id: <20220407232644.0ECB2C385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: add new config ARCH_HAS_VM_GET_PAGE_PROT
has been added to the -mm tree.  Its filename is
     mm-mmap-add-new-config-arch_has_vm_get_page_prot.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mmap-add-new-config-arch_has_vm_get_page_prot.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap-add-new-config-arch_has_vm_get_page_prot.patch

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
Subject: mm/mmap: add new config ARCH_HAS_VM_GET_PAGE_PROT

Patch series "mm/mmap: Drop arch_vm_get_page_prot() and arch_filter_pgprot()", v4.

protection_map[] is an array based construct that translates given
vm_flags combination.  This array contains page protection map, which is
populated by the platform via [__S000 ..  __S111] and [__P000 ..  __P111]
exported macros.  Primary usage for protection_map[] is for
vm_get_page_prot(), which is used to determine page protection value for a
given vm_flags.  vm_get_page_prot() implementation, could again call
platform overrides arch_vm_get_page_prot() and arch_filter_pgprot().  Some
platforms override protection_map[] that was originally built with
__SXXX/__PXXX with different runtime values.

Currently there are multiple layers of abstraction i.e __SXXX/__PXXX
macros, protection_map[], arch_vm_get_page_prot() and arch_filter_pgprot()
built between the platform and generic MM, finally defining
vm_get_page_prot().

Hence this series proposes to drop later two abstraction levels and
instead just move the responsibility of defining vm_get_page_prot() to the
platform (still utilizing generic protection_map[] array) itself making it
clean and simple.

This first introduces ARCH_HAS_VM_GET_PAGE_PROT which enables the
platforms to define custom vm_get_page_prot().  This starts converting
platforms that define the overrides arch_filter_pgprot() or
arch_vm_get_page_prot() which enables for those constructs to be dropped
off completely.

The series has been inspired from an earlier discuss with Christoph Hellwig

https://lore.kernel.org/all/1632712920-8171-1-git-send-email-anshuman.khandual@arm.com/


This patch (of 7):

Add a new config ARCH_HAS_VM_GET_PAGE_PROT, which when subscribed enables
a given platform to define its own vm_get_page_prot() but still utilizing
the generic protection_map[] array.

Link: https://lkml.kernel.org/r/20220407103251.1209606-1-anshuman.khandual@arm.com
Link: https://lkml.kernel.org/r/20220407103251.1209606-2-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    3 +++
 mm/mmap.c  |    2 ++
 2 files changed, 5 insertions(+)

--- a/mm/Kconfig~mm-mmap-add-new-config-arch_has_vm_get_page_prot
+++ a/mm/Kconfig
@@ -765,6 +765,9 @@ config ARCH_HAS_CURRENT_STACK_POINTER
 config ARCH_HAS_FILTER_PGPROT
 	bool
 
+config ARCH_HAS_VM_GET_PAGE_PROT
+	bool
+
 config ARCH_HAS_PTE_DEVMAP
 	bool
 
--- a/mm/mmap.c~mm-mmap-add-new-config-arch_has_vm_get_page_prot
+++ a/mm/mmap.c
@@ -120,6 +120,7 @@ pgprot_t protection_map[16] __ro_after_i
 	[VM_SHARED | VM_EXEC | VM_WRITE | VM_READ]	= __S111
 };
 
+#ifndef CONFIG_ARCH_HAS_VM_GET_PAGE_PROT
 #ifndef CONFIG_ARCH_HAS_FILTER_PGPROT
 static inline pgprot_t arch_filter_pgprot(pgprot_t prot)
 {
@@ -136,6 +137,7 @@ pgprot_t vm_get_page_prot(unsigned long
 	return arch_filter_pgprot(ret);
 }
 EXPORT_SYMBOL(vm_get_page_prot);
+#endif	/* CONFIG_ARCH_HAS_VM_GET_PAGE_PROT */
 
 static pgprot_t vm_pgprot_modify(pgprot_t oldprot, unsigned long vm_flags)
 {
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

