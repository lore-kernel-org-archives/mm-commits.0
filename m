Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A6524334A
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837164; cv=none; b=uF+vhWSakOz5jaQTTzbOEV27G8nv/mF1y5n6/4e/BR9rBnRmJLfuMniiShjQlcoONxPXekaK3e8fLiJ/7andL4/RQVd5PF4AXu8H/INRP4h1pfXx39CRQnvTIkQq35iIX70+XSmUcYNF+oapkPIcGiMNbn8TjZVLwFbQUP6/TTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837164; c=relaxed/simple;
	bh=0oeSGDj69JvOplpcdfmitSha7npM0c3ZWrRHNvWqpSw=;
	h=Date:To:From:Subject:Message-Id; b=sqs0mw/wBQPesjZodgqTsvcHtyL7EF5R4ME/WOPn0Q6wqPjnsmmkiDYNCtpV7RF7JpLimh6oZEP6gnAktrSox8SsM5FOKe0I+dD9zZ/yoRF1ijGatMpxA7CEdpccqxgU4cH2vywqmH0BuEpj3SSesupgxR4KAVto+dMvdmyOHqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rowqG8rZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rowqG8rZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E454C4CEDD;
	Tue, 14 Jan 2025 06:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837164;
	bh=0oeSGDj69JvOplpcdfmitSha7npM0c3ZWrRHNvWqpSw=;
	h=Date:To:From:Subject:From;
	b=rowqG8rZgE4CAFNauG5QrAxrTopKK3B1fZP6rnK1/uysZ03QFmzqTfd9u430FPV3n
	 Fu2d8iLe3Wvwd26muiLj0R0nHodCZN9+MJYvuTDUrTEL8x57Se/WSjs8qPvPAdhMYr
	 PBs9p1YLkvk9I+p8Z+lAHkSOcu848zKaqoiUUEJs=
Date: Mon, 13 Jan 2025 22:46:03 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-syfs-schemes-implement-per-scheme-filter-passed-bytes-stat.patch removed from -mm tree
Message-Id: <20250114064604.4E454C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/syfs-schemes: implement per-scheme filter-passed bytes stat
has been removed from the -mm tree.  Its filename was
     mm-damon-syfs-schemes-implement-per-scheme-filter-passed-bytes-stat.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/syfs-schemes: implement per-scheme filter-passed bytes stat
Date: Mon, 6 Jan 2025 11:33:53 -0800

Add a new DAMON sysfs interface file under scheme stat directory, namely
'sz_ops_filter_passed'.  It represents total bytes that passed
region-internal DAMOS filters of the scheme that handled by the DAMON
operations set layer.

Link: https://lkml.kernel.org/r/20250106193401.109161-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/mm/damon/sysfs-schemes.c~mm-damon-syfs-schemes-implement-per-scheme-filter-passed-bytes-stat
+++ a/mm/damon/sysfs-schemes.c
@@ -188,6 +188,7 @@ struct damon_sysfs_stats {
 	unsigned long sz_tried;
 	unsigned long nr_applied;
 	unsigned long sz_applied;
+	unsigned long sz_ops_filter_passed;
 	unsigned long qt_exceeds;
 };
 
@@ -232,6 +233,15 @@ static ssize_t sz_applied_show(struct ko
 	return sysfs_emit(buf, "%lu\n", stats->sz_applied);
 }
 
+static ssize_t sz_ops_filter_passed_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_stats *stats = container_of(kobj,
+			struct damon_sysfs_stats, kobj);
+
+	return sysfs_emit(buf, "%lu\n", stats->sz_ops_filter_passed);
+}
+
 static ssize_t qt_exceeds_show(struct kobject *kobj,
 		struct kobj_attribute *attr, char *buf)
 {
@@ -258,6 +268,9 @@ static struct kobj_attribute damon_sysfs
 static struct kobj_attribute damon_sysfs_stats_sz_applied_attr =
 		__ATTR_RO_MODE(sz_applied, 0400);
 
+static struct kobj_attribute damon_sysfs_stats_sz_ops_filter_passed_attr =
+		__ATTR_RO_MODE(sz_ops_filter_passed, 0400);
+
 static struct kobj_attribute damon_sysfs_stats_qt_exceeds_attr =
 		__ATTR_RO_MODE(qt_exceeds, 0400);
 
@@ -266,6 +279,7 @@ static struct attribute *damon_sysfs_sta
 	&damon_sysfs_stats_sz_tried_attr.attr,
 	&damon_sysfs_stats_nr_applied_attr.attr,
 	&damon_sysfs_stats_sz_applied_attr.attr,
+	&damon_sysfs_stats_sz_ops_filter_passed_attr.attr,
 	&damon_sysfs_stats_qt_exceeds_attr.attr,
 	NULL,
 };
@@ -2077,6 +2091,8 @@ void damon_sysfs_schemes_update_stats(
 		sysfs_stats->sz_tried = scheme->stat.sz_tried;
 		sysfs_stats->nr_applied = scheme->stat.nr_applied;
 		sysfs_stats->sz_applied = scheme->stat.sz_applied;
+		sysfs_stats->sz_ops_filter_passed =
+			scheme->stat.sz_ops_filter_passed;
 		sysfs_stats->qt_exceeds = scheme->stat.qt_exceeds;
 	}
 }
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch

