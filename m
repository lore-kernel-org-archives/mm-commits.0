Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F268C727A2
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:23:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236998AbjHXXWu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244118AbjHXXWO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:22:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4FDAFB
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:22:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82D1B65BCA
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:22:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3496C433D9;
        Thu, 24 Aug 2023 23:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919330;
        bh=n2L85X01zf5RSWoQooBpceR46lFIOBHDCRzOvdIMVX8=;
        h=Date:To:From:Subject:From;
        b=j4OE9xu2BYC9i1mK9iV9IcwVpgz3Ov1VlSUnPVHjfLXapc+77BmHFoHc0QRuF6ocp
         GBZE3Jg78ArBar8ck9TXcC5n5lo7PKNej/Gr3lxe79oLzx8rYumRWU4UllXZDDkGZY
         7197Zq+lIyrVDsBuB4JSOUSv2m7mVRwZHRv/4M6c=
Date:   Thu, 24 Aug 2023 16:22:10 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-allow-huge_fault-to-be-called-without-the-mmap_lock-held.patch removed from -mm tree
Message-Id: <20230824232210.D3496C433D9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: allow ->huge_fault() to be called without the mmap_lock held
has been removed from the -mm tree.  Its filename was
     mm-allow-huge_fault-to-be-called-without-the-mmap_lock-held.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: allow ->huge_fault() to be called without the mmap_lock held
Date: Fri, 18 Aug 2023 21:23:34 +0100

Remove the checks for the VMA lock being held, allowing the page fault
path to call into the filesystem instead of retrying with the mmap_lock
held.  This will improve scalability for DAX page faults.  Also update the
documentation to match (and fix some other changes that have happened
recently).

Link: https://lkml.kernel.org/r/20230818202335.2739663-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/locking.rst |   36 +++++++++++++++---------
 Documentation/filesystems/porting.rst |   11 +++++++
 mm/memory.c                           |   22 +-------------
 3 files changed, 36 insertions(+), 33 deletions(-)

--- a/Documentation/filesystems/locking.rst~mm-allow-huge_fault-to-be-called-without-the-mmap_lock-held
+++ a/Documentation/filesystems/locking.rst
@@ -628,26 +628,29 @@ vm_operations_struct
 
 prototypes::
 
-	void (*open)(struct vm_area_struct*);
-	void (*close)(struct vm_area_struct*);
-	vm_fault_t (*fault)(struct vm_area_struct*, struct vm_fault *);
+	void (*open)(struct vm_area_struct *);
+	void (*close)(struct vm_area_struct *);
+	vm_fault_t (*fault)(struct vm_fault *);
+	vm_fault_t (*huge_fault)(struct vm_fault *, unsigned int order);
+	vm_fault_t (*map_pages)(struct vm_fault *, pgoff_t start, pgoff_t end);
 	vm_fault_t (*page_mkwrite)(struct vm_area_struct *, struct vm_fault *);
 	vm_fault_t (*pfn_mkwrite)(struct vm_area_struct *, struct vm_fault *);
 	int (*access)(struct vm_area_struct *, unsigned long, void*, int, int);
 
 locking rules:
 
-=============	=========	===========================
+=============	==========	===========================
 ops		mmap_lock	PageLocked(page)
-=============	=========	===========================
-open:		yes
-close:		yes
-fault:		yes		can return with page locked
-map_pages:	read
-page_mkwrite:	yes		can return with page locked
-pfn_mkwrite:	yes
-access:		yes
-=============	=========	===========================
+=============	==========	===========================
+open:		write
+close:		read/write
+fault:		read		can return with page locked
+huge_fault:	maybe-read
+map_pages:	maybe-read
+page_mkwrite:	read		can return with page locked
+pfn_mkwrite:	read
+access:		read
+=============	==========	===========================
 
 ->fault() is called when a previously not present pte is about to be faulted
 in. The filesystem must find and return the page associated with the passed in
@@ -657,6 +660,13 @@ then ensure the page is not already trun
 subsequent truncate), and then return with VM_FAULT_LOCKED, and the page
 locked. The VM will unlock the page.
 
+->huge_fault() is called when there is no PUD or PMD entry present.  This
+gives the filesystem the opportunity to install a PUD or PMD sized page.
+Filesystems can also use the ->fault method to return a PMD sized page,
+so implementing this function may not be necessary.  In particular,
+filesystems should not call filemap_fault() from ->huge_fault().
+The mmap_lock may not be held when this method is called.
+
 ->map_pages() is called when VM asks to map easy accessible pages.
 Filesystem should find and map pages associated with offsets from "start_pgoff"
 till "end_pgoff". ->map_pages() is called with the RCU lock held and must
--- a/Documentation/filesystems/porting.rst~mm-allow-huge_fault-to-be-called-without-the-mmap_lock-held
+++ a/Documentation/filesystems/porting.rst
@@ -943,3 +943,14 @@ file pointer instead of struct dentry po
 changed to simplify callers.  The passed file is in a non-open state and on
 success must be opened before returning (e.g. by calling
 finish_open_simple()).
+
+---
+
+**mandatory**
+
+Calling convention for ->huge_fault has changed.  It now takes a page
+order instead of an enum page_entry_size, and it may be called without the
+mmap_lock held.  All in-tree users have been audited and do not seem to
+depend on the mmap_lock being held, but out of tree users should verify
+for themselves.  If they do need it, they can return VM_FAULT_RETRY to
+be called with the mmap_lock held.
--- a/mm/memory.c~mm-allow-huge_fault-to-be-called-without-the-mmap_lock-held
+++ a/mm/memory.c
@@ -4854,13 +4854,8 @@ static inline vm_fault_t create_huge_pmd
 	struct vm_area_struct *vma = vmf->vma;
 	if (vma_is_anonymous(vma))
 		return do_huge_pmd_anonymous_page(vmf);
-	if (vma->vm_ops->huge_fault) {
-		if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
-			vma_end_read(vma);
-			return VM_FAULT_RETRY;
-		}
+	if (vma->vm_ops->huge_fault)
 		return vma->vm_ops->huge_fault(vmf, PE_SIZE_PMD);
-	}
 	return VM_FAULT_FALLBACK;
 }
 
@@ -4880,10 +4875,6 @@ static inline vm_fault_t wp_huge_pmd(str
 
 	if (vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) {
 		if (vma->vm_ops->huge_fault) {
-			if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
-				vma_end_read(vma);
-				return VM_FAULT_RETRY;
-			}
 			ret = vma->vm_ops->huge_fault(vmf, PE_SIZE_PMD);
 			if (!(ret & VM_FAULT_FALLBACK))
 				return ret;
@@ -4904,13 +4895,8 @@ static vm_fault_t create_huge_pud(struct
 	/* No support for anonymous transparent PUD pages yet */
 	if (vma_is_anonymous(vma))
 		return VM_FAULT_FALLBACK;
-	if (vma->vm_ops->huge_fault) {
-		if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
-			vma_end_read(vma);
-			return VM_FAULT_RETRY;
-		}
+	if (vma->vm_ops->huge_fault)
 		return vma->vm_ops->huge_fault(vmf, PE_SIZE_PUD);
-	}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 	return VM_FAULT_FALLBACK;
 }
@@ -4927,10 +4913,6 @@ static vm_fault_t wp_huge_pud(struct vm_
 		goto split;
 	if (vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) {
 		if (vma->vm_ops->huge_fault) {
-			if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
-				vma_end_read(vma);
-				return VM_FAULT_RETRY;
-			}
 			ret = vma->vm_ops->huge_fault(vmf, PE_SIZE_PUD);
 			if (!(ret & VM_FAULT_FALLBACK))
 				return ret;
_

Patches currently in -mm which might be from willy@infradead.org are


