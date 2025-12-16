Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097532BFC60
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 18:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765911500; cv=none; b=T/Da+AH6pS903Kf3O0NjPs8AhN38ByV1yuN5rMbwrj7O9z49whiKeUL6Vz6M3RgJ41ATfg8hBGiEjRC7rwLlO2V1XQ0EquiG+xureWNY1GofClvYT/DNKqi+InTIz7eCANNHlZA0hgy/vizWHmC0tzkTH3bM//Kv3DWb3NU5f+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765911500; c=relaxed/simple;
	bh=epJ6oWLxx0/MVGiyVzgT6nSfkFR9L+lct4DoJTKaclY=;
	h=Date:To:From:Subject:Message-Id; b=XaI3A1Givqi9azTE6pOhh5gMoC57yPV3I/WcZlzrkhXsoeUr0hiBSHX4efWHMUHWqpZY1efqfffHKC0WI2hbzO4YIHSJuznQJ0LODuwqagYfXiRRxxFEO+vo28px27cDdR/bOt7h7aVqukKOSmpbNdj8O6+9jPQDD0wM07ukL7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l8+ra5iQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l8+ra5iQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFA41C4CEF1;
	Tue, 16 Dec 2025 18:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765911499;
	bh=epJ6oWLxx0/MVGiyVzgT6nSfkFR9L+lct4DoJTKaclY=;
	h=Date:To:From:Subject:From;
	b=l8+ra5iQ6VfxRCWqNxRv/Xh3AZY8uiXtwhBojMoyBuRAxz/xauftweJkIJ5mtMzFt
	 5Q9ZQFThQQW7YMIG3NlPIEbfNvKQusHM0LM0/GqSk6+58SgcNQYixOK+Rs/6Olb7Wp
	 8HM6+ao5VtRi4x1yLBiVWCYSCaxvvNxHo/VrZl7s=
Date: Tue, 16 Dec 2025 10:58:19 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,rostedt@goodmis.org,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-implement-max_nr_snapshots-file.patch added to mm-new branch
Message-Id: <20251216185819.CFA41C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs-schemes: implement max_nr_snapshots file
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-schemes-implement-max_nr_snapshots-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-implement-max_nr_snapshots-file.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
Subject: mm/damon/sysfs-schemes: implement max_nr_snapshots file
Date: Tue, 16 Dec 2025 00:01:21 -0800

Add a new DAMON sysfs file for setting and getting the newly introduced
per-DAMON-snapshot level DAMOS deactivation control parameter,
max_nr_snapshots.  The file has a name same to the parameter and placed
under the damos stat directory.

Link: https://lkml.kernel.org/r/20251216080128.42991-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-implement-max_nr_snapshots-file
+++ a/mm/damon/sysfs-schemes.c
@@ -205,6 +205,7 @@ struct damon_sysfs_stats {
 	unsigned long sz_ops_filter_passed;
 	unsigned long qt_exceeds;
 	unsigned long nr_snapshots;
+	unsigned long max_nr_snapshots;
 };
 
 static struct damon_sysfs_stats *damon_sysfs_stats_alloc(void)
@@ -275,6 +276,28 @@ static ssize_t nr_snapshots_show(struct
 	return sysfs_emit(buf, "%lu\n", stats->nr_snapshots);
 }
 
+static ssize_t max_nr_snapshots_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_stats *stats = container_of(kobj,
+			struct damon_sysfs_stats, kobj);
+
+	return sysfs_emit(buf, "%lu\n", stats->max_nr_snapshots);
+}
+
+static ssize_t max_nr_snapshots_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_stats *stats = container_of(kobj,
+			struct damon_sysfs_stats, kobj);
+	unsigned long max_nr_snapshots, err = kstrtoul(buf, 0, &max_nr_snapshots);
+
+	if (err)
+		return err;
+	stats->max_nr_snapshots = max_nr_snapshots;
+	return count;
+}
+
 static void damon_sysfs_stats_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_stats, kobj));
@@ -301,6 +324,9 @@ static struct kobj_attribute damon_sysfs
 static struct kobj_attribute damon_sysfs_stats_nr_snapshots_attr =
 		__ATTR_RO_MODE(nr_snapshots, 0400);
 
+static struct kobj_attribute damon_sysfs_stats_max_nr_snapshots_attr =
+		__ATTR_RW_MODE(max_nr_snapshots, 0600);
+
 static struct attribute *damon_sysfs_stats_attrs[] = {
 	&damon_sysfs_stats_nr_tried_attr.attr,
 	&damon_sysfs_stats_sz_tried_attr.attr,
@@ -309,6 +335,7 @@ static struct attribute *damon_sysfs_sta
 	&damon_sysfs_stats_sz_ops_filter_passed_attr.attr,
 	&damon_sysfs_stats_qt_exceeds_attr.attr,
 	&damon_sysfs_stats_nr_snapshots_attr.attr,
+	&damon_sysfs_stats_max_nr_snapshots_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_stats);
@@ -2730,6 +2757,7 @@ static struct damos *damon_sysfs_mk_sche
 		damon_destroy_scheme(scheme);
 		return NULL;
 	}
+	scheme->max_nr_snapshots = sysfs_scheme->stats->max_nr_snapshots;
 	return scheme;
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-nr_snapshots-damos-stat.patch
mm-damon-sysfs-schemes-introduce-nr_snapshots-damos-stat-file.patch
docs-mm-damon-design-update-for-nr_snapshots-damos-stat.patch
docs-admin-guide-mm-damon-usage-update-for-nr_snapshots-damos-stat.patch
docs-abi-damon-update-for-nr_snapshots-damos-stat.patch
mm-damon-update-damos-kerneldoc-for-stat-field.patch
mm-damon-core-implement-max_nr_snapshots.patch
mm-damon-sysfs-schemes-implement-max_nr_snapshots-file.patch
docs-mm-damon-design-update-for-max_nr_snapshots.patch
docs-admin-guide-mm-damon-usage-update-for-max_nr_snapshots.patch
docs-abi-damon-update-for-max_nr_snapshots.patch
mm-damon-core-add-trace-point-for-damos-stat-per-apply-interval.patch

