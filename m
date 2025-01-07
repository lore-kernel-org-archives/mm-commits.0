Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8B533EA
	for <mm-commits@vger.kernel.org>; Tue,  7 Jan 2025 02:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736215486; cv=none; b=CYDPD4UN+4pdPB5ctka7GqzEfbLJlMJbJvgd+nNqjDEO95yaLjrdKB9fN9THAkSsilFd8tT4XwYlSqMEqfFiHYY46+Ci+QBkAtcvQR+dau+qkSRdwEZA6MgX7Ut/xJ6NB4WGhqHP0Qx97F7o7y9kwr5JCtEnINxXAZvbOFFgAzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736215486; c=relaxed/simple;
	bh=kGEctaSEWUL2rNdxfSOH8qcn9mmSsshNYmQu6mISYyg=;
	h=Date:To:From:Subject:Message-Id; b=QrfmA7w5eQp+YRc//J5lEVws18XtJcxIOdcOVt0kpNpsJoLJPVwfmEEBtf/naR8U04j1xS2LFgAi4wQE1c0yrnOANAR9fYzUvrZARVx6Rf+IEeShofMBoQRm8OA3TgWzSqow8f7erDmIdCOg/r/+4vUealyNa6mBmZ1QzuUF7M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Nm+QZiZf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Nm+QZiZf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8EB8C4CED2;
	Tue,  7 Jan 2025 02:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736215485;
	bh=kGEctaSEWUL2rNdxfSOH8qcn9mmSsshNYmQu6mISYyg=;
	h=Date:To:From:Subject:From;
	b=Nm+QZiZfHIQNmPurPbRpMbAARu6sWXigyJqkZsJkvy5eBxW74WIF7cGykutr771Bp
	 vzoQ/dqf2Rkk3E0TKcc1J1HTS7rvTVLx3c7x933T88ycCgxyZ+tJXGok77hikFBY2t
	 /Lvfiee0RPsvbrux9fok7iRGq17ePqDqtqV50P64=
Date: Mon, 06 Jan 2025 18:04:45 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-expose-per-region-filter-passed-bytes.patch added to mm-unstable branch
Message-Id: <20250107020445.B8EB8C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs-schemes: expose per-region filter-passed bytes
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-expose-per-region-filter-passed-bytes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-expose-per-region-filter-passed-bytes.patch

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
Subject: mm/damon/sysfs-schemes: expose per-region filter-passed bytes
Date: Mon, 6 Jan 2025 11:33:58 -0800

Per-region operations set-handled DAMOS filters passed memory size
information is provided to only DAMON core API users.  Further expose it
to the user space by adding a new DAMON sysfs interface file under each
scheme tried region directory.

Link: https://lkml.kernel.org/r/20250106193401.109161-14-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-common.h  |    2 +-
 mm/damon/sysfs-schemes.c |   19 ++++++++++++++++++-
 mm/damon/sysfs.c         |    3 ++-
 3 files changed, 21 insertions(+), 3 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-schemes-expose-per-region-filter-passed-bytes
