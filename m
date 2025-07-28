Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D308218AB4
	for <mm-commits@vger.kernel.org>; Mon, 28 Jul 2025 22:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753740325; cv=none; b=kz++sh9sF1e8U1uZ76WtXMz/seEsZGYchayFrksOuGy6axFH/EaCQbQ+u+2CLm0XenlrdQ3zqbZiWlQDjf18XDK1vQaYzM3Ffk2nv6ogDd3DAfa7COQjZaGQ0yJYvgjZo0Jmj4XcfHLhBruM7ZUb7gAbIIQj9yc7wsfMza0pfSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753740325; c=relaxed/simple;
	bh=X/tzThxrylMD2TmHuCsgGyaeh15N6azgsElRezNbwtc=;
	h=Date:To:From:Subject:Message-Id; b=V5yOWwg0FZVht+mx/WTj4Sa+OobPyq+3ThIO2T8m/wZjtsdO+4EsrLjdg2YP38zyBKH7XOy2QKtacLURns7D4Vf+/Uv90BDc9PGBuOAb+ph30mDI5KUs3bwWX966pARJSNcWkCvykzEzSpA3p20J28Gg/SSQx8H7mUX3afw/P80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FCB+apLP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FCB+apLP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA4CC4CEE7;
	Mon, 28 Jul 2025 22:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753740324;
	bh=X/tzThxrylMD2TmHuCsgGyaeh15N6azgsElRezNbwtc=;
	h=Date:To:From:Subject:From;
	b=FCB+apLPmj5TWlP6Lg0foBAogmy6BrgDVKUtavcfVYcUJ17JZdZRrcjuKWwGHBEsV
	 3N+Ou5PnBqU56RMNBWmf5uLcXVY6yf/Lou1HHSmAxpZmKmp2W7ar4NDXgo5D2avjJF
	 VGr1v/qm1R9PO/QOprXZQwZgSmQfYeTfZnYDib4U=
Date: Mon, 28 Jul 2025 15:05:24 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,hughd@google.com,dev.jain@arm.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-swap-simplify-swapin-path-and-result-handling.patch added to mm-new branch
Message-Id: <20250728220524.CAA4CC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem, swap: simplify swapin path and result handling
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-swap-simplify-swapin-path-and-result-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-swap-simplify-swapin-path-and-result-handling.patch

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

mm-shmem-swap-improve-cached-mthp-handling-and-fix-potential-hang.patch
mm-shmem-swap-avoid-redundant-xarray-lookup-during-swapin.patch
mm-shmem-swap-tidy-up-thp-swapin-checks.patch
mm-shmem-swap-tidy-up-swap-entry-splitting.patch
mm-shmem-swap-never-use-swap-cache-and-readahead-for-swp_synchronous_io.patch
mm-shmem-swap-simplify-swapin-path-and-result-handling.patch
mm-shmem-swap-rework-swap-entry-and-index-calculation-for-large-swapin.patch
mm-shmem-swap-fix-major-fault-counting.patch

