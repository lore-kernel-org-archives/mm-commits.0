Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5293C3C07
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439096; cv=none; b=kJ3hM+UnmWfAcfKzvZuJefDxf8FdM39RK1NJAUyxRzDMoFaGyhd/wRDn+kZHlwdy5NqfLPtOVXDfajh/5Se8rxijCrNLhTnRYbA8Ds+AY21ZKxgMpgAFvDq2NPjh95RVJCuxWED6GEFnRcHzfiSLNUcL3iXr2EiNokA1wm2eqkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439096; c=relaxed/simple;
	bh=sMWmi/A+ONK17giWx/tzDz5xplvfQmhxCwkOm/rSAAU=;
	h=Date:To:From:Subject:Message-Id; b=Hj1dDdyWt3FiapXlgBmmFcm2utY8Dw17T2SC6fbCIDyd0jEVH58Ch+WeGYBnGhtwvwSMXKLvzvdklEakxEK8jZnjupKzFtlpJAGltq94S2dWZixRlcvSs84Z8IQ+SsxoUBi0I16sscko0wtfyj4bROpIzZhxs5gVDD5oU3vRNI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gbdgW4lR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gbdgW4lR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6533D1F00893;
	Tue,  2 Jun 2026 22:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439094;
	bh=chb0rk3VEF0okp9x8nUyXTO690Ga6qsGLl7ttF41K+k=;
	h=Date:To:From:Subject;
	b=gbdgW4lR9T+h8z7EAsEFcd6KkIi6cIFgB/cPefray2nmSxFznw0s/FjHv/SU/s9PG
	 vZMbGtlV4ZScBAoPrJOsajfPJVacjuLQ099uxUorqvhRDIekoUHxsvCCWqv1X5XAfM
	 wEq98dpbrhSB6G4tevaWLRi0zR2Ng+eyDvsM5aac=
Date: Tue, 02 Jun 2026 15:24:53 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rostedt@goodmis.org,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-implement-probes-dir.patch removed from -mm tree
Message-Id: <20260602222454.6533D1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: implement probes dir
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-implement-probes-dir.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: implement probes dir
Date: Mon, 18 May 2026 16:40:57 -0700

Implement sysfs directory that can be used by the users to install data
probes.

Link: https://lore.kernel.org/20260518234119.97569-10-sj@kernel.org
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

 mm/damon/sysfs.c |   46 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-implement-probes-dir
+++ a/mm/damon/sysfs.c
@@ -748,6 +748,35 @@ static const struct kobj_type damon_sysf
 };
 
 /*
+ * probes directory
+ */
+
+struct damon_sysfs_probes {
+	struct kobject kobj;
+};
+
+static struct damon_sysfs_probes *damon_sysfs_probes_alloc(void)
+{
+	return kzalloc_obj(struct damon_sysfs_probes);
+}
+
+static void damon_sysfs_probes_release(struct kobject *kobj)
+{
+	kfree(container_of(kobj, struct damon_sysfs_probes, kobj));
+}
+
+static struct attribute *damon_sysfs_probes_attrs[] = {
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_probes);
+
+static const struct kobj_type damon_sysfs_probes_ktype = {
+	.release = damon_sysfs_probes_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_probes_groups,
+};
+
+/*
  * monitoring_attrs directory
  */
 
@@ -755,6 +784,7 @@ struct damon_sysfs_attrs {
 	struct kobject kobj;
 	struct damon_sysfs_intervals *intervals;
 	struct damon_sysfs_ul_range *nr_regions_range;
+	struct damon_sysfs_probes *probes;
 };
 
 static struct damon_sysfs_attrs *damon_sysfs_attrs_alloc(void)
@@ -771,6 +801,7 @@ static int damon_sysfs_attrs_add_dirs(st
 {
 	struct damon_sysfs_intervals *intervals;
 	struct damon_sysfs_ul_range *nr_regions_range;
+	struct damon_sysfs_probes *probes;
 	int err;
 
 	intervals = damon_sysfs_intervals_alloc(5000, 100000, 60000000);
@@ -799,8 +830,22 @@ static int damon_sysfs_attrs_add_dirs(st
 	if (err)
 		goto put_nr_regions_intervals_out;
 	attrs->nr_regions_range = nr_regions_range;
+
+	probes = damon_sysfs_probes_alloc();
+	if (!probes) {
+		err = -ENOMEM;
+		goto put_nr_regions_intervals_out;
+	}
+	err = kobject_init_and_add(&probes->kobj,
+			&damon_sysfs_probes_ktype, &attrs->kobj, "probes");
+	if (err)
+		goto put_probes_out;
+	attrs->probes = probes;
 	return 0;
 
+put_probes_out:
+	kobject_put(&probes->kobj);
+	attrs->probes = NULL;
 put_nr_regions_intervals_out:
 	kobject_put(&nr_regions_range->kobj);
 	attrs->nr_regions_range = NULL;
@@ -817,6 +862,7 @@ static void damon_sysfs_attrs_rm_dirs(st
 	kobject_put(&attrs->nr_regions_range->kobj);
 	damon_sysfs_intervals_rm_dirs(attrs->intervals);
 	kobject_put(&attrs->intervals->kobj);
+	kobject_put(&attrs->probes->kobj);
 }
 
 static void damon_sysfs_attrs_release(struct kobject *kobj)
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
maintainers-add-testing-abi-documents-for-mm.patch

