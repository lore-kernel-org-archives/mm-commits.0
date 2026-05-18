Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8074E30C35E
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 21:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779141571; cv=none; b=Z/Kl7s2wTM3QiChYFzBt0vYEzHmrJCeKYhImwSIRbY/1uSG0I/xlfVIrtY2yIsmT0ctyPt6s9BAXa2m7QxoLqH2jaXJLzQC7bJSkntRTblstdyQ4AcleZ30p6WVNhdxHVk0X54+cKbHV/Eim3U79GqfGZbeNh01dl1eBPX1Igwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779141571; c=relaxed/simple;
	bh=3NmfbrIaNJOG11g18P9TQxDDnI6EBhz7VPX91Ny2lB8=;
	h=Date:To:From:Subject:Message-Id; b=eWk7kHoNv1Ym43jMx+/fvcgPzNho5bDaijYv1gDyzFTXEBZmYjAn1yxJAq+QR2xfJRuoCkchKDq/uFhNgUVfaE0ee45y7Lg6cfd0YbR2ZhBlXP292NYRlLpmUZgEIiB5euICsPc2DaJLopYPDce/2jlAccpkKXt0LIpTtnohnjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kMLt8Oml; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kMLt8Oml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50724C2BCB7;
	Mon, 18 May 2026 21:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779141571;
	bh=3NmfbrIaNJOG11g18P9TQxDDnI6EBhz7VPX91Ny2lB8=;
	h=Date:To:From:Subject:From;
	b=kMLt8Omlw6edkYsrYwXX8u1NZ8xfidi7mLpZvmDPHgyQ85oet97ZGgSvSthRWkXJE
	 IB7gNqkXYgYWXhUtf/MZbW6DdlM+GO5gjfNMkl0cYYFSJjh51s2xa+2OJel/PwXljx
	 NddYI/7P2O/mRrgNPBmf7wTsjX3d/qXZNNO3WsBk=
Date: Mon, 18 May 2026 14:59:30 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] fs-remove-nr_thps-from-struct-address_space.patch removed from -mm tree
Message-Id: <20260518215931.50724C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs: remove nr_thps from struct address_space
has been removed from the -mm tree.  Its filename was
     fs-remove-nr_thps-from-struct-address_space.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: fs: remove nr_thps from struct address_space
Date: Wed, 29 Apr 2026 11:35:30 -0400

filemap_nr_thps*() are removed, the related field, address_space->nr_thps,
is no longer needed.  Remove it.  This shrinks struct address_space by 8
bytes on 64-bit systems which may increase the number of inodes we can
cache.

Link: https://lore.kernel.org/20260429153538.727855-3-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Nico Pache <npache@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Liam Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c         |    3 ---
 include/linux/fs.h |    5 -----
 2 files changed, 8 deletions(-)

--- a/fs/inode.c~fs-remove-nr_thps-from-struct-address_space
+++ a/fs/inode.c
@@ -279,9 +279,6 @@ int inode_init_always_gfp(struct super_b
 	mapping->flags = 0;
 	mapping->wb_err = 0;
 	atomic_set(&mapping->i_mmap_writable, 0);
-#ifdef CONFIG_READ_ONLY_THP_FOR_FS
-	atomic_set(&mapping->nr_thps, 0);
-#endif
 	mapping_set_gfp_mask(mapping, GFP_HIGHUSER_MOVABLE);
 	mapping->writeback_index = 0;
 	init_rwsem(&mapping->invalidate_lock);
--- a/include/linux/fs.h~fs-remove-nr_thps-from-struct-address_space
+++ a/include/linux/fs.h
@@ -460,7 +460,6 @@ struct mapping_metadata_bhs {
  *   memory mappings.
  * @gfp_mask: Memory allocation flags to use for allocating pages.
  * @i_mmap_writable: Number of VM_SHARED, VM_MAYWRITE mappings.
- * @nr_thps: Number of THPs in the pagecache (non-shmem only).
  * @i_mmap: Tree of private and shared mappings.
  * @i_mmap_rwsem: Protects @i_mmap and @i_mmap_writable.
  * @nrpages: Number of page entries, protected by the i_pages lock.
@@ -476,10 +475,6 @@ struct address_space {
 	struct rw_semaphore	invalidate_lock;
 	gfp_t			gfp_mask;
 	atomic_t		i_mmap_writable;
-#ifdef CONFIG_READ_ONLY_THP_FOR_FS
-	/* number of thp, only for non-shmem files */
-	atomic_t		nr_thps;
-#endif
 	struct rb_root_cached	i_mmap;
 	unsigned long		nrpages;
 	pgoff_t			writeback_index;
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-huge_memory-remove-folio-split-check-for-read_only_thp_for_fs.patch
mm-truncate-use-folio_split-in-truncate_inode_partial_folio.patch
fs-btrfs-remove-a-comment-referring-to-read_only_thp_for_fs.patch
selftests-mm-remove-read_only_thp_for_fs-in-khugepaged.patch
selftests-mm-remove-read_only_thp_for_fs-in-khugepaged-fix.patch
selftests-mm-remove-read_only_thp_for_fs-in-khugepaged-fix-2.patch
selftests-mm-remove-read_only_thp_for_fs-code-from-guard-regions.patch
mm-khugepaged-enable-clean-pagecache-folio-collapse-for-writable-files.patch
selftests-mm-add-writable-file-collapse-tests-for-khugepaged.patch

