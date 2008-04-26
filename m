From: akpm@linux-foundation.org
Subject: - rcu-split-listh-and-move-rcu-protected-lists-into-rculisth.patch removed from -mm tree
Date: Sat, 26 Apr 2008 07:22:20 -0700
Message-ID: <200804261422.m3QEMKUq025967@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41349 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757218AbYDZOXO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Apr 2008 10:23:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fbuihuu@gmail.com, josh@kernel.org, paulmck@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     rcu: split list.h and move rcu-protected lists into rculist.h
has been removed from the -mm tree.  Its filename was
     rcu-split-listh-and-move-rcu-protected-lists-into-rculisth.patch

This patch was dropped because Linus changes wrecked it

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rcu: split list.h and move rcu-protected lists into rculist.h
From: Franck Bui-Huu <fbuihuu@gmail.com>

Move rcu-protected lists from list.h into a new header file rculist.h.

This is done because list are a very used primitive structure all over the
kernel and it's currently impossible to include other header files in this
list.h without creating some circular dependencies.

For example, list.h implements rcu-protected list and uses rcu_dereference()
without including rcupdate.h.  It actually compiles because users of
rcu_dereference() are macros.  Others RCU functions could be used too but
aren't probably because of this.

Therefore this patch creates rculist.h which includes rcupdates without to
many changes/troubles.

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Josh Triplett <josh@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/sn/kernel/irq.c                       |    1 
 crypto/async_tx/async_tx.c                      |    1 
 drivers/infiniband/hw/ipath/ipath_verbs.c       |    1 
 drivers/infiniband/hw/ipath/ipath_verbs_mcast.c |    3 
 drivers/net/macvlan.c                           |    2 
 include/linux/dcache.h                          |    1 
 include/linux/list.h                            |  385 -------------
 include/linux/rculist.h                         |  396 ++++++++++++++
 kernel/pid.c                                    |    1 
 lib/textsearch.c                                |    1 
 net/802/psnap.c                                 |    1 
 net/8021q/vlan.c                                |    1 
 net/bridge/br_fdb.c                             |    1 
 net/bridge/br_stp.c                             |    1 
 net/netlabel/netlabel_domainhash.c              |    3 
 15 files changed, 409 insertions(+), 390 deletions(-)

diff -puN arch/ia64/sn/kernel/irq.c~rcu-split-listh-and-move-rcu-protected-lists-into-rculisth arch/ia64/sn/kernel/irq.c
--- a/arch/ia64/sn/kernel/irq.c~rcu-split-listh-and-move-rcu-protected-lists-into-rculisth
+++ a/arch/ia64/sn/kernel/irq.c
@@ -11,6 +11,7 @@
 #include <linux/irq.h>
 #include <linux/spinlock.h>
 #include <linux/init.h>
+#include <linux/rculist.h>
 #include <asm/sn/addrs.h>
 #include <asm/sn/arch.h>
 #include <asm/sn/intr.h>
diff -puN crypto/async_tx/async_tx.c~rcu-split-listh-and-move-rcu-protected-lists-into-rculisth crypto/async_tx/async_tx.c
--- a/crypto/async_tx/async_tx.c~rcu-split-listh-and-move-rcu-protected-lists-into-rculisth
+++ a/crypto/async_tx/async_tx.c
@@ -23,6 +23,7 @@
  * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
  *
  */
+#include <linux/rculist.h>
 #include <linux/kernel.h>
 #include <linux/async_tx.h>
 
diff -puN drivers/infiniband/hw/ipath/ipath_verbs.c~rcu-split-listh-and-move-rcu-protected-lists-into-rculisth drivers/infiniband/hw/ipath/ipath_verbs.c
--- a/drivers/infiniband/hw/ipath/ipath_verbs.c~rcu-split-listh-and-move-rcu-protected-lists-into-rculisth
+++ a/drivers/infiniband/hw/ipath/ipath_verbs.c
@@ -35,6 +35,7 @@
 #include <rdma/ib_user_verbs.h>
 #include <linux/io.h>
 #include <linux/utsname.h>
+#include <linux/rculist.h>
 
 #include "ipath_kernel.h"
 #include "ipath_verbs.h"
diff -puN drivers/infiniband/hw/ipath/ipath_verbs_mcast.c~rcu-split-listh-and-move-rcu-protected-lists-into-rculisth drivers/infiniband/hw/ipath/ipath_verbs_mcast.c
--- a/drivers/infiniband/hw/ipath/ipath_verbs_mcast.c~rcu-split-listh-and-move-rcu-protected-lists-into-rculisth
+++ a/drivers/infiniband/hw/ipath/ipath_verbs_mcast.c
@@ -31,8 +31,7 @@
  * SOFTWARE.
  */
 
-#include <linux/list.h>
-#include <linux/rcupdate.h>
+#include <linux/rculist.h>
 
 #include "ipath_verbs.h"
 
diff -puN drivers/net/macvlan.c~rcu-split-listh-and-move-rcu-protected-lists-into-rculisth drivers/net/macvlan.c
--- a/drivers/net/macvlan.c~rcu-split-listh-and-move-rcu-protected-lists-into-rculisth
+++ a/drivers/net/macvlan.c
@@ -20,7 +20,7 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/string.h>
-#include <linux/list.h>
+#include <linux/rculist.h>
 #include <linux/notifier.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
diff -puN include/linux/dcache.h~rcu-split-listh-and-move-rcu-protected-lists-into-rculisth include/linux/dcache.h
--- a/include/linux/dcache.h~rcu-split-listh-and-move-rcu-protected-lists-into-rculisth
+++ a/include/linux/dcache.h
@@ -5,6 +5,7 @@
 
 #include <asm/atomic.h>
 #include <linux/list.h>
+#include <linux/rculist.h>
 #include <linux/spinlock.h>
 #include <linux/cache.h>
 #include <linux/rcupdate.h>
diff -puN include/linux/list.h~rcu-split-listh-and-move-rcu-protected-lists-into-rculisth include/linux/list.h
--- a/include/linux/list.h~rcu-split-listh-and-move-rcu-protected-lists-into-rculisth
+++ a/include/linux/list.h
@@ -87,65 +87,6 @@ static inline void list_add_tail(struct 
 }
 
 /*
- * Insert a new entry between two known consecutive entries.
- *
- * This is only for internal list manipulation where we know
- * the prev/next entries already!
- */
-static inline void __list_add_rcu(struct list_head * new,
-		struct list_head * prev, struct list_head * next)
-{
-	new->next = next;
-	new->prev = prev;
-	smp_wmb();
-	next->prev = new;
-	prev->next = new;
-}
-
-/**
- * list_add_rcu - add a new entry to rcu-protected list
- * @new: new entry to be added
- * @head: list head to add it after
- *
- * Insert a new entry after the specified head.
- * This is good for implementing stacks.
- *
- * The caller must take whatever precautions are necessary
- * (such as holding appropriate locks) to avoid racing
- * with another list-mutation primitive, such as list_add_rcu()
- * or list_del_rcu(), running on this same list.
- * However, it is perfectly legal to run concurrently with
- * the _rcu list-traversal primitives, such as
- * list_for_each_entry_rcu().
- */
-static inline void list_add_rcu(struct list_head *new, struct list_head *head)
-{
-	__list_add_rcu(new, head, head->next);
-}
-
-/**
- * list_add_tail_rcu - add a new entry to rcu-protected list
- * @new: new entry to be added
- * @head: list head to add it before
- *
- * Insert a new entry before the specified head.
- * This is useful for implementing queues.
- *
- * The caller must take whatever precautions are necessary
- * (such as holding appropriate locks) to avoid racing
- * with another list-mutation primitive, such as list_add_tail_rcu()
- * or list_del_rcu(), running on this same list.
- * However, it is perfectly legal to run concurrently with
- * the _rcu list-traversal primitives, such as
- * list_for_each_entry_rcu().
- */
-static inline void list_add_tail_rcu(struct list_head *new,
-					struct list_head *head)
-{
-	__list_add_rcu(new, head->prev, head);
-}
-
-/*
  * Delete a list entry by making the prev/next entries
  * point to each other.
  *
@@ -176,36 +117,6 @@ extern void list_del(struct list_head *e
 #endif
 
 /**
- * list_del_rcu - deletes entry from list without re-initialization
- * @entry: the element to delete from the list.
- *
- * Note: list_empty() on entry does not return true after this,
- * the entry is in an undefined state. It is useful for RCU based
- * lockfree traversal.
- *
- * In particular, it means that we can not poison the forward
- * pointers that may still be used for walking the list.
- *
- * The caller must take whatever precautions are necessary
- * (such as holding appropriate locks) to avoid racing
- * with another list-mutation primitive, such as list_del_rcu()
- * or list_add_rcu(), running on this same list.
- * However, it is perfectly legal to run concurrently with
- * the _rcu list-traversal primitives, such as
- * list_for_each_entry_rcu().
- *
- * Note that the caller is not permitted to immediately free
- * the newly deleted entry.  Instead, either synchronize_rcu()
- * or call_rcu() must be used to defer freeing until an RCU
- * grace period has elapsed.
- */
-static inline void list_del_rcu(struct list_head *entry)
-{
-	__list_del(entry->prev, entry->next);
-	entry->prev = LIST_POISON2;
-}
-
-/**
  * list_replace - replace old entry by new one
  * @old : the element to be replaced
  * @new : the new element to insert
@@ -229,25 +140,6 @@ static inline void list_replace_init(str
 }
 
 /**
- * list_replace_rcu - replace old entry by new one
- * @old : the element to be replaced
- * @new : the new element to insert
- *
- * The @old entry will be replaced with the @new entry atomically.
- * Note: @old should not be empty.
- */
-static inline void list_replace_rcu(struct list_head *old,
-				struct list_head *new)
-{
-	new->next = old->next;
-	new->prev = old->prev;
-	smp_wmb();
-	new->next->prev = new;
-	new->prev->next = new;
-	old->prev = LIST_POISON2;
-}
-
-/**
  * list_del_init - deletes entry from list and reinitialize it.
  * @entry: the element to delete from the list.
  */
