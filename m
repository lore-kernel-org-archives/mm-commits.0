Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3D827FB28
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966076; cv=none; b=pp02EPoDGfQIs1VSQFDBKxM6tV7QhJgSnh2yz2kXD2iGo4VMVV4tF/SW+YppeBxjBi1H1id2FiTUGIwBOueJwiNlqTLxBSGJ4lBxr8tfoSS/xBsSEi13Bc0BgGT/yi5S48Qz/qMlo5GGVPZxC4TV0kfZhmqkB8Grtogf8Ncf+s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966076; c=relaxed/simple;
	bh=KcbIRJixvTq1DFgV/pJVE6eMgurzbRivmRHpcpSQx7M=;
	h=Date:To:From:Subject:Message-Id; b=HVRr5xZAz4LYNCkl1fCbOkiABJSjm3mJmMPnzRI6woUf9Ts/lzghG9cRI2GoNFnxrDw1nZWmjXwcALn+lJUQdIJmSMOpvtL/Nr7Rk2uiuq4rASvpQVNSeRzddZpMek8LjIXqS3Bu3yYYVwcw7+M+8326p/73fK0pgZUyal7IqSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ukp2rx+z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ukp2rx+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27245C16AAE;
	Wed, 21 Jan 2026 03:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966076;
	bh=KcbIRJixvTq1DFgV/pJVE6eMgurzbRivmRHpcpSQx7M=;
	h=Date:To:From:Subject:From;
	b=Ukp2rx+zAkOGqdyoKFZ+FWh/RUCH75vTKTNUn/E3Ny46os666tPx2y32Zd7duwSLi
	 VT4yq0vSwk/gvrj1dG+KcCRJylERPx7kffZMqdulJduOF+TDdl7T0X2BP4Nk7wJ6ZC
	 OKQyqeJsLJXZ1oJnyg/kMNXz+K27UMJSGsnZVJPw=
Date: Tue, 20 Jan 2026 19:27:55 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,rostedt@goodmis.org,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-implement-max_nr_snapshots-file.patch removed from -mm tree
Message-Id: <20260121032756.27245C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: implement max_nr_snapshots file
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-implement-max_nr_snapshots-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: implement max_nr_snapshots file
Date: Tue, 16 Dec 2025 00:01:21 -0800

Add a new DAMON sysfs file for setting and getting the newly introduced
per-DAMON-snapshot level DAMOS deactivation control parameter,
max_nr_snapshots.  The file has a name same to the parameter and placed
under the damos stat directory.

Link: https://lkml.kernel.org/r/20251216080128.42991-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-implement-max_nr_snapshots-file
+++ a/mm/damon/sysfs-schemes.c
@@ -205,6 +205,7 @@ struct damon_sysfs_stats {
 	unsigned long sz_ops_filter_passed;
 	unsigned long qt_exceeds;
 	unsigned long nr_snapshots;
+	unsigned long max_nr_snapshots;
 };
 
 static struct damon_sysfs_stats *damon_sysfs_stats_alloc(void)
@@ -275,6 +276,28 @@ static ssize_t nr_snapshots_show(struct
 	return sysfs_emit(buf, "%lu\n", stats->nr_snapshots);
 }
 
+static ssize_t max_nr_snapshots_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_stats *stats = container_of(kobj,
+			struct damon_sysfs_stats, kobj);
+
+	return sysfs_emit(buf, "%lu\n", stats->max_nr_snapshots);
+}
+
+static ssize_t max_nr_snapshots_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_stats *stats = container_of(kobj,
+			struct damon_sysfs_stats, kobj);
+	unsigned long max_nr_snapshots, err = kstrtoul(buf, 0, &max_nr_snapshots);
+
+	if (err)
+		return err;
+	stats->max_nr_snapshots = max_nr_snapshots;
+	return count;
+}
+
 static void damon_sysfs_stats_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_stats, kobj));
@@ -301,6 +324,9 @@ static struct kobj_attribute damon_sysfs
 static struct kobj_attribute damon_sysfs_stats_nr_snapshots_attr =
 		__ATTR_RO_MODE(nr_snapshots, 0400);
 
