Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE680C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:17:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234195AbiEJEVb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236101AbiEJEUC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73ABD2AC6E5
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:14:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FE2D6176A
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:14:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ABD2C385A6;
        Tue, 10 May 2022 04:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156098;
        bh=a3ZhfSANbIeGjVbGRRhhULvui1pPgc/DCsSiBs/o88U=;
        h=Date:To:From:Subject:From;
        b=FEICA80l70jUUg9roOlJUUEoR2MUwZK+bdmBO7jH/JTmN/v/xCgkAabn9JS9LFMSN
         K229nSY/IVSv0UJbSxrDnhdW62Qjb2V+X4+UmsVAx4U8WsaHkBphIn0fHtcBp4ecjS
         mf9zNB8UWT/FUjHXKvaVOjiiEZHn1ZmA9JIff0Ro=
Date:   Mon, 09 May 2022 21:14:57 -0700
To:     mm-commits@vger.kernel.org, zhangliang5@huawei.com,
        willy@infradead.org, will@kernel.org, vbabka@suse.cz,
        tglx@linutronix.de, shakeelb@google.com, rppt@linux.ibm.com,
        riel@surriel.com, peterx@redhat.com, pedrodemargomes@gmail.com,
        paulus@samba.org, oleg@redhat.com, oded.gabbay@gmail.com,
        namit@vmware.com, mpe@ellerman.id.au, mingo@redhat.com,
        mike.kravetz@oracle.com, mhocko@kernel.org,
        kirill.shutemov@linux.intel.com, jhubbard@nvidia.com,
        jgg@nvidia.com, jannh@google.com, jack@suse.cz, hughd@google.com,
        hch@lst.de, hca@linux.ibm.com, guro@fb.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, ddutile@redhat.com,
        dave.hansen@linux.intel.com, catalin.marinas@arm.com, bp@alien8.de,
        benh@kernel.crashing.org, aarcange@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-pgtable-support-__have_arch_pte_swp_exclusive.patch removed from -mm tree
Message-Id: <20220510041458.5ABD2C385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: x86/pgtable: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE
has been removed from the -mm tree.  Its filename was
     x86-pgtable-support-__have_arch_pte_swp_exclusive.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: x86/pgtable: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE

Let's use bit 3 to remember PG_anon_exclusive in swap ptes.

[david@redhat.com: fix 32-bit swap layout]
  Link: https://lkml.kernel.org/r/d875c292-46b3-f281-65ae-71d0b0c6f592@redhat.com
Link: https://lkml.kernel.org/r/20220329164329.208407-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Liang Zhang <zhangliang5@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Nadav Amit <namit@vmware.com>
Cc: Oded Gabbay <oded.gabbay@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h          |   17 +++++++++++++++++
 arch/x86/include/asm/pgtable_64.h       |    4 +++-
 arch/x86/include/asm/pgtable_64_types.h |    5 +++++
 3 files changed, 25 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/pgtable_64.h~x86-pgtable-support-__have_arch_pte_swp_exclusive
+++ a/arch/x86/include/asm/pgtable_64.h
@@ -186,7 +186,7 @@ static inline void native_pgd_clear(pgd_
  *
  * |     ...            | 11| 10|  9|8|7|6|5| 4| 3|2| 1|0| <- bit number
  * |     ...            |SW3|SW2|SW1|G|L|D|A|CD|WT|U| W|P| <- bit names
- * | TYPE (59-63) | ~OFFSET (9-58)  |0|0|X|X| X| X|F|SD|0| <- swp entry
+ * | TYPE (59-63) | ~OFFSET (9-58)  |0|0|X|X| X| E|F|SD|0| <- swp entry
  *
  * G (8) is aliased and used as a PROT_NONE indicator for
  * !present ptes.  We need to start storing swap entries above
@@ -203,6 +203,8 @@ static inline void native_pgd_clear(pgd_
  * F (2) in swp entry is used to record when a pagetable is
  * writeprotected by userfaultfd WP support.
  *
+ * E (3) in swp entry is used to rememeber PG_anon_exclusive.
+ *
  * Bit 7 in swp entry should be 0 because pmd_present checks not only P,
  * but also L and G.
  *
--- a/arch/x86/include/asm/pgtable_64_types.h~x86-pgtable-support-__have_arch_pte_swp_exclusive
+++ a/arch/x86/include/asm/pgtable_64_types.h
@@ -163,4 +163,9 @@ extern unsigned int ptrs_per_p4d;
 
 #define PGD_KERNEL_START	((PAGE_SIZE / 2) / sizeof(pgd_t))
 
+/*
+ * We borrow bit 3 to remember PG_anon_exclusive.
+ */
+#define _PAGE_SWP_EXCLUSIVE	_PAGE_PWT
+
 #endif /* _ASM_X86_PGTABLE_64_DEFS_H */
--- a/arch/x86/include/asm/pgtable.h~x86-pgtable-support-__have_arch_pte_swp_exclusive
+++ a/arch/x86/include/asm/pgtable.h
@@ -1286,6 +1286,23 @@ static inline void update_mmu_cache_pud(
 		unsigned long addr, pud_t *pud)
 {
 }
+#ifdef _PAGE_SWP_EXCLUSIVE
+#define __HAVE_ARCH_PTE_SWP_EXCLUSIVE
+static inline pte_t pte_swp_mkexclusive(pte_t pte)
+{
+	return pte_set_flags(pte, _PAGE_SWP_EXCLUSIVE);
+}
+
+static inline int pte_swp_exclusive(pte_t pte)
+{
+	return pte_flags(pte) & _PAGE_SWP_EXCLUSIVE;
+}
+
+static inline pte_t pte_swp_clear_exclusive(pte_t pte)
+{
+	return pte_clear_flags(pte, _PAGE_SWP_EXCLUSIVE);
+}
+#endif /* _PAGE_SWP_EXCLUSIVE */
 
 #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
 static inline pte_t pte_swp_mksoft_dirty(pte_t pte)
_

Patches currently in -mm which might be from david@redhat.com are


