Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793640154;
	b=0g+MYQqrdXw2FRSigK5nZBqBFgmj6iSBiNRmuaY4K1NLoc4+eA9YVIUv8vECGrRTLXaB
	 VDdT64pTGdDrnL8GKiA//wsTtCFXQG7a4GZ4/PnfOgoM9MOltlsQetnZGgmZLBXUS4fTs
	 O0hXl7jWELk25a/SUJ6h5wVQiLTEd648kJFE2a3V46QYrw41LTQgnsmzigeY24dUX8Z+n
	 fKopuaBFzrsv2dC6+ljwsC7f5yhoRvF57ekAQkoL2s11c8wXk5bbWfHhYtgvOdimlUYvg
	 Ccj+nTSnCa00BZ3NIeGaUWWKdfmaF+pXPK7H8hKmkQs52KZ6LcaX91WarS/cRb+piGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793640154;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=WlX270F3npf3jYQyTbjXF7gI4rs8nokd2Stlv5Sa2ws=;
	b=Cybtdo2l+FwiBBtGBk/W6ZO5JD9+9xbp6OhTorS5aWgsBIaSbUtJw7eL2BNNc1TnKYqp
	 9bT07kMZjLgMzJLoiIK1e4JW7X2qMobMoCP61Pfa4+Iy7ySeKfuOf7qg9BfFTwo0qfPYq
	 SqBjVfCwJtuX/5YoseBi3kHJwkrIEOvAp0U1Gwz/SZd2LZbiLHNgSRXLwC/IlTjBEOx1v
	 IYJPs/Hb5PBrkSj6veGZaAuegHQJYSHle+6FPtDHYEfWdyoAehTeMGgcnjaccxF8VY4Ro
	 pgI/6TIcZpqzSn4CDhQthJUvMRSac2v7wjutArFpTblqLc46K7L/ZCknayJxSLAYZ0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WiY7u3pP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881BE606B1CD
	for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2026 17:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WiY7u3pP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4CA1F00A16;
	Mon,  2 Nov 2026 17:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793640154;
	bh=WlX270F3npf3jYQyTbjXF7gI4rs8nokd2Stlv5Sa2ws=;
	h=Date:To:From:Subject;
	b=WiY7u3pPGNkhxQ87mw/XXVN0EkhFbNlw9nsP9gSs1kUCYF6aWU0EZRM3fYQrTGTOa
	 rOVCMIeaahnn3tOWWtFexmVjl+Y5bpLruV+KRmo7kGYiNDLe7Y/oIJkQWEkhJpCSSW
	 RR8jNU5CYVrov6vlQK9m8JVd8TxVLRSyEQsrNBZE=
Date: Mon, 02 Nov 2026 09:22:23 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,suhaas@s-joshi.in,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-use-only-installed-probe-in-damon_merge_two_regions.patch added to mm-new branch
Message-Id: <20261102172233.EC4CA1F00A16@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/core: use only installed probe in damon_merge_two_regions()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-use-only-installed-probe-in-damon_merge_two_regions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-use-only-installed-probe-in-damon_merge_two_regions.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Suhaas Joshi <suhaas@s-joshi.in>
Subject: mm/damon/core: use only installed probe in damon_merge_two_regions()
Date: Mon, 02 Nov 2026 07:37:51 -0800

Patch series "mm/damon/core: iterate over installed probes instead of
DAMON_MAX_PROBES", v5.

There were two "todo: " items of the same nature in mm/damon/core.c.
Both of these suggested that we should iterate over only installed
probes while updating (last_)probe_hits[] during merging/splitting
regions, instead of iterating over the entire array, which may have
empty/unused indices.

So this patch series does exactly that. It replaces the for-loop over
[0, DAMON_MAX_PROBES) with a damon_for_each_probe() over the probe list
of the context.

Reviewer note.

These patches are based off mm-new. They pass all KUnit tests related to
damon. I have boot tested (but nothing beyond) on qemu-x86_64. Please do
let me know if I should do any specific tests and link the logs here.

The series has been tested with mm-new fetched on Oct 14, 2026.


This patch (of 2):

While merging 2 regions, we iterate over the entire probe_hits[] array,
whose size is determined by the DAMON_MAX_PROBES macro. However, it is
possible that we have fewer probes installed than DAMON_MAX_PROBES. In such
cases, we end up making redundant iterations. Therefore, to remedy this,
iterate over the list of installed probes instead of iterating over the
entire array. For doing this, start accepting a struct damon_ctx in
damon_merge_two_regions(), and update calling functions to pass this
argument.

