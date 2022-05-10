Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D013DC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:13:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236030AbiEJERI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236078AbiEJEQ0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:16:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC7A5C859
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:11:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 000EDB81AF7
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:11:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB77C385A6;
        Tue, 10 May 2022 04:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155914;
        bh=Hld7zTyXBhniNRuJnyVqxqbNvMRl/ojfC6ZrOH5KNr4=;
        h=Date:To:From:Subject:From;
        b=PwE7otk1Gpi1mc0ZJCjX6ayUtGO3qzd7BAEfrvarzHdogOFiUKh1nqxdnZK9PJkXj
         RYXHu9nQpPsA0TDMDKy+XSN5f94rwATMIJ2P563typmlctCbE8PLevRsjZcjXDUIsM
         2mIQ2fNIzCPDNGbFWiwAsbVAs9b9/ejdGW3/mgMQ=
Date:   Mon, 09 May 2022 21:11:54 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, tglx@linutronix.de,
        paulus@samba.org, mpe@ellerman.id.au, mingo@redhat.com,
        khalid.aziz@oracle.com, hch@infradead.org, davem@davemloft.net,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com,
        anshuman.khandual@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-add-new-config-arch_has_vm_get_page_prot.patch removed from -mm tree
Message-Id: <20220510041154.ADB77C385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap: add new config ARCH_HAS_VM_GET_PAGE_PROT
has been removed from the -mm tree.  Its filename was
     mm-mmap-add-new-config-arch_has_vm_get_page_prot.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/mmap: add new config ARCH_HAS_VM_GET_PAGE_PROT

Patch series "mm/mmap: Drop arch_vm_get_page_prot() and arch_filter_pgprot()", v7.

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
macros , protection_map[], arch_vm_get_page_prot() and
arch_filter_pgprot() built between the platform and generic MM, finally
defining vm_get_page_prot().

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

Link: https://lkml.kernel.org/r/20220414062125.609297-1-anshuman.khandual@arm.com
Link: https://lkml.kernel.org/r/20220414062125.609297-2-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Cc: David S. Miller <davem@davemloft.net>
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


