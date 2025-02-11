Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD73272908
	for <mm-commits@vger.kernel.org>; Tue, 11 Feb 2025 23:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739315437; cv=none; b=twccYOtSLEz8ev06sW0h2pGkcT/El6Jwn8XBsNql0NeaFi85QMapXjirTPvI9DzFT4pufE+BC+UN4IrrI2i5R3fZCcJld49eejFx0Di3c8i4FBKyMuYVEU1HC+3Bak5hbayZ8uJWKpXEXcr6H4EHFj6q4lpPe8qvZiMEgkbnUcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739315437; c=relaxed/simple;
	bh=DUAPpF5Fm7c28b9QqbJWUH5zQxEU37InIVExBiyKZIU=;
	h=Date:To:From:Subject:Message-Id; b=nv6wjBuVlZmEjvj8ZnAfCOOnnVVyrHh2Vyf2aqiPqmgP1wj8zIK89CU7svt4twWkOEpG0W5J+CZBTlJxJJv9dnNJbeh1XmArwKasNENj6WikwfBnG5yrUOfK64lFifH6ZiwOai2ZkQmZVdlqTu1oydI0pym/67iLPuKca1Vy988=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X99lxfnM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X99lxfnM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53273C4CEDD;
	Tue, 11 Feb 2025 23:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739315436;
	bh=DUAPpF5Fm7c28b9QqbJWUH5zQxEU37InIVExBiyKZIU=;
	h=Date:To:From:Subject:From;
	b=X99lxfnMYUqujATgrPlKwA7reXd45nx6JXeV2t0EYa5zGe+8H4wG8VTifa8VfpYd5
	 y+B21FlxgKQthVmsd5JEhjIwTmG0KXkb4UnT9/wGAJI4Qhcn0i4GoOJ+Q3CQ8o7uyd
	 p/RBrPxLkZXCF6ybNo1hpUB3JYBx568d4VvOswic=
Date: Tue, 11 Feb 2025 15:10:35 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,hannes@cmpxchg.org,david@redhat.com,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-introduce-damos-filter-type-hugepage_size.patch added to mm-unstable branch
Message-Id: <20250211231036.53273C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: introduce DAMOS filter type hugepage_size
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-introduce-damos-filter-type-hugepage_size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-introduce-damos-filter-type-hugepage_size.patch

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

Link: https://lkml.kernel.org/r/20250211124437.278873-1-usamaarif642@gmail.com
Link: https://lkml.kernel.org/r/20250211124437.278873-2-usamaarif642@gmail.com
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h    |   13 +++++++++++++
 mm/damon/core.c          |    3 +++
 mm/damon/paddr.c         |    6 ++++++
 mm/damon/sysfs-schemes.c |    1 +
 4 files changed, 23 insertions(+)

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
@@ -376,6 +388,7 @@ struct damos_filter {
 		unsigned short memcg_id;
 		struct damon_addr_range addr_range;
 		int target_idx;
+		struct damon_size_range sz_range;
 	};
 	struct list_head list;
 };
--- a/mm/damon/core.c~mm-damon-introduce-damos-filter-type-hugepage_size
+++ a/mm/damon/core.c
@@ -776,6 +776,9 @@ static void damos_commit_filter_arg(
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
@@ -203,6 +203,7 @@ static bool damos_pa_filter_match(struct
 {
 	bool matched = false;
 	struct mem_cgroup *memcg;
+	size_t folio_sz;
 
 	switch (filter->type) {
 	case DAMOS_FILTER_TYPE_ANON:
@@ -222,6 +223,11 @@ static bool damos_pa_filter_match(struct
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

mm-damon-ops-have-damon_get_folio-return-folio-even-for-tail-pages.patch
mm-damon-introduce-damos-filter-type-hugepage_size.patch
mm-damon-sysfs-schemes-add-files-for-setting-damos_filter-sz_range.patch
docs-abi-damon-document-damos-sysfs-files-to-set-the-min-max-folio_size.patch
docs-admin-guide-mm-damon-usage-document-hugepage_size-filter-type.patch

