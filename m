Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213A015746F
	for <mm-commits@vger.kernel.org>; Wed, 29 Apr 2026 12:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777467118; cv=none; b=WdolryfUctn1YTZyGMdGnjcHOMvBudslfEjG+XAkRnLCR6QQBxrsx+7VriR6sYCPMiQ4htYB94KnZCrF2DNtPQtx/5W9ftign0ZHnHVJZDoOkD45n6Kt2gTY+/W8sw81Tk0fwVBsgRH+aFn6bHvlBK1nznG8UBlB5vNF/boE3AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777467118; c=relaxed/simple;
	bh=zsM/Ue5wi1SqJ7otcASjrTZ/RyV3eXS8Et5RdMnEjek=;
	h=Date:To:From:Subject:Message-Id; b=G87QLIEJRsaV2xXMyuuukwL49UfIVeo9QzUuaGwWLfqKmOZBj+ztxfwz9jHr/Z8ubFoSFCThLi/VNyn0huw3p6yyYoS4ProxgE1foGeb0waIGrdNErA7uKkSUebBlbpMaiZqIko95rn15HpWWdfxJlwbvScJiAoZuHVaIVLJmMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Oxo/ZfJV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Oxo/ZfJV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD6E5C19425;
	Wed, 29 Apr 2026 12:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777467117;
	bh=zsM/Ue5wi1SqJ7otcASjrTZ/RyV3eXS8Et5RdMnEjek=;
	h=Date:To:From:Subject:From;
	b=Oxo/ZfJVQpUG8A6SWe8CUz5cPbjddlByUetzu0bOyIP0XGvX5SdXhuPmi+neG0e4P
	 nsJjvhuPPxlFtFAf1VOU0ddotzldPplD42+Yfqoq0vKC1x9xFjsLJCaT/ic2apqRrO
	 z+NpdiAIeIhwJRIZveWc4dM2/Aa+Ug3MiHePRkIg=
Date: Wed, 29 Apr 2026 05:51:57 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-introduce-damon_set_region_system_rams_default.patch added to mm-new branch
Message-Id: <20260429125157.AD6E5C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: introduce damon_set_region_system_rams_default()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-introduce-damon_set_region_system_rams_default.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-introduce-damon_set_region_system_rams_default.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: introduce damon_set_region_system_rams_default()
Date: Tue, 28 Apr 2026 21:12:23 -0700

Patch series "mm/damon/reclaim,lru_sort: monitor all system rams by
default".

DAMON_RECLAIM and DAMON_LRU_SORT set the biggest 'System RAM' resource of
the system as the default monitoring target address range.  The main
intention behind the design is to minimize the overhead coming from
monitoring of non-System RAM areas.

This could result in an odd setup when there are multiple discrete System
RAMs of considerable sizes.  For example, there are System RAMs each
having 500 GiB size.  In this case, only the first 500 GiB will be set as
the monitoring region by default.  This is particularly common on NUMA
systems.  Hence the modules allow users to set the monitoring target
address range using the module parameters if the default setup doesn't
work for them.  In other words, the current design trades ease of setup
for lower overhead.

However, because DAMON utilizes the sampling based access check and the
adaptive regions adjustment mechanisms, the overhead from the monitoring
of non-System RAM areas should be negligible in most setups.  Meanwhile,
the setup complexity is causing real headaches for users who need to run
those modules on various types of systems.  That is, the current tradeoff
is not a good deal.

Set the physical address range that can cover all System RAM areas of the
system as the default monitoring regions for DAMON_RECLAIM and
DAMON_LRU_SORT.

Technically speaking, this is changing documented behavior.  However, it
makes no sense to believe there is a real use case that really depends on
the old weird default behavior.  If the old default behavior was working
for them in the reasonable way, this change will only add a negligible
amount of monitoring overhead.  If it didn't work, the users may already
be using manual monitoring regions setup, and they will not be affected by
this change.

Patches Sequence
================

Patch 1 introduces a new core function that will be used for the new
default monitoring target region setup.  Patch 2 and 3 update
DAMON_RECLAIM and DAMON_LRU_SORT to use the new function instead of the
old one, respectively.  Patch 4 removes the old core function that was
replaced by the new one, as there is no more user of it.  Patch 5 updates
DAMON_STAT to use the new one instead of its in-house nearly-duplicate
self implementation of the functionality.  Finally patches 6 and 7 update
the DAMON_RECLAIM and DAMON_LRU_SORT user documentation for the new
behaviors, respectively.


This patch (of 7):

damon_set_region_biggest_system_ram_default() sets the monitoring target
region as the caller requested.  If the caller didn't specify the region,
it finds the biggest System RAM of the system and sets it as the target
region.  When there are more than one considerable size of System RAM
resources in the system, the default target setup makes no sense. 
Introduce a variant, namely damon_set_region_system_rams_default().  It
sets a physical address range that covers all System RAM resources as the
default target region.

Link: https://lore.kernel.org/20260429041232.90257-1-sj@kernel.org
Link: https://lore.kernel.org/20260429041232.90257-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    5 ++
 mm/damon/core.c       |   77 +++++++++++++++++++++++++++++++++++++---
 2 files changed, 77 insertions(+), 5 deletions(-)

