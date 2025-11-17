Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68199231A23
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343248; cv=none; b=Em0ZSAlo82413fWSAJ0fx30G2cJmP9IzWAHke0sjk1dnoVnYnFxKNQEp2scM6jxkOu+N0WsWLBnjecI2PdJbVRzdjoYJjeI9tmk1IN/kKiclXNneO4S8slV/EX7pSHQqBiz7DnlE7WO5GKaM/waOLuNGxizL4DV/ElDojJO+5B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343248; c=relaxed/simple;
	bh=8MGtWO4yGudrpCrYEmDdn/5n+Xj5rvbAibTctM9nG3I=;
	h=Date:To:From:Subject:Message-Id; b=hBVThaX62ypKk9vYUa+2iZgEXKQSZV9RPyLhpnACGsqZ9+pu93HJTrvpMEOcEm7qMnlPxOUh6HuqkIILXFf/mpaXaAFxmjX7G69QCB0kFRQ49OCM3Xi5fdWVSZZfIIyP4kf3d6jU8Xm0223GUa46WnI78JX0zLU+e3cG5wBdj+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KXpxWbQj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KXpxWbQj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE82C4CEF1;
	Mon, 17 Nov 2025 01:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343248;
	bh=8MGtWO4yGudrpCrYEmDdn/5n+Xj5rvbAibTctM9nG3I=;
	h=Date:To:From:Subject:From;
	b=KXpxWbQjVuD++0lSeoiCyrbXM4pbvakgayhetXHGcFNpAoGyuIZF3O7H+ngwfg2Zr
	 5R54v/+MUwycl6Oall5pOz/QwtftsBPJ8irwQk7QZr6E31dwx5KZqiv60QzAGpYVEn
	 9my3u2IUd31R1yF2yL77UctDi42jkXwULyzz4HRU=
Date: Sun, 16 Nov 2025 17:34:07 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-lru_sort-document-addr_unit-parameter.patch removed from -mm tree
Message-Id: <20251117013408.3BE82C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/lru_sort: document addr_unit parameter
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-lru_sort-document-addr_unit-parameter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/lru_sort: document addr_unit parameter
Date: Sun, 26 Oct 2025 11:22:11 -0700

Commit 2e0fe9245d6b ("mm/damon/lru_sort: support addr_unit for
DAMON_LRU_SORT") introduced the 'addr_unit' parameter for DAMON_LRU_SORT. 
But the usage document is not updated for that.  Update the document.

Link: https://lkml.kernel.org/r/20251026182216.118200-7-sj@kernel.org
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

 Documentation/admin-guide/mm/damon/lru_sort.rst |   22 ++++++++++++++
 1 file changed, 22 insertions(+)

--- a/Documentation/admin-guide/mm/damon/lru_sort.rst~docs-admin-guide-mm-damon-lru_sort-document-addr_unit-parameter
+++ a/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -211,6 +211,28 @@ End of target memory region in physical
 The end physical address of memory region that DAMON_LRU_SORT will do work
 against.  By default, biggest System RAM is used as the region.
 
+addr_unit
+---------
+
+A scale factor for memory addresses and bytes.
+
+This parameter is for setting and getting the :ref:`address unit
+<damon_design_addr_unit>` parameter of the DAMON instance for DAMON_RECLAIM.
+
+``monitor_region_start`` and ``monitor_region_end`` should be provided in this
+unit.  For example, let's suppose ``addr_unit``, ``monitor_region_start`` and
+``monitor_region_end`` are set as ``1024``, ``0`` and ``10``, respectively.
+Then DAMON_LRU_SORT will work for 10 KiB length of physical address range that
+starts from address zero (``[0 * 1024, 10 * 1024)`` in bytes).
+
+Stat parameters having ``bytes_`` prefix are also in this unit.  For example,
+let's suppose values of ``addr_unit``, ``bytes_lru_sort_tried_hot_regions`` and
+``bytes_lru_sorted_hot_regions`` are ``1024``, ``42``, and ``32``,
+respectively.  Then it means DAMON_LRU_SORT tried to LRU-sort 42 KiB of hot
+memory and successfully LRU-sorted 32 KiB of the memory in total.
+
+If unsure, use only the default value (``1``) and forget about this.
+
 kdamond_pid
 -----------
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-tests-core-kunit-remove-dynamic-allocs-on-damos_test_commit_filter.patch
mm-damon-tests-core-kunit-split-out-damos_test_commit_filter-core-logic.patch
mm-damon-tests-core-kunit-extend-damos_test_commit_filter_for-for-union-fields.patch
mm-damon-tests-core-kunit-add-test-cases-to-damos_test_commit_filter.patch
mm-damon-tests-core-kunit-add-damos_commit_quota_goal-test.patch
mm-damon-tests-core-kunit-add-damos_commit_quota_goals-test.patch
mm-damon-tests-core-kunit-add-damos_commit_quota-test.patch
mm-damon-core-pass-migrate_dests-to-damos_commit_dests.patch
mm-damon-tests-core-kunit-add-damos_commit_dests-test.patch
mm-damon-tests-core-kunit-add-damos_commit-test.patch
mm-damon-tests-core-kunit-add-damon_commit_target_regions-test.patch
mm-damon-rename-damos-core-filter-helpers-to-have-word-core.patch
mm-damon-rename-damos-filters-to-damos-core_filters.patch
mm-damon-vaddr-cleanup-using-pmd_trans_huge_lock.patch
mm-damon-vaddr-use-vm_normal_folio_pmd-instead-of-damon_get_folio.patch
mm-damon-vaddr-consistently-use-only-pmd_entry-for-damos_migrate.patch
mm-damon-tests-core-kunit-remove-damon_min_region-redefinition.patch
selftests-damon-sysfspy-merge-damon-status-dumping-into-commitment-assertion.patch
docs-mm-damon-maintainer-profile-fix-a-typo-on-mm-untable-link.patch
docs-mm-damon-maintainer-profile-fix-grammartical-errors.patch

