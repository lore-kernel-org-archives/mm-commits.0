Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4550C3F7885
	for <mm-commits@vger.kernel.org>; Wed, 29 Apr 2026 12:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777467123; cv=none; b=AgHHQnaSTBYvDD3NsWK4xWQqJ3DwYPk9FaZvYq6JR1JBCh4n7h/uJ5NKVxY2q7Jey813h5xyjN3H7CunL1r67k5MV2jxECDVIT9pEkRaAb+Sg8OHmXzVU9I6Bp9ExurB7M32EGkZzA0qFoGS401YvEz43EssbNC6p2szUvtI52g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777467123; c=relaxed/simple;
	bh=pI4mNcnUk/u3tVyOwrlz8po1J/pukEW136MAtdDDbeQ=;
	h=Date:To:From:Subject:Message-Id; b=JZSc9Yp6VgBQZy+ki7INteWPaHW2nbROKOqYcZFk7xGYgHg0NqVij7BCBY/yRzzefHXDBKlC6dBKgIyMeO6g1/zdoAzjwLKWq2zOHOFUuDMikihr2B5mqzETE9vfir3S85XjYSFuRClWdjWiqi6pMC+/L+L/XL35MAVvElBUppQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hgi1cSt4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hgi1cSt4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E974BC19425;
	Wed, 29 Apr 2026 12:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777467123;
	bh=pI4mNcnUk/u3tVyOwrlz8po1J/pukEW136MAtdDDbeQ=;
	h=Date:To:From:Subject:From;
	b=hgi1cSt4tDd2Sg98WIMBJhfUfafK6hXJK6JYo1x87Q8ogNwCq4mQBbosu92zbiEzJ
	 jVZoI3GtZlFm2mKKYvdupy9DOVUTQPerhunqtkuFjju3tR8SFPZn5/JKlYjqEM8E7B
	 xC+hTW452Rs4F2CJf1/DFblrAxKctX1eUKjh9RJs=
Date: Wed, 29 Apr 2026 05:52:02 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-lru_sort-cover-all-system-rams.patch added to mm-new branch
Message-Id: <20260429125202.E974BC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/lru_sort: cover all system rams
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-lru_sort-cover-all-system-rams.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-lru_sort-cover-all-system-rams.patch

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
Subject: mm/damon/lru_sort: cover all system rams
Date: Tue, 28 Apr 2026 21:12:25 -0700

DAMON_LRU_SORT allows users to set the physical address range to monitor
and do the work on.  When users don't explicitly set the range, the
biggest system ram resource of the system is selected as the monitoring
target address range.  The intention was to reduce the overhead from
monitoring non-System RAM areas because monitoring non-System RAM may be
meaningless.  However, because of the sampling based access check and
adaptive regions adjustment, the overhead should be negligible.  It makes
more sense to just cover all system rams of the system.  Do so.

Link: https://lore.kernel.org/20260429041232.90257-4-sj@kernel.org
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

 mm/damon/lru_sort.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/damon/lru_sort.c~mm-damon-lru_sort-cover-all-system-rams
+++ a/mm/damon/lru_sort.c
@@ -139,7 +139,8 @@ DEFINE_DAMON_MODULES_MON_ATTRS_PARAMS(da
  * Start of the target memory region in physical address.
  *
  * The start physical address of memory region that DAMON_LRU_SORT will do work
- * against.  By default, biggest System RAM is used as the region.
+ * against.  By default, the system's entire physical memory is used as the
+ * region.
  */
 static unsigned long monitor_region_start __read_mostly;
 module_param(monitor_region_start, ulong, 0600);
@@ -148,7 +149,8 @@ module_param(monitor_region_start, ulong
  * End of the target memory region in physical address.
  *
  * The end physical address of memory region that DAMON_LRU_SORT will do work
- * against.  By default, biggest System RAM is used as the region.
+ * against.  By default, the system's entire physical memory is used as the
+ * region.
  */
 static unsigned long monitor_region_end __read_mostly;
 module_param(monitor_region_end, ulong, 0600);
@@ -326,7 +328,7 @@ static int damon_lru_sort_apply_paramete
 	if (err)
 		goto out;
 
-	err = damon_set_region_biggest_system_ram_default(param_target,
+	err = damon_set_region_system_rams_default(param_target,
 					&monitor_region_start,
 					&monitor_region_end,
 					param_ctx->addr_unit,
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

