Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508333B83FB
	for <mm-commits@vger.kernel.org>; Fri, 28 Aug 2026 18:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787942778; cv=none; b=LlKMVm6IuHmG3A0ILjJtlXGY5jbjgVhcYLfr2i3Q19Xh5vAZa41psvFq1DZWc0G1nM5yNxc6qv+NjHEHYrM6Mjtwrj0R1x/5DxDkPkQinqNkLPd2IV/2GHyPXngfVpC/FKvhWLXey65qT52g3Uck83qgq9fN+qlhkoJC7qDqwRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787942778; c=relaxed/simple;
	bh=s5Veu3eVTP4cjJkU91XWLuiw1RtgKbjguYcQi1gZ2k4=;
	h=Date:To:From:Subject:Message-Id; b=XcWRXRLCV8MM15WaAuGMlWEcIsb1Lc+Ca22p+m6OeaUYgxPYlFe93drsLCyeGwDXkyp8CMLtcs426p5mdV/rhYPcyzxYEtBPRQkf8lnkXj9p60mUix6Q27ZppxW9I+KhXjeUUDsGNhbfKHyJ7YruqGM+23sK1n4oG+Sy9WIw0EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Na88Z9xY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Na88Z9xY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952401F000E9;
	Fri, 28 Aug 2026 18:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787942776;
	bh=0W9y1zxmw2s5KuNSpLD6m1H+jrPMyH9QbsJXln60Oms=;
	h=Date:To:From:Subject;
	b=Na88Z9xYRlMOb5ZFUOj6lgbj28efU/oVJbjJD1J2S83KQTlLla6WuWmsRelOHRSGC
	 /lNo7hqLA1qwJ17G1DoPTTzr0ob9EfRmjcm8n683G+xzbyiVMVmCvW/ftmRPVCxKaM
	 uy7Ug4mrgqsWQGmRpubgIE7UuyTDIeHG45yFiz4U=
Date: Fri, 28 Aug 2026 11:46:16 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hughd@google.com,hannes@cmpxchg.org,david@kernel.org,brauner@kernel.org,baolin.wang@linux.alibaba.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-move-unused-huge-shrinklist-queuing-past-the-truncation-check.patch added to mm-new branch
Message-Id: <20260828184616.952401F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: move unused huge shrinklist queuing past the truncation check
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-move-unused-huge-shrinklist-queuing-past-the-truncation-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-move-unused-huge-shrinklist-queuing-past-the-truncation-check.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   48 +++++++++++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 21 deletions(-)

--- a/mm/shmem.c~mm-shmem-move-unused-huge-shrinklist-queuing-past-the-truncation-check
+++ a/mm/shmem.c
@@ -2536,27 +2536,6 @@ repeat:
 
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
@@ -2586,6 +2565,33 @@ clear:
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

fs-fix-missed-removal-of-super_fs_objects_eligible.patch
mm-memcontrol-make-obj_cgroup_memcg-handle-null-objcg.patch
mm-shmem-move-unused-huge-shrinklist-queuing-past-the-truncation-check.patch
mm-shmem-make-unused-huge-shrinker-memcg-aware.patch

