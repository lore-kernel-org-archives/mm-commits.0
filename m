Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3AC3C5850
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439088; cv=none; b=pL4KGlJ8p/Av3REvdQYkKbbKU1kB/LbvdF0Rhz/zDFKl48rL7GzygNZOM8bcCaj+GhfztT7BYbP3+PJE93dwgJT4yfxjZPMFa2WuxKcglCWohQmt2CqAGtlwJiLYmz8B/kabxuz+KTUjROYMG6L9MLnfsjEsFUrvx2oDyOgm+bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439088; c=relaxed/simple;
	bh=nYWG1mgtY07/XTMMgj+krn6eyA5MSU/XR8seDRkqu00=;
	h=Date:To:From:Subject:Message-Id; b=oSvaY8IrdUYtLaLGqrpgxTSfXsF6QkanH/oEff5IRtjSNnK6ix6ntEDsCGag8i587D/oZrSTIu3q9Bn6Ky32PoSSooovcXBJb9bR6qJh/5B0TONUJGMj8fg2I6/q22Z6kFDtBtwS1dk64c+pNboOYunQwEW6HNHW8Z30s1HQT2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AUSqWDKA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AUSqWDKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8B21F0089E;
	Tue,  2 Jun 2026 22:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439086;
	bh=WVGOW9pe8TwuAPMmJYoCpFhF1aQ7x1hRC2j//W2YXZE=;
	h=Date:To:From:Subject;
	b=AUSqWDKAzWxHa0pMTTOogNN5/pwppYHFAYl5ceKU5nMHU1SSOAfquGKVSMh9zPsLl
	 X+WrRapg+mVh0VzL+CHAHvU+YiGpbqOyCMiuZm3ivP2FwO7BFseJAzuUtHXYp4j7fN
	 S4owT6j6546oJA2KHtmEstyKkcWyKOg32BBN0faA=
Date: Tue, 02 Jun 2026 15:24:46 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rostedt@goodmis.org,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-introduce-damon_filter.patch removed from -mm tree
Message-Id: <20260602222446.9B8B21F0089E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: introduce damon_filter
has been removed from the -mm tree.  Its filename was
     mm-damon-core-introduce-damon_filter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: introduce damon_filter
Date: Mon, 18 May 2026 16:40:51 -0700

Define a data structure for constructing damon_probe's attributes check,
namely damon_filter.  It is very similar to damos_filter but works only
for monitoring purposes.  Also embed that into damon_probe, implement
essential handling of the link, with fundamental helpers.

Link: https://lore.kernel.org/20260518234119.97569-4-sj@kernel.org
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

 include/linux/damon.h |   36 ++++++++++++++++++++++++++++++++++++
 mm/damon/core.c       |   30 ++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+)

--- a/include/linux/damon.h~mm-damon-core-introduce-damon_filter
+++ a/include/linux/damon.h
@@ -731,11 +731,37 @@ struct damon_intervals_goal {
 };
 
 /**
+ * enum damon_filter_type - Type of &struct damon_filter
+ *
+ * @DAMON_FILTER_TYPE_ANON:	Anonymous pages.
+ */
+enum damon_filter_type {
+	DAMON_FILTER_TYPE_ANON,
+};
+
+/**
+ * struct damon_filter - DAMON region filter for &struct damon_probe.
+ *
+ * @type:	Type of the region.
+ * @matching:	Whether this filter is for the type-matching ones.
+ * @allow:	Whether the @type-@matching ones should pass this filter.
+ * @list:	Siblings list.
+ */
+struct damon_filter {
+	enum damon_filter_type type;
+	bool matching;
+	bool allow;
+	struct list_head list;
+};
+
+/**
  * struct damon_probe - Data region attribute probe.
  *
+ * @filters:	Filters for assessing if a given region is for this probe.
  * @list:	Siblings list.
  */
 struct damon_probe {
+	struct list_head filters;
 	struct list_head list;
 };
 
@@ -910,6 +936,12 @@ static inline unsigned long damon_sz_reg
 	return r->ar.end - r->ar.start;
 }
 
+#define damon_for_each_filter(f, p) \
+	list_for_each_entry(f, &(p)->filters, list)
+
+#define damon_for_each_filter_safe(f, next, p) \
+	list_for_each_entry_safe(f, next, &(p)->filters, list)
+
 #define damon_for_each_probe(p, ctx) \
 	list_for_each_entry(p, &(ctx)->probes, list)
 
@@ -957,6 +989,10 @@ static inline unsigned long damon_sz_reg
 
 #ifdef CONFIG_DAMON
 
+struct damon_filter *damon_new_filter(enum damon_filter_type type,
+		bool matching, bool allow);
+void damon_add_filter(struct damon_probe *probe, struct damon_filter *f);
+
 struct damon_probe *damon_new_probe(void);
 void damon_add_probe(struct damon_ctx *ctx, struct damon_probe *probe);
 
--- a/mm/damon/core.c~mm-damon-core-introduce-damon_filter
+++ a/mm/damon/core.c
@@ -113,6 +113,31 @@ int damon_select_ops(struct damon_ctx *c
 	return err;
 }
 
+struct damon_filter *damon_new_filter(enum damon_filter_type type,
+		bool matching, bool allow)
+{
+	struct damon_filter *filter;
+
+	filter = kmalloc_obj(*filter);
+	if (!filter)
+		return NULL;
+	filter->type = type;
+	filter->matching = matching;
+	filter->allow = allow;
+	INIT_LIST_HEAD(&filter->list);
+	return filter;
+}
+
+void damon_add_filter(struct damon_probe *p, struct damon_filter *f)
+{
+	list_add_tail(&f->list, &p->filters);
+}
+
+static void damon_free_filter(struct damon_filter *f)
+{
+	kfree(f);
+}
+
 struct damon_probe *damon_new_probe(void)
 {
 	struct damon_probe *p;
@@ -120,6 +145,7 @@ struct damon_probe *damon_new_probe(void
 	p = kmalloc_obj(*p);
 	if (!p)
 		return NULL;
+	INIT_LIST_HEAD(&p->filters);
 	INIT_LIST_HEAD(&p->list);
 	return p;
 }
@@ -136,6 +162,10 @@ static void damon_del_probe(struct damon
 
 static void damon_free_probe(struct damon_probe *p)
 {
+	struct damon_filter *f, *next;
+
+	damon_for_each_filter_safe(f, next, p)
+		damon_free_filter(f);
 	kfree(p);
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
maintainers-add-testing-abi-documents-for-mm.patch

