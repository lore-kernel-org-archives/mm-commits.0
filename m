Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E8B224B11
	for <mm-commits@vger.kernel.org>; Thu,  6 Feb 2025 07:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738828668; cv=none; b=Xr98s3Gx65uvgTOcI3N9+ZvMUPshAm/ETYSQ+byaRp9o9zmsAqVHmHewEOP15P/FciE/XtGY2JCr3aVr38JHlC8jKKTDncFv8GpAH93WlYs+BTLbwce5ZbqJLpu2ZzVVsvtUOJ9NusS6sSQ5C5MvkgDRsuodeTrOqN4Lljhl/pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738828668; c=relaxed/simple;
	bh=HMAd/huzVyMt1vgLvvYLL7wUetG0qW59m3nZpm1S1L4=;
	h=Date:To:From:Subject:Message-Id; b=C7cu+p70Zqpne16u4XwN8I8ocr/YvNPEZiKjVeD4lvXjtKEV/uzu1PTMyOmFYQPjM4fw1Fq7iUx/6R0J+dphpx3DNbvpH8Re4Z78OVZTkuQd8DxxgjvQuXk1NbA++fbTzjgt8ZQjI9uxCDBcRcNwXAAVf8pHhx8pkBk1U8Jnv/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H/Dau1IP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H/Dau1IP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A1ACC4CEDD;
	Thu,  6 Feb 2025 07:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738828668;
	bh=HMAd/huzVyMt1vgLvvYLL7wUetG0qW59m3nZpm1S1L4=;
	h=Date:To:From:Subject:From;
	b=H/Dau1IPWN4Vf2ro9YLDo/r/xxgqZvfJoz96HZ8XjKN2yqtiJnlno6jD5YNUdj7xt
	 io/fGgy2HXDxOcFN8JTq7Pc4ugXGfQBzSwAl9FvmZmpE/UMVbeTUHUIQYH6zMGZ8si
	 tPe2/3d9En4lEVE2Jf8Qy0chs3HLC/nHUkwwX+Zk=
Date: Wed, 05 Feb 2025 23:57:47 -0800
To: mm-commits@vger.kernel.org,ryncsn@gmail.com,chrisl@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swapfilec-open-code-cluster_alloc_swap.patch added to mm-unstable branch
Message-Id: <20250206075748.3A1ACC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swapfile.c: open code cluster_alloc_swap()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swapfilec-open-code-cluster_alloc_swap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swapfilec-open-code-cluster_alloc_swap.patch

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
From: Baoquan He <bhe@redhat.com>
Subject: mm/swapfile.c: open code cluster_alloc_swap()
Date: Wed, 5 Feb 2025 17:27:21 +0800

It's only called in scan_swap_map_slots().

And also remove the stale code comment in scan_swap_map_slots() because
it's not fit for the current cluster allocation mechanism.

Link: https://lkml.kernel.org/r/20250205092721.9395-13-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Chis Li <chrisl@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   38 ++++++++++----------------------------
 1 file changed, 10 insertions(+), 28 deletions(-)

--- a/mm/swapfile.c~mm-swapfilec-open-code-cluster_alloc_swap
+++ a/mm/swapfile.c
@@ -1158,39 +1158,13 @@ static void swap_range_free(struct swap_
 	swap_usage_sub(si, nr_entries);
 }
 
-static int cluster_alloc_swap(struct swap_info_struct *si,
-			     unsigned char usage, int nr,
-			     swp_entry_t slots[], int order)
-{
-	int n_ret = 0;
-
-	while (n_ret < nr) {
-		unsigned long offset = cluster_alloc_swap_entry(si, order, usage);
-
-		if (!offset)
-			break;
-		slots[n_ret++] = swp_entry(si->type, offset);
-	}
-
-	return n_ret;
-}
-
 static int scan_swap_map_slots(struct swap_info_struct *si,
 			       unsigned char usage, int nr,
 			       swp_entry_t slots[], int order)
 {
 	unsigned int nr_pages = 1 << order;
+	int n_ret = 0;
 
-	/*
-	 * We try to cluster swap pages by allocating them sequentially
-	 * in swap.  Once we've allocated SWAPFILE_CLUSTER pages this
-	 * way, however, we resort to first-free allocation, starting
-	 * a new cluster.  This prevents us from scattering swap pages
-	 * all over the entire swap partition, so that we reduce
-	 * overall disk seek times between swap pages.  -- sct
-	 * But we do now try to find an empty cluster.  -Andrea
-	 * And we let swap pages go all over an SSD partition.  Hugh
-	 */
 	if (order > 0) {
 		/*
 		 * Should not even be attempting large allocations when huge
@@ -1210,7 +1184,15 @@ static int scan_swap_map_slots(struct sw
 			return 0;
 	}
 
-	return cluster_alloc_swap(si, usage, nr, slots, order);
+	while (n_ret < nr) {
+		unsigned long offset = cluster_alloc_swap_entry(si, order, usage);
+
+		if (!offset)
+			break;
+		slots[n_ret++] = swp_entry(si->type, offset);
+	}
+
+	return n_ret;
 }
 
 static bool get_swap_device_info(struct swap_info_struct *si)
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-swap_statec-fix-the-obsolete-code-comment.patch
mm-swap_statec-optimize-the-code-in-clear_shadow_from_swap_cache.patch
mm-swap-remove-swap_flag_prio_shift.patch
mm-swap-skip-scanning-cluster-range-if-its-empty-cluster.patch
mm-swap-rename-swap_is_has_cache-to-swap_only_has_cache.patch
mm-swapfilec-update-the-code-comment-above-swap_count_continued.patch
mm-swapfilec-optimize-code-in-setup_clusters.patch
mm-swap_statec-remove-the-meaningless-code-comment.patch
mm-swapfilec-remove-the-unneeded-checking.patch
mm-swap-rename-swap_swapcount-to-swap_entry_swapped.patch
mm-swapfilec-remove-the-incorrect-code-comment.patch
mm-swapfilec-open-code-cluster_alloc_swap.patch