Update the damon_test_merge_two() test to use this new signature for
damon_merge_two_regions() as well.

Link: https://lore.kernel.org/20261102153753.97769-1-sj@kernel.org
Link: https://lore.kernel.org/20261102153753.97769-2-sj@kernel.org
Signed-off-by: Suhaas Joshi <suhaas@s-joshi.in>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
---

 mm/damon/core.c             |   15 ++++++++++-----
 mm/damon/tests/core-kunit.h |   20 ++++++++++++++++++--
 2 files changed, 28 insertions(+), 7 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-use-only-installed-probe-in-damon_merge_two_regions
+++ a/mm/damon/core.c
@@ -3554,20 +3554,25 @@ static void damon_verify_merge_two_regio
 /*
  * Merge two adjacent regions into one region
  */
-static void damon_merge_two_regions(struct damon_target *t,
-		struct damon_region *l, struct damon_region *r)
+static void damon_merge_two_regions(struct damon_ctx *ctx,
+		struct damon_target *t, struct damon_region *l,
+		struct damon_region *r)
 {
 	unsigned long sz_l = damon_sz_region(l), sz_r = damon_sz_region(r);
 	int i;
+	struct damon_probe *p;
 
 	l->nr_accesses = (l->nr_accesses * sz_l + r->nr_accesses * sz_r) /
 			(sz_l + sz_r);
 	l->age = (l->age * sz_l + r->age * sz_r) / (sz_l + sz_r);
 	l->ar.end = r->ar.end;
-	/* todo: do this for only installed probes */
-	for (i = 0; i < DAMON_MAX_PROBES; i++)
+
+	i = 0;
+	damon_for_each_probe(p, ctx) {
 		l->probe_hits[i] = (l->probe_hits[i] * sz_l + r->probe_hits[i]
 				* sz_r) / (sz_l + sz_r);
+		++i;
+	}
 	damon_verify_merge_two_regions(l, r);
 	damon_destroy_region(r, t);
 }
@@ -3620,7 +3625,7 @@ static void damon_merge_regions_of(struc
 			goto set_prev_continue;
 		if (damon_sz_region(prev) + damon_sz_region(r) > sz_limit)
 			goto set_prev_continue;
-		damon_merge_two_regions(t, prev, r);
+		damon_merge_two_regions(ctx, t, prev, r);
 		continue;
 set_prev_continue:
 		prev = r;
--- a/mm/damon/tests/core-kunit.h~mm-damon-core-use-only-installed-probe-in-damon_merge_two_regions
+++ a/mm/damon/tests/core-kunit.h
@@ -182,6 +182,8 @@ static void damon_test_merge_two(struct
 {
 	struct damon_target *t;
 	struct damon_region *r, *r2, *r3;
+	struct damon_probe *p;
+	struct damon_ctx *ctx;
 	int i;
 
 	t = damon_new_target();
@@ -206,7 +208,21 @@ static void damon_test_merge_two(struct
 	r2->age = 21;
 	damon_add_region(r2, t);
 
-	damon_merge_two_regions(t, r, r2);
+	p = damon_new_probe();
+	if (!p) {
+		damon_free_target(t);
+		kunit_skip(test, "probe alloc fail");
+	}
+	ctx = damon_new_ctx();
+	if (!ctx) {
+		damon_destroy_probe(p);
+		damon_free_target(t);
+		kunit_skip(test, "context alloc fail");
+	}
+	damon_add_probe(ctx, p);
+	damon_add_target(ctx, t);
+
+	damon_merge_two_regions(ctx, t, r, r2);
 	KUNIT_EXPECT_EQ(test, r->ar.start, 0ul);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 300ul);
 	KUNIT_EXPECT_EQ(test, r->nr_accesses, 16u);
@@ -220,7 +236,7 @@ static void damon_test_merge_two(struct
 	}
 	KUNIT_EXPECT_EQ(test, i, 1);
 
-	damon_free_target(t);
+	damon_destroy_ctx(ctx);
 }
 
 static struct damon_region *__nth_region_of(struct damon_target *t, int idx)
_

Patches currently in -mm which might be from suhaas@s-joshi.in are

mm-damon-core-use-only-installed-probe-in-damon_merge_two_regions.patch

