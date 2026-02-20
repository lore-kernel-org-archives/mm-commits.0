Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11F63EBF28
	for <mm-commits@vger.kernel.org>; Fri, 20 Feb 2026 23:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771631143; cv=none; b=bFLDImIF1k1Od4U2ZiuoQUULl9zBQxa8hSo2yGYR4zIqtTthDaa4wxqfBA2Y+H554+yEkXY6FDL/UVQ2gfTaLumychhJPvk/wY4IqhEw3+QQ0twNap/BQr1cj1W/TtbAIQRGhEEsZjrrVE1ysihsJpOyemHW0QEf6hFdTPN6cm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771631143; c=relaxed/simple;
	bh=iX19pZg0p69hMMpq+5490Bp3dwFlVscheT+5IRQTbsA=;
	h=Date:To:From:Subject:Message-Id; b=RDjntXyDIrFcafxDBhKDJ6CZ6KToUW5q2IJ/OZGdlNKwlcoc6ARrNsREunP8028pP8V1B7/KRJCyb2NjfVZOTDwRmWUoDvK81XSOdHMunv+3C9HjFM12lB6SJWsbDrEI0u6HVT2uEzpHz7RJz9XOTmIHBMDgEBWQDQGs9kW08ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a1e/HOE9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a1e/HOE9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB26CC116C6;
	Fri, 20 Feb 2026 23:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771631142;
	bh=iX19pZg0p69hMMpq+5490Bp3dwFlVscheT+5IRQTbsA=;
	h=Date:To:From:Subject:From;
	b=a1e/HOE98L8OzVZGxE5DNfu6kmyF4rLLjAPJSeI/3xVcM+l01i+bte50F3/5hbe27
	 T4ToyhF+zfMtdLiqjY83mGTXqMfTB62U3zyIpxxlfPQ6nnlACZVOQfpwU70KHZYkbS
	 asGCoLioTKequnH/k020I+sj1xt4QTiwhqbN6BNU=
Date: Fri, 20 Feb 2026 15:45:42 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,nphamcs@gmail.com,hannes@cmpxchg.org,chrisl@kernel.org,chengming.zhou@linux.dev,bhe@redhat.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-remove-swp_synchronous_io-swapcache-bypass-workaround.patch added to mm-new branch
Message-Id: <20260220234542.AB26CC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: remove SWP_SYNCHRONOUS_IO swapcache bypass workaround
has been added to the -mm mm-new branch.  Its filename is
     mm-zswap-remove-swp_synchronous_io-swapcache-bypass-workaround.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-remove-swp_synchronous_io-swapcache-bypass-workaround.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/zswap: remove SWP_SYNCHRONOUS_IO swapcache bypass workaround
Date: Mon, 02 Feb 2026 01:47:32 +0800

Since commit f1879e8a0c60 ("mm, swap: never bypass the swap cache even for
SWP_SYNCHRONOUS_IO"), all swap-in operations go through the swap cache,
including those from SWP_SYNCHRONOUS_IO devices like zram.  Which means
the workaround for swap cache bypassing introduced by commit 25cd241408a2
("mm: zswap: fix data loss on SWP_SYNCHRONOUS_IO devices") is no longer
needed.  Remove it, but keep the comments that are still helpful.

Link: https://lkml.kernel.org/r/20260202-zswap-syncio-cleanup-v1-1-86bb24a64521@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Suggested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Chris Li <chrisl@kernel.org>
Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Baoquan He <bhe@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

--- a/mm/zswap.c~mm-zswap-remove-swp_synchronous_io-swapcache-bypass-workaround
+++ a/mm/zswap.c
@@ -1589,11 +1589,11 @@ int zswap_load(struct folio *folio)
 {
 	swp_entry_t swp = folio->swap;
 	pgoff_t offset = swp_offset(swp);
-	bool swapcache = folio_test_swapcache(folio);
 	struct xarray *tree = swap_zswap_tree(swp);
 	struct zswap_entry *entry;
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
+	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
 
 	if (zswap_never_enabled())
 		return -ENOENT;
@@ -1624,22 +1624,15 @@ int zswap_load(struct folio *folio)
 		count_objcg_events(entry->objcg, ZSWPIN, 1);
 
 	/*
-	 * When reading into the swapcache, invalidate our entry. The
-	 * swapcache can be the authoritative owner of the page and
+	 * We are reading into the swapcache, invalidate zswap entry.
+	 * The swapcache is the authoritative owner of the page and
 	 * its mappings, and the pressure that results from having two
 	 * in-memory copies outweighs any benefits of caching the
 	 * compression work.
-	 *
-	 * (Most swapins go through the swapcache. The notable
-	 * exception is the singleton fault on SWP_SYNCHRONOUS_IO
-	 * files, which reads into a private page and may free it if
-	 * the fault fails. We remain the primary owner of the entry.)
 	 */
-	if (swapcache) {
-		folio_mark_dirty(folio);
-		xa_erase(tree, offset);
-		zswap_entry_free(entry);
-	}
+	folio_mark_dirty(folio);
+	xa_erase(tree, offset);
+	zswap_entry_free(entry);
 
 	folio_unlock(folio);
 	return 0;
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-swap-speed-up-hibernation-allocation-and-writeout.patch
mm-swap-protect-si-swap_file-properly-and-use-as-a-mount-indicator.patch
mm-swap-clean-up-swapon-process-and-locking.patch
mm-swap-remove-redundant-arguments-and-locking-for-enabling-a-device.patch
mm-swap-consolidate-bad-slots-setup-and-make-it-more-robust.patch
mm-workingset-leave-highest-bits-empty-for-anon-shadow.patch
mm-swap-implement-helpers-for-reserving-data-in-the-swap-table.patch
mm-swap-mark-bad-slots-in-swap-table-directly.patch
mm-swap-simplify-swap-table-sanity-range-check.patch
mm-swap-use-the-swap-table-to-track-the-swap-count.patch
mm-swap-no-need-to-truncate-the-scan-border.patch
mm-swap-simplify-checking-if-a-folio-is-swapped.patch
mm-swap-no-need-to-clear-the-shadow-explicitly.patch
memcg-consolidate-private-id-refcount-get-put-helpers.patch
mm-shmem-remove-unnecessary-restrain-unmask-of-swap-gfp-flags.patch
mm-zswap-remove-swp_synchronous_io-swapcache-bypass-workaround.patch

