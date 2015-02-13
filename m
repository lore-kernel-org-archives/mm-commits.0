From: akpm@linux-foundation.org
Subject: [merged] list_lru-organize-all-list_lrus-to-list.patch removed
 from -mm tree
Date: Fri, 13 Feb 2015 12:20:00 -0800
Message-ID: <54de5c70.5qeyLA9PnjIfX+cH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48717 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbbBMUUC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:20:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, david@fromorbit.com, glommer@gmail.com, gthelen@google.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, tj@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: list_lru: organize all list_lrus to list
has been removed from the -mm tree.  Its filename was
     list_lru-organize-all-list_lrus-to-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: list_lru: organize all list_lrus to list

To make list_lru memcg aware, we need all list_lrus to be kept on a list
protected by a mutex, so that we could sleep while walking over the list.

Therefore after this change list_lru_destroy may sleep.  Fortunately,
there is only one user that calls it from an atomic context - it's
put_super - and we can easily fix it by calling list_lru_destroy before
put_super in destroy_locked_super - anyway we don't longer need lrus by
that time.

Another point that should be noted is that list_lru_destroy is allowed to
be called on an uninitialized zeroed-out object, in which case it is a
no-op.  Before this patch this was guaranteed by kfree, but now we need an
explicit check there.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Greg Thelen <gthelen@google.com>
Cc: Glauber Costa <glommer@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c               |    8 ++++++++
 include/linux/list_lru.h |    3 +++
 mm/list_lru.c            |   34 ++++++++++++++++++++++++++++++++++
 3 files changed, 45 insertions(+)

diff -puN fs/super.c~list_lru-organize-all-list_lrus-to-list fs/super.c
--- a/fs/super.c~list_lru-organize-all-list_lrus-to-list
+++ a/fs/super.c
@@ -282,6 +282,14 @@ void deactivate_locked_super(struct supe
 		unregister_shrinker(&s->s_shrink);
 		fs->kill_sb(s);
 
+		/*
+		 * Since list_lru_destroy() may sleep, we cannot call it from
+		 * put_super(), where we hold the sb_lock. Therefore we destroy
+		 * the lru lists right now.
+		 */
+		list_lru_destroy(&s->s_dentry_lru);
+		list_lru_destroy(&s->s_inode_lru);
+
 		put_filesystem(fs);
 		put_super(s);
 	} else {
diff -puN include/linux/list_lru.h~list_lru-organize-all-list_lrus-to-list include/linux/list_lru.h
--- a/include/linux/list_lru.h~list_lru-organize-all-list_lrus-to-list
+++ a/include/linux/list_lru.h
@@ -31,6 +31,9 @@ struct list_lru_node {
 
 struct list_lru {
 	struct list_lru_node	*node;
+#ifdef CONFIG_MEMCG_KMEM
+	struct list_head	list;
+#endif
 };
 
 void list_lru_destroy(struct list_lru *lru);
diff -puN mm/list_lru.c~list_lru-organize-all-list_lrus-to-list mm/list_lru.c
--- a/mm/list_lru.c~list_lru-organize-all-list_lrus-to-list
+++ a/mm/list_lru.c
@@ -9,6 +9,34 @@
 #include <linux/mm.h>
 #include <linux/list_lru.h>
 #include <linux/slab.h>
+#include <linux/mutex.h>
+
+#ifdef CONFIG_MEMCG_KMEM
+static LIST_HEAD(list_lrus);
+static DEFINE_MUTEX(list_lrus_mutex);
+
+static void list_lru_register(struct list_lru *lru)
+{
+	mutex_lock(&list_lrus_mutex);
+	list_add(&lru->list, &list_lrus);
+	mutex_unlock(&list_lrus_mutex);
+}
+
+static void list_lru_unregister(struct list_lru *lru)
+{
+	mutex_lock(&list_lrus_mutex);
+	list_del(&lru->list);
+	mutex_unlock(&list_lrus_mutex);
+}
+#else
+static void list_lru_register(struct list_lru *lru)
+{
+}
+
+static void list_lru_unregister(struct list_lru *lru)
+{
+}
+#endif /* CONFIG_MEMCG_KMEM */
 
 bool list_lru_add(struct list_lru *lru, struct list_head *item)
 {
@@ -137,12 +165,18 @@ int list_lru_init_key(struct list_lru *l
 		INIT_LIST_HEAD(&lru->node[i].list);
 		lru->node[i].nr_items = 0;
 	}
+	list_lru_register(lru);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(list_lru_init_key);
 
 void list_lru_destroy(struct list_lru *lru)
 {
+	/* Already destroyed or not yet initialized? */
+	if (!lru->node)
+		return;
+	list_lru_unregister(lru);
 	kfree(lru->node);
+	lru->node = NULL;
 }
 EXPORT_SYMBOL_GPL(list_lru_destroy);
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch

