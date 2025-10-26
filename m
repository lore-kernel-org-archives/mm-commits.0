Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4910747F
	for <mm-commits@vger.kernel.org>; Sun, 26 Oct 2025 19:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761507952; cv=none; b=qWtBJb10KND+mVGq34l/5xM+iYY/6fKDbZqnb8yw2j/uEC3y9YsZETWVp80Ng/zQnVSC/L4ln50IvzH2yF8ZIzVeHEXFW32AQ7+MpN523rqWiLh3RvJevCWCjHPf8aq6BmC0TJYSJT2cTJeSIRYJnPyHbdVgF+9tVhqZS3MRsmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761507952; c=relaxed/simple;
	bh=yzJby/hLszEodPnea0TYuNMNnBFn00zMUgksy2y5M3I=;
	h=Date:To:From:Subject:Message-Id; b=IEL7Cp5rS+ICoOiSTpyZp5ZoCu+wERItRROsn1pu0Qs78tJBJBk3ZXj6wWnskR7+db6yhg5gT+0erB1+gBNEA+WNpv6e+Rl9WsF1vX1e9UM4LIoR62D5IZ68MK7gPJmjJM96bTpFEY2qPjhfTYVrlP5LUanTrDFhAt5dIUmimwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lUrE3mi3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lUrE3mi3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFA1EC4CEE7;
	Sun, 26 Oct 2025 19:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761507951;
	bh=yzJby/hLszEodPnea0TYuNMNnBFn00zMUgksy2y5M3I=;
	h=Date:To:From:Subject:From;
	b=lUrE3mi3TfkcZV/888SVyBvdDZr+SGTrddtXswYqOTOne6XVU9bpX5Ewetw5U+66j
	 2Q08DNl622HCEArLxcBxBlyarRNtAuopO614tMw49BqPYa128lwkxnSz7fexKx83cl
	 HtygVzdPyp/UrUlsFs0T6dtDdWxcIXUmroemjsHM=
Date: Sun, 26 Oct 2025 12:45:51 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-stat-document-negative-idle-time.patch added to mm-unstable branch
Message-Id: <20251026194551.AFA1EC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/admin-guide/mm/damon/stat: document negative idle time
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-stat-document-negative-idle-time.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-stat-document-negative-idle-time.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/stat: document negative idle time
Date: Sun, 26 Oct 2025 11:22:13 -0700

Commit a983a26d5298 ("mm/damon/stat: expose negative idle time")
introduced the negative idle time feature for DAMON_STAT.  But it is not
documented.  Document it on the usage document.

Link: https://lkml.kernel.org/r/20251026182216.118200-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/stat.rst |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/Documentation/admin-guide/mm/damon/stat.rst~docs-admin-guide-mm-damon-stat-document-negative-idle-time
+++ a/Documentation/admin-guide/mm/damon/stat.rst
@@ -74,12 +74,13 @@ memory_idle_ms_percentiles
 Per-byte idle time (milliseconds) percentiles of the system.
 
 DAMON_STAT calculates how long each byte of the memory was not accessed until
-now (idle time), based on the current DAMON results snapshot.  If DAMON found a
-region of access frequency (nr_accesses) larger than zero, every byte of the
-region gets zero idle time.  If a region has zero access frequency
-(nr_accesses), how long the region was keeping the zero access frequency (age)
-becomes the idle time of every byte of the region.  Then, DAMON_STAT exposes
-the percentiles of the idle time values via this read-only parameter.  Reading
-the parameter returns 101 idle time values in milliseconds, separated by comma.
+now (idle time), based on the current DAMON results snapshot.  For regions
+having access frequency (nr_accesses) larger than zero, how long the current
+access frequency level was kept multiplied by ``-1`` becomes the idlee time of
+every byte of the region.  If a region has zero access frequency (nr_accesses),
+how long the region was keeping the zero access frequency (age) becomes the
+idle time of every byte of the region.  Then, DAMON_STAT exposes the
+percentiles of the idle time values via this read-only parameter.  Reading the
+parameter returns 101 idle time values in milliseconds, separated by comma.
 Each value represents 0-th, 1st, 2nd, 3rd, ..., 99th and 100th percentile idle
 times.
_

Patches currently in -mm which might be from sj@kernel.org are

mm-zswap-remove-unnecessary-dlen-writes-for-incompressible-pages.patch
mm-zswap-fix-typos-s-zwap-zswap.patch
mm-zswap-s-red-black-tree-xarray.patch
docs-admin-guide-mm-zswap-s-red-black-tree-xarray.patch
mm-damon-document-damos_quota_goal-nid-use-case.patch
mm-damon-add-damos-quota-goal-type-for-per-memcg-per-node-memory-usage.patch
mm-damon-core-implement-damos_quota_node_memcg_used_bp.patch
mm-damon-sysfs-schemes-implement-path-file-under-quota-goal-directory.patch
mm-damon-sysfs-schemes-support-damos_quota_node_memcg_used_bp.patch
mm-damon-core-add-damos-quota-gaol-metric-for-per-memcg-per-numa-free-memory.patch
mm-damon-sysfs-schemes-support-damos_quota_node_memcg_free_bp.patch
docs-mm-damon-design-document-damos_quota_node_memcg_usedfree_bp.patch
docs-admin-guide-mm-damon-usage-document-damos-quota-goal-path-file.patch
docs-abi-damon-document-damos-quota-goal-path-file.patch
mm-damon-core-fix-wrong-comment-of-damon_call-return-timing.patch
docs-mm-damon-design-fix-wrong-link-to-intervals-goal-section.patch
docs-admin-guide-mm-damon-stat-fix-a-typo-s-sampling-events-sampling-interval.patch
docs-admin-guide-mm-damon-usage-document-empty-target-regions-commit-behavior.patch
docs-admin-guide-mm-damon-reclaim-document-addr_unit-parameter.patch
docs-admin-guide-mm-damon-lru_sort-document-addr_unit-parameter.patch
docs-admin-guide-mm-damon-stat-document-aggr_interval_us-parameter.patch
docs-admin-guide-mm-damon-stat-document-negative-idle-time.patch
mm-damon-core-add-damon_target-obsolete-for-pin-point-removal.patch
mm-damon-sysfs-test-commit-input-against-realistic-destination.patch
mm-damon-sysfs-implement-obsolete_target-file.patch
docs-admin-guide-mm-damon-usage-document-obsolete_target-file.patch
docs-abi-damon-document-obsolete_target-sysfs-file.patch
selftests-damon-_damon_sysfs-support-obsolete_target-file.patch
drgn_dump_damon_status-dump-damon_target-obsolete.patch
sysfspy-extend-assert_ctx_committed-for-monitoring-targets.patch
selftests-damon-sysfs-add-obsolete_target-test.patch

