Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2178E234973
	for <mm-commits@vger.kernel.org>; Fri, 11 Sep 2026 00:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789085874; cv=none; b=A6hgVc5ZwUuodGb9MUqE9KOuiAwyd31nAw1/D8vU3cspUR82AH8aXDgb95oItsNHRDlwe3a5F5RP1OMU8Su24QiF+yQ1cQvjaFlno0KPbHED47D46AJ34TxxsjBp8XWaOyiPQ31/lGfphCwxcDepmLiRDyohtWELmVqs+ZXKccQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789085874; c=relaxed/simple;
	bh=lZ0UywrY4taC8H411hDwSk5sm7d3y9zx9U1vzPDhTuI=;
	h=Date:To:From:Subject:Message-Id; b=YyGK/oPeGrVhpknztjd7GTK7j3P8B+dkDqiBNheba1aN8SWfKZd/Tll3cxZcmL2s+z4sqhIkgJjP0Y7hXuLfJnGOe9PWdJ6HMIktDPEGXklAsCg0dahnk66CZ9llSxUuLb8qlgUOF4RnPv3kwzAuh7l4v6R9q0ZOtHOKlKeLMjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KRT8W2ZC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KRT8W2ZC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE8491F00893;
	Fri, 11 Sep 2026 00:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789085872;
	bh=gJhAzn0wLPw/1j9HYLUzEk5rInaa431c35p7pvnouq4=;
	h=Date:To:From:Subject;
	b=KRT8W2ZCTBKzfJUH+j5paJARUX4Wj9MRYeM50hRRgfNsSb/NdYmKIswP0jWMmHYxi
	 dOHetTgA84YXmWaFEb+V7xusJpfD4LCQU+2jw9DYCGIK1uNHWA9Rpt+8xDY7TOO3Wm
	 C5h9lvC5SSDZpgeucDBscTm2RVJyMWgFxIPKLF5k=
Date: Thu, 10 Sep 2026 17:17:52 -0700
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,nphamcs@gmail.com,luizcap@redhat.com,kasong@tencent.com,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-move-setup_swap_clusters_info-after-swp_solidstate-initialization.patch added to mm-new branch
Message-Id: <20260911001752.CE8491F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: Move setup_swap_clusters_info() after SWP_SOLIDSTATE initialization
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-move-setup_swap_clusters_info-after-swp_solidstate-initialization.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-move-setup_swap_clusters_info-after-swp_solidstate-initialization.patch

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
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm, swap: Move setup_swap_clusters_info() after SWP_SOLIDSTATE initialization
Date: Mon, 7 Sep 2026 17:13:54 +0800

In setup_swap_clusters_info(), SWP_SOLIDSTATE is used to decide
global_cluster allocation.  Move setup_swap_clusters_info() after
SWP_SOLIDSTATE initialization to avoid unneeded global_cluster allocation.

Link: https://lore.kernel.org/20260907091356.53026-3-shikemeng@huaweicloud.com
Fixes: 451c6326105b2 ("mm, swap: clean up swapon process and locking")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Luiz Capitulino <luizcap@redhat.com>
Acked-by: Kairui Song <kasong@tencent.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Youngjun Park <youngjun.park@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

mm-swap-fix-potential-null-dereference-when-trying-a-sleep-table-allocation.patch
mm-swap-move-setup_swap_clusters_info-after-swp_solidstate-initialization.patch
mm-swap-return-early-from-swap_extend_table_try_free-on-first-non-zero-entry.patch
mm-swap-remove-unneeded-swap_extend_table_try_free-in-swap_dup_entries_cluster.patch

