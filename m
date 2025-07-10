Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88FEFB660
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 03:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752119236; cv=none; b=FLSnYCMP41GLQ03TBjLbyIYL9FuYNgdbQqprdydhzE9KjJBdsWL/Bz9CCa7m4sCrwLUHaix56t0MQnA/yBsyMjC7rGaYD8YdxGqX2i0l0AIucBU8b7UtDpMt4vAHMhHjSuVW4QrXZvKwM/Ix0wl/nVRC9SyV9z8uo9/KLBC69BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752119236; c=relaxed/simple;
	bh=Ubnoj9FNaHUR7mOpoo94tho58/MAzyQwrAIfyoYVwN4=;
	h=Date:To:From:Subject:Message-Id; b=ee3uBODSzYXjD80F/CfszA6BIb1MQ0Bmj80AU/8NcR7iXvcvH4FQikL9fjerWEVnKhKkV30ECbyB1Lk2T3mlBMDxTNKcKgJ5PuQTamWXRzxJ+3ya1wGjfd/7qM0dXopW7YrvXxmmdtcHHCInlToK80H01BcAw0hWQGymrR7zars=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i9RRDRpB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i9RRDRpB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F1C2C4CEE3;
	Thu, 10 Jul 2025 03:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752119236;
	bh=Ubnoj9FNaHUR7mOpoo94tho58/MAzyQwrAIfyoYVwN4=;
	h=Date:To:From:Subject:From;
	b=i9RRDRpBLjclHABXwnjqAggmEsQaoxRobTuBqsXLMpMH4Uk/XHF7ezcaF9YlET1m8
	 kvMjk738nfAbtClnBiomaWn3fy+Q6jC22ZqVY96zIoTYD3Ra0eXCGYfZErQROgt8kZ
	 KDYpvcJDljpbx/LRriSDqgF3/c2qQruWZ4w1Ou5M=
Date: Wed, 09 Jul 2025 20:47:15 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,hughd@google.com,dev.jain@arm.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-swap-simplify-swapin-path-and-result-handling.patch added to mm-new branch
Message-Id: <20250710034716.0F1C2C4CEE3@smtp.kernel.org>
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
Date: Thu, 10 Jul 2025 11:37:04 +0800

Slightly tidy up the different handling of swap in and error handling for
SWP_SYNCHRONOUS_IO and non-SWP_SYNCHRONOUS_IO devices.  Now swapin will
always use either shmem_swap_alloc_folio or shmem_swapin_cluster, then
check the result.

Simplify the control flow and avoid a redundant goto label.

Link: https://lkml.kernel.org/r/20250710033706.71042-7-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
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
@@ -2320,40 +2320,33 @@ static int shmem_swapin_folio(struct ino
 			count_memcg_event_mm(fault_mm, PGMAJFAULT);
 		}
 
-		/* Skip swapcache for synchronous device. */
 		if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
+			/* Direct mTHP swapin skipping swap cache & readhaed */
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

mm-list_lru-refactor-the-locking-code.patch
mm-shmem-swap-improve-cached-mthp-handling-and-fix-potential-hung.patch
mm-shmem-swap-avoid-redundant-xarray-lookup-during-swapin.patch
mm-shmem-swap-tidy-up-thp-swapin-checks.patch
mm-shmem-swap-tidy-up-swap-entry-splitting.patch
mm-shmem-swap-never-use-swap-cache-and-readahead-for-swp_synchronous_io.patch
mm-shmem-swap-simplify-swapin-path-and-result-handling.patch
mm-shmem-swap-rework-swap-entry-and-index-calculation-for-large-swapin.patch
mm-shmem-swap-fix-major-fault-counting.patch

