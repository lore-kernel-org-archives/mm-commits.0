Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87BE3BFE3A
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896724; cv=none; b=MWX29mcv++KW48Hu7GijDFSLO6C8W/x+CEOEgsC0ED3dfjV9rfGhR1lYo5SdHANSVrSPJSlibhIaZb0xXhIE+ZkcUJkyafZAbddyHZi00c6Fy1azyG2gh0IOOjfRpKep55CD0vqbSdYXeHvgmejbSDg1xtCMFoQOz234uF6YWsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896724; c=relaxed/simple;
	bh=3DbfSlOEKA8hQXbsSvZ+MgSRnufBnYTveg565OBxS28=;
	h=Date:To:From:Subject:Message-Id; b=SlXk94MtA7sZnons1/ivFkP21xBHAY8+bYhA1DzgqzkSp16n/N6V541vrYDF8vkR5eKPI8uerltssqVYE2uxZHqE0zpD8VhMphPjwGIIJ1juC6FBTQJVZjULPkdvDvUO/idhYuztUvtK6I/ILm78eWhJXY5P+XJJYbO4mySkvPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FWpWM0/e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FWpWM0/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B22AC1F00A3A;
	Wed,  5 Aug 2026 02:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896722;
	bh=C6eEMgD5Doj/bNBl7pkdqZ8a4ut5at/LXRnG8F3wcZE=;
	h=Date:To:From:Subject;
	b=FWpWM0/eD8VFAMJtDEA1ExEQdKHZj2GKDXIHf9B4Yu8kZgKVdF20PcJWcKJEUuBzi
	 90n4uah/HRSVk+Pbj83xtMKKIIdii0W3uYWl6j6xMMgsm3qvAp7zEFpch2e0UtabuP
	 JOwM54I5PfsuUXXjlZbGKDfOi/8CDSMOnlNHELXE=
Date: Tue, 04 Aug 2026 19:25:22 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-implement-probe-weight-file.patch removed from -mm tree
Message-Id: <20260805022522.B22AC1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: implement probe/weight file
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-implement-probe-weight-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/sysfs: implement probe/weight file
Date: Fri, 10 Jul 2026 06:46:45 -0700

Implement a new sysfs file, 'weight', under probe directory.  Users will
be able to set the probe weight and enable the attributes only monitoring
using it.

Link: https://lore.kernel.org/20260710134651.18084-17-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-implement-probe-weight-file
+++ a/mm/damon/sysfs.c
@@ -1065,6 +1065,7 @@ static const struct kobj_type damon_sysf
 
 struct damon_sysfs_probe {
 	struct kobject kobj;
+	unsigned int weight;
 	struct damon_sysfs_filters *filters;
 };
 
@@ -1100,12 +1101,35 @@ static void damon_sysfs_probe_rm_dirs(st
 	}
 }
 
+static ssize_t weight_show(struct kobject *kobj, struct kobj_attribute *attr,
+		char *buf)
+{
+	struct damon_sysfs_probe *probe = container_of(kobj,
+			struct damon_sysfs_probe, kobj);
+
+	return sysfs_emit(buf, "%u\n", probe->weight);
+}
+
+static ssize_t weight_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_probe *probe = container_of(kobj,
+			struct damon_sysfs_probe, kobj);
+	int err = kstrtouint(buf, 0, &probe->weight);
+
+	return err ? err : count;
+}
+
 static void damon_sysfs_probe_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_probe, kobj));
 }
 
+static struct kobj_attribute damon_sysfs_probe_weight_attr =
+		__ATTR_RW_MODE(weight, 0600);
+
 static struct attribute *damon_sysfs_probe_attrs[] = {
+	&damon_sysfs_probe_weight_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_probe);
@@ -1965,6 +1989,7 @@ static int damon_sysfs_set_probes(struct
 			return -ENOMEM;
 		damon_add_probe(ctx, p);
 		sys_probe = sys_probes->probes_arr[i];
+		p->weight = sys_probe->weight;
 		err = damon_sysfs_set_probe(p, sys_probe);
 		if (err)
 			return err;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-adjust-isolated-pages-stat-for-damos_migrate_hotcold.patch
samples-damon-mtier-error-out-for-zero-quota-goal-target-values.patch
mm-damon-lru_sort-error-out-for-10000-active_mem_bp.patch
mm-damon-reclaim-skip-damon_call-if-ctx-has-not-started.patch
mm-damon-lru_sort-skip-damon_call-if-ctx-has-not-started.patch
mm-damon-core-skip-aging-from-repeated-aggressive-merging.patch
mm-damon-core-hide-private-damon_region-fields.patch
mm-damon-core-hide-private-damon_target-fields.patch
mm-damon-core-hide-private-damos_quota_goal-fields.patch
mm-damon-core-hide-private-damos_quota-fields.patch
mm-damon-core-hide-private-damos_filter-fields.patch
mm-damon-core-hide-private-damos-fields.patch
mm-damon-core-hide-private-damon_filter-fields.patch
mm-damon-core-hide-private-damon_probe-fields.patch
mm-damon-sysfs-do-not-directly-access-damon_ctx-ops.patch
mm-damon-core-hide-core-private-damon_ctx-fields.patch
mm-damon-core-avoid-infinite-kdamond_merge_regions-internal-loop.patch
mm-damon-tests-core-kunit-catch-test-failure-in-test_merge_regions_of.patch
mm-damon-vaddr-drop-last-same-folio-access-check-optimization.patch
mm-damon-paddr-drop-last-same-folio-access-check-reuse-optimization.patch
mm-damon-sysfs-read-addr_unit-only-once-in-damon_sysfs_apply_inputs.patch
mm-damon-sysfs-read-ops_id-only-once-in-damon_sysfs_apply_inputs.patch
mm-damon-core-initialize-damos-last_applied.patch
mm-damon-core-kunit-check-region-count-before-testing-in-split_at.patch
mm-damon-vaddr-kunit-check-region-count-in-three_regions-test.patch
mm-damon-core-kunit-handle-region-split-failure-in-filter_out.patch
mm-damon-core-kunit-skip-wrong-dest-walk-in-commit_dests_for.patch
mm-damon-core-kunit-skip-wrong-quota-goal-walk-in-commit_quota_goals.patch
mm-damon-core-kunit-skip-wrong-region-walk-in-commit_target_regions.patch
mm-damon-ops-common-use-nr_accesses-moving-sum-for-quota-score.patch
mm-damon-core-handle-region-split-failure-in-apply_min_nr_regions.patch

