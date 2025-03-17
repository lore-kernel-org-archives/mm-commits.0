Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E77C2A1D8
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188453; cv=none; b=bDaxOO3O/lrcV7fBYIvIq5sQ66jZP7yKMVMEmONuvLhThc4vr2zh50BGYjscqdlklJcu1s1tl/p2SPVNpLNQ0vOGMB0pyeFNcgyvlAdIE1aYnTAi4Y+bz33xxl+np/Vsp5CzXPnSSRSdL4hpthDQwcD3iL80ALrI9pZPfETZ+jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188453; c=relaxed/simple;
	bh=G5qG35JMjcckE9oWtSZalJwWMRKPuHGGmG9nVAalhDk=;
	h=Date:To:From:Subject:Message-Id; b=dTcxet3rmN7lv+B6nJW5igKqdfNFBUgTw/8sigr7Vpn7KNjFpzDY9dO2c2Brbr5Mta2qKRYtR4WzeGP61Moxe6566Weu9rop84Pclmc1GbuCaB0KzB6MZ9uXpajqIGI7Aly1T4Mf3K3hvLOlPQCNuvIMB4ld1OzQ6F0zCbHNHJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cEqi1rSz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cEqi1rSz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F1BC4CEEC;
	Mon, 17 Mar 2025 05:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188453;
	bh=G5qG35JMjcckE9oWtSZalJwWMRKPuHGGmG9nVAalhDk=;
	h=Date:To:From:Subject:From;
	b=cEqi1rSzkN5HibumV5/cAtDig6scxNemg7lZsR2y0ZkVk7FzBRhVg8DmRQNvS3zxY
	 jMxAnPH5W1YcqWLBhXX9nln77WWFgM1CsIw4gnGGxDo/qdkVUk12820duFEwIbuq/a
	 pYfnvy2zPcj1FqEuLJB6HoXHv5agemGxwFGPXP9I=
Date: Sun, 16 Mar 2025 22:14:12 -0700
To: mm-commits@vger.kernel.org,ryncsn@gmail.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-remove-stale-comment-of-swap_reclaim_full_clusters.patch removed from -mm tree
Message-Id: <20250317051413.37F1BC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: swap: remove stale comment of swap_reclaim_full_clusters()
has been removed from the -mm tree.  Its filename was
     mm-swap-remove-stale-comment-of-swap_reclaim_full_clusters.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm: swap: remove stale comment of swap_reclaim_full_clusters()
Date: Sun, 23 Feb 2025 00:08:50 +0800

swap_reclaim_full_clusters() has no return value now, just remove the
stale comment which says swap_reclaim_full_clusters() wil return a bool
value.

Link: https://lkml.kernel.org/r/20250222160850.505274-7-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/swapfile.c~mm-swap-remove-stale-comment-of-swap_reclaim_full_clusters
+++ a/mm/swapfile.c
@@ -820,7 +820,6 @@ out:
 	return found;
 }
 
-/* Return true if reclaimed a whole cluster */
 static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 {
 	long to_scan = 1;
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


