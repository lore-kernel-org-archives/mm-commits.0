Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4AD36E495
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027582; cv=none; b=WDbDe3uGrtNwoB16bT3OpcEAnrmv/c0k6WdrFyALafdLAFCXtd1NVHWCMegm0vZg+giJZjWr8CmZsLHo+1iE7a48oBWDne/BZGAwM5dnM7jmj51EYf75LRH7B0qMs32bm02g9v2+jQsFTXeutJidUCi1+LVcY1HwiVGjd1izSF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027582; c=relaxed/simple;
	bh=cHkOyEiuGta8sa3zbMdmvIjX0nZX2UQrpRQxWJAtVTQ=;
	h=Date:To:From:Subject:Message-Id; b=YPnnw+0XlHDQ2nn6kiJ6ZKzwrZVHd4s+A0Y9+ALCTSu2sLPgk0zr5j7UTHtTPiFLCzLa+6U+P3NOf7TnlXoahvhS44YJBvx++sHtQ8mBNPd2CWncaIcPGnM4J+E9nugvOrQRb3/yoGikS/4BT569Q5WgIH3k2GTbCPBJrzsV3Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pW3JBRqP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pW3JBRqP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6241F00893;
	Fri, 29 May 2026 04:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027580;
	bh=FKxGAm8daXRXL6rqv/K5esrdsEA+ZVKIgEx9bfGX7vg=;
	h=Date:To:From:Subject;
	b=pW3JBRqP3RC5+ta8/no+3sYpdPgd9Su7ROi6XUJnBavwVig1gw4WZ3NOO0e9aAZfm
	 CA1CrtxL/g9BDBqh4qnRAvXYSQQN7MkYd03LDT3uq+t7L01o0CbDvNXKPb1J368RMw
	 jAgZjXJ97sETwOjqtF2DxpWAY0w/EDOd1NUhz7oc=
Date: Thu, 28 May 2026 21:06:20 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-document-fail_charge_numdenom-files.patch removed from -mm tree
Message-Id: <20260529040620.AB6241F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: document fail_charge_{num,denom} files
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-document-fail_charge_numdenom-files.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: document fail_charge_{num,denom} files
Date: Mon, 27 Apr 2026 18:33:55 -0700

Update DAMON usage document for the DAMOS action failed regions quota
charge ratio control sysfs files.

Link: https://lore.kernel.org/20260428013402.115171-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   18 +++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-document-fail_charge_numdenom-files
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -83,7 +83,9 @@ comma (",").
     │ │ │ │ │ │ │ │ sz/min,max
     │ │ │ │ │ │ │ │ nr_accesses/min,max
     │ │ │ │ │ │ │ │ age/min,max
-    │ │ │ │ │ │ │ :ref:`quotas <sysfs_quotas>`/ms,bytes,reset_interval_ms,effective_bytes,goal_tuner
+    │ │ │ │ │ │ │ :ref:`quotas <sysfs_quotas>`/ms,bytes,reset_interval_ms,
+    │ │ │ │ │ │ │     effective_bytes,goal_tuner,
+    │ │ │ │ │ │ │     fail_charge_num,fail_charge_denom
     │ │ │ │ │ │ │ │ weights/sz_permil,nr_accesses_permil,age_permil
     │ │ │ │ │ │ │ │ :ref:`goals <sysfs_schemes_quota_goals>`/nr_goals
     │ │ │ │ │ │ │ │ │ 0/target_metric,target_value,current_value,nid,path
@@ -377,9 +379,10 @@ schemes/<N>/quotas/
 The directory for the :ref:`quotas <damon_design_damos_quotas>` of the given
 DAMON-based operation scheme.
 
-Under ``quotas`` directory, five files (``ms``, ``bytes``,
-``reset_interval_ms``, ``effective_bytes`` and ``goal_tuner``) and two
-directories (``weights`` and ``goals``) exist.
+Under ``quotas`` directory, seven files (``ms``, ``bytes``,
+``reset_interval_ms``, ``effective_bytes``, ``goal_tuner``, ``fail_charge_num``
+and ``fail_charge_denom``) and two directories (``weights`` and ``goals``)
+exist.
 
 You can set the ``time quota`` in milliseconds, ``size quota`` in bytes, and
 ``reset interval`` in milliseconds by writing the values to the three files,
