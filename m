Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D385C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 14 Apr 2022 21:10:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235560AbiDNVM4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Apr 2022 17:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346832AbiDNVMy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Apr 2022 17:12:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EFCAD5EB6
        for <mm-commits@vger.kernel.org>; Thu, 14 Apr 2022 14:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31DEBB82762
        for <mm-commits@vger.kernel.org>; Thu, 14 Apr 2022 21:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93C8C385A5;
        Thu, 14 Apr 2022 21:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649970615;
        bh=uPbT7ZTrU3urB0fP417QH8/EzN6T7bKVEqlEw9cgB2U=;
        h=Date:To:From:Subject:From;
        b=zrecyXT+mFvfix+Cc25ayxV3BSe/vABgoG2f4I/Om58CL3jEC6kJUWeufm7XaGBYI
         vNtMhgNwfnQ5M+NwTiOQM019eojxeBY6WLuiGlOTayn3HzzgQ/9uIGUQsy0cemeR8X
         swUffKwhj2NT3AOJh1smSI8kqDQg1WmtetBtfg+8=
Date:   Thu, 14 Apr 2022 14:10:14 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, tglx@linutronix.de,
        paulus@samba.org, mpe@ellerman.id.au, mingo@redhat.com,
        khalid.aziz@oracle.com, hch@infradead.org, davem@davemloft.net,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com,
        anshuman.khandual@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-drop-arch_filter_pgprot.patch added to -mm tree
Message-Id: <20220414211014.D93C8C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: drop arch_filter_pgprot()
has been added to the -mm tree.  Its filename is
     mm-mmap-drop-arch_filter_pgprot.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mmap-drop-arch_filter_pgprot.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap-drop-arch_filter_pgprot.patch

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
Subject: mm/mmap: drop arch_filter_pgprot()

There are no platforms left which subscribe ARCH_HAS_FILTER_PGPROT.  Hence
drop generic arch_filter_pgprot() and also config ARCH_HAS_FILTER_PGPROT.

Link: https://lkml.kernel.org/r/20220414062125.609297-7-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/Kconfig~mm-mmap-drop-arch_filter_pgprot
+++ a/mm/Kconfig
@@ -762,9 +762,6 @@ config ARCH_HAS_CURRENT_STACK_POINTER
 	  register alias named "current_stack_pointer", this config can be
 	  selected.
 
-config ARCH_HAS_FILTER_PGPROT
-	bool
-
 config ARCH_HAS_VM_GET_PAGE_PROT
 	bool
 
--- a/mm/mmap.c~mm-mmap-drop-arch_filter_pgprot
+++ a/mm/mmap.c
@@ -121,20 +121,11 @@ pgprot_t protection_map[16] __ro_after_i
 };
 
 #ifndef CONFIG_ARCH_HAS_VM_GET_PAGE_PROT
-#ifndef CONFIG_ARCH_HAS_FILTER_PGPROT
-static inline pgprot_t arch_filter_pgprot(pgprot_t prot)
-{
-	return prot;
-}
-#endif
-
 pgprot_t vm_get_page_prot(unsigned long vm_flags)
 {
-	pgprot_t ret = __pgprot(pgprot_val(protection_map[vm_flags &
-				(VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)]) |
+	return __pgprot(pgprot_val(protection_map[vm_flags &
+			(VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)]) |
 			pgprot_val(arch_vm_get_page_prot(vm_flags)));
-
-	return arch_filter_pgprot(ret);
 }
 EXPORT_SYMBOL(vm_get_page_prot);
 #endif	/* CONFIG_ARCH_HAS_VM_GET_PAGE_PROT */
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

