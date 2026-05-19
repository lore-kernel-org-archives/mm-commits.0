Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F18E27CCE0
	for <mm-commits@vger.kernel.org>; Tue, 19 May 2026 00:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779152137; cv=none; b=OxnrIIwqGza90F1Q3LQ2Nxc0agnetqGPXtAFxyQJb7CdDR5nAsbCeAIIuoWJQmyd7YZE8U61GJy4WCmMyxmYhW7eJonKUbO4sXFiaLJk0kPxC0pPSJK3pM303uCybqZmOAN1BlU9Wci4hMij+WoZInw+gaLjSunj2sEcJeiWeyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779152137; c=relaxed/simple;
	bh=FOVNyhBdGoTwRsUjr/ruRiS4thZFIgF/RPwrrTX4ntw=;
	h=Date:To:From:Subject:Message-Id; b=Z71++EYlSXDRYxAdjKbOTu7BwHDocNqNIOoWAhQkJUhHh3gOPHSXTG3ftdns/nFKdat+Je+/woVOfowvC2t39DtVrsQ9b0ZIumYLC9NM5fA9++IOHmEcVeXW315OD79WzszX0WPapB0XdYXe36x4eydWgR4nYzifCE759r3AzzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dRZQTwZa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dRZQTwZa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A881C2BCB7;
	Tue, 19 May 2026 00:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779152137;
	bh=FOVNyhBdGoTwRsUjr/ruRiS4thZFIgF/RPwrrTX4ntw=;
	h=Date:To:From:Subject:From;
	b=dRZQTwZaxFhuJHeeNbrHkc09bUfePJYizLZDEhjkXOX5J+pBxRZQBhmHwMl4Yf+hJ
	 mapcT247EGTqPyGVrf9aTsVStaIS7aZrE/LJ0bAwnki5aAMxQfVAejiIXo+JNxAyQ4
	 /9oXFdV7ywR9KokmK8PwhBuTEq0PNfZQqhpvTOdE=
Date: Mon, 18 May 2026 17:55:36 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-setup-probes-on-damon-core-api-parameters.patch added to mm-new branch
Message-Id: <20260519005537.1A881C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: setup probes on DAMON core API parameters
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-setup-probes-on-damon-core-api-parameters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-setup-probes-on-damon-core-api-parameters.patch

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
Subject: mm/damon/sysfs: setup probes on DAMON core API parameters
Date: Mon, 18 May 2026 16:41:02 -0700

Add user-installed data probes to DAMON core API parameters, so that user
inputs for data probes are passed to DAMON core.

Link: https://lore.kernel.org/20260518234119.97569-15-sj@kernel.org
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

 mm/damon/sysfs.c |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-setup-probes-on-damon-core-api-parameters
+++ a/mm/damon/sysfs.c
@@ -1855,6 +1855,40 @@ static int damon_sysfs_set_attrs(struct
 	return damon_set_attrs(ctx, &attrs);
 }
 
+static int damon_sysfs_set_probes(struct damon_ctx *ctx,
+		struct damon_sysfs_probes *sys_probes)
+{
+	int i;
+
+	for (i = 0; i < sys_probes->nr; i++) {
+		struct damon_sysfs_filters *sys_filters =
+			sys_probes->probes_arr[i]->filters;
+		struct damon_probe *c;
+		int j;
+
+		if (!sys_filters)
+			continue;
+		c = damon_new_probe();
+		if (!c)
+			return -ENOMEM;
+		damon_add_probe(ctx, c);
+
+		for (j = 0; j < sys_filters->nr; j++) {
+			struct damon_sysfs_filter *sys_filter =
+				sys_filters->filters_arr[j];
+			struct damon_filter *filter;
+
+			filter = damon_new_filter(sys_filter->type,
+					sys_filter->matching,
+					sys_filter->allow);
+			if (!filter)
+				return -ENOMEM;
+			damon_add_filter(c, filter);
+		}
+	}
+	return 0;
+}
+
 static int damon_sysfs_set_regions(struct damon_target *t,
 		struct damon_sysfs_regions *sysfs_regions,
 		unsigned long min_region_sz)
@@ -1969,6 +2003,9 @@ static int damon_sysfs_apply_inputs(stru
 	err = damon_sysfs_set_attrs(ctx, sys_ctx->attrs);
 	if (err)
 		return err;
+	err = damon_sysfs_set_probes(ctx, sys_ctx->attrs->probes);
+	if (err)
+		return err;
 	err = damon_sysfs_add_targets(ctx, sys_ctx->targets);
 	if (err)
 		return err;
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

