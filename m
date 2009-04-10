From: akpm@linux-foundation.org
Subject: [to-be-updated] sysctl-lockdep-support-for-sysctl-reference-counting.patch removed from -mm tree
Date: Fri, 10 Apr 2009 02:19:23 -0700
Message-ID: <200904100919.n3A9JNCx012585@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35442 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764418AbZDJJWK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 05:22:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@aristanetworks.com, a.p.zijlstra@chello.nl, adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: lockdep support for sysctl reference counting
has been removed from the -mm tree.  Its filename was
     sysctl-lockdep-support-for-sysctl-reference-counting.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl: lockdep support for sysctl reference counting
From: Eric Biederman <ebiederm@aristanetworks.com>

It is possible for get lock ordering deadlocks between locks and waiting
for the sysctl used count to drop to zero.  We have recently observed one
of these in the networking code.

So teach the sysctl code how to speak lockdep so the kernel
can warn about these kinds of rare issues proactively.

Signed-off-by: Eric Biederman <ebiederm@aristanetworks.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysctl.h |    4 +
 kernel/sysctl.c        |  108 +++++++++++++++++++++++++++++++--------
 2 files changed, 91 insertions(+), 21 deletions(-)

diff -puN include/linux/sysctl.h~sysctl-lockdep-support-for-sysctl-reference-counting include/linux/sysctl.h
--- a/include/linux/sysctl.h~sysctl-lockdep-support-for-sysctl-reference-counting
+++ a/include/linux/sysctl.h
@@ -28,6 +28,7 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/compiler.h>
+#include <linux/lockdep.h>
 
 struct file;
 struct completion;
@@ -1088,6 +1089,9 @@ struct ctl_table_header
 	struct ctl_table *attached_by;
 	struct ctl_table *attached_to;
 	struct ctl_table_header *parent;
+#ifdef CONFIG_PROVE_LOCKING
+	struct lockdep_map dep_map;
+#endif
 };
 
 /* struct ctl_path describes where in the hierarchy a table is added */