@@ -361,62 +253,6 @@ static inline void list_splice_init(stru
 }
 
 /**
- * list_splice_init_rcu - splice an RCU-protected list into an existing list.
- * @list:	the RCU-protected list to splice
- * @head:	the place in the list to splice the first list into
- * @sync:	function to sync: synchronize_rcu(), synchronize_sched(), ...
- *
- * @head can be RCU-read traversed concurrently with this function.
- *
- * Note that this function blocks.
- *
- * Important note: the caller must take whatever action is necessary to
- *	prevent any other updates to @head.  In principle, it is possible
- *	to modify the list as soon as sync() begins execution.
- *	If this sort of thing becomes necessary, an alternative version
- *	based on call_rcu() could be created.  But only if -really-
- *	needed -- there is no shortage of RCU API members.
- */
-static inline void list_splice_init_rcu(struct list_head *list,
-					struct list_head *head,
-					void (*sync)(void))
-{
-	struct list_head *first = list->next;
-	struct list_head *last = list->prev;
-	struct list_head *at = head->next;
-
-	if (list_empty(head))
-		return;
-
-	/* "first" and "last" tracking list, so initialize it. */
-
-	INIT_LIST_HEAD(list);
-
-	/*
-	 * At this point, the list body still points to the source list.
-	 * Wait for any readers to finish using the list before splicing
-	 * the list body into the new list.  Any new readers will see
-	 * an empty list.
-	 */
-
-	sync();
-
-	/*
-	 * Readers are finished with the source list, so perform splice.
-	 * The order is important if the new list is global and accessible
-	 * to concurrent RCU readers.  Note that RCU readers are not
-	 * permitted to traverse the prev pointers without excluding
-	 * this function.
-	 */
-
-	last->next = at;
-	smp_wmb();
-	head->next = first;
-	first->prev = head;
-	at->prev = last;
-}
-
-/**
  * list_entry - get the struct for this entry
  * @ptr:	the &struct list_head pointer.
  * @type:	the type of the struct this is embedded in.
@@ -621,75 +457,6 @@ static inline void list_splice_init_rcu(
 	     &pos->member != (head); 					\
 	     pos = n, n = list_entry(n->member.prev, typeof(*n), member))
 
-/**
- * list_for_each_rcu	-	iterate over an rcu-protected list
- * @pos:	the &struct list_head to use as a loop cursor.
- * @head:	the head for your list.
- *
- * This list-traversal primitive may safely run concurrently with
- * the _rcu list-mutation primitives such as list_add_rcu()
- * as long as the traversal is guarded by rcu_read_lock().
- */
-#define list_for_each_rcu(pos, head) \
-	for (pos = (head)->next; \
-		prefetch(rcu_dereference(pos)->next), pos != (head); \
-        	pos = pos->next)
-
-#define __list_for_each_rcu(pos, head) \
-	for (pos = (head)->next; \
-		rcu_dereference(pos) != (head); \
-        	pos = pos->next)
-
-/**
- * list_for_each_safe_rcu
- * @pos:	the &struct list_head to use as a loop cursor.
- * @n:		another &struct list_head to use as temporary storage
- * @head:	the head for your list.
- *
- * Iterate over an rcu-protected list, safe against removal of list entry.
- *
- * This list-traversal primitive may safely run concurrently with
- * the _rcu list-mutation primitives such as list_add_rcu()
- * as long as the traversal is guarded by rcu_read_lock().
- */
-#define list_for_each_safe_rcu(pos, n, head) \
-	for (pos = (head)->next; \
-		n = rcu_dereference(pos)->next, pos != (head); \
-		pos = n)
-
-/**
- * list_for_each_entry_rcu	-	iterate over rcu list of given type
- * @pos:	the type * to use as a loop cursor.
- * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
- *
- * This list-traversal primitive may safely run concurrently with
- * the _rcu list-mutation primitives such as list_add_rcu()
- * as long as the traversal is guarded by rcu_read_lock().
- */
-#define list_for_each_entry_rcu(pos, head, member) \
-	for (pos = list_entry((head)->next, typeof(*pos), member); \
-		prefetch(rcu_dereference(pos)->member.next), \
-			&pos->member != (head); \
-		pos = list_entry(pos->member.next, typeof(*pos), member))
-
-
-/**
- * list_for_each_continue_rcu
- * @pos:	the &struct list_head to use as a loop cursor.
- * @head:	the head for your list.
- *
- * Iterate over an rcu-protected list, continuing after current point.
- *
- * This list-traversal primitive may safely run concurrently with
- * the _rcu list-mutation primitives such as list_add_rcu()
- * as long as the traversal is guarded by rcu_read_lock().
- */
-#define list_for_each_continue_rcu(pos, head) \
-	for ((pos) = (pos)->next; \
-		prefetch(rcu_dereference((pos))->next), (pos) != (head); \
-        	(pos) = (pos)->next)
-
 /*
  * Double linked lists with a single pointer list head.
  * Mostly useful for hash tables where the two pointer list head is
@@ -740,31 +507,6 @@ static inline void hlist_del(struct hlis
 	n->pprev = LIST_POISON2;
 }
 
-/**
- * hlist_del_rcu - deletes entry from hash list without re-initialization
- * @n: the element to delete from the hash list.
- *
- * Note: list_unhashed() on entry does not return true after this,
- * the entry is in an undefined state. It is useful for RCU based
- * lockfree traversal.
- *
- * In particular, it means that we can not poison the forward
- * pointers that may still be used for walking the hash list.
- *
- * The caller must take whatever precautions are necessary
- * (such as holding appropriate locks) to avoid racing
- * with another list-mutation primitive, such as hlist_add_head_rcu()
- * or hlist_del_rcu(), running on this same list.
- * However, it is perfectly legal to run concurrently with
- * the _rcu list-traversal primitives, such as
- * hlist_for_each_entry().
- */
-static inline void hlist_del_rcu(struct hlist_node *n)
-{
-	__hlist_del(n);
-	n->pprev = LIST_POISON2;
-}
-
 static inline void hlist_del_init(struct hlist_node *n)
 {
 	if (!hlist_unhashed(n)) {
@@ -773,27 +515,6 @@ static inline void hlist_del_init(struct
 	}
 }
 
-/**
- * hlist_replace_rcu - replace old entry by new one
- * @old : the element to be replaced
- * @new : the new element to insert
- *
- * The @old entry will be replaced with the @new entry atomically.
- */
-static inline void hlist_replace_rcu(struct hlist_node *old,
-					struct hlist_node *new)
-{
-	struct hlist_node *next = old->next;
-
-	new->next = next;
-	new->pprev = old->pprev;
-	smp_wmb();
-	if (next)
-		new->next->pprev = &new->next;
-	*new->pprev = new;
-	old->pprev = LIST_POISON2;
-}
-
 static inline void hlist_add_head(struct hlist_node *n, struct hlist_head *h)
 {
 	struct hlist_node *first = h->first;
@@ -804,38 +525,6 @@ static inline void hlist_add_head(struct
 	n->pprev = &h->first;
 }
 
-
-/**
- * hlist_add_head_rcu
- * @n: the element to add to the hash list.
- * @h: the list to add to.
- *
- * Description:
- * Adds the specified element to the specified hlist,
- * while permitting racing traversals.
- *
- * The caller must take whatever precautions are necessary
- * (such as holding appropriate locks) to avoid racing
- * with another list-mutation primitive, such as hlist_add_head_rcu()
- * or hlist_del_rcu(), running on this same list.
- * However, it is perfectly legal to run concurrently with
- * the _rcu list-traversal primitives, such as
- * hlist_for_each_entry_rcu(), used to prevent memory-consistency
- * problems on Alpha CPUs.  Regardless of the type of CPU, the
- * list-traversal primitive must be guarded by rcu_read_lock().
- */
-static inline void hlist_add_head_rcu(struct hlist_node *n,
-					struct hlist_head *h)
-{
-	struct hlist_node *first = h->first;
-	n->next = first;
-	n->pprev = &h->first;
-	smp_wmb();
-	if (first)
-		first->pprev = &n->next;
-	h->first = n;
-}
-
 /* next must be != NULL */
 static inline void hlist_add_before(struct hlist_node *n,
 					struct hlist_node *next)
@@ -857,63 +546,6 @@ static inline void hlist_add_after(struc
 		next->next->pprev  = &next->next;
 }
 
-/**
- * hlist_add_before_rcu
- * @n: the new element to add to the hash list.
- * @next: the existing element to add the new element before.
- *
- * Description:
- * Adds the specified element to the specified hlist
- * before the specified node while permitting racing traversals.
- *
- * The caller must take whatever precautions are necessary
- * (such as holding appropriate locks) to avoid racing
- * with another list-mutation primitive, such as hlist_add_head_rcu()
- * or hlist_del_rcu(), running on this same list.
- * However, it is perfectly legal to run concurrently with
- * the _rcu list-traversal primitives, such as
- * hlist_for_each_entry_rcu(), used to prevent memory-consistency
- * problems on Alpha CPUs.
- */
-static inline void hlist_add_before_rcu(struct hlist_node *n,
-					struct hlist_node *next)
-{
-	n->pprev = next->pprev;
-	n->next = next;
-	smp_wmb();
-	next->pprev = &n->next;
-	*(n->pprev) = n;
-}
-
-/**
- * hlist_add_after_rcu
- * @prev: the existing element to add the new element after.
- * @n: the new element to add to the hash list.
- *
- * Description:
- * Adds the specified element to the specified hlist
- * after the specified node while permitting racing traversals.
- *
- * The caller must take whatever precautions are necessary
- * (such as holding appropriate locks) to avoid racing
- * with another list-mutation primitive, such as hlist_add_head_rcu()
- * or hlist_del_rcu(), running on this same list.
- * However, it is perfectly legal to run concurrently with
- * the _rcu list-traversal primitives, such as
- * hlist_for_each_entry_rcu(), used to prevent memory-consistency
- * problems on Alpha CPUs.
- */
-static inline void hlist_add_after_rcu(struct hlist_node *prev,
-				       struct hlist_node *n)
-{
-	n->next = prev->next;
-	n->pprev = &prev->next;
-	smp_wmb();
-	prev->next = n;
-	if (n->next)
-		n->next->pprev = &n->next;
-}
-
 #define hlist_entry(ptr, type, member) container_of(ptr,type,member)
 
 #define hlist_for_each(pos, head) \
@@ -974,23 +606,6 @@ static inline void hlist_add_after_rcu(s
 		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
 	     pos = n)
 
-/**
- * hlist_for_each_entry_rcu - iterate over rcu list of given type
- * @tpos:	the type * to use as a loop cursor.
- * @pos:	the &struct hlist_node to use as a loop cursor.
- * @head:	the head for your list.
- * @member:	the name of the hlist_node within the struct.
- *
- * This list-traversal primitive may safely run concurrently with
- * the _rcu list-mutation primitives such as hlist_add_head_rcu()
- * as long as the traversal is guarded by rcu_read_lock().
- */
-#define hlist_for_each_entry_rcu(tpos, pos, head, member)		 \
-	for (pos = (head)->first;					 \
-	     rcu_dereference(pos) && ({ prefetch(pos->next); 1;}) &&	 \
-		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
-	     pos = pos->next)
-
 #else
 #warning "don't include kernel headers in userspace"
 #endif /* __KERNEL__ */
diff -puN /dev/null include/linux/rculist.h
--- /dev/null
+++ a/include/linux/rculist.h
@@ -0,0 +1,396 @@
+#ifndef _LINUX_RCULIST_H
+#define _LINUX_RCULIST_H
+
+#ifdef __KERNEL__
+
+/*
+ * RCU-protected list version
+ */
+#include <linux/list.h>
+
+/*
+ * Insert a new entry between two known consecutive entries.
+ *
+ * This is only for internal list manipulation where we know
+ * the prev/next entries already!
+ */
+static inline void __list_add_rcu(struct list_head *new,
+		struct list_head *prev, struct list_head *next)
+{
+	new->next = next;
+	new->prev = prev;
+	smp_wmb();
+	next->prev = new;
+	prev->next = new;
+}
+
+/**
+ * list_add_rcu - add a new entry to rcu-protected list
+ * @new: new entry to be added
+ * @head: list head to add it after
+ *
+ * Insert a new entry after the specified head.
+ * This is good for implementing stacks.
+ *
+ * The caller must take whatever precautions are necessary
+ * (such as holding appropriate locks) to avoid racing
+ * with another list-mutation primitive, such as list_add_rcu()
+ * or list_del_rcu(), running on this same list.
+ * However, it is perfectly legal to run concurrently with
+ * the _rcu list-traversal primitives, such as
+ * list_for_each_entry_rcu().
+ */
+static inline void list_add_rcu(struct list_head *new, struct list_head *head)
+{
+	__list_add_rcu(new, head, head->next);
+}
+
+/**
+ * list_add_tail_rcu - add a new entry to rcu-protected list
+ * @new: new entry to be added
+ * @head: list head to add it before
+ *
+ * Insert a new entry before the specified head.
+ * This is useful for implementing queues.
+ *
+ * The caller must take whatever precautions are necessary
+ * (such as holding appropriate locks) to avoid racing
+ * with another list-mutation primitive, such as list_add_tail_rcu()
+ * or list_del_rcu(), running on this same list.
+ * However, it is perfectly legal to run concurrently with
+ * the _rcu list-traversal primitives, such as
+ * list_for_each_entry_rcu().
+ */
+static inline void list_add_tail_rcu(struct list_head *new,
+					struct list_head *head)
+{
+	__list_add_rcu(new, head->prev, head);
+}
+
+/**
+ * list_del_rcu - deletes entry from list without re-initialization
+ * @entry: the element to delete from the list.
+ *
+ * Note: list_empty() on entry does not return true after this,
+ * the entry is in an undefined state. It is useful for RCU based
+ * lockfree traversal.
+ *
+ * In particular, it means that we can not poison the forward
+ * pointers that may still be used for walking the list.
+ *
+ * The caller must take whatever precautions are necessary
+ * (such as holding appropriate locks) to avoid racing
+ * with another list-mutation primitive, such as list_del_rcu()
+ * or list_add_rcu(), running on this same list.
+ * However, it is perfectly legal to run concurrently with
+ * the _rcu list-traversal primitives, such as
+ * list_for_each_entry_rcu().
+ *
+ * Note that the caller is not permitted to immediately free
+ * the newly deleted entry.  Instead, either synchronize_rcu()
+ * or call_rcu() must be used to defer freeing until an RCU
+ * grace period has elapsed.
+ */
+static inline void list_del_rcu(struct list_head *entry)
+{
+	__list_del(entry->prev, entry->next);
+	entry->prev = LIST_POISON2;
+}
+
+/**
+ * list_replace_rcu - replace old entry by new one
+ * @old : the element to be replaced
+ * @new : the new element to insert
+ *
+ * The @old entry will be replaced with the @new entry atomically.
+ * Note: @old should not be empty.
+ */
+static inline void list_replace_rcu(struct list_head *old,
+				struct list_head *new)
+{
+	new->next = old->next;
+	new->prev = old->prev;
+	smp_wmb();
+	new->next->prev = new;
+	new->prev->next = new;
+	old->prev = LIST_POISON2;
+}
+
+/**
+ * list_splice_init_rcu - splice an RCU-protected list into an existing list.
+ * @list:	the RCU-protected list to splice
+ * @head:	the place in the list to splice the first list into
+ * @sync:	function to sync: synchronize_rcu(), synchronize_sched(), ...
+ *
+ * @head can be RCU-read traversed concurrently with this function.
+ *
+ * Note that this function blocks.
+ *
+ * Important note: the caller must take whatever action is necessary to
+ *	prevent any other updates to @head.  In principle, it is possible
+ *	to modify the list as soon as sync() begins execution.
+ *	If this sort of thing becomes necessary, an alternative version
+ *	based on call_rcu() could be created.  But only if -really-
+ *	needed -- there is no shortage of RCU API members.
+ */
+static inline void list_splice_init_rcu(struct list_head *list,
+					struct list_head *head,
+					void (*sync)(void))
+{
+	struct list_head *first = list->next;
+	struct list_head *last = list->prev;
+	struct list_head *at = head->next;
+
+	if (list_empty(head))
+		return;
+
+	/* "first" and "last" tracking list, so initialize it. */
+
+	INIT_LIST_HEAD(list);
+
+	/*
+	 * At this point, the list body still points to the source list.
+	 * Wait for any readers to finish using the list before splicing
+	 * the list body into the new list.  Any new readers will see
+	 * an empty list.
+	 */
+
+	sync();
+
+	/*
+	 * Readers are finished with the source list, so perform splice.
+	 * The order is important if the new list is global and accessible
+	 * to concurrent RCU readers.  Note that RCU readers are not
+	 * permitted to traverse the prev pointers without excluding
+	 * this function.
+	 */
+
+	last->next = at;
+	smp_wmb();
+	head->next = first;
+	first->prev = head;
+	at->prev = last;
+}
+
+/**
+ * list_for_each_rcu	-	iterate over an rcu-protected list
+ * @pos:	the &struct list_head to use as a loop cursor.
+ * @head:	the head for your list.
+ *
+ * This list-traversal primitive may safely run concurrently with
+ * the _rcu list-mutation primitives such as list_add_rcu()
+ * as long as the traversal is guarded by rcu_read_lock().
+ */
+#define list_for_each_rcu(pos, head) \
+	for (pos = (head)->next; \
+		prefetch(rcu_dereference(pos)->next), pos != (head); \
+		pos = pos->next)
+
+#define __list_for_each_rcu(pos, head) \
+	for (pos = (head)->next; \
+		rcu_dereference(pos) != (head); \
+		pos = pos->next)
+
+/**
+ * list_for_each_safe_rcu
+ * @pos:	the &struct list_head to use as a loop cursor.
+ * @n:		another &struct list_head to use as temporary storage
+ * @head:	the head for your list.
+ *
+ * Iterate over an rcu-protected list, safe against removal of list entry.
+ *
+ * This list-traversal primitive may safely run concurrently with
+ * the _rcu list-mutation primitives such as list_add_rcu()
+ * as long as the traversal is guarded by rcu_read_lock().
+ */
+#define list_for_each_safe_rcu(pos, n, head) \
+	for (pos = (head)->next; \
+		n = rcu_dereference(pos)->next, pos != (head); \
+		pos = n)
+
+/**
+ * list_for_each_entry_rcu	-	iterate over rcu list of given type
+ * @pos:	the type * to use as a loop cursor.
+ * @head:	the head for your list.
+ * @member:	the name of the list_struct within the struct.
+ *
+ * This list-traversal primitive may safely run concurrently with
+ * the _rcu list-mutation primitives such as list_add_rcu()
+ * as long as the traversal is guarded by rcu_read_lock().
+ */
+#define list_for_each_entry_rcu(pos, head, member) \
+	for (pos = list_entry((head)->next, typeof(*pos), member); \
+		prefetch(rcu_dereference(pos)->member.next), \
+			&pos->member != (head); \
+		pos = list_entry(pos->member.next, typeof(*pos), member))
+
+
+/**
+ * list_for_each_continue_rcu
+ * @pos:	the &struct list_head to use as a loop cursor.
+ * @head:	the head for your list.
+ *
+ * Iterate over an rcu-protected list, continuing after current point.
+ *
+ * This list-traversal primitive may safely run concurrently with
+ * the _rcu list-mutation primitives such as list_add_rcu()
+ * as long as the traversal is guarded by rcu_read_lock().
+ */
+#define list_for_each_continue_rcu(pos, head) \
+	for ((pos) = (pos)->next; \
+		prefetch(rcu_dereference((pos))->next), (pos) != (head); \
+		(pos) = (pos)->next)
+
+/**
+ * hlist_del_rcu - deletes entry from hash list without re-initialization
+ * @n: the element to delete from the hash list.
+ *
+ * Note: list_unhashed() on entry does not return true after this,
+ * the entry is in an undefined state. It is useful for RCU based
+ * lockfree traversal.
+ *
+ * In particular, it means that we can not poison the forward
+ * pointers that may still be used for walking the hash list.
+ *
+ * The caller must take whatever precautions are necessary
+ * (such as holding appropriate locks) to avoid racing
+ * with another list-mutation primitive, such as hlist_add_head_rcu()
+ * or hlist_del_rcu(), running on this same list.
+ * However, it is perfectly legal to run concurrently with
+ * the _rcu list-traversal primitives, such as
+ * hlist_for_each_entry().
+ */
+static inline void hlist_del_rcu(struct hlist_node *n)
+{
+	__hlist_del(n);
+	n->pprev = LIST_POISON2;
+}
+
+/**
+ * hlist_replace_rcu - replace old entry by new one
+ * @old : the element to be replaced
+ * @new : the new element to insert
+ *
+ * The @old entry will be replaced with the @new entry atomically.
+ */
+static inline void hlist_replace_rcu(struct hlist_node *old,
+					struct hlist_node *new)
+{
+	struct hlist_node *next = old->next;
+
+	new->next = next;
+	new->pprev = old->pprev;
+	smp_wmb();
+	if (next)
+		new->next->pprev = &new->next;
+	*new->pprev = new;
+	old->pprev = LIST_POISON2;
+}
+
+/**
+ * hlist_add_head_rcu
+ * @n: the element to add to the hash list.
+ * @h: the list to add to.
+ *
+ * Description:
+ * Adds the specified element to the specified hlist,
+ * while permitting racing traversals.
+ *
+ * The caller must take whatever precautions are necessary
+ * (such as holding appropriate locks) to avoid racing
+ * with another list-mutation primitive, such as hlist_add_head_rcu()
+ * or hlist_del_rcu(), running on this same list.
+ * However, it is perfectly legal to run concurrently with
+ * the _rcu list-traversal primitives, such as
+ * hlist_for_each_entry_rcu(), used to prevent memory-consistency
+ * problems on Alpha CPUs.  Regardless of the type of CPU, the
+ * list-traversal primitive must be guarded by rcu_read_lock().
+ */
+static inline void hlist_add_head_rcu(struct hlist_node *n,
+					struct hlist_head *h)
+{
+	struct hlist_node *first = h->first;
+	n->next = first;
+	n->pprev = &h->first;
+	smp_wmb();
+	if (first)
+		first->pprev = &n->next;
+	h->first = n;
+}
+
+/**
+ * hlist_add_before_rcu
+ * @n: the new element to add to the hash list.
+ * @next: the existing element to add the new element before.
+ *
+ * Description:
+ * Adds the specified element to the specified hlist
+ * before the specified node while permitting racing traversals.
+ *
+ * The caller must take whatever precautions are necessary
+ * (such as holding appropriate locks) to avoid racing
+ * with another list-mutation primitive, such as hlist_add_head_rcu()
+ * or hlist_del_rcu(), running on this same list.
+ * However, it is perfectly legal to run concurrently with
+ * the _rcu list-traversal primitives, such as
+ * hlist_for_each_entry_rcu(), used to prevent memory-consistency
+ * problems on Alpha CPUs.
+ */
+static inline void hlist_add_before_rcu(struct hlist_node *n,
+					struct hlist_node *next)
+{
+	n->pprev = next->pprev;
+	n->next = next;
+	smp_wmb();
+	next->pprev = &n->next;
+	*(n->pprev) = n;
+}
+
+/**
+ * hlist_add_after_rcu
+ * @prev: the existing element to add the new element after.
+ * @n: the new element to add to the hash list.
+ *
+ * Description:
+ * Adds the specified element to the specified hlist
+ * after the specified node while permitting racing traversals.
+ *
+ * The caller must take whatever precautions are necessary
+ * (such as holding appropriate locks) to avoid racing
+ * with another list-mutation primitive, such as hlist_add_head_rcu()
+ * or hlist_del_rcu(), running on this same list.
+ * However, it is perfectly legal to run concurrently with
+ * the _rcu list-traversal primitives, such as
+ * hlist_for_each_entry_rcu(), used to prevent memory-consistency
+ * problems on Alpha CPUs.
+ */
+static inline void hlist_add_after_rcu(struct hlist_node *prev,
+				       struct hlist_node *n)
+{
+	n->next = prev->next;
+	n->pprev = &prev->next;
+	smp_wmb();
+	prev->next = n;
+	if (n->next)
+		n->next->pprev = &n->next;
+}
+
+/**
+ * hlist_for_each_entry_rcu - iterate over rcu list of given type
+ * @tpos:	the type * to use as a loop cursor.
+ * @pos:	the &struct hlist_node to use as a loop cursor.
+ * @head:	the head for your list.
+ * @member:	the name of the hlist_node within the struct.
+ *
+ * This list-traversal primitive may safely run concurrently with
+ * the _rcu list-mutation primitives such as hlist_add_head_rcu()
+ * as long as the traversal is guarded by rcu_read_lock().
+ */
+#define hlist_for_each_entry_rcu(tpos, pos, head, member)		 \
+	for (pos = (head)->first;					 \
+	     rcu_dereference(pos) && ({ prefetch(pos->next); 1; }) &&	 \
+		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1; }); \
+	     pos = pos->next)
+
+#endif	/* __KERNEL__ */
+#endif
diff -puN kernel/pid.c~rcu-split-listh-and-move-rcu-protected-lists-into-rculisth kernel/pid.c
--- a/kernel/pid.c~rcu-split-listh-and-move-rcu-protected-lists-into-rculisth
+++ a/kernel/pid.c
@@ -30,6 +30,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/init.h>
+#include <linux/rculist.h>
 #include <linux/bootmem.h>
 #include <linux/hash.h>
 #include <linux/pid_namespace.h>
diff -puN lib/textsearch.c~rcu-split-listh-and-move-rcu-protected-lists-into-rculisth lib/textsearch.c
--- a/lib/textsearch.c~rcu-split-listh-and-move-rcu-protected-lists-into-rculisth
+++ a/lib/textsearch.c
@@ -97,6 +97,7 @@
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/init.h>
+#include <linux/rculist.h>
 #include <linux/rcupdate.h>
 #include <linux/err.h>
 #include <linux/textsearch.h>
diff -puN net/802/psnap.c~rcu-split-listh-and-move-rcu-protected-lists-into-rculisth net/802/psnap.c
--- a/net/802/psnap.c~rcu-split-listh-and-move-rcu-protected-lists-into-rculisth
+++ a/net/802/psnap.c
@@ -20,6 +20,7 @@
 #include <linux/mm.h>
 #include <linux/in.h>
 #include <linux/init.h>
+#include <linux/rculist.h>
 
 static LIST_HEAD(snap_list);
 static DEFINE_SPINLOCK(snap_lock);
diff -puN net/8021q/vlan.c~rcu-split-listh-and-move-rcu-protected-lists-into-rculisth net/8021q/vlan.c
--- a/net/8021q/vlan.c~rcu-split-listh-and-move-rcu-protected-lists-into-rculisth
+++ a/net/8021q/vlan.c
@@ -27,6 +27,7 @@
 #include <linux/mm.h>
 #include <linux/in.h>
 #include <linux/init.h>
