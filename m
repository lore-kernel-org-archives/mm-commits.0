Return-Path: <SRS0=ColI=A4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B79FFC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jul 2020 21:11:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9152D2076A
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jul 2020 21:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595020281;
	bh=9sdQpoU3zYhVOpDmvCrR5RERP5K38s+g2wEkwuHt5KQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=0OQHK5JZe+EM2jzT+sEXuu6oq9xUs+VD8jl33IG8qsCQE67yr0Jsjwvkjm+38qCji
	 HnjFBIhsWGEthquheqP0dOsgScPWrJ+3KzETLAwpPiAOxLcHKPrCAGm74c+IT9tDGK
	 gz2Q1OU3D4XsN7xx+KqB9GXEj4rf7n/FPaF26jGg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgGQVLV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Jul 2020 17:11:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726399AbgGQVLU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 17 Jul 2020 17:11:20 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE8C820717;
        Fri, 17 Jul 2020 21:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595020280;
        bh=9sdQpoU3zYhVOpDmvCrR5RERP5K38s+g2wEkwuHt5KQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=aO0SOXt3FrSTUMDShuqaFbK77bQyH7nJnsskpbOLLa8PE9Z3o17nkMuQ/6YYfcuEd
         rb0W+BNso33R85qZgalFb3q4kSDhwy85fnuZCVt7l2j+ZwQ0KLDNbwR7r+a2tNVh4A
         0FVV8xrOnldgxfi4RbC17IF8AAy336qYHLvpwIXc=
Date:   Fri, 17 Jul 2020 14:11:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     mm-commits@vger.kernel.org, palmerdabbelt@google.com,
        penberg@kernel.org, rientjes@google.com, rppt@linux.ibm.com,
        thomas.lendacky@amd.com
Subject:  +
 mm-pgtable-make-generic-pgprot_-macros-available-for-no-mmu.patch added to
 -mm tree
Message-ID: <20200717211119.NWJgKf5f7%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: pgtable: make generic pgprot_* macros available for no-MMU
has been added to the -mm tree.  Its filename is
     mm-pgtable-make-generic-pgprot_-macros-available-for-no-mmu.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-pgtable-make-generic-pgprot_-macros-available-for-no-mmu.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-pgtable-make-generic-pgprot_-macros-available-for-no-mmu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -647,40 +647,6 @@ static inline int arch_unmap_one(struct
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
@@ -840,6 +806,43 @@ static inline void ptep_modify_prot_comm
  * No-op macros that just return the current protection value. Defined here
  * because these macros can be used used even if CONFIG_MMU is not defined.
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

mm-pgtable-make-generic-pgprot_-macros-available-for-no-mmu.patch
riscv-use-generic-pgprot_-macros-from-linux-pgtableh.patch

