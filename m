Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C5C278156
	for <mm-commits@vger.kernel.org>; Tue, 19 May 2026 00:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779152114; cv=none; b=ahrFCWSd7nS9BLHulXnDfci8ZrtUMxrW8doC/q0oVMlzb0kC4EqqGL7IKP6/pTOzjuVwyMzfEBu6Ce92Ay4oAKlLwgntApx3+Z+IWUIn18lHnd0Bk7i4II6cTArHwVDApKVwe65qneWXYiL//zxqzVwZgUdYzLjaAHcO1lvLc+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779152114; c=relaxed/simple;
	bh=20SB87ARtUTIc7/TX4Ag+U1mjbBYP+bWONgspY0RnZk=;
	h=Date:To:From:Subject:Message-Id; b=uJgo4FLuzCy84MV+zkw8qy13GXATZGTJy47QWURxc+BjU7nz+X9MOKTu/kw8Yo97vr9N24dJIlbqE4fWLMdwG4i9u/1wqpUW1ZGz6QUl3pU0euEqqZKndR9ja/9Pq2QDEDmyXKo8Eu2jSVNNtGmqiz2COIgjDq6sJKRkIK8GfL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MdnGR4U1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MdnGR4U1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD9CC2BCB7;
	Tue, 19 May 2026 00:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779152114;
	bh=20SB87ARtUTIc7/TX4Ag+U1mjbBYP+bWONgspY0RnZk=;
	h=Date:To:From:Subject:From;
	b=MdnGR4U1zYA2mNqaXxokWY416gf8IPTNw4mQqdBANrt7xBtd80jcJEKo9fxDekBCJ
	 HiOAvaOM/NyVHdUGo8bWKUT3pGSfRT9fU/snaXoj2XFyVfo+U1cC7Z76ItG73qBmh7
	 Zcd/nQOP70zy4vVS0JljwCKetLe7ChNtxNAPaTcY=
Date: Mon, 18 May 2026 17:55:13 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-commit-probes.patch added to mm-new branch
Message-Id: <20260519005514.3FD9CC2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: commit probes
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-commit-probes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-commit-probes.patch

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
Subject: mm/damon/core: commit probes
Date: Mon, 18 May 2026 16:40:52 -0700

Update damon_commit_ctx() to commit installed data probes, too.

Link: https://lore.kernel.org/20260518234119.97569-5-sj@kernel.org
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

 mm/damon/core.c |  104 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 104 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-commit-probes
+++ a/mm/damon/core.c
@@ -133,11 +133,34 @@ void damon_add_filter(struct damon_probe
 	list_add_tail(&f->list, &p->filters);
 }
 
+static void damon_del_filter(struct damon_filter *f)
+{
+	list_del(&f->list);
+}
+
 static void damon_free_filter(struct damon_filter *f)
 {
 	kfree(f);
 }
 
+static void damon_destroy_filter(struct damon_filter *f)
+{
+	damon_del_filter(f);
+	damon_free_filter(f);
+}
+
+static struct damon_filter *damon_nth_filter(int n, struct damon_probe *p)
+{
+	struct damon_filter *f;
+	int i = 0;
+
+	damon_for_each_filter(f, p) {
+		if (i++ == n)
+			return f;
+	}
+	return NULL;
+}
+
 struct damon_probe *damon_new_probe(void)
 {
 	struct damon_probe *p;
@@ -175,6 +198,18 @@ static void damon_destroy_probe(struct d
 	damon_free_probe(p);
 }
 
+static struct damon_probe *damon_nth_probe(int n, struct damon_ctx *ctx)
+{
+	struct damon_probe *p;
+	int i = 0;
+
+	damon_for_each_probe(p, ctx) {
+		if (i++ == n)
+			return p;
+	}
+	return NULL;
+}
+
 #ifdef CONFIG_DAMON_DEBUG_SANITY
 static void damon_verify_new_region(unsigned long start, unsigned long end)
 {
@@ -1386,6 +1421,72 @@ static int damon_commit_targets(
 	return 0;
 }
 
+static void damon_commit_filter(struct damon_filter *dst,
+		struct damon_filter *src)
+{
+	dst->type = src->type;
+	dst->matching = src->matching;
+	dst->allow = src->allow;
+}
+
+static int damon_commit_filters(struct damon_probe *dst,
+		struct damon_probe *src)
+{
+	struct damon_filter *dst_filter, *next, *src_filter, *new_filter;
+	int i = 0, j = 0;
+
+	damon_for_each_filter_safe(dst_filter, next, dst) {
+		src_filter = damon_nth_filter(i++, src);
+		if (src_filter)
+			damon_commit_filter(dst_filter, src_filter);
+		else
+			damon_destroy_filter(dst_filter);
+	}
+
+	damon_for_each_filter_safe(src_filter, next, src) {
+		if (j++ < i)
+			continue;
+
+		new_filter = damon_new_filter(src_filter->type,
+				src_filter->matching, src_filter->allow);
+		if (!new_filter)
+			return -ENOMEM;
+		damon_add_filter(dst, new_filter);
+	}
+	return 0;
+}
+
+static int damon_commit_probes(struct damon_ctx *dst, struct damon_ctx *src)
+{
+	struct damon_probe *dst_probe, *next, *src_probe, *new_probe;
+	int i = 0, j = 0, err;
+
+	damon_for_each_probe_safe(dst_probe, next, dst) {
+		src_probe = damon_nth_probe(i++, src);
+		if (src_probe) {
+			err = damon_commit_filters(dst_probe, src_probe);
+			if (err)
+				return err;
+		} else {
+			damon_destroy_probe(dst_probe);
+		}
+	}
+
+	damon_for_each_probe_safe(src_probe, next, src) {
+		if (j++ < i)
+			continue;
+
+		new_probe = damon_new_probe();
+		if (!new_probe)
+			return -ENOMEM;
+		damon_add_probe(dst, new_probe);
+		err = damon_commit_filters(new_probe, src_probe);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
 /**
  * damon_commit_ctx() - Commit parameters of a DAMON context to another.
  * @dst:	The commit destination DAMON context.
@@ -1442,6 +1543,9 @@ int damon_commit_ctx(struct damon_ctx *d
 	}
 	dst->pause = src->pause;
 	dst->ops = src->ops;
+	err = damon_commit_probes(dst, src);
+	if (err)
+		return err;
 	dst->addr_unit = src->addr_unit;
 	dst->min_region_sz = src->min_region_sz;
 
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

