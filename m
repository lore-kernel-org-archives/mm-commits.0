Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ACB818A925
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925208; cv=none; b=gWaw3YMn1omCpVc2pmHGcgn9CpjBhS57xP+rar130gCbiVH0Rzgb1xO+tGQlf0Hk0B61Co6euKlqYUno8sZ2Ul8Sj+3lpiNSjZyiYrGBc6eGHmo1wtwlXMQ79o54Bt4JtjBrgibEjecNf0r+UHhpTQg2JYFvmayG2XwyqxeHcXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925208; c=relaxed/simple;
	bh=RJRhATHnIwYca/R8RrGXGQQYKCi7jvwxmn2lmc43Yes=;
	h=Date:To:From:Subject:Message-Id; b=IJdYkvvGbC8T2tate5qq/FiLlcO6b7EXu1rpavMeu3biNrMQ3xY9xoWGeXYXJLTe4Q1OtT1WfCAbPn4RU1B/s0MSrtVK43y4DLeOESzmN5MNg7Z4gWCsM4q6skRRiKoZDnb4dBoBQWD8/aRNggjISVHFyiZu8Ro+owGWg6fhVRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h1J7xH3O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h1J7xH3O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16AA4C4CEC5;
	Mon,  9 Sep 2024 23:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925208;
	bh=RJRhATHnIwYca/R8RrGXGQQYKCi7jvwxmn2lmc43Yes=;
	h=Date:To:From:Subject:From;
	b=h1J7xH3OBK0vu8tMgL+f5AdF99Y1Tch9I4SCRc1NRm1zxTndjyRI0pa792rNLSjq/
	 C/zV3auPPEFFtrYhE6Kkd7FG03455zhSqi1pc6YSVI+49KoSMaxJ4uOq1LBZ4kH9dU
	 nSIG2/8ZusXctyktRR0IzXr2BHpJkK7eE+mSvN/U=
Date: Mon, 09 Sep 2024 16:40:07 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ioworker0@gmail.com,hughd@google.com,gshan@redhat.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-tidy-up-shmem-mthp-controls-and-stats.patch removed from -mm tree
Message-Id: <20240909234008.16AA4C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: tidy up shmem mTHP controls and stats
has been removed from the -mm tree.  Its filename was
     mm-tidy-up-shmem-mthp-controls-and-stats.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: tidy up shmem mTHP controls and stats
Date: Thu, 8 Aug 2024 12:18:47 +0100

Previously we had a situation where shmem mTHP controls and stats were not
exposed for some supported sizes and were exposed for some unsupported
sizes.  So let's clean that up.

Anon mTHP can support all large orders [2, PMD_ORDER].  But shmem can
support all large orders [1, MAX_PAGECACHE_ORDER].  However, per-size
shmem controls and stats were previously being exposed for all the anon
mTHP orders, meaning order-1 was not present, and for arm64 64K base
pages, orders 12 and 13 were exposed but were not supported internally.

Tidy this all up by defining ctrl and stats attribute groups for anon and
file separately.  Anon ctrl and stats groups are populated for all orders
in THP_ORDERS_ALL_ANON and file ctrl and stats groups are populated for
all orders in THP_ORDERS_ALL_FILE_DEFAULT.

Additionally, create "any" ctrl and stats attribute groups which are
populated for all orders in (THP_ORDERS_ALL_ANON |
THP_ORDERS_ALL_FILE_DEFAULT).  swpout stats use this since they apply to
anon and shmem.

The side-effect of all this is that different hugepage-*kB directories
contain different sets of controls and stats, depending on which memory
types support that size.  This approach is preferred over the alternative,
which is to populate dummy controls and stats for memory types that do not
support a given size.

[ryan.roberts@arm.com: file pages and shmem can also be split]
  Link: https://lkml.kernel.org/r/f7ced14c-8bc5-405f-bee7-94f63980f525@arm.comLink: https://lkml.kernel.org/r/20240808111849.651867-3-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Tested-by: Barry Song <baohua@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |  140 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 112 insertions(+), 28 deletions(-)

