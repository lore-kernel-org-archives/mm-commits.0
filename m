Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0A63B992C;
	Fri,  7 Aug 2026 02:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068129; cv=none; b=f3KOHBzJ8VqVeBfpCW9tBXPG0ci4F9rWHryIKO8TH02yftpgpPKOPO7sz2EajPaTcB5X9dUGJRqGdf0aF3r62/oKeKe8A0wK4elh4beDbZ0o/9bMjN+Fvs4m3pGNUponUZP3ykO580sHs0fibqgrlfSwNPdnM1MAoJKzhNbXZkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068129; c=relaxed/simple;
	bh=9mVDisbw1UCdxYMW5ndA7+tUS1d1gj/Y+UL4qSB3nV4=;
	h=Date:To:From:Subject:Message-Id; b=V2Ct0WI3IpBm2bwsyCSs2P4Ij4keaHMKY4QDnwT5ZI4C3FJUaSTYQp5ciSjfYBF3P6c35JmO3Lu5IUnMjwTWypNMPrqyvAu/1rW8NOJ9ZTAgExDNUcIbyhVbuZsWrQLrvccYg7bTVY2Q+rzikfL4rbWrDWgW7lTz9SzXM/ZT+qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GhNBldyT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GhNBldyT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 513251F000E9;
	Fri,  7 Aug 2026 02:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068127;
	bh=/8C1/32h4IHYznYPaPftABoCl+KZZodfC2qhpIFV4Mw=;
	h=Date:To:From:Subject;
	b=GhNBldyTEXlh2Y2DlkTUrV5zbM3lgj2Gg6Q2Iqp/+7hJPQAge+ixQ+QVBRH2awKD3
	 YWdgVnRmjGOmPB/crUKsMPXOgbvpYGovFnmYZ87i6783xWrX16KL/U3MeAuuyU1uOj
	 QLUK83ig2D6CHSa79quApucUegbyOK49LcKjBt/s=
Date: Thu, 06 Aug 2026 19:02:06 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-handle-region-split-failure-in-apply_min_nr_regions.patch removed from -mm tree
Message-Id: <20260807020207.513251F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: handle region split failure in apply_min_nr_regions()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-handle-region-split-failure-in-apply_min_nr_regions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: handle region split failure in apply_min_nr_regions()
Date: Sun, 19 Jul 2026 08:54:40 -0700

damon_apply_min_nr_regions() repeatedly split each region until its size
becomes small enough to meet the user-defined low limit of the number of
regions.  The loop assumes the split operation (damon_split_region_at())
will always succeed and create the new region.  But the operation could
silently fail for memory allocation failures, for example.

If such failure happens and the region was the last region, the linked
list-based next region fetching returns invalid pointer.  As a result,
invalid memory dereference and corruption could happen.  Even if the
corner case is handled, it imposes stress to the allocator by trying split
regions for other targets.  Fix the issue by breaking all the loops for
any region split failure.

This means there could be a min_nr_regions violation.  It will only rarely
happen since the allocation is arguably too small to fail.  Even if it
happens, it is only temporal.  damon_apply_min_nr_regions() will be called
again after the aggregation interval.

The user impact of the issue should be minor, since the allocation is
arguably too small to fail.  But, it could still theoretically happen, and
the consequence is very bad.

This issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260719155442.88794-1-sj@kernel.org
Link: https://lore.kernel.org/20260717011834.120715-1-sj@kernel.org [1]
Fixes: b1029f29eb1d ("mm/damon/core: split regions for min_nr_regions")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 7.1.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-handle-region-split-failure-in-apply_min_nr_regions
+++ a/mm/damon/core.c
@@ -1886,7 +1886,7 @@ static unsigned long damon_region_sz_lim
 	return sz;
 }
 
-static void damon_split_region_at(struct damon_target *t,
+static int damon_split_region_at(struct damon_target *t,
 				  struct damon_region *r, unsigned long sz_r);
 
 /*
@@ -1912,11 +1912,13 @@ static unsigned long damon_apply_min_nr_
 	damon_for_each_target(t, ctx) {
 		damon_for_each_region_safe(r, next, t) {
 			while (damon_sz_region(r) > max_region_sz) {
-				damon_split_region_at(t, r, max_region_sz);
+				if (damon_split_region_at(t, r, max_region_sz))
+					goto out;
 				r = damon_next_region(r);
 			}
 		}
 	}
+out:
 	return max_region_sz;
 }
 
@@ -3411,8 +3413,10 @@ static void damon_verify_split_region_at
  *
  * r		the region to be split
  * sz_r		size of the first sub-region that will be made
+ *
+ * Return: 0 on success, negative error code otherwise.
  */
-static void damon_split_region_at(struct damon_target *t,
+static int damon_split_region_at(struct damon_target *t,
 				  struct damon_region *r, unsigned long sz_r)
 {
 	struct damon_region *new;
@@ -3420,7 +3424,7 @@ static void damon_split_region_at(struct
 	damon_verify_split_region_at(r, sz_r);
 	new = damon_new_region(r->ar.start + sz_r, r->ar.end);
 	if (!new)
-		return;
+		return -ENOMEM;
 
 	r->ar.end = new->ar.start;
 
@@ -3433,6 +3437,7 @@ static void damon_split_region_at(struct
 			sizeof(r->last_probe_hits));
 
 	damon_insert_region(new, r, damon_next_region(r), t);
+	return 0;
 }
 
 /* Split every region in the given target into 'nr_subs' regions */
_

Patches currently in -mm which might be from sj@kernel.org are


