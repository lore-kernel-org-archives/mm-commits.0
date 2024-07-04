Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4057210EE
	for <mm-commits@vger.kernel.org>; Thu,  4 Jul 2024 05:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720070958; cv=none; b=QlC3fHGjWofhjAP60rPYMExVP+GIag5Hw13kj4P6LDxrdue1L5xCrEWTBu/XEQ7VXY4XV1IH5S5YtLVIzjKTrIzy7j6wxWxs0b89+6oMEL7FLZoDJEca78AHIRKrtJAswH3CN+PwOyK3Hp6Nu/+mIziQdxmRrTk16+iKbS40Htk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720070958; c=relaxed/simple;
	bh=He/DjBDaUoNfCAEXQlfcl3Cvaj7M4Kjp8Wi3POmtZPQ=;
	h=Date:To:From:Subject:Message-Id; b=D37QttgdaSa/sznQ1f9xKra7e85ggyqbv7yVEBQnHItTlyOreOL34/bwQYy+OU0Mjgi2z3rz848DamjmUruTCueMQMOkdJ76YmE6uq8rokAe7xDzLh3ES7G/AER9zzIZaS8GIDCboF2eE4MCck77LiIRZMHGF/PFBq6WX50v2Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ee5cw4kE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ee5cw4kE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 626BEC3277B;
	Thu,  4 Jul 2024 05:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720070957;
	bh=He/DjBDaUoNfCAEXQlfcl3Cvaj7M4Kjp8Wi3POmtZPQ=;
	h=Date:To:From:Subject:From;
	b=Ee5cw4kEZdv7h7xiDr7Thf1WjZV0loB3zqDyJ366KUayoLEnNGQIQWpwc5EUDso/r
	 2pmiXhCUVXeTlsVOrxsAEqz8BisIhCUkV/43/q1tCKqZ2qQUBBCOq/Ik8DY6pLS7eN
	 zwif1oTfwXwr7P5e77mm69bi0YbIfyauOWO4hopU=
Date: Wed, 03 Jul 2024 22:29:16 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix.patch removed from -mm tree
Message-Id: <20240704052917.626BEC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: increase regions merge aggressiveness while respecting min_nr_regions
has been removed from the -mm tree.  Its filename was
     mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix.patch

This patch was dropped because it was folded into mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet.patch

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
mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix-2.patch
mm-damon-paddr-initialize-nr_succeeded-in-__damon_pa_migrate_folio_list.patch
docs-mm-damon-design-fix-two-typos.patch
docs-mm-damon-design-clarify-regions-merging-operation.patch
docs-admin-guide-mm-damon-start-add-access-pattern-snapshot-example.patch
docs-mm-damon-design-add-links-from-overall-architecture-to-sections-of-details.patch
docs-mm-damon-design-move-configurable-operations-set-section-into-operations-set-layer-section.patch
docs-mm-damon-design-remove-programmable-modules-section-in-favor-of-modules-section.patch
docs-mm-damon-design-add-links-to-sections-of-damon-sysfs-interface-usage-doc.patch
docs-mm-damon-index-add-links-to-design.patch
docs-mm-damon-index-add-links-to-admin-guide-doc.patch

