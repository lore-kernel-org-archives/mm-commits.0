Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A974C92
	for <mm-commits@vger.kernel.org>; Mon, 29 Jun 2026 19:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782759755; cv=none; b=J9GqEWM1vayXhJsAWmVoBoAyheU1Mwr1p4/qngKBqkDJN9DZa7kNAkfzWQwbXou4ojSFmD73RVB0+I3+VubXDabYPeVBr5rkTn0wb9NkD3IDY8voeVD2VXTzJ4YcWleoh69yWc1bdvhAVcy+TwCi06MHPXHq/sKYiNdOYM0wIlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782759755; c=relaxed/simple;
	bh=odxi6VkBfrCW/3CZblBjep/18nguFvnDloew2XilsEM=;
	h=Date:To:From:Subject:Message-Id; b=Ckyfr3jhTAGGi8rcBHozUnMn44/b2hT8lH9fYL01p1G0LhM6F/SU1UwR28VpGZPm4V/OE/GjZVeBDp6NHEZRm4d++JLbx8eMf4U0xYmKc6aJtciCCr3CHhgKB3hI8v+NUdXGlXXo56ar4gJQxxVK3ZnVr4yTqYFI23wLHtuKOt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=odIsxNSk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="odIsxNSk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7018E1F000E9;
	Mon, 29 Jun 2026 19:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782759753;
	bh=Fub4stBdVZexeLZhPqKuQ6PMBCb2dVfSRU0q1o5vN/E=;
	h=Date:To:From:Subject;
	b=odIsxNSkxJl76oO6zP68nIKAwKnC26+KyI9CCOVGuwvJbWW1ZVVunPXyKBmpfPRi6
	 saSAVZHKpdbYK9ROu0SNoom+rli1rYb3PZ2NiHbs2n5dfdDCR32O0ZLyrQwOLlukQ9
	 MhtTPyBLgohsRukgUFgkC81yBYF8I3ru0z5f+rEg=
Date: Mon, 29 Jun 2026 12:02:32 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,shu17az@gmail.com,jiayuan.chen@shopee.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-split-a-fraction-of-regions-when-nr_regions-exceeds-max-2.patch added to mm-new branch
Message-Id: <20260629190233.7018E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: split a fraction of regions when nr_regions exceeds max/2
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-split-a-fraction-of-regions-when-nr_regions-exceeds-max-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-split-a-fraction-of-regions-when-nr_regions-exceeds-max-2.patch

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
From: Jiayuan Chen <jiayuan.chen@shopee.com>
Subject: mm/damon/core: split a fraction of regions when nr_regions exceeds max/2
Date: Mon, 29 Jun 2026 07:56:28 -0700

Patch series "mm/damon/core: detect internal variation above
max_nr_regions/2", v3.

kdamond_split_regions() bails out early when nr_regions is already above
max_nr_regions / 2.  A large region that picks up new internal variation
after that point never gets split, so we lose visibility into its hot/cold
structure.

We hit this with damon-paddr on hugepage workloads and damon-vaddr on
processes that mmap a large anonymous range.

Example with max_nr_regions == 1500.  A target ends up with 799 small
hot/cold regions plus one big region (an earlier merge collapsed a
uniformly-accessed range into a single piece):

H:hot
C:cold

      r1     r2     r3                 r800
    HHHHHH|CCCCCC|HHHHHH|...|HHHHHH..........................|

    nr_regions = 800  >  max_nr_regions / 2 = 750

Now a cold subarea shows up inside r800:

      r1     r2     r3                 r800
    HHHHHH|CCCCCC|HHHHHH|...|HHHHHH........CCCCCC.............|

The small regions can't merge with each other (their access counts
differ), so budget never frees up.  r800 can't be split because nr_regions
> max_nr_regions / 2 returns early.  The cold subarea stays invisible.

Patch 1 keeps refining on this path: when nr_regions is above
max_nr_regions / 2 but still under the maximum, it splits a fraction of
the regions instead of returning.  The fraction shrinks as the remaining
budget shrinks, so the count approaches max_nr_regions smoothly.  A
useless split is undone by the next merge cycle.

Patch 2 adds a KUnit test for the case where nr_regions is already above
max_nr_regions / 2.

Thanks to SJ for the suggestion to drive the split fraction from the
remaining budget rather than an age-based filter.


This patch (of 2):

kdamond_split_regions() returns early when nr_regions is above
max_nr_regions / 2, leaving internal access variation inside a large
region undetected.

Such a layout is common with damon-paddr on hugepage workloads or
damon-vaddr on processes with a large anonymous mmap.

