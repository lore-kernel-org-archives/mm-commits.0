Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1217DC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:13:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbiEJERO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:17:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236100AbiEJEQ1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:16:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A6E71D4A3E
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:12:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17C6F61741
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:12:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 723E0C385A6;
        Tue, 10 May 2022 04:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155920;
        bh=Nddf28++u7Wj9hOMxBKnSPQqI0wjjETrWPrLWM0XfDo=;
        h=Date:To:From:Subject:From;
        b=WBnSXkLFxniBhziDL4Wr85M8kSHLli0tr41VRu6Jz7wykpwhtXuB+hRNDEbiwtYuB
         eDH5gzw8RZEbvuZ29QVwrtE4j5H7X13KUSc6JGctHMIGK+YkaZDpwoJrI7BJAyluAl
         ehzl9ae7FnkRm6Htxc5I8uRxrX6rnalg7sM+cPdQ=
Date:   Mon, 09 May 2022 21:11:59 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, tglx@linutronix.de,
        paulus@samba.org, mpe@ellerman.id.au, mingo@redhat.com,
        khalid.aziz@oracle.com, hch@infradead.org, davem@davemloft.net,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com,
        anshuman.khandual@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-drop-arch_filter_pgprot.patch removed from -mm tree
Message-Id: <20220510041200.723E0C385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap: drop arch_filter_pgprot()
has been removed from the -mm tree.  Its filename was
     mm-mmap-drop-arch_filter_pgprot.patch

This patch was dropped because it was merged into mm-stable

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

 mm/Kconfig |    3 ---
 mm/mmap.c  |   13 ++-----------
 2 files changed, 2 insertions(+), 14 deletions(-)

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


