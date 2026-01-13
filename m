Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B4D833F8D4
	for <mm-commits@vger.kernel.org>; Tue, 13 Jan 2026 22:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768343883; cv=none; b=cWRDQ3WTTfbkM3v3q+YTjbiIy3s8UNpxDrju39d+wTliH8oiUtFCC0xuo96KcPfZOsiYeo1+4Nalesm/0K57gx70imAQkx70KxOfXxciISTnhjMfkgTPFyRo/G9Y37INrMESIbNdiVZ22n08zbSJio9lRAPcDl3U9rWaHqDEy/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768343883; c=relaxed/simple;
	bh=roszXoZmngnInxcMOXB9lYHr3B4jJzdauBTxyfs91CA=;
	h=Date:To:From:Subject:Message-Id; b=srtGl9S5t3FY3ZZedgk0IcKKn3vKJNt/PqFktaqBacxx+YlVxV7la5E6yjwk6jr3NCy725xgFGoZP8lqS+mzi1nT1Tux7oGRRgzqwCt+wukjHDxKPWb6dnRLod6rq+3F+diydWPo2jlk1F9GIM17Gl+VeUYdEfk6dmeL950kCyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dftRhsU7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dftRhsU7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7B5C116C6;
	Tue, 13 Jan 2026 22:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768343882;
	bh=roszXoZmngnInxcMOXB9lYHr3B4jJzdauBTxyfs91CA=;
	h=Date:To:From:Subject:From;
	b=dftRhsU7vItlBFaSLJcFTylAqM9MaMCPJtytxrZ6RRua+rL3A4GXHozfB346QK5UA
	 JGeYwFAMEzj+KaaDG64jQRTvAS9ajrOnel3go0lVpDnblVtGZvQN5IOMg8RNTOabdj
	 D6lvXqeF0o+myfHeZy8a0KPn4sNocSBVfLtdV/ks=
Date: Tue, 13 Jan 2026 14:38:01 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-document-damos_quota_active_mem_bp.patch added to mm-new branch
Message-Id: <20260113223802.AC7B5C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/design: document DAMOS_QUOTA_[IN]ACTIVE_MEM_BP
has been added to the -mm mm-new branch.  Its filename is
     docs-mm-damon-design-document-damos_quota_active_mem_bp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-document-damos_quota_active_mem_bp.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
Subject: Docs/mm/damon/design: document DAMOS_QUOTA_[IN]ACTIVE_MEM_BP
Date: Tue, 13 Jan 2026 07:27:08 -0800

Update design document for newly added DAMOS_QUOTA_[IN]ACTIVE_MEM_BP
metrics.  Note that API document is automatically updated by kernel-doc
comment, and the usage document points to the design document which uses
keywords same to that for sysfs inputs.  Hence updating only design
document is sufficient.

Link: https://lkml.kernel.org/r/20260113152717.70459-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |    4 ++++
 1 file changed, 4 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-document-damos_quota_active_mem_bp
+++ a/Documentation/mm/damon/design.rst
@@ -585,6 +585,10 @@ mechanism tries to make ``current_value`
   specific NUMA node, in bp (1/10,000).
 - ``node_memcg_free_bp``: Specific cgroup's node unused memory ratio for a
   specific NUMA node, in bp (1/10,000).
+- ``active_mem_bp``: Active to active + inactive (LRU) memory size ratio in bp
+  (1/10,000).
+- ``inactive_mem_bp``: Inactive to active + inactive (LRU) memory size ratio in
+  bp (1/10,000).
 
 ``nid`` is optionally required for only ``node_mem_used_bp``,
 ``node_mem_free_bp``, ``node_memcg_used_bp`` and ``node_memcg_free_bp`` to
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-nr_snapshots-damos-stat.patch
mm-damon-sysfs-schemes-introduce-nr_snapshots-damos-stat-file.patch
docs-mm-damon-design-update-for-nr_snapshots-damos-stat.patch
docs-admin-guide-mm-damon-usage-update-for-nr_snapshots-damos-stat.patch
docs-abi-damon-update-for-nr_snapshots-damos-stat.patch
mm-damon-update-damos-kerneldoc-for-stat-field.patch
mm-damon-core-implement-max_nr_snapshots.patch
mm-damon-sysfs-schemes-implement-max_nr_snapshots-file.patch
docs-mm-damon-design-update-for-max_nr_snapshots.patch
docs-admin-guide-mm-damon-usage-update-for-max_nr_snapshots.patch
docs-abi-damon-update-for-max_nr_snapshots.patch
mm-damon-core-add-trace-point-for-damos-stat-per-apply-interval.patch
mm-damon-tests-core-kunit-add-test-cases-for-multiple-regions-in-damon_test_split_regions_of-fix.patch
mm-damon-core-introduce-active-memory-ratio-damos-quota-goal-metric.patch
mm-damon-sysfs-schemes-support-damos_quota_active_mem_bp.patch
docs-mm-damon-design-document-damos_quota_active_mem_bp.patch
mm-damon-paddr-activate-damos_lru_prio-targets-instead-of-marking-accessed.patch
mm-damon-lru_sort-consider-age-for-quota-prioritization.patch
mm-damon-lru_sort-support-young-page-filters.patch
docs-admin-guide-mm-damon-lru_sort-document-filter_young_pages.patch
mm-damon-lru_sort-support-active-inactive-memory-ratio-based-auto-tuning.patch
docs-admin-guide-mm-damon-lru_sort-document-active_mem_bp-parameter.patch
mm-damon-lru_sort-add-monitoring-intervals-auto-tuning-parameter.patch
docs-admin-guide-mm-damon-lru_sort-document-intervals-autotuning.patch

