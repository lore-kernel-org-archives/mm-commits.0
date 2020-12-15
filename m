Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DD32C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78C9322D2B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbgLOX7C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:59808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727352AbgLOXVA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:21:00 -0500
Date:   Tue, 15 Dec 2020 15:19:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074386;
        bh=jiE7bE6uGrik7/Pyq++/HGWlT89eWSKxKrLdG+bRbfw=;
        h=From:To:Subject:From;
        b=SRfCq1pdonENGB40gws0sRUpo3l7EPNdIEIUOd39WrcvKU5cTVsnTUOjJN+l3V+Nu
         PRnPl6HrSP9jOFimYz/Er+StgpX7/mvyk1hTGdecIUK/WezW0Hl8nzWO1s2l4PZGI6
         HNUvTWT0Y3noYC5R+ZSvmOXVC02dnMz+A1H253Fc=
From:   akpm@linux-foundation.org
To:     bgeffon@google.com, catalin.marinas@arm.com,
        dan.carpenter@oracle.com, dan.j.williams@intel.com,
        dave.jiang@intel.com, dima@arista.com, hughd@google.com,
        jgg@ziepe.ca, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com,
        linux@armlinux.org.uk, luto@kernel.org, mike.kravetz@oracle.com,
        minchan@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org,
        rcampbell@nvidia.com, tglx@linutronix.de,
        tsbogend@alpha.franken.de, vbabka@suse.cz, viro@zeniv.linux.org.uk,
        vishal.l.verma@intel.com, will@kernel.org
Subject:  [merged] mm-forbid-splitting-special-mappings.patch
 removed from -mm tree
Message-ID: <20201215231945.Boz-OnZdt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: forbid splitting special mappings
has been removed from the -mm tree.  Its filename was
     mm-forbid-splitting-special-mappings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dmitry Safonov <dima@arista.com>
Subject: mm: forbid splitting special mappings

Don't allow splitting of vm_special_mapping's.  It affects vdso/vvar
areas.  Uprobes have only one page in xol_area so they aren't affected.

Those restrictions were enforced by checks in .mremap() callbacks. 
Restrict resizing with generic .split() callback.

Link: https://lkml.kernel.org/r/20201013013416.390574-7-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/vdso.c    |    9 -------
 arch/arm64/kernel/vdso.c  |   41 +++---------------------------------
 arch/mips/vdso/genvdso.c  |    4 ---
 arch/s390/kernel/vdso.c   |   11 ---------
 arch/x86/entry/vdso/vma.c |   17 --------------
 mm/mmap.c                 |   12 ++++++++++
 6 files changed, 17 insertions(+), 77 deletions(-)

--- a/arch/arm64/kernel/vdso.c~mm-forbid-splitting-special-mappings
+++ a/arch/arm64/kernel/vdso.c
@@ -78,17 +78,9 @@ static union {
 } vdso_data_store __page_aligned_data;
 struct vdso_data *vdso_data = vdso_data_store.data;
 
