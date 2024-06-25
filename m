Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43B2143C64
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291725; cv=none; b=ZOa3GdPjD9ITTqCY9Cb2Fy1aSwsaJxqOMROLhS1S9XsHGqSnBkcP6Acucr2iH8AqBt6zpilsPANTQY4+0RbmKhw/2XGor2unU506kG+UOPnRaXTMkEaga6RCDEfPLH8HLVjXnOcisZNZgKuA1HrXtHVmbw/1mbLDwiVYCfFTeSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291725; c=relaxed/simple;
	bh=G3c5NUfS6vDP1bLaNrmRCeFW2O9e+9fTw5DU7TlYhUg=;
	h=Date:To:From:Subject:Message-Id; b=XSnvMDQEwyqMT6Gjnd3x7ubNdcQ6jYCjP4Op0NZCSCxCL0q/SxsgqQaF1nDs8Q3VJsahPEukFNgj56bLs5zdyd4LbKhd6LYAFFqa3KrMOcg6f0AoW/XAbCraNktRawdTAOYhdEQyM6twoFMU2LnFPSZXGP9tBgzCDAyio1VgBaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IrrECUM5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IrrECUM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7776AC32782;
	Tue, 25 Jun 2024 05:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291725;
	bh=G3c5NUfS6vDP1bLaNrmRCeFW2O9e+9fTw5DU7TlYhUg=;
	h=Date:To:From:Subject:From;
	b=IrrECUM5XQSnhoBsZcBJmHVhi/8LV178HdJ8IvlGI0M2FealsI9arEmbiC1qpce6v
	 dLUbXMyo2Zze/4nYdEXR9qCtE2TW0meqOqErvRyRraCu0Kav0EWUnd2jAlRTBu1wbv
	 yPF/sLnAKdWsgBQHBSeIqx27r6UZ+BLQGXua9KEU=
Date: Mon, 24 Jun 2024 22:02:04 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,rostedt@goodmis.org,rakie.kim@sk.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,honggyu.kim@sk.com,gregory.price@memverge.com,42.hyeyoo@gmail.com,hyeongtak.ji@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-add-target_nid-on-sysfs-schemes.patch removed from -mm tree
Message-Id: <20240625050205.7776AC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: add target_nid on sysfs-schemes
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-add-target_nid-on-sysfs-schemes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hyeongtak Ji <hyeongtak.ji@sk.com>
Subject: mm/damon/sysfs-schemes: add target_nid on sysfs-schemes
Date: Fri, 14 Jun 2024 12:00:05 +0900

This patch adds target_nid under
  /sys/kernel/mm/damon/admin/kdamonds/<N>/contexts/<N>/schemes/<N>/

The 'target_nid' can be used as the destination node for DAMOS actions
such as DAMOS_MIGRATE_{HOT,COLD} in the follow up patches.

[sj@kernel.org: document target_nid file]
  Link: https://lkml.kernel.org/r/20240618213630.84846-3-sj@kernel.org
Link: https://lkml.kernel.org/r/20240614030010.751-4-honggyu.kim@sk.com
Signed-off-by: Hyeongtak Ji <hyeongtak.ji@sk.com>
Signed-off-by: Honggyu Kim <honggyu.kim@sk.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Gregory Price <gregory.price@memverge.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |    6 ++
 include/linux/damon.h                           |   11 ++++
 mm/damon/core.c                                 |    5 +-
 mm/damon/dbgfs.c                                |    2 
 mm/damon/lru_sort.c                             |    3 -
 mm/damon/reclaim.c                              |    3 -
 mm/damon/sysfs-schemes.c                        |   33 +++++++++++++-
 7 files changed, 57 insertions(+), 6 deletions(-)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~mm-damon-sysfs-schemes-add-target_nid-on-sysfs-schemes
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -155,6 +155,12 @@ Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the action
 		of the scheme.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/target_nid
+Date:		Jun 2024
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Action's target NUMA node id.  Supported by only relevant
+		actions.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/apply_interval_us
 Date:		Sep 2023
 Contact:	SeongJae Park <sj@kernel.org>
