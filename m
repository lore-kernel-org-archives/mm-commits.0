Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A6F7C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 14 Apr 2022 21:10:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346823AbiDNVM5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Apr 2022 17:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346835AbiDNVMy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Apr 2022 17:12:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA3F9D64C6
        for <mm-commits@vger.kernel.org>; Thu, 14 Apr 2022 14:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29E4E6200B
        for <mm-commits@vger.kernel.org>; Thu, 14 Apr 2022 21:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D1AEC385A9;
        Thu, 14 Apr 2022 21:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649970616;
        bh=zQhQAYIybL+lTwvGhfp8FDfXEXZYDKlMspNUUuPH2DY=;
        h=Date:To:From:Subject:From;
        b=n2udEbMBqlNQwqS5AKBc5iQP1xthTYT9a22Jm1pr/5YZr7q0FRZLiPaCAfY0LS7zA
         rlJPvsEiusrqoOYBC67j5jeyVW81lNFz5uAZk4YlVPoaBAj/zolzZZ/j6y5IMnwVI5
         KLjVK4x6G7MIwz40diHEhGKGlaglxHu97P7/wj4w=
Date:   Thu, 14 Apr 2022 14:10:15 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, tglx@linutronix.de,
        paulus@samba.org, mpe@ellerman.id.au, mingo@redhat.com,
        khalid.aziz@oracle.com, hch@infradead.org, davem@davemloft.net,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com,
        akpm@linux-foundation.org, anshuman.khandual@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-drop-arch_vm_get_page_pgprot.patch added to -mm tree
Message-Id: <20220414211016.7D1AEC385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: Drop arch_vm_get_page_pgprot()
has been added to the -mm tree.  Its filename is
     mm-mmap-drop-arch_vm_get_page_pgprot.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mmap-drop-arch_vm_get_page_pgprot.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap-drop-arch_vm_get_page_pgprot.patch

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
Subject: mm/mmap: Drop arch_vm_get_page_pgprot()

There are no platforms left which use arch_vm_get_page_prot(). Just drop
generic arch_vm_get_page_prot().

Link: https://lkml.kernel.org/r/20220414062125.609297-8-anshuman.khandual@arm.com
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
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


--- a/include/linux/mman.h~mm-mmap-drop-arch_vm_get_page_pgprot
+++ a/include/linux/mman.h
@@ -93,10 +93,6 @@ static inline void vm_unacct_memory(long
 #define arch_calc_vm_flag_bits(flags) 0
 #endif
 
-#ifndef arch_vm_get_page_prot
-#define arch_vm_get_page_prot(vm_flags) __pgprot(0)
-#endif
-
 #ifndef arch_validate_prot
 /*
  * This is called from mprotect().  PROT_GROWSDOWN and PROT_GROWSUP have
--- a/mm/mmap.c~mm-mmap-drop-arch_vm_get_page_pgprot
+++ a/mm/mmap.c
@@ -123,9 +123,7 @@ pgprot_t protection_map[16] __ro_after_i
 #ifndef CONFIG_ARCH_HAS_VM_GET_PAGE_PROT
 pgprot_t vm_get_page_prot(unsigned long vm_flags)
 {
-	return __pgprot(pgprot_val(protection_map[vm_flags &
-			(VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)]) |
-			pgprot_val(arch_vm_get_page_prot(vm_flags)));
+	return protection_map[vm_flags & (VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)];
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

