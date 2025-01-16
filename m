Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A24D13D53B
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006494; cv=none; b=po6bX9KOH2V82tmBKgK2F58Il5TAoFZNYkziqmUreZ1Xpys57GDg0DWmY+TVPBgMIhC4UM+7PtLyBb1ajpsYuYbB1qeiZXsdVHb2ZxEWrV+hfXHtLSqE4ra03Q8E5TU1xatn3n0nqczYTPUGxnsbE4iuzPJk/9odxC3TXv4XQyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006494; c=relaxed/simple;
	bh=X/xhz2Czr+oo0lpMZbyrhpjAQpaB0e0q0HOWEIrc2M0=;
	h=Date:To:From:Subject:Message-Id; b=C7PsnlWmaqhscsqPyC9qRQ/Kl3L7m6r6JQ49Hs2NmAONGoAShKydL06xa5qzg1l/EgC2Hnj24sEWpl0dM/dN38TITpBZo/ZoCcv9/EpF6v2cQcn9HwkegJ7UMfITGk5VbmXFvyJqYB0rEJ/SzD66DDUwmEcT5VSkrhasPdYr9bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H/3ekVLr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H/3ekVLr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A6ACC4CED6;
	Thu, 16 Jan 2025 05:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006493;
	bh=X/xhz2Czr+oo0lpMZbyrhpjAQpaB0e0q0HOWEIrc2M0=;
	h=Date:To:From:Subject:From;
	b=H/3ekVLr5KA88X4bXU3p//D0QhjlmW9wwS6If2qNxsVxyO0zL3C+KawBlUBciSK1K
	 MJgg/dnCtXAbMgQi86YE20BzwqA51cnqEbja1ok3RYBHtO4gGz0eWu5k58EY2L2U0i
	 eS8kXy4PLsEePGVRnkodPyasxIX7eGrUvLrLqK4s=
Date: Wed, 15 Jan 2025 21:48:12 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] xarray-do-not-return-sibling-entries-from-xas_find_marked.patch removed from -mm tree
Message-Id: <20250116054813.1A6ACC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Xarray: do not return sibling entries from xas_find_marked()
has been removed from the -mm tree.  Its filename was
     xarray-do-not-return-sibling-entries-from-xas_find_marked.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: Xarray: do not return sibling entries from xas_find_marked()
Date: Fri, 13 Dec 2024 20:25:19 +0800

Patch series "Fixes and cleanups to xarray", v5.

This series contains some random fixes and cleanups to xarray.  Patch 1-2
are fixes and patch 3-6 are cleanups.  More details can be found in
respective patches.


This patch (of 5):

