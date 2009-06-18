From: akpm@linux-foundation.org
Subject: [merged] ptrace-mm_need_new_owner-use-real_parent-to-search-in-the-siblings.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:46:28 -0700
Message-ID: <200906182246.n5IMkSxK005491@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54774 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758990AbZFRWrO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:47:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ptrace: mm_need_new_owner: use ->real_parent to search in the siblings
has been removed from the -mm tree.  Its filename was
     ptrace-mm_need_new_owner-use-real_parent-to-search-in-the-siblings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: mm_need_new_owner: use ->real_parent to search in the siblings
From: Oleg Nesterov <oleg@redhat.com>

"Search in the siblings" should use ->real_parent, not ->parent.  If the
task is traced then ->parent == tracer, while the task's parent is always
->real_parent.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/exit.c~ptrace-mm_need_new_owner-use-real_parent-to-search-in-the-siblings kernel/exit.c
--- a/kernel/exit.c~ptrace-mm_need_new_owner-use-real_parent-to-search-in-the-siblings
+++ a/kernel/exit.c
@@ -590,7 +590,7 @@ retry:
 	/*
 	 * Search in the siblings
 	 */
-	list_for_each_entry(c, &p->parent->children, sibling) {
+	list_for_each_entry(c, &p->real_parent->children, sibling) {
 		if (c->mm == mm)
 			goto assign_new_owner;
 	}
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
ptrace-wait_task_zombie-do-not-account-traced-sub-threads.patch
linux-next.patch
rework-fix-is_single_threaded.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
signals-tracehook_notify_jctl-change.patch
utrace-core.patch

