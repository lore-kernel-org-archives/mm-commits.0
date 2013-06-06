From: akpm@linux-foundation.org
Subject: [to-be-updated] list-add-a-new-lru-list-type.patch removed from
 -mm tree
Date: Thu, 06 Jun 2013 12:34:35 -0700
Message-ID: <51b0e44b.Vr4AUNcmNgyPkt3M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51931 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab3FFTeg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jun 2013 15:34:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, glommer@openvz.org, dchinner@redhat.com

Subject: [to-be-updated] list-add-a-new-lru-list-type.patch removed from -mm tree
To: dchinner@redhat.com,glommer@openvz.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 06 Jun 2013 12:34:35 -0700


The patch titled
     Subject: list: add a new LRU list type
has been removed from the -mm tree.  Its filename was
     list-add-a-new-lru-list-type.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Dave Chinner <dchinner@redhat.com>
Subject: list: add a new LRU list type

Several subsystems use the same construct for LRU lists - a list head, a
spin lock and and item count.  They also use exactly the same code for
adding and removing items from the LRU.  Create a generic type for these
LRU lists.

This is the beginning of generic, node aware LRUs for shrinkers to
work with.

[glommer@openvz.org: enum defined constants for lru. Suggested by gthelen, don't relock over retry]
Cc: Glauber Costa <glommer@openvz.org>
Cc: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list_lru.h |   46 +++++++++++++
 lib/Makefile             |    2 
 lib/list_lru.c           |  122 +++++++++++++++++++++++++++++++++++++
 3 files changed, 169 insertions(+), 1 deletion(-)

diff -puN /dev/null include/linux/list_lru.h
--- /dev/null
+++ a/include/linux/list_lru.h
@@ -0,0 +1,46 @@
+/*
+ * Copyright (c) 2010-2012 Red Hat, Inc. All rights reserved.
+ * Author: David Chinner
+ *
+ * Generic LRU infrastructure
+ */
+#ifndef _LRU_LIST_H
+#define _LRU_LIST_H
+
+#include <linux/list.h>
+
+enum lru_status {
+	LRU_REMOVED,		/* item removed from list */
+	LRU_ROTATE,		/* item referenced, give another pass */
+	LRU_SKIP,		/* item cannot be locked, skip */
+	LRU_RETRY,		/* item not freeable. May drop the lock
+				   internally, but has to return locked. */
+};
+
+struct list_lru {
+	spinlock_t		lock;
+	struct list_head	list;
+	long			nr_items;
+};
+
+int list_lru_init(struct list_lru *lru);
+int list_lru_add(struct list_lru *lru, struct list_head *item);
+int list_lru_del(struct list_lru *lru, struct list_head *item);
+
+static inline unsigned long list_lru_count(struct list_lru *lru)
+{
+	return lru->nr_items;
+}
+
+typedef enum lru_status
+(*list_lru_walk_cb)(struct list_head *item, spinlock_t *lock, void *cb_arg);
+
+typedef void (*list_lru_dispose_cb)(struct list_head *dispose_list);
+
+unsigned long list_lru_walk(struct list_lru *lru, list_lru_walk_cb isolate,
+		   void *cb_arg, unsigned long nr_to_walk);
+
+unsigned long
+list_lru_dispose_all(struct list_lru *lru, list_lru_dispose_cb dispose);
+
+#endif /* _LRU_LIST_H */
diff -puN lib/Makefile~list-add-a-new-lru-list-type lib/Makefile
--- a/lib/Makefile~list-add-a-new-lru-list-type
+++ a/lib/Makefile
@@ -13,7 +13,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
 	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o flex_proportions.o prio_heap.o ratelimit.o show_mem.o \
 	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
-	 earlycpio.o percpu-refcount.o
+	 earlycpio.o percpu-refcount.o list_lru.o
 
 obj-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
 lib-$(CONFIG_MMU) += ioremap.o
diff -puN /dev/null lib/list_lru.c
--- /dev/null
+++ a/lib/list_lru.c
@@ -0,0 +1,122 @@
+/*
+ * Copyright (c) 2010-2012 Red Hat, Inc. All rights reserved.
+ * Author: David Chinner
+ *
+ * Generic LRU infrastructure
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/list_lru.h>
+
+int
+list_lru_add(
+	struct list_lru	*lru,
+	struct list_head *item)
+{
+	spin_lock(&lru->lock);
+	if (list_empty(item)) {
+		list_add_tail(item, &lru->list);
+		lru->nr_items++;
+		spin_unlock(&lru->lock);
+		return 1;
+	}
+	spin_unlock(&lru->lock);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(list_lru_add);
+
+int
+list_lru_del(
+	struct list_lru	*lru,
+	struct list_head *item)
+{
+	spin_lock(&lru->lock);
+	if (!list_empty(item)) {
+		list_del_init(item);
+		lru->nr_items--;
+		spin_unlock(&lru->lock);
+		return 1;
+	}
+	spin_unlock(&lru->lock);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(list_lru_del);
+
+unsigned long
+list_lru_walk(
+	struct list_lru *lru,
+	list_lru_walk_cb isolate,
+	void		*cb_arg,
+	unsigned long	nr_to_walk)
+{
+	struct list_head *item, *n;
+	unsigned long removed = 0;
+
+	spin_lock(&lru->lock);
+	list_for_each_safe(item, n, &lru->list) {
+		enum lru_status ret;
+		bool first_pass = true;
+restart:
+		ret = isolate(item, &lru->lock, cb_arg);
+		switch (ret) {
+		case LRU_REMOVED:
+			lru->nr_items--;
+			removed++;
+			break;
+		case LRU_ROTATE:
+			list_move_tail(item, &lru->list);
+			break;
+		case LRU_SKIP:
+			break;
+		case LRU_RETRY:
+			if (!first_pass)
+				break;
+			first_pass = false;
+			goto restart;
+		default:
+			BUG();
+		}
+
+		if (nr_to_walk-- == 0)
+			break;
+
+	}
+	spin_unlock(&lru->lock);
+	return removed;
+}
+EXPORT_SYMBOL_GPL(list_lru_walk);
+
+unsigned long
+list_lru_dispose_all(
+	struct list_lru *lru,
+	list_lru_dispose_cb dispose)
+{
+	unsigned long disposed = 0;
+	LIST_HEAD(dispose_list);
+
+	spin_lock(&lru->lock);
+	while (!list_empty(&lru->list)) {
+		list_splice_init(&lru->list, &dispose_list);
+		disposed += lru->nr_items;
+		lru->nr_items = 0;
+		spin_unlock(&lru->lock);
+
+		dispose(&dispose_list);
+
+		spin_lock(&lru->lock);
+	}
+	spin_unlock(&lru->lock);
+	return disposed;
+}
+
+int
+list_lru_init(
+	struct list_lru	*lru)
+{
+	spin_lock_init(&lru->lock);
+	INIT_LIST_HEAD(&lru->list);
+	lru->nr_items = 0;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(list_lru_init);
_

Patches currently in -mm which might be from dchinner@redhat.com are

linux-next.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
dcache-convert-to-use-new-lru-list-infrastructure.patch
list_lru-per-node-list-infrastructure.patch
shrinker-add-node-awareness.patch
vmscan-per-node-deferred-work.patch
list_lru-per-node-api.patch
fs-convert-inode-and-dentry-shrinking-to-be-node-aware.patch
xfs-convert-buftarg-lru-to-generic-code.patch
xfs-rework-buffer-dispose-list-tracking.patch
xfs-convert-dquot-cache-lru-to-list_lru.patch
fs-convert-fs-shrinkers-to-new-scan-count-api.patch
drivers-convert-shrinkers-to-new-count-scan-api.patch
i915-bail-out-earlier-when-shrinker-cannot-acquire-mutex.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api.patch
shrinker-kill-old-shrink-api.patch
vmscan-also-shrink-slab-in-memcg-pressure.patch
memcglist_lru-duplicate-lrus-upon-kmemcg-creation.patch
lru-add-an-element-to-a-memcg-list.patch
list_lru-per-memcg-walks.patch
memcg-per-memcg-kmem-shrinking.patch
memcg-scan-cache-objects-hierarchically.patch
vmscan-take-at-least-one-pass-with-shrinkers.patch
super-targeted-memcg-reclaim.patch
memcg-move-initialization-to-memcg-creation.patch
vmpressure-in-kernel-notifications.patch
memcg-reap-dead-memcgs-upon-global-memory-pressure.patch