--- a/mm/huge_memory.c~mm-tidy-up-shmem-mthp-controls-and-stats
+++ a/mm/huge_memory.c
@@ -460,8 +460,8 @@ static void thpsize_release(struct kobje
 static DEFINE_SPINLOCK(huge_anon_orders_lock);
 static LIST_HEAD(thpsize_list);
 
-static ssize_t thpsize_enabled_show(struct kobject *kobj,
-				    struct kobj_attribute *attr, char *buf)
+static ssize_t anon_enabled_show(struct kobject *kobj,
+				 struct kobj_attribute *attr, char *buf)
 {
 	int order = to_thpsize(kobj)->order;
 	const char *output;
@@ -478,9 +478,9 @@ static ssize_t thpsize_enabled_show(stru
 	return sysfs_emit(buf, "%s\n", output);
 }
 
-static ssize_t thpsize_enabled_store(struct kobject *kobj,
-				     struct kobj_attribute *attr,
-				     const char *buf, size_t count)
+static ssize_t anon_enabled_store(struct kobject *kobj,
+				  struct kobj_attribute *attr,
+				  const char *buf, size_t count)
 {
 	int order = to_thpsize(kobj)->order;
 	ssize_t ret = count;
@@ -522,19 +522,35 @@ static ssize_t thpsize_enabled_store(str
 	return ret;
 }
 
-static struct kobj_attribute thpsize_enabled_attr =
-	__ATTR(enabled, 0644, thpsize_enabled_show, thpsize_enabled_store);
+static struct kobj_attribute anon_enabled_attr =
+	__ATTR(enabled, 0644, anon_enabled_show, anon_enabled_store);
 
-static struct attribute *thpsize_attrs[] = {
-	&thpsize_enabled_attr.attr,
+static struct attribute *anon_ctrl_attrs[] = {
+	&anon_enabled_attr.attr,
+	NULL,
+};
+
+static const struct attribute_group anon_ctrl_attr_grp = {
+	.attrs = anon_ctrl_attrs,
+};
+
+static struct attribute *file_ctrl_attrs[] = {
 #ifdef CONFIG_SHMEM
 	&thpsize_shmem_enabled_attr.attr,
 #endif
 	NULL,
 };
 
-static const struct attribute_group thpsize_attr_group = {
-	.attrs = thpsize_attrs,
+static const struct attribute_group file_ctrl_attr_grp = {
+	.attrs = file_ctrl_attrs,
+};
+
+static struct attribute *any_ctrl_attrs[] = {
+	NULL,
+};
+
+static const struct attribute_group any_ctrl_attr_grp = {
+	.attrs = any_ctrl_attrs,
 };
 
 static const struct kobj_type thpsize_ktype = {
@@ -573,64 +589,132 @@ DEFINE_MTHP_STAT_ATTR(anon_fault_fallbac
 DEFINE_MTHP_STAT_ATTR(anon_fault_fallback_charge, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
 DEFINE_MTHP_STAT_ATTR(swpout, MTHP_STAT_SWPOUT);
 DEFINE_MTHP_STAT_ATTR(swpout_fallback, MTHP_STAT_SWPOUT_FALLBACK);
+#ifdef CONFIG_SHMEM
 DEFINE_MTHP_STAT_ATTR(shmem_alloc, MTHP_STAT_SHMEM_ALLOC);
 DEFINE_MTHP_STAT_ATTR(shmem_fallback, MTHP_STAT_SHMEM_FALLBACK);
 DEFINE_MTHP_STAT_ATTR(shmem_fallback_charge, MTHP_STAT_SHMEM_FALLBACK_CHARGE);
+#endif
 DEFINE_MTHP_STAT_ATTR(split, MTHP_STAT_SPLIT);
 DEFINE_MTHP_STAT_ATTR(split_failed, MTHP_STAT_SPLIT_FAILED);
 DEFINE_MTHP_STAT_ATTR(split_deferred, MTHP_STAT_SPLIT_DEFERRED);
 
-static struct attribute *stats_attrs[] = {
+static struct attribute *anon_stats_attrs[] = {
 	&anon_fault_alloc_attr.attr,
 	&anon_fault_fallback_attr.attr,
 	&anon_fault_fallback_charge_attr.attr,
+#ifndef CONFIG_SHMEM
 	&swpout_attr.attr,
 	&swpout_fallback_attr.attr,
+#endif
+	&split_deferred_attr.attr,
+	NULL,
+};
+
+static struct attribute_group anon_stats_attr_grp = {
+	.name = "stats",
+	.attrs = anon_stats_attrs,
+};
+
+static struct attribute *file_stats_attrs[] = {
+#ifdef CONFIG_SHMEM
 	&shmem_alloc_attr.attr,
 	&shmem_fallback_attr.attr,
 	&shmem_fallback_charge_attr.attr,
+#endif
+	NULL,
+};
+
+static struct attribute_group file_stats_attr_grp = {
+	.name = "stats",
+	.attrs = file_stats_attrs,
+};
+
+static struct attribute *any_stats_attrs[] = {
+#ifdef CONFIG_SHMEM
+	&swpout_attr.attr,
+	&swpout_fallback_attr.attr,
+#endif
 	&split_attr.attr,
 	&split_failed_attr.attr,
-	&split_deferred_attr.attr,
 	NULL,
 };
 
-static struct attribute_group stats_attr_group = {
+static struct attribute_group any_stats_attr_grp = {
 	.name = "stats",
-	.attrs = stats_attrs,
+	.attrs = any_stats_attrs,
 };
 
+static int sysfs_add_group(struct kobject *kobj,
+			   const struct attribute_group *grp)
+{
+	int ret = -ENOENT;
+
+	/*
+	 * If the group is named, try to merge first, assuming the subdirectory
+	 * was already created. This avoids the warning emitted by
+	 * sysfs_create_group() if the directory already exists.
+	 */
+	if (grp->name)
+		ret = sysfs_merge_group(kobj, grp);
+	if (ret)
+		ret = sysfs_create_group(kobj, grp);
+
+	return ret;
+}
+
 static struct thpsize *thpsize_create(int order, struct kobject *parent)
 {
 	unsigned long size = (PAGE_SIZE << order) / SZ_1K;
 	struct thpsize *thpsize;
-	int ret;
+	int ret = -ENOMEM;
 
 	thpsize = kzalloc(sizeof(*thpsize), GFP_KERNEL);
 	if (!thpsize)
-		return ERR_PTR(-ENOMEM);
+		goto err;
+
+	thpsize->order = order;
 
 	ret = kobject_init_and_add(&thpsize->kobj, &thpsize_ktype, parent,
 				   "hugepages-%lukB", size);
 	if (ret) {
 		kfree(thpsize);
-		return ERR_PTR(ret);
+		goto err;
 	}
 
-	ret = sysfs_create_group(&thpsize->kobj, &thpsize_attr_group);
-	if (ret) {
-		kobject_put(&thpsize->kobj);
-		return ERR_PTR(ret);
+
+	ret = sysfs_add_group(&thpsize->kobj, &any_ctrl_attr_grp);
+	if (ret)
+		goto err_put;
+
+	ret = sysfs_add_group(&thpsize->kobj, &any_stats_attr_grp);
+	if (ret)
+		goto err_put;
+
+	if (BIT(order) & THP_ORDERS_ALL_ANON) {
+		ret = sysfs_add_group(&thpsize->kobj, &anon_ctrl_attr_grp);
+		if (ret)
+			goto err_put;
+
+		ret = sysfs_add_group(&thpsize->kobj, &anon_stats_attr_grp);
+		if (ret)
+			goto err_put;
 	}
 
-	ret = sysfs_create_group(&thpsize->kobj, &stats_attr_group);
-	if (ret) {
-		kobject_put(&thpsize->kobj);
-		return ERR_PTR(ret);
+	if (BIT(order) & THP_ORDERS_ALL_FILE_DEFAULT) {
+		ret = sysfs_add_group(&thpsize->kobj, &file_ctrl_attr_grp);
+		if (ret)
+			goto err_put;
+
+		ret = sysfs_add_group(&thpsize->kobj, &file_stats_attr_grp);
+		if (ret)
+			goto err_put;
 	}
 
-	thpsize->order = order;
 	return thpsize;
+err_put:
+	kobject_put(&thpsize->kobj);
+err:
+	return ERR_PTR(ret);
 }
 
 static void thpsize_release(struct kobject *kobj)
@@ -671,7 +755,7 @@ static int __init hugepage_init_sysfs(st
 		goto remove_hp_group;
 	}
 
-	orders = THP_ORDERS_ALL_ANON;
+	orders = THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_FILE_DEFAULT;
 	order = highest_order(orders);
 	while (orders) {
 		thpsize = thpsize_create(order, *hugepage_kobj);
_

Patches currently in -mm which might be from ryan.roberts@arm.com are