+static struct kobj_attribute damon_sysfs_stats_max_nr_snapshots_attr =
+		__ATTR_RW_MODE(max_nr_snapshots, 0600);
+
 static struct attribute *damon_sysfs_stats_attrs[] = {
 	&damon_sysfs_stats_nr_tried_attr.attr,
 	&damon_sysfs_stats_sz_tried_attr.attr,
@@ -309,6 +335,7 @@ static struct attribute *damon_sysfs_sta
 	&damon_sysfs_stats_sz_ops_filter_passed_attr.attr,
 	&damon_sysfs_stats_qt_exceeds_attr.attr,
 	&damon_sysfs_stats_nr_snapshots_attr.attr,
+	&damon_sysfs_stats_max_nr_snapshots_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_stats);
@@ -2732,6 +2759,7 @@ static struct damos *damon_sysfs_mk_sche
 		damon_destroy_scheme(scheme);
 		return NULL;
 	}
+	scheme->max_nr_snapshots = sysfs_scheme->stats->max_nr_snapshots;
 	return scheme;
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-active-memory-ratio-damos-quota-goal-metric.patch
mm-damon-sysfs-schemes-support-damos_quota_active_mem_bp.patch
docs-mm-damon-design-document-damos_quota_active_mem_bp.patch
mm-damon-paddr-activate-damos_lru_prio-targets-instead-of-marking-accessed.patch
mm-damon-lru_sort-consider-age-for-quota-prioritization.patch
mm-damon-lru_sort-support-young-page-filters.patch
docs-admin-guide-mm-damon-lru_sort-document-filter_young_pages.patch
mm-damon-lru_sort-support-active-inactive-memory-ratio-based-auto-tuning.patch
mm-damon-lru_sort-support-active-inactive-memory-ratio-based-auto-tuning-fix.patch
docs-admin-guide-mm-damon-lru_sort-document-active_mem_bp-parameter.patch
mm-damon-lru_sort-add-monitoring-intervals-auto-tuning-parameter.patch
docs-admin-guide-mm-damon-lru_sort-document-intervals-autotuning.patch
mm-damon-core-implement-damon_kdamond_pid.patch
mm-damon-sysfs-use-damon_kdamond_pid.patch
mm-damon-lru_sort-use-damon_kdamond_pid.patch
mm-damon-reclaim-use-damon_kdamond_pid.patch
mm-damon-hide-kdamond-and-kdamond_lock-of-damon_ctx.patch
mm-vma-temporary-build-fix.patch
selftests-damon-sysfs_memcg_path_leaksh-use-kmemleak.patch
selftests-damon-wss_estimation-test-for-up-to-160-mib-working-set-size.patch
selftests-damon-access_memory-add-repeat-mode.patch
selftests-damon-wss_estimation-ensure-number-of-collected-wss.patch
selftests-damon-wss_estimation-deduplicate-failed-samples-output.patch
mm-damon-remove-damon_operations-cleanup.patch
mm-damon-core-cleanup-targets-and-regions-at-once-on-kdamond-termination.patch
mm-damon-core-cancel-damos_walk-before-damon_ctx-kdamond-reset.patch
mm-damon-core-process-damon_call_control-requests-on-a-local-list.patch
mm-damon-document-damon_call_control-dealloc_on_cancel-repeat-behavior.patch
mm-damon-core-rename-damos_filter_out-to-damos_core_filter_out.patch
mm-damon-rename-damon_min_region-to-damon_min_region_sz.patch
mm-damon-rename-min_sz_region-of-damon_ctx-to-min_region_sz.patch
docs-mm-damon-index-simplify-the-intro.patch
docs-mm-damon-design-link-repology-instead-of-fedora-package.patch
docs-mm-damon-design-document-damon-sample-modules.patch
docs-mm-damon-design-add-reference-to-damon_stat-usage.patch
docs-admin-guide-mm-damon-usage-introduce-damon-modules-at-the-beginning.patch
docs-admin-guide-mm-damon-usage-update-stats-update-process-for-refresh_ms.patch
docs-mm-damon-maintainer-profile-fix-wrong-maitnainers-section-name.patch
docs-mm-damon-maintainer-profile-remove-damon-tests-perf-suggestion.patch

