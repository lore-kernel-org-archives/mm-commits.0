Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D20C18C03F
	for <mm-commits@vger.kernel.org>; Sat,  1 Nov 2025 03:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761966534; cv=none; b=AcL0eIwWd1yvZa6Wi969cDDh39ljqPd/kJSb3YkQ+wCDUnzByjG/0UIBsB9D0Cj0dS5hJruG/RkB7Z1fwop8VszvpWQsUBPmX4kMRnJErPSWVMPVDQPWUMrhjVBVOTzgdHEzr0DfyyB5z3QdfkEHnk0AvV3dRCHMOP0BOo0GUYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761966534; c=relaxed/simple;
	bh=o3beqTDiPbLcE06D/LtWI7W7LSmEC+ayNy2vzXYwcco=;
	h=Date:To:From:Subject:Message-Id; b=LYFBYhL1pOsDrGNIwK6Vz+57m937ZsN+/0aoyJ5sgsDYXyA76KWXmfbdaBwhUmi4Vs9/DPFstP/ZDrsrRZEZ+VuLFNSxT7Uh3cV9+GQ14Kl7AdoVAQ0LZ1Q0hzyq1djMj8q3PWRPDMMpfT6VNhzIhYGn10W3LwWsoeNs83DD7Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zNY5Skpt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zNY5Skpt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D6FC4CEE7;
	Sat,  1 Nov 2025 03:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761966534;
	bh=o3beqTDiPbLcE06D/LtWI7W7LSmEC+ayNy2vzXYwcco=;
	h=Date:To:From:Subject:From;
	b=zNY5SkptjHz4Neu12k0zLhGNhUo8U6t+osCM/W3SZmfbfG/ODGNuAl64RkvCeioQc
	 aN4REJUPtzQUo7cPIRyW/O5OsfEWepNgE1hswxePLK3lK5cqGqUDLFHc3prtnmpjNj
	 xQ4yK6y2NX52EVVeS6rrz/pFMFrv7i0JyXMybEfM=
Date: Fri, 31 Oct 2025 20:08:53 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,youngjun.park@lge.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-fix-memory-leak-in-setup_clusters-error-path.patch added to mm-new branch
Message-Id: <20251101030853.E4D6FC4CEE7@smtp.kernel.org>
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
@@ -3324,7 +3324,7 @@ static struct swap_cluster_info *setup_c
 		si->global_cluster = kmalloc(sizeof(*si->global_cluster),
 				     GFP_KERNEL);
 		if (!si->global_cluster)
-			goto err_free;
+			goto err;
 		for (i = 0; i < SWAP_NR_ORDERS; i++)
 			si->global_cluster->next[i] = SWAP_ENTRY_INVALID;
 		spin_lock_init(&si->global_cluster_lock);
@@ -3377,9 +3377,8 @@ static struct swap_cluster_info *setup_c
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

mm-swap-fix-memory-leak-in-setup_clusters-error-path.patch
mm-swap-use-swp_solidstate-to-determine-if-swap-is-rotational.patch
mm-swap-remove-redundant-comment-for-read_swap_cache_async.patch
mm-swap-change-swap_alloc_slow-to-void.patch
mm-swap-remove-scan_swap_map_slots-references-from-comments.patch

