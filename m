Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BDD72874F5
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 16:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763657667; cv=none; b=gEfYZ+mFXYMHVUKktHUU/F1E/cZjIYtKxRg+/jJrWs2LvsbQucK5oBPtTPiLbvGwKlZ1VC6NtPdyWG1+yjplJvOVlKypwPheWrRDbd9U9CcwWb8yd/ygfkGe2dLnG3op4FDHqLhmmZXjyCpgoeMTLR/fUgIMp91sRs/X3LJLV7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763657667; c=relaxed/simple;
	bh=f3LtdjlF5MvlyOVlwCpnUsmNzedZPrR+0m3y2QC1Kso=;
	h=Date:To:From:Subject:Message-Id; b=osbMm4kDRybVBamZllkRgk81vzwmw7XaZRNlttA9BtEP/9eeSM3eueKY7zHtTs/8E2Ce0V2sHkI+A09yEJk3CEOOOWRVaifKtNP/GPRNi+fXEE9oJpjuAvcUalDgP7Fs9ZLeDnnwc7iwhZ3D7rwc3rP43xtQOd7z1SvY7wcL1m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=babCJRZs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="babCJRZs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA422C116C6;
	Thu, 20 Nov 2025 16:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763657666;
	bh=f3LtdjlF5MvlyOVlwCpnUsmNzedZPrR+0m3y2QC1Kso=;
	h=Date:To:From:Subject:From;
	b=babCJRZsCMgDqjA1aW5BZZeeEhXVMXrm5dQkOU0V0PvBsTZ26LtG2ddFul8aVmy64
	 fsOEK+SivoU1p0YHR1Sdz3ZBOzUNAQAbSbQ0/Z3RLpjrL3+2gh/0epXjabKR367/hw
	 0a3AJunfr9ZmZMKD59qzjnUK1KDMgF4ratnIwPz4=
Date: Thu, 20 Nov 2025 08:54:25 -0800
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,youngjun.park@lge.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-fix-memory-leak-in-setup_clusters-error-path.patch added to mm-new branch
Message-Id: <20251120165426.BA422C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: fix memory leak in setup_clusters() error path
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-fix-memory-leak-in-setup_clusters-error-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-fix-memory-leak-in-setup_clusters-error-path.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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

mm-swap-remove-duplicate-nr_swap_pages-decrement-in-get_swap_page_of_type.patch
mm-swap-fix-wrong-plist-empty-check-in-swap_alloc_slow.patch
mm-swap-fix-memory-leak-in-setup_clusters-error-path.patch
mm-swap-use-swp_solidstate-to-determine-if-swap-is-rotational.patch
mm-swap-remove-redundant-comment-for-read_swap_cache_async.patch
mm-swap-change-swap_alloc_slow-to-void.patch
mm-swap-remove-scan_swap_map_slots-references-from-comments.patch

