Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4A72505CE
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 18:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754160883; cv=none; b=dI5qeRKIs17mqjvrFrngXTtePSsODYJmO8eLP2/qYyPw0NnXgqqAAOkY37VI001/pstd3b1Lcs3/e2+dvecg5g2v+aPOLWPfqs+Sc6DJKqYsoyZFEWaQEivz5WPHtcE8R5rKFIw6OxWJf6l6fkOVUrrQR/ZRmHCGf1gJSFZf410=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754160883; c=relaxed/simple;
	bh=y4hoA6rdHeQ2OYumH35FBQmsxjihHoApathkf2N8vB4=;
	h=Date:To:From:Subject:Message-Id; b=TAqGIbfXkOGbY0Wt80/Qx9S5ECwVOxbUvatlS07OhERUbvTXZuu1Enhxi27uwvW3vQuUX0+Psyi2ysbu9/6LNYi5odrbp9VeR4UP/TQMTQesSoAMpJlWzICKXEwzPe/NXCZdHbrCc73PM1McNQOSrkaJFqv6ebnA4gMqQ6DpGoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lB2szsev; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lB2szsev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD96C4CEEF;
	Sat,  2 Aug 2025 18:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754160883;
	bh=y4hoA6rdHeQ2OYumH35FBQmsxjihHoApathkf2N8vB4=;
	h=Date:To:From:Subject:From;
	b=lB2szsevsUGB4bRP+8b0ZVutYmc/U6Au6K0NobCr4ihwZDH4lWynCnGSgSB+J1iNA
	 BVLGuOdTIx6STBbrQdR7T5fcYty22aD/WjCA31xqNDNBR2bEimUlDfwbpQpbxcwnol
	 RgLA0uBvt0+jmOiyf24gmi4NERx7XYQer9qatLjA=
Date: Sat, 02 Aug 2025 11:54:43 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,hughd@google.com,dev.jain@arm.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-swap-simplify-swapin-path-and-result-handling.patch removed from -mm tree
Message-Id: <20250802185443.AFD96C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/shmem, swap: simplify swapin path and result handling
has been removed from the -mm tree.  Its filename was
     mm-shmem-swap-simplify-swapin-path-and-result-handling.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/shmem, swap: simplify swapin path and result handling
Date: Mon, 28 Jul 2025 15:53:04 +0800

Slightly tidy up the different handling of swap in and error handling for
SWP_SYNCHRONOUS_IO and non-SWP_SYNCHRONOUS_IO devices.  Now swapin will
always use either shmem_swap_alloc_folio or shmem_swapin_cluster, then
check the result.

Simplify the control flow and avoid a redundant goto label.

Link: https://lkml.kernel.org/r/20250728075306.12704-7-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   45 +++++++++++++++++++--------------------------
 1 file changed, 19 insertions(+), 26 deletions(-)

--- a/mm/shmem.c~mm-shmem-swap-simplify-swapin-path-and-result-handling
+++ a/mm/shmem.c
@@ -2357,40 +2357,33 @@ static int shmem_swapin_folio(struct ino
 			count_memcg_event_mm(fault_mm, PGMAJFAULT);
 		}
 
-		/* Skip swapcache for synchronous device. */
 		if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
+			/* Direct swapin skipping swap cache & readahead */
 			folio = shmem_swap_alloc_folio(inode, vma, index, swap, order, gfp);
-			if (!IS_ERR(folio)) {
-				skip_swapcache = true;
-				goto alloced;
+			if (IS_ERR(folio)) {
+				error = PTR_ERR(folio);
+				folio = NULL;
+				goto failed;
 			}
-
+			skip_swapcache = true;
+		} else {
 			/*
-			 * Direct swapin handled order 0 fallback already,
-			 * if it failed, abort.
+			 * Cached swapin only supports order 0 folio, it is
+			 * necessary to recalculate the new swap entry based on
+			 * the offset, as the swapin index might be unalgined.
 			 */
-			error = PTR_ERR(folio);
-			folio = NULL;
-			goto failed;
-		}
-
-		/*
-		 * Now swap device can only swap in order 0 folio, it is
-		 * necessary to recalculate the new swap entry based on
-		 * the offset, as the swapin index might be unalgined.
-		 */
-		if (order) {
-			offset = index - round_down(index, 1 << order);
-			swap = swp_entry(swp_type(swap), swp_offset(swap) + offset);
-		}
+			if (order) {
+				offset = index - round_down(index, 1 << order);
+				swap = swp_entry(swp_type(swap), swp_offset(swap) + offset);
+			}
 
-		folio = shmem_swapin_cluster(swap, gfp, info, index);
-		if (!folio) {
-			error = -ENOMEM;
-			goto failed;
+			folio = shmem_swapin_cluster(swap, gfp, info, index);
+			if (!folio) {
+				error = -ENOMEM;
+				goto failed;
+			}
 		}
 	}
-alloced:
 	if (order > folio_order(folio)) {
 		/*
 		 * Swapin may get smaller folios due to various reasons:
_

Patches currently in -mm which might be from kasong@tencent.com are


