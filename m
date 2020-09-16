Return-Path: <SRS0=oQto=CZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDFE5C43461
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 23:20:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B84B022209
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 23:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600298459;
	bh=DMMvuk+xRS/svmzjK5svzuMca2AuUIacP1TOgBrD5MU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=MKzLCwlwqOWCQIa331z2qvtnC2QxzkmG3ddo6txkCApsvXuJF4wqsYGxL9FZiNFSi
	 wDxFlDcWRr62aacLNjJzGs34BCd+CIWefOse9EIESZQeAOKB4hL0WYP5gdLCzk2i6m
	 xHUbR0HOMCIVKs6W7SGx8oPjhMYfccfLh6kv91WQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgIPXU7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Sep 2020 19:20:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:40908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726084AbgIPXU7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Sep 2020 19:20:59 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09E5822205;
        Wed, 16 Sep 2020 23:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600298457;
        bh=DMMvuk+xRS/svmzjK5svzuMca2AuUIacP1TOgBrD5MU=;
        h=Date:From:To:Subject:From;
        b=V2ftxXDeTepYbkVwYMIU7w19UlL8Lh+xn48cEOyJ0j4pGAOYVvcOq6uvF9qwNJ99n
         2NUKSF08eEesZDhW41RyAfbimn4gLRXjuT7FoL6h+/jJwdUlYV3lgZS8oULX6qExjc
         gNkJLvVERJmnJBqbXcyJkMJVNq74gNgrYKc9vodo=
Date:   Wed, 16 Sep 2020 16:20:55 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        viro@zeniv.linux.org.uk, tycho@tycho.ws, tglx@linutronix.de,
        peterz@infradead.org, paul.walmsley@sifive.com,
        palmerdabbelt@google.com, palmer@dabbelt.com,
        mtk.manpages@gmail.com, mingo@redhat.com, mark.rutland@arm.com,
        luto@kernel.org, kirill@shutemov.name, jejb@linux.ibm.com,
        idan.yaniv@ibm.com, hpa@zytor.com, elena.reshetova@intel.com,
        david@redhat.com, dave.hansen@linux.intel.com,
        dan.j.williams@intel.com, cl@linux.com, catalin.marinas@arm.com,
        bp@alien8.de, arnd@arndb.de, rppt@linux.ibm.com
Subject:  +
 mm-secretmem-use-pmd-size-pages-to-amortize-direct-map-fragmentation.patch
 added to -mm tree
Message-ID: <20200916232055.FNLid%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: secretmem: use PMD-size pages to amortize direct map fragmentation
has been added to the -mm tree.  Its filename is
     mm-secretmem-use-pmd-size-pages-to-amortize-direct-map-fragmentation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-secretmem-use-pmd-size-pages-to-amortize-direct-map-fragmentation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-secretmem-use-pmd-size-pages-to-amortize-direct-map-fragmentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm: secretmem: use PMD-size pages to amortize direct map fragmentation

Removing a PAGE_SIZE page from the direct map every time such page is
allocated for a secret memory mapping will cause severe fragmentation of
the direct map.  This fragmentation can be reduced by using PMD-size pages
as a pool for small pages for secret memory mappings.

Add a gen_pool per secretmem inode and lazily populate this pool with
PMD-size pages.

Link: https://lkml.kernel.org/r/20200916073539.3552-6-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christopher Lameter <cl@linux.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Elena Reshetova <elena.reshetova@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Idan Yaniv <idan.yaniv@ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Bottomley <jejb@linux.ibm.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Palmer Dabbelt <palmerdabbelt@google.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tycho Andersen <tycho@tycho.ws>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/secretmem.c |  107 ++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 88 insertions(+), 19 deletions(-)

--- a/mm/secretmem.c~mm-secretmem-use-pmd-size-pages-to-amortize-direct-map-fragmentation
+++ a/mm/secretmem.c
@@ -12,6 +12,7 @@
 #include <linux/bitops.h>
 #include <linux/printk.h>
 #include <linux/pagemap.h>
