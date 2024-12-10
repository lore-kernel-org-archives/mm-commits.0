Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3C74F8A0
	for <mm-commits@vger.kernel.org>; Tue, 10 Dec 2024 05:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733808592; cv=none; b=ieswSh7jc36gtaswyebZu6VbztV1dEvQDcteR9Na1iJ+Kap+sT5HEr0KeovrRJI/te/a7Q5ihBvvpVbfNXdrEqRD0eqGuaPBfY/sBybC408QpWQoFt3bHq1cP4Ru2GULNrQB/DpLUX3BAljKLnBo5vj4H1lKX1tvTfEMyVYRA/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733808592; c=relaxed/simple;
	bh=G6RhURXl1Ql5r/ZT54MdW/n6nxtwdsw3/fT1hnDvuik=;
	h=Date:To:From:Subject:Message-Id; b=ht811L8xWTHi1Fua169s+qetnFJWutcm73khEhjZXVr4pqkVNuFP+BNYF9kCscbwRmKB/lGNCFl+vxF7i/ZPAhwYkkzozqctwys/m3u+w5/76jI9RlyTlGAx9Ep44G/0bznto3PDhGLZWWO8PxEepA3uCMolrUZbP292ZVJW00M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sqTHuXqE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sqTHuXqE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40DCCC4CED6;
	Tue, 10 Dec 2024 05:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733808592;
	bh=G6RhURXl1Ql5r/ZT54MdW/n6nxtwdsw3/fT1hnDvuik=;
	h=Date:To:From:Subject:From;
	b=sqTHuXqEpxZHo91bPGZ83gamBkBXIiLlaAb6+rrbMfklYtgaCp9YFSNvwXdaUZNs5
	 bVmIDcGc+RhMTbWvo81GmwFfn6sRTsA966r5cBOeIzmKY20nqQyPVwhJGw+LiGt3RK
	 pq+p61EP0ysjNyl2ViEXxT5P8UB+4JOQw5A/iR10=
Date: Mon, 09 Dec 2024 21:29:51 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,sj@kernel.org,sfr@canb.auug.org.au,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-tests-vaddr-kunith-reduce-stack-consumption-fix.patch added to mm-unstable branch
Message-Id: <20241210052952.40DCCC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-damon-tests-vaddr-kunith-reduce-stack-consumption-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-tests-vaddr-kunith-reduce-stack-consumption-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-vaddr-kunith-reduce-stack-consumption-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-damon-tests-vaddr-kunith-reduce-stack-consumption-fix
Date: Mon Dec  9 09:22:25 PM PST 2024

fix build

Cc: SeongJae Park <sj@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/vaddr-kunit.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/tests/vaddr-kunit.h~mm-damon-tests-vaddr-kunith-reduce-stack-consumption-fix
+++ a/mm/damon/tests/vaddr-kunit.h
@@ -68,7 +68,7 @@ static void damon_test_three_regions_in_
 	static struct mm_struct mm;
 	struct damon_addr_range regions[3] = {0};
 	/* 10-20-25, 200-210-220, 300-305, 307-330 */
-	static const struct vm_area_struct vmas[] = {
+	static struct vm_area_struct vmas[] = {
 		(struct vm_area_struct) {.vm_start = 10, .vm_end = 20},
 		(struct vm_area_struct) {.vm_start = 20, .vm_end = 25},
 		(struct vm_area_struct) {.vm_start = 200, .vm_end = 210},
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-account-for-free-pages-to-prevent-infinite-loop-in-throttle_direct_reclaim-checkpatch-fixes.patch
mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix.patch
mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix.patch
mm-introduce-mmap_lock_speculate_try_beginretry-fix.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption-fix.patch
mm-remove-an-avoidable-load-of-page-refcount-in-page_ref_add_unless-fix.patch
xarray-port-tests-to-kunit-fix.patch
fault-inject-use-prandom-where-cryptographically-secure-randomness-is-not-needed-fix.patch

