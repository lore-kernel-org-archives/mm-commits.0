From: akpm@linux-foundation.org
Subject: + workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name.patch added to -mm tree
Date: Mon, 14 Nov 2011 14:04:52 -0800
Message-ID: <201111142204.pAEM4qFW031227@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:65065 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007Ab1KNWE7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2011 17:04:59 -0500
Received: by faap16 with SMTP id p16so81090faa.1
        for <mm-commits@vger.kernel.org>; Mon, 14 Nov 2011 14:04:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, hch@infradead.org


The patch titled
     Subject: workqueue: make alloc_workqueue() take printf fmt and args for name
has been added to the -mm tree.  Its filename is
     workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: workqueue: make alloc_workqueue() take printf fmt and args for name

alloc_workqueue() currently expects the passed in @name pointer to remain
accessible.  This is inconvenient and a bit silly given that the whole wq
is being dynamically allocated.  This patch updates alloc_workqueue() and
friends to take printf format string instead of opaque string and matching
varargs at the end.  The name is allocated together with the wq and
formatted.

alloc_ordered_workqueue() is converted to a macro to unify varargs
handling with alloc_workqueue(), and, while at it, add comment to
alloc_workqueue().

None of the current in-kernel users pass in string with '%' as constant
name and this change shouldn't cause any problem.

Signed-off-by: Tejun Heo <tj@kernel.org>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <>
---

 include/linux/workqueue.h |   48 ++++++++++++++++++++++++------------
 kernel/workqueue.c        |   32 ++++++++++++++++--------
 2 files changed, 54 insertions(+), 26 deletions(-)

diff -puN include/linux/workqueue.h~workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name include/linux/workqueue.h
--- a/include/linux/workqueue.h~workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name
+++ a/include/linux/workqueue.h
@@ -297,32 +297,51 @@ extern struct workqueue_struct *system_u
 extern struct workqueue_struct *system_freezable_wq;
 
 extern struct workqueue_struct *
-__alloc_workqueue_key(const char *name, unsigned int flags, int max_active,
-		      struct lock_class_key *key, const char *lock_name);
+__alloc_workqueue_key(const char *fmt, unsigned int flags, int max_active,
+		      struct lock_class_key *key, const char *lock_name, ...)
+	__attribute__((format (printf, 1, 6)));
 
+/**
+ * alloc_workqueue - allocate a workqueue
+ * @fmt: printf format for the name of the workqueue
+ * @flags: WQ_* flags
+ * @max_active: max in-flight work items, 0 for default
+ * @args: args for @fmt
+ *
+ * Allocate a workqueue with the specified parameters.  For detailed
+ * information on WQ_* flags, please refer to Documentation/workqueue.txt.
+ *
+ * The __lock_name macro dance is to guarantee that single lock_class_key
+ * doesn't end up with different namesm, which isn't allowed by lockdep.
+ *
+ * RETURNS:
+ * Pointer to the allocated workqueue on success, %NULL on failure.
+ */
 #ifdef CONFIG_LOCKDEP
-#define alloc_workqueue(name, flags, max_active)		\
+#define alloc_workqueue(fmt, flags, max_active, args...)	\
 ({								\
 	static struct lock_class_key __key;			\
 	const char *__lock_name;				\
 								\
-	if (__builtin_constant_p(name))				\
-		__lock_name = (name);				\
+	if (__builtin_constant_p(fmt))				\
+		__lock_name = (fmt);				\
 	else							\
-		__lock_name = #name;				\
+		__lock_name = #fmt;				\
 								\
-	__alloc_workqueue_key((name), (flags), (max_active),	\
-			      &__key, __lock_name);		\
+	__alloc_workqueue_key((fmt), (flags), (max_active),	\
+			      &__key, __lock_name, ##args);	\
 })
 #else
-#define alloc_workqueue(name, flags, max_active)		\
-	__alloc_workqueue_key((name), (flags), (max_active), NULL, NULL)
+#define alloc_workqueue(fmt, flags, max_active, args...)	\
+	__alloc_workqueue_key((fmt), (flags), (max_active),	\
+			      NULL, NULL, ##args)
 #endif
 
 /**
  * alloc_ordered_workqueue - allocate an ordered workqueue
- * @name: name of the workqueue
+ * @fmt: printf format for the name of the workqueue
  * @flags: WQ_* flags (only WQ_FREEZABLE and WQ_MEM_RECLAIM are meaningful)
+ * @args: args for @fmt
  *
  * Allocate an ordered workqueue.  An ordered workqueue executes at
  * most one work item at any given time in the queued order.  They are
@@ -331,11 +350,8 @@ __alloc_workqueue_key(const char *name, 
  * RETURNS:
  * Pointer to the allocated workqueue on success, %NULL on failure.
  */
-static inline struct workqueue_struct *
-alloc_ordered_workqueue(const char *name, unsigned int flags)
-{
-	return alloc_workqueue(name, WQ_UNBOUND | flags, 1);
-}
+#define alloc_ordered_workqueue(fmt, flags, args...)		\
+	alloc_workqueue(fmt, WQ_UNBOUND | (flags), 1, ##args)
 
 #define create_workqueue(name)					\
 	alloc_workqueue((name), WQ_MEM_RECLAIM, 1)
diff -puN kernel/workqueue.c~workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name kernel/workqueue.c
--- a/kernel/workqueue.c~workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name
+++ a/kernel/workqueue.c
@@ -242,10 +242,10 @@ struct workqueue_struct {
 
 	int			nr_drainers;	/* W: drain in progress */
 	int			saved_max_active; /* W: saved cwq max_active */
-	const char		*name;		/* I: workqueue name */
 #ifdef CONFIG_LOCKDEP
 	struct lockdep_map	lockdep_map;
 #endif
+	char			name[];		/* I: workqueue name */
 };
 
 struct workqueue_struct *system_wq __read_mostly;
@@ -2954,14 +2954,29 @@ static int wq_clamp_max_active(int max_a
 	return clamp_val(max_active, 1, lim);
 }
 
-struct workqueue_struct *__alloc_workqueue_key(const char *name,
+struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 					       unsigned int flags,
 					       int max_active,
 					       struct lock_class_key *key,
-					       const char *lock_name)
+					       const char *lock_name, ...)
 {
+	va_list args, args1;
 	struct workqueue_struct *wq;
 	unsigned int cpu;
+	size_t namelen;
+
+	/* determine namelen, allocate wq and format name */
+	va_start(args, lock_name);
+	va_copy(args1, args);
+	namelen = vsnprintf(NULL, 0, fmt, args) + 1;
+
+	wq = kzalloc(sizeof(*wq) + namelen, GFP_KERNEL);
+	if (!wq)
+		goto err;
+
+	vsnprintf(wq->name, namelen, fmt, args1);
+	va_end(args);
+	va_end(args1);
 
 	/*
 	 * Workqueues which may be used during memory reclaim should
@@ -2978,12 +2993,9 @@ struct workqueue_struct *__alloc_workque
 		flags |= WQ_HIGHPRI;
 
 	max_active = max_active ?: WQ_DFL_ACTIVE;
-	max_active = wq_clamp_max_active(max_active, flags, name);
-
-	wq = kzalloc(sizeof(*wq), GFP_KERNEL);
-	if (!wq)
-		goto err;
+	max_active = wq_clamp_max_active(max_active, flags, wq->name);
 
+	/* init wq */
 	wq->flags = flags;
 	wq->saved_max_active = max_active;
 	mutex_init(&wq->flush_mutex);
@@ -2991,7 +3003,6 @@ struct workqueue_struct *__alloc_workque
 	INIT_LIST_HEAD(&wq->flusher_queue);
 	INIT_LIST_HEAD(&wq->flusher_overflow);
 
-	wq->name = name;
 	lockdep_init_map(&wq->lockdep_map, lock_name, key, 0);
 	INIT_LIST_HEAD(&wq->list);
 
@@ -3020,7 +3031,8 @@ struct workqueue_struct *__alloc_workque
 		if (!rescuer)
 			goto err;
 
-		rescuer->task = kthread_create(rescuer_thread, wq, "%s", name);
+		rescuer->task = kthread_create(rescuer_thread, wq, "%s",
+					       wq->name);
 		if (IS_ERR(rescuer->task))
 			goto err;
 
_
Subject: Subject: workqueue: make alloc_workqueue() take printf fmt and args for name

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
drivers-scsi-osd-osd_uldc-use-ida_simple_get-to-handle-id.patch
procfs-make-proc_get_link-to-use-dentry-instead-of-inode.patch
procfs-introduce-the-proc-pid-map_files-directory.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update.patch
scatterlist-new-helper-functions-update-fix.patch