For example, with max_nr_regions == 1500, a target may end up with 799
small alternating-temperature regions plus one large region that absorbed
a uniformly-accessed range during an earlier merge:

H:hot
C:cold

      r1     r2     r3                 r800
    HHHHHH|CCCCCC|HHHHHH|...|HHHHHH..........................|

    nr_regions = 800  >  max_nr_regions / 2 = 750

If a cold subarea later emerges inside r800:

      r1     r2     r3                 r800
    HHHHHH|CCCCCC|HHHHHH|...|HHHHHH........CCCCCC.............|

The small regions cannot merge with each other (different access counts),
so the budget stays full.  r800 cannot be split because nr_regions >
max_nr_regions / 2 causes an early return.  The cold subarea is never
discovered.

When nr_regions is above max_nr_regions / 2 but still under the maximum,
split only a fraction of the regions instead of returning.  One region in
every 'max_nr_regions / budget' regions is split, where budget is the
remaining room (max_nr_regions - nr_regions), starting from a rotating
offset so different regions get picked over time.  The fraction shrinks as
the budget shrinks, so the region count keeps refining while approaching
max_nr_regions smoothly rather than overshooting it.  An unnecessary split
is reverted by the next kdamond_merge_regions().

Link: https://lore.kernel.org/20260629145630.134891-1-sj@kernel.org
Link: https://lore.kernel.org/20260626085851.70754-2-jiayuan.chen@linux.dev
Link: https://lore.kernel.org/20260629145630.134891-2-sj@kernel.org
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Signed-off-by: SJ Park <sj@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Shu Anzai <shu17az@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   49 +++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 44 insertions(+), 5 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-split-a-fraction-of-regions-when-nr_regions-exceeds-max-2
+++ a/mm/damon/core.c
@@ -3234,6 +3234,37 @@ static void damon_split_regions_of(struc
 	}
 }
 
+/* Split one in every @split_step regions into two, from a rotating offset */
+static void damon_split_some_regions(struct damon_ctx *ctx,
+				     unsigned long split_step)
+{
+	static unsigned long rotation;
+	struct damon_target *t;
+	struct damon_region *r, *next;
+	unsigned long offset = rotation++ % split_step;
+	unsigned long idx = 0;
+
+	damon_for_each_target(t, ctx) {
+		damon_for_each_region_safe(r, next, t) {
+			unsigned long sz_region, sz_sub;
+
+			if (idx++ % split_step != offset)
+				continue;
+			sz_region = damon_sz_region(r);
+			if (sz_region < 2 * ctx->min_region_sz)
+				continue;
+
+			sz_sub = ALIGN_DOWN(damon_rand(ctx, 1, 10) *
+					sz_region / 10, ctx->min_region_sz);
+			/* Do not allow blank region */
+			if (sz_sub == 0 || sz_sub >= sz_region)
+				continue;
+
+			damon_split_region_at(t, r, sz_sub);
+		}
+	}
+}
+
 /*
  * Split every target region into randomly-sized small regions
  *
@@ -3247,25 +3278,33 @@ static void damon_split_regions_of(struc
 static void kdamond_split_regions(struct damon_ctx *ctx)
 {
 	struct damon_target *t;
-	unsigned int nr_regions = 0;
-	static unsigned int last_nr_regions;
+	unsigned long nr_regions = 0;
+	unsigned long max_nr_regions = ctx->attrs.max_nr_regions;
+	static unsigned long last_nr_regions;
 	int nr_subregions = 2;
 
 	damon_for_each_target(t, ctx)
 		nr_regions += damon_nr_regions(t);
 
-	if (nr_regions > ctx->attrs.max_nr_regions / 2)
-		return;
+	if (nr_regions >= max_nr_regions)
+		goto done;
+
+	if (nr_regions > max_nr_regions / 2) {
+		damon_split_some_regions(ctx,
+			max_nr_regions / (max_nr_regions - nr_regions));
+		goto done;
+	}
 
 	/* Maybe the middle of the region has different access frequency */
 	if (last_nr_regions == nr_regions &&
-			nr_regions < ctx->attrs.max_nr_regions / 3)
+			nr_regions < max_nr_regions / 3)
 		nr_subregions = 3;
 
 	damon_for_each_target(t, ctx)
 		damon_split_regions_of(ctx, t, nr_subregions,
 				       ctx->min_region_sz);
 
+done:
 	last_nr_regions = nr_regions;
 }
 
_

Patches currently in -mm which might be from jiayuan.chen@shopee.com are

mm-damon-core-split-a-fraction-of-regions-when-nr_regions-exceeds-max-2.patch
mm-damon-tests-core-kunit-test-split-above-max_nr_regions-2.patch

