From: akpm@linux-foundation.org
Subject: [merged]
 fput-turn-list_head-delayed_fput_list-into-llist_head.patch removed from
 -mm tree
Date: Mon, 15 Jul 2013 13:49:35 -0700
Message-ID: <51e4605f.ngaCk8xgpYnLHsma%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49293 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab3GOUtg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Jul 2013 16:49:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ying.huang@intel.com, viro@zeniv.linux.org.uk, ebiederm@xmission.com, dhowells@redhat.com, avagin@openvz.org, akpm@linux-foundation.org, a.p.zijlstra@chello.nl, oleg@redhat.com

Subject: [merged] fput-turn-list_head-delayed_fput_list-into-llist_head.patch removed from -mm tree
To: oleg@redhat.com,a.p.zijlstra@chello.nl,akpm@linux-foundation.org,avagin@openvz.org,dhowells@redhat.com,ebiederm@xmission.com,viro@zeniv.linux.org.uk,ying.huang@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 15 Jul 2013 13:49:35 -0700


The patch titled
     Subject: fput: turn "list_head delayed_fput_list" into llist_head
has been removed from the -mm tree.  Its filename was
     fput-turn-list_head-delayed_fput_list-into-llist_head.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: fput: turn "list_head delayed_fput_list" into llist_head

fput() and delayed_fput() can use llist and avoid the locking.

This is unlikely path, it is not that this change can improve
the performance, but this way the code looks simpler.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/file_table.c    |   25 ++++++++++---------------
 include/linux/fs.h |    2 ++
 2 files changed, 12 insertions(+), 15 deletions(-)

diff -puN fs/file_table.c~fput-turn-list_head-delayed_fput_list-into-llist_head fs/file_table.c
--- a/fs/file_table.c~fput-turn-list_head-delayed_fput_list-into-llist_head
+++ a/fs/file_table.c
@@ -265,18 +265,15 @@ static void __fput(struct file *file)
 	mntput(mnt);
 }
 
-static DEFINE_SPINLOCK(delayed_fput_lock);
-static LIST_HEAD(delayed_fput_list);
+static LLIST_HEAD(delayed_fput_list);
 static void delayed_fput(struct work_struct *unused)
 {
-	LIST_HEAD(head);
-	spin_lock_irq(&delayed_fput_lock);
-	list_splice_init(&delayed_fput_list, &head);
-	spin_unlock_irq(&delayed_fput_lock);
-	while (!list_empty(&head)) {
-		struct file *f = list_first_entry(&head, struct file, f_u.fu_list);
-		list_del_init(&f->f_u.fu_list);
-		__fput(f);
+	struct llist_node *node = llist_del_all(&delayed_fput_list);
+	struct llist_node *next;
+
+	for (; node; node = next) {
+		next = llist_next(node);
+		__fput(llist_entry(node, struct file, f_u.fu_llist));
 	}
 }
 
@@ -306,7 +303,6 @@ void fput(struct file *file)
 {
 	if (atomic_long_dec_and_test(&file->f_count)) {
 		struct task_struct *task = current;
-		unsigned long flags;
 
 		file_sb_list_del(file);
 		if (likely(!in_interrupt() && !(task->flags & PF_KTHREAD))) {
@@ -320,10 +316,9 @@ void fput(struct file *file)
 			 * fput to avoid leaking *file.
 			 */
 		}
-		spin_lock_irqsave(&delayed_fput_lock, flags);
-		list_add(&file->f_u.fu_list, &delayed_fput_list);
-		schedule_work(&delayed_fput_work);
-		spin_unlock_irqrestore(&delayed_fput_lock, flags);
+
+		if (llist_add(&file->f_u.fu_llist, &delayed_fput_list))
+			schedule_work(&delayed_fput_work);
 	}
 }
 
diff -puN include/linux/fs.h~fput-turn-list_head-delayed_fput_list-into-llist_head include/linux/fs.h
--- a/include/linux/fs.h~fput-turn-list_head-delayed_fput_list-into-llist_head
+++ a/include/linux/fs.h
@@ -10,6 +10,7 @@
 #include <linux/stat.h>
 #include <linux/cache.h>
 #include <linux/list.h>
+#include <linux/llist.h>
 #include <linux/radix-tree.h>
 #include <linux/rbtree.h>
 #include <linux/init.h>
@@ -767,6 +768,7 @@ struct file {
 	 */
 	union {
 		struct list_head	fu_list;
+		struct llist_node	fu_llist;
 		struct rcu_head 	fu_rcuhead;
 	} f_u;
 	struct path		f_path;
_

Patches currently in -mm which might be from oleg@redhat.com are

mm-mempolicy-fix-mbind_range-vma_adjust-interaction.patch
include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
mm-mempolicy-turn-vma_set_policy-into-vma_dup_policy.patch
kernel-wide-fix-missing-validations-on-__get-__put-__copy_to-__copy_from_user.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
signals-eventpoll-set-saved_sigmask-at-the-start.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch

