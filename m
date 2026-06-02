Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8790E3B9DA4
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439086; cv=none; b=rXK/jy+wVPLNAcghV8hStkjR2DyTVuk2k3Ydm5N139DnxNk8Du0AMfX3IdfgFxUr9AJNw0YwpWfcKND8MpXQuYiBFYJw/z2DbxNPMptz2CNS0D3Bly1BsQuF7Nd4HqYrQljDcN3FwzWn2SSBUQwI6FuzeBGgZXkUzGvz605yhVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439086; c=relaxed/simple;
	bh=djyhl3duzhLp6H5kWdSHSFVToMDPzy9YA32eN+PjKRc=;
	h=Date:To:From:Subject:Message-Id; b=dMV3f/17p28upVsXWamLp2RHzfKKZSFwOs3/G+a6u+ePSMC9JUBS0Oud48dg9Vq0ABbLFzRZO84chmm8kGQD+zOquz+jjBFV2MHCODioYoXZTjG/if1MWNsK9S4TN3W2hjHhE75Lu+rx6d/PLuqjaliENVtbNPqeLU/4pYJtJos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LieHDu8l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LieHDu8l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0411F00898;
	Tue,  2 Jun 2026 22:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439085;
	bh=m5uVIBE4per0o+YAGrw5zLFeO9Zj/AKBUAkdAL/L7es=;
	h=Date:To:From:Subject;
	b=LieHDu8lbJyTNJn5ULt2V+oN7TcTIGVt1HatoePDIda8Pqia7vDWwTy8m4jtnIFlY
	 9G9ogM+UGurMaIhS4EH+2gM3DcI9VeTr47Agh9skzAX2+HoaFXUHvpXCPz8DdH2yBL
	 HxJAjErv9FHCcTLuDY+aIfpy8y0OelPQWspEr2ag=
Date: Tue, 02 Jun 2026 15:24:44 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rostedt@goodmis.org,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-embed-damon_probe-objects-in-damon_ctx.patch removed from -mm tree
Message-Id: <20260602222445.5B0411F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: embed damon_probe objects in damon_ctx
has been removed from the -mm tree.  Its filename was
     mm-damon-core-embed-damon_probe-objects-in-damon_ctx.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: embed damon_probe objects in damon_ctx
Date: Mon, 18 May 2026 16:40:50 -0700

Let damon_probe objects be able to be installed on a given damon_ctx, by
adding a linked list header for storing the objects.  Add initialization
and cleanup of the new field with helper functions, too.

Link: https://lore.kernel.org/20260518234119.97569-3-sj@kernel.org
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

 include/linux/damon.h |    9 +++++++++
 mm/damon/core.c       |   38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

--- a/include/linux/damon.h~mm-damon-core-embed-damon_probe-objects-in-damon_ctx
+++ a/include/linux/damon.h
@@ -857,6 +857,7 @@ struct damon_ctx {
 
 /* public: */
 	struct damon_operations ops;
+	struct list_head probes;
 	unsigned long addr_unit;
 	unsigned long min_region_sz;
 	bool pause;
@@ -909,6 +910,11 @@ static inline unsigned long damon_sz_reg
 	return r->ar.end - r->ar.start;
 }
 
+#define damon_for_each_probe(p, ctx) \
+	list_for_each_entry(p, &(ctx)->probes, list)
+
+#define damon_for_each_probe_safe(p, next, ctx) \
+	list_for_each_entry_safe(p, next, &(ctx)->probes, list)
 
 #define damon_for_each_region(r, t) \
 	list_for_each_entry(r, &t->regions_list, list)
@@ -951,6 +957,9 @@ static inline unsigned long damon_sz_reg
 
 #ifdef CONFIG_DAMON
 
+struct damon_probe *damon_new_probe(void);
+void damon_add_probe(struct damon_ctx *ctx, struct damon_probe *probe);
+
 struct damon_region *damon_new_region(unsigned long start, unsigned long end);
 
 /*
--- a/mm/damon/core.c~mm-damon-core-embed-damon_probe-objects-in-damon_ctx
+++ a/mm/damon/core.c
@@ -113,6 +113,38 @@ int damon_select_ops(struct damon_ctx *c
 	return err;
 }
 
+struct damon_probe *damon_new_probe(void)
+{
+	struct damon_probe *p;
+
+	p = kmalloc_obj(*p);
+	if (!p)
+		return NULL;
+	INIT_LIST_HEAD(&p->list);
+	return p;
+}
+
+void damon_add_probe(struct damon_ctx *ctx, struct damon_probe *probe)
+{
+	list_add_tail(&probe->list, &ctx->probes);
+}
+
+static void damon_del_probe(struct damon_probe *p)
+{
+	list_del(&p->list);
+}
+
+static void damon_free_probe(struct damon_probe *p)
+{
+	kfree(p);
+}
+
+static void damon_destroy_probe(struct damon_probe *p)
+{
+	damon_del_probe(p);
+	damon_free_probe(p);
+}
+
 #ifdef CONFIG_DAMON_DEBUG_SANITY
 static void damon_verify_new_region(unsigned long start, unsigned long end)
 {
@@ -605,6 +637,8 @@ struct damon_ctx *damon_new_ctx(void)
 	ctx->attrs.min_nr_regions = 10;
 	ctx->attrs.max_nr_regions = 1000;
 
+	INIT_LIST_HEAD(&ctx->probes);
+
 	ctx->addr_unit = 1;
 	ctx->min_region_sz = DAMON_MIN_REGION_SZ;
 
@@ -627,12 +661,16 @@ static void damon_destroy_targets(struct
 void damon_destroy_ctx(struct damon_ctx *ctx)
 {
 	struct damos *s, *next_s;
+	struct damon_probe *p, *next_p;
 
 	damon_destroy_targets(ctx);
 
 	damon_for_each_scheme_safe(s, next_s, ctx)
 		damon_destroy_scheme(s);
 
+	damon_for_each_probe_safe(p, next_p, ctx)
+		damon_destroy_probe(p);
+
 	kfree(ctx);
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
maintainers-add-testing-abi-documents-for-mm.patch

