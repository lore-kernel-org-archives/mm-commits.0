Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2B7AC6FD19
	for <mm-commits@archiver.kernel.org>; Mon, 13 Mar 2023 01:02:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjCMBCC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 12 Mar 2023 21:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCMBCC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 12 Mar 2023 21:02:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F252A6DE
        for <mm-commits@vger.kernel.org>; Sun, 12 Mar 2023 18:01:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F90E6101E
        for <mm-commits@vger.kernel.org>; Mon, 13 Mar 2023 01:01:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C607EC433EF;
        Mon, 13 Mar 2023 01:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678669318;
        bh=je9FUkZSniCQrNnSqGVrUa0Mdmlb0Yyg3m1sbUcPznI=;
        h=Date:To:From:Subject:From;
        b=iI72X0ZSNt+zuZFZU1IBov+n4FQ/y8KevgHOlnqYyJgKmHZHndyEcdQZaCPoyp6Pu
         +sysd5nzWi0H3VlAFdrGFzIf3xc0MTmPKyrkEHmTqhCDnIiUIAnJcbD1u8F73UVYJr
         6DBDdn2XmTvxqPZZL4zU1Lw7oB+PnEpnEB3yk+gE=
Date:   Sun, 12 Mar 2023 18:01:58 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        thomas.hellstrom@linux.intel.com, mhocko@suse.com,
        kirill.shutemov@linux.intel.com, jgg@ziepe.ca,
        dan.j.williams@intel.com, christian.koenig@amd.com,
        lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-unused-vmf_insert_mixed_prot.patch added to mm-unstable branch
Message-Id: <20230313010158.C607EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove unused vmf_insert_mixed_prot()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-unused-vmf_insert_mixed_prot.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-unused-vmf_insert_mixed_prot.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm: remove unused vmf_insert_mixed_prot()
Date: Sun, 12 Mar 2023 23:40:13 +0000

Patch series "Remove drm/ttm-specific mm changes".

Functionality was added specifically for the DRM TTM driver to support
mapping memory for VM_MIXEDMAP VMAs with customised protection flags,
however this has now been rolled back as issues were found with this
approach.

This series removes the mm changes too, retaining some of the useful
comments.


This patch (of 3):

The sole user of vmf_insert_mixed_prot(), the drm ttm module, stopped
using this in commit f91142c62161 ("drm/ttm: nuke VM_MIXEDMAP on BO
mappings v3") citing use of VM_MIXEDMAP in this case being terribly
broken.

Remove this now-dead code and references to it, but retain the useful
description of the prot != vma->vm_page_prot case, moving it to
vmf_insert_pfn_prot() instead.

Link: https://lkml.kernel.org/r/cover.1678661628.git.lstoakes@gmail.com
Link: https://lkml.kernel.org/r/a069644388e6f1593a7020d15840e6fc9f39bcaf.1678661628.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mm.h~mm-remove-unused-vmf_insert_mixed_prot
+++ a/include/linux/mm.h
@@ -3330,8 +3330,6 @@ vm_fault_t vmf_insert_pfn_prot(struct vm
 			unsigned long pfn, pgprot_t pgprot);
 vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
 			pfn_t pfn);
-vm_fault_t vmf_insert_mixed_prot(struct vm_area_struct *vma, unsigned long addr,
-			pfn_t pfn, pgprot_t pgprot);
 vm_fault_t vmf_insert_mixed_mkwrite(struct vm_area_struct *vma,
 		unsigned long addr, pfn_t pfn);
 int vm_iomap_memory(struct vm_area_struct *vma, phys_addr_t start, unsigned long len);
--- a/include/linux/mm_types.h~mm-remove-unused-vmf_insert_mixed_prot
+++ a/include/linux/mm_types.h
@@ -502,12 +502,7 @@ struct vm_area_struct {
 	};
 
 	struct mm_struct *vm_mm;	/* The address space we belong to. */