+#include <linux/rculist.h>
 #include <net/p8022.h>
 #include <net/arp.h>
 #include <linux/rtnetlink.h>
diff -puN net/bridge/br_fdb.c~rcu-split-listh-and-move-rcu-protected-lists-into-rculisth net/bridge/br_fdb.c
--- a/net/bridge/br_fdb.c~rcu-split-listh-and-move-rcu-protected-lists-into-rculisth
+++ a/net/bridge/br_fdb.c
@@ -15,6 +15,7 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/rculist.h>
 #include <linux/spinlock.h>
 #include <linux/times.h>
 #include <linux/netdevice.h>
diff -puN net/bridge/br_stp.c~rcu-split-listh-and-move-rcu-protected-lists-into-rculisth net/bridge/br_stp.c
--- a/net/bridge/br_stp.c~rcu-split-listh-and-move-rcu-protected-lists-into-rculisth
+++ a/net/bridge/br_stp.c
@@ -13,6 +13,7 @@
  *	2 of the License, or (at your option) any later version.
  */
 #include <linux/kernel.h>
+#include <linux/rculist.h>
 
 #include "br_private.h"
 #include "br_private_stp.h"
diff -puN net/netlabel/netlabel_domainhash.c~rcu-split-listh-and-move-rcu-protected-lists-into-rculisth net/netlabel/netlabel_domainhash.c
--- a/net/netlabel/netlabel_domainhash.c~rcu-split-listh-and-move-rcu-protected-lists-into-rculisth
+++ a/net/netlabel/netlabel_domainhash.c
@@ -30,8 +30,7 @@
  */
 
 #include <linux/types.h>
-#include <linux/rcupdate.h>
-#include <linux/list.h>
+#include <linux/rculist.h>
 #include <linux/skbuff.h>
 #include <linux/spinlock.h>
 #include <linux/string.h>
_

Patches currently in -mm which might be from fbuihuu@gmail.com are

rcu-split-listh-and-move-rcu-protected-lists-into-rculisth.patch
rculisth-use-the-rcu-api.patch

