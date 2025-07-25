Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84211214232;
	Fri, 25 Jul 2025 02:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409695; cv=none; b=sPv+qX9LBpmp29xtN8BfyKapwO/pVbnQmeUPjzxAUPjnPERjVfjt8FkA3B/qRIYHfr5qKnebPKvTFjiOYkb41de6bUtGii/FZrd1qivQt4qOUuBnePMRhz41adpKYKsq6jurBnhv8V5kFMOEB5PpBXKPGLGOrrRk3ybHbljs1Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409695; c=relaxed/simple;
	bh=jwEI8goxCJRcQgy46WdDaV9JX30nfeTxysAOLwZQQaQ=;
	h=Date:To:From:Subject:Message-Id; b=L4UylqBsf8J4eAJ8jTnGCRm9AmJwTVVVJlw4kWiZcyOADkMclcRUrPXZ5Q6WLZyv7LGzo1p1euyrWll8aZQaSsAnQRrQwlrrVXc9/L7jgzwEr775hTcm4h5utG5cPQuq6d1CXE80nXIx/6XYCc8zltCz+GBSLhJYfJUrHBO204g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xIGXu9kl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xIGXu9kl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 561ECC4CEEF;
	Fri, 25 Jul 2025 02:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409695;
	bh=jwEI8goxCJRcQgy46WdDaV9JX30nfeTxysAOLwZQQaQ=;
	h=Date:To:From:Subject:From;
	b=xIGXu9klJwP2IgqIdL509nGFndqxmD6sqfXERumZC89Gn+BgIA2iT+X/x9jIn7i1R
	 izdReOULrxHWiuzZYlABIM0ls0hfeqZI41pWAnCq6whAPjZP4xKgftaMA9fEGh+X0U
	 wzGdJQE19dGQIr/Z4B3fLB8FsnKIRHDaBwWBIdT0=
Date: Thu, 24 Jul 2025 19:14:54 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,kasong@tencent.com,hannes@cmpxchg.org,bhe@redhat.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-fix-potensial-buffer-overflow-in-setup_clusters.patch removed from -mm tree
Message-Id: <20250725021455.561ECC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: swap: fix potential buffer overflow in setup_clusters()
has been removed from the -mm tree.  Its filename was
     mm-swap-fix-potensial-buffer-overflow-in-setup_clusters.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm: swap: fix potential buffer overflow in setup_clusters()
Date: Thu, 22 May 2025 20:25:53 +0800

In setup_swap_map(), we only ensure badpages are in range (0, last_page]. 
As maxpages might be < last_page, setup_clusters() will encounter a buffer
overflow when a badpage is >= maxpages.

Only call inc_cluster_info_page() for badpage which is < maxpages to fix
the issue.

Link: https://lkml.kernel.org/r/20250522122554.12209-4-shikemeng@huaweicloud.com
Fixes: b843786b0bd0 ("mm: swapfile: fix SSD detection with swapfile on btrfs")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/swapfile.c~mm-swap-fix-potensial-buffer-overflow-in-setup_clusters
+++ a/mm/swapfile.c
@@ -3208,9 +3208,13 @@ static struct swap_cluster_info *setup_c
 	 * and the EOF part of the last cluster.
 	 */
 	inc_cluster_info_page(si, cluster_info, 0);
-	for (i = 0; i < swap_header->info.nr_badpages; i++)
-		inc_cluster_info_page(si, cluster_info,
-				      swap_header->info.badpages[i]);
+	for (i = 0; i < swap_header->info.nr_badpages; i++) {
+		unsigned int page_nr = swap_header->info.badpages[i];
+
+		if (page_nr >= maxpages)
+			continue;
+		inc_cluster_info_page(si, cluster_info, page_nr);
+	}
 	for (i = maxpages; i < round_up(maxpages, SWAPFILE_CLUSTER); i++)
 		inc_cluster_info_page(si, cluster_info, i);
 
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


