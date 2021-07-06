Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F80EC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:17:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAE0661C91
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:17:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbhGFTUW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:20:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:54224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229925AbhGFTUW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:20:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B846B61C7C;
        Tue,  6 Jul 2021 19:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599063;
        bh=ToSbHANp0xFNv19+uSzTS3l7QMIna9OBUtx1xNuAN7A=;
        h=Date:From:To:Subject:From;
        b=vU1wdgBRwOdQzD2q/r5NUqon92Mi26TRKEO5P8xcPIt43dVsKmVcgwtBvHKT2d4CR
         dSnTIGhCsQpbIVCNcrFBwlwpfoig0p0+Pf7KgmMz5xhZp8k9YmEGfQkjBA7+txUTpw
         77eHeAnwGgv+7r8/rMHl7I0kAWnqlKcrRCh8v0uc=
Date:   Tue, 06 Jul 2021 12:17:42 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, almasrymina@google.com,
        axelrasmussen@google.com, bgeffon@google.com, dgilbert@redhat.com,
        hughd@google.com, jglisse@redhat.com, joe@perches.com,
        kirill@shutemov.name, lokeshgidra@google.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        oupton@google.com, peterx@redhat.com, rppt@linux.vnet.ibm.com,
        sfr@canb.auug.org.au, shli@fb.com, shuah@kernel.org,
        viro@zeniv.linux.org.uk, wangqing@vivo.com
Subject:  [merged]
 mm-pagemap-export-uffd-wp-protection-information.patch removed from -mm
 tree
Message-ID: <20210706191742.ktHXGfI3b%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/pagemap: export uffd-wp protection information
has been removed from the -mm tree.  Its filename was
     mm-pagemap-export-uffd-wp-protection-information.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/pagemap: export uffd-wp protection information

Export the PTE/PMD status of uffd-wp to pagemap too.

Link: https://lkml.kernel.org/r/20210428225030.9708-6-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Oliver Upton <oupton@google.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Wang Qing <wangqing@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/pagemap.rst |    2 ++
 fs/proc/task_mmu.c                       |    9 +++++++++
 2 files changed, 11 insertions(+)

--- a/Documentation/admin-guide/mm/pagemap.rst~mm-pagemap-export-uffd-wp-protection-information
+++ a/Documentation/admin-guide/mm/pagemap.rst
@@ -21,6 +21,8 @@ There are four components to pagemap:
     * Bit  55    pte is soft-dirty (see
       :ref:`Documentation/admin-guide/mm/soft-dirty.rst <soft_dirty>`)
     * Bit  56    page exclusively mapped (since 4.2)
+    * Bit  57    pte is uffd-wp write-protected (since 5.13) (see
+      :ref:`Documentation/admin-guide/mm/userfaultfd.rst <userfaultfd>`)
     * Bits 57-60 zero
     * Bit  61    page is file-page or shared-anon (since 3.5)
     * Bit  62    page swapped
--- a/fs/proc/task_mmu.c~mm-pagemap-export-uffd-wp-protection-information
+++ a/fs/proc/task_mmu.c
@@ -1302,6 +1302,7 @@ struct pagemapread {
 #define PM_PFRAME_MASK		GENMASK_ULL(PM_PFRAME_BITS - 1, 0)
 #define PM_SOFT_DIRTY		BIT_ULL(55)
 #define PM_MMAP_EXCLUSIVE	BIT_ULL(56)
+#define PM_UFFD_WP		BIT_ULL(57)
 #define PM_FILE			BIT_ULL(61)
 #define PM_SWAP			BIT_ULL(62)
 #define PM_PRESENT		BIT_ULL(63)
@@ -1375,10 +1376,14 @@ static pagemap_entry_t pte_to_pagemap_en
 		page = vm_normal_page(vma, addr, pte);
 		if (pte_soft_dirty(pte))
 			flags |= PM_SOFT_DIRTY;
+		if (pte_uffd_wp(pte))
+			flags |= PM_UFFD_WP;
 	} else if (is_swap_pte(pte)) {
 		swp_entry_t entry;
 		if (pte_swp_soft_dirty(pte))
 			flags |= PM_SOFT_DIRTY;
+		if (pte_swp_uffd_wp(pte))
+			flags |= PM_UFFD_WP;
 		entry = pte_to_swp_entry(pte);
 		if (pm->show_pfn)
 			frame = swp_type(entry) |
@@ -1426,6 +1431,8 @@ static int pagemap_pmd_range(pmd_t *pmdp
 			flags |= PM_PRESENT;
 			if (pmd_soft_dirty(pmd))
 				flags |= PM_SOFT_DIRTY;
+			if (pmd_uffd_wp(pmd))
+				flags |= PM_UFFD_WP;
 			if (pm->show_pfn)
 				frame = pmd_pfn(pmd) +
 					((addr & ~PMD_MASK) >> PAGE_SHIFT);
@@ -1444,6 +1451,8 @@ static int pagemap_pmd_range(pmd_t *pmdp
 			flags |= PM_SWAP;
 			if (pmd_swp_soft_dirty(pmd))
 				flags |= PM_SOFT_DIRTY;
+			if (pmd_swp_uffd_wp(pmd))
+				flags |= PM_UFFD_WP;
 			VM_BUG_ON(!is_pmd_migration_entry(pmd));
 			page = migration_entry_to_page(entry);
 		}
_

Patches currently in -mm which might be from peterx@redhat.com are


