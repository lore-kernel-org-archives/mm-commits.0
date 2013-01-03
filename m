From: akpm@linux-foundation.org
Subject: + lib-cpu_rmap-avoid-flushing-all-workqueues.patch added to -mm tree
Date: Thu, 03 Jan 2013 13:48:02 -0800
Message-ID: <20130103214803.5F8E0820050@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:58960 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737Ab3ACVsF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jan 2013 16:48:05 -0500
Received: by mail-qa0-f74.google.com with SMTP id r4so1706873qaq.1
        for <mm-commits@vger.kernel.org>; Thu, 03 Jan 2013 13:48:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: decot@googlers.com, amirv@mellanox.com, bhutchings@solarflare.com, davem@davemloft.net, edumazet@google.com, josh@joshtriplett.org, ogerlitz@mellanox.com


The patch titled
     Subject: lib: cpu_rmap: avoid flushing all workqueues
has been added to the -mm tree.  Its filename is
     lib-cpu_rmap-avoid-flushing-all-workqueues.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Decotigny <decot@googlers.com>
Subject: lib: cpu_rmap: avoid flushing all workqueues

In some cases, free_irq_cpu_rmap() is called while holding a lock (eg. 
rtnl).  This can lead to deadlocks, because it invokes
flush_scheduled_work() which ends up waiting for whole system workqueue to
flush, but some pending works might try to acquire the lock we are already
holding.

This commit uses reference-counting to replace
irq_run_affinity_notifiers().  It also removes
irq_run_affinity_notifiers() altogether.

Signed-off-by: David Decotigny <decot@googlers.com>
Reviewed-by: Ben Hutchings <bhutchings@solarflare.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Amir Vadai <amirv@mellanox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpu_rmap.h  |   13 ++-----
 include/linux/interrupt.h |    5 --
 lib/cpu_rmap.c            |   63 +++++++++++++++++++++++++++++++++---
 3 files changed, 62 insertions(+), 19 deletions(-)

diff -puN include/linux/cpu_rmap.h~lib-cpu_rmap-avoid-flushing-all-workqueues include/linux/cpu_rmap.h
--- a/include/linux/cpu_rmap.h~lib-cpu_rmap-avoid-flushing-all-workqueues
+++ a/include/linux/cpu_rmap.h
@@ -13,9 +13,11 @@
 #include <linux/cpumask.h>
 #include <linux/gfp.h>
 #include <linux/slab.h>
