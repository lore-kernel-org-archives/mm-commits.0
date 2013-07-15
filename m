From: akpm@linux-foundation.org
Subject: [merged] llist-fix-simplify-llist_add-and-llist_add_batch.patch
 removed from -mm tree
Date: Mon, 15 Jul 2013 13:49:37 -0700
Message-ID: <51e46061.HPSVKt98ATVxMDtg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49301 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab3GOUti (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Jul 2013 16:49:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ying.huang@intel.com, viro@zeniv.linux.org.uk, ebiederm@xmission.com, dhowells@redhat.com, avagin@openvz.org, a.p.zijlstra@chello.nl, oleg@redhat.com

Subject: [merged] llist-fix-simplify-llist_add-and-llist_add_batch.patch removed from -mm tree
To: oleg@redhat.com,a.p.zijlstra@chello.nl,avagin@openvz.org,dhowells@redhat.com,ebiederm@xmission.com,viro@zeniv.linux.org.uk,ying.huang@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 15 Jul 2013 13:49:37 -0700


The patch titled
     Subject: llist: fix/simplify llist_add() and llist_add_batch()
has been removed from the -mm tree.  Its filename was
     llist-fix-simplify-llist_add-and-llist_add_batch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: llist: fix/simplify llist_add() and llist_add_batch()

1. This is mostly theoretical, but llist_add*() need ACCESS_ONCE().

   Otherwise it is not guaranteed that the first cmpxchg() uses the
   same value for old_entry and new_last->next.

2. These helpers cache the result of cmpxchg() and read the initial
   value of head->first before the main loop. I do not think this
   makes sense. In the likely case cmpxchg() succeeds, otherwise
   it doesn't hurt to reload head->first.

   I think it would be better to simplify the code and simply read
   ->first before cmpxchg().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/llist.h |   15 +++++----------
 lib/llist.c           |   15 +++++----------
 2 files changed, 10 insertions(+), 20 deletions(-)

diff -puN include/linux/llist.h~llist-fix-simplify-llist_add-and-llist_add_batch include/linux/llist.h
--- a/include/linux/llist.h~llist-fix-simplify-llist_add-and-llist_add_batch
+++ a/include/linux/llist.h
@@ -151,18 +151,13 @@ static inline struct llist_node *llist_n
  */
 static inline bool llist_add(struct llist_node *new, struct llist_head *head)
 {
-	struct llist_node *entry, *old_entry;
+	struct llist_node *first;
 
-	entry = head->first;
-	for (;;) {
-		old_entry = entry;
-		new->next = entry;
-		entry = cmpxchg(&head->first, old_entry, new);
-		if (entry == old_entry)
-			break;
-	}
+	do {
+		new->next = first = ACCESS_ONCE(head->first);
+	} while (cmpxchg(&head->first, first, new) != first);
 
-	return old_entry == NULL;
+	return !first;
 }
 
 /**
diff -puN lib/llist.c~llist-fix-simplify-llist_add-and-llist_add_batch lib/llist.c
--- a/lib/llist.c~llist-fix-simplify-llist_add-and-llist_add_batch
+++ a/lib/llist.c
@@ -39,18 +39,13 @@
 bool llist_add_batch(struct llist_node *new_first, struct llist_node *new_last,
 		     struct llist_head *head)
 {
-	struct llist_node *entry, *old_entry;
+	struct llist_node *first;
 
-	entry = head->first;
-	for (;;) {
-		old_entry = entry;
-		new_last->next = entry;
-		entry = cmpxchg(&head->first, old_entry, new_first);
-		if (entry == old_entry)
-			break;
-	}
+	do {
+		new_last->next = first = ACCESS_ONCE(head->first);
+	} while (cmpxchg(&head->first, first, new_first) != first);
 
-	return old_entry == NULL;
+	return !first;
 }
 EXPORT_SYMBOL_GPL(llist_add_batch);
 
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

