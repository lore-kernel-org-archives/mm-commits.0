Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508784119FA
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525502; cv=none; b=j6rDLsSbgsNOrRgxesKF9qk1FJCdAUx1Jb8elptLBGfRxgvnkOkyPIl2Yb3d8oD6Wkhjdz5ASYfKkeJHm4Ax/OF18vese6tgEiEpuMGAGK0vDVBMxfe1sx1axVBngE7nYgYzGGg853WW/9Qb7idBwlk876Ko/DQAZP909lybDNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525502; c=relaxed/simple;
	bh=GzOaeb2yA1lBFf2ROYQSljMH5iBT2NAwV5PCIy/5fkU=;
	h=Date:To:From:Subject:Message-Id; b=ZyV6wyRc6t8GzM3J8LdMMP3ionnRT1obTg2ZqoFdeqH1r6aNzKw3szmS+hYUyBsbrfzSd600lAbAnyR8rcd0me09fz/L4ads5PpD/kT6oLVx+CHs3fx9J6yF6EjBN4ypRQsJiVmuoOy8CeNqq5KOiNT5tYr+N3PNOLdxqS684xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HhPgw+jI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HhPgw+jI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270321F000FF;
	Fri,  9 Oct 2026 05:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525501;
	bh=jo0pL7Lit8RsqOGJZrwDeTlx5aYij24jNGqWp4K38qw=;
	h=Date:To:From:Subject;
	b=HhPgw+jI6gTEpdztUAG3Yllg7QkBP7hSV+yYJU9s9iN2zAQNqR+hGAROZe8m20Enj
	 2286VaGLHIbgX035RR3XP3Ufh+GGRgIUUJ6CVqKK1T7FxckE3SrWOOPax0QbMBibIl
	 HWu2JBQelUA21rBewKfQZz/kh43I3pT8BZo+ETKs=
Date: Thu, 08 Oct 2026 22:58:20 -0700
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,nphamcs@gmail.com,luizcap@redhat.com,kasong@tencent.com,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-move-setup_swap_clusters_info-after-swp_solidstate-initialization.patch removed from -mm tree
Message-Id: <20261009055821.270321F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: move setup_swap_clusters_info() after SWP_SOLIDSTATE initialization
has been removed from the -mm tree.  Its filename was
     mm-swap-move-setup_swap_clusters_info-after-swp_solidstate-initialization.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm, swap: move setup_swap_clusters_info() after SWP_SOLIDSTATE initialization
Date: Mon, 7 Sep 2026 17:13:54 +0800

In setup_swap_clusters_info(), SWP_SOLIDSTATE is used to decide
global_cluster allocation.  Move setup_swap_clusters_info() after
SWP_SOLIDSTATE initialization to avoid unneeded global_cluster allocation.

Link: https://lore.kernel.org/20260907091356.53026-3-shikemeng@huaweicloud.com
Fixes: 451c6326105b ("mm, swap: clean up swapon process and locking")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Luiz Capitulino <luizcap@redhat.com>
Acked-by: Kairui Song <kasong@tencent.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Youngjun Park <youngjun.park@lge.com>
---

 mm/swapfile.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/mm/swapfile.c~mm-swap-move-setup_swap_clusters_info-after-swp_solidstate-initialization
+++ a/mm/swapfile.c
@@ -3763,11 +3763,6 @@ SYSCALL_DEFINE2(swapon, const char __use
 
 	maxpages = si->max;
 
-	/* Set up the swap cluster info */
-	error = setup_swap_clusters_info(si, swap_header, maxpages);
-	if (error)
-		goto bad_swap_unlock_inode;
-
 	if (si->bdev && bdev_stable_writes(si->bdev))
 		si->flags |= SWP_STABLE_WRITES;
 
@@ -3781,6 +3776,14 @@ SYSCALL_DEFINE2(swapon, const char __use
 		inced_nr_rotate_swap = true;
 	}
 
+	/*
+	 * Set up the swap cluster info after SWP_ flags handling as
+	 * setup_swap_clusters_info() checks SWP_SOLIDSTATE.
+	 */
+	error = setup_swap_clusters_info(si, swap_header, maxpages);
+	if (error)
+		goto bad_swap_unlock_inode;
+
 	if ((swap_flags & SWAP_FLAG_DISCARD) &&
 	    si->bdev && bdev_max_discard_sectors(si->bdev)) {
 		/*
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


