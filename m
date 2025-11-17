Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932C922E004
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343249; cv=none; b=jCTk8JX+BQWdHIac44pYNbw3Hsq0FkpF4LLds1V7hiwkS3xU3ABg0KX1vGwxajX23FnnQEiJ17WdZw1VFe7SpUknTEKtSYgRML/L6L3kf9KNe4MKlLiElnfZIYVjNWxdMWV3N3ZHlOVQSG6sN6HigTc39l5XwyzLeANlnMVr7UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343249; c=relaxed/simple;
	bh=BsPioa5kPuvr3Gd+BDizOQxyLBumJC8AuF99Rw8hEzE=;
	h=Date:To:From:Subject:Message-Id; b=GwsyGz4dcijD+lg/9aatOqDncqQLDlvQwjaViPCiWI7o5T9mOfAhs2rzXd8pPAz5MO44TCjWa4QKiUTd63NSy6yBXlZ8m7pmH/zTq46pi7i65yDHSl6FYZYdGRaT9cFKhrDyJSHbMWYHFnloqCv9q9H6zo/L07E3/R0mRai+ZHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qIvHrSzA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qIvHrSzA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6926FC116D0;
	Mon, 17 Nov 2025 01:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343249;
	bh=BsPioa5kPuvr3Gd+BDizOQxyLBumJC8AuF99Rw8hEzE=;
	h=Date:To:From:Subject:From;
	b=qIvHrSzAhAVnNCmWAprkPITmTIb0gPcFtUffxUMTgYDry0yX8fMsSIxgOmUV4yH3F
	 9UVn/nU1cTBILK3waov8MmCiMwX4pFjcT12YnP+QFOTnl4tvnOpTG7hn+H17RfSASt
	 LmBEIq5CouCkoTi8/XPQPpRyKFNj2sT0VvrNlva0=
Date: Sun, 16 Nov 2025 17:34:08 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-stat-document-aggr_interval_us-parameter.patch removed from -mm tree
Message-Id: <20251117013409.6926FC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/stat: document aggr_interval_us parameter
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-stat-document-aggr_interval_us-parameter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/stat: document aggr_interval_us parameter
Date: Sun, 26 Oct 2025 11:22:12 -0700

Commit cc7ceb1d14b0 ("mm/damon/stat: expose the current tuned aggregation
interval"), has introduced 'aggr_interval_us' parameter for DAMON_STAT. 
But the new parameter is not yet documented.  Document it on the usage
document for the module.

Link: https://lkml.kernel.org/r/20251026182216.118200-8-sj@kernel.org
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

 Documentation/admin-guide/mm/damon/stat.rst |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/damon/stat.rst~docs-admin-guide-mm-damon-stat-document-aggr_interval_us-parameter
+++ a/Documentation/admin-guide/mm/damon/stat.rst
@@ -10,6 +10,8 @@ on the system's entire physical memory u
 access monitoring results statistics, namely idle time percentiles and
 estimated memory bandwidth.
 
+.. _damon_stat_monitoring_accuracy_overhead:
+
 Monitoring Accuracy and Overhead
 ================================
 
@@ -19,7 +21,9 @@ overhead minimum.  It auto-tunes the int
 events to be captured in each snapshot, while limiting the resulting sampling
 interval to be 5 milliseconds in minimum and 10 seconds in maximum.  On a few
 production server systems, it resulted in consuming only 0.x % single CPU time,
-while capturing reasonable quality of access patterns.
+while capturing reasonable quality of access patterns.  The tuning-resulting
+intervals can be retrieved via ``aggr_interval_us`` :ref:`parameter
+<damon_stat_aggr_interval_us>`.
 
 Interface: Module Parameters
 ============================
@@ -41,6 +45,18 @@ You can enable DAMON_STAT by setting the
 Setting it as ``N`` disables DAMON_STAT.  The default value is set by
 ``CONFIG_DAMON_STAT_ENABLED_DEFAULT`` build config option.
 
+.. _damon_stat_aggr_interval_us:
+
+aggr_interval_us
+----------------
+
+Auto-tuned aggregation time interval in microseconds.
+
+Users can read the aggregation interval of DAMON that is being used by the
+DAMON instance for DAMON_STAT.  It is :ref:`auto-tuned
+<damon_stat_monitoring_accuracy_overhead>` and therefore the value is
+dynamically changed.
+
 estimated_memory_bandwidth
 --------------------------
 
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