--- a/include/linux/damon.h~mm-damon-introduce-damon_set_region_system_rams_default
+++ a/include/linux/damon.h
@@ -998,6 +998,11 @@ int damon_kdamond_pid(struct damon_ctx *
 int damon_call(struct damon_ctx *ctx, struct damon_call_control *control);
 int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control);
 
+int damon_set_region_system_rams_default(struct damon_target *t,
+				unsigned long *start, unsigned long *end,
+				unsigned long addr_unit,
+				unsigned long min_region_sz);
+
 int damon_set_region_biggest_system_ram_default(struct damon_target *t,
 				unsigned long *start, unsigned long *end,
 				unsigned long addr_unit,
--- a/mm/damon/core.c~mm-damon-introduce-damon_set_region_system_rams_default
+++ a/mm/damon/core.c
@@ -3105,14 +3105,20 @@ done:
 	return 0;
 }
 
-static int walk_system_ram(struct resource *res, void *arg)
+struct damon_system_ram_range_walk_arg {
+	bool walked;
+	struct resource res;
+};
+
+static int damon_system_ram_walk_fn(struct resource *res, void *arg)
 {
-	struct resource *a = arg;
+	struct damon_system_ram_range_walk_arg *a = arg;
 
-	if (resource_size(a) < resource_size(res)) {
-		a->start = res->start;
-		a->end = res->end;
+	if (!a->walked) {
+		a->walked = true;
+		a->res.start = res->start;
 	}
+	a->res.end = res->end;
 	return 0;
 }
 
@@ -3129,6 +3135,67 @@ static unsigned long damon_res_to_core_a
 	return ra / addr_unit;
 }
 
+static bool damon_find_system_rams_range(unsigned long *start,
+		unsigned long *end, unsigned long addr_unit)
+{
+	struct damon_system_ram_range_walk_arg arg = {};
+
+	walk_system_ram_res(0, -1, &arg, damon_system_ram_walk_fn);
+	if (!arg.walked)
+		return false;
+	*start = damon_res_to_core_addr(arg.res.start, addr_unit);
+	*end = damon_res_to_core_addr(arg.res.end + 1, addr_unit);
+	if (*end <= *start)
+		return false;
+	return true;
+}
+
+/**
+ * damon_set_region_system_rams_default() - Set the region of the given
+ * monitoring target as requested, or to cover all 'System RAM' resources.
+ * @t:		The monitoring target to set the region.
+ * @start:	The pointer to the start address of the region.
+ * @end:	The pointer to the end address of the region.
+ * @addr_unit:	The address unit for the damon_ctx of @t.
+ * @min_region_sz:	Minimum region size.
+ *
+ * This function sets the region of @t as requested by @start and @end.  If the
+ * values of @start and @end are zero, however, this function finds 'System
+ * RAM' resources and sets the region to cover all the resource.  In the latter
+ * case, this function saves the start and the end addresseses of the first and
+ * the last resources in @start and @end, respectively.
+ *
+ * Return: 0 on success, negative error code otherwise.
+ */
+int damon_set_region_system_rams_default(struct damon_target *t,
+			unsigned long *start, unsigned long *end,
+			unsigned long addr_unit, unsigned long min_region_sz)
+{
+	struct damon_addr_range addr_range;
+
+	if (*start > *end)
+		return -EINVAL;
+
+	if (!*start && !*end &&
+		!damon_find_system_rams_range(start, end, addr_unit))
+		return -EINVAL;
+
+	addr_range.start = *start;
+	addr_range.end = *end;
+	return damon_set_regions(t, &addr_range, 1, min_region_sz);
+}
+
+static int walk_system_ram(struct resource *res, void *arg)
+{
+	struct resource *a = arg;
+
+	if (resource_size(a) < resource_size(res)) {
+		a->start = res->start;
+		a->end = res->end;
+	}
+	return 0;
+}
+
 /*
  * Find biggest 'System RAM' resource and store its start and end address in
  * @start and @end, respectively.  If no System RAM is found, returns false.
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-call-missing-mem_cgroup_iter_break.patch
mm-damon-fix-damos_stat-tracepoint-format-for-sz_applied.patch
docs-mm-damon-maintainer-profile-add-ai-review-usage-guideline.patch
mm-damon-core-introduce-damon_ctx-paused.patch
mm-damon-sysfs-add-pause-file-under-context-dir.patch
docs-mm-damon-design-update-for-context-pause-resume-feature.patch
docs-admin-guide-mm-damon-usage-update-for-pause-file.patch
docs-abi-damon-update-for-pause-sysfs-file.patch
mm-damon-tests-core-kunit-test-pause-commitment.patch
selftests-damon-_damon_sysfs-support-pause-file-staging.patch
selftests-damon-drgn_dump_damon_status-dump-pause.patch
selftests-damon-sysfspy-check-pause-on-assert_ctx_committed.patch
selftests-damon-sysfspy-pause-damon-before-dumping-status.patch
mm-damon-introduce-damon_set_region_system_rams_default.patch
mm-damon-reclaim-cover-all-system-rams.patch
mm-damon-lru_sort-cover-all-system-rams.patch
mm-damon-core-remove-damon_set_region_biggest_system_ram_default.patch
mm-damon-stat-use-damon_set_region_system_rams_default.patch
docs-admin-guide-mm-damon-reclaim-update-for-entire-memory-monitoring.patch
docs-admin-guide-mm-damon-lru_sort-update-for-entire-memory-monitoring.patch