+#include <linux/kref.h>
 
 /**
  * struct cpu_rmap - CPU affinity reverse-map
+ * @refcount: kref for object
  * @size: Number of objects to be reverse-mapped
  * @used: Number of objects added
  * @obj: Pointer to array of object pointers
@@ -23,6 +25,7 @@
  *      based on affinity masks
  */
 struct cpu_rmap {
+	struct kref	refcount;
 	u16		size, used;
 	void		**obj;
 	struct {
@@ -33,15 +36,7 @@ struct cpu_rmap {
 #define CPU_RMAP_DIST_INF 0xffff
 
 extern struct cpu_rmap *alloc_cpu_rmap(unsigned int size, gfp_t flags);
-
-/**
- * free_cpu_rmap - free CPU affinity reverse-map
- * @rmap: Reverse-map allocated with alloc_cpu_rmap(), or %NULL
- */
-static inline void free_cpu_rmap(struct cpu_rmap *rmap)
-{
-	kfree(rmap);
-}
+extern void free_cpu_rmap(struct cpu_rmap *rmap);
 
 extern int cpu_rmap_add(struct cpu_rmap *rmap, void *obj);
 extern int cpu_rmap_update(struct cpu_rmap *rmap, u16 index,
diff -puN include/linux/interrupt.h~lib-cpu_rmap-avoid-flushing-all-workqueues include/linux/interrupt.h
--- a/include/linux/interrupt.h~lib-cpu_rmap-avoid-flushing-all-workqueues
+++ a/include/linux/interrupt.h
@@ -268,11 +268,6 @@ struct irq_affinity_notify {
 extern int
 irq_set_affinity_notifier(unsigned int irq, struct irq_affinity_notify *notify);
 
-static inline void irq_run_affinity_notifiers(void)
-{
-	flush_scheduled_work();
-}
-
 #else /* CONFIG_SMP */
 
 static inline int irq_set_affinity(unsigned int irq, const struct cpumask *m)
diff -puN lib/cpu_rmap.c~lib-cpu_rmap-avoid-flushing-all-workqueues lib/cpu_rmap.c
--- a/lib/cpu_rmap.c~lib-cpu_rmap-avoid-flushing-all-workqueues
+++ a/lib/cpu_rmap.c
@@ -45,6 +45,7 @@ struct cpu_rmap *alloc_cpu_rmap(unsigned
 	if (!rmap)
 		return NULL;
 
+	kref_init(&rmap->refcount);
 	rmap->obj = (void **)((char *)rmap + obj_offset);
 
 	/* Initially assign CPUs to objects on a rota, since we have
@@ -63,6 +64,44 @@ struct cpu_rmap *alloc_cpu_rmap(unsigned
 }
 EXPORT_SYMBOL(alloc_cpu_rmap);
 
+/**
+ * cpu_rmap_reclaim - internal reclaiming helper called from kref_put
+ * @ref: kref to struct cpu_rmap
+ */
+static void cpu_rmap_reclaim(struct kref *ref)
+{
+	struct cpu_rmap *rmap = container_of(ref, struct cpu_rmap, refcount);
+	kfree(rmap);
+}
+
+/**
+ * cpu_rmap_get - internal helper to get new ref on a cpu_rmap
+ * @rmap: reverse-map allocated with alloc_cpu_rmap()
+ */
+static inline void cpu_rmap_get(struct cpu_rmap *rmap)
+{
+	kref_get(&rmap->refcount);
+}
+
+/**
+ * cpu_rmap_put - internal helper to release ref on a cpu_rmap
+ * @rmap: reverse-map allocated with alloc_cpu_rmap()
+ */
+static inline void cpu_rmap_put(struct cpu_rmap *rmap)
+{
+	kref_put(&rmap->refcount, cpu_rmap_reclaim);
+}
+
+/**
+ * free_cpu_rmap - free CPU affinity reverse-map
+ * @rmap: Reverse-map allocated with alloc_cpu_rmap()
+ */
+void free_cpu_rmap(struct cpu_rmap *rmap)
+{
+	cpu_rmap_put(rmap);
+}
+EXPORT_SYMBOL(free_cpu_rmap);
+
 /* Reevaluate nearest object for given CPU, comparing with the given
  * neighbours at the given distance.
  */
@@ -197,8 +236,7 @@ struct irq_glue {
  * free_irq_cpu_rmap - free a CPU affinity reverse-map used for IRQs
  * @rmap: Reverse-map allocated with alloc_irq_cpu_map(), or %NULL
  *
- * Must be called in process context, before freeing the IRQs, and
- * without holding any locks required by global workqueue items.
+ * Must be called in process context, before freeing the IRQs.
  */
 void free_irq_cpu_rmap(struct cpu_rmap *rmap)
 {
@@ -212,12 +250,18 @@ void free_irq_cpu_rmap(struct cpu_rmap *
 		glue = rmap->obj[index];
 		irq_set_affinity_notifier(glue->notify.irq, NULL);
 	}
-	irq_run_affinity_notifiers();
 
-	kfree(rmap);
+	cpu_rmap_put(rmap);
 }
 EXPORT_SYMBOL(free_irq_cpu_rmap);
 
+/**
+ * irq_cpu_rmap_notify - callback for IRQ subsystem when IRQ affinity updated
+ * @notify: struct irq_affinity_notify passed by irq/manage.c
+ * @mask: cpu mask for new SMP affinity
+ *
+ * This is executed in workqueue context.
+ */
 static void
 irq_cpu_rmap_notify(struct irq_affinity_notify *notify, const cpumask_t *mask)
 {
@@ -230,10 +274,16 @@ irq_cpu_rmap_notify(struct irq_affinity_
 		pr_warning("irq_cpu_rmap_notify: update failed: %d\n", rc);
 }
 
+/**
+ * irq_cpu_rmap_release - reclaiming callback for IRQ subsystem
+ * @ref: kref to struct irq_affinity_notify passed by irq/manage.c
+ */
 static void irq_cpu_rmap_release(struct kref *ref)
 {
 	struct irq_glue *glue =
 		container_of(ref, struct irq_glue, notify.kref);
+
+	cpu_rmap_put(glue->rmap);
 	kfree(glue);
 }
 
@@ -258,10 +308,13 @@ int irq_cpu_rmap_add(struct cpu_rmap *rm
 	glue->notify.notify = irq_cpu_rmap_notify;
 	glue->notify.release = irq_cpu_rmap_release;
 	glue->rmap = rmap;
+	cpu_rmap_get(rmap);
 	glue->index = cpu_rmap_add(rmap, glue);
 	rc = irq_set_affinity_notifier(irq, &glue->notify);
-	if (rc)
+	if (rc) {
+		cpu_rmap_put(glue->rmap);
 		kfree(glue);
+	}
 	return rc;
 }
 EXPORT_SYMBOL(irq_cpu_rmap_add);
_

Patches currently in -mm which might be from decot@googlers.com are

lib-cpu_rmap-avoid-flushing-all-workqueues.patch
lib-cpu_rmap-avoid-flushing-all-workqueues-fix.patch

