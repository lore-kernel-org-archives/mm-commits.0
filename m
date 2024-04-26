Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71BCE7D410
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104012; cv=none; b=PeXAoj6H7TOrWCVsfCoElMaPI7o4ZRD9k0gFHivP+Tjxna/RLqIHjI04U1Dm/AzjoQ1d8H+6PinFXNGmy2bYqT4PRKOmpU2Kj3p68IAFNF5a7Ojc56tcypigCpdzNNHR1xfidxTTID6D7tI2AXVIA4tTntYKX+x/uM2PLqZ4WxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104012; c=relaxed/simple;
	bh=QsXmFQ9VikKYxuPCMIegK/qjGQPmeU32D040H6MfbRw=;
	h=Date:To:From:Subject:Message-Id; b=Qx7IeU069GpMcRj/z6vQqcVCj19oVleiNas6LOV8anWysyR1lW3FAmS//f70yVqClMo3ab2s/0cXKso+pKkw2LTMEwPWvDupqPhw77kc91EFIbty6F31B1maXgVemRK83Gi2cTF7QMpiXVDE2TK5TWubXDDh78CD7N35ZolXYGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=13ueuKgV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="13ueuKgV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4703DC2BD11;
	Fri, 26 Apr 2024 04:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104012;
	bh=QsXmFQ9VikKYxuPCMIegK/qjGQPmeU32D040H6MfbRw=;
	h=Date:To:From:Subject:From;
	b=13ueuKgVIDGOAPJCgHeRVeijqcvy2Em43Ne/V6+1XwaNt3Pa4NSJfPXt3Wrbczp2v
	 s/l3oZt2tkfhahnsmssJ5sb3LwTEacKysC4PClimVCjO7Rmkkvf8IgD57b6bTGghDS
	 a2nza0EGRK0/+rR5YEOXiTs9KnJawWVscZNmY6bk=
Date: Thu, 25 Apr 2024 21:00:11 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sh-remove-use-of-pg_arch_1-on-individual-pages.patch removed from -mm tree
Message-Id: <20240426040012.4703DC2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sh: remove use of PG_arch_1 on individual pages
has been removed from the -mm tree.  Its filename was
     sh-remove-use-of-pg_arch_1-on-individual-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: sh: remove use of PG_arch_1 on individual pages
Date: Tue, 26 Mar 2024 17:10:23 +0000

Patch series "Various page->flags cleanups".

The first two patches are bug fixes, although I'm not sure that either
architecture will have noticed.  There aren't a lot of uses of page->flags
left!  The big build-up here is to reworking stable_page_flags(), which
will definitely be a user-visible change.  I think a welcome one, given
the special case we had to spread the Slab flag into all tail pages.


This patch (of 10):

Since switching to the new page table range API, we do not set the
PG_arch_1 (aka dcache clean) flag on tail pages, only on the folio.  Test
it on the folio.  Also use page_mapped() instead of page_mapcount() as it
is more efficient.

[akpm@linux-foundation.org: fix folio_flags call]
Link: https://lkml.kernel.org/r/20240326171045.410737-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20240326171045.410737-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/mm/cache-sh4.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/sh/mm/cache-sh4.c~sh-remove-use-of-pg_arch_1-on-individual-pages
+++ a/arch/sh/mm/cache-sh4.c
@@ -241,13 +241,14 @@ static void sh4_flush_cache_page(void *a
 	if ((vma->vm_mm == current->active_mm))
 		vaddr = NULL;
 	else {
+		struct folio *folio = page_folio(page);
 		/*
 		 * Use kmap_coherent or kmap_atomic to do flushes for
 		 * another ASID than the current one.
 		 */
 		map_coherent = (current_cpu_data.dcache.n_aliases &&
-			test_bit(PG_dcache_clean, &page->flags) &&
-			page_mapcount(page));
+			test_bit(PG_dcache_clean, folio_flags(folio, 0)) &&
+			page_mapped(page));
 		if (map_coherent)
 			vaddr = kmap_coherent(page, address);
 		else
_

Patches currently in -mm which might be from willy@infradead.org are

doc-improve-the-description-of-__folio_mark_dirty.patch
buffer-add-kernel-doc-for-block_dirty_folio.patch
buffer-add-kernel-doc-for-try_to_free_buffers.patch
buffer-fix-__bread-and-__bread_gfp-kernel-doc.patch
buffer-add-kernel-doc-for-brelse-and-__brelse.patch
buffer-add-kernel-doc-for-bforget-and-__bforget.patch
buffer-improve-bdev_getblk-documentation.patch
doc-split-bufferrst-out-of-api-summaryrst.patch
doc-split-bufferrst-out-of-api-summaryrst-fix.patch
mm-memory-failure-remove-fsdax_pgoff-argument-from-__add_to_kill.patch
mm-memory-failure-pass-addr-to-__add_to_kill.patch
mm-return-the-address-from-page_mapped_in_vma.patch
mm-make-page_mapped_in_vma-conditional-on-config_memory_failure.patch
mm-memory-failure-convert-shake_page-to-shake_folio.patch
mm-convert-hugetlb_page_mapping_lock_write-to-folio.patch
mm-memory-failure-convert-memory_failure-to-use-a-folio.patch
mm-memory-failure-convert-hwpoison_user_mappings-to-take-a-folio.patch
mm-memory-failure-add-some-folio-conversions-to-unpoison_memory.patch
mm-memory-failure-use-folio-functions-throughout-collect_procs.patch
mm-memory-failure-pass-the-folio-to-collect_procs_ksm.patch
fscrypt-convert-bh_get_inode_and_lblk_num-to-use-a-folio.patch
f2fs-convert-f2fs_clear_page_cache_dirty_tag-to-use-a-folio.patch
memory-failure-remove-calls-to-page_mapping.patch
migrate-expand-the-use-of-folio-in-__migrate_device_pages.patch
userfault-expand-folio-use-in-mfill_atomic_install_pte.patch
mm-remove-page_mapping.patch
mm-remove-page_cache_alloc.patch
mm-remove-put_devmap_managed_page.patch
mm-convert-put_devmap_managed_page_refs-to-put_devmap_managed_folio_refs.patch
mm-remove-page_ref_sub_return.patch
gup-use-folios-for-gup_devmap.patch
mm-add-kernel-doc-for-folio_mark_accessed.patch
mm-remove-pagereferenced.patch
mm-simplify-thp_vma_allowable_order.patch

