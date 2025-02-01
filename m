Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDAC7190486
	for <mm-commits@vger.kernel.org>; Sat,  1 Feb 2025 11:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738410856; cv=none; b=Ti6zcj8Su0RNFxTtHh8K0yBgHfgdtOld6qPOYvkxZ8z6+wL/iWuPfaNQxJSab0dtEOnWnuCeK9O3ujBD5CuCq3HlRn3ohynL8ENRRKZ7+8UfLxXAXmvEV3mFJgZ/+yz0aityAB5CXodlS7BtCdSLWSE6UDA31GxUdsDnKtq1QAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738410856; c=relaxed/simple;
	bh=D5IeDi2SMMCedKz1FSfWuov6Lx0Oji1FlvDpipdj5yc=;
	h=Date:To:From:Subject:Message-Id; b=fscdnr/g0HgKv7c4oTLkAFyOf+Fv0qi8Wk5v3FtqURPXEjUL7f+7xDQTDf2NemH92UDoyq7NNTA7erxKLggSQ4ev3ItQ+eOrLO0lJIXtQ1s26pNO+HyN2UPzbLvFZIVf9SaEPSWpoQQcVI2CxFC9Or6rO+v5n2aynLRBY4Z5XQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rVZ8v+wl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rVZ8v+wl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E34C4CED3;
	Sat,  1 Feb 2025 11:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738410855;
	bh=D5IeDi2SMMCedKz1FSfWuov6Lx0Oji1FlvDpipdj5yc=;
	h=Date:To:From:Subject:From;
	b=rVZ8v+wlus945E5P2zlcpLuFSWmqHKnVnJ7+77WeIncFt9XFGUM0GFKfmbijk35J5
	 sPbnZmKw5YdgXQve6Y8327L48n6A2io/Gv+7iMzQXtCa3tnjH+ptcqwBXwHRBLbj7S
	 r29Nhb5NV4k6CT9VGCVUvKDS6OIATyKKMsyN1bg8=
Date: Sat, 01 Feb 2025 03:54:14 -0800
To: mm-commits@vger.kernel.org,chrisl@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-swap-fix-reclaim-offset-calculation-error-during-allocation.patch removed from -mm tree
Message-Id: <20250201115415.44E34C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: fix reclaim offset calculation error during allocation
has been removed from the -mm tree.  Its filename was
     mm-swap-fix-reclaim-offset-calculation-error-during-allocation.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: fix reclaim offset calculation error during allocation
Date: Thu, 30 Jan 2025 19:51:31 +0800

There is a code error that will cause the swap entry allocator to reclaim
and check the whole cluster with an unexpected tail offset instead of the
part that needs to be reclaimed.  This may cause corruption of the swap
map, so fix it.

Link: https://lkml.kernel.org/r/20250130115131.37777-1-ryncsn@gmail.com
Fixes: 3b644773eefd ("mm, swap: reduce contention on device lock")
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Chris Li <chrisl@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swap-fix-reclaim-offset-calculation-error-during-allocation
+++ a/mm/swapfile.c
@@ -794,7 +794,7 @@ static unsigned int alloc_swap_scan_clus
 		if (!cluster_scan_range(si, ci, offset, nr_pages, &need_reclaim))
 			continue;
 		if (need_reclaim) {
-			ret = cluster_reclaim_range(si, ci, start, end);
+			ret = cluster_reclaim_range(si, ci, offset, offset + nr_pages);
 			/*
 			 * Reclaim drops ci->lock and cluster could be used
 			 * by another order. Not checking flag as off-list
_

Patches currently in -mm which might be from kasong@tencent.com are


