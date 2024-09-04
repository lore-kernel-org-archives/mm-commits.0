Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC22E2F34
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 03:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725421668; cv=none; b=aVnBNWTctDoWViLQQMJQ4BakTrZ6MJMOjbeWEbTJKJX4gQSdxlHwWWbgmlsndq+9AIOvfRcp2ywefTx89GqFVPb/+ax7KUIcbw44LHoNJh0ULCeIptLpfdTw21O04hnXB/2I62vTFloO/7N6jaAQYyYcTnctGGYluchl8uogsII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725421668; c=relaxed/simple;
	bh=utECewbLHHVdbjY9/SFRllJ1Q55zll3Nnj0s9KH4hKU=;
	h=Date:To:From:Subject:Message-Id; b=THS3dgAz7AFDCTnMWbP+ShK8EJO2UNrbS5EdWd+OkE2VHF+qyCcdvcrgO+w/U5tdwfg/dr+3Cs64j6Txt4hUTldR4cHUoqXeVOn4AHX+f8YgbHago2Y6FokeeP/1I+rzBaNNHY6eOxjhOpy+zjYCXtDfIv2cUzthTVkMidFW8Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kWg6E5XE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kWg6E5XE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3857DC4CEC2;
	Wed,  4 Sep 2024 03:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725421666;
	bh=utECewbLHHVdbjY9/SFRllJ1Q55zll3Nnj0s9KH4hKU=;
	h=Date:To:From:Subject:From;
	b=kWg6E5XExUU0+zpjyqX+D/brHcutL1HQBI9B2Jsp2qCs2A0qMT7uo5fdrbSKhTZFx
	 4jFRx0T53fVwVEkg9CISSOmOsZ2D48H3/ZxGhbv1ARQitw8+zC2fZA4SjEQLkHAK3V
	 FfJk/68M7BO+xmnetNMXuWQQAZuSNYJVkRVWC4Xg=
Date: Tue, 03 Sep 2024 20:47:45 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,ryan.roberts@arm.com,kasong@tencent.com,kaleshsingh@google.com,hughd@google.com,david@redhat.com,chrisl@kernel.org,21cnbao@gmail.com,ryncsn@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-swap-add-a-adaptive-full-cluster-cache-reclaim-fix.patch removed from -mm tree
Message-Id: <20240904034746.3857DC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-swap-add-a-adaptive-full-cluster-cache-reclaim-fix
has been removed from the -mm tree.  Its filename was
     mm-swap-add-a-adaptive-full-cluster-cache-reclaim-fix.patch

This patch was dropped because it was folded into mm-swap-add-a-adaptive-full-cluster-cache-reclaim.patch

------------------------------------------------------
From: Kairui Song <ryncsn@gmail.com>
Subject: mm-swap-add-a-adaptive-full-cluster-cache-reclaim-fix
Date: Thu, 1 Aug 2024 17:59:17 +0800

fix discard of full cluster

Link: https://lkml.kernel.org/r/CAMgjq7CWwK75_2Zi5P40K08pk9iqOcuWKL6khu=x4Yg_nXaQag@mail.gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reported-by: David Hildenbrand <david@redhat.com>
Closes: https://lkml.kernel.org/r/3c79021a-e9a0-4669-a4e7-7060edf12d58@redhat.com
Cc: Barry Song <21cnbao@gmail.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 +
 mm/swapfile.c        |    8 +++++---
 2 files changed, 6 insertions(+), 3 deletions(-)

--- a/include/linux/swap.h~mm-swap-add-a-adaptive-full-cluster-cache-reclaim-fix
+++ a/include/linux/swap.h
@@ -260,6 +260,7 @@ struct swap_cluster_info {
 #define CLUSTER_FLAG_FREE 1 /* This cluster is free */
 #define CLUSTER_FLAG_NONFULL 2 /* This cluster is on nonfull list */
 #define CLUSTER_FLAG_FRAG 4 /* This cluster is on nonfull list */
+#define CLUSTER_FLAG_FULL 8 /* This cluster is on full list */
 
 /*
  * The first page in the swap file is the swap header, which is always marked
--- a/mm/swapfile.c~mm-swap-add-a-adaptive-full-cluster-cache-reclaim-fix
+++ a/mm/swapfile.c
@@ -450,7 +450,10 @@ static void __free_cluster(struct swap_i
 	lockdep_assert_held(&si->lock);
 	lockdep_assert_held(&ci->lock);
 
-	list_move_tail(&ci->list, &si->free_clusters);
+	if (ci->flags)
+		list_move_tail(&ci->list, &si->free_clusters);
+	else
+		list_add_tail(&ci->list, &si->free_clusters);
 	ci->flags = CLUSTER_FLAG_FREE;
 	ci->order = 0;
 }
@@ -474,7 +477,6 @@ static void swap_do_scheduled_discard(st
 				SWAPFILE_CLUSTER);
 
 		spin_lock(&si->lock);
-
 		spin_lock(&ci->lock);
 		__free_cluster(si, ci);
 		memset(si->swap_map + idx * SWAPFILE_CLUSTER,
@@ -666,7 +668,7 @@ static void cluster_alloc_range(struct s
 		if (ci->flags & CLUSTER_FLAG_FRAG)
 			si->frag_cluster_nr[ci->order]--;
 		list_move_tail(&ci->list, &si->full_clusters);
-		ci->flags = 0;
+		ci->flags = CLUSTER_FLAG_FULL;
 	}
 }
 
_

Patches currently in -mm which might be from ryncsn@gmail.com are

mm-swap-add-a-adaptive-full-cluster-cache-reclaim.patch