--- a/include/linux/damon.h~mm-damon-sysfs-schemes-add-target_nid-on-sysfs-schemes
+++ a/include/linux/damon.h
@@ -374,6 +374,7 @@ struct damos_access_pattern {
  * @apply_interval_us:	The time between applying the @action.
  * @quota:		Control the aggressiveness of this scheme.
  * @wmarks:		Watermarks for automated (in)activation of this scheme.
+ * @target_nid:		Destination node if @action is "migrate_{hot,cold}".
  * @filters:		Additional set of &struct damos_filter for &action.
  * @stat:		Statistics of this scheme.
  * @list:		List head for siblings.
@@ -389,6 +390,10 @@ struct damos_access_pattern {
  * monitoring context are inactive, DAMON stops monitoring either, and just
  * repeatedly checks the watermarks.
  *
+ * @target_nid is used to set the migration target node for migrate_hot or
+ * migrate_cold actions, which means it's only meaningful when @action is either
+ * "migrate_hot" or "migrate_cold".
+ *
  * Before applying the &action to a memory region, &struct damon_operations
  * implementation could check pages of the region and skip &action to respect
  * &filters
@@ -410,6 +415,9 @@ struct damos {
 /* public: */
 	struct damos_quota quota;
 	struct damos_watermarks wmarks;
+	union {
+		int target_nid;
+	};
 	struct list_head filters;
 	struct damos_stat stat;
 	struct list_head list;
@@ -726,7 +734,8 @@ struct damos *damon_new_scheme(struct da
 			enum damos_action action,
 			unsigned long apply_interval_us,
 			struct damos_quota *quota,
-			struct damos_watermarks *wmarks);
+			struct damos_watermarks *wmarks,
+			int target_nid);
 void damon_add_scheme(struct damon_ctx *ctx, struct damos *s);
 void damon_destroy_scheme(struct damos *s);
 
--- a/mm/damon/core.c~mm-damon-sysfs-schemes-add-target_nid-on-sysfs-schemes
+++ a/mm/damon/core.c
@@ -354,7 +354,8 @@ struct damos *damon_new_scheme(struct da
 			enum damos_action action,
 			unsigned long apply_interval_us,
 			struct damos_quota *quota,
-			struct damos_watermarks *wmarks)
+			struct damos_watermarks *wmarks,
+			int target_nid)
 {
 	struct damos *scheme;
 
@@ -381,6 +382,8 @@ struct damos *damon_new_scheme(struct da
 	scheme->wmarks = *wmarks;
 	scheme->wmarks.activated = true;
 
+	scheme->target_nid = target_nid;
+
 	return scheme;
 }
 
--- a/mm/damon/dbgfs.c~mm-damon-sysfs-schemes-add-target_nid-on-sysfs-schemes
+++ a/mm/damon/dbgfs.c
@@ -281,7 +281,7 @@ static struct damos **str_to_schemes(con
 
 		pos += parsed;
 		scheme = damon_new_scheme(&pattern, action, 0, &quota,
-				&wmarks);
+				&wmarks, NUMA_NO_NODE);
 		if (!scheme)
 			goto fail;
 
--- a/mm/damon/lru_sort.c~mm-damon-sysfs-schemes-add-target_nid-on-sysfs-schemes
+++ a/mm/damon/lru_sort.c
@@ -163,7 +163,8 @@ static struct damos *damon_lru_sort_new_
 			/* under the quota. */
 			&quota,
 			/* (De)activate this according to the watermarks. */
-			&damon_lru_sort_wmarks);
+			&damon_lru_sort_wmarks,
+			NUMA_NO_NODE);
 }
 
 /* Create a DAMON-based operation scheme for hot memory regions */
--- a/mm/damon/reclaim.c~mm-damon-sysfs-schemes-add-target_nid-on-sysfs-schemes
+++ a/mm/damon/reclaim.c
@@ -177,7 +177,8 @@ static struct damos *damon_reclaim_new_s
 			/* under the quota. */
 			&damon_reclaim_quota,
 			/* (De)activate this according to the watermarks. */
-			&damon_reclaim_wmarks);
+			&damon_reclaim_wmarks,
+			NUMA_NO_NODE);
 }
 
 static void damon_reclaim_copy_quota_status(struct damos_quota *dst,
--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-add-target_nid-on-sysfs-schemes
+++ a/mm/damon/sysfs-schemes.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/slab.h>
+#include <linux/numa.h>
 
 #include "sysfs-common.h"
 
@@ -1445,6 +1446,7 @@ struct damon_sysfs_scheme {
 	struct damon_sysfs_scheme_filters *filters;
 	struct damon_sysfs_stats *stats;
 	struct damon_sysfs_scheme_regions *tried_regions;
+	int target_nid;
 };
 
 /* This should match with enum damos_action */
@@ -1470,6 +1472,7 @@ static struct damon_sysfs_scheme *damon_
 	scheme->kobj = (struct kobject){};
 	scheme->action = action;
 	scheme->apply_interval_us = apply_interval_us;
+	scheme->target_nid = NUMA_NO_NODE;
 	return scheme;
 }
 
@@ -1692,6 +1695,28 @@ static ssize_t apply_interval_us_store(s
 	return err ? err : count;
 }
 
+static ssize_t target_nid_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_scheme *scheme = container_of(kobj,
+			struct damon_sysfs_scheme, kobj);
+
+	return sysfs_emit(buf, "%d\n", scheme->target_nid);
+}
+
+static ssize_t target_nid_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_scheme *scheme = container_of(kobj,
+			struct damon_sysfs_scheme, kobj);
+	int err = 0;
+
+	/* TODO: error handling for target_nid range. */
+	err = kstrtoint(buf, 0, &scheme->target_nid);
+
+	return err ? err : count;
+}
+
 static void damon_sysfs_scheme_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_scheme, kobj));
@@ -1703,9 +1728,13 @@ static struct kobj_attribute damon_sysfs
 static struct kobj_attribute damon_sysfs_scheme_apply_interval_us_attr =
 		__ATTR_RW_MODE(apply_interval_us, 0600);
 
+static struct kobj_attribute damon_sysfs_scheme_target_nid_attr =
+		__ATTR_RW_MODE(target_nid, 0600);
+
 static struct attribute *damon_sysfs_scheme_attrs[] = {
 	&damon_sysfs_scheme_action_attr.attr,
 	&damon_sysfs_scheme_apply_interval_us_attr.attr,
+	&damon_sysfs_scheme_target_nid_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_scheme);
@@ -2031,7 +2060,8 @@ static struct damos *damon_sysfs_mk_sche
 	};
 
 	scheme = damon_new_scheme(&pattern, sysfs_scheme->action,
-			sysfs_scheme->apply_interval_us, &quota, &wmarks);
+			sysfs_scheme->apply_interval_us, &quota, &wmarks,
+			sysfs_scheme->target_nid);
 	if (!scheme)
 		return NULL;
 
@@ -2068,6 +2098,7 @@ static void damon_sysfs_update_scheme(st
 
 	scheme->action = sysfs_scheme->action;
 	scheme->apply_interval_us = sysfs_scheme->apply_interval_us;
+	scheme->target_nid = sysfs_scheme->target_nid;
 
 	scheme->quota.ms = sysfs_quotas->ms;
 	scheme->quota.sz = sysfs_quotas->sz;
_

Patches currently in -mm which might be from hyeongtak.ji@sk.com are


