Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE214C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:17:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233462AbiEJEVi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234185AbiEJEUD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72102AC6EA
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 545096176B
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DA0C385C2;
        Tue, 10 May 2022 04:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156102;
        bh=891iFn58qTQjl8fLgXNi24Ot3hUqBunUii/arwVaiWg=;
        h=Date:To:From:Subject:From;
        b=erBvftTxn8M8hU7959SnO11WclXKButGYdoWiA5IoCc7rfruH0c0bUjArUKlb4zb7
         6KiKLXrGScX4+2j6m++DNz7z1ES4MmjAL6aSYaJifs9IHuLJ7uhztbh4wHrlh7G5z4
         LIRf8ILNXMNL2g/T9oqi1Pk3wVsGmhOB36RQXoVU=
Date:   Mon, 09 May 2022 21:15:02 -0700
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
Subject: [merged mm-stable] s390-pgtable-support-__have_arch_pte_swp_exclusive.patch removed from -mm tree
Message-Id: <20220510041502.A5DA0C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: s390/pgtable: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE
has been removed from the -mm tree.  Its filename was
     s390-pgtable-support-__have_arch_pte_swp_exclusive.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: s390/pgtable: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE

Let's use bit 52, which is unused.

Link: https://lkml.kernel.org/r/20220329164329.208407-7-david@redhat.com
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

 arch/s390/include/asm/pgtable.h |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

--- a/arch/s390/include/asm/pgtable.h~s390-pgtable-support-__have_arch_pte_swp_exclusive
+++ a/arch/s390/include/asm/pgtable.h
@@ -181,6 +181,8 @@ static inline int is_module_addr(void *a
 #define _PAGE_SOFT_DIRTY 0x000
 #endif
 
+#define _PAGE_SWP_EXCLUSIVE _PAGE_LARGE	/* SW pte exclusive swap bit */
+
 /* Set of bits not changed in pte_modify */
 #define _PAGE_CHG_MASK		(PAGE_MASK | _PAGE_SPECIAL | _PAGE_DIRTY | \
 				 _PAGE_YOUNG | _PAGE_SOFT_DIRTY)
@@ -826,6 +828,22 @@ static inline int pmd_protnone(pmd_t pmd
 }
 #endif
 
+#define __HAVE_ARCH_PTE_SWP_EXCLUSIVE
+static inline int pte_swp_exclusive(pte_t pte)
+{
+	return pte_val(pte) & _PAGE_SWP_EXCLUSIVE;
+}
+
+static inline pte_t pte_swp_mkexclusive(pte_t pte)
+{
+	return set_pte_bit(pte, __pgprot(_PAGE_SWP_EXCLUSIVE));
+}
+
+static inline pte_t pte_swp_clear_exclusive(pte_t pte)
+{
+	return clear_pte_bit(pte, __pgprot(_PAGE_SWP_EXCLUSIVE));
+}
+
 static inline int pte_soft_dirty(pte_t pte)
 {
 	return pte_val(pte) & _PAGE_SOFT_DIRTY;
@@ -1715,14 +1733,15 @@ static inline int has_transparent_hugepa
  * Bits 54 and 63 are used to indicate the page type. Bit 53 marks the pte
  * as invalid.
  * A swap pte is indicated by bit pattern (pte & 0x201) == 0x200
- * |			  offset			|X11XX|type |S0|
+ * |			  offset			|E11XX|type |S0|
  * |0000000000111111111122222222223333333333444444444455|55555|55566|66|
  * |0123456789012345678901234567890123456789012345678901|23456|78901|23|
  *
  * Bits 0-51 store the offset.
+ * Bit 52 (E) is used to remember PG_anon_exclusive.
  * Bits 57-61 store the type.
  * Bit 62 (S) is used for softdirty tracking.
- * Bits 52, 55 and 56 (X) are unused.
+ * Bits 55 and 56 (X) are unused.
  */
 
 #define __SWP_OFFSET_MASK	((1UL << 52) - 1)
_

Patches currently in -mm which might be from david@redhat.com are


