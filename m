Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C299141D22B
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525591; cv=none; b=U6IQoOLqmGtJbIOe9zVcenB44g8bY81LVmD0uENzr2jiYlv0xawZRkhCzQtZN9JVhR6SBhrYrTFj/TnzIrrcW9dFJb0IsnzO/te6ehAqGU6ulbTXignHK3NLmcZNkK/s+JfhooMWmYmjqyuQeYtXtxUCGs6gToeeidvylfhtxlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525591; c=relaxed/simple;
	bh=GWw9YVFdbbB9LVBJR8IW5SIQBNwbCAJ6L6IIuQEp0EQ=;
	h=Date:To:From:Subject:Message-Id; b=Aj5NVikNDhPjU1tYBverdyo79/smYUtRG9iuRGsYLzSlZirG4iuaXWdV6VwpNDiGZpkcJLsIGYljQCaUlQRsqwrCQ6OWkwBd0J6XHJi3AH981jQ+kuml9IAHcGB8uVzedMwNzdKoelpIUoi834OCVwxcQgkCkLhHiPVMzwQxpmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kA7GnKjl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kA7GnKjl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C3E1F00899;
	Fri,  9 Oct 2026 05:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525589;
	bh=SiL1scSdH9NQGRHfuMpTbMuKXkO5i+6rakn21s/byMQ=;
	h=Date:To:From:Subject;
	b=kA7GnKjluwxt/XSkOHUsxNo1tXLEuLuRlURRDBGZeoRw8SAfaRSn0k6EAcDQlxNyi
	 f9pkgwoWjHYXX0OGaYKdHRY2gi/IIj0o5U6Va/+CzDDbLFT8288D3SedSB7bkXeCKT
	 yV7UM5qNjiX6QYgmGtX1NRst4nmpPsJtY3ts9rP4=
Date: Thu, 08 Oct 2026 22:59:48 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,trondmy@kernel.org,surenb@google.com,slava@dubeyko.com,rppt@kernel.org,richard@nod.at,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,idryomov@gmail.com,david@kernel.org,chengzhihao1@huawei.com,anna@kernel.org,amarkuze@redhat.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] treewide-remove-pageprivate-and-pg_private-from-comments-and-docs.patch removed from -mm tree
Message-Id: <20261009055949.13C3E1F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: treewide: remove PagePrivate() and PG_private from comments and docs
has been removed from the -mm tree.  Its filename was
     treewide-remove-pageprivate-and-pg_private-from-comments-and-docs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: treewide: remove PagePrivate() and PG_private from comments and docs
Date: Sun, 20 Sep 2026 22:28:12 -0400

PG_private and PagePrivate() are no longer used. Adjust related comments
and documentations to refer to page/folio->private instead.

hugetlbfs_reserv.rst is outdated and left unchanged. It should be
rewritten.

Link: https://lore.kernel.org/20260920-remove-pg_private-v5-16-bb68b6a21869@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: LLM
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Alex Markuze <amarkuze@redhat.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: Trond Myklebust <trondmy@kernel.org>
Cc: Anna Schumaker <anna@kernel.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Zhihao Cheng <chengzhihao1@huawei.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
---

 Documentation/admin-guide/kdump/vmcoreinfo.rst |    2 +-
 Documentation/filesystems/vfs.rst              |    6 +++---
 fs/nfs/file.c                                  |    4 ++--
 fs/ubifs/file.c                                |    8 ++++----
 include/linux/mm.h                             |   15 ++++++++-------
 include/linux/mm_types.h                       |    4 ++--
 6 files changed, 20 insertions(+), 19 deletions(-)

--- a/Documentation/admin-guide/kdump/vmcoreinfo.rst~treewide-remove-pageprivate-and-pg_private-from-comments-and-docs
+++ a/Documentation/admin-guide/kdump/vmcoreinfo.rst
@@ -325,7 +325,7 @@ NR_FREE_PAGES
 On linux-2.6.21 or later, the number of free pages is in
 vm_stat[NR_FREE_PAGES]. Used to get the number of free pages.
 
-PG_lru|PG_private|PG_swapcache|PG_swapbacked|PG_hwpoison|PG_head_mask
+PG_lru|PG_swapcache|PG_swapbacked|PG_hwpoison|PG_head_mask
 --------------------------------------------------------------------------
 
 Page attributes. These flags are used to filter various unnecessary for
--- a/Documentation/filesystems/vfs.rst~treewide-remove-pageprivate-and-pg_private-from-comments-and-docs
+++ a/Documentation/filesystems/vfs.rst
@@ -649,8 +649,8 @@ Writeback.
 
 The first can be used independently to the others.  The VM can try to
 release clean pages in order to reuse them.  To do this it can call
-->release_folio on clean folios with the private
-flag set.  Clean pages without PagePrivate and with no external references
+->release_folio on clean folios with folio->private set. Clean pages
+without folio->private set and with no external references
 will be released without notice being given to the address_space.
 
 To achieve this functionality, pages need to be placed on an LRU with
@@ -674,7 +674,7 @@ filemap_fdatawait_range, to wait for all
 
 An address_space handler may attach extra information to a page,
 typically using the 'private' field in the 'struct page'.  If such
-information is attached, the PG_Private flag should be set.  This will
+information is attached, non-NULL 'private' field will
 cause various VM routines to make extra calls into the address_space
 handler to deal with that data.
 
