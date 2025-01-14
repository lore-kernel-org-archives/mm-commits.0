Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FED65695
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 00:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736813999; cv=none; b=MmmvN1C4lvG9Ax+m6bd96TX6o9A83RP7lqekk0KldpZmeGoZAaZsAQ6KesOIt+rF1kq5REhilC3lo+8R8NRFyMpAmvH5agkKShUSG4gOLAQcewtVR/a7l8xom7MfNBEDB5NXnfxFfmMz4ymeFvYAjZWT5kk0Ajte6mIP2Tt5F2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736813999; c=relaxed/simple;
	bh=0p6gOBvy3hvdYh61gGKCrI6kPzgFoU60Fb06kFAau6Q=;
	h=Date:To:From:Subject:Message-Id; b=u9LmdS2f0ukz1d+kOTn7j3pxoGEpZjpy4eDnd7gFda0G9uqIqXV/+3AomD9kAGMMHaK/APD6PvIwOgWWc2VqG/R0x9eawDnmo5W09/IUiOxBGvGmPhQNM0FPUbjwVWtogoKcuL7JsJGbzjIoVEne1pwV5BVu2+OUPF1XNcwl+ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1axoQDdd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1axoQDdd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0DC3C4CEE6;
	Tue, 14 Jan 2025 00:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736813999;
	bh=0p6gOBvy3hvdYh61gGKCrI6kPzgFoU60Fb06kFAau6Q=;
	h=Date:To:From:Subject:From;
	b=1axoQDddNNJS5CDLMQmYYBgU2RFMRSPXDnqzNKxtAN5BNLbD+jmK7Z9Zo/iivK+Kg
	 l2VKrYNO+r2xIE6m7SNnTrXxXpkU2Fj3srscLCNg9BA9nCsm0/qQKTgvCvGs6tI3xa
	 Uu2MZGgg77BV3pNoyRNaGKBatm+0DRFsw2RluIR4=
Date: Mon, 13 Jan 2025 16:19:58 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@linux.alibaba.com,v-songbaohua@oppo.com,ryan.roberts@arm.com,nphamcs@gmail.com,kaleshsingh@google.com,hughd@google.com,hannes@cmpxchg.org,chrisl@kernel.org,bhe@redhat.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-introduce-a-helper-for-retrieving-cluster-from-offset.patch added to mm-unstable branch
Message-Id: <20250114001958.F0DC3C4CEE6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: introduce a helper for retrieving cluster from offset
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-introduce-a-helper-for-retrieving-cluster-from-offset.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-introduce-a-helper-for-retrieving-cluster-from-offset.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: introduce a helper for retrieving cluster from offset
Date: Tue, 14 Jan 2025 01:57:30 +0800

It's a common operation to retrieve the cluster info from offset,
introduce a helper for this.

Link: https://lkml.kernel.org/r/20250113175732.48099-12-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Suggested-by: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/mm/swapfile.c~mm-swap-introduce-a-helper-for-retrieving-cluster-from-offset
+++ a/mm/swapfile.c
@@ -424,6 +424,12 @@ static inline unsigned int cluster_index
 	return ci - si->cluster_info;
 }
 
+static inline struct swap_cluster_info *offset_to_cluster(struct swap_info_struct *si,
+							  unsigned long offset)
+{
+	return &si->cluster_info[offset / SWAPFILE_CLUSTER];
+}
+
 static inline unsigned int cluster_offset(struct swap_info_struct *si,
 					  struct swap_cluster_info *ci)
 {
@@ -435,7 +441,7 @@ static inline struct swap_cluster_info *
 {
 	struct swap_cluster_info *ci;
 
-	ci = &si->cluster_info[offset / SWAPFILE_CLUSTER];
+	ci = offset_to_cluster(si, offset);
 	spin_lock(&ci->lock);
 
 	return ci;
@@ -1480,10 +1486,10 @@ static void swap_entry_range_free(struct
 	unsigned char *map_end = map + nr_pages;
 	struct swap_cluster_info *ci;
 
-	/* It should never free entries across different clusters */
-	VM_BUG_ON((offset / SWAPFILE_CLUSTER) != ((offset + nr_pages - 1) / SWAPFILE_CLUSTER));
-
 	ci = lock_cluster(si, offset);
+
+	/* It should never free entries across different clusters */
+	VM_BUG_ON(ci != offset_to_cluster(si, offset + nr_pages - 1));
 	VM_BUG_ON(cluster_is_empty(ci));
 	VM_BUG_ON(ci->count < nr_pages);
 
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-memcontrol-avoid-duplicated-memcg-enable-check.patch
mm-swap_cgroup-remove-swap_cgroup_cmpxchg.patch
mm-swap_cgroup-remove-global-swap-cgroup-lock.patch
mm-swap_cgroup-decouple-swap-cgroup-recording-and-clearing.patch
mm-swap-minor-clean-up-for-swap-entry-allocation.patch
mm-swap-fold-swap_info_get_cont-in-the-only-caller.patch
mm-swap-remove-old-allocation-path-for-hdd.patch
mm-swap-use-cluster-lock-for-hdd.patch
mm-swap-clean-up-device-availability-check.patch
mm-swap-clean-up-plist-removal-and-adding.patch
mm-swap-hold-a-reference-during-scan-and-cleanup-flag-usage.patch
mm-swap-use-an-enum-to-define-all-cluster-flags-and-wrap-flags-changes.patch
mm-swap-reduce-contention-on-device-lock.patch
mm-swap-simplify-percpu-cluster-updating.patch
mm-swap-introduce-a-helper-for-retrieving-cluster-from-offset.patch
mm-swap-use-a-global-swap-cluster-for-non-rotation-devices.patch
mm-swap_slots-remove-slot-cache-for-freeing-path.patch

