Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963D4486653
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 17:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788283066; cv=none; b=SHf9C6woiNINc+BtGuX5hJE4xxabDMrbL2PbXWgmolASYbe52sMjwvcP+uFjxjRjfB2ArCTr1N3RTAzWyI6NV6+66Vc5wC8+3za6KZ0XVvNIsTzHYlA4yrBRHGvzgSiTVPNPB/m9UdqYcmg/ExU3IpEDY6Zg1WqFZTUnJvrUpu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788283066; c=relaxed/simple;
	bh=mit6zZKCU+KzUYrjgnLNO/b4XUbw7PZswF/4INQKMVY=;
	h=Date:To:From:Subject:Message-Id; b=ZV9TJTv+P15EJifBuA1bRuMBLAautO90h9cM8y66c1Ql0TEU7UEb021gTGzz+7S2RyLEYNpidEIdDfj0vyN7bCgMcjx5Sjact9OI1ZO5o2RGI3u58L1tkW8TZuKnO0vY0t4ycoyK1QlcQwAU1KxJfoNO9AduEUL6UHKTQrt3g1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Sev70tPi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Sev70tPi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF6B1F000E9;
	Tue,  1 Sep 2026 17:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788283064;
	bh=ZDkKSQ5w9dme9BrTVZsUYRUVTmk6jKHEOa+MbPMa+qA=;
	h=Date:To:From:Subject;
	b=Sev70tPi0xSn2Gj1tqvhVH4Nj+iViX+wv/g7JyR33WGxtkWTe29dDo1M30sI4Ju4e
	 fWMM3WzF23STuB/uc3uo5wp/tf92kb1Qb3Ptkku2usPfdRXK3cj1UKFADWzX4Y9ugK
	 QfSAxyeSTuaK9DKIhgrY4y1qkPTh4jDQ6wMVmq9I=
Date: Tue, 01 Sep 2026 10:17:43 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-introduce-damon_prep-struct.patch added to mm-new branch
Message-Id: <20260901171744.2CF6B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: introduce damon_prep struct
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-introduce-damon_prep-struct.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-introduce-damon_prep-struct.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: introduce damon_prep struct
Date: Tue, 1 Sep 2026 06:24:52 -0700

Some DAMON probe filter types require preparatory actions.  For example,
pgilde_unset probe filter can say if the page was accessed but when.  To
answer the second question, the PG_Idle flag should be set at a specific
time.  It can make life much easier if DAMON can do such preparatory
actions.  Introduce a new data type called damon_prep.  It specifies each
of the preparation actions for each probe.  DAMON will execute the action
for each region per sampling interval, like it clears page table accessed
bits and unsets PG_Idle flag for access monitoring.

Also introduce DAMON_PREP_SET_PGIDLE as the initial prep action.  As the
name says, it will do exactly what DAMON was doing as the preparation
action for the access monitoring.

Link: https://lore.kernel.org/20260901132506.99243-6-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   32 ++++++++++++++++++++++++++++++++
 mm/damon/core.c       |   26 ++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

--- a/include/linux/damon.h~mm-damon-core-introduce-damon_prep-struct
+++ a/include/linux/damon.h
@@ -743,6 +743,27 @@ struct damon_intervals_goal {
 };
 
 /**
+ * enum damon_prep_action - DAMON probing preparation action.
+ *
+ * @DAMON_PREP_SET_PGIDLE:	Set the probing memory as idle page.
+ */
+enum damon_prep_action {
+	DAMON_PREP_SET_PGIDLE,
+};
+
+/**
+ * struct damon_prep - DAMON probing preparation request.
+ *
+ * @action:	Action to do to the probing memory for the preparation.
+ */
+struct damon_prep {
+	enum damon_prep_action action;
+/* private: */
+	/* siblings list. */
+	struct list_head list;
+};
+
+/**
  * enum damon_filter_type - Type of &struct damon_filter
  *
  * @DAMON_FILTER_TYPE_ANON:		Anonymous pages.
@@ -783,6 +804,8 @@ struct damon_filter {
 struct damon_probe {
 	unsigned int weight;
 /* private: */
+	/* Preparation actions to apply to each probing memory. */
+	struct list_head preps;
 	/* Filters for assessing if a given region is for this probe. */
 	struct list_head filters;
 	/* Siblings list. */
@@ -962,6 +985,12 @@ static inline unsigned long damon_sz_reg
 	return r->ar.end - r->ar.start;
 }
 
