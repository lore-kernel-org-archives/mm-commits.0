Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DD27C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:04:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 403022087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817470;
	bh=T/suh2QaZxyTrGnu3Z+qGfEkf6U38UdnL7GtqRBHl/4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=NICDfRI1BDMKWJtnbX1jRQJbb/7KWBe+qNVVPCab9Sv1anWn/5xiixfB733jh2p8V
	 6QWRC7VnbW9Rln/MtG+QcOtPXd31qzyJik62zUw5bTsrkVSrpkiMwSulWHKAo7LEsn
	 BHzR5mPSd0D3aJ3Vvxasu1eqSp7qo3Li9MrhbADE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732549AbgJPDE3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:04:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:43526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728261AbgJPDE3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:04:29 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CE1220878;
        Fri, 16 Oct 2020 03:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817467;
        bh=T/suh2QaZxyTrGnu3Z+qGfEkf6U38UdnL7GtqRBHl/4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=zittXN3Lbh6SpCZVAKvnUGlTLBDAJvd6HYf5WHCtJ59b/eOuHVjvA18ifD5wFv2bP
         AKjUfg70qPd9VLeg6TeBKA9bTq6+YL2AvxG3RisJSgjLhD/+Zo5jbk7B2XcGtTLMmq
         pxPoHARB+A+KxeCl+VzpWOi9mO7vS6FQ5SR+mw8I=
Date:   Thu, 15 Oct 2020 20:04:26 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        anshuman.khandual@arm.com, christophe.leroy@csgroup.eu,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        torvalds@linux-foundation.org
Subject:  [patch 002/156] powerpc/mm: add DEBUG_VM WARN for
 pmd_clear
Message-ID: <20201016030426.RDP2eKDm-%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: powerpc/mm: add DEBUG_VM WARN for pmd_clear

Patch series "mm/debug_vm_pgtable fixes", v4.

This patch series includes fixes for debug_vm_pgtable test code so that
they follow page table updates rules correctly.  The first two patches
introduce changes w.r.t ppc64.

Hugetlb test is disabled on ppc64 because that needs larger change to satisfy
page table update rules.

These tests are broken w.r.t page table update rules and results in kernel
crash as below. 

[   21.083519] kernel BUG at arch/powerpc/mm/pgtable.c:304!
cpu 0x0: Vector: 700 (Program Check) at [c000000c6d1e76c0]
    pc: c00000000009a5ec: assert_pte_locked+0x14c/0x380
    lr: c0000000005eeeec: pte_update+0x11c/0x190
    sp: c000000c6d1e7950
   msr: 8000000002029033
  current = 0xc000000c6d172c80
  paca    = 0xc000000003ba0000   irqmask: 0x03   irq_happened: 0x01
    pid   = 1, comm = swapper/0
kernel BUG at arch/powerpc/mm/pgtable.c:304!
[link register   ] c0000000005eeeec pte_update+0x11c/0x190
[c000000c6d1e7950] 0000000000000001 (unreliable)
[c000000c6d1e79b0] c0000000005eee14 pte_update+0x44/0x190
[c000000c6d1e7a10] c000000001a2ca9c pte_advanced_tests+0x160/0x3d8
[c000000c6d1e7ab0] c000000001a2d4fc debug_vm_pgtable+0x7e8/0x1338
[c000000c6d1e7ba0] c0000000000116ec do_one_initcall+0xac/0x5f0
[c000000c6d1e7c80] c0000000019e4fac kernel_init_freeable+0x4dc/0x5a4
[c000000c6d1e7db0] c000000000012474 kernel_init+0x24/0x160
[c000000c6d1e7e20] c00000000000cbd0 ret_from_kernel_thread+0x5c/0x6c

With DEBUG_VM disabled

[   20.530152] BUG: Kernel NULL pointer dereference on read at 0x00000000
[   20.530183] Faulting instruction address: 0xc0000000000df330
cpu 0x33: Vector: 380 (Data SLB Access) at [c000000c6d19f700]
    pc: c0000000000df330: memset+0x68/0x104
    lr: c00000000009f6d8: hash__pmdp_huge_get_and_clear+0xe8/0x1b0
    sp: c000000c6d19f990
   msr: 8000000002009033
   dar: 0
  current = 0xc000000c6d177480
  paca    = 0xc00000001ec4f400   irqmask: 0x03   irq_happened: 0x01
    pid   = 1, comm = swapper/0
[link register   ] c00000000009f6d8 hash__pmdp_huge_get_and_clear+0xe8/0x1b0
[c000000c6d19f990] c00000000009f748 hash__pmdp_huge_get_and_clear+0x158/0x1b0 (unreliable)
[c000000c6d19fa10] c0000000019ebf30 pmd_advanced_tests+0x1f0/0x378
[c000000c6d19fab0] c0000000019ed088 debug_vm_pgtable+0x79c/0x1244
[c000000c6d19fba0] c0000000000116ec do_one_initcall+0xac/0x5f0
[c000000c6d19fc80] c0000000019a4fac kernel_init_freeable+0x4dc/0x5a4
[c000000c6d19fdb0] c000000000012474 kernel_init+0x24/0x160
[c000000c6d19fe20] c00000000000cbd0 ret_from_kernel_thread+0x5c/0x6c


This patch (of 13):

With the hash page table, the kernel should not use pmd_clear for clearing
huge pte entries.  Add a DEBUG_VM WARN to catch the wrong usage.

Link: https://lkml.kernel.org/r/20200902114222.181353-1-aneesh.kumar@linux.ibm.com
Link: https://lkml.kernel.org/r/20200902114222.181353-2-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/book3s/64/pgtable.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~powerpc-mm-add-debug_vm-warn-for-pmd_clear
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -866,6 +866,13 @@ static inline bool pte_ci(pte_t pte)
 
 static inline void pmd_clear(pmd_t *pmdp)
 {
+	if (IS_ENABLED(CONFIG_DEBUG_VM) && !radix_enabled()) {
+		/*
+		 * Don't use this if we can possibly have a hash page table
+		 * entry mapping this.
+		 */
+		WARN_ON((pmd_val(*pmdp) & (H_PAGE_HASHPTE | _PAGE_PTE)) == (H_PAGE_HASHPTE | _PAGE_PTE));
+	}
 	*pmdp = __pmd(0);
 }
 
@@ -914,6 +921,13 @@ static inline int pmd_bad(pmd_t pmd)
 
 static inline void pud_clear(pud_t *pudp)
 {
+	if (IS_ENABLED(CONFIG_DEBUG_VM) && !radix_enabled()) {
+		/*
+		 * Don't use this if we can possibly have a hash page table
+		 * entry mapping this.
+		 */
+		WARN_ON((pud_val(*pudp) & (H_PAGE_HASHPTE | _PAGE_PTE)) == (H_PAGE_HASHPTE | _PAGE_PTE));
+	}
 	*pudp = __pud(0);
 }
 
_