-static int __vdso_remap(enum vdso_abi abi,
-			const struct vm_special_mapping *sm,
-			struct vm_area_struct *new_vma)
-{
-	unsigned long new_size = new_vma->vm_end - new_vma->vm_start;
-	unsigned long vdso_size = vdso_info[abi].vdso_code_end -
-				  vdso_info[abi].vdso_code_start;
-
-	if (vdso_size != new_size)
-		return -EINVAL;
-
+static int vdso_mremap(const struct vm_special_mapping *sm,
+		struct vm_area_struct *new_vma)
+{
 	current->mm->context.vdso = (void *)new_vma->vm_start;
 
 	return 0;
@@ -219,17 +211,6 @@ static vm_fault_t vvar_fault(const struc
 	return vmf_insert_pfn(vma, vmf->address, pfn);
 }
 
-static int vvar_mremap(const struct vm_special_mapping *sm,
-		       struct vm_area_struct *new_vma)
-{
-	unsigned long new_size = new_vma->vm_end - new_vma->vm_start;
-
-	if (new_size != VVAR_NR_PAGES * PAGE_SIZE)
-		return -EINVAL;
-
-	return 0;
-}
-
 static int __setup_additional_pages(enum vdso_abi abi,
 				    struct mm_struct *mm,
 				    struct linux_binprm *bprm,
@@ -280,12 +261,6 @@ up_fail:
 /*
  * Create and map the vectors page for AArch32 tasks.
  */
-static int aarch32_vdso_mremap(const struct vm_special_mapping *sm,
-		struct vm_area_struct *new_vma)
-{
-	return __vdso_remap(VDSO_ABI_AA32, sm, new_vma);
-}
-
 enum aarch32_map {
 	AA32_MAP_VECTORS, /* kuser helpers */
 	AA32_MAP_SIGPAGE,
@@ -308,11 +283,10 @@ static struct vm_special_mapping aarch32
 	[AA32_MAP_VVAR] = {
 		.name = "[vvar]",
 		.fault = vvar_fault,
-		.mremap = vvar_mremap,
 	},
 	[AA32_MAP_VDSO] = {
 		.name = "[vdso]",
-		.mremap = aarch32_vdso_mremap,
+		.mremap = vdso_mremap,
 	},
 };
 
@@ -453,12 +427,6 @@ out:
 }
 #endif /* CONFIG_COMPAT */
 
-static int vdso_mremap(const struct vm_special_mapping *sm,
-		struct vm_area_struct *new_vma)
-{
-	return __vdso_remap(VDSO_ABI_AA64, sm, new_vma);
-}
-
 enum aarch64_map {
 	AA64_MAP_VVAR,
 	AA64_MAP_VDSO,
@@ -468,7 +436,6 @@ static struct vm_special_mapping aarch64
 	[AA64_MAP_VVAR] = {
 		.name	= "[vvar]",
 		.fault = vvar_fault,
-		.mremap = vvar_mremap,
 	},
 	[AA64_MAP_VDSO] = {
 		.name	= "[vdso]",
--- a/arch/arm/kernel/vdso.c~mm-forbid-splitting-special-mappings
+++ a/arch/arm/kernel/vdso.c
@@ -50,15 +50,6 @@ static const struct vm_special_mapping v
 static int vdso_mremap(const struct vm_special_mapping *sm,
 		struct vm_area_struct *new_vma)
 {
-	unsigned long new_size = new_vma->vm_end - new_vma->vm_start;
-	unsigned long vdso_size;
-
-	/* without VVAR page */
-	vdso_size = (vdso_total_pages - 1) << PAGE_SHIFT;
-
-	if (vdso_size != new_size)
-		return -EINVAL;
-
 	current->mm->context.vdso = new_vma->vm_start;
 
 	return 0;
--- a/arch/mips/vdso/genvdso.c~mm-forbid-splitting-special-mappings
+++ a/arch/mips/vdso/genvdso.c
@@ -263,10 +263,6 @@ int main(int argc, char **argv)
 	fprintf(out_file, "	const struct vm_special_mapping *sm,\n");
 	fprintf(out_file, "	struct vm_area_struct *new_vma)\n");
 	fprintf(out_file, "{\n");
-	fprintf(out_file, "	unsigned long new_size =\n");
-	fprintf(out_file, "	new_vma->vm_end - new_vma->vm_start;\n");
-	fprintf(out_file, "	if (vdso_image.size != new_size)\n");
-	fprintf(out_file, "		return -EINVAL;\n");
 	fprintf(out_file, "	current->mm->context.vdso =\n");
 	fprintf(out_file, "	(void *)(new_vma->vm_start);\n");
 	fprintf(out_file, "	return 0;\n");
--- a/arch/s390/kernel/vdso.c~mm-forbid-splitting-special-mappings
+++ a/arch/s390/kernel/vdso.c
@@ -61,17 +61,8 @@ static vm_fault_t vdso_fault(const struc
 static int vdso_mremap(const struct vm_special_mapping *sm,
 		       struct vm_area_struct *vma)
 {
-	unsigned long vdso_pages;
-
-	vdso_pages = vdso64_pages;
-
-	if ((vdso_pages << PAGE_SHIFT) != vma->vm_end - vma->vm_start)
-		return -EINVAL;
-
-	if (WARN_ON_ONCE(current->mm != vma->vm_mm))
-		return -EFAULT;
-
 	current->mm->context.vdso_base = vma->vm_start;
+
 	return 0;
 }
 
--- a/arch/x86/entry/vdso/vma.c~mm-forbid-splitting-special-mappings
+++ a/arch/x86/entry/vdso/vma.c
@@ -89,30 +89,14 @@ static void vdso_fix_landing(const struc
 static int vdso_mremap(const struct vm_special_mapping *sm,
 		struct vm_area_struct *new_vma)
 {
-	unsigned long new_size = new_vma->vm_end - new_vma->vm_start;
 	const struct vdso_image *image = current->mm->context.vdso_image;
 
-	if (image->size != new_size)
-		return -EINVAL;
-
 	vdso_fix_landing(image, new_vma);
 	current->mm->context.vdso = (void __user *)new_vma->vm_start;
 
 	return 0;
 }
 
-static int vvar_mremap(const struct vm_special_mapping *sm,
-		struct vm_area_struct *new_vma)
-{
-	const struct vdso_image *image = new_vma->vm_mm->context.vdso_image;
-	unsigned long new_size = new_vma->vm_end - new_vma->vm_start;
-
-	if (new_size != -image->sym_vvar_start)
-		return -EINVAL;
-
-	return 0;
-}
-
 #ifdef CONFIG_TIME_NS
 static struct page *find_timens_vvar_page(struct vm_area_struct *vma)
 {
@@ -252,7 +236,6 @@ static const struct vm_special_mapping v
 static const struct vm_special_mapping vvar_mapping = {
 	.name = "[vvar]",
 	.fault = vvar_fault,
-	.mremap = vvar_mremap,
 };
 
 /*
--- a/mm/mmap.c~mm-forbid-splitting-special-mappings
+++ a/mm/mmap.c
@@ -3422,6 +3422,17 @@ static int special_mapping_mremap(struct
 	return 0;
 }
 
+static int special_mapping_split(struct vm_area_struct *vma, unsigned long addr)
+{
+	/*
+	 * Forbid splitting special mappings - kernel has expectations over
+	 * the number of pages in mapping. Together with VM_DONTEXPAND
+	 * the size of vma should stay the same over the special mapping's
+	 * lifetime.
+	 */
+	return -EINVAL;
+}
+
 static const struct vm_operations_struct special_mapping_vmops = {
 	.close = special_mapping_close,
 	.fault = special_mapping_fault,
@@ -3429,6 +3440,7 @@ static const struct vm_operations_struct
 	.name = special_mapping_name,
 	/* vDSO code relies that VVAR can't be accessed remotely */
 	.access = NULL,
+	.may_split = special_mapping_split,
 };
 
 static const struct vm_operations_struct legacy_special_mapping_vmops = {
_

Patches currently in -mm which might be from dima@arista.com are


