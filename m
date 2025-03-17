Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D03C215771
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188274; cv=none; b=BuI5lpOE6vtarz2HPLDy2qhDCZZdqmYAP8833fyYMq6t3NZMmAHf8SHE7sABtOKWFe8mkynJsz770ZsXsWwiCAAcT6pObxgmSOWYRkGMruy3U6Xd+6dvd8ECwc3slTcZ/u3HU2c8d+cr7RBVHXR1R3Cm6RUw7wyJU39HEyq0eYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188274; c=relaxed/simple;
	bh=iywIpHXXVKrx3ZdI6b3TXrBMTYgT4KLbtjJleyBWgTo=;
	h=Date:To:From:Subject:Message-Id; b=rFsFXonU3ElohQLHiHLXzHDDT3QToYRDrOJJvzhCmOivEQD1wfa2eRW7pHvpMbRrYsiXIl87VNrwQprvN2aEXcQxWcec+XFgOsgeTyMn3VXIWIeNSNh3k2j6TSH//MU28OJByaC0Xzz1QCOduzJy2bTE8vr9+OwRVOU1NindU5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iwV3qJ7R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iwV3qJ7R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86694C4CEEC;
	Mon, 17 Mar 2025 05:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188273;
	bh=iywIpHXXVKrx3ZdI6b3TXrBMTYgT4KLbtjJleyBWgTo=;
	h=Date:To:From:Subject:From;
	b=iwV3qJ7R1v5MS3uuyyJQPyyUiS347bwRaUpMbMBId3+p34eLizhKpfGWcHFz8YyNJ
	 jIC7amSzrA5ladNkT/bhu0cfJSUcSEpwi/QKVtQkicvUCnb7p4wTfpL7LLkwK+WT6Y
	 uvNqOMtcTJpVJbuzCeXVSnaaBmip15oK66ZkOBkE=
Date: Sun, 16 Mar 2025 22:11:13 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,hannes@cmpxchg.org,david@redhat.com,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-introduce-damos-filter-type-hugepage_size.patch removed from -mm tree
Message-Id: <20250317051113.86694C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: introduce DAMOS filter type hugepage_size
has been removed from the -mm tree.  Its filename was
     mm-damon-introduce-damos-filter-type-hugepage_size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Usama Arif <usamaarif642@gmail.com>
Subject: mm/damon: introduce DAMOS filter type hugepage_size
Date: Tue, 11 Feb 2025 12:43:40 +0000

Patch series "mm/damon: add support for hugepage_size DAMOS filter", v5.

hugepage_size DAMOS filter can be used to gather statistics to check if
memory regions of specific access tempratures are backed by hugepages of a
size in a specific range.  This filter can help to observe and prove the
effectivenes of different schemes for shrinking/collapsing hugepages.


This patch (of 4):

This is to gather statistics to check if memory regions of specific access
tempratures are backed by pages of a size in a specific range.  This
filter can help to observe and prove the effectivenes of different schemes
for shrinking/collapsing hugepages.

[sj@kernel.org: add kernel-doc comment for damos_filter->sz_range]
  Link: https://lkml.kernel.org/r/20250218223058.52459-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250211124437.278873-1-usamaarif642@gmail.com
Link: https://lkml.kernel.org/r/20250211124437.278873-2-usamaarif642@gmail.com
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h    |   14 ++++++++++++++
 mm/damon/core.c          |    3 +++
 mm/damon/paddr.c         |    6 ++++++
 mm/damon/sysfs-schemes.c |    1 +
 4 files changed, 24 insertions(+)

--- a/include/linux/damon.h~mm-damon-introduce-damos-filter-type-hugepage_size
+++ a/include/linux/damon.h
@@ -36,6 +36,16 @@ struct damon_addr_range {
 };
 
 /**
+ * struct damon_size_range - Represents size for filter to operate on [@min, @max].
+ * @min:	Min size (inclusive).
+ * @max:	Max size (inclusive).
+ */
+struct damon_size_range {
+	unsigned long min;
+	unsigned long max;
+};
+
+/**
  * struct damon_region - Represents a monitoring target region.
  * @ar:			The address range of the region.
  * @sampling_addr:	Address of the sample for the next access check.
@@ -326,6 +336,7 @@ struct damos_stat {
  * @DAMOS_FILTER_TYPE_ANON:	Anonymous pages.
  * @DAMOS_FILTER_TYPE_MEMCG:	Specific memcg's pages.
  * @DAMOS_FILTER_TYPE_YOUNG:	Recently accessed pages.
+ * @DAMOS_FILTER_TYPE_HUGEPAGE_SIZE:	Page is part of a hugepage.
  * @DAMOS_FILTER_TYPE_ADDR:	Address range.
  * @DAMOS_FILTER_TYPE_TARGET:	Data Access Monitoring target.
  * @NR_DAMOS_FILTER_TYPES:	Number of filter types.
@@ -345,6 +356,7 @@ enum damos_filter_type {
 	DAMOS_FILTER_TYPE_ANON,
 	DAMOS_FILTER_TYPE_MEMCG,
 	DAMOS_FILTER_TYPE_YOUNG,
+	DAMOS_FILTER_TYPE_HUGEPAGE_SIZE,
 	DAMOS_FILTER_TYPE_ADDR,
 	DAMOS_FILTER_TYPE_TARGET,
 	NR_DAMOS_FILTER_TYPES,
@@ -360,6 +372,7 @@ enum damos_filter_type {
  * @target_idx:	Index of the &struct damon_target of
  *		&damon_ctx->adaptive_targets if @type is
  *		DAMOS_FILTER_TYPE_TARGET.
+ * @sz_range:	Size range if @type is DAMOS_FILTER_TYPE_HUGEPAGE_SIZE.
  * @list:	List head for siblings.
  *
  * Before applying the &damos->action to a memory region, DAMOS checks if each
@@ -376,6 +389,7 @@ struct damos_filter {
 		unsigned short memcg_id;
 		struct damon_addr_range addr_range;
 		int target_idx;
+		struct damon_size_range sz_range;
 	};
 	struct list_head list;
 };
--- a/mm/damon/core.c~mm-damon-introduce-damos-filter-type-hugepage_size
+++ a/mm/damon/core.c
@@ -777,6 +777,9 @@ static void damos_commit_filter_arg(
 	case DAMOS_FILTER_TYPE_TARGET:
 		dst->target_idx = src->target_idx;
 		break;
+	case DAMOS_FILTER_TYPE_HUGEPAGE_SIZE:
+		dst->sz_range = src->sz_range;
+		break;
 	default:
 		break;
 	}
--- a/mm/damon/paddr.c~mm-damon-introduce-damos-filter-type-hugepage_size
+++ a/mm/damon/paddr.c
@@ -211,6 +211,7 @@ static bool damos_pa_filter_match(struct
 {
 	bool matched = false;
 	struct mem_cgroup *memcg;
+	size_t folio_sz;
 
 	switch (filter->type) {
 	case DAMOS_FILTER_TYPE_ANON:
@@ -230,6 +231,11 @@ static bool damos_pa_filter_match(struct
 		if (matched)
 			damon_folio_mkold(folio);
 		break;
+	case DAMOS_FILTER_TYPE_HUGEPAGE_SIZE:
+		folio_sz = folio_size(folio);
+		matched = filter->sz_range.min <= folio_sz &&
+			  folio_sz <= filter->sz_range.max;
+		break;
 	default:
 		break;
 	}
--- a/mm/damon/sysfs-schemes.c~mm-damon-introduce-damos-filter-type-hugepage_size
+++ a/mm/damon/sysfs-schemes.c
@@ -329,6 +329,7 @@ static const char * const damon_sysfs_sc
 	"anon",
 	"memcg",
 	"young",
+	"hugepage_size",
 	"addr",
 	"target",
 };
_

Patches currently in -mm which might be from usamaarif642@gmail.com are


