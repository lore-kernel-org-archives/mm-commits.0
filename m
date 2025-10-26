Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D5E747F
	for <mm-commits@vger.kernel.org>; Sun, 26 Oct 2025 19:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761507944; cv=none; b=oODDdHf3/t0DfGdoRwR8mHEFrjO6GPPwB3nVwcMfskupbQhQoNo/umD19+GgnEXzxfKOvJE625AcmnKUWWZae0s0h0PQ/7PLZA6NqwT/pB5hnezk8AyeWl/dl28f1RMK4qtif7h111xlvIIJ6Sb/SNpzvwWN6ZUnpbf+qOATp8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761507944; c=relaxed/simple;
	bh=/ic+qqBMP4iqsIvwhP1wpWTIrIcIdZ4NikI2EXx2VAo=;
	h=Date:To:From:Subject:Message-Id; b=uKl3JE29D4/BAE0zlUgnhqH4cP0YuLbp2BRCsqHGMFEKOjmOfvz706K6XGQPsPqusNntViojmiml2qe0CHmIEyqzxq20sK683Nzx8yFrHlV7G8CXunviQ/5Op0KV6D6lxf9BP1+3WknglpYUoUnPNwDSZgA4dwmODxozBhlSjVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c3i8hJs+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c3i8hJs+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2CBFC4CEE7;
	Sun, 26 Oct 2025 19:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761507943;
	bh=/ic+qqBMP4iqsIvwhP1wpWTIrIcIdZ4NikI2EXx2VAo=;
	h=Date:To:From:Subject:From;
	b=c3i8hJs+VI7ZAti1136GgF4NGf3yaDEoy8FalNQhjSBQTkdVkKWNueR/o34RNL7AD
	 LBlRnmI8lEK3dmJWr0Kjj6pY2cfS0H7ejrxWYd9JhJYElr+HsHr3kv4CgY3jIhYvMw
	 RPmfe0deEwBZ6HxBN29sMJWYpfSDxlv0B/FyITp0=
Date: Sun, 26 Oct 2025 12:45:43 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-document-empty-target-regions-commit-behavior.patch added to mm-unstable branch
Message-Id: <20251026194543.C2CBFC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: document empty target regions commit behavior
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-usage-document-empty-target-regions-commit-behavior.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-document-empty-target-regions-commit-behavior.patch

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
Subject: Docs/admin-guide/mm/damon/usage: document empty target regions commit behavior
Date: Sun, 26 Oct 2025 11:22:09 -0700

Committing a monitoring target with empty target regions is for keeping
the current monitoring results.  This behavior was introduced by commit
973233600676 ("mm/damon/sysfs: update monitoring target regions for online
input commit").  The behavior is not documented, though.  Update the usage
document for clarifying this behavior.

Link: https://lkml.kernel.org/r/20251026182216.118200-5-sj@kernel.org
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

 Documentation/admin-guide/mm/damon/usage.rst |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-document-empty-target-regions-commit-behavior
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -134,7 +134,8 @@ Users can write below commands for the k
 - ``on``: Start running.
 - ``off``: Stop running.
 - ``commit``: Read the user inputs in the sysfs files except ``state`` file
-  again.
+  again.  Monitoring :ref:`target region <sysfs_regions>` inputs are also be
+  ignored if no target region is specified.
 - ``update_tuned_intervals``: Update the contents of ``sample_us`` and
   ``aggr_us`` files of the kdamond with the auto-tuning applied ``sampling
   interval`` and ``aggregation interval`` for the files.  Please refer to
@@ -289,6 +290,11 @@ In the beginning, this directory has onl
 number (``N``) to the file creates the number of child directories named ``0``
 to ``N-1``.  Each directory represents each initial monitoring target region.
 
+If ``nr_regions`` is zero when committing new DAMON parameters online (writing
+``commit`` to ``state`` file of :ref:`kdamond <sysfs_kdamond>`), the commit
+logic ignores the target regions.  In other words, the current monitoring
+results for the target are preserved.
+
 .. _sysfs_region:
 
 regions/<N>/
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

