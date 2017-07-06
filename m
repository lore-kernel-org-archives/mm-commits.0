From: akpm@linux-foundation.org
Subject: [patch 023/108] mm/slub.c: wrap cpu_slab->partial in
 CONFIG_SLUB_CPU_PARTIAL
Date: Thu, 06 Jul 2017 15:36:31 -0700
Message-ID: <20170706223631.FCwN148sB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34790 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752733AbdGFWgc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:36:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org, penberg@kernel.org, richard.weiyang@gmail.com, rientjes@google.com, torvalds@linux-foundation.org

From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/slub.c: wrap cpu_slab->partial in CONFIG_SLUB_CPU_PARTIAL

cpu_slab's field partial is used when CONFIG_SLUB_CPU_PARTIAL is set,
which means we can save a pointer's space on each cpu for every slub item.

This patch wraps cpu_slab->partial in CONFIG_SLUB_CPU_PARTIAL and wraps
its sysfs use too.

[akpm@linux-foundation.org: avoid strange 80-col tricks]
Link: http://lkml.kernel.org/r/20170502144533.10729-3-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |   19 +++++++++++++++++++
 mm/slub.c                |   18 +++++++++++-------
 2 files changed, 30 insertions(+), 7 deletions(-)

diff -puN include/linux/slub_def.h~mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial include/linux/slub_def.h
--- a/include/linux/slub_def.h~mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial
+++ a/include/linux/slub_def.h
@@ -41,12 +41,31 @@ struct kmem_cache_cpu {
 	void **freelist;	/* Pointer to next available object */
 	unsigned long tid;	/* Globally unique transaction id */
 	struct page *page;	/* The slab from which we are allocating */
+#ifdef CONFIG_SLUB_CPU_PARTIAL
 	struct page *partial;	/* Partially allocated frozen slabs */
+#endif
 #ifdef CONFIG_SLUB_STATS
 	unsigned stat[NR_SLUB_STAT_ITEMS];
 #endif
 };
 
+#ifdef CONFIG_SLUB_CPU_PARTIAL
+#define slub_percpu_partial(c)		((c)->partial)
+
+#define slub_set_percpu_partial(c, p)		\
+({						\
+	slub_percpu_partial(c) = (p)->next;	\
+})
+
+#define slub_percpu_partial_read_once(c)     READ_ONCE(slub_percpu_partial(c))
+#else
+#define slub_percpu_partial(c)			NULL
+
+#define slub_set_percpu_partial(c, p)
+
+#define slub_percpu_partial_read_once(c)	NULL
+#endif // CONFIG_SLUB_CPU_PARTIAL
+
 /*
  * Word size structure that can be atomically updated or read and that
  * contains both the order and the number of objects that a slab of the
diff -puN mm/slub.c~mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial mm/slub.c
--- a/mm/slub.c~mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial
+++ a/mm/slub.c
@@ -2303,7 +2303,7 @@ static bool has_cpu_slab(int cpu, void *
 	struct kmem_cache *s = info;
 	struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab, cpu);
 
-	return c->page || c->partial;
+	return c->page || slub_percpu_partial(c);
 }
 
 static void flush_all(struct kmem_cache *s)
@@ -2565,9 +2565,9 @@ load_freelist:
 
 new_slab:
 
-	if (c->partial) {
-		page = c->page = c->partial;
-		c->partial = page->next;
+	if (slub_percpu_partial(c)) {
+		page = c->page = slub_percpu_partial(c);
+		slub_set_percpu_partial(c, page);
 		stat(s, CPU_PARTIAL_ALLOC);
 		goto redo;
 	}
@@ -4754,7 +4754,7 @@ static ssize_t show_slab_objects(struct
 			total += x;
 			nodes[node] += x;
 
-			page = READ_ONCE(c->partial);
+			page = slub_percpu_partial_read_once(c);
 			if (page) {
 				node = page_to_nid(page);
 				if (flags & SO_TOTAL)
@@ -4982,7 +4982,9 @@ static ssize_t slabs_cpu_partial_show(st
 	int len;
 
 	for_each_online_cpu(cpu) {
-		struct page *page = per_cpu_ptr(s->cpu_slab, cpu)->partial;
+		struct page *page;
+
+		page = slub_percpu_partial(per_cpu_ptr(s->cpu_slab, cpu));
 
 		if (page) {
 			pages += page->pages;
@@ -4994,7 +4996,9 @@ static ssize_t slabs_cpu_partial_show(st
 
 #ifdef CONFIG_SMP
 	for_each_online_cpu(cpu) {
-		struct page *page = per_cpu_ptr(s->cpu_slab, cpu) ->partial;
+		struct page *page;
+
+		page = slub_percpu_partial(per_cpu_ptr(s->cpu_slab, cpu));
 
 		if (page && len < PAGE_SIZE - 20)
 			len += sprintf(buf + len, " C%d=%d(%d)", cpu,
_
