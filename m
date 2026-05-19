Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59FA920C461
	for <mm-commits@vger.kernel.org>; Tue, 19 May 2026 00:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779152162; cv=none; b=YsT0NoMu9rv9vbA+JL+tyhpZu5rOR00w8aBlCDJfHPlvcFjiCiMXCnecy9H+S+BL0pTJdB9JeuWaLd4MOahQ5Z4/mn+fUk3g+XAzAffH2sS5Au+FNo9CrgdzqztjKOj6W2I6Mm2/zsVehaukYx/+Y0NQd7NU/CRmir/ezHXe/iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779152162; c=relaxed/simple;
	bh=bSQABZn2E0sCPEVE4dzSBli6JPm8TeLe+Q8PPwGnueA=;
	h=Date:To:From:Subject:Message-Id; b=Md0Kdja/W7vcw4L9UEttoPgWXyHEfFsdhmRi5mio73oO6TACC6raKgdiR/veZqVH/zKqVSkOk+7RRH1XLHKSwk970HMajC3Esa35Fx5A2cUlO5kKXWevfU7Y9FY809v1DGkyGq5vpXjsF64AwUuTaXSYKgPhA93MAthHutHzF48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2sMWAnuL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2sMWAnuL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34675C2BCB7;
	Tue, 19 May 2026 00:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779152162;
	bh=bSQABZn2E0sCPEVE4dzSBli6JPm8TeLe+Q8PPwGnueA=;
	h=Date:To:From:Subject:From;
	b=2sMWAnuLE6kdOLswyOceOeUI7am763hB3uAFGYC+/9eNS7XMDGPyAdrHmnrQ4ZqYp
	 L40Y4nHTsqKoIrfSReFsLpdK9biwEWecisu+1SMYg00MgksLjz9XMUoQPJdUdyzChP
	 j24OlVWOhmKj02Fd9AdyxWefzO2wL6javv7BkcEE=
Date: Mon, 18 May 2026 17:56:01 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-move-memcg_path_to_id-to-sysfs-common.patch added to mm-new branch
Message-Id: <20260519005602.34675C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs-schemes: move memcg_path_to_id() to sysfs-common
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-schemes-move-memcg_path_to_id-to-sysfs-common.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-move-memcg_path_to_id-to-sysfs-common.patch

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
Subject: mm/damon/sysfs-schemes: move memcg_path_to_id() to sysfs-common
Date: Mon, 18 May 2026 16:41:13 -0700

The next commit will need to find the memcg id from the user-passed path
to the memory cgroup, from sysfs.c.  memcg_path_to_id() is doing that, but
defined in sysfs-schemes.c as a static function.  Move the function to
sysfs-common.c and mark it as non-static, so that the next commit can
reuse the function.

Link: https://lore.kernel.org/20260518234119.97569-26-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-common.c  |   41 +++++++++++++++++++++++++++++++++++++
 mm/damon/sysfs-common.h  |    2 +
 mm/damon/sysfs-schemes.c |   41 -------------------------------------
 3 files changed, 43 insertions(+), 41 deletions(-)

--- a/mm/damon/sysfs-common.c~mm-damon-sysfs-schemes-move-memcg_path_to_id-to-sysfs-common
+++ a/mm/damon/sysfs-common.c
@@ -104,3 +104,44 @@ const struct kobj_type damon_sysfs_ul_ra
 	.default_groups = damon_sysfs_ul_range_groups,
 };
 
+
+static bool damon_sysfs_memcg_path_eq(struct mem_cgroup *memcg,
+		char *memcg_path_buf, char *path)
+{
+#ifdef CONFIG_MEMCG
+	cgroup_path(memcg->css.cgroup, memcg_path_buf, PATH_MAX);
+	if (sysfs_streq(memcg_path_buf, path))
+		return true;
+#endif /* CONFIG_MEMCG */
+	return false;
+}
+
+int damon_sysfs_memcg_path_to_id(char *memcg_path, u64 *id)
+{
+	struct mem_cgroup *memcg;
+	char *path;
+	bool found = false;
+
+	if (!memcg_path)
+		return -EINVAL;
+
+	path = kmalloc_array(PATH_MAX, sizeof(*path), GFP_KERNEL);
+	if (!path)
+		return -ENOMEM;
+
+	for (memcg = mem_cgroup_iter(NULL, NULL, NULL); memcg;
+			memcg = mem_cgroup_iter(NULL, memcg, NULL)) {
+		/* skip offlined memcg */
+		if (!mem_cgroup_online(memcg))
+			continue;
+		if (damon_sysfs_memcg_path_eq(memcg, path, memcg_path)) {
+			*id = mem_cgroup_id(memcg);
+			found = true;
+			mem_cgroup_iter_break(NULL, memcg);
+			break;
+		}
+	}
+
+	kfree(path);
+	return found ? 0 : -EINVAL;
+}
--- a/mm/damon/sysfs-common.h~mm-damon-sysfs-schemes-move-memcg_path_to_id-to-sysfs-common
+++ a/mm/damon/sysfs-common.h
@@ -59,3 +59,5 @@ int damos_sysfs_set_quota_scores(struct
 void damos_sysfs_update_effective_quotas(
 		struct damon_sysfs_schemes *sysfs_schemes,
 		struct damon_ctx *ctx);
+
+int damon_sysfs_memcg_path_to_id(char *memcg_path, u64 *id);
--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-move-memcg_path_to_id-to-sysfs-common
+++ a/mm/damon/sysfs-schemes.c
@@ -2791,47 +2791,6 @@ const struct kobj_type damon_sysfs_schem
 	.default_groups = damon_sysfs_schemes_groups,
 };
 
-static bool damon_sysfs_memcg_path_eq(struct mem_cgroup *memcg,
-		char *memcg_path_buf, char *path)
-{
-#ifdef CONFIG_MEMCG
-	cgroup_path(memcg->css.cgroup, memcg_path_buf, PATH_MAX);
-	if (sysfs_streq(memcg_path_buf, path))
-		return true;
-#endif /* CONFIG_MEMCG */
-	return false;
-}
-
-static int damon_sysfs_memcg_path_to_id(char *memcg_path, u64 *id)
-{
-	struct mem_cgroup *memcg;
-	char *path;
-	bool found = false;
-
-	if (!memcg_path)
-		return -EINVAL;
-
-	path = kmalloc_array(PATH_MAX, sizeof(*path), GFP_KERNEL);
-	if (!path)
-		return -ENOMEM;
-
-	for (memcg = mem_cgroup_iter(NULL, NULL, NULL); memcg;
-			memcg = mem_cgroup_iter(NULL, memcg, NULL)) {
-		/* skip offlined memcg */
-		if (!mem_cgroup_online(memcg))
-			continue;
-		if (damon_sysfs_memcg_path_eq(memcg, path, memcg_path)) {
-			*id = mem_cgroup_id(memcg);
-			found = true;
-			mem_cgroup_iter_break(NULL, memcg);
-			break;
-		}
-	}
-
-	kfree(path);
-	return found ? 0 : -EINVAL;
-}
-
 static int damon_sysfs_add_scheme_filters(struct damos *scheme,
 		struct damon_sysfs_scheme_filters *sysfs_filters)
 {
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-delete-tried-region-in-regions_rmdirs.patch
mm-damon-core-make-charge_addr_from-aware-of-end-address-exclusivity.patch
mm-damon-core-handle-min_region_sz-remaining-quota-as-empty.patch
mm-damon-core-merge-regions-after-applying-damos-schemes.patch
mm-damon-core-introduce-failed-region-quota-charge-ratio.patch
mm-damon-sysfs-schemes-implement-fail_charge_numdenom-files.patch
docs-mm-damon-design-document-fail_charge_numdenom.patch
docs-admin-guide-mm-damon-usage-document-fail_charge_numdenom-files.patch
docs-abi-damon-document-fail_charge_numdenom.patch
mm-damon-tests-core-kunit-test-fail_charge_numdenom-committing.patch
selftests-damon-_damon_sysfs-support-failed-region-quota-charge-ratio.patch
selftests-damon-drgn_dump_damon_status-support-failed-region-quota-charge-ratio.patch
selftests-damon-sysfspy-test-failed-region-quota-charge-ratio.patch
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
docs-admin-guide-mm-damon-usage-mark-scheme-filters-sysfs-dir-as-deprecated.patch
docs-abi-damon-mark-schemes-s-filters-deprecated.patch
mm-damon-reclaim-add-autotune_monitoring_intervals-parameter.patch
docs-admin-guide-mm-damon-reclaim-update-for-autotune_monitoring_intervals.patch
mm-damon-stat-add-a-parameter-for-reading-kdamond-pid.patch
docs-admin-guide-mm-damon-stat-document-kdamond_pid-parameter.patch
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

