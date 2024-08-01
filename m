Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CF513C832
	for <mm-commits@vger.kernel.org>; Thu,  1 Aug 2024 19:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722539263; cv=none; b=GCJXSsjVStg4aYNZMBJFGOhmT0gs/aEGV+oBKdG/FAiG/h+j3TBydXayiWO28LguslGjfYqqpL2yCuXNpAQC1KK2jQNLYQ951bR0BjKpLmYEHevatDR3TWRm4szVqbSh5aFq1ETt8VyP6iReSdS24iKfwI8FdqM6c3sk/nTsiIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722539263; c=relaxed/simple;
	bh=kuAAvhLRDXRJWCff82/zr+XHsbvpsiJQMlNEIVY9tLU=;
	h=Date:To:From:Subject:Message-Id; b=oudKlHfHVYQym5HcOzj2YgRiVjEh/7klZRVLevAFmglGSImtlYcGyDcEWsWBfw/KS9zLMEpH1oQtvZu6/ypp+nCC0FFLqNfMDVmhelaIgDoSFGabuco0cSrc4S+7D/bqJoND/p47oIokjOZBRiF/v8hUUShSdlJKXhiaEjKZljU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HQV6uiDQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HQV6uiDQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9365BC32786;
	Thu,  1 Aug 2024 19:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722539262;
	bh=kuAAvhLRDXRJWCff82/zr+XHsbvpsiJQMlNEIVY9tLU=;
	h=Date:To:From:Subject:From;
	b=HQV6uiDQzKETvA0rbUQ5YuaCNZrzQuMAqgX5FpmWha5n8B9w9xi/oMKXjgTyoduDw
	 J9d6baF6sNnX1gIhcn2Lqc097aSu6SDe1J3KJJbJWBKziS+iE8n25yZAWhHn1vbB4o
	 MGVRcgecdlzgOu43vjKGbSrE/AtUyIYextwcosyA=
Date: Thu, 01 Aug 2024 12:07:41 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,ryan.roberts@arm.com,kasong@tencent.com,kaleshsingh@google.com,hughd@google.com,david@redhat.com,chrisl@kernel.org,21cnbao@gmail.com,ryncsn@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-add-a-adaptive-full-cluster-cache-reclaim-fix.patch added to mm-unstable branch
Message-Id: <20240801190742.9365BC32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-swap-add-a-adaptive-full-cluster-cache-reclaim-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-add-a-adaptive-full-cluster-cache-reclaim-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-add-a-adaptive-full-cluster-cache-reclaim-fix.patch

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

mm-swap-add-a-adaptive-full-cluster-cache-reclaim-fix.patch