+++ a/mm/damon/sysfs.c
@@ -1461,7 +1461,8 @@ static void damon_sysfs_schemes_tried_re
 
 	damos_sysfs_populate_region_dir(
 			sysfs_kdamond->contexts->contexts_arr[0]->schemes,
-			ctx, t, r, s, walk_data->total_bytes_only);
+			ctx, t, r, s, walk_data->total_bytes_only,
+			sz_filter_passed);
 }
 
 static int damon_sysfs_update_schemes_tried_regions(
--- a/mm/damon/sysfs-common.h~mm-damon-sysfs-schemes-expose-per-region-filter-passed-bytes
+++ a/mm/damon/sysfs-common.h
@@ -48,7 +48,7 @@ void damon_sysfs_schemes_update_stats(
 void damos_sysfs_populate_region_dir(struct damon_sysfs_schemes *sysfs_schemes,
 		struct damon_ctx *ctx, struct damon_target *t,
 		struct damon_region *r, struct damos *s,
-		bool total_bytes_only);
+		bool total_bytes_only, unsigned long sz_filter_passed);
 
 int damon_sysfs_schemes_clear_regions(
 		struct damon_sysfs_schemes *sysfs_schemes);
--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-expose-per-region-filter-passed-bytes
+++ a/mm/damon/sysfs-schemes.c
@@ -19,6 +19,7 @@ struct damon_sysfs_scheme_region {
 	struct damon_addr_range ar;
 	unsigned int nr_accesses;
 	unsigned int age;
+	unsigned long sz_filter_passed;
 	struct list_head list;
 };
 
@@ -74,6 +75,15 @@ static ssize_t age_show(struct kobject *
 	return sysfs_emit(buf, "%u\n", region->age);
 }
 
+static ssize_t sz_filter_passed_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_scheme_region *region = container_of(kobj,
+			struct damon_sysfs_scheme_region, kobj);
+
+	return sysfs_emit(buf, "%lu\n", region->sz_filter_passed);
+}
+
 static void damon_sysfs_scheme_region_release(struct kobject *kobj)
 {
 	struct damon_sysfs_scheme_region *region = container_of(kobj,
@@ -95,11 +105,15 @@ static struct kobj_attribute damon_sysfs
 static struct kobj_attribute damon_sysfs_scheme_region_age_attr =
 		__ATTR_RO_MODE(age, 0400);
 
+static struct kobj_attribute damon_sysfs_scheme_region_sz_filter_passed_attr =
+		__ATTR_RO_MODE(sz_filter_passed, 0400);
+
 static struct attribute *damon_sysfs_scheme_region_attrs[] = {
 	&damon_sysfs_scheme_region_start_attr.attr,
 	&damon_sysfs_scheme_region_end_attr.attr,
 	&damon_sysfs_scheme_region_nr_accesses_attr.attr,
 	&damon_sysfs_scheme_region_age_attr.attr,
+	&damon_sysfs_scheme_region_sz_filter_passed_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_scheme_region);
@@ -2105,12 +2119,14 @@ void damon_sysfs_schemes_update_stats(
  * @r:			DAMON region to populate the directory for.
  * @s:			Corresponding scheme.
  * @total_bytes_only:	Whether the request is for bytes update only.
+ * @sz_filter_passed:	Bytes of @r that passed filters of @s.
  *
  * Called from DAMOS walk callback while holding damon_sysfs_lock.
  */
 void damos_sysfs_populate_region_dir(struct damon_sysfs_schemes *sysfs_schemes,
 		struct damon_ctx *ctx, struct damon_target *t,
-		struct damon_region *r, struct damos *s, bool total_bytes_only)
+		struct damon_region *r, struct damos *s, bool total_bytes_only,
+		unsigned long sz_filter_passed)
 {
 	struct damos *scheme;
 	struct damon_sysfs_scheme_regions *sysfs_regions;
@@ -2135,6 +2151,7 @@ void damos_sysfs_populate_region_dir(str
 	region = damon_sysfs_scheme_region_alloc(r);
 	if (!region)
 		return;
+	region->sz_filter_passed = sz_filter_passed;
 	list_add_tail(&region->list, &sysfs_regions->regions_list);
 	sysfs_regions->nr_regions++;
 	if (kobject_init_and_add(&region->kobj,
_

Patches currently in -mm which might be from sj@kernel.org are

samples-add-a-skeleton-of-a-sample-damon-module-for-working-set-size-estimation.patch
samples-damon-wsse-start-and-stop-damon-as-the-user-requests.patch
samples-damon-wsse-implement-working-set-size-estimation-and-logging.patch
samples-damon-introduce-a-skeleton-of-a-smaple-damon-module-for-proactive-reclamation.patch
samples-damon-prcl-implement-schemes-setup.patch
replace-free-hugepage-folios-after-migration-fix-2.patch
docs-admin-guide-mm-damon-usage-remove-damon-debugfs-interface-documentation.patch
docs-mm-damon-design-update-for-removal-of-damon-debugfs-interface.patch
selftests-damon-config-remove-configs-for-damon-debugfs-interface-selftests.patch
selftests-damon-remove-tests-for-damon-debugfs-interface.patch
kunit-configs-remove-configs-for-damon-debugfs-interface-tests.patch
mm-damon-remove-damon-debugfs-interface-kunit-tests.patch
mm-damon-remove-damon-debugfs-interface.patch
mm-damon-sysfs-schemes-remove-unnecessary-schemes-existence-check-in-damon_sysfs_schemes_clear_regions.patch
mm-damon-sysfs-handle-clear_schemes_tried_regions-from-damon-sysfs-context.patch
mm-damon-core-introduce-damon_call.patch
mm-damon-sysfs-use-damon_call-for-update_schemes_stats.patch
mm-damon-sysfs-use-damon_call-for-commit_schemes_quota_goals.patch
mm-damon-sysfs-use-damon_call-for-update_schemes_effective_quotas.patch
mm-damon-core-implement-damos_walk.patch
docs-mm-damon-design-document-damos-regions-walking.patch
mm-damon-sysfs-use-damos_walk-for-update_schemes_tried_bytesregions.patch
mm-damon-sysfs-remove-unused-code-for-schemes-tried-regions-update.patch
mm-damon-clarify-trying-vs-applying-on-damos_stat-kernel-doc-comment.patch
docs-mm-damon-design-add-statistics-section.patch
docs-admin-guide-mm-damon-usage-link-damos-stat-design-doc.patch
mm-damon-ask-apply_scheme-to-report-filter-passed-region-internal-bytes.patch
mm-damon-paddr-report-filter-passed-bytes-back-for-normal-actions.patch
mm-damon-paddr-report-filter-passed-bytes-back-for-damos_stat-action.patch
mm-damon-core-implement-per-scheme-ops-handled-filter-passed-bytes-stat.patch
mm-damon-syfs-schemes-implement-per-scheme-filter-passed-bytes-stat.patch
docs-mm-damon-design-document-sz_ops_filter_passed.patch
docs-admin-guide-mm-damon-usage-document-sz_ops_filter_passed.patch
docs-abi-damon-document-per-scheme-filter-passed-bytes-stat-file.patch
mm-damon-core-pass-per-region-filter-passed-bytes-to-damos_walk_control-walk_fn.patch
mm-damon-sysfs-schemes-expose-per-region-filter-passed-bytes.patch
docs-mm-damon-design-document-per-region-sz_filter_passed-stat.patch
docs-admin-guide-mm-damon-usage-document-sz_filtered_out-of-scheme-tried-region-directories.patch
docs-abi-damon-document-per-region-damos-filter-passed-bytes-stat-file.patch