+#include <linux/genalloc.h>
 #include <linux/syscalls.h>
 #include <linux/pseudo_fs.h>
 #include <linux/set_memory.h>
@@ -40,24 +41,66 @@
 #define SECRETMEM_FLAGS_MASK	SECRETMEM_MODE_MASK
 
 struct secretmem_ctx {
+	struct gen_pool *pool;
 	unsigned int mode;
 };
 
-static struct page *secretmem_alloc_page(gfp_t gfp)
+static int secretmem_pool_increase(struct secretmem_ctx *ctx, gfp_t gfp)
 {
-	/*
-	 * FIXME: use a cache of large pages to reduce the direct map
-	 * fragmentation
-	 */
-	return alloc_page(gfp);
+	unsigned long nr_pages = (1 << PMD_PAGE_ORDER);
+	struct gen_pool *pool = ctx->pool;
+	unsigned long addr;
+	struct page *page;
+	int err;
+
+	page = alloc_pages(gfp, PMD_PAGE_ORDER);
+	if (!page)
+		return -ENOMEM;
+
+	addr = (unsigned long)page_address(page);
+	split_page(page, PMD_PAGE_ORDER);
+
+	err = gen_pool_add(pool, addr, PMD_SIZE, NUMA_NO_NODE);
+	if (err) {
+		__free_pages(page, PMD_PAGE_ORDER);
+		return err;
+	}
+
+	__kernel_map_pages(page, nr_pages, 0);
+
+	return 0;
+}
+
+static struct page *secretmem_alloc_page(struct secretmem_ctx *ctx,
+					 gfp_t gfp)
+{
+	struct gen_pool *pool = ctx->pool;
+	unsigned long addr;
+	struct page *page;
+	int err;
+
+	if (gen_pool_avail(pool) < PAGE_SIZE) {
+		err = secretmem_pool_increase(ctx, gfp);
+		if (err)
+			return NULL;
+	}
+
+	addr = gen_pool_alloc(pool, PAGE_SIZE);
+	if (!addr)
+		return NULL;
+
+	page = virt_to_page(addr);
+	get_page(page);
+
+	return page;
 }
 
 static vm_fault_t secretmem_fault(struct vm_fault *vmf)
 {
+	struct secretmem_ctx *ctx = vmf->vma->vm_file->private_data;
 	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
 	struct inode *inode = file_inode(vmf->vma->vm_file);
 	pgoff_t offset = vmf->pgoff;
-	unsigned long addr;
 	struct page *page;
 	int ret = 0;
 
@@ -66,7 +109,7 @@ static vm_fault_t secretmem_fault(struct
 
 	page = find_get_entry(mapping, offset);
 	if (!page) {
-		page = secretmem_alloc_page(vmf->gfp_mask);
+		page = secretmem_alloc_page(ctx, vmf->gfp_mask);
 		if (!page)
 			return vmf_error(-ENOMEM);
 
@@ -74,14 +117,8 @@ static vm_fault_t secretmem_fault(struct
 		if (unlikely(ret))
 			goto err_put_page;
 
-		ret = set_direct_map_invalid_noflush(page);
-		if (ret)
-			goto err_del_page_cache;
-
-		addr = (unsigned long)page_address(page);
-		flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
-
 		__SetPageUptodate(page);
+		set_page_private(page, (unsigned long)ctx);
 
 		ret = VM_FAULT_LOCKED;
 	}
@@ -89,8 +126,6 @@ static vm_fault_t secretmem_fault(struct
 	vmf->page = page;
 	return ret;
 
-err_del_page_cache:
-	delete_from_page_cache(page);
 err_put_page:
 	put_page(page);
 	return vmf_error(ret);
@@ -138,7 +173,11 @@ static int secretmem_migratepage(struct
 
 static void secretmem_freepage(struct page *page)
 {
-	set_direct_map_default_noflush(page);
+	unsigned long addr = (unsigned long)page_address(page);
+	struct secretmem_ctx *ctx = (struct secretmem_ctx *)page_private(page);
+	struct gen_pool *pool = ctx->pool;
+
+	gen_pool_free(pool, addr, PAGE_SIZE);
 }
 
 static const struct address_space_operations secretmem_aops = {
@@ -163,13 +202,18 @@ static struct file *secretmem_file_creat
 	if (!ctx)
 		goto err_free_inode;
 
+	ctx->pool = gen_pool_create(PAGE_SHIFT, NUMA_NO_NODE);
+	if (!ctx->pool)
+		goto err_free_ctx;
+
 	file = alloc_file_pseudo(inode, secretmem_mnt, "secretmem",
 				 O_RDWR, &secretmem_fops);
 	if (IS_ERR(file))
-		goto err_free_ctx;
+		goto err_free_pool;
 
 	mapping_set_unevictable(inode->i_mapping);
 
+	inode->i_private = ctx;
 	inode->i_mapping->private_data = ctx;
 	inode->i_mapping->a_ops = &secretmem_aops;
 
@@ -183,6 +227,8 @@ static struct file *secretmem_file_creat
 
 	return file;
 
+err_free_pool:
+	gen_pool_destroy(ctx->pool);
 err_free_ctx:
 	kfree(ctx);
 err_free_inode:
@@ -221,11 +267,34 @@ err_put_fd:
 	return err;
 }
 
+static void secretmem_cleanup_chunk(struct gen_pool *pool,
+				    struct gen_pool_chunk *chunk, void *data)
+{
+	unsigned long start = chunk->start_addr;
+	unsigned long end = chunk->end_addr;
+	unsigned long nr_pages, addr;
+
+	nr_pages = (end - start + 1) / PAGE_SIZE;
+	__kernel_map_pages(virt_to_page(start), nr_pages, 1);
+
+	for (addr = start; addr < end; addr += PAGE_SIZE)
+		put_page(virt_to_page(addr));
+}
+
+static void secretmem_cleanup_pool(struct secretmem_ctx *ctx)
+{
+	struct gen_pool *pool = ctx->pool;
+
+	gen_pool_for_each_chunk(pool, secretmem_cleanup_chunk, ctx);
+	gen_pool_destroy(pool);
+}
+
 static void secretmem_evict_inode(struct inode *inode)
 {
 	struct secretmem_ctx *ctx = inode->i_private;
 
 	truncate_inode_pages_final(&inode->i_data);
+	secretmem_cleanup_pool(ctx);
 	clear_inode(inode);
 	kfree(ctx);
 }
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-account-pmd-tables-like-pte-tables-fix.patch
kvm-ppc-book3s-hv-simplify-kvm_cma_reserve.patch
dma-contiguous-simplify-cma_early_percent_memory.patch
arm-xtensa-simplify-initialization-of-high-memory-pages.patch
arm64-numa-simplify-dummy_numa_init.patch
h8300-nds32-openrisc-simplify-detection-of-memory-extents.patch
riscv-drop-unneeded-node-initialization.patch
mircoblaze-drop-unneeded-numa-and-sparsemem-initializations.patch
memblock-make-for_each_memblock_type-iterator-private.patch
memblock-make-memblock_debug-and-related-functionality-private.patch
memblock-reduce-number-of-parameters-in-for_each_mem_range.patch
arch-mm-replace-for_each_memblock-with-for_each_mem_pfn_range.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix-2.patch
x86-setup-simplify-initrd-relocation-and-reservation.patch
x86-setup-simplify-reserve_crashkernel.patch
memblock-remove-unused-memblock_mem_size.patch
memblock-implement-for_each_reserved_mem_region-using-__next_mem_region.patch
memblock-use-separate-iterators-for-memory-and-reserved-regions.patch
mm-add-definition-of-pmd_page_order.patch
mmap-make-mlock_future_check-global.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant.patch
mm-secretmem-use-pmd-size-pages-to-amortize-direct-map-fragmentation.patch

