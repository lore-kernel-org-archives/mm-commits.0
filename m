Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544D418DF8F
	for <mm-commits@vger.kernel.org>; Tue, 30 Jul 2024 22:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722379663; cv=none; b=OLTx+PhZ0qtuBZ0KgKJwQmg1isqSsECg2Gl+saBQiniSqwuLriQEzbAZ/jd8TIOuVDMIqMOcNA608D9xLn3XQ22keZBBluA0+KyYKHMw4vLulWcLo7KGJOGfEKmfseFNOGTN4Wr7Xdup/h5cmtvOSfc1wtNo/CJGkoLLA50/8jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722379663; c=relaxed/simple;
	bh=WUDTJQy2iFbBa69Wf8VOAAhpwfx3xlsRvGyMq1A53QQ=;
	h=Date:To:From:Subject:Message-Id; b=We2iz3dcCCxH42VsbQMx1glOVRN01hlUZWHQTU3QjjkUdZqScYvG6friWWIxr6oc0bhVE+q9FpM1MZzSVmSqzML+SnW2uCyxAR2Ru3gY5VoNi3L3lsYUH60FBXTxJRA1KvCYqb/1S+ff6ou+dswOdFujmO3K5ONHliwp56S48wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=evrN7UIL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="evrN7UIL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B810CC32782;
	Tue, 30 Jul 2024 22:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722379662;
	bh=WUDTJQy2iFbBa69Wf8VOAAhpwfx3xlsRvGyMq1A53QQ=;
	h=Date:To:From:Subject:From;
	b=evrN7UILqPEcOzmGFhL94/nzfpfMWOttwnGRh5dqTHQ+ld3ppCJb4ByCwShQYU9EA
	 wRDlVpwpA8q6PYynh+7SqnAD2N46O+6gIyrVZqpGhHKg5ypb1+SRMmrlLwnudA4iuP
	 64TbR0auV1iU/7uZOElvyXn4txHC9X3eTQoDjaI0=
Date: Tue, 30 Jul 2024 15:47:42 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeel.butt@linux.dev,hannes@cmpxchg.org,chengming.zhou@linux.dev,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zswap-increment-swapin-count-for-non-pivot-swapped-in-pages.patch added to mm-unstable branch
Message-Id: <20240730224742.B810CC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zswap: increment swapin count for non-pivot swapped in pages
has been added to the -mm mm-unstable branch.  Its filename is
     zswap-increment-swapin-count-for-non-pivot-swapped-in-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zswap-increment-swapin-count-for-non-pivot-swapped-in-pages.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Nhat Pham <nphamcs@gmail.com>
Subject: zswap: increment swapin count for non-pivot swapped in pages
Date: Tue, 30 Jul 2024 15:27:07 -0700

Currently, we only increment the swapin counter on pivot pages.  This
means we are not taking into account pages that also need to be swapped
in, but are already taken care of as part of the readahead window.  We are
also incrementing when the pages are read from the zswap pool, which is
inaccurate.

This patch rectifies this issue by incrementing whenever we need to
perform a non-zswap read.

To test this change, I built the kernel under a cgroup with its
memory.max set to 2 GB:

real: 236.66s
user: 4286.06s
sys: 652.86s
swapins: 81552

For comparison, with just the new second chance algorithm, the build
time is as follows:

real: 244.85s
user: 4327.22s
sys: 664.39s
swapins: 94663

Without either:

real: 263.89s
user: 4318.11s
sys: 673.29s
swapins: 227300.5

(average over 5 runs)

With this change, the kernel CPU time reduces by a further 1.7%, and the
real time is reduced by another 3.3%, compared to just the second chance
algorithm by itself.  The swapins count also reduces by another 13.85%.

Combining the two changes, we reduce the real time by 10.32%, kernel CPU
time by 3%, and number of swapins by 64.12%.

To gauge the new scheme's ability to offload cold data, I ran another
benchmark, in which the kernel was built under a cgroup with memory.max
set to 3 GB, but with 0.5 GB worth of cold data allocated before each
build (in a shmem file).

Under the old scheme:

real: 197.18s
user: 4365.08s
sys: 289.02s
zswpwb: 72115.2

Under the new scheme:

real: 195.8s
user: 4362.25s
sys: 290.14s
zswpwb: 87277.8

(average over 5 runs)

Notice that we actually observe a 21% increase in the number of written
back pages - so the new scheme is just as good, if not better at
offloading pages from the zswap pool when they are cold.  Build time
reduces by around 0.7% as a result.

Link: https://lkml.kernel.org/r/20240730222707.2324536-3-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c    |   11 ++++++++++-
 mm/swap_state.c |    8 ++------
 2 files changed, 12 insertions(+), 7 deletions(-)

--- a/mm/page_io.c~zswap-increment-swapin-count-for-non-pivot-swapped-in-pages
+++ a/mm/page_io.c
@@ -521,7 +521,15 @@ void swap_read_folio(struct folio *folio
 
 	if (zswap_load(folio)) {
 		folio_unlock(folio);
-	} else if (data_race(sis->flags & SWP_FS_OPS)) {
+		goto finish;
+	}
+
+	/*
+	 * We have to read the page from slower devices. Increase zswap protection.
+	 */
+	zswap_folio_swapin(folio);
+
+	if (data_race(sis->flags & SWP_FS_OPS)) {
 		swap_read_folio_fs(folio, plug);
 	} else if (synchronous) {
 		swap_read_folio_bdev_sync(folio, sis);
@@ -529,6 +537,7 @@ void swap_read_folio(struct folio *folio
 		swap_read_folio_bdev_async(folio, sis);
 	}
 
+finish:
 	if (workingset) {
 		delayacct_thrashing_end(&in_thrashing);
 		psi_memstall_leave(&pflags);
--- a/mm/swap_state.c~zswap-increment-swapin-count-for-non-pivot-swapped-in-pages
+++ a/mm/swap_state.c
@@ -698,10 +698,8 @@ skip:
 	/* The page was likely read above, so no need for plugging here */
 	folio = __read_swap_cache_async(entry, gfp_mask, mpol, ilx,
 					&page_allocated, false);
-	if (unlikely(page_allocated)) {
-		zswap_folio_swapin(folio);
+	if (unlikely(page_allocated))
 		swap_read_folio(folio, NULL);
-	}
 	return folio;
 }
 
@@ -850,10 +848,8 @@ skip:
 	/* The folio was likely read above, so no need for plugging here */
 	folio = __read_swap_cache_async(targ_entry, gfp_mask, mpol, targ_ilx,
 					&page_allocated, false);
-	if (unlikely(page_allocated)) {
-		zswap_folio_swapin(folio);
+	if (unlikely(page_allocated))
 		swap_read_folio(folio, NULL);
-	}
 	return folio;
 }
 
_

Patches currently in -mm which might be from nphamcs@gmail.com are

zswap-implement-a-second-chance-algorithm-for-dynamic-zswap-shrinker.patch
zswap-increment-swapin-count-for-non-pivot-swapped-in-pages.patch

