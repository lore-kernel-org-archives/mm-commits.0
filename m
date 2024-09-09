Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E2B18E04F
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925233; cv=none; b=DBl5YMZc07hZd3lrja6tdwIafkXReWlD7pK1X5oO58Ut22ytJW3qeCyl/1G4okZ/uZyWaYHVHCR7NRU8mdPK4N6dqCFntQzu2EIAKE50pTBCmwzxzdIRl76wdF/iHkYn/g3O38+Dih34LbJs6igSFYu73QaYX1T9AJ8vim5Egqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925233; c=relaxed/simple;
	bh=dV9p23BQSwhrsIp29NSoCwRQ2ZuwdtLQgKMmRSbGO+E=;
	h=Date:To:From:Subject:Message-Id; b=BFJZNNBxWdaUQHuJfPAJnQ4RDewoQYMFS40A++gC8VPqFDAKisZFGZHbLM37n9Y5cHwRlZ/GqcOgSRAPt/W6lmoE3LeBf4PvroOg87MRzxtn+GyQrO9ku5TbFnsgJQFbGrA13gZ1DrSout3XCy80fn7K5JXAiIkgJ8cpx0sPgLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LY2drv2B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LY2drv2B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C825C4CEC6;
	Mon,  9 Sep 2024 23:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925233;
	bh=dV9p23BQSwhrsIp29NSoCwRQ2ZuwdtLQgKMmRSbGO+E=;
	h=Date:To:From:Subject:From;
	b=LY2drv2BBXbWjulojRdcr8PGx78bEe7ds5mb06NOKUfHahAw4VL0NYqk4IxzIFzIp
	 luSFS3T1niPhPEip9AJwO4oZfiLJ+1Yzd029+6UWDhL/QhrZlHT0YdZb5pVH5/kKSN
	 65n2G+IGEI/ycycbSBB9oIVz1zuVL8A9Ji9rUcYk=
Date: Mon, 09 Sep 2024 16:40:32 -0700
To: mm-commits@vger.kernel.org,kirill.shutemov@linux.intel.com,david@redhat.com,baolin.wang@linux.alibaba.com,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes.patch removed from -mm tree
Message-Id: <20240909234033.0C825C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: extend shmem_unused_huge_shrink() to all sizes
has been removed from the -mm tree.  Its filename was
     mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: shmem: extend shmem_unused_huge_shrink() to all sizes
Date: Sun, 25 Aug 2024 16:25:39 -0700 (PDT)

Although shmem_get_folio_gfp() is correctly putting inodes on the
shrinklist according to the folio size, shmem_unused_huge_shrink() was
still dealing with that shrinklist in terms of HPAGE_PMD_SIZE.

Generalize that; and to handle the mixture of sizes more sensibly,
shmem_alloc_and_add_folio() give it a number of pages to be freed
(approximate: no need to minimize that with an exact calculation) instead
of a number of inodes to split.

[akpm@linux-foundation.org: comment tweak, per David]
Link: https://lkml.kernel.org/r/d8c40850-6774-7a93-1e2c-8d941683b260@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   45 ++++++++++++++++++++-------------------------
 1 file changed, 20 insertions(+), 25 deletions(-)

--- a/mm/shmem.c~mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes
+++ a/mm/shmem.c
@@ -636,15 +636,14 @@ static const char *shmem_format_huge(int
 #endif
 
 static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
-		struct shrink_control *sc, unsigned long nr_to_split)
+		struct shrink_control *sc, unsigned long nr_to_free)
 {
 	LIST_HEAD(list), *pos, *next;
-	LIST_HEAD(to_remove);
 	struct inode *inode;
 	struct shmem_inode_info *info;
 	struct folio *folio;
 	unsigned long batch = sc ? sc->nr_to_scan : 128;
-	int split = 0;
+	unsigned long split = 0, freed = 0;
 
 	if (list_empty(&sbinfo->shrinklist))
 		return SHRINK_STOP;
@@ -662,13 +661,6 @@ static unsigned long shmem_unused_huge_s
 			goto next;
 		}
 
-		/* Check if there's anything to gain */
-		if (round_up(inode->i_size, PAGE_SIZE) ==
-				round_up(inode->i_size, HPAGE_PMD_SIZE)) {
-			list_move(&info->shrinklist, &to_remove);
-			goto next;
-		}
-
 		list_move(&info->shrinklist, &list);
 next:
 		sbinfo->shrinklist_len--;
@@ -677,34 +669,36 @@ next:
 	}
 	spin_unlock(&sbinfo->shrinklist_lock);
 
-	list_for_each_safe(pos, next, &to_remove) {
-		info = list_entry(pos, struct shmem_inode_info, shrinklist);
-		inode = &info->vfs_inode;
-		list_del_init(&info->shrinklist);
-		iput(inode);
-	}
-
 	list_for_each_safe(pos, next, &list) {
+		pgoff_t next, end;
+		loff_t i_size;
 		int ret;
-		pgoff_t index;
 
 		info = list_entry(pos, struct shmem_inode_info, shrinklist);
 		inode = &info->vfs_inode;
 
-		if (nr_to_split && split >= nr_to_split)
+		if (nr_to_free && freed >= nr_to_free)
 			goto move_back;
 
-		index = (inode->i_size & HPAGE_PMD_MASK) >> PAGE_SHIFT;
-		folio = filemap_get_folio(inode->i_mapping, index);
-		if (IS_ERR(folio))
+		i_size = i_size_read(inode);
+		folio = filemap_get_entry(inode->i_mapping, i_size / PAGE_SIZE);
+		if (!folio || xa_is_value(folio))
 			goto drop;
 
-		/* No huge page at the end of the file: nothing to split */
+		/* No large folio at the end of the file: nothing to split */
 		if (!folio_test_large(folio)) {
 			folio_put(folio);
 			goto drop;
 		}
 
+		/* Check if there is anything to gain from splitting */
+		next = folio_next_index(folio);
+		end = shmem_fallocend(inode, DIV_ROUND_UP(i_size, PAGE_SIZE));
+		if (end <= folio->index || end >= next) {
+			folio_put(folio);
+			goto drop;
+		}
+
 		/*
 		 * Move the inode on the list back to shrinklist if we failed
 		 * to lock the page at this time.
@@ -725,6 +719,7 @@ next:
 		if (ret)
 			goto move_back;
 
+		freed += next - end;
 		split++;
 drop:
 		list_del_init(&info->shrinklist);
@@ -769,7 +764,7 @@ static long shmem_unused_huge_count(stru
 #define shmem_huge SHMEM_HUGE_DENY
 
 static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
-		struct shrink_control *sc, unsigned long nr_to_split)
+		struct shrink_control *sc, unsigned long nr_to_free)
 {
 	return 0;
 }
@@ -1851,7 +1846,7 @@ allocated:
 		 * Try to reclaim some space by splitting a few
 		 * large folios beyond i_size on the filesystem.
 		 */
-		shmem_unused_huge_shrink(sbinfo, NULL, 2);
+		shmem_unused_huge_shrink(sbinfo, NULL, pages);
 		/*
 		 * And do a shmem_recalc_inode() to account for freed pages:
 		 * except our folio is there in cache, so not quite balanced.
_

Patches currently in -mm which might be from hughd@google.com are


