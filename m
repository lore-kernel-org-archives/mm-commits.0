From: akpm@linux-foundation.org
Subject: + introduce-a-handy-list_first_entry-macro-v2.patch added to -mm tree
Date: Thu, 19 Apr 2007 22:24:13 -0700
Message-ID: <200704200524.l3K5ODEB007644@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46502 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030748AbXDTFZZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 01:25:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@sw.ru, andi@firstfloor.org, davidel@xmailserver.org, dev@openvz.org, johnstul@us.ibm.com, linuxram@us.ibm.com, mingo@elte.hu, randy.dunlap@oracle.com, tglx@linutronix.de, ttb@tentacle.dhs.org, xemul@openvz.org, zach.brown@oracle.com


The patch titled
     Introduce a handy list_first_entry macro
has been added to the -mm tree.  Its filename is
     introduce-a-handy-list_first_entry-macro-v2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Introduce a handy list_first_entry macro
From: Pavel Emelianov <xemul@sw.ru>

There are many places in the kernel where the construction like

   foo = list_entry(head->next, struct foo_struct, list);

are used.
The code might look more descriptive and neat if using the macro

   list_first_entry(head, type, member) \
             list_entry((head)->next, type, member)

Here is the macro itself and the examples of its usage in the generic code.
 If it will turn out to be useful, I can prepare the set of patches to
inject in into arch-specific code, drivers, networking, etc.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>
Signed-off-by: Kirill Korotaev <dev@openvz.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: John McCutchan <ttb@tentacle.dhs.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Ram Pai <linuxram@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dquot.c                |    2 +-
 fs/eventpoll.c            |    6 +++---
 fs/inode.c                |    2 +-
 fs/inotify.c              |    2 +-
 fs/namespace.c            |    4 ++--
 fs/pnode.c                |    2 +-
 include/linux/list.h      |   11 +++++++++++
 kernel/posix-cpu-timers.c |   14 +++++++-------
 kernel/timer.c            |    4 ++--
 9 files changed, 29 insertions(+), 18 deletions(-)

