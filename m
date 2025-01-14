Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED4024334A
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837163; cv=none; b=bIh13NkZqloY+xmWwz/7berDDC1g7B5EkzJc86uYFZbqNOyFGTRtrHCOgfhMUb2GyJAJPOCYzwZ/RLgdyxcJ1mX8q/QNScG0rHxaWf/ld9ITi/JZCto4WH4GFQgD9QwK7FXkIQuYCz+ldvcHNLbtKoG/xkX+Q6VpdGcChmpvNWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837163; c=relaxed/simple;
	bh=wM9t4qM0U/U6iz0S45I6ybaUEjl8rgJ1Eb9Z+kYBOsg=;
	h=Date:To:From:Subject:Message-Id; b=K4H3j4j2Uh6/WLWm61WhIspRGVKd2bZMqc28tRVuV2ZC1tNPQTRDflHyzhNXN5L4fiLiA96Fc0O/jNgbi/iHmvuz6XbWXAKmbzyuNS+0O4t2b8l8NbuBuEKOXibH9oCwH0CGqyEtnLVn8rLhgWVjqYX5sjQGZ+TOoQ2drGUXeqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LGkYsS6W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LGkYsS6W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43915C4CEDD;
	Tue, 14 Jan 2025 06:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837163;
	bh=wM9t4qM0U/U6iz0S45I6ybaUEjl8rgJ1Eb9Z+kYBOsg=;
	h=Date:To:From:Subject:From;
	b=LGkYsS6W9yUlEREmXmwiR5FxwYRCuuzKeSyu1MHthNH9jLvngX9otR05/0e4mr4q2
	 3ZzrceTlTxNB+dxLGNpluXk+VJMvy2WswWFw2F3vLF0Ze6BtyQTvqDYJ7vyv/ix8pO
	 Fv3lbrq0Kcvz+evlU0VYr6Yr0ocqfR6kPLS50yi4=
Date: Mon, 13 Jan 2025 22:46:02 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-implement-per-scheme-ops-handled-filter-passed-bytes-stat.patch removed from -mm tree
Message-Id: <20250114064603.43915C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: implement per-scheme ops-handled filter-passed bytes stat
has been removed from the -mm tree.  Its filename was
     mm-damon-core-implement-per-scheme-ops-handled-filter-passed-bytes-stat.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: implement per-scheme ops-handled filter-passed bytes stat
Date: Mon, 6 Jan 2025 11:33:52 -0800

Implement a new per-DAMOS scheme statistic field, namely
sz_ops_filter_passed, using the changed damon_operations->apply_scheme()
interface.  It counts total bytes of memory that given DAMOS action tried
to be applied, and passed the operations layer handled region-internal
filters of the scheme.  DAMON API users can access it using DAMON-internal
safe access features such as damon_call() and/or damos_walk().

Link: https://lkml.kernel.org/r/20250106193401.109161-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    3 +++
 mm/damon/core.c       |    6 ++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-implement-per-scheme-ops-handled-filter-passed-bytes-stat
+++ a/include/linux/damon.h
@@ -286,6 +286,8 @@ struct damos_watermarks {
  * @sz_tried:	Total size of regions that the scheme is tried to be applied.
  * @nr_applied:	Total number of regions that the scheme is applied.
  * @sz_applied:	Total size of regions that the scheme is applied.
+ * @sz_ops_filter_passed:
+ *		Total bytes that passed ops layer-handled DAMOS filters.
  * @qt_exceeds: Total number of times the quota of the scheme has exceeded.
  *
  * "Tried an action to a region" in this context means the DAMOS core logic
@@ -310,6 +312,7 @@ struct damos_stat {
 	unsigned long sz_tried;
 	unsigned long nr_applied;
 	unsigned long sz_applied;
+	unsigned long sz_ops_filter_passed;
 	unsigned long qt_exceeds;
 };
 
--- a/mm/damon/core.c~mm-damon-core-implement-per-scheme-ops-handled-filter-passed-bytes-stat
+++ a/mm/damon/core.c
@@ -1362,13 +1362,15 @@ static bool damos_skip_charged_region(st
 }
 
 static void damos_update_stat(struct damos *s,
-		unsigned long sz_tried, unsigned long sz_applied)
+		unsigned long sz_tried, unsigned long sz_applied,
+		unsigned long sz_ops_filter_passed)
 {
 	s->stat.nr_tried++;
 	s->stat.sz_tried += sz_tried;
 	if (sz_applied)
 		s->stat.nr_applied++;
 	s->stat.sz_applied += sz_applied;
+	s->stat.sz_ops_filter_passed += sz_ops_filter_passed;
 }
 
 static bool __damos_filter_out(struct damon_ctx *ctx, struct damon_target *t,
@@ -1586,7 +1588,7 @@ static void damos_apply_scheme(struct da
 		r->age = 0;
 
 update_stat:
-	damos_update_stat(s, sz, sz_applied);
+	damos_update_stat(s, sz, sz_applied, sz_ops_filter_passed);
 }
 
 static void damon_do_apply_schemes(struct damon_ctx *c,
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch

