From: akpm@linux-foundation.org
Subject: - idr-introduce-the-ridr-structure.patch removed from -mm tree
Date: Mon, 05 May 2008 09:28:37 -0700
Message-ID: <200805051628.m45GSb9s025483@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42590 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753951AbYEEQaQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2008 12:30:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Nadia.Derbey@bull.net, jim.houston@comcast.net, manfred@colorfullife.com, nickpiggin@yahoo.com.au, paulmck@us.ibm.com, peifferp@gmail.com, mm-commits@vger.kernel.org


The patch titled
     idr: introduce the ridr structure
has been removed from the -mm tree.  Its filename was
     idr-introduce-the-ridr-structure.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: idr: introduce the ridr structure
From: Nadia Derbey <Nadia.Derbey@bull.net>

Introduce the ridr structure as an RCU safe idr structure: a layer is actually
made of the existing idr layer, followed by the rcu head.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Jim Houston <jim.houston@comcast.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Pierre Peiffer <peifferp@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/idr.h  |    6 ++--
 include/linux/ridr.h |   50 +++++++++++++++++++++++++++++++++++++++++
 init/main.c          |    2 +
 lib/Makefile         |    2 -
 lib/idr.c            |    2 -
 lib/ridr.c           |   26 +++++++++++++++++++++
 6 files changed, 83 insertions(+), 5 deletions(-)

diff -puN include/linux/idr.h~idr-introduce-the-ridr-structure include/linux/idr.h
--- a/include/linux/idr.h~idr-introduce-the-ridr-structure
+++ a/include/linux/idr.h
@@ -49,9 +49,9 @@
 #define IDR_FREE_MAX MAX_LEVEL + MAX_LEVEL
 
 struct idr_layer {
-	unsigned long		 bitmap; /* A zero bit means "space here" */
-	struct idr_layer	*ary[1<<IDR_BITS];
-	int			 count;	 /* When zero, we can release it */
+	unsigned long	 bitmap; /* A zero bit means "space here" */
+	void		*ary[1<<IDR_BITS];
+	int		 count;	 /* When zero, we can release it */
 };
 
 struct idr {
diff -puN /dev/null include/linux/ridr.h
--- /dev/null
+++ a/include/linux/ridr.h
@@ -0,0 +1,50 @@
+/*
+ * include/linux/ridr.h
+ *
+ * Small id to pointer translation service avoiding fixed sized
+ * tables. RCU-based implmentation of IDRs.
+ */
+
+#ifndef _RIDR_H_
+#define _RIDR_H_
+
+#include <linux/idr.h>
+#include <linux/rcupdate.h>
+
+/*
+ * The idr_layer part should stay at the beginning of the structure
+ */
+struct ridr_layer {
+	struct idr_layer idr;
+	struct rcu_head	 rcu_head;
+};
+
+struct ridr {
+	struct ridr_layer *top;
+	struct ridr_layer *id_free;
+	int		  layers;
+	int		  id_free_cnt;
+	spinlock_t	  lock;
+};
+
+#define RIDR_INIT(name)						\
+{								\
+	.top		= NULL,					\
+	.id_free	= NULL,					\
+	.layers 	= 0,					\
+	.id_free_cnt	= 0,					\
+	.lock		= __SPIN_LOCK_UNLOCKED(name.lock),	\
+}
+#define DEFINE_RIDR(name)	struct ridr name = RIDR_INIT(name)
+
+#define idr_to_ridr(p) container_of((p), struct ridr_layer, idr)
+#define ridr_to_idr(p) (&((p)->idr))
+
+/*
+ * This is what we export.
+ */
+
+
+void __init ridr_init_cache(void);
+
+#endif /* _RIDR_H_ */
diff -puN init/main.c~idr-introduce-the-ridr-structure init/main.c
--- a/init/main.c~idr-introduce-the-ridr-structure
+++ a/init/main.c
@@ -61,6 +61,7 @@
 #include <linux/sched.h>
 #include <linux/signal.h>
 #include <linux/idr.h>
+#include <linux/ridr.h>
 #include <linux/kmemcheck.h>
 #include <linux/immediate.h>
 
@@ -657,6 +658,7 @@ asmlinkage void __init start_kernel(void
 	kmem_cache_init();
 	debug_objects_mem_init();
 	idr_init_cache();
+	ridr_init_cache();
 	setup_per_cpu_pageset();
 	numa_policy_init();
 	if (late_time_init)
diff -puN lib/Makefile~idr-introduce-the-ridr-structure lib/Makefile
--- a/lib/Makefile~idr-introduce-the-ridr-structure
+++ a/lib/Makefile
@@ -6,7 +6,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
 	 rbtree.o radix-tree.o dump_stack.o \
 	 idr.o int_sqrt.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
-	 proportions.o prio_heap.o ratelimit.o
+	 proportions.o prio_heap.o ratelimit.o ridr.o
 
 ifdef CONFIG_FTRACE
 # Do not profile string.o, since it may be used in early boot or vdso
diff -puN lib/idr.c~idr-introduce-the-ridr-structure lib/idr.c
--- a/lib/idr.c~idr-introduce-the-ridr-structure
+++ a/lib/idr.c
@@ -342,7 +342,7 @@ static void sub_remove(struct idr *idp, 
 	while ((shift > 0) && p) {
 		n = (id >> shift) & IDR_MASK;
 		__clear_bit(n, &p->bitmap);
-		*++paa = &p->ary[n];
+		*++paa = (struct idr_layer **) &p->ary[n];
 		p = p->ary[n];
 		shift -= IDR_BITS;
 	}
diff -puN /dev/null lib/ridr.c
--- /dev/null
+++ a/lib/ridr.c
@@ -0,0 +1,26 @@
+/*
+ * RCU-based idr API
+ */
+
+
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/ridr.h>
+
+static struct kmem_cache *ridr_layer_cache;
+
+
+static void ridr_cache_ctor(struct kmem_cache *ridr_layer_cache,
+			void *ridr_layer)
+{
+	memset(ridr_layer, 0, sizeof(struct ridr_layer));
+}
+
+void __init ridr_init_cache(void)
+{
+	ridr_layer_cache = kmem_cache_create("ridr_layer_cache",
+				sizeof(struct ridr_layer), 0, SLAB_PANIC,
+				ridr_cache_ctor);
+}
+
_

Patches currently in -mm which might be from Nadia.Derbey@bull.net are

origin.patch
idr-introduce-the-ridr-structure.patch
idr-introduce-ridr_pre_get.patch
idr-introduce-ridr_init.patch
idr-introduce-ridr_get_new_above.patch
idr-introduce-ridr_get_new.patch
idr-introduce-ridr_find.patch
idr-introduce-ridr_remove.patch
ipc-integrate-the-ridr-code-into-ipc-code.patch
ipc-get-rid-of-ipc_lock_down.patch

