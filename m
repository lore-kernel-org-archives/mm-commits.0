Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8CD7F465
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104073; cv=none; b=tcABGb0ctSyar+wAfcLy04k5EJL8AHRDcNcB3W/4QqeNZXOGWex0Xq4gjgB0HQZyq10Y9hP6NLxtP4HcEbBTe3DUR4Ri5D5re1Z6dHcq2bB/V498YWs2n4Z4YtLVcjpUsDjZ6J5m+bs0awoBPw62MMIhTJvoYoFHq+9r9kdGDyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104073; c=relaxed/simple;
	bh=vLnQtyaxPj+zvbfDvxxu0rUtBEETRQV+2aCZGPABd00=;
	h=Date:To:From:Subject:Message-Id; b=reID/K50PocZ/AgMnzNYLA5ssM1pzWvnQA4QSpgCjhkNvlXksVHCxIH+o6PloiTDYpampbfbFzzCE/KHU18jaaolpJgpdm5c8ZRAGSQpW1t/3aqmNQsSm7WL9f2wLsEMkqBs8naVhxM3NY6BhI3CjUamV4F2PRsja4Egu86Yz4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oJMKFl9n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oJMKFl9n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06246C113CD;
	Fri, 26 Apr 2024 04:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104073;
	bh=vLnQtyaxPj+zvbfDvxxu0rUtBEETRQV+2aCZGPABd00=;
	h=Date:To:From:Subject:From;
	b=oJMKFl9n6a63I0SZGZWJzE+5kJqSmsA5jOcP0zi6JAzl8jGve7jj0wXHNBsCMgZil
	 8y+dvR0gI29LMdSgARDKAluL+HJoHVRvzQawXO8wuTWFZiusyf2aQ5gdhFZJo+wx40
	 2BVZ6vTulUBkBuzmBz3LkAPW7Eqpvcl40t+NfM9Y=
Date: Thu, 25 Apr 2024 21:01:12 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-rwsem-assertion-macros-for-mmap_lock.patch removed from -mm tree
Message-Id: <20240426040113.06246C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use rwsem assertion macros for mmap_lock
has been removed from the -mm tree.  Its filename was
     mm-use-rwsem-assertion-macros-for-mmap_lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: use rwsem assertion macros for mmap_lock
Date: Wed, 27 Mar 2024 19:06:59 +0000

This slightly strengthens our write assertion when lockdep is disabled. 
It also downgrades us from BUG_ON to WARN_ON, but I think that's an
improvement.  I don't think dumping the mm_struct was all that valuable;
the call chain is what's important.

Link: https://lkml.kernel.org/r/20240327190701.1082560-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmap_lock.h |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/include/linux/mmap_lock.h~mm-use-rwsem-assertion-macros-for-mmap_lock
+++ a/include/linux/mmap_lock.h
@@ -60,16 +60,14 @@ static inline void __mmap_lock_trace_rel
 
 #endif /* CONFIG_TRACING */
 
-static inline void mmap_assert_locked(struct mm_struct *mm)
+static inline void mmap_assert_locked(const struct mm_struct *mm)
 {
-	lockdep_assert_held(&mm->mmap_lock);
-	VM_BUG_ON_MM(!rwsem_is_locked(&mm->mmap_lock), mm);
+	rwsem_assert_held(&mm->mmap_lock);
 }
 
-static inline void mmap_assert_write_locked(struct mm_struct *mm)
+static inline void mmap_assert_write_locked(const struct mm_struct *mm)
 {
-	lockdep_assert_held_write(&mm->mmap_lock);
-	VM_BUG_ON_MM(!rwsem_is_locked(&mm->mmap_lock), mm);
+	rwsem_assert_held_write(&mm->mmap_lock);
 }
 
 #ifdef CONFIG_PER_VMA_LOCK
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

