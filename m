Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ED12C2D0E4
	for <mm-commits@archiver.kernel.org>; Thu, 12 Nov 2020 22:14:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF4432222F
	for <mm-commits@archiver.kernel.org>; Thu, 12 Nov 2020 22:14:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="OU5neR15"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbgKLWO3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Nov 2020 17:14:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:55102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727214AbgKLWO1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Nov 2020 17:14:27 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CDB422201;
        Thu, 12 Nov 2020 22:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605219266;
        bh=RYFcS6j6L38/qxFkKhOcmS3W/W0xVdIYAba78ksJqDw=;
        h=Date:From:To:Subject:From;
        b=OU5neR15rfRSKxy16ZPIaLx63zrVWL6RgDzDyhUxo6j98vXRK+jx8SJXdmsBXOqlo
         aK/vMwcPMPms0Ogrtu6zGGOX0aFfJpw/MCOALVfEP3NY3i5MIXlBQqJfKcnVy11OTB
         07qSt62Thac1DSWMq/Ex7mUVF+B9uffHnK6JTZ7s=
Date:   Thu, 12 Nov 2020 14:14:24 -0800
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, bp@alien8.de, catalin.marinas@arm.com, cl@linux.com,
        dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        david@redhat.com, elena.reshetova@intel.com, hagen@jauu.net,
        hpa@zytor.com, jejb@linux.ibm.com, kirill@shutemov.name,
        luto@kernel.org, mark.rutland@arm.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, mtk.manpages@gmail.com,
        palmerdabbelt@google.com, paul.walmsley@sifive.com,
        peterz@infradead.org, rick.p.edgecombe@intel.com,
        rppt@linux.ibm.com, shuah@kernel.org, tglx@linutronix.de,
        tycho@tycho.ws, viro@zeniv.linux.org.uk, will@kernel.org,
        willy@infradead.org
Subject:  + secretmem-add-memcg-accounting.patch added to -mm tree
Message-ID: <20201112221424.jDwTCZHCH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: secretmem: add memcg accounting
has been added to the -mm tree.  Its filename is
     secretmem-add-memcg-accounting.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/secretmem-add-memcg-accounting.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/secretmem-add-memcg-accounting.patch

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
Subject: secretmem: add memcg accounting

Account memory consumed by secretmem to memcg.  The accounting is updated
when the memory is actually allocated and freed.

Link: https://lkml.kernel.org/r/20201110151444.20662-7-rppt@kernel.org
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
Cc: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Bottomley <jejb@linux.ibm.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Palmer Dabbelt <palmerdabbelt@google.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tycho Andersen <tycho@tycho.ws>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c   |    2 +-
 mm/secretmem.c |   42 +++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 42 insertions(+), 2 deletions(-)

--- a/mm/filemap.c~secretmem-add-memcg-accounting
+++ a/mm/filemap.c
@@ -844,7 +844,7 @@ static noinline int __add_to_page_cache_
 	page->mapping = mapping;
 	page->index = offset;
 
-	if (!huge) {
+	if (!huge && !page->memcg_data) {
 		error = mem_cgroup_charge(page, current->mm, gfp);
 		if (error)
 			goto error;
--- a/mm/secretmem.c~secretmem-add-memcg-accounting
+++ a/mm/secretmem.c
@@ -17,6 +17,7 @@
 #include <linux/syscalls.h>
 #include <linux/memblock.h>
 #include <linux/pseudo_fs.h>
+#include <linux/memcontrol.h>
 #include <linux/set_memory.h>
 #include <linux/sched/signal.h>
 
@@ -49,6 +50,38 @@ struct secretmem_ctx {
 
 static struct cma *secretmem_cma;
 
+static int secretmem_memcg_charge(struct page *page, gfp_t gfp, int order)
+{
+	unsigned long nr_pages = (1 << order);
+	int i, err;
+
+	err = memcg_kmem_charge_page(page, gfp, order);
+	if (err)
+		return err;
+
+	for (i = 1; i < nr_pages; i++) {
+		struct page *p = page + i;
+
+		p->memcg_data = page->memcg_data;
+	}
+
+	return 0;
+}
+
+static void secretmem_memcg_uncharge(struct page *page, int order)
+{
+	unsigned long nr_pages = (1 << order);
+	int i;
+
+	for (i = 1; i < nr_pages; i++) {
+		struct page *p = page + i;
+
+		p->memcg_data = 0;
+	}
+
+	memcg_kmem_uncharge_page(page, PMD_PAGE_ORDER);
+}
+
 static int secretmem_pool_increase(struct secretmem_ctx *ctx, gfp_t gfp)
 {
 	unsigned long nr_pages = (1 << PMD_PAGE_ORDER);
@@ -61,10 +94,14 @@ static int secretmem_pool_increase(struc
 	if (!page)
 		return -ENOMEM;
 
-	err = set_direct_map_invalid_noflush(page, nr_pages);
+	err = secretmem_memcg_charge(page, gfp, PMD_PAGE_ORDER);
 	if (err)
 		goto err_cma_release;
 
+	err = set_direct_map_invalid_noflush(page, nr_pages);
+	if (err)
+		goto err_memcg_uncharge;
+
 	addr = (unsigned long)page_address(page);
 	err = gen_pool_add(pool, addr, PMD_SIZE, NUMA_NO_NODE);
 	if (err)
@@ -81,6 +118,8 @@ err_set_direct_map:
 	 * won't fail
 	 */
 	set_direct_map_default_noflush(page, nr_pages);
+err_memcg_uncharge:
+	secretmem_memcg_uncharge(page, PMD_PAGE_ORDER);
 err_cma_release:
 	cma_release(secretmem_cma, page, nr_pages);
 	return err;
@@ -310,6 +349,7 @@ static void secretmem_cleanup_chunk(stru
 	int i;
 
 	set_direct_map_default_noflush(page, nr_pages);
+	secretmem_memcg_uncharge(page, PMD_PAGE_ORDER);
 
 	for (i = 0; i < nr_pages; i++)
 		clear_highpage(page + i);
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

alpha-switch-from-discontigmem-to-sparsemem.patch
ia64-remove-custom-__early_pfn_to_nid.patch
ia64-remove-ifdef-config_zone_dma32-statements.patch
ia64-discontig-paging_init-remove-local-max_pfn-calculation.patch
ia64-split-virtual-map-initialization-out-of-paging_init.patch
ia64-forbid-using-virtual_mem_map-with-flatmem.patch
ia64-make-sparsemem-default-and-disable-discontigmem.patch
arm-remove-config_arch_has_holes_memorymodel.patch
arm-arm64-move-free_unused_memmap-to-generic-mm.patch
arc-use-flatmem-with-freeing-of-unused-memory-map-instead-of-discontigmem.patch
m68k-mm-make-node-data-and-node-setup-depend-on-config_discontigmem.patch
m68k-mm-enable-use-of-generic-memory_modelh-for-discontigmem.patch
m68k-deprecate-discontigmem.patch
mm-introduce-debug_pagealloc_mapunmap_pages-helpers.patch
pm-hibernate-make-direct-map-manipulations-more-explicit.patch
arch-mm-restore-dependency-of-__kernel_map_pages-on-debug_pagealloc.patch
arch-mm-make-kernel_page_present-always-available.patch
mm-add-definition-of-pmd_page_order.patch
mmap-make-mlock_future_check-global.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
secretmem-use-pmd-size-pages-to-amortize-direct-map-fragmentation.patch
secretmem-add-memcg-accounting.patch
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch

