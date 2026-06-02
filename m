Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4E43BADB7
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439098; cv=none; b=fljHntRDu6aJ0zJVozAD/COW5174E5tlzLwk7opQfihirjpoLdoSag7zZa0ltaPUu12xSxbLmHp/4fcv3j9ieClg6TtzobbPgT4X5RtZyqzybzTHN5OwoMC6SxPWahg2/N8+T034e/bT7DLNQS9hLLZy5PQFAorxJQsJnHttups=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439098; c=relaxed/simple;
	bh=AcX8pO23vX5gP1nbZ+37nHpRdjDi6ny2VUQKQIyW3x0=;
	h=Date:To:From:Subject:Message-Id; b=htotmOGQ7Vk0yReJh9iiroM3MNQfpSF6AdtYwGYV5WZ2JPTRioAm0avuzGblSAGeAdLi41+/sJ+c71ZjIlWW9Q8xO/30RwSxraHw9WapSamf3leGzHsn3wPj3XnBURzq+9akiBFPfqifb1JMJuyLddB5t9XJOSDMnRvhJGPQC6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xNuev0qR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xNuev0qR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF031F0089A;
	Tue,  2 Jun 2026 22:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439097;
	bh=NUL6jdnd5CDqhBeZDxD9y9lqSQjsbaPcd3MGCicZ090=;
	h=Date:To:From:Subject;
	b=xNuev0qRSIpMz1TI07ElH+RaGl5j2WBOMSz/C9A85sARefqV7Fbs9rWbKVsxb1Vk6
	 pceUkJuf0jQq2p6BnIuwx16LhL32FlT9zM5cTE5/W/Vg5Arrc3QCZri7HJXR5DXhXJ
	 7WdyoCBHubSUbeIUlKj2tuqiJ9SyT+yvwHRKEqAk=
Date: Tue, 02 Jun 2026 15:24:56 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rostedt@goodmis.org,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-implement-filters-directory.patch removed from -mm tree
Message-Id: <20260602222456.EEF031F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: implement filters directory
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-implement-filters-directory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: implement filters directory
Date: Mon, 18 May 2026 16:40:59 -0700

Implement a directory for letting users to install data probe filters.

Link: https://lore.kernel.org/20260518234119.97569-12-sj@kernel.org
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

 mm/damon/sysfs.c |   65 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 64 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-implement-filters-directory
+++ a/mm/damon/sysfs.c
@@ -748,11 +748,41 @@ static const struct kobj_type damon_sysf
 };
 
 /*
+ * filters directory
+ */
+
+struct damon_sysfs_filters {
+	struct kobject kobj;
+};
+
+static struct damon_sysfs_filters *damon_sysfs_filters_alloc(void)
+{
+	return kzalloc_obj(struct damon_sysfs_filters);
+}
+
+static void damon_sysfs_filters_release(struct kobject *kobj)
+{
+	kfree(container_of(kobj, struct damon_sysfs_filters, kobj));
+}
+
+static struct attribute *damon_sysfs_filters_attrs[] = {
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_filters);
+
+static const struct kobj_type damon_sysfs_filters_ktype = {
+	.release = damon_sysfs_filters_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_filters_groups,
+};
+
+/*
  * probe directory
  */
 
 struct damon_sysfs_probe {
 	struct kobject kobj;
+	struct damon_sysfs_filters *filters;
 };
 
 static struct damon_sysfs_probe *damon_sysfs_probe_alloc(void)
@@ -760,6 +790,30 @@ static struct damon_sysfs_probe *damon_s
 	return kzalloc_obj(struct damon_sysfs_probe);
 }
 
+static int damon_sysfs_probe_add_dirs(struct damon_sysfs_probe *attr)
+{
+	struct damon_sysfs_filters *filters;
+	int err;
+
+	filters = damon_sysfs_filters_alloc();
+	if (!filters)
+		return -ENOMEM;
+	attr->filters = filters;
+
+	err = kobject_init_and_add(&filters->kobj, &damon_sysfs_filters_ktype,
+			&attr->kobj, "filters");
+	if (err) {
+		kobject_put(&filters->kobj);
+		attr->filters = NULL;
+	}
+	return err;
+}
+
+static void damon_sysfs_probe_rm_dirs(struct damon_sysfs_probe *attr)
+{
+	kobject_put(&attr->filters->kobj);
+}
+
 static void damon_sysfs_probe_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_probe, kobj));
@@ -797,8 +851,10 @@ static void damon_sysfs_probes_rm_dirs(
 	struct damon_sysfs_probe **probes_arr = probes->probes_arr;
 	int i;
 
-	for (i = 0; i < probes->nr; i++)
+	for (i = 0; i < probes->nr; i++) {
+		damon_sysfs_probe_rm_dirs(probes_arr[i]);
 		kobject_put(&probes_arr[i]->kobj);
+	}
 	probes->nr = 0;
 	kfree(probes_arr);
 	probes->probes_arr = NULL;
@@ -833,6 +889,13 @@ static int damon_sysfs_probes_add_dirs(
 		if (err) {
 			kobject_put(&probe->kobj);
 			damon_sysfs_probes_rm_dirs(probes);
+			return err;
+		}
+
+		err = damon_sysfs_probe_add_dirs(probe);
+		if (err) {
+			kobject_put(&probe->kobj);
+			damon_sysfs_probes_rm_dirs(probes);
 			return err;
 		}
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
maintainers-add-testing-abi-documents-for-mm.patch

