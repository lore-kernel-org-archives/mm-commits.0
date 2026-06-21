Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5793655DE
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067104; cv=none; b=QkWjMOG4lUV6f+3jH1+DrjqLj8KlaTcmoPwCzahtb3JNypJP9LcBZeV8BTssESCNKOXtqfm96EYmuygx9HJFhkWu98iGb+lj+2gSh5oUk8FfU5pRwW6hrjpRKkaXFCktpC51GFHi1Ol1VuthCRjkoy74SBQ0rcBDNBEw+dM8nfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067104; c=relaxed/simple;
	bh=8IHw47rW/5WI/83yAogy8PAKpS2qMeafEEqeHZEnK4w=;
	h=Date:To:From:Subject:Message-Id; b=kN1EwzSFe+JAdwGwerA4a3CIUK9dYhcmvdwO42KQct2mBXWv+bAQGRx2rzC8+kmdNQ4TuFn7KYKvLJZdJantuPaVGMajNaKG06WFM/tL6d3dD6w3WwiQ9ufo8RaUYhqtMKgW/oyJ6W0IRlUC9PTHu4c9QmmQaI/qdFgpn1Jhvwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uDxEOM1Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uDxEOM1Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B771F000E9;
	Sun, 21 Jun 2026 18:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067103;
	bh=heRw7druD7x/g3GzNgSninXf19d2ht/hu2HyXp82UEM=;
	h=Date:To:From:Subject;
	b=uDxEOM1Y/rolhwdNLG3vYG8PSleBwoMN8hS3ltYCSrKE502m54lPdL2nLC+TQJgiK
	 n7MpoW3FbSpofZAnUWx2HXie42BaZLVac5tNReR2zaY+iueHo4fFa4mw+lexh3bHaO
	 ZszjVp0F5b4Djz+kubZogii8dwVsj/HTGQl6igcg=
Date: Sun, 21 Jun 2026 11:38:23 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@kernel.org,surenb@google.com,songliubraving@fb.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jack@suse.cz,dsterba@suse.com,dev.jain@arm.com,david@kernel.org,clm@fb.com,brauner@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fs-remove-filemap_nr_thps-functions-and-their-users.patch removed from -mm tree
Message-Id: <20260621183823.67B771F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fs: remove filemap_nr_thps*() functions and their users
has been removed from the -mm tree.  Its filename was
     mm-fs-remove-filemap_nr_thps-functions-and-their-users.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm: fs: remove filemap_nr_thps*() functions and their users
Date: Sun, 17 May 2026 09:54:08 -0400

They are used by READ_ONLY_THP_FOR_FS to handle writes to FSes without
large folio support, so that read-only THPs created in these FSes are not
seen by the FSes when the underlying fd becomes writable.  Now read-only
PMD THPs only appear in a FS with large folio support and the supported
orders include PMD_ORDER.

READ_ONLY_THP_FOR_FS was using mapping->nr_thps, inode->i_writecount, and
smp_mb() to prevent writes to a read-only THP and collapsing writable
folios into a THP.  In collapse_file(), mapping->nr_thps is increased,
then smp_mb(), and if inode->i_writecount > 0, collapse is stopped, while
do_dentry_open() first increases inode->i_writecount, then a full memory
fence, and if mapping->nr_thps > 0, all read-only THPs are truncated.

Now this mechanism can be removed along with READ_ONLY_THP_FOR_FS code,
since a dirty folio check has been added after try_to_unmap() in
collapse_file() to prevent dirty folios from being collapsed as clean.

Link: https://lore.kernel.org/20260517135416.1434539-7-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/open.c               |   27 ---------------------------
 include/linux/pagemap.h |   29 -----------------------------
 mm/filemap.c            |    1 -
 mm/huge_memory.c        |    1 -
 mm/khugepaged.c         |   28 ----------------------------
 5 files changed, 86 deletions(-)

