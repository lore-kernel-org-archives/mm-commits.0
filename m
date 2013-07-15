From: akpm@linux-foundation.org
Subject: [merged] llist-llist_add-can-use-llist_add_batch.patch removed
 from -mm tree
Date: Mon, 15 Jul 2013 13:49:39 -0700
Message-ID: <51e46063.yJCK6fJo3OaIpN5q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49308 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405Ab3GOUtk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Jul 2013 16:49:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ying.huang@intel.com, viro@zeniv.linux.org.uk, ebiederm@xmission.com, dhowells@redhat.com, avagin@openvz.org, a.p.zijlstra@chello.nl, oleg@redhat.com

Subject: [merged] llist-llist_add-can-use-llist_add_batch.patch removed from -mm tree
To: oleg@redhat.com,a.p.zijlstra@chello.nl,avagin@openvz.org,dhowells@redhat.com,ebiederm@xmission.com,viro@zeniv.linux.org.uk,ying.huang@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 15 Jul 2013 13:49:39 -0700


The patch titled
     Subject: llist: llist_add() can use llist_add_batch()
has been removed from the -mm tree.  Its filename was
     llist-llist_add-can-use-llist_add_batch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: llist: llist_add() can use llist_add_batch()

llist_add(new, head) can simply use llist_add_batch(new, new, head),
no need to duplicate the code.

This obviously uninlines llist_add() and to me this is a win. But we
can make llist_add_batch() inline if this is desirable, in this case
gcc can notice that new_first == new_last if the caller is llist_add().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/llist.h |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff -puN include/linux/llist.h~llist-llist_add-can-use-llist_add_batch include/linux/llist.h
--- a/include/linux/llist.h~llist-llist_add-can-use-llist_add_batch
+++ a/include/linux/llist.h
@@ -142,6 +142,9 @@ static inline struct llist_node *llist_n
 	return node->next;
 }
 
+extern bool llist_add_batch(struct llist_node *new_first,
+			    struct llist_node *new_last,
+			    struct llist_head *head);
 /**
  * llist_add - add a new entry
  * @new:	new entry to be added
@@ -151,13 +154,7 @@ static inline struct llist_node *llist_n
  */
 static inline bool llist_add(struct llist_node *new, struct llist_head *head)
 {
-	struct llist_node *first;
-
-	do {
-		new->next = first = ACCESS_ONCE(head->first);
-	} while (cmpxchg(&head->first, first, new) != first);
-
-	return !first;
+	return llist_add_batch(new, new, head);
 }
 
 /**
@@ -173,9 +170,6 @@ static inline struct llist_node *llist_d
 	return xchg(&head->first, NULL);
 }
 
-extern bool llist_add_batch(struct llist_node *new_first,
-			    struct llist_node *new_last,
-			    struct llist_head *head);
 extern struct llist_node *llist_del_first(struct llist_head *head);
 
 #endif /* LLIST_H */
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

