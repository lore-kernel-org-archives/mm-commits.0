Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A6E3CB911
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439097; cv=none; b=jqg2PSYb36QdBS+WjpKqXIoBYvTKxwfuj7+CpDmGF93F5aKQrSYS/bvDE6sM+za39CrPN1PrAzvgdbql/gHxSMzodHkMyue5ZGZ8Av6xfPUrxpqdbJQGhz1D/Dzq6Ihcolcutt5HABgQeL5QFlBcFaclUtTu/JDHBc+qTF4S0dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439097; c=relaxed/simple;
	bh=dg/00NYZERxYX/h/DTWxAbp64Lbnaymx9qRZ8Dintco=;
	h=Date:To:From:Subject:Message-Id; b=K2ypWw4vm0k03qW75NClGl2fKJ7xtf2iIt/phv4c4INAn+b0o88afi6R4hT1axXiqmWyphg1Xv+MmFFk2tg9n8HQjH3EBZYLwqMJLc9/3Vwqt7b7ZZByFiTj6VBSZVeTHuY/iaBFaORnEZg+/q00wTHzEbzjz3hPs/ArQyL0gYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Di2O43K7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Di2O43K7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A885A1F00898;
	Tue,  2 Jun 2026 22:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439095;
	bh=9arZRW9pL0W1v99xnzepVUbgvsHZqYMOiOi5kSiU63A=;
	h=Date:To:From:Subject;
	b=Di2O43K7M0xrjjcn8ZjgvJ67au9wUvTw32QcX8x3hvV/+cKQKPw3+flDsHDUanYTx
	 5TfaGug7MTud6oy68BhfNGd80KuLpY3u5RVT4kWaWQDPTWDB6g80QIKt3g3akunjMR
	 9D4rq8ejoeEdm+404mb15PttLfdklAQ+PHSIlFDo=
Date: Tue, 02 Jun 2026 15:24:55 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rostedt@goodmis.org,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-implement-probe-dir.patch removed from -mm tree
Message-Id: <20260602222455.A885A1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: implement probe dir
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-implement-probe-dir.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: implement probe dir
Date: Mon, 18 May 2026 16:40:58 -0700

Implement sysfs directory for letting users install each data probe.

Link: https://lore.kernel.org/20260518234119.97569-11-sj@kernel.org
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

 mm/damon/sysfs.c |  119 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 119 insertions(+)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-implement-probe-dir
+++ a/mm/damon/sysfs.c
@@ -748,11 +748,42 @@ static const struct kobj_type damon_sysf
 };
 
 /*
+ * probe directory
+ */
+
+struct damon_sysfs_probe {
+	struct kobject kobj;
+};
+
+static struct damon_sysfs_probe *damon_sysfs_probe_alloc(void)
+{
+	return kzalloc_obj(struct damon_sysfs_probe);
+}
+
+static void damon_sysfs_probe_release(struct kobject *kobj)
+{
+	kfree(container_of(kobj, struct damon_sysfs_probe, kobj));
+}
+
+static struct attribute *damon_sysfs_probe_attrs[] = {
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_probe);
+
+static const struct kobj_type damon_sysfs_probe_ktype = {
+	.release = damon_sysfs_probe_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_probe_groups,
+};
+
+/*
  * probes directory
  */
 
 struct damon_sysfs_probes {
 	struct kobject kobj;
+	struct damon_sysfs_probe **probes_arr;
+	int nr;
 };
 
 static struct damon_sysfs_probes *damon_sysfs_probes_alloc(void)
@@ -760,12 +791,99 @@ static struct damon_sysfs_probes *damon_
 	return kzalloc_obj(struct damon_sysfs_probes);
 }
 
+static void damon_sysfs_probes_rm_dirs(
+		struct damon_sysfs_probes *probes)
+{
+	struct damon_sysfs_probe **probes_arr = probes->probes_arr;
+	int i;
+
+	for (i = 0; i < probes->nr; i++)
+		kobject_put(&probes_arr[i]->kobj);
+	probes->nr = 0;
+	kfree(probes_arr);
+	probes->probes_arr = NULL;
+}
+
+static int damon_sysfs_probes_add_dirs(
+		struct damon_sysfs_probes *probes, int nr_probes)
+{
+	struct damon_sysfs_probe **probes_arr, *probe;
+	int err, i;
+
+	damon_sysfs_probes_rm_dirs(probes);
+	if (!nr_probes)
+		return 0;
+
+	probes_arr = kmalloc_objs(*probes_arr, nr_probes,
+				   GFP_KERNEL | __GFP_NOWARN);
+	if (!probes_arr)
+		return -ENOMEM;
+	probes->probes_arr = probes_arr;
+
+	for (i = 0; i < nr_probes; i++) {
+		probe = damon_sysfs_probe_alloc();
+		if (!probe) {
+			damon_sysfs_probes_rm_dirs(probes);
+			return -ENOMEM;
+		}
+
+		err = kobject_init_and_add(&probe->kobj,
+				&damon_sysfs_probe_ktype, &probes->kobj,
+				"%d", i);
+		if (err) {
+			kobject_put(&probe->kobj);
+			damon_sysfs_probes_rm_dirs(probes);
+			return err;
+		}
+
+		probes_arr[i] = probe;
+		probes->nr++;
+	}
+	return 0;
+}
+
+static ssize_t nr_probes_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_probes *probes = container_of(kobj,
+			struct damon_sysfs_probes, kobj);
+
+	return sysfs_emit(buf, "%d\n", probes->nr);
+}
+
+static ssize_t nr_probes_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_probes *probes;
+	int nr, err = kstrtoint(buf, 0, &nr);
+
+	if (err)
+		return err;
+	if (nr < 0 || nr > DAMON_MAX_PROBES)
+		return -EINVAL;
+
+	probes = container_of(kobj, struct damon_sysfs_probes, kobj);
+
+	if (!mutex_trylock(&damon_sysfs_lock))
+		return -EBUSY;
+	err = damon_sysfs_probes_add_dirs(probes, nr);
+	mutex_unlock(&damon_sysfs_lock);
+	if (err)
+		return err;
+
+	return count;
+}
+
 static void damon_sysfs_probes_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_probes, kobj));
 }
 
+static struct kobj_attribute damon_sysfs_probes_nr_probes =
+		__ATTR_RW_MODE(nr_probes, 0600);
+
 static struct attribute *damon_sysfs_probes_attrs[] = {
+	&damon_sysfs_probes_nr_probes.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_probes);
@@ -862,6 +980,7 @@ static void damon_sysfs_attrs_rm_dirs(st
 	kobject_put(&attrs->nr_regions_range->kobj);
 	damon_sysfs_intervals_rm_dirs(attrs->intervals);
 	kobject_put(&attrs->intervals->kobj);
+	damon_sysfs_probes_rm_dirs(attrs->probes);
 	kobject_put(&attrs->probes->kobj);
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
maintainers-add-testing-abi-documents-for-mm.patch

