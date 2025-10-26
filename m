Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45816747F
	for <mm-commits@vger.kernel.org>; Sun, 26 Oct 2025 19:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761507940; cv=none; b=JPWHPEycLuIVg5FnRZ7RrZozP6l5NtwuO9NplQ7BmhM3BLEB6w+Nbmi368zkq0MjZUcNszYJO6iI7u97EStXZHfMFzvla6wRkVMcfMdXMHP9uPowlAqc5uLMGKuRgS97CeXHHY2tHdIwy7+/7gyd6MZABiqVvO4w2CqCbe2TCW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761507940; c=relaxed/simple;
	bh=cte5cOqoT39Vcv+c+BOebfmCnwJqg9qyqDnAgPWRy5c=;
	h=Date:To:From:Subject:Message-Id; b=fVlUb6dxyj7Q7miazUypXm7XLQ4noazN8FopBKvSM7N4ogBizPHFPhpuRUWpI3l8AMPtBSXRCwRHJYbo2+hIuTM55itriVqL4Lfs+sBw+sZU/J5bE4S3kMR11k1MLd1nhuPzFxHL2z0J8VjwTBPww5oY+A2L8q1fx0KmyDnfgVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DeekRkO+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DeekRkO+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A92D5C4CEE7;
	Sun, 26 Oct 2025 19:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761507939;
	bh=cte5cOqoT39Vcv+c+BOebfmCnwJqg9qyqDnAgPWRy5c=;
	h=Date:To:From:Subject:From;
	b=DeekRkO+MfGNw+np88TJJljAmTSSvlC8tErH1WexWKIMS7VQPpuWTqoLIlANhBGWt
	 iOxbZS69ODrFIYozZ1YSQS9KA7A8Wf46+nBFfcBB5w7hLzx7u8IQ478y0CdgknRD7B
	 pQw5l9E3qQbVvEvTwjLpEs/tvkjR6dfnPFZd/8Pc=
Date: Sun, 26 Oct 2025 12:45:39 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-fix-wrong-link-to-intervals-goal-section.patch added to mm-unstable branch
Message-Id: <20251026194539.A92D5C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/design: fix wrong link to intervals goal section
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-fix-wrong-link-to-intervals-goal-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-fix-wrong-link-to-intervals-goal-section.patch

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
Subject: Docs/mm/damon/design: fix wrong link to intervals goal section
Date: Sun, 26 Oct 2025 11:22:07 -0700

Commit b243d666d107 ("Docs/admin-guide/mm/damon/usage: add intervals_goal
directory on the hierarchy") mistakenly added a wrong reference for
intervals goal usage documentation on the design document.  Fix it.

Link: https://lkml.kernel.org/r/20251026182216.118200-3-sj@kernel.org
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

 Documentation/mm/damon/design.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-fix-wrong-link-to-intervals-goal-section
+++ a/Documentation/mm/damon/design.rst
@@ -381,8 +381,8 @@ That is, assumes 4% (20% of 20%) DAMON-o
 to capture 64% (80% multipled by 80%) real access events (outcomes).
 
 To know how user-space can use this feature via :ref:`DAMON sysfs interface
-<sysfs_interface>`, refer to :ref:`intervals_goal <sysfs_scheme>` part of
-the documentation.
+<sysfs_interface>`, refer to :ref:`intervals_goal
+<damon_usage_sysfs_monitoring_intervals_goal>` part of the documentation.
 
 
 .. _damon_design_damos:
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