@@ -398,6 +401,13 @@ the background design of the feature and
 Refer to :ref:`goals directory <sysfs_schemes_quota_goals>` for the goals
 setup.
 
+You can set the action-failed memory quota charging ratio by writing the
+numerator and the denominator for the ratio to ``fail_charge_num`` and
+``fail_charge_denom`` files, respectively.  Reading those files will return the
+current set values.  Refer to :ref:`design
+<damon_design_damos_quotas_failed_memory_charging_ratio>` for more details of
+the ratio feature.
+
 The time quota is internally transformed to a size quota.  Between the
 transformed size quota and user-specified size quota, smaller one is applied.
 Based on the user-specified :ref:`goal <sysfs_schemes_quota_goals>`, the
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-ops-common-call-folio_test_lru-after-folio_get.patch
mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
mm-damon-core-introduce-struct-damon_probe.patch
mm-damon-core-embed-damon_probe-objects-in-damon_ctx.patch
mm-damon-core-introduce-damon_filter.patch
mm-damon-core-commit-probes.patch
mm-damon-core-introduce-damon_region-probe_hits.patch
mm-damon-core-introduce-damon_ops-apply_probes.patch
mm-damon-core-do-data-attributes-monitoring.patch
mm-damon-paddr-support-data-attributes-monitoring.patch
mm-damon-sysfs-implement-probes-dir.patch
mm-damon-sysfs-implement-probe-dir.patch
mm-damon-sysfs-implement-filters-directory.patch
mm-damon-sysfs-implement-filter-dir.patch
mm-damon-sysfs-implement-filter-dir-files.patch
mm-damon-sysfs-setup-probes-on-damon-core-api-parameters.patch
mm-damon-sysfs-schemes-implement-tried_regions-r-probes.patch
mm-damon-sysfs-schemes-implement-probe-dir.patch
mm-damon-sysfs-schemes-implement-probe-hits-file.patch
mm-damon-trace-probe_hits.patch
selftests-damon-sysfssh-test-probes-dir.patch
docs-mm-damon-design-document-data-attributes-monitoring.patch
docs-admin-guide-mm-damon-usage-document-data-attributes-monitoring.patch
mm-damon-core-introduce-damon_filter_type_memcg.patch
mm-damon-paddr-support-damon_filter_type_memcg.patch
mm-damon-sysfs-add-filters-f-path-file.patch
mm-damon-sysfs-schemes-move-memcg_path_to_id-to-sysfs-common.patch
mm-damon-sysfs-setup-damon_filter-memcg_id-from-path.patch
docs-mm-damon-design-update-for-memcg-damon-filter.patch
docs-admin-guide-mm-damon-usage-update-for-memcg-damon-filter.patch
mm-damon-core-safely-handle-no-region-case-in-damon_set_regions.patch
mm-damon-core-do-not-use-region-out-of-a-loop-in-damon_set_regions.patch
samples-damon-mtier-replace-damon_add_region-with-damon_set_regions.patch
mm-damon-tests-vaddr-kunit-replace-damon_add_region-with-damon_set_regions.patch
mm-damon-core-hide-damon_add_region.patch
mm-damon-core-hide-damon_insert_region.patch
mm-damon-core-hide-damon_destroy_region.patch
mm-damon-core-add-kdamond_call-debug_sanity-check.patch
mm-damon-core-remove-damon_verify_nr_regions.patch
mm-damon-tests-core-kunit-add-damon_set_regions-test-cases.patch
selftests-damon-sysfspy-stop-kdamonds-before-failing.patch
selftests-damon-sysfssh-test-monitoring-intervals-goal-dir.patch
selftests-damon-sysfssh-test-addr_unit-file-existence.patch
selftests-damon-sysfssh-test-pause-file-existence.patch
mm-damon-core-trace-esz-at-first-setup.patch