--- a/fs/open.c~mm-fs-remove-filemap_nr_thps-functions-and-their-users
+++ a/fs/open.c
@@ -968,33 +968,6 @@ static int do_dentry_open(struct file *f
 	if ((f->f_flags & O_DIRECT) && !(f->f_mode & FMODE_CAN_ODIRECT))
 		return -EINVAL;
 
-	/*
-	 * XXX: Huge page cache doesn't support writing yet. Drop all page
-	 * cache for this file before processing writes.
-	 */
-	if (f->f_mode & FMODE_WRITE) {
-		/*
-		 * Depends on full fence from get_write_access() to synchronize
-		 * against collapse_file() regarding i_writecount and nr_thps
-		 * updates. Ensures subsequent insertion of THPs into the page
-		 * cache will fail.
-		 */
-		if (filemap_nr_thps(inode->i_mapping)) {
-			struct address_space *mapping = inode->i_mapping;
-
-			filemap_invalidate_lock(inode->i_mapping);
-			/*
-			 * unmap_mapping_range just need to be called once
-			 * here, because the private pages is not need to be
-			 * unmapped mapping (e.g. data segment of dynamic
-			 * shared libraries here).
-			 */
-			unmap_mapping_range(mapping, 0, 0, 0);
-			truncate_inode_pages(mapping, 0);
-			filemap_invalidate_unlock(inode->i_mapping);
-		}
-	}
-
 	return 0;
 
 cleanup_all:
--- a/include/linux/pagemap.h~mm-fs-remove-filemap_nr_thps-functions-and-their-users
+++ a/include/linux/pagemap.h
@@ -546,35 +546,6 @@ static inline size_t mapping_max_folio_s
 	return PAGE_SIZE << mapping_max_folio_order(mapping);
 }
 
-static inline int filemap_nr_thps(const struct address_space *mapping)
-{
-#ifdef CONFIG_READ_ONLY_THP_FOR_FS
-	return atomic_read(&mapping->nr_thps);
-#else
-	return 0;
-#endif
-}
-
-static inline void filemap_nr_thps_inc(struct address_space *mapping)
-{
-#ifdef CONFIG_READ_ONLY_THP_FOR_FS
-	if (!mapping_large_folio_support(mapping))
-		atomic_inc(&mapping->nr_thps);
-#else
-	WARN_ON_ONCE(mapping_large_folio_support(mapping) == 0);
-#endif
-}
-
-static inline void filemap_nr_thps_dec(struct address_space *mapping)
-{
-#ifdef CONFIG_READ_ONLY_THP_FOR_FS
-	if (!mapping_large_folio_support(mapping))
-		atomic_dec(&mapping->nr_thps);
-#else
-	WARN_ON_ONCE(mapping_large_folio_support(mapping) == 0);
-#endif
-}
-
 struct address_space *folio_mapping(const struct folio *folio);
 
 /**
--- a/mm/filemap.c~mm-fs-remove-filemap_nr_thps-functions-and-their-users
+++ a/mm/filemap.c
@@ -189,7 +189,6 @@ static void filemap_unaccount_folio(stru
 			lruvec_stat_mod_folio(folio, NR_SHMEM_THPS, -nr);
 	} else if (folio_test_pmd_mappable(folio)) {
 		lruvec_stat_mod_folio(folio, NR_FILE_THPS, -nr);
-		filemap_nr_thps_dec(mapping);
 	}
 	if (test_bit(AS_KERNEL_FILE, &folio->mapping->flags))
 		mod_node_page_state(folio_pgdat(folio),
--- a/mm/huge_memory.c~mm-fs-remove-filemap_nr_thps-functions-and-their-users
+++ a/mm/huge_memory.c
@@ -3877,7 +3877,6 @@ static int __folio_freeze_and_split_unma
 				} else {
 					lruvec_stat_mod_folio(folio,
 							NR_FILE_THPS, -nr);
-					filemap_nr_thps_dec(mapping);
 				}
 			}
 		}
--- a/mm/khugepaged.c~mm-fs-remove-filemap_nr_thps-functions-and-their-users
+++ a/mm/khugepaged.c
@@ -2480,21 +2480,6 @@ out_unlock:
 		goto xa_unlocked;
 	}
 
-	if (!is_shmem) {
-		filemap_nr_thps_inc(mapping);
-		/*
-		 * Paired with the fence in do_dentry_open() -> get_write_access()
-		 * to ensure i_writecount is up to date and the update to nr_thps
-		 * is visible. Ensures the page cache will be truncated if the
-		 * file is opened writable.
-		 */
-		smp_mb();
-		if (inode_is_open_for_write(mapping->host)) {
-			result = SCAN_FAIL;
-			filemap_nr_thps_dec(mapping);
-		}
-	}
-
 xa_locked:
 	xas_unlock_irq(&xas);
 xa_unlocked:
@@ -2672,19 +2657,6 @@ rollback:
 		folio_putback_lru(folio);
 		folio_put(folio);
 	}
-	/*
-	 * Undo the updates of filemap_nr_thps_inc for non-SHMEM
-	 * file only. This undo is not needed unless failure is
-	 * due to SCAN_COPY_MC.
-	 */
-	if (!is_shmem && result == SCAN_COPY_MC) {
-		filemap_nr_thps_dec(mapping);
-		/*
-		 * Paired with the fence in do_dentry_open() -> get_write_access()
-		 * to ensure the update to nr_thps is visible.
-		 */
-		smp_mb();
-	}
 
 	new_folio->mapping = NULL;
 
_

Patches currently in -mm which might be from ziy@nvidia.com are


