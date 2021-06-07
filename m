Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D1C0C47082
	for <mm-commits@archiver.kernel.org>; Mon,  7 Jun 2021 22:37:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1D6961185
	for <mm-commits@archiver.kernel.org>; Mon,  7 Jun 2021 22:37:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbhFGWiv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Jun 2021 18:38:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230306AbhFGWiu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Jun 2021 18:38:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 988846120F;
        Mon,  7 Jun 2021 22:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623105406;
        bh=jj9mNwu2FOqv1PCGR0cnxNvtiFESxjunbD5Rm5M+NrM=;
        h=Date:From:To:Subject:From;
        b=YOSga9QV7xt3lRLaOujZ5xK90XWcIf8YaZqavaowBhGRoohP4hKhnKAQEpwd7TNdB
         XCUUmEcBDQpZvPYt97UnOvy1fkLpuEfKphH/8i5rbj/uBkc9qEOR9FdjBjpImGUHSV
         YQ28FLQ7DGPPuApAZ8EQ18jpPHBjXezmtWl0gaXw=
Date:   Mon, 07 Jun 2021 15:36:46 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, christophe.leroy@csgroup.eu,
        joel@joelfernandes.org, kaleshsingh@google.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com
Subject:  [to-be-updated]
 powerpc-mm-book3s64-fix-possible-build-error.patch removed from -mm tree
Message-ID: <20210607223646.s1KxFP03s%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/mm/book3s64: fix possible build error
has been removed from the -mm tree.  Its filename was
     powerpc-mm-book3s64-fix-possible-build-error.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: powerpc/mm/book3s64: fix possible build error

Update _tlbiel_pid() such that we can avoid build errors like below when
using this function in other places.

arch/powerpc/mm/book3s64/radix_tlb.c: In function `__radix__flush_tlb_range_psize':
arch/powerpc/mm/book3s64/radix_tlb.c:114:2: warning: `asm' operand 3 probably does not match constraints
  114 |  asm volatile(PPC_TLBIEL(%0, %4, %3, %2, %1)
      |  ^~~
arch/powerpc/mm/book3s64/radix_tlb.c:114:2: error: impossible constraint in `asm'
make[4]: *** [scripts/Makefile.build:271: arch/powerpc/mm/book3s64/radix_tlb.o] Error 1
m

With this fix, we can also drop the __always_inline in
__radix_flush_tlb_range_psize which was added by commit e12d6d7d46a6
("powerpc/mm/radix: mark __radix__flush_tlb_range_psize() as
__always_inline").

Link: https://lkml.kernel.org/r/20210422054323.150993-5-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/book3s64/radix_tlb.c |   26 ++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

--- a/arch/powerpc/mm/book3s64/radix_tlb.c~powerpc-mm-book3s64-fix-possible-build-error
+++ a/arch/powerpc/mm/book3s64/radix_tlb.c
@@ -291,22 +291,30 @@ static inline void fixup_tlbie_lpid(unsi
 /*
  * We use 128 set in radix mode and 256 set in hpt mode.
  */
-static __always_inline void _tlbiel_pid(unsigned long pid, unsigned long ric)
+static inline void _tlbiel_pid(unsigned long pid, unsigned long ric)
 {
 	int set;
 
 	asm volatile("ptesync": : :"memory");
 
-	/*
-	 * Flush the first set of the TLB, and if we're doing a RIC_FLUSH_ALL,
-	 * also flush the entire Page Walk Cache.
-	 */
-	__tlbiel_pid(pid, 0, ric);
+	switch (ric) {
+	case RIC_FLUSH_PWC:
 
-	/* For PWC, only one flush is needed */
-	if (ric == RIC_FLUSH_PWC) {
+		/* For PWC, only one flush is needed */
+		__tlbiel_pid(pid, 0, RIC_FLUSH_PWC);
 		ppc_after_tlbiel_barrier();
 		return;
+	case RIC_FLUSH_TLB:
+		__tlbiel_pid(pid, 0, RIC_FLUSH_TLB);
+		break;
+	case RIC_FLUSH_ALL:
+	default:
+		/*
+		 * Flush the first set of the TLB, and if
+		 * we're doing a RIC_FLUSH_ALL, also flush
+		 * the entire Page Walk Cache.
+		 */
+		__tlbiel_pid(pid, 0, RIC_FLUSH_ALL);
 	}
 
 	if (!cpu_has_feature(CPU_FTR_ARCH_31)) {
@@ -1176,7 +1184,7 @@ void radix__tlb_flush(struct mmu_gather
 	}
 }
 
-static __always_inline void __radix__flush_tlb_range_psize(struct mm_struct *mm,
+static void __radix__flush_tlb_range_psize(struct mm_struct *mm,
 				unsigned long start, unsigned long end,
 				int psize, bool also_pwc)
 {
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

powerpc-mm-book3s64-update-tlb-flush-routines-to-take-a-page-walk-cache-flush-argument.patch
mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush.patch
mm-mremap-move-tlb-flush-outside-page-table-lock.patch
mm-mremap-allow-arch-runtime-override.patch
powerpc-mm-enable-move-pmd-pud.patch

