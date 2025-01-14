Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E881C548C
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837208; cv=none; b=ZFPonmwgntb6ONmb7U42yzl3UQ5zOnK+4n5nDMsw5VQthnkPtdSB8M9BOerdu6PpM50KoiAUCXgn6c84Da01h9pELF5iea6907u3zkF47vO330zmQuYNZ3eSKPBPJat4X1MjchIRnBfKt0mRkKaoBDU0fMp2YXm6toWKuZzGKTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837208; c=relaxed/simple;
	bh=4iSQQgpd6rkT191kDUTi3xCOgVGReOgFTNaZF1k5ptI=;
	h=Date:To:From:Subject:Message-Id; b=FTf7gNTpG/EmXjQcXFYldY4spa3nCqv0yCJVGUBInmbDgdS6ad6E0jGJU+W8Ufr4FJoisEqUHUzsXsWNIEzanuU1FoSAoXCEAWNYpXm5ymJERP6b/rzZSFq1x+IvfceV78c3LLBheaDIN5eeqjsY18ccpC7ROi+iudgldpQ7tzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uNuWVUsw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uNuWVUsw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD3E6C4CEDD;
	Tue, 14 Jan 2025 06:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837207;
	bh=4iSQQgpd6rkT191kDUTi3xCOgVGReOgFTNaZF1k5ptI=;
	h=Date:To:From:Subject:From;
	b=uNuWVUsw0O8KmBKCyaLeYidRCA99tiCQyC+4hRZI1XTZgfHDqAm4kFdKeZBPNuCMP
	 vO7wFBiefLkgWoOmv+LxdZnSSN7d9/SfhG9yvfs6son7NSDhh16iZnuPImU4f9+g/4
	 eg2oPRKFTVQcwwL6fz+VfjCyJpFLEoMwLn6zzxKw=
Date: Mon, 13 Jan 2025 22:46:47 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-add-a-file-for-setting-damos_filter-allow.patch removed from -mm tree
Message-Id: <20250114064647.CD3E6C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: add a file for setting damos_filter->allow
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-add-a-file-for-setting-damos_filter-allow.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: add a file for setting damos_filter->allow
Date: Thu, 9 Jan 2025 09:51:22 -0800

Only kernel-space DAMON API users can use inclusive DAMOS filters.  Add a
sysfs file named 'allow' under DAMOS filter directory of DAMON sysfs
interface, to let the user-space users use inclusive DAMOS filters.

Link: https://lkml.kernel.org/r/20250109175126.57878-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-add-a-file-for-setting-damos_filter-allow
+++ a/mm/damon/sysfs-schemes.c
@@ -313,6 +313,7 @@ struct damon_sysfs_scheme_filter {
 	struct kobject kobj;
 	enum damos_filter_type type;
 	bool matching;
+	bool allow;
 	char *memcg_path;
 	struct damon_addr_range addr_range;
 	int target_idx;
@@ -385,6 +386,30 @@ static ssize_t matching_store(struct kob
 	return count;
 }
 
+static ssize_t allow_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
+			struct damon_sysfs_scheme_filter, kobj);
+
+	return sysfs_emit(buf, "%c\n", filter->allow ? 'Y' : 'N');
+}
+
+static ssize_t allow_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
+			struct damon_sysfs_scheme_filter, kobj);
+	bool allow;
+	int err = kstrtobool(buf, &allow);
+
+	if (err)
+		return err;
+
+	filter->allow = allow;
+	return count;
+}
+
 static ssize_t memcg_path_show(struct kobject *kobj,
 		struct kobj_attribute *attr, char *buf)
 {
@@ -482,6 +507,9 @@ static struct kobj_attribute damon_sysfs
 static struct kobj_attribute damon_sysfs_scheme_filter_matching_attr =
 		__ATTR_RW_MODE(matching, 0600);
 
+static struct kobj_attribute damon_sysfs_scheme_filter_allow_attr =
+		__ATTR_RW_MODE(allow, 0600);
+
 static struct kobj_attribute damon_sysfs_scheme_filter_memcg_path_attr =
 		__ATTR_RW_MODE(memcg_path, 0600);
 
@@ -497,6 +525,7 @@ static struct kobj_attribute damon_sysfs
 static struct attribute *damon_sysfs_scheme_filter_attrs[] = {
 	&damon_sysfs_scheme_filter_type_attr.attr,
 	&damon_sysfs_scheme_filter_matching_attr.attr,
+	&damon_sysfs_scheme_filter_allow_attr.attr,
 	&damon_sysfs_scheme_filter_memcg_path_attr.attr,
 	&damon_sysfs_scheme_filter_addr_start_attr.attr,
 	&damon_sysfs_scheme_filter_addr_end_attr.attr,
@@ -1901,7 +1930,8 @@ static int damon_sysfs_add_scheme_filter
 			sysfs_filters->filters_arr[i];
 		struct damos_filter *filter =
 			damos_new_filter(sysfs_filter->type,
-					sysfs_filter->matching, false);
+					sysfs_filter->matching,
+					sysfs_filter->allow);
 		int err;
 
 		if (!filter)
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch

