Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F552E282B
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334204; cv=none; b=aM9nE9qNqE/Z2jCnMAEhjblf7on5ABsH4hpvrLrYch26P40x4zCQ6K5Gox/CjJV2V5eJRF5L5CD1D2qzVjO3gQjumRGxlX72t59z0kSCoKjU9J7YJOZ6yjV2/rqH9sC7lPeUe2ld2qEbqpA2TAcqwZOSw6sU3SoSkR1iCzFLozY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334204; c=relaxed/simple;
	bh=4YMFQ/Kgk/ezNITwuOEcwImcSXpH56fn5i+sMp9Oi3Y=;
	h=Date:To:From:Subject:Message-Id; b=s2ifHkkTuMpZT1kLWoXNkCOyTZ0VJA5c9qVoeZZjqU5bxOu90afXJU+2+Zahqd6sab0VMJMd4FeIbLZFrR8611z/DyzwCTrv7uwOnQ0NHjXg5uot9a5ZThnw1Lb4lEoeooIzu/EMBYl4mtPH9EDUEbdm9hnEWl9iCmTERxz6kOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=slxg2iz5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="slxg2iz5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541A81F0089C;
	Wed,  7 Oct 2026 00:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334203;
	bh=PkKyHw4YdUr7iMUCizWoF0HCl49c7glwzLxl0kX0eVc=;
	h=Date:To:From:Subject;
	b=slxg2iz5ccdg6dtKoMWqAl1PwbNP/fAfcO9racFcWXiSYAf1WWNVTLPYvjyodqNeA
	 LC50fXqtEMY6xUa4FD89UzQnZKk6dW3hgqv6peV2yiMo3aerwfFnCuixM7bwruAhKF
	 9I6/a4Uh/rFn9Y+DFMvC1mxApIE34Ob7mVdM8v5o=
Date: Tue, 06 Oct 2026 17:50:02 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hughd@google.com,hannes@cmpxchg.org,david@kernel.org,brauner@kernel.org,baolin.wang@linux.alibaba.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-move-unused-huge-shrinklist-queuing-past-the-truncation-check.patch removed from -mm tree
Message-Id: <20261007005003.541A81F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: move unused huge shrinklist queuing past the truncation check
has been removed from the -mm tree.  Its filename was
     mm-shmem-move-unused-huge-shrinklist-queuing-past-the-truncation-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: shmem: move unused huge shrinklist queuing past the truncation check
Date: Mon, 17 Aug 2026 17:03:27 +0800

The shmem_get_folio_gfp() adds the inode to the unused huge shrinker list
at the alloced label, but a subsequent truncation check may still fail and
remove the folio, leaving the inode on the list with a stale folio.

The original code works because the shrinker re-looks-up the folio and
drops stale entries, but it is cleaner to queue the inode only after all
checks that might remove the folio have passed.

So just make the pure structural move with no functional change, and it
serves as preparation for the memcg-aware shrinker conversion.

Link: https://lore.kernel.org/17fcf64faec0dfbbe6cf8a97924e3f39cd3c51a4.1786955972.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
---

 mm/shmem.c |   48 +++++++++++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 21 deletions(-)

--- a/mm/shmem.c~mm-shmem-move-unused-huge-shrinklist-queuing-past-the-truncation-check
+++ a/mm/shmem.c
@@ -2539,27 +2539,6 @@ repeat:
 
 alloced:
 	alloced = true;
-	if (folio_test_large(folio) &&
-	    DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE) <
-					folio_next_index(folio)) {
-		struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
-		struct shmem_inode_info *info = SHMEM_I(inode);
-		/*
-		 * Part of the large folio is beyond i_size: subject
-		 * to shrink under memory pressure.
-		 */
-		spin_lock(&sbinfo->shrinklist_lock);
-		/*
-		 * _careful to defend against unlocked access to
-		 * ->shrink_list in shmem_unused_huge_shrink()
-		 */
-		if (list_empty_careful(&info->shrinklist)) {
-			list_add_tail(&info->shrinklist,
-				      &sbinfo->shrinklist);
-			sbinfo->shrinklist_len++;
-		}
-		spin_unlock(&sbinfo->shrinklist_lock);
-	}
 
 	if (sgp == SGP_WRITE)
 		folio_set_referenced(folio);
@@ -2589,6 +2568,33 @@ clear:
 		error = -EINVAL;
 		goto unlock;
 	}
+
+	/*
+	 * Queue the inode on the shrink list only after all checks that might
+	 * remove the folio have passed. Otherwise the inode could be left on
+	 * the shrinker list with a stale folio.
+	 */
+	if (alloced && folio_test_large(folio) &&
+	    DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE) < folio_next_index(folio)) {
+		struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
+		struct shmem_inode_info *info = SHMEM_I(inode);
+		/*
+		 * Part of the large folio is beyond i_size: subject
+		 * to shrink under memory pressure.
+		 */
+		spin_lock(&sbinfo->shrinklist_lock);
+		/*
+		 * _careful to defend against unlocked access to
+		 * ->shrink_list in shmem_unused_huge_shrink()
+		 */
+		if (list_empty_careful(&info->shrinklist)) {
+			list_add_tail(&info->shrinklist,
+				      &sbinfo->shrinklist);
+			sbinfo->shrinklist_len++;
+		}
+		spin_unlock(&sbinfo->shrinklist_lock);
+	}
+
 out:
 	*foliop = folio;
 	return 0;
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


