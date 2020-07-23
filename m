Return-Path: <SRS0=ssb3=BC=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F25AC433E0
	for <mm-commits@archiver.kernel.org>; Thu, 23 Jul 2020 23:23:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 493B420825
	for <mm-commits@archiver.kernel.org>; Thu, 23 Jul 2020 23:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595546614;
	bh=2oedVtpbtAy9lgoiyUXqG2iModrzrZuvn9EfboqhglM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=dk5WS4yb6LO1oZRi0UT2M8tBr2R3sq9pCCTthJIe78SwYDa9lUBZX5G3xgfofnDxP
	 ybV67Zk4Ua5g8eHV3zoHLjCix+WTH9h7H5IHP1gz/6DpMxRaj7/Fhz8MvRDWX696S2
	 lozPvjNmd5li5xPyCvoKgFJwYlliEW4kmvqLihMw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgGWXXe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Jul 2020 19:23:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:35198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726723AbgGWXXd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Jul 2020 19:23:33 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D09FE20792;
        Thu, 23 Jul 2020 23:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595546613;
        bh=2oedVtpbtAy9lgoiyUXqG2iModrzrZuvn9EfboqhglM=;
        h=Date:From:To:Subject:From;
        b=hz6eZxETQdxg4bxlIzP9fNZmJ/RyfJIJgoB1K2xuYR50w+5vXv6WYm8Ej5Pbi2JL4
         jbalJj4A5bj5PhVmSXZyR//BchzopQq0Vsidz/4eJnPiwJ46IPy90FQxmOBASUkmev
         5uH4i+W1BwBxVapG7dWbYfdD5cP1I2jw4KRw0qhA=
Date:   Thu, 23 Jul 2020 16:23:32 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, palmerdabbelt@google.com,
        penberg@kernel.org, rientjes@google.com, rppt@linux.ibm.com,
        thomas.lendacky@amd.com
Subject:  [merged]
 mm-pgtable-make-generic-pgprot_-macros-available-for-no-mmu.patch removed
 from -mm tree
Message-ID: <20200723232332.NaeVoeeW6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: pgtable: make generic pgprot_* macros available for no-MMU
has been removed from the -mm tree.  Its filename was
     mm-pgtable-make-generic-pgprot_-macros-available-for-no-mmu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Pekka Enberg <penberg@kernel.org>
Subject: mm: pgtable: make generic pgprot_* macros available for no-MMU

The <linux/pgtable.h> header defines some generic pgprot_*
implementations, but they are only available when CONFIG_MMU is enabled. 
The RISC-V architecture, for example, therefore defines some of these
pgprot_* macros for !NOMMU.

Let's make the pgprot_* generic available even for !NOMMU so we can remove
the RISC-V specific definitions.

Compile-tested with x86 defconfig, and riscv defconfig and !MMU defconfig.

Link: http://lkml.kernel.org/r/20200715053340.576300-1-penberg@gmail.com
Signed-off-by: Pekka Enberg <penberg@kernel.org>
Suggested-by: Palmer Dabbelt <palmerdabbelt@google.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |   71 +++++++++++++++++++-------------------
 1 file changed, 37 insertions(+), 34 deletions(-)

--- a/include/linux/pgtable.h~mm-pgtable-make-generic-pgprot_-macros-available-for-no-mmu
+++ a/include/linux/pgtable.h
@@ -675,40 +675,6 @@ static inline void arch_swap_restore(swp
 #define flush_tlb_fix_spurious_fault(vma, address) flush_tlb_page(vma, address)
 #endif
 
-#ifndef pgprot_nx
-#define pgprot_nx(prot)	(prot)
-#endif
-
-#ifndef pgprot_noncached
-#define pgprot_noncached(prot)	(prot)
-#endif
-
-#ifndef pgprot_writecombine
-#define pgprot_writecombine pgprot_noncached
-#endif
-
-#ifndef pgprot_writethrough
-#define pgprot_writethrough pgprot_noncached
-#endif
-
-#ifndef pgprot_device
-#define pgprot_device pgprot_noncached
-#endif
-
-#ifndef pgprot_modify
-#define pgprot_modify pgprot_modify
-static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
-{
-	if (pgprot_val(oldprot) == pgprot_val(pgprot_noncached(oldprot)))
-		newprot = pgprot_noncached(newprot);
-	if (pgprot_val(oldprot) == pgprot_val(pgprot_writecombine(oldprot)))
-		newprot = pgprot_writecombine(newprot);
-	if (pgprot_val(oldprot) == pgprot_val(pgprot_device(oldprot)))
-		newprot = pgprot_device(newprot);
-	return newprot;
-}
-#endif
-
 /*
  * When walking page tables, get the address of the next boundary,
  * or the end address of the range if that comes earlier.  Although no
@@ -868,6 +834,43 @@ static inline void ptep_modify_prot_comm
  * No-op macros that just return the current protection value. Defined here
  * because these macros can be used even if CONFIG_MMU is not defined.
  */
+
+#ifndef pgprot_nx
+#define pgprot_nx(prot)	(prot)
+#endif
+
+#ifndef pgprot_noncached
+#define pgprot_noncached(prot)	(prot)
+#endif
+
+#ifndef pgprot_writecombine
+#define pgprot_writecombine pgprot_noncached
+#endif
+
+#ifndef pgprot_writethrough
+#define pgprot_writethrough pgprot_noncached
+#endif
+
+#ifndef pgprot_device
+#define pgprot_device pgprot_noncached
+#endif
+
+#ifdef CONFIG_MMU
+#ifndef pgprot_modify
+#define pgprot_modify pgprot_modify
+static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
+{
+	if (pgprot_val(oldprot) == pgprot_val(pgprot_noncached(oldprot)))
+		newprot = pgprot_noncached(newprot);
+	if (pgprot_val(oldprot) == pgprot_val(pgprot_writecombine(oldprot)))
+		newprot = pgprot_writecombine(newprot);
+	if (pgprot_val(oldprot) == pgprot_val(pgprot_device(oldprot)))
+		newprot = pgprot_device(newprot);
+	return newprot;
+}
+#endif
+#endif /* CONFIG_MMU */
+
 #ifndef pgprot_encrypted
 #define pgprot_encrypted(prot)	(prot)
 #endif
_

Patches currently in -mm which might be from penberg@kernel.org are


