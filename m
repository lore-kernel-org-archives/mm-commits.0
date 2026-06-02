Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718EC3C4178
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439103; cv=none; b=XeJVg9CaxanOWkA8F25GgVOmGvNNcRMAOJCqakLyRmLrf0WqM954PS8xmnxXF4o4F8lBiMUeXfnGgQOF5B6q6LVXXZrhiW76rGtUytH7fN+ZCqTbSPOF+pqH0wFwKX3WsO0+TdZXRL/ssBTTnlQkuzsn+jTDfhNoT2EfaONS5Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439103; c=relaxed/simple;
	bh=YqajaiZ7WNukPDhoybvzOtlFu4zpRmo1YfBL9CWSDHc=;
	h=Date:To:From:Subject:Message-Id; b=QJKqBAZmxgpfssT9Ybw7dxU9jeJ7DbIvCAOIahxL05Vwb+Ik8Wth2E8KzwHqykUfY6t8t9k8sT0feVXHoqD5zseOgwc+y+WNd4AEcZfhpudrY700Y3yTGDSu+SWNjowBQmQTH7j1j8/f3pl3NyyrxH2S5d1wKCBNf9qKQePhvyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y4bIuqCq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y4bIuqCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190A11F00893;
	Tue,  2 Jun 2026 22:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439102;
	bh=uOTXFXsic74yM7bOtvvcnYQUTjZqWig8lDQrMwViKew=;
	h=Date:To:From:Subject;
	b=y4bIuqCq078VvFoMQKn3xnUzQ61LdMAHe5a1PWhV1FxBdwDrGikZ026jF/j2gVyTz
	 AIQHw392t/S6CVXKWd915vA7JRTlKQ4ODjzSsgL3BMVY5KWci82uTcxMRRvdaq8nAc
	 kXe8v46CgHbHjFpj7IWBWbnzd9GvwwoGt5qBGqDY=
Date: Tue, 02 Jun 2026 15:25:01 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rostedt@goodmis.org,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-implement-tried_regions-r-probes.patch removed from -mm tree
Message-Id: <20260602222502.190A11F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: implement tried_regions/<r>/probes/
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-implement-tried_regions-r-probes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: implement tried_regions/<r>/probes/
Date: Mon, 18 May 2026 16:41:03 -0700

Implement a sysfs directory for showing the per-region probe hit counts. 
It is named 'probes/' and located under the DAMOS tried region directory.

Link: https://lore.kernel.org/20260518234119.97569-16-sj@kernel.org
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

 mm/damon/sysfs-schemes.c |   67 ++++++++++++++++++++++++++++++++++---
 1 file changed, 63 insertions(+), 4 deletions(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-implement-tried_regions-r-probes
+++ a/mm/damon/sysfs-schemes.c
@@ -11,6 +11,32 @@
 #include "sysfs-common.h"
 
 /*
+ * probes directory
+ */
+
+struct damos_sysfs_probes {
+	struct kobject kobj;
+};
+
+static struct damos_sysfs_probes *damos_sysfs_probes_alloc(void)
+{
+	return kzalloc_obj(struct damos_sysfs_probes);
+}
+
+static void damos_sysfs_probes_release(struct kobject *kobj)
+{
+	struct damos_sysfs_probes *probes = container_of(kobj,
+			struct damos_sysfs_probes, kobj);
+
+	kfree(probes);
+}
+
+static const struct kobj_type damos_sysfs_probes_ktype = {
+	.release = damos_sysfs_probes_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+};
+
+/*
  * scheme region directory
  */
 
@@ -20,6 +46,7 @@ struct damon_sysfs_scheme_region {
 	unsigned int nr_accesses;
 	unsigned int age;
 	unsigned long sz_filter_passed;
+	struct damos_sysfs_probes *probes;
 	struct list_head list;
 };
 
@@ -34,10 +61,36 @@ static struct damon_sysfs_scheme_region
 	sysfs_region->ar = region->ar;
 	sysfs_region->nr_accesses = region->nr_accesses_bp / 10000;
 	sysfs_region->age = region->age;
+	sysfs_region->probes = NULL;
 	INIT_LIST_HEAD(&sysfs_region->list);
 	return sysfs_region;
 }
 
+static int damos_sysfs_region_add_dirs(
+		struct damon_sysfs_scheme_region *region)
+{
+	struct damos_sysfs_probes *probes = damos_sysfs_probes_alloc();
+	int err;
+
+	if (!probes)
+		return -ENOMEM;
+	err = kobject_init_and_add(&probes->kobj, &damos_sysfs_probes_ktype,
+			&region->kobj, "probes");
+	if (err) {
+		kobject_put(&probes->kobj);
+		return err;
+	}
+
+	region->probes = probes;
+	return 0;
+}
+
+static void damos_sysfs_region_rm_dirs(
+		struct damon_sysfs_scheme_region *region)
+{
+	kobject_put(&region->probes->kobj);
+}
+
 static ssize_t start_show(struct kobject *kobj, struct kobj_attribute *attr,
 		char *buf)
 {
@@ -163,6 +216,7 @@ static void damon_sysfs_scheme_regions_r
 	struct damon_sysfs_scheme_region *r, *next;
 
 	list_for_each_entry_safe(r, next, &regions->regions_list, list) {
+		damos_sysfs_region_rm_dirs(r);
 		list_del(&r->list);
 		kobject_put(&r->kobj);
 		regions->nr_regions--;
@@ -2995,12 +3049,17 @@ void damos_sysfs_populate_region_dir(str
 	if (kobject_init_and_add(&region->kobj,
 				&damon_sysfs_scheme_region_ktype,
 				&sysfs_regions->kobj, "%d",
-				sysfs_regions->nr_regions)) {
-		kobject_put(&region->kobj);
-		return;
-	}
+				sysfs_regions->nr_regions))
+		goto out;
+	if (damos_sysfs_region_add_dirs(region))
+		goto out;
+
 	list_add_tail(&region->list, &sysfs_regions->regions_list);
 	sysfs_regions->nr_regions++;
+	return;
+
+out:
+	kobject_put(&region->kobj);
 }
 
 int damon_sysfs_schemes_clear_regions(
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
maintainers-add-testing-abi-documents-for-mm.patch