-
-	/*
-	 * Access permissions of this VMA.
-	 * See vmf_insert_mixed_prot() for discussion.
-	 */
-	pgprot_t vm_page_prot;
+	pgprot_t vm_page_prot;          /* Access permissions of this VMA. */
 
 	/*
 	 * Flags, see mm.h.
--- a/mm/memory.c~mm-remove-unused-vmf_insert_mixed_prot
+++ a/mm/memory.c
@@ -2169,8 +2169,20 @@ out_unlock:
  * vmf_insert_pfn_prot should only be used if using multiple VMAs is
  * impractical.
  *
- * See vmf_insert_mixed_prot() for a discussion of the implication of using
- * a value of @pgprot different from that of @vma->vm_page_prot.
+ * pgprot typically only differs from @vma->vm_page_prot when drivers set
+ * caching- and encryption bits different than those of @vma->vm_page_prot,
+ * because the caching- or encryption mode may not be known at mmap() time.
+ *
+ * This is ok as long as @vma->vm_page_prot is not used by the core vm
+ * to set caching and encryption bits for those vmas (except for COW pages).
+ * This is ensured by core vm only modifying these page table entries using
+ * functions that don't touch caching- or encryption bits, using pte_modify()
+ * if needed. (See for example mprotect()).
+ *
+ * Also when new page-table entries are created, this is only done using the
+ * fault() callback, and never using the value of vma->vm_page_prot,
+ * except for page-table entries that point to anonymous pages as the result
+ * of COW.
  *
  * Context: Process context.  May allocate using %GFP_KERNEL.
  * Return: vm_fault_t value.
@@ -2245,9 +2257,9 @@ static bool vm_mixed_ok(struct vm_area_s
 }
 
 static vm_fault_t __vm_insert_mixed(struct vm_area_struct *vma,
-		unsigned long addr, pfn_t pfn, pgprot_t pgprot,
-		bool mkwrite)
+		unsigned long addr, pfn_t pfn, bool mkwrite)
 {
+	pgprot_t pgprot = vma->vm_page_prot;
 	int err;
 
 	BUG_ON(!vm_mixed_ok(vma, pfn));
@@ -2290,43 +2302,10 @@ static vm_fault_t __vm_insert_mixed(stru
 	return VM_FAULT_NOPAGE;
 }
 
-/**
- * vmf_insert_mixed_prot - insert single pfn into user vma with specified pgprot
- * @vma: user vma to map to
- * @addr: target user address of this page
- * @pfn: source kernel pfn
- * @pgprot: pgprot flags for the inserted page
- *
- * This is exactly like vmf_insert_mixed(), except that it allows drivers
- * to override pgprot on a per-page basis.
- *
- * Typically this function should be used by drivers to set caching- and
- * encryption bits different than those of @vma->vm_page_prot, because
- * the caching- or encryption mode may not be known at mmap() time.
- * This is ok as long as @vma->vm_page_prot is not used by the core vm
- * to set caching and encryption bits for those vmas (except for COW pages).
- * This is ensured by core vm only modifying these page table entries using
- * functions that don't touch caching- or encryption bits, using pte_modify()
- * if needed. (See for example mprotect()).
- * Also when new page-table entries are created, this is only done using the
- * fault() callback, and never using the value of vma->vm_page_prot,
- * except for page-table entries that point to anonymous pages as the result
- * of COW.
- *
- * Context: Process context.  May allocate using %GFP_KERNEL.
- * Return: vm_fault_t value.
- */
-vm_fault_t vmf_insert_mixed_prot(struct vm_area_struct *vma, unsigned long addr,
-				 pfn_t pfn, pgprot_t pgprot)
-{
-	return __vm_insert_mixed(vma, addr, pfn, pgprot, false);
-}
-EXPORT_SYMBOL(vmf_insert_mixed_prot);
-
 vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
 		pfn_t pfn)
 {
-	return __vm_insert_mixed(vma, addr, pfn, vma->vm_page_prot, false);
+	return __vm_insert_mixed(vma, addr, pfn, false);
 }
 EXPORT_SYMBOL(vmf_insert_mixed);
 
@@ -2338,7 +2317,7 @@ EXPORT_SYMBOL(vmf_insert_mixed);
 vm_fault_t vmf_insert_mixed_mkwrite(struct vm_area_struct *vma,
 		unsigned long addr, pfn_t pfn)
 {
-	return __vm_insert_mixed(vma, addr, pfn, vma->vm_page_prot, true);
+	return __vm_insert_mixed(vma, addr, pfn, true);
 }
 EXPORT_SYMBOL(vmf_insert_mixed_mkwrite);
 
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-remove-unused-vmf_insert_mixed_prot.patch
mm-remove-vmf_insert_pfn_xxx_prot-for-huge-page-table-entries.patch
drm-ttm-remove-comment-referencing-now-removed-vmf_insert_mixed_prot.patch

