Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4894615216A
	for <mm-commits@vger.kernel.org>; Wed, 26 Jun 2024 19:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719428979; cv=none; b=NjKdhgdQvmpcC1WoFWor2tVGhe67jHUCp0MZBUv0oXnZFhvr99hpox43X/N27uoxRZrv4vsvI9qzvRl0kTSWek8DtwpmqvRul9RODuDgX81+8Pnqx6mmjVvx1l1PUXbWspfIHWFlf/kZA0uYTymPUsbH4O047eZDcElDPc2pvik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719428979; c=relaxed/simple;
	bh=ghppp2nRQdjqC0xUqQl5N25+mMa2iDnFlaDdLirHT1s=;
	h=Date:To:From:Subject:Message-Id; b=A5l6+FR874CP++2PmyHHbO5EJVGyBXvkVeT1+kd3lYnX3DMHhaOt/oW0NKTBMSxeJERMIfhf9d5XpE4EScRrWGrkVLpVKzaDOMeHbBcNIgPiBTiX9W97gG0QxzypvA3eApJuwJbcLvkuJwz/SYxzXj6hgqPaHiL28aMBFjOusC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WZ9IhNsF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WZ9IhNsF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F047BC116B1;
	Wed, 26 Jun 2024 19:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719428979;
	bh=ghppp2nRQdjqC0xUqQl5N25+mMa2iDnFlaDdLirHT1s=;
	h=Date:To:From:Subject:From;
	b=WZ9IhNsFhXROBf9K7tA/0cXqP9zWAP8V46WW4JfGyFx9CJXYRzR0on3IDuZUEc/q2
	 QeBpWvlLegbmR15m4yFM9qzDaA2o7E/AhkNOpRYXnWozU6BrRvvY4yr99as1+V09Tj
	 qQiYNLmVebUuCu2LjNtdSN+XffLcAJ4yYWzXqXq0=
Date: Wed, 26 Jun 2024 12:09:38 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20240626190938.F047BC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: increase regions merge aggressiveness while respecting min_nr_regions
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: increase regions merge aggressiveness while respecting min_nr_regions
Date: Wed, 26 Jun 2024 09:47:53 -0700

DAMON's merge mechanism has two thresholds, namely those for access
frequency and size.  The access frequency threshold avoids merging two
adjacent regions that having pretty different access frequency.

The size threshold is calculated as total size of regions divided by
min_nr_regions.  Merging operation skip merging two adjacent regions if
the resulting region's size can be larger than the threshold.  This is for
meeting min_nr_regions.

Commit 44fdaf596984 ("mm/damon/core: merge regions aggressively when
max_nr_regions is unmet") of mm-unstable, however, ignores the
min_nr_regions by increasing not only access frequency threshold but also
the size threshold.

The commit also has one more problem.  User could set DAMON target regions
with more than max_nr_regions discrete regions.  Because DAMON cannot
merge non-adjacent regions, the number of regions will never be lower than
max_nr_regions regardless of the increased thresholds.  As a result, the
function can infinitely repeat the loop.

Increase only access frequency threshold, up to only possible maximum
value.

Link: https://lkml.kernel.org/r/20240626164753.46270-1-sj@kernel.org
Fixes: 44fdaf596984 ("mm/damon/core: merge regions aggressively when max_nr_regions is unmet") # mm-unstable
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix
+++ a/mm/damon/core.c
@@ -1359,20 +1359,21 @@ static void damon_merge_regions_of(struc
  * overhead under the dynamically changeable access pattern.  If a merge was
  * unnecessarily made, later 'kdamond_split_regions()' will revert it.
  *
- * The total number of regions could be temporarily higher than the
- * user-defined limit, max_nr_regions for some cases.  For an example, the user
- * updates max_nr_regions to a number that lower than the current number of
- * regions while DAMON is running.  Depending on the access pattern, it could
- * take indefinitve time to reduce the number below the limit.  For such a
- * case, repeat merging until the limit is met while increasing @threshold and
- * @sz_limit.
+ * The total number of regions could be higher than the user-defined limit,
+ * max_nr_regions for some cases.  For example, the user can update
+ * max_nr_regions to a number that lower than the current number of regions
+ * while DAMON is running.  For such a case, repeat merging until the limit is
+ * met while increasing @threshold up to possible maximum level.
  */
 static void kdamond_merge_regions(struct damon_ctx *c, unsigned int threshold,
 				  unsigned long sz_limit)
 {
 	struct damon_target *t;
 	unsigned int nr_regions;
+	unsigned int max_thres;
 
+	max_thres = c->attrs.aggr_interval /
+		(c->attrs.sample_interval ?  c->attrs.sample_interval : 1);
 	do {
 		nr_regions = 0;
 		damon_for_each_target(t, c) {
@@ -1380,8 +1381,8 @@ static void kdamond_merge_regions(struct
 			nr_regions += damon_nr_regions(t);
 		}
 		threshold = max(1, threshold * 2);
-		sz_limit = max(1, sz_limit * 2);
-	} while (nr_regions > c->attrs.max_nr_regions);
+	} while (nr_regions > c->attrs.max_nr_regions &&
+			threshold <= max_thres);
 }
 
 /*
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet.patch
mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix.patch
docs-mm-damon-maintainer-profile-introduce-hackermail.patch
docs-mm-damon-maintainer-profile-document-damon-community-meetups.patch
selftests-damon-access_memory-use-user-defined-region-size.patch
selftests-damon-_damon_sysfs-support-schemes_update_tried_regions.patch
selftests-damon-implement-a-program-for-even-numbered-memory-regions-access.patch
selftests-damon-implement-damos-tried-regions-test.patch
selftests-damon-_damon_sysfs-implement-kdamonds-stop-function.patch
selftests-damon-implement-test-for-min-max_nr_regions.patch
_damon_sysfs-implement-commit-for-online-parameters-update.patch
selftests-damon-damon_nr_regions-test-online-tuned-max_nr_regions.patch

