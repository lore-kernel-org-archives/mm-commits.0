Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6042C43219
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:17:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234185AbiEJEVk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236081AbiEJEUb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA462AC6EF
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 275E36176C
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71FBDC385A6;
        Tue, 10 May 2022 04:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156105;
        bh=kpKHGbSqjLQN6fpcm1tXEsOPXSD8s36zoR8eRp98qIg=;
        h=Date:To:From:Subject:From;
        b=HXnV7fDl9Y2pGsWvLFrDF4431OSzRDTCA8jafHmrNA9L9oKIzpP9EA82VYzgveXtY
         i2UP/A8Egy5lkw6JAZlJwt2mRMSKTb6J1uRkIfHETQsbuC4Q+4fONLH6cxF6KWfMfw
         +ZmkhOXAdkdYN40d04WTR1+jrdKkLNCTMn1iPXfo=
Date:   Mon, 09 May 2022 21:15:04 -0700
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
Subject: [merged mm-stable] powerpc-pgtable-support-__have_arch_pte_swp_exclusive-for-book3s.patch removed from -mm tree
Message-Id: <20220510041505.71FBDC385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: powerpc/pgtable: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE for book3s
has been removed from the -mm tree.  Its filename was
     powerpc-pgtable-support-__have_arch_pte_swp_exclusive-for-book3s.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: powerpc/pgtable: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE for book3s

Right now, the last 5 bits (0x1f) of the swap entry are used for the type
and the bit before that (0x20) is used for _PAGE_SWP_SOFT_DIRTY.  We
cannot use 0x40, as that collides with _RPAGE_RSV1 -- contained in
_PAGE_HPTEFLAGS.  The next candidate would be _RPAGE_SW3 (0x200) -- which
is used for _PAGE_SOFT_DIRTY for !swp ptes.

So let's just use _PAGE_SOFT_DIRTY for _PAGE_SWP_SOFT_DIRTY (to make it
easier to grasp) and use 0x20 now for _PAGE_SWP_EXCLUSIVE.

Link: https://lkml.kernel.org/r/20220329164329.208407-9-david@redhat.com
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

 arch/powerpc/include/asm/book3s/64/pgtable.h |   21 ++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~powerpc-pgtable-support-__have_arch_pte_swp_exclusive-for-book3s
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -752,6 +752,7 @@ static inline pte_t pte_modify(pte_t pte
 	 */							\
 	BUILD_BUG_ON(_PAGE_HPTEFLAGS & SWP_TYPE_MASK); \
 	BUILD_BUG_ON(_PAGE_HPTEFLAGS & _PAGE_SWP_SOFT_DIRTY);	\
+	BUILD_BUG_ON(_PAGE_HPTEFLAGS & _PAGE_SWP_EXCLUSIVE);	\
 	} while (0)
 
 #define SWP_TYPE_BITS 5
@@ -772,11 +773,13 @@ static inline pte_t pte_modify(pte_t pte
 #define __swp_entry_to_pmd(x)	(pte_pmd(__swp_entry_to_pte(x)))
 
 #ifdef CONFIG_MEM_SOFT_DIRTY
-#define _PAGE_SWP_SOFT_DIRTY	_PAGE_NON_IDEMPOTENT
+#define _PAGE_SWP_SOFT_DIRTY	_PAGE_SOFT_DIRTY
 #else
 #define _PAGE_SWP_SOFT_DIRTY	0UL
 #endif /* CONFIG_MEM_SOFT_DIRTY */
 
+#define _PAGE_SWP_EXCLUSIVE	_PAGE_NON_IDEMPOTENT
+
 #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
 static inline pte_t pte_swp_mksoft_dirty(pte_t pte)
 {
@@ -794,6 +797,22 @@ static inline pte_t pte_swp_clear_soft_d
 }
 #endif /* CONFIG_HAVE_ARCH_SOFT_DIRTY */
 
+#define __HAVE_ARCH_PTE_SWP_EXCLUSIVE
+static inline pte_t pte_swp_mkexclusive(pte_t pte)
+{
+	return __pte_raw(pte_raw(pte) | cpu_to_be64(_PAGE_SWP_EXCLUSIVE));
+}
+
+static inline int pte_swp_exclusive(pte_t pte)
+{
+	return !!(pte_raw(pte) & cpu_to_be64(_PAGE_SWP_EXCLUSIVE));
+}
+
+static inline pte_t pte_swp_clear_exclusive(pte_t pte)
+{
+	return __pte_raw(pte_raw(pte) & cpu_to_be64(~_PAGE_SWP_EXCLUSIVE));
+}
+
 static inline bool check_pte_access(unsigned long access, unsigned long ptev)
 {
 	/*
_

Patches currently in -mm which might be from david@redhat.com are