diff -puN kernel/sysctl.c~sysctl-lockdep-support-for-sysctl-reference-counting kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-lockdep-support-for-sysctl-reference-counting
+++ a/kernel/sysctl.c
@@ -1508,12 +1508,63 @@ static struct ctl_table dev_table[] = {
 
 static DEFINE_SPINLOCK(sysctl_lock);
 
+#ifndef CONFIG_PROVE_LOCKING
+
+# define lock_sysctl() spin_lock(&sysctl_lock)
+# define unlock_sysctl() spin_unlock(&sysctl_lock)
+
+static inline void table_acquire_use(struct ctl_table_header *hdr) { }
+static inline void table_release_use(struct ctl_table_header *hdr) { }
+static inline void table_acquire(struct ctl_table_header *hdr) { }
+static inline void table_contended(struct ctl_table_header *hdr) { }
+static inline void table_acquired(struct ctl_table_header *hdr) { }
+static inline void table_release(struct ctl_table_header *hdr) { }
+
+#else	/* CONFIG_PROVE_LOCKING */
+
+#  define lock_sysctl() __raw_spin_lock(&sysctl_lock.raw_lock)
+#  define unlock_sysctl() __raw_spin_unlock(&sysctl_lock.raw_lock)
+
+static inline void table_acquire_use(struct ctl_table_header *hdr)
+{
+	lock_acquire(&hdr->dep_map, 0, 0, 1, 2, NULL, _RET_IP_);
+	lock_acquired(&hdr->dep_map, _RET_IP_);
+}
+
+static inline void table_release_use(struct ctl_table_header *hdr)
+{
+	lock_release(&hdr->dep_map, 0, _RET_IP_);
+}
+
+static inline void table_acquire(struct ctl_table_header *hdr)
+{
+	lock_acquire(&hdr->dep_map, 0, 0, 0, 2, NULL, _RET_IP_);
+}
+
+static inline void table_contended(struct ctl_table_header *hdr)
+{
+	lock_contended(&hdr->dep_map, _RET_IP_);
+}
+
+static inline void table_acquired(struct ctl_table_header *hdr)
+{
+	lock_acquired(&hdr->dep_map, _RET_IP_);
+}
+
+static inline void table_release(struct ctl_table_header *hdr)
+{
+	lock_release(&hdr->dep_map, 0, _RET_IP_);
+}
+
+#endif /* CONFIG_PROVE_LOCKING */
+
 /* called under sysctl_lock */
 static int use_table(struct ctl_table_header *p)
 {
 	if (unlikely(p->unregistering))
 		return 0;
 	p->used++;
+	table_acquire_use(p);
 	return 1;
 }
 
@@ -1523,6 +1574,8 @@ static void unuse_table(struct ctl_table
 	if (!--p->used)
 		if (unlikely(p->unregistering))
 			complete(p->unregistering);
+
+	table_release_use(p);
 }
 
 /* called under sysctl_lock, will reacquire if has to wait */
@@ -1532,47 +1585,54 @@ static void start_unregistering(struct c
 	 * if p->used is 0, nobody will ever touch that entry again;
 	 * we'll eliminate all paths to it before dropping sysctl_lock
 	 */
+	table_acquire(p);
 	if (unlikely(p->used)) {
 		struct completion wait;
+		table_contended(p);
+
 		init_completion(&wait);
 		p->unregistering = &wait;
-		spin_unlock(&sysctl_lock);
+		unlock_sysctl();
 		wait_for_completion(&wait);
-		spin_lock(&sysctl_lock);
+		lock_sysctl();
 	} else {
 		/* anything non-NULL; we'll never dereference it */
 		p->unregistering = ERR_PTR(-EINVAL);
 	}
+	table_acquired(p);
+
 	/*
 	 * do not remove from the list until nobody holds it; walking the
 	 * list in do_sysctl() relies on that.
 	 */
 	list_del_init(&p->ctl_entry);
+
+	table_release(p);
 }
 
 void sysctl_head_get(struct ctl_table_header *head)
 {
-	spin_lock(&sysctl_lock);
+	lock_sysctl();
 	head->count++;
-	spin_unlock(&sysctl_lock);
+	unlock_sysctl();
 }
 
 void sysctl_head_put(struct ctl_table_header *head)
 {
-	spin_lock(&sysctl_lock);
+	lock_sysctl();
 	if (!--head->count)
 		kfree(head);
-	spin_unlock(&sysctl_lock);
+	unlock_sysctl();
 }
 
 struct ctl_table_header *sysctl_head_grab(struct ctl_table_header *head)
 {
 	if (!head)
 		BUG();
-	spin_lock(&sysctl_lock);
+	lock_sysctl();
 	if (!use_table(head))
 		head = ERR_PTR(-ENOENT);
-	spin_unlock(&sysctl_lock);
+	unlock_sysctl();
 	return head;
 }
 
@@ -1580,9 +1640,9 @@ void sysctl_head_finish(struct ctl_table
 {
 	if (!head)
 		return;
-	spin_lock(&sysctl_lock);
+	lock_sysctl();
 	unuse_table(head);
-	spin_unlock(&sysctl_lock);
+	unlock_sysctl();
 }
 
 static struct ctl_table_set *
@@ -1609,7 +1669,7 @@ struct ctl_table_header *__sysctl_head_n
 	struct ctl_table_header *head;
 	struct list_head *tmp;
 
-	spin_lock(&sysctl_lock);
+	lock_sysctl();
 	if (prev) {
 		head = prev;
 		tmp = &prev->ctl_entry;
@@ -1622,7 +1682,7 @@ struct ctl_table_header *__sysctl_head_n
 
 		if (!use_table(head))
 			goto next;
-		spin_unlock(&sysctl_lock);
+		unlock_sysctl();
 		return head;
 	next:
 		root = head->root;
@@ -1641,7 +1701,7 @@ struct ctl_table_header *__sysctl_head_n
 		tmp = header_list->next;
 	}
 out:
-	spin_unlock(&sysctl_lock);
+	unlock_sysctl();
 	return NULL;
 }
 
@@ -1652,9 +1712,9 @@ struct ctl_table_header *sysctl_head_nex
 
 void register_sysctl_root(struct ctl_table_root *root)
 {
-	spin_lock(&sysctl_lock);
+	lock_sysctl();
 	list_add_tail(&root->root_list, &sysctl_table_root.root_list);
-	spin_unlock(&sysctl_lock);
+	unlock_sysctl();
 }
 
 #ifdef CONFIG_SYSCTL_SYSCALL
@@ -2005,7 +2065,13 @@ struct ctl_table_header *__register_sysc
 		return NULL;
 	}
 #endif
-	spin_lock(&sysctl_lock);
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	{
+		static struct lock_class_key __key;
+		lockdep_init_map(&header->dep_map, "sysctl_used", &__key, 0);
+	}
+#endif
+	lock_sysctl();
 	header->set = lookup_header_set(root, namespaces);
 	header->attached_by = header->ctl_table;
 	header->attached_to = root_table;
@@ -2020,7 +2086,7 @@ struct ctl_table_header *__register_sysc
 	}
 	header->parent->count++;
 	list_add_tail(&header->ctl_entry, &header->set->list);
-	spin_unlock(&sysctl_lock);
+	unlock_sysctl();
 
 	return header;
 }
@@ -2072,7 +2138,7 @@ void unregister_sysctl_table(struct ctl_
 	if (header == NULL)
 		return;
 
-	spin_lock(&sysctl_lock);
+	lock_sysctl();
 	start_unregistering(header);
 	if (!--header->parent->count) {
 		WARN_ON(1);
@@ -2080,21 +2146,21 @@ void unregister_sysctl_table(struct ctl_
 	}
 	if (!--header->count)
 		kfree(header);
-	spin_unlock(&sysctl_lock);
+	unlock_sysctl();
 }
 
 int sysctl_is_seen(struct ctl_table_header *p)
 {
 	struct ctl_table_set *set = p->set;
 	int res;
-	spin_lock(&sysctl_lock);
+	lock_sysctl();
 	if (p->unregistering)
 		res = 0;
 	else if (!set->is_seen)
 		res = 1;
 	else
 		res = set->is_seen(set);
-	spin_unlock(&sysctl_lock);
+	unlock_sysctl();
 	return res;
 }
 
_

Patches currently in -mm which might be from ebiederm@aristanetworks.com are

sysctl-lockdep-support-for-sysctl-reference-counting.patch
sysctl-lockdep-support-for-sysctl-reference-counting-fix.patch