Similar to issue fixed in commit cbc02854331ed ("XArray: Do not return
sibling entries from xa_load()"), we may return sibling entries from
xas_find_marked as following:
    Thread A:               Thread B:
                            xa_store_range(xa, entry, 6, 7, gfp);
			    xa_set_mark(xa, 6, mark)
    XA_STATE(xas, xa, 6);
    xas_find_marked(&xas, 7, mark);
    offset = xas_find_chunk(xas, advance, mark);
    [offset is 6 which points to a valid entry]
                            xa_store_range(xa, entry, 4, 7, gfp);
    entry = xa_entry(xa, node, 6);
    [entry is a sibling of 4]
    if (!xa_is_node(entry))
        return entry;

Skip sibling entry like xas_find() does to protect caller from seeing
sibling entry from xas_find_marked() or caller may use sibling entry
as a valid entry and crash the kernel.

Besides, load_race() test is modified to catch mentioned issue and modified
load_race() only passes after this fix is merged.

Here is an example how this bug could be triggerred in tmpfs which
enables large folio in mapping:
Let's take a look at involved racer:
1. How pages could be created and dirtied in shmem file.
write
 ksys_write
  vfs_write
   new_sync_write
    shmem_file_write_iter
     generic_perform_write
      shmem_write_begin
       shmem_get_folio
        shmem_allowable_huge_orders
        shmem_alloc_and_add_folios
        shmem_alloc_folio
        __folio_set_locked
        shmem_add_to_page_cache
         XA_STATE_ORDER(..., index, order)
         xax_store()
      shmem_write_end
       folio_mark_dirty()

2. How dirty pages could be deleted in shmem file.
ioctl
 do_vfs_ioctl
  file_ioctl
   ioctl_preallocate
    vfs_fallocate
     shmem_fallocate
      shmem_truncate_range
       shmem_undo_range
        truncate_inode_folio
         filemap_remove_folio
          page_cache_delete
           xas_store(&xas, NULL);

3. How dirty pages could be lockless searched
sync_file_range
 ksys_sync_file_range
  __filemap_fdatawrite_range
   filemap_fdatawrite_wbc
    do_writepages
     writeback_use_writepage
      writeback_iter
       writeback_get_folio
        filemap_get_folios_tag
         find_get_entry
          folio = xas_find_marked()
          folio_try_get(folio)

Kernel will crash as following:
1.Create               2.Search             3.Delete
/* write page 2,3 */
write
 ...
  shmem_write_begin
   XA_STATE_ORDER(xas, i_pages, index = 2, order = 1)
   xa_store(&xas, folio)
  shmem_write_end
   folio_mark_dirty()

                       /* sync page 2 and page 3 */
                       sync_file_range
                        ...
                         find_get_entry
                          folio = xas_find_marked()
                          /* offset will be 2 */
                          offset = xas_find_chunk()

                                             /* delete page 2 and page 3 */
                                             ioctl
                                              ...
                                               xas_store(&xas, NULL);

/* write page 0-3 */
write
 ...
  shmem_write_begin
   XA_STATE_ORDER(xas, i_pages, index = 0, order = 2)
   xa_store(&xas, folio)
  shmem_write_end
   folio_mark_dirty(folio)

                          /* get sibling entry from offset 2 */
                          entry = xa_entry(.., 2)
                          /* use sibling entry as folio and crash kernel */
                          folio_try_get(folio)

Link: https://lkml.kernel.org/r/20241213122523.12764-1-shikemeng@huaweicloud.com
Link: https://lkml.kernel.org/r/20241213122523.12764-2-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Mattew Wilcox <willy@infradead.org> [English fixes]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xarray.c                          |    2 ++
 tools/testing/radix-tree/multiorder.c |    4 ++++
 2 files changed, 6 insertions(+)

--- a/lib/xarray.c~xarray-do-not-return-sibling-entries-from-xas_find_marked
+++ a/lib/xarray.c
@@ -1387,6 +1387,8 @@ void *xas_find_marked(struct xa_state *x
 		entry = xa_entry(xas->xa, xas->xa_node, xas->xa_offset);
 		if (!entry && !(xa_track_free(xas->xa) && mark == XA_FREE_MARK))
 			continue;
+		if (xa_is_sibling(entry))
+			continue;
 		if (!xa_is_node(entry))
 			return entry;
 		xas->xa_node = xa_to_node(entry);
--- a/tools/testing/radix-tree/multiorder.c~xarray-do-not-return-sibling-entries-from-xas_find_marked
+++ a/tools/testing/radix-tree/multiorder.c
@@ -227,6 +227,7 @@ static void *load_creator(void *ptr)
 			unsigned long index = (3 << RADIX_TREE_MAP_SHIFT) -
 						(1 << order);
 			item_insert_order(tree, index, order);
+			xa_set_mark(tree, index, XA_MARK_1);
 			item_delete_rcu(tree, index);
 		}
 	}
@@ -242,8 +243,11 @@ static void *load_worker(void *ptr)
 
 	rcu_register_thread();
 	while (!stop_iteration) {
+		unsigned long find_index = (2 << RADIX_TREE_MAP_SHIFT) + 1;
 		struct item *item = xa_load(ptr, index);
 		assert(!xa_is_internal(item));
+		item = xa_find(ptr, &find_index, index, XA_MARK_1);
+		assert(!xa_is_internal(item));
 	}
 	rcu_unregister_thread();
 
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


