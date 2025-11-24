Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8A42FB990
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025878; cv=none; b=fdJKVfVXncVtjT1P5SVHl4qcEbXiWyDeRDqfwjUEZ+2+dJ1v2smvDWclgPtSK+5YBidGZSzqScDOvmCihXJTXXypAYpIf6E+2KPCYm5AJ5jXZ6hDyvn9yqk5gKN4R0aQibnxJ10Sz7hoWQ4HfJ1vzFnOgji7bQmyIabeOPd8GJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025878; c=relaxed/simple;
	bh=nQwehB4IFxzEYIYUmRyxwAa4z5O5GL4yGFG0yng04ds=;
	h=Date:To:From:Subject:Message-Id; b=cHbGmJdHFiRRmj8ZQxz6oyOUIynXZRNnliXczFRdXkWOuAun2eHpFA8HKirE400/12P+ouAKcIKxCFBE/EDre4JEML/x9Uida5/NXgykPTvJy4x9Uv6xOblaXcNp7b66aia5/YKLTKZ+SJW3FVt1XnJWj048bywz+0dpHvmpFBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rEsC7sVh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rEsC7sVh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A24C4CEF1;
	Mon, 24 Nov 2025 23:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025878;
	bh=nQwehB4IFxzEYIYUmRyxwAa4z5O5GL4yGFG0yng04ds=;
	h=Date:To:From:Subject:From;
	b=rEsC7sVhmrNqh4g3WO8AN3jZjO+njTgVlPH6oiLESDBhYtKLvqWfKOf+pMzFM9rnD
	 eUNmZt8tPkUoA+YftOZe6/YOdf1iP3DRC5TG2JylBDRv+ELEeRiOG+u9ihrUnV+N2H
	 YW7LluJNaIpogjkOarG+2GsrCJWjdCCnOm/h7tK0=
Date: Mon, 24 Nov 2025 15:11:17 -0800
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,youngjun.park@lge.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-fix-memory-leak-in-setup_clusters-error-path.patch removed from -mm tree
Message-Id: <20251124231118.61A24C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: fix memory leak in setup_clusters() error path
has been removed from the -mm tree.  Its filename was
     mm-swap-fix-memory-leak-in-setup_clusters-error-path.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Youngjun Park <youngjun.park@lge.com>
Subject: mm, swap: fix memory leak in setup_clusters() error path
Date: Fri, 31 Oct 2025 15:50:07 +0900

Patch series "mm: swap: small fixes and comment cleanups", v2.

This series provides a few small fixes and cleanups for the swap code.

The first patch fixes a memory leak in an error path that was recently
introduced. The subsequent patches include minor logic adjustments and
the removal of redundant comments.


This patch (of 5):

setup_clusters() could leak 'cluster_info' memory if an error occurred on
a path that did not jump to the 'err_free' label.

This patch simplifies the error handling by removing the goto label and
instead calling free_cluster_info() on all error exit paths.

The new logic is safe, as free_cluster_info() already handles NULL pointer
inputs.

Link: https://lkml.kernel.org/r/20251031065011.40863-1-youngjun.park@lge.com
Link: https://lkml.kernel.org/r/20251031065011.40863-2-youngjun.park@lge.com
Fixes: 07adc4cf1ecd ("mm, swap: implement dynamic allocation of swap table")
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Reviewed-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/swapfile.c~mm-swap-fix-memory-leak-in-setup_clusters-error-path
+++ a/mm/swapfile.c
@@ -3330,7 +3330,7 @@ static struct swap_cluster_info *setup_c
 		si->global_cluster = kmalloc(sizeof(*si->global_cluster),
 				     GFP_KERNEL);
 		if (!si->global_cluster)
-			goto err_free;
+			goto err;
 		for (i = 0; i < SWAP_NR_ORDERS; i++)
 			si->global_cluster->next[i] = SWAP_ENTRY_INVALID;
 		spin_lock_init(&si->global_cluster_lock);
@@ -3383,9 +3383,8 @@ static struct swap_cluster_info *setup_c
 	}
 
 	return cluster_info;
-err_free:
-	free_cluster_info(cluster_info, maxpages);
 err:
+	free_cluster_info(cluster_info, maxpages);
 	return ERR_PTR(err);
 }
 
_

Patches currently in -mm which might be from youngjun.park@lge.com are


