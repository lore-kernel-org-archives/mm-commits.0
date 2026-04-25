Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894E337FF73
	for <mm-commits@vger.kernel.org>; Sat, 25 Apr 2026 22:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777154822; cv=none; b=urtNMoeWr7u0tTsoVZZ6VMICDjr61AonIK26DdWQCDdo7ATykiADPX2guTUo5lX/IIpPXNBTAIB1ODILFwE+sYJ9hzuBnVCjcIq/G04x+mYG8Dj9vsSS3jAGVCqXezdTBURWqDlOsREgK/UkLbaHwA+1cQDebVhcLiSuZvjfpA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777154822; c=relaxed/simple;
	bh=AInOq9zVvXa9aZty4284b/ZXA2TQ2klkvXS4UrEwupc=;
	h=Date:To:From:Subject:Message-Id; b=IWvGoHiUnlp+3a91/f9/0I5rKYSbMwQSJ9PBJnhUqOJpUnAmW3/v3pV7wWdFXzW5KXJ6L1GObWpVXgHZXdViQsUp8Shu7gfvgRzO1UpeIaPzDqY+QCy+OzdvstC2h7aW81PFlwaLdnJjGULYodWcVvSqmXQVv6W//uzd07clFs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cI6jsV9S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cI6jsV9S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 577FBC2BCB0;
	Sat, 25 Apr 2026 22:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777154822;
	bh=AInOq9zVvXa9aZty4284b/ZXA2TQ2klkvXS4UrEwupc=;
	h=Date:To:From:Subject:From;
	b=cI6jsV9S8krMFPVrqSvsZUQEQE9yug08446d4b5f8Yawjx3ZgVPXbQoAlyN7be7eC
	 FKbkI4L1banFBzcwDc2bF+nYEAvsT/Aqs+MvltYW2XuU9qZ0bCdxazNHoeTgSsvpTC
	 LMme+p9B/786yaPBUdX+SOf3XujjoMyveF39wih4=
Date: Sat, 25 Apr 2026 15:07:01 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] fs-remove-nr_thps-from-struct-address_space.patch removed from -mm tree
Message-Id: <20260425220702.577FBC2BCB0@smtp.kernel.org>
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
Date: Thu, 23 Apr 2026 22:49:10 -0400

filemap_nr_thps*() are removed, the related field, address_space->nr_thps,
is no longer needed.  Remove it.  This shrinks struct address_space by 8
bytes on 64-bit systems which may increase the number of inodes we can
cache.

Link: https://lore.kernel.org/20260424024915.28758-8-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
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
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Suren Baghdasaryan <surenb@google.com>
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
selftests-mm-remove-read_only_thp_for_fs-code-from-guard-regions.patch