--- a/fs/nfs/file.c~treewide-remove-pageprivate-and-pg_private-from-comments-and-docs
+++ a/fs/nfs/file.c
@@ -484,7 +484,7 @@ static int nfs_write_end(const struct ki
  * Partially or wholly invalidate a page
  * - Release the private state associated with a page if undergoing complete
  *   page invalidation
- * - Called if either PG_private or PG_fscache is set on the page
+ * - Called if either folio->private or PG_fscache is set on the page
  * - Caller holds page lock
  */
 static void nfs_invalidate_folio(struct folio *folio, size_t offset,
@@ -555,7 +555,7 @@ static void nfs_check_dirty_writeback(st
  * Attempt to clear the private state associated with a page when an error
  * occurs that requires the cached contents of an inode to be written back or
  * destroyed
- * - Called if either PG_private or fscache is set on the page
+ * - Called if either page->private or fscache is set on the page
  * - Caller holds page lock
  * - Return 0 if successful, -error otherwise
  */
--- a/fs/ubifs/file.c~treewide-remove-pageprivate-and-pg_private-from-comments-and-docs
+++ a/fs/ubifs/file.c
@@ -12,14 +12,14 @@
  * This file implements VFS file and inode operations for regular files, device
  * nodes and symlinks as well as address space operations.
  *
- * UBIFS uses 2 page flags: @PG_private and @PG_checked. @PG_private is set if
+ * UBIFS uses folio->private and page flag @PG_checked. folio->private is set if
  * the page is dirty and is used for optimization purposes - dirty pages are
- * not budgeted so the flag shows that 'ubifs_write_end()' should not release
+ * not budgeted so it shows that 'ubifs_write_end()' should not release
  * the budget for this page. The @PG_checked flag is set if full budgeting is
  * required for the page e.g., when it corresponds to a file hole or it is
  * beyond the file size. The budgeting is done in 'ubifs_write_begin()', because
  * it is OK to fail in this function, and the budget is released in
- * 'ubifs_write_end()'. So the @PG_private and @PG_checked flags carry
+ * 'ubifs_write_end()'. So the folio->private and the @PG_checked flag carry
  * information about how the page was budgeted, to make it possible to release
  * the budget properly.
  *
@@ -1509,7 +1509,7 @@ static vm_fault_t ubifs_vm_page_mkwrite(
 	 *
 	 * At the moment we do not know whether the folio is dirty or not, so we
 	 * assume that it is not and budget for a new folio. We could look at
-	 * the @PG_private flag and figure this out, but we may race with write
+	 * folio->private and figure this out, but we may race with write
 	 * back and the folio state may change by the time we lock it, so this
 	 * would need additional care. We do not bother with this at the
 	 * moment, although it might be good idea to do. Instead, we allocate
--- a/include/linux/mm.h~treewide-remove-pageprivate-and-pg_private-from-comments-and-docs
+++ a/include/linux/mm.h
@@ -2049,20 +2049,21 @@ vm_fault_t finish_fault(struct vm_fault
  *
  * A pagecache page contains an opaque `private' member, which belongs to the
  * page's address_space. Usually, this is the address of a circular list of
- * the page's disk buffers. PG_private must be set to tell the VM to call
- * into the filesystem to release these pages.
+ * the page's disk buffers. It tells the VM to call into the filesystem to
+ * release these pages.
  *
  * A folio may belong to an inode's memory mapping. In this case,
  * folio->mapping points to the inode, and folio->index is the file
  * offset of the folio, in units of PAGE_SIZE.
  *
- * If pagecache pages are not associated with an inode, they are said to be
- * anonymous pages. These may become associated with the swapcache, and in that
- * case PG_swapcache is set, and page->private is an offset into the swapcache.
+ * If pagecache folios are not associated with an inode, they are said to be
+ * anonymous folios. These may become associated with the swapcache, and in that
+ * case PG_swapcache is set, and folio->private is an offset into the swapcache.
  *
  * In either case (swapcache or inode backed), the pagecache itself holds one
- * reference to the page. Setting PG_private should also increment the
- * refcount. The each user mapping also has a reference to the page.
+ * reference to the folio. Attaching filesystem private data via
+ * folio_attach_private() also increments the refcount. Each user mapping also
+ * has a reference to the folio.
  *
  * The pagecache pages are stored in a per-mapping radix tree, which is
  * rooted at mapping->i_pages, and indexed by offset.
--- a/include/linux/mm_types.h~treewide-remove-pageprivate-and-pg_private-from-comments-and-docs
+++ a/include/linux/mm_types.h
@@ -108,7 +108,7 @@ struct page {
 			};
 			/**
 			 * @private: Mapping-private opaque data.
-			 * Usually used for buffer_heads if PagePrivate.
+			 * Usually used for buffer_heads.
 			 * Used for swp_entry_t if swapcache flag set.
 			 * Indicates order in the buddy system if PageBuddy
 			 * or on pcp_llist.
@@ -675,7 +675,7 @@ static inline void ptdesc_pmd_pts_init(s
 #define STRUCT_PAGE_MAX_SHIFT	(order_base_2(sizeof(struct page)))
 
 /*
- * page_private can be used on tail pages.  However, PagePrivate is only
+ * page_private can be used on tail pages.  However, it is only
  * checked by the VM on the head page.  So page_private on the tail pages
  * should be used for data that's ancillary to the head page (eg attaching
  * buffer heads to tail pages after attaching buffer heads to the head page)
_

Patches currently in -mm which might be from ziy@nvidia.com are


