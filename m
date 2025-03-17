Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9BE2215795
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188278; cv=none; b=WvnZTYjfDa21fIIcfMxoL3bA1LWzlLOGf+vEOjWSYvMlE/7bmw7hFvApvZ7DhBd3WHNfk0YAEqkIGmdHBgO54G44Oyy0PFfmqUZv8yES9yQMM4LnUPYk4vPrhPwz+2NfpbEjlaAP2Qdo+Qf2Uom2884HN393PVk8/htm6ucK1NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188278; c=relaxed/simple;
	bh=6iazGq7S1/KyvdC3+Cew3BltLO18XfMzHrTe02TW61c=;
	h=Date:To:From:Subject:Message-Id; b=Lmiiv86B1eCayHWdhiIhEqR5LS7Ygb0dD0DYt0gpuOA3oycZDwMRN2ScToGl3pmXRSnAQAmCkyQIE6SqxusBMHAB9lItFHiwIo3z5ZIPkfqDRVeVfcN+8Fkj62cWPNLBC5Pjpygr9BcevRmDP+adroiU3PaH3JkgvP1GT3GyLOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OoSrnHGo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OoSrnHGo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A9E9C4CEEC;
	Mon, 17 Mar 2025 05:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188276;
	bh=6iazGq7S1/KyvdC3+Cew3BltLO18XfMzHrTe02TW61c=;
	h=Date:To:From:Subject:From;
	b=OoSrnHGod2+wH5NM0WgUODQpLTUPn875OKRhLNV1WK7aQ0IFvWkv7vTXTpbOVIBLW
	 +7DazZcY2X8bKwS2T7sWZYz6zfWtaKXAbJc+nap1gt5nU0QG44Jc1VoDdoBJ+E1GeN
	 Wmhlaq7KUNC16W2+4BfpnBUaxPu16NJNg29RyRuE=
Date: Sun, 16 Mar 2025 22:11:15 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,hannes@cmpxchg.org,david@redhat.com,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-add-files-for-setting-damos_filter-sz_range.patch removed from -mm tree
Message-Id: <20250317051116.1A9E9C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: add files for setting damos_filter->sz_range
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-add-files-for-setting-damos_filter-sz_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Usama Arif <usamaarif642@gmail.com>
Subject: mm/damon/sysfs-schemes: add files for setting damos_filter->sz_range
Date: Tue, 11 Feb 2025 12:43:41 +0000

Add min and max files for damon filters to let the userspace decide the
min/max folio size to operate on.  This will be needed to decide what
folio sizes to give pa_stat for.

Link: https://lkml.kernel.org/r/20250211124437.278873-3-usamaarif642@gmail.com
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   54 +++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-add-files-for-setting-damos_filter-sz_range
+++ a/mm/damon/sysfs-schemes.c
@@ -316,6 +316,7 @@ struct damon_sysfs_scheme_filter {
 	bool allow;
 	char *memcg_path;
 	struct damon_addr_range addr_range;
+	struct damon_size_range sz_range;
 	int target_idx;
 };
 
@@ -474,6 +475,44 @@ static ssize_t addr_end_store(struct kob
 	return err ? err : count;
 }
 
+static ssize_t min_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
+			struct damon_sysfs_scheme_filter, kobj);
+
+	return sysfs_emit(buf, "%lu\n", filter->sz_range.min);
+}
+
+static ssize_t min_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
+			struct damon_sysfs_scheme_filter, kobj);
+	int err = kstrtoul(buf, 0, &filter->sz_range.min);
+
+	return err ? err : count;
+}
+
+static ssize_t max_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
+			struct damon_sysfs_scheme_filter, kobj);
+
+	return sysfs_emit(buf, "%lu\n", filter->sz_range.max);
+}
+
+static ssize_t max_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
+			struct damon_sysfs_scheme_filter, kobj);
+	int err = kstrtoul(buf, 0, &filter->sz_range.max);
+
+	return err ? err : count;
+}
+
 static ssize_t damon_target_idx_show(struct kobject *kobj,
 		struct kobj_attribute *attr, char *buf)
 {
@@ -520,6 +559,12 @@ static struct kobj_attribute damon_sysfs
 static struct kobj_attribute damon_sysfs_scheme_filter_addr_end_attr =
 		__ATTR_RW_MODE(addr_end, 0600);
 
+static struct kobj_attribute damon_sysfs_scheme_filter_min_attr =
+		__ATTR_RW_MODE(min, 0600);
+
+static struct kobj_attribute damon_sysfs_scheme_filter_max_attr =
+		__ATTR_RW_MODE(max, 0600);
+
 static struct kobj_attribute damon_sysfs_scheme_filter_damon_target_idx_attr =
 		__ATTR_RW_MODE(damon_target_idx, 0600);
 
@@ -530,6 +575,8 @@ static struct attribute *damon_sysfs_sch
 	&damon_sysfs_scheme_filter_memcg_path_attr.attr,
 	&damon_sysfs_scheme_filter_addr_start_attr.attr,
 	&damon_sysfs_scheme_filter_addr_end_attr.attr,
+	&damon_sysfs_scheme_filter_min_attr.attr,
+	&damon_sysfs_scheme_filter_max_attr.attr,
 	&damon_sysfs_scheme_filter_damon_target_idx_attr.attr,
 	NULL,
 };
@@ -1954,6 +2001,13 @@ static int damon_sysfs_add_scheme_filter
 			filter->addr_range = sysfs_filter->addr_range;
 		} else if (filter->type == DAMOS_FILTER_TYPE_TARGET) {
 			filter->target_idx = sysfs_filter->target_idx;
+		} else if (filter->type == DAMOS_FILTER_TYPE_HUGEPAGE_SIZE) {
+			if (sysfs_filter->sz_range.min >
+					sysfs_filter->sz_range.max) {
+				damos_destroy_filter(filter);
+				return -EINVAL;
+			}
+			filter->sz_range = sysfs_filter->sz_range;
 		}
 
 		damos_add_filter(scheme, filter);
_

Patches currently in -mm which might be from usamaarif642@gmail.com are


