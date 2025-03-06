Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC31199E88
	for <mm-commits@vger.kernel.org>; Thu,  6 Mar 2025 03:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741233305; cv=none; b=ehxYI+lEqv+bjw/IsuDpQdeEHb7PFrHOcqRdbE19VwnWLGGtxaP6DI9mg6ZQvQyMg+LR0gMlw9cBsVRCJh0C5PZzHacsrjdAQsPTUrj9gaN84tZhafrwLjiJELf9e+Xcf/eNVNaEut2sKzmBy1/P2/BtzC4gd/KN/UPBKT6ykUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741233305; c=relaxed/simple;
	bh=0KdkShzPK9lIxwEkfjwXOaWvkX7xxLi6ikmViVfSlxE=;
	h=Date:To:From:Subject:Message-Id; b=kl1THhDTNK8Gzlk8RzPXtcnG2J6FJ8w86XT3L5clfDvjz6TbupO+mTRrZAUhH00vP08Hu4vE23xFcjUSH48IGWn9Y/GVVGi96l7yEXLBda0l5wqDVD8YoFSGi2vc1EmW67DYxDQDNCQ/8k0PQ32s6pGJA3nwpB9bJWSruk5yTiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=git7kY6v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="git7kY6v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3C2C4CEE4;
	Thu,  6 Mar 2025 03:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741233305;
	bh=0KdkShzPK9lIxwEkfjwXOaWvkX7xxLi6ikmViVfSlxE=;
	h=Date:To:From:Subject:From;
	b=git7kY6vlFL9H1/eOY03Y3Q3fdUd76Tu9pgPD/B1+Ny0plCHA5HcfiOIDJuIcUWGY
	 gRCFlRwIzCz96MTtWgzGJjMuRKxVleWaMTi/HsKSKCgN5pO/4CZY3v6x2m7/hm8S6d
	 hnSnT4YforWxfEKhkwLhtTw3+TY1830ou87IQ7fA=
Date: Wed, 05 Mar 2025 19:55:04 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] userfaultfd-do-not-block-on-locking-a-large-folio-with-raised-refcount-fix.patch removed from -mm tree
Message-Id: <20250306035504.DD3C2C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfaultfd-do-not-block-on-locking-a-large-folio-with-raised-refcount-fix
has been removed from the -mm tree.  Its filename was
     userfaultfd-do-not-block-on-locking-a-large-folio-with-raised-refcount-fix.patch

This patch was dropped because it was folded into userfaultfd-do-not-block-on-locking-a-large-folio-with-raised-refcount.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: userfaultfd-do-not-block-on-locking-a-large-folio-with-raised-refcount-fix
Date: Wed Feb 26 01:50:26 PM PST 2025

reflow comment to 80 cols, s/end/end up/

Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-do-not-block-on-locking-a-large-folio-with-raised-refcount-fix
+++ a/mm/userfaultfd.c
@@ -1272,11 +1272,11 @@ retry:
 
 			locked = folio_trylock(folio);
 			/*
-			 * We avoid waiting for folio lock with a raised refcount
-			 * for large folios because extra refcounts will result in
-			 * split_folio() failing later and retrying. If multiple
-			 * tasks are trying to move a large folio we can end
-			 * livelocking.
+			 * We avoid waiting for folio lock with a raised
+			 * refcount for large folios because extra refcounts
+			 * will result in split_folio() failing later and
+			 * retrying.  If multiple tasks are trying to move a
+			 * large folio we can end up livelocking.
 			 */
 			if (!locked && folio_test_large(folio)) {
 				spin_unlock(src_ptl);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

userfaultfd-do-not-block-on-locking-a-large-folio-with-raised-refcount.patch
mm-vmscan-extract-calculated-pressure-balance-as-a-function-fix.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise-fix-checkpatch-fixes.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise-fix.patch
selftests-mm-print-some-details-when-uffd-stress-gets-bad-params-fix.patch
selftests-mm-dont-fail-uffd-stress-if-too-many-cpus-fix.patch
mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2-fix.patch
mm-mremap-initial-refactor-of-move_vma-fix.patch
mm-mremap-thread-state-through-move-page-table-operation-fix.patch
mm-hugetlb-add-hugetlb_alloc_threads-cmdline-option-fix.patch
lib-plistc-add-shortcut-for-plist_requeue-fix.patch
scsi-lpfc-convert-timeouts-to-secs_to_jiffies-fix.patch
signal-avoid-clearing-tif_sigpending-in-recalc_sigpending-if-unset-fix.patch

