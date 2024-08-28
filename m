Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2FDE225D6
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 02:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724811463; cv=none; b=hLSpgabeXgAtHGbmUnFhI5LG9Ftupl5koeTZg2YZcqSugUA9YJvUFo4tBNBQKyhyKkzRuSFGJMt9FexspLEMTx+kY9ZJCZXxGnZkd3Os0MQfr2pGjWN1STLyZiO629oQmPtjjCYMNF68H0da/5xPI2Zn9WrTxw2zSKxSFpx/grI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724811463; c=relaxed/simple;
	bh=3+BVoz/PpqutgNAQHMJBs1XA4YQ1faHOm2OZQHmx5n8=;
	h=Date:To:From:Subject:Message-Id; b=h0gyOo5jgv4sIxsYCSEWN2uAJQnUctExKGUVyKLzRykKHwqx11eGCdxE2Sl++gXx7sFoD4CjKJg9sHg0MI5FHcvJ+xMioPqJwATH/YJBROA1Dl3Q5bxkA2YWQWSuQf13ta8+QuIG9NcmkDNX03EFWLmkgz6ZBzHM62uQWHhtfhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QiQJ5Z4x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QiQJ5Z4x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587EDC4DE14;
	Wed, 28 Aug 2024 02:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724811462;
	bh=3+BVoz/PpqutgNAQHMJBs1XA4YQ1faHOm2OZQHmx5n8=;
	h=Date:To:From:Subject:From;
	b=QiQJ5Z4xjHVR3WghR73MHeMrv/cRwtTmGxdHpJsAYqZwo/5AYzsk5k641YoX4JNAb
	 /1VNDLbxGUQYtm8tMZ/p0LWUduTxvOEtD2rgg81iBmNP0K88N2toG0WOZGCBO46mTd
	 fmbyMQ2dJGH6/0oZGNySFDAy7ZsojmIWMPj/B/VM=
Date: Tue, 27 Aug 2024 19:17:41 -0700
To: mm-commits@vger.kernel.org,kirill.shutemov@linux.intel.com,david@redhat.com,baolin.wang@linux.alibaba.com,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes.patch added to mm-unstable branch
Message-Id: <20240828021742.587EDC4DE14@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: extend shmem_unused_huge_shrink() to all sizes
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes.patch

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
+		/* No large page at the end of the file: nothing to split */
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
@@ -1852,7 +1847,7 @@ allocated:
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

mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large-fix.patch
mm-shmem-support-large-folio-swap-out-fix.patch
mm-shmem-fix-minor-off-by-one-in-shrinkable-calculation.patch
mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes.patch