+#define damon_for_each_prep(p, probe) \
+	list_for_each_entry(p, &(probe)->preps, list)
+
+#define damon_for_each_prep_safe(p, next, probe) \
+	list_for_each_entry_safe(p, next, &(probe)->preps, list)
+
 #define damon_for_each_filter(f, p) \
 	list_for_each_entry(f, &(p)->filters, list)
 
@@ -1015,6 +1044,9 @@ static inline unsigned long damon_sz_reg
 
 #ifdef CONFIG_DAMON
 
+struct damon_prep *damon_new_prep(enum damon_prep_action action);
+void damon_add_prep(struct damon_probe *p, struct damon_prep *prep);
+
 struct damon_filter *damon_new_filter(enum damon_filter_type type,
 		bool matching, bool allow);
 void damon_add_filter(struct damon_probe *probe, struct damon_filter *f);
--- a/mm/damon/core.c~mm-damon-core-introduce-damon_prep-struct
+++ a/mm/damon/core.c
@@ -112,6 +112,28 @@ int damon_select_ops(struct damon_ctx *c
 	return err;
 }
 
+struct damon_prep *damon_new_prep(enum damon_prep_action action)
+{
+	struct damon_prep *prep;
+
+	prep = kmalloc_obj(*prep);
+	if (!prep)
+		return NULL;
+	prep->action = action;
+	INIT_LIST_HEAD(&prep->list);
+	return prep;
+}
+
+void damon_add_prep(struct damon_probe *p, struct damon_prep *prep)
+{
+	list_add_tail(&prep->list, &p->preps);
+}
+
+static void damon_free_prep(struct damon_prep *p)
+{
+	kfree(p);
+}
+
 struct damon_filter *damon_new_filter(enum damon_filter_type type,
 		bool matching, bool allow)
 {
@@ -168,6 +190,7 @@ struct damon_probe *damon_new_probe(void
 	if (!p)
 		return NULL;
 	p->weight = 0;
+	INIT_LIST_HEAD(&p->preps);
 	INIT_LIST_HEAD(&p->filters);
 	INIT_LIST_HEAD(&p->list);
 	return p;
@@ -185,8 +208,11 @@ static void damon_del_probe(struct damon
 
 static void damon_free_probe(struct damon_probe *p)
 {
+	struct damon_prep *prep, *prep_next;
 	struct damon_filter *f, *next;
 
+	damon_for_each_prep_safe(prep, prep_next, p)
+		damon_free_prep(prep);
 	damon_for_each_filter_safe(f, next, p)
 		damon_free_filter(f);
 	kfree(p);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-skip-applying-scheme-if-region-split-for-quota-fails.patch
mm-damon-paddr-respect-folio-end-for-damos_stat.patch
mm-damon-paddr-respect-folio-end-for-damos-actions-except-stat.patch
mm-damon-vaddr-respect-folio-end-for-damos_stat.patch
mm-damon-vaddr-respect-folio-end-for-damos_migrate_hotcold.patch
mm-damon-core-handle-extreme-memory-state-in-damon_get_node_mem_bp.patch
mm-damon-core-handle-extreme-memory-state-in-get_node_memcg_used_bp.patch
mm-damon-core-handle-extreme-memory-state-in-get_in_active_mem_bp.patch
mm-damon-core-introduce-damon_filter_type_pgidle_unset.patch
mm-damon-paddr-support-pgidle_unset-probe-filter-type.patch
mm-damon-sysfs-support-pgidle_unset-probe-filter-type.patch
docs-mm-damon-design-document-pgidle_unset-probe-filter-type.patch
mm-damon-core-introduce-damon_prep-struct.patch
mm-damon-core-commit-preps.patch
mm-damon-core-introduce-damon_operations-prep_probes.patch
mm-damon-paddr-support-damon_prep.patch
mm-damon-sysfs-implement-preps-directory.patch
mm-damon-sysfs-implement-preps-nr_preps-file.patch
mm-damon-sysfs-create-directories-for-nr_preps-writes.patch
mm-damon-sysfs-implement-prep_action-file.patch
mm-damon-sysfs-pass-preps-to-damon-core.patch
selftests-damon-sysfssh-test-probe-prep-sysfs-files.patch
docs-mm-damon-design-document-probe-preps.patch
docs-admin-guide-mm-damon-usage-document-probe-preps-sysfs-files.patch
docs-abi-damon-document-probe-prep-sysfs-files.patch

