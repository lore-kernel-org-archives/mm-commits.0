Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BC87346F
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006262; cv=none; b=kT5cBbFbB61X7JZB8YulWdFNBrcxvK7hCWX8Bp8EO8W8aRuH0WRGv4CD7j7yB3EabqKDwO3ARbZeOS4/w9Zf+Of6P6NkNNROShXwQFiVmLxp+PXOlJr0/NhkMQubcEtj1NyAj0/vzIlMSpwokoXbu734Prvln8I4j4opjtMO2pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006262; c=relaxed/simple;
	bh=vCILGgiOnk5gU4P+zI9j05tZc3y7u7xpm9RMVbLus5k=;
	h=Date:To:From:Subject:Message-Id; b=oWCZxM8FwrNB9mt5cRH2fZ9gbjAJqPHC9Xv/sUZ7DT4L+4hs2A+OVQkJNVENufeIHAZrIEbL5iBi6lK9uBkDotDra3XxXYkut0gEkiCkxFbyROdbdA1pnMXXw0mHMGWnc5gb5SVTdN1Yvy4glIAUqUNBFzcsndfRX5HEAKeLKn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MJYAiesS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MJYAiesS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55119C4CED6;
	Thu, 16 Jan 2025 05:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006261;
	bh=vCILGgiOnk5gU4P+zI9j05tZc3y7u7xpm9RMVbLus5k=;
	h=Date:To:From:Subject:From;
	b=MJYAiesSOl+rK/AVElcUxb/7SroTC3c/8jkG7ym3epG1xeOv6oJ4E3lwGmrukQElw
	 QGGU8koWvod8IfHiM8W/MVwPqeNy6fkHwRASLo3spCuAx981bjYRcMBhuDg+P79fiK
	 +zUF+zyclu81bxKqxNgsF3GKQ+iGWeXWleIX+H8Y=
Date: Wed, 15 Jan 2025 21:44:20 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@linux.alibaba.com,v-songbaohua@oppo.com,ryan.roberts@arm.com,nphamcs@gmail.com,kaleshsingh@google.com,hughd@google.com,hannes@cmpxchg.org,chrisl@kernel.org,bhe@redhat.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-introduce-a-helper-for-retrieving-cluster-from-offset.patch removed from -mm tree
Message-Id: <20250116054421.55119C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: introduce a helper for retrieving cluster from offset
has been removed from the -mm tree.  Its filename was
     mm-swap-introduce-a-helper-for-retrieving-cluster-from-offset.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


