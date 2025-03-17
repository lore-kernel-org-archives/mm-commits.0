Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F287B2153E0
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188249; cv=none; b=faSpNEV9fmqn24ylU8wNyFG0lAfoV+6pgjMv6Gog+lttDSkIGeXCTH9czA6sEd7EHLaYuI1D2J6xNg8CcEK1DuMmJMEVdQ4tMwPQTwIW3gT03Vi9C+yiSbZuAVYyBFJb+nj091pXbkgRPvS/BxAUeO7i8534gULjWl+3CZSCtfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188249; c=relaxed/simple;
	bh=+69UPK8xeEhAtM1snQc+iJvFHqfA0QZWIi3/wY4RmAM=;
	h=Date:To:From:Subject:Message-Id; b=C4DGXmZbJ8JTqrmfKVp2Zs6b63h2kj36wgYfFQO10V8hQA5jYVx7bA6D5lqHHzBBfjpc6KILionsbdCBXRthacdhYRbsIW9v+9I2WS4WZKay34YLpMNoJFdBXvATVS35TuR+JzYiVTFmlIBT+/KZjkUalZBUoE56UnZOdVtY0vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ktV1/maM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ktV1/maM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C646EC4CEEC;
	Mon, 17 Mar 2025 05:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188248;
	bh=+69UPK8xeEhAtM1snQc+iJvFHqfA0QZWIi3/wY4RmAM=;
	h=Date:To:From:Subject:From;
	b=ktV1/maMcfXGZkwUU8z4HOqd2kgDd8xOQrxrMN5dA6mVnmkz0nOTCA6qNMqK61i01
	 Eap9PArc1mX5IRzJOzaJhMzM3sqGw4jwGtlz29L+z8utzLG5sO6YBMoa8064lPo5HN
	 YtU9wJeMDEn2qxurcmcEqZeyOU2pmp+DiztAijTw=
Date: Sun, 16 Mar 2025 22:10:48 -0700
To: mm-commits@vger.kernel.org,ryncsn@gmail.com,chrisl@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swapfilec-open-code-cluster_alloc_swap.patch removed from -mm tree
Message-Id: <20250317051048.C646EC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swapfile.c: open code cluster_alloc_swap()
has been removed from the -mm tree.  Its filename was
     mm-swapfilec-open-code-cluster_alloc_swap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/swapfile.c: open code cluster_alloc_swap()
Date: Wed, 5 Feb 2025 17:27:21 +0800

It's only called in scan_swap_map_slots().

And also remove the stale code comment in scan_swap_map_slots() because
it's not fit for the current cluster allocation mechanism.

Link: https://lkml.kernel.org/r/20250205092721.9395-13-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   38 ++++++++++----------------------------
 1 file changed, 10 insertions(+), 28 deletions(-)

--- a/mm/swapfile.c~mm-swapfilec-open-code-cluster_alloc_swap
+++ a/mm/swapfile.c
@@ -1163,39 +1163,13 @@ static void swap_range_free(struct swap_
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
@@ -1215,7 +1189,15 @@ static int scan_swap_map_slots(struct sw
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


