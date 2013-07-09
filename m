From: akpm@linux-foundation.org
Subject: [merged]
 vfree-dont-schedule-free_work-if-llist_add-returns-false.patch removed from -mm tree
Date: Tue, 09 Jul 2013 16:19:57 -0700
Message-ID: <51dc9a9d.JjaL8Ju74P0+dmPt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38865 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab3GIXT5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:19:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, oleg@redhat.com

Subject: [merged] vfree-dont-schedule-free_work-if-llist_add-returns-false.patch removed from -mm tree
To: oleg@redhat.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:19:57 -0700


The patch titled
     Subject: vfree: don't schedule free_work() if llist_add() returns false
has been removed from the -mm tree.  Its filename was
     vfree-dont-schedule-free_work-if-llist_add-returns-false.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: vfree: don't schedule free_work() if llist_add() returns false

vfree() only needs schedule_work(&p->wq) if p->list was empty, otherwise
vfree_deferred->wq is already pending or it is running and didn't do
llist_del_all() yet.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/vmalloc.c~vfree-dont-schedule-free_work-if-llist_add-returns-false mm/vmalloc.c
--- a/mm/vmalloc.c~vfree-dont-schedule-free_work-if-llist_add-returns-false
+++ a/mm/vmalloc.c
@@ -1477,7 +1477,6 @@ static void __vunmap(const void *addr, i
  *	conventions for vfree() arch-depenedent would be a really bad idea)
  *
  *	NOTE: assumes that the object at *addr has a size >= sizeof(llist_node)
- *	
  */
 void vfree(const void *addr)
 {
@@ -1489,8 +1488,8 @@ void vfree(const void *addr)
 		return;
 	if (unlikely(in_interrupt())) {
 		struct vfree_deferred *p = &__get_cpu_var(vfree_deferred);
-		llist_add((struct llist_node *)addr, &p->list);
-		schedule_work(&p->wq);
+		if (llist_add((struct llist_node *)addr, &p->list))
+			schedule_work(&p->wq);
 	} else
 		__vunmap(addr, 1);
 }
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
mm-mempolicy-fix-mbind_range-vma_adjust-interaction.patch
include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
fput-task_work_add-can-fail-if-the-caller-has-passed-exit_task_work-fix.patch
fput-turn-list_head-delayed_fput_list-into-llist_head.patch
llist-fix-simplify-llist_add-and-llist_add_batch.patch
llist-llist_add-can-use-llist_add_batch.patch
kernel-wide-fix-missing-validations-on-__get-__put-__copy_to-__copy_from_user.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
signals-eventpoll-set-saved_sigmask-at-the-start.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch

