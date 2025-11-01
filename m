Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5BD8212FB3
	for <mm-commits@vger.kernel.org>; Sat,  1 Nov 2025 03:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761966542; cv=none; b=iJZgYrFOxfInKCZ94Tnj1KqpYOLhJOouREQsL/3v2+BTOmoBj+4ACUv3k59Z18uOxy8yx7dlnid+OiqDf1OzuZY/REfg7xSU2w4U84CxRPIv0/yfWT1mA1HdGkfx7G99mfVfP3W3zd7mrY//sPaPCpt/2hmPfpzdqOuBpa1acGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761966542; c=relaxed/simple;
	bh=px/Cw+D/rrx4jCvhawOahNPdl5BF9NsFUGCqahoO/a8=;
	h=Date:To:From:Subject:Message-Id; b=rRUyE4FVNxrgsbPxm/w5qxGCM72sRZIFSflqMsLhAFS46s6K0ReGu5c3tfGl+wI1hYGfJBUIRy1SQkmSGWo5LxOkHfLq+nUGJlmAzOjlLObC7jw3PRhS/wFHrlO8W1y3QW248J6iu7+zhT+NxMR4aAORDzO23xPWfytKHVXtFS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HSW8PNvB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HSW8PNvB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4169DC4CEE7;
	Sat,  1 Nov 2025 03:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761966542;
	bh=px/Cw+D/rrx4jCvhawOahNPdl5BF9NsFUGCqahoO/a8=;
	h=Date:To:From:Subject:From;
	b=HSW8PNvBBkjlrXg+CC17vI9CCgaZLbRe9obuBnzM/xqPQNMNB7D6ga20Z9hJuozHJ
	 lbEWKNOKUfLfPXsQ/A70l6k2RWZKtZ/VF2HjOmrgIALO7C6y+k3fbweuy844xRlLaq
	 lX3qhusYpTiWZ3coXdecV+QqPEP+N1Pr9I0oTyTY=
Date: Fri, 31 Oct 2025 20:09:01 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,youngjun.park@lge.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-remove-scan_swap_map_slots-references-from-comments.patch added to mm-new branch
Message-Id: <20251101030902.4169DC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: remove scan_swap_map_slots() references from comments
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-remove-scan_swap_map_slots-references-from-comments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-remove-scan_swap_map_slots-references-from-comments.patch

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
Subject: mm: swap: remove scan_swap_map_slots() references from comments
Date: Fri, 31 Oct 2025 15:50:11 +0900

The scan_swap_map_slots() helper has been removed, but several comments
still referred to it in swap allocation and reclaim paths.  This patch
cleans up those outdated references and reflows the affected comment
blocks to match kernel coding style.

Link: https://lkml.kernel.org/r/20251031065011.40863-6-youngjun.park@lge.com
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- a/mm/swapfile.c~mm-swap-remove-scan_swap_map_slots-references-from-comments
+++ a/mm/swapfile.c
@@ -236,11 +236,10 @@ again:
 	ret = -nr_pages;
 
 	/*
-	 * When this function is called from scan_swap_map_slots() and it's
-	 * called by vmscan.c at reclaiming folios. So we hold a folio lock
-	 * here. We have to use trylock for avoiding deadlock. This is a special
-	 * case and you should use folio_free_swap() with explicit folio_lock()
-	 * in usual operations.
+	 * We hold a folio lock here. We have to use trylock for
+	 * avoiding deadlock. This is a special case and you should
+	 * use folio_free_swap() with explicit folio_lock() in usual
+	 * operations.
 	 */
 	if (!folio_trylock(folio))
 		goto out;
@@ -1365,14 +1364,13 @@ start_over:
 		spin_lock(&swap_avail_lock);
 		/*
 		 * if we got here, it's likely that si was almost full before,
-		 * and since scan_swap_map_slots() can drop the si->lock,
 		 * multiple callers probably all tried to get a page from the
 		 * same si and it filled up before we could get one; or, the si
-		 * filled up between us dropping swap_avail_lock and taking
-		 * si->lock. Since we dropped the swap_avail_lock, the
-		 * swap_avail_head list may have been modified; so if next is
-		 * still in the swap_avail_head list then try it, otherwise
-		 * start over if we have not gotten any slots.
+		 * filled up between us dropping swap_avail_lock.
+		 * Since we dropped the swap_avail_lock, the swap_avail_list
+		 * may have been modified; so if next is still in the
+		 * swap_avail_head list then try it, otherwise start over if we
+		 * have not gotten any slots.
 		 */
 		if (plist_node_empty(&si->avail_list))
 			goto start_over;
_

Patches currently in -mm which might be from youngjun.park@lge.com are

mm-swap-fix-memory-leak-in-setup_clusters-error-path.patch
mm-swap-use-swp_solidstate-to-determine-if-swap-is-rotational.patch
mm-swap-remove-redundant-comment-for-read_swap_cache_async.patch
mm-swap-change-swap_alloc_slow-to-void.patch
mm-swap-remove-scan_swap_map_slots-references-from-comments.patch

