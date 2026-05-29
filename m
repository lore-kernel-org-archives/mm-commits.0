Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4F236EAB9
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027664; cv=none; b=CEui92c9wWZJur9Ne2w+D0UC/LW02vUDS69MbI84sRN0vT4iQ0ZxloNsWd4CFdNPdi2IHwOSwNagS8Tp0c/nYcWOXJqKDtA/6PfCLE3dyvuK23FRJAnASJZDs8MKTok9HtKHNNE4Tao6e9k1HlAsWWbUQBqIn8M0XeF84EQ5NSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027664; c=relaxed/simple;
	bh=Q2dNHlwGKrqbXKTD7isWYosY4t+uNRIGNPhgB288aiM=;
	h=Date:To:From:Subject:Message-Id; b=NoxjYEjZ6iA8+sUiUSgyCxcRP5Xwqzd8fStEcJoIU+3XGy88UPHfZEDF4Tvp9lqB1VPcXKAcFbWEMuPsyn4kmQ3GrfzfGBmmh2e2dyAmCvGzlTg5kVmWjKwE6xxLAYf/7VSHViZiqAJHRLVeQDgrYgzhqBANVRWutSlNHv0qWVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=euZLfoxU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="euZLfoxU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A611F00893;
	Fri, 29 May 2026 04:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027663;
	bh=/RATGxOTH+hHsp2O+pSWWjWLHMwRbOrcBiJCRqqJe/Y=;
	h=Date:To:From:Subject;
	b=euZLfoxUc6kMFCPFpF0aMZxUFTjZgDdU1idv8SoFyVLE1QWXDYw37hdoAkqjkfz2z
	 ddVBF8Y27Bb/gEgMln+ml6hrRmRB9906n3bpMnlx3eznNo6ZtDm9oPvVC5VkWKSIK/
	 9A219eW7NrzjK2qSaL94SdUp7d/m3Y+wxn3g0u14=
Date: Thu, 28 May 2026 21:07:42 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-drgn_dump_damon_status-dump-pause.patch removed from -mm tree
Message-Id: <20260529040743.11A611F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/drgn_dump_damon_status: dump pause
has been removed from the -mm tree.  Its filename was
     selftests-damon-drgn_dump_damon_status-dump-pause.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/drgn_dump_damon_status: dump pause
Date: Mon, 27 Apr 2026 08:12:27 -0700

drgn_dump_damon_status is not dumping the damon_ctx->pause parameter
value, so it cannot be tested.  Dump it for future tests.

Link: https://lore.kernel.org/20260427151231.113429-9-sj@kernel.org
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

 tools/testing/selftests/damon/drgn_dump_damon_status.py |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/damon/drgn_dump_damon_status.py~selftests-damon-drgn_dump_damon_status-dump-pause
+++ a/tools/testing/selftests/damon/drgn_dump_damon_status.py
@@ -202,6 +202,7 @@ def damon_ctx_to_dict(ctx):
         ['attrs', attrs_to_dict],
         ['adaptive_targets', targets_to_list],
         ['schemes', schemes_to_list],
+        ['pause', bool],
         ])
 
 def main():
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

