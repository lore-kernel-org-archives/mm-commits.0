Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2269F272908
	for <mm-commits@vger.kernel.org>; Tue, 11 Feb 2025 23:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739315438; cv=none; b=P7eWu/aYVdQnCmOWt+66h6TbvhE6Z/ibOaSEcZU0GqvI3LTDWJADS9dbQbWKQm0YLpLJhaUNtYV2YHobRHtBuSao+ujlSyt3yuBeaHsN0MOU60CYZJBaFfkcdN1SkXHtJKQRIQKBFh8URAVYR+zXUmbf8ElgGalryjDxJehcfpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739315438; c=relaxed/simple;
	bh=qqJTem45OoqrDjsbivvjoeSGIab/9S8gfI3x+EaFXiY=;
	h=Date:To:From:Subject:Message-Id; b=Sh6P3jEf36vP81zroZMPjz3n3hTqMxkK2GGCWuhdiYKmj+jMXEnWUeOFbBDaxBKcRpY+RqwIvUFAPazWZ983CQFD+/HrSa7uqYBwRM6BA/iL+Jgs49kNiMRHbW4j4eR3ujobqQcoy1QHnGKmbU36t/6eRieZP3dcdTmZjpXmWZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DwwtZQyK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DwwtZQyK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D844AC4CEDD;
	Tue, 11 Feb 2025 23:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739315437;
	bh=qqJTem45OoqrDjsbivvjoeSGIab/9S8gfI3x+EaFXiY=;
	h=Date:To:From:Subject:From;
	b=DwwtZQyKblYUNDfNL1invJnERzpOuZAAWZQvqSlQuTMXnctduzOVdqPtLy5O5h46n
	 YWx3EL8mHWxkOC3J6Ph842PxT0wIo0i6hiFDmLItDNPXhOTHzNP9Usl5I1iDTTSPrQ
	 A86Q1IWXPcrejkBGAttHcGa6FDTMzaxtt/avPFJo=
Date: Tue, 11 Feb 2025 15:10:37 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,hannes@cmpxchg.org,david@redhat.com,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-add-files-for-setting-damos_filter-sz_range.patch added to mm-unstable branch
Message-Id: <20250211231037.D844AC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs-schemes: add files for setting damos_filter->sz_range
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-add-files-for-setting-damos_filter-sz_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-add-files-for-setting-damos_filter-sz_range.patch

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

mm-damon-ops-have-damon_get_folio-return-folio-even-for-tail-pages.patch
mm-damon-introduce-damos-filter-type-hugepage_size.patch
mm-damon-sysfs-schemes-add-files-for-setting-damos_filter-sz_range.patch
docs-abi-damon-document-damos-sysfs-files-to-set-the-min-max-folio_size.patch
docs-admin-guide-mm-damon-usage-document-hugepage_size-filter-type.patch

