Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15959246335
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837157; cv=none; b=B0V18KqsUOeA1j6aaJcI9mtA7WOCg+SVxA2JT+VDNYb7BUlBTcudSYm7Jy0m69dr2zJsN9mnibowq0tXsr9+9vJ/XCvjSqliDTNM6tS8GI0HVOJszGV4ccAdyG75So9fDhFw3qK7jV388Ah4GDBjLgVmGsc2h80tQnbFlXxHrXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837157; c=relaxed/simple;
	bh=oEuOqWqw60ZDzv/YWNPRWBa906QzvIEnWjM1+f7AeRY=;
	h=Date:To:From:Subject:Message-Id; b=Umh5JXbpvLlQQDfZHsxxV5CDDjnWDZ/Zy5+NNh9KxNpXcl6SAC6xr9Na9MN0G9r4JavfWUVDprQ9UumslEkfips2aqofOIzGAQBaOXDj4Rh4wgRZM7PNQ7E8xw4pfCPBsMH/OllRN/YQT5YXKLcaNpmOTR1X/zES1bnNEjem+Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UvJw1kj7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UvJw1kj7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC788C4CEDD;
	Tue, 14 Jan 2025 06:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837156;
	bh=oEuOqWqw60ZDzv/YWNPRWBa906QzvIEnWjM1+f7AeRY=;
	h=Date:To:From:Subject:From;
	b=UvJw1kj7TDPzZPHtdR0LxGblToS2hhu7/a0Ef7qpcbdtK7UO+HC8amvRRTLWkW6GK
	 Gxgp0dATu4MNLxucVjl8y3R56+Y9xgtFVdH9oT7CqBXibDmLXoUtlar0Ltpq0crRaa
	 ixuRmkXpaKQLChedF2oq75jlKZj+ZpqZGgLjfxHU=
Date: Mon, 13 Jan 2025 22:45:56 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-clarify-trying-vs-applying-on-damos_stat-kernel-doc-comment.patch removed from -mm tree
Message-Id: <20250114064556.DC788C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: clarify trying vs applying on damos_stat kernel-doc comment
has been removed from the -mm tree.  Its filename was
     mm-damon-clarify-trying-vs-applying-on-damos_stat-kernel-doc-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: clarify trying vs applying on damos_stat kernel-doc comment
Date: Mon, 6 Jan 2025 11:33:46 -0800

Patch series "mm/damon: enable page level properties based monitoring".

TL; DR
======

This patch series enables access monitoring based on page level properties
including their anonymousness, belonging cgroups and young-ness, by
extending DAMOS stats and regions walk features with region-internal DAMOS
filters.

Background
==========

DAMOS has initially developed for only access-aware system operations. 
But, efficient acces monitoring results querying is yet another major
usage of today's DAMOS.  DAMOS stats and regions walk, which exposes
accumulated counts and per-region monitoring results that filtered by
DAMOS parameters including target access pattern, quotas and DAMOS
filters, are the key features for that usage.  For tunings and
investigations, it can be more useful if only the information can be
exposed without making real system operational change.  Special DAMOS
action, DAMOS_STAT, was introduced for the purpose.

DAMOS fundametally works with only access pattern information in region
granularity.  For some use cases, fixed and fine granularity information
based on non access pattern properties can be useful, though.  For
example, on systems having swap devices that much faster than storage
devices for files, DAMOS-based proactive reclaim need to be applied
differently for anonymous pages and file-backed pages.

DAMOS filters is a feature that makes it possible.  It supports non access
pattern information including page level properties such as anonymousness,
belonging cgroups, and young-ness (whether the page has accessed since the
last access check of it).  The information can be useful for tuning and
investigations.  DAMOS stat exposes some of it via {nr,sz}_applied, but it
is mixed with operation failures.  Also, exposing the information without
making system operation change is impossible, since DAMOS_STAT simply
ignores the page level properties based DAMOS filters.

Design
======

Expose the exact information for every DAMOS action including DAMOS_STAT
by implementing below changes.

Extend the interface for DAMON operations set layer, which contains the
implementation of the page level filters, to report back the amount of
memory that passed the region-internal DAMOS filters to the core layer. 
On the core layer, account the operations set layer reported stat with
DAMOS stat for per-scheme monitoring.  Also, pass the information to
regions walk for per-region monitoring.  In this way, DAMON API users can
efficiently get the fine-grained information.

For the user-space, make DAMON sysfs interface collects the information
using the updated DAMON core API, and expose those to new per-scheme stats
file and per-DAMOS-tried region properties file.

Practical Usages
================

With this patch series, DAMON users can query how many bytes of regions of
specific access temperature is backed by pages of specific type.  The type
can be any of DAMOS filter-supporting one, including anonymousness,
belonging cgroups, and young-ness.  For example, users can visualize
access hotness-based page granulairty histogram for different cgroups,
backing content type, or youngness.  In future, it could be extended to
more types such as whether it is THP, position on LRU lists, etc.  This
can be useful for estimating benefits of a new or an existing access-aware
system optimizations without really committing the changes.

Patches Sequence
================

The patches are constructed in four sub-sequences.

First three patches (patches 1-3) update documents to have missing
background knowledges and better structures for easily introducing
followup changes.

Following three patches (patches 4-6) change the operations set layer
interface to report back the region-internal filter passed memory size,
and make the operations set implementations support the changed symantic.

Following five patches (patches 7-11) implement per-scheme accumulated
stat for region-internal filter-passed memory size on core API
(damos_stat) and DAMON sysfs interface.  First two patches of those are
for code change, and following three patches are for documentation.

Finally, five patches (patches 12-16) implementing per-region
region-internal filter-passed memory size follows.  Similar to that for
per-scheme stat, first two patches implement core-API and sysfs interface
change.  Then three patches for documentation update follow.


This patch (of 16):

DAMOS stat kernel-doc documentation is using terms that bit ambiguous. 
Without reading the code, understanding it correctly is not that easy. 
Add the clarification on the kernel-doc comment.

Link: https://lkml.kernel.org/r/20250106193401.109161-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250106193401.109161-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/include/linux/damon.h~mm-damon-clarify-trying-vs-applying-on-damos_stat-kernel-doc-comment
+++ a/include/linux/damon.h
@@ -287,6 +287,23 @@ struct damos_watermarks {
  * @nr_applied:	Total number of regions that the scheme is applied.
  * @sz_applied:	Total size of regions that the scheme is applied.
  * @qt_exceeds: Total number of times the quota of the scheme has exceeded.
+ *
+ * "Tried an action to a region" in this context means the DAMOS core logic
+ * determined the region as eligible to apply the action.  The access pattern
+ * (&struct damos_access_pattern), quotas (&struct damos_quota), watermarks
+ * (&struct damos_watermarks) and filters (&struct damos_filter) that handled
+ * on core logic can affect this.  The core logic asks the operation set
+ * (&struct damon_operations) to apply the action to the region.
+ *
+ * "Applied an action to a region" in this context means the operation set
+ * (&struct damon_operations) successfully applied the action to the region, at
+ * least to a part of the region.  The filters (&struct damos_filter) that
+ * handled on operation set layer and type of the action and pages of the
+ * region can affect this.  For example, if a filter is set to exclude
+ * anonymous pages and the region has only anonymous pages, the region will be
+ * failed at applying the action.  If the action is &DAMOS_PAGEOUT and all
+ * pages of the region are already paged out, the region will be failed at
+ * applying the action.
  */
 struct damos_stat {
 	unsigned long nr_tried;
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch

