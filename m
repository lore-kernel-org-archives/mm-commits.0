Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683BE2F4A
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 18:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711477828; cv=none; b=Qim8qZpPN03hqcCaTaqWdOiNrIb93RukkOovVjWnyBe0KBi+PALYC8bp4wuXDK+FkJQA+3KO5pkQIsfqIKu3AWQp9D5gQNh7aAH0okExBEBg6emp6wl/rRI2twhc91kclLSv/PveXcceNVqYRyU93LWnAHiNAVSOxbfCiZHiya8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711477828; c=relaxed/simple;
	bh=5EEq6eR4Uru4rxARa9WHTSDdkiUcA4At5o9NJ2G0ppc=;
	h=Date:To:From:Subject:Message-Id; b=p1opoHpwe3pf1BnI2+r+wup0Wsac3va0xmPPc0zKLBKiaZcVzDgkybia6KnEhMrlG039rV1PKHCgRT6f4Q70DgiGPJgNgqjgMHwSdMUhiGCTHY4beSHE08So8/4HxINZgzHmeY6Fc3YOZMLTZweF0vfP3VZ1ZDEF40XM1YFgQ48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HXIsrNxX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HXIsrNxX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AAD1C43390;
	Tue, 26 Mar 2024 18:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711477828;
	bh=5EEq6eR4Uru4rxARa9WHTSDdkiUcA4At5o9NJ2G0ppc=;
	h=Date:To:From:Subject:From;
	b=HXIsrNxXNEuHW5+U07KG/FwW6TUg7/+ZpYm/ehwxU9DFSFGXwf6pbVAuXngt9SEZT
	 /RfZc3oLdD55Irl5F2I2bPf9X3LPCZ5qtYZkz7O29M0jW1/rg5w8f9xn8zzamhwP4X
	 wMh8BzavDNVtKXFjrqQPUvlXZ22TTnMdSa0hNFXA=
Date: Tue, 26 Mar 2024 11:30:27 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + remove-references-to-page-flags-in-documentation.patch added to mm-unstable branch
Message-Id: <20240326183028.3AAD1C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: remove references to page->flags in documentation
has been added to the -mm mm-unstable branch.  Its filename is
     remove-references-to-page-flags-in-documentation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/remove-references-to-page-flags-in-documentation.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: remove references to page->flags in documentation
Date: Tue, 26 Mar 2024 17:10:31 +0000

Mostly rewording, but remove entirely the copy of page_fixed_fake_head()
in the documentation; we can refer people to the actual source if
necessary.

Link: https://lkml.kernel.org/r/20240326171045.410737-10-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v1/memory.rst         |    4 -
 Documentation/mm/vmemmap_dedup.rst                     |   22 ----------
 Documentation/translations/zh_CN/core-api/cachetlb.rst |    2 
 mm/migrate.c                                           |    2 
 mm/rmap.c                                              |    4 -
 5 files changed, 7 insertions(+), 27 deletions(-)

--- a/Documentation/admin-guide/cgroup-v1/memory.rst~remove-references-to-page-flags-in-documentation
+++ a/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -300,14 +300,14 @@ When oom event notifier is registered, e
 
 Lock order is as follows::
 
-  Page lock (PG_locked bit of page->flags)
+  folio_lock
     mm->page_table_lock or split pte_lock
       folio_memcg_lock (memcg->move_lock)
         mapping->i_pages lock
           lruvec->lru_lock.
 
 Per-node-per-memcgroup LRU (cgroup's private LRU) is guarded by
-lruvec->lru_lock; PG_lru bit of page->flags is cleared before
+lruvec->lru_lock; the folio LRU flag is cleared before
 isolating a page from its LRU under lruvec->lru_lock.
 
 .. _cgroup-v1-memory-kernel-extension:
--- a/Documentation/mm/vmemmap_dedup.rst~remove-references-to-page-flags-in-documentation
+++ a/Documentation/mm/vmemmap_dedup.rst
@@ -180,27 +180,7 @@ this correctly. There is only **one** he
 ``struct page`` with ``PG_head`` are fake head ``struct page``.  We need an
 approach to distinguish between those two different types of ``struct page`` so
 that ``compound_head()`` can return the real head ``struct page`` when the
-parameter is the tail ``struct page`` but with ``PG_head``. The following code
-snippet describes how to distinguish between real and fake head ``struct page``.
-
-.. code-block:: c
-
-	if (test_bit(PG_head, &page->flags)) {
-		unsigned long head = READ_ONCE(page[1].compound_head);
-
-		if (head & 1) {
-			if (head == (unsigned long)page + 1)
-				/* head struct page */
-			else
-				/* tail struct page */
-		} else {
-			/* head struct page */
-		}
-	}
-
-We can safely access the field of the **page[1]** with ``PG_head`` because the
-page is a compound page composed with at least two contiguous pages.
-The implementation refers to ``page_fixed_fake_head()``.
+parameter is the tail ``struct page`` but with ``PG_head``.
 
 Device DAX
 ==========
--- a/Documentation/translations/zh_CN/core-api/cachetlb.rst~remove-references-to-page-flags-in-documentation
+++ a/Documentation/translations/zh_CN/core-api/cachetlb.rst
@@ -260,7 +260,7 @@ 问题有可能存在，因为内核已�
 	如果D-cache别名不是一个问题，这个程序可以简单地定义为该架构上
 	的nop。
 
-	在page->flags (PG_arch_1)中有一个位是“架构私有”。内核保证，
+	在folio->flags (PG_arch_1)中有一个位是“架构私有”。内核保证，
 	对于分页缓存的页面，当这样的页面第一次进入分页缓存时，它将清除
 	这个位。
 
--- a/mm/migrate.c~remove-references-to-page-flags-in-documentation
+++ a/mm/migrate.c
@@ -113,7 +113,7 @@ bool isolate_movable_page(struct page *p
 	if (!mops->isolate_page(&folio->page, mode))
 		goto out_no_isolated;
 
-	/* Driver shouldn't use PG_isolated bit of page->flags */
+	/* Driver shouldn't use the isolated flag */
 	WARN_ON_ONCE(folio_test_isolated(folio));
 	folio_set_isolated(folio);
 	folio_unlock(folio);
--- a/mm/rmap.c~remove-references-to-page-flags-in-documentation
+++ a/mm/rmap.c
@@ -23,7 +23,7 @@
  * inode->i_rwsem	(while writing or truncating, not reading or faulting)
  *   mm->mmap_lock
  *     mapping->invalidate_lock (in filemap_fault)
- *       page->flags PG_locked (lock_page)
+ *       folio_lock
  *         hugetlbfs_i_mmap_rwsem_key (in huge_pmd_share, see hugetlbfs below)
  *           vma_start_write
  *             mapping->i_mmap_rwsem
@@ -50,7 +50,7 @@
  *   hugetlb_fault_mutex (hugetlbfs specific page fault mutex)
  *     vma_lock (hugetlb specific lock for pmd_sharing)
  *       mapping->i_mmap_rwsem (also used for hugetlb pmd sharing)
- *         page->flags PG_locked (lock_page)
+ *         folio_lock
  */
 
 #include <linux/mm.h>
_

Patches currently in -mm which might be from willy@infradead.org are

mm-always-initialise-folio-_deferred_list.patch
mm-create-folio_flag_false-and-folio_type_ops-macros.patch
mm-remove-folio_prep_large_rmappable.patch
mm-support-page_mapcount-on-page_has_type-pages.patch
mm-turn-folio_test_hugetlb-into-a-pagetype.patch
mm-turn-folio_test_hugetlb-into-a-pagetype-fix.patch
mm-remove-a-call-to-compound_head-from-is_page_hwpoison.patch
mm-free-up-pg_slab.patch
mm-free-up-pg_slab-fix.patch
mm-improve-dumping-of-mapcount-and-page_type.patch
hugetlb-remove-mention-of-destructors.patch
sh-remove-use-of-pg_arch_1-on-individual-pages.patch
xtensa-remove-uses-of-pg_arch_1-on-individual-pages.patch
mm-make-page_ext_get-take-a-const-argument.patch
mm-make-folio_test_idle-and-folio_test_young-take-a-const-argument.patch
mm-make-is_free_buddy_page-take-a-const-argument.patch
mm-make-page_mapped-take-a-const-argument.patch
mm-convert-arch_clear_hugepage_flags-to-take-a-folio.patch
slub-remove-use-of-page-flags.patch
remove-references-to-page-flags-in-documentation.patch
proc-rewrite-stable_page_flags.patch