diff -puN fs/dquot.c~introduce-a-handy-list_first_entry-macro-v2 fs/dquot.c
--- a/fs/dquot.c~introduce-a-handy-list_first_entry-macro-v2
+++ a/fs/dquot.c
@@ -474,7 +474,7 @@ int vfs_quota_sync(struct super_block *s
 		spin_lock(&dq_list_lock);
 		dirty = &dqopt->info[cnt].dqi_dirty_list;
 		while (!list_empty(dirty)) {
-			dquot = list_entry(dirty->next, struct dquot, dq_dirty);
+			dquot = list_first_entry(dirty, struct dquot, dq_dirty);
 			/* Dirty and inactive can be only bad dquot... */
 			if (!test_bit(DQ_ACTIVE_B, &dquot->dq_flags)) {
 				clear_dquot_dirty(dquot);
diff -puN fs/eventpoll.c~introduce-a-handy-list_first_entry-macro-v2 fs/eventpoll.c
--- a/fs/eventpoll.c~introduce-a-handy-list_first_entry-macro-v2
+++ a/fs/eventpoll.c
@@ -453,7 +453,7 @@ void eventpoll_release_file(struct file 
 	mutex_lock(&epmutex);
 
 	while (!list_empty(lsthead)) {
-		epi = list_entry(lsthead->next, struct epitem, fllink);
+		epi = list_first_entry(lsthead, struct epitem, fllink);
 
 		ep = epi->ep;
 		list_del_init(&epi->fllink);
@@ -1143,7 +1143,7 @@ static void ep_unregister_pollwait(struc
 
 	if (nwait) {
 		while (!list_empty(lsthead)) {
-			pwq = list_entry(lsthead->next, struct eppoll_entry, llink);
+			pwq = list_first_entry(lsthead, struct eppoll_entry, llink);
 
 			list_del_init(&pwq->llink);
 			remove_wait_queue(pwq->whead, &pwq->wait);
@@ -1359,7 +1359,7 @@ static int ep_send_events(struct eventpo
 	 * read.
 	 */
 	for (eventcnt = 0; !list_empty(txlist) && eventcnt < maxevents;) {
-		epi = list_entry(txlist->next, struct epitem, rdllink);
+		epi = list_first_entry(txlist, struct epitem, rdllink);
 		prefetch(epi->rdllink.next);
 
 		/*
diff -puN fs/inode.c~introduce-a-handy-list_first_entry-macro-v2 fs/inode.c
--- a/fs/inode.c~introduce-a-handy-list_first_entry-macro-v2
+++ a/fs/inode.c
@@ -276,7 +276,7 @@ static void dispose_list(struct list_hea
 	while (!list_empty(head)) {
 		struct inode *inode;
 
-		inode = list_entry(head->next, struct inode, i_list);
+		inode = list_first_entry(head, struct inode, i_list);
 		list_del(&inode->i_list);
 
 		if (inode->i_data.nrpages)
diff -puN fs/inotify.c~introduce-a-handy-list_first_entry-macro-v2 fs/inotify.c
--- a/fs/inotify.c~introduce-a-handy-list_first_entry-macro-v2
+++ a/fs/inotify.c
@@ -509,7 +509,7 @@ void inotify_destroy(struct inotify_hand
 			mutex_unlock(&ih->mutex);
 			break;
 		}
-		watch = list_entry(watches->next, struct inotify_watch, h_list);
+		watch = list_first_entry(watches, struct inotify_watch, h_list);
 		get_inotify_watch(watch);
 		mutex_unlock(&ih->mutex);
 
diff -puN fs/namespace.c~introduce-a-handy-list_first_entry-macro-v2 fs/namespace.c
--- a/fs/namespace.c~introduce-a-handy-list_first_entry-macro-v2
+++ a/fs/namespace.c
@@ -518,7 +518,7 @@ void release_mounts(struct list_head *he
 {
 	struct vfsmount *mnt;
 	while (!list_empty(head)) {
-		mnt = list_entry(head->next, struct vfsmount, mnt_hash);
+		mnt = list_first_entry(head, struct vfsmount, mnt_hash);
 		list_del_init(&mnt->mnt_hash);
 		if (mnt->mnt_parent != mnt) {
 			struct dentry *dentry;
@@ -1196,7 +1196,7 @@ static void expire_mount_list(struct lis
 
 	while (!list_empty(graveyard)) {
 		LIST_HEAD(umounts);
-		mnt = list_entry(graveyard->next, struct vfsmount, mnt_expire);
+		mnt = list_first_entry(graveyard, struct vfsmount, mnt_expire);
 		list_del_init(&mnt->mnt_expire);
 
 		/* don't do anything if the namespace is dead - all the
diff -puN fs/pnode.c~introduce-a-handy-list_first_entry-macro-v2 fs/pnode.c
--- a/fs/pnode.c~introduce-a-handy-list_first_entry-macro-v2
+++ a/fs/pnode.c
@@ -59,7 +59,7 @@ static int do_make_slave(struct vfsmount
 	} else {
 		struct list_head *p = &mnt->mnt_slave_list;
 		while (!list_empty(p)) {
-                        slave_mnt = list_entry(p->next,
+                        slave_mnt = list_first_entry(p,
 					struct vfsmount, mnt_slave);
 			list_del_init(&slave_mnt->mnt_slave);
 			slave_mnt->mnt_master = NULL;
diff -puN include/linux/list.h~introduce-a-handy-list_first_entry-macro-v2 include/linux/list.h
--- a/include/linux/list.h~introduce-a-handy-list_first_entry-macro-v2
+++ a/include/linux/list.h
@@ -426,6 +426,17 @@ static inline void list_splice_init_rcu(
 	container_of(ptr, type, member)
 
 /**
+ * list_first_entry - get the first element from a list
+ * @ptr:	the list head to take the element from.
+ * @type:	the type of the struct this is embedded in.
+ * @member:	the name of the list_struct within the struct.
+ *
+ * Note, that list is expected to be not empty.
+ */
+#define list_first_entry(ptr, type, member) \
+	list_entry((ptr)->next, type, member)
+
+/**
  * list_for_each	-	iterate over a list
  * @pos:	the &struct list_head to use as a loop cursor.
  * @head:	the head for your list.
diff -puN kernel/posix-cpu-timers.c~introduce-a-handy-list_first_entry-macro-v2 kernel/posix-cpu-timers.c
--- a/kernel/posix-cpu-timers.c~introduce-a-handy-list_first_entry-macro-v2
+++ a/kernel/posix-cpu-timers.c
@@ -971,7 +971,7 @@ static void check_thread_timers(struct t
 	maxfire = 20;
 	tsk->it_prof_expires = cputime_zero;
 	while (!list_empty(timers)) {
-		struct cpu_timer_list *t = list_entry(timers->next,
+		struct cpu_timer_list *t = list_first_entry(timers,
 						      struct cpu_timer_list,
 						      entry);
 		if (!--maxfire || cputime_lt(prof_ticks(tsk), t->expires.cpu)) {
@@ -986,7 +986,7 @@ static void check_thread_timers(struct t
 	maxfire = 20;
 	tsk->it_virt_expires = cputime_zero;
 	while (!list_empty(timers)) {
-		struct cpu_timer_list *t = list_entry(timers->next,
+		struct cpu_timer_list *t = list_first_entry(timers,
 						      struct cpu_timer_list,
 						      entry);
 		if (!--maxfire || cputime_lt(virt_ticks(tsk), t->expires.cpu)) {
@@ -1001,7 +1001,7 @@ static void check_thread_timers(struct t
 	maxfire = 20;
 	tsk->it_sched_expires = 0;
 	while (!list_empty(timers)) {
-		struct cpu_timer_list *t = list_entry(timers->next,
+		struct cpu_timer_list *t = list_first_entry(timers,
 						      struct cpu_timer_list,
 						      entry);
 		if (!--maxfire || tsk->sched_time < t->expires.sched) {
@@ -1057,7 +1057,7 @@ static void check_process_timers(struct 
 	maxfire = 20;
 	prof_expires = cputime_zero;
 	while (!list_empty(timers)) {
-		struct cpu_timer_list *t = list_entry(timers->next,
+		struct cpu_timer_list *t = list_first_entry(timers,
 						      struct cpu_timer_list,
 						      entry);
 		if (!--maxfire || cputime_lt(ptime, t->expires.cpu)) {
@@ -1072,7 +1072,7 @@ static void check_process_timers(struct 
 	maxfire = 20;
 	virt_expires = cputime_zero;
 	while (!list_empty(timers)) {
-		struct cpu_timer_list *t = list_entry(timers->next,
+		struct cpu_timer_list *t = list_first_entry(timers,
 						      struct cpu_timer_list,
 						      entry);
 		if (!--maxfire || cputime_lt(utime, t->expires.cpu)) {
@@ -1087,7 +1087,7 @@ static void check_process_timers(struct 
 	maxfire = 20;
 	sched_expires = 0;
 	while (!list_empty(timers)) {
-		struct cpu_timer_list *t = list_entry(timers->next,
+		struct cpu_timer_list *t = list_first_entry(timers,
 						      struct cpu_timer_list,
 						      entry);
 		if (!--maxfire || sched_time < t->expires.sched) {
@@ -1400,7 +1400,7 @@ void set_process_cpu_timer(struct task_s
 	 */
 	head = &tsk->signal->cpu_timers[clock_idx];
 	if (list_empty(head) ||
-	    cputime_ge(list_entry(head->next,
+	    cputime_ge(list_first_entry(head,
 				  struct cpu_timer_list, entry)->expires.cpu,
 		       *newval)) {
 		/*
diff -puN kernel/timer.c~introduce-a-handy-list_first_entry-macro-v2 kernel/timer.c
--- a/kernel/timer.c~introduce-a-handy-list_first_entry-macro-v2
+++ a/kernel/timer.c
@@ -627,7 +627,7 @@ static inline void __run_timers(tvec_bas
 			void (*fn)(unsigned long);
 			unsigned long data;
 
-			timer = list_entry(head->next,struct timer_list,entry);
+			timer = list_first_entry(head, struct timer_list,entry);
  			fn = timer->function;
  			data = timer->data;
 
@@ -1246,7 +1246,7 @@ static void migrate_timer_list(tvec_base
 	struct timer_list *timer;
 
 	while (!list_empty(head)) {
-		timer = list_entry(head->next, struct timer_list, entry);
+		timer = list_first_entry(head, struct timer_list, entry);
 		detach_timer(timer, 0);
 		timer_set_base(timer, new_base);
 		internal_add_timer(new_base, timer);
_

Patches currently in -mm which might be from xemul@sw.ru are

origin.patch
lockdep-treats-down_write_trylock-like-regular-down_write.patch
introduce-a-handy-list_first_entry-macro-v2.patch
