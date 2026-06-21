Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8187A3655DE
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067106; cv=none; b=Xb4OcL0Rq77qfE1pnjIdkBFIP/PNujVcuwJDTn/n1i2Ncl2t+LhDC/5hKrYMmhwHnAdf76PglxBMupL3ExuwibkFYbV7ddjkXTYCaBBM4mURQyNnn55sgRDsTbLkvdAVLm7EeeXqS1Z1Tqb6DsZ7/8SLDhs/xVEu6cztZwTk38U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067106; c=relaxed/simple;
	bh=/nLGSJYcSq6UtRowpELXoMxBYAz9NKtvp6pL4qJPH+M=;
	h=Date:To:From:Subject:Message-Id; b=bbkY+ZxWLH3y2d7MmR+Ug133z7A2SURIKL/B1P3p4q1MaB9S3BsxKZv1/O4c/JrvKaYBSPTGuPjc0yaHSTDnddQVogoNAtXj089LKLPyk5x4Enfh5kofA8x9fULHh5DokT7+gTW2BwjqKJYv85GUfh+5C4AOFpWFNWVDU+geMYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SPQsa207; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SPQsa207"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C1101F000E9;
	Sun, 21 Jun 2026 18:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067105;
	bh=yOhD3zTa8R8u8OJto7kW1POc7Z+AEeuP2+yqowqR+Ek=;
	h=Date:To:From:Subject;
	b=SPQsa207QbJjHO6y+UlZzWpQ0KGZkIW9DUPWdKGYhWrPvPj53gg7pUHlVvWun8wEG
	 jDS+ire2rVG92CWkfqqkXJtrW47OD94QrjiIskdzdBQgBPn7l3Sqzq1a1WzO8cApdK
	 gIIvwPCQZdd3Y70nlwYYj99gdMoMLJMDXStmvxuo=
Date: Sun, 21 Jun 2026 11:38:24 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@kernel.org,surenb@google.com,songliubraving@fb.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jack@suse.cz,dsterba@suse.com,dev.jain@arm.com,david@kernel.org,clm@fb.com,brauner@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-remove-nr_thps-from-struct-address_space.patch removed from -mm tree
Message-Id: <20260621183825.0C1101F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs: remove nr_thps from struct address_space
has been removed from the -mm tree.  Its filename was
     fs-remove-nr_thps-from-struct-address_space.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: fs: remove nr_thps from struct address_space
Date: Sun, 17 May 2026 09:54:09 -0400

filemap_nr_thps*() are removed, the related field, address_space->nr_thps,
is no longer needed.  Remove it.  This shrinks struct address_space by 8
bytes on 64-bit systems which may increase the number of inodes we can
cache.

Link: https://lore.kernel.org/20260517135416.1434539-8-ziy@nvidia.com
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


