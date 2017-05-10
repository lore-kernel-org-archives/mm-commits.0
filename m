From: akpm@linux-foundation.org
Subject: + mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial.patch
 added to -mm tree
Date: Wed, 10 May 2017 15:16:42 -0700
Message-ID: <5913914a.mlFLWpDMM34G61fj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40594 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751829AbdEJWQn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 10 May 2017 18:16:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard.weiyang@gmail.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub.c: wrap cpu_slab->partial in CONFIG_SLUB_CPU_PARTIAL
has been added to the -mm tree.  Its filename is
     mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/slub.c: wrap cpu_slab->partial in CONFIG_SLUB_CPU_PARTIAL

cpu_slab's field partial is used when CONFIG_SLUB_CPU_PARTIAL is set,
which means we can save a pointer's space on each cpu for every slub item.

This patch wraps cpu_slab->partial in CONFIG_SLUB_CPU_PARTIAL and wraps
its sysfs use too.

Link: http://lkml.kernel.org/r/20170502144533.10729-3-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |   19 +++++++++++++++++++
 mm/slub.c                |   16 +++++++++-------
 2 files changed, 28 insertions(+), 7 deletions(-)

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
@@ -4982,7 +4982,8 @@ static ssize_t slabs_cpu_partial_show(st
 	int len;
 
 	for_each_online_cpu(cpu) {
-		struct page *page = per_cpu_ptr(s->cpu_slab, cpu)->partial;
+		struct page *page =
+			slub_percpu_partial(per_cpu_ptr(s->cpu_slab, cpu));
 
 		if (page) {
 			pages += page->pages;
@@ -4994,7 +4995,8 @@ static ssize_t slabs_cpu_partial_show(st
 
 #ifdef CONFIG_SMP
 	for_each_online_cpu(cpu) {
-		struct page *page = per_cpu_ptr(s->cpu_slab, cpu) ->partial;
+		struct page *page =
+			slub_percpu_partial(per_cpu_ptr(s->cpu_slab, cpu));
 
 		if (page && len < PAGE_SIZE - 20)
 			len += sprintf(buf + len, " C%d=%d(%d)", cpu,
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-slub-remove-a-redundant-assignment-in-___slab_alloc.patch
mm-slub-reset-cpu_slabs-pointer-in-deactivate_slab.patch
mm-slub-pack-red_left_pad-with-another-int-to-save-a-word.patch
mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial.patch
mm-slub-wrap-kmem_cache-cpu_partial-in-config-config_slub_cpu_partial.patch
mm-page_alloc-return-0-in-case-this-node-has-no-page-within-the-zone.patch

