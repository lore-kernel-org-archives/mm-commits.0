From: akpm@linux-foundation.org
Subject: + list-change-list_for_each_entry-to-use-list__entry.patch added
 to -mm tree
Date: Mon, 11 Nov 2013 15:18:53 -0800
Message-ID: <528165dd.VXek2w3/NnjKvHEj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51408 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab3KKXSy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Nov 2013 18:18:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, gregkh@linuxfoundation.org, eilong@broadcom.com, a.p.zijlstra@chello.nl, oleg@redhat.com

Subject: + list-change-list_for_each_entry-to-use-list__entry.patch added to -mm tree
To: oleg@redhat.com,a.p.zijlstra@chello.nl,eilong@broadcom.com,gregkh@linuxfoundation.org
From: akpm@linux-foundation.org
Date: Mon, 11 Nov 2013 15:18:53 -0800


The patch titled
     Subject: list: change list_for_each_entry*() to use list_*_entry()
has been added to the -mm tree.  Its filename is
     list-change-list_for_each_entry-to-use-list__entry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/list-change-list_for_each_entry-to-use-list__entry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/list-change-list_for_each_entry-to-use-list__entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: list: change list_for_each_entry*() to use list_*_entry()

Now that we have list_{next,prev}_entry() we can change
list_for_each_entry*() and list_safe_reset_next() to use the new helpers
to improve the readability.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Eilon Greenstein <eilong@broadcom.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list.h |   44 ++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff -puN include/linux/list.h~list-change-list_for_each_entry-to-use-list__entry include/linux/list.h
--- a/include/linux/list.h~list-change-list_for_each_entry-to-use-list__entry
+++ a/include/linux/list.h
@@ -433,8 +433,8 @@ static inline void list_splice_tail_init
  */
 #define list_for_each_entry(pos, head, member)				\
 	for (pos = list_entry((head)->next, typeof(*pos), member);	\
-	     &pos->member != (head); 	\
-	     pos = list_entry(pos->member.next, typeof(*pos), member))
+	     &pos->member != (head);					\
+	     pos = list_next_entry(pos, member))
 
 /**
  * list_for_each_entry_reverse - iterate backwards over list of given type.
@@ -444,8 +444,8 @@ static inline void list_splice_tail_init
  */
 #define list_for_each_entry_reverse(pos, head, member)			\
 	for (pos = list_entry((head)->prev, typeof(*pos), member);	\
-	     &pos->member != (head); 	\
-	     pos = list_entry(pos->member.prev, typeof(*pos), member))
+	     &pos->member != (head); 					\
+	     pos = list_prev_entry(pos, member))
 
 /**
  * list_prepare_entry - prepare a pos entry for use in list_for_each_entry_continue()
@@ -468,9 +468,9 @@ static inline void list_splice_tail_init
  * the current position.
  */
 #define list_for_each_entry_continue(pos, head, member) 		\
-	for (pos = list_entry(pos->member.next, typeof(*pos), member);	\
-	     &pos->member != (head);	\
-	     pos = list_entry(pos->member.next, typeof(*pos), member))
+	for (pos = list_next_entry(pos, member);			\
+	     &pos->member != (head);					\
+	     pos = list_next_entry(pos, member))
 
 /**
  * list_for_each_entry_continue_reverse - iterate backwards from the given point
@@ -482,9 +482,9 @@ static inline void list_splice_tail_init
  * the current position.
  */
 #define list_for_each_entry_continue_reverse(pos, head, member)		\
-	for (pos = list_entry(pos->member.prev, typeof(*pos), member);	\
-	     &pos->member != (head);	\
-	     pos = list_entry(pos->member.prev, typeof(*pos), member))
+	for (pos = list_prev_entry(pos, member);			\
+	     &pos->member != (head);					\
+	     pos = list_prev_entry(pos, member))
 
 /**
  * list_for_each_entry_from - iterate over list of given type from the current point
@@ -495,8 +495,8 @@ static inline void list_splice_tail_init
  * Iterate over list of given type, continuing from current position.
  */
 #define list_for_each_entry_from(pos, head, member) 			\
-	for (; &pos->member != (head);	\
-	     pos = list_entry(pos->member.next, typeof(*pos), member))
+	for (; &pos->member != (head);					\
+	     pos = list_next_entry(pos, member))
 
 /**
  * list_for_each_entry_safe - iterate over list of given type safe against removal of list entry
@@ -507,9 +507,9 @@ static inline void list_splice_tail_init
  */
 #define list_for_each_entry_safe(pos, n, head, member)			\
 	for (pos = list_entry((head)->next, typeof(*pos), member),	\
-		n = list_entry(pos->member.next, typeof(*pos), member);	\
+		n = list_next_entry(pos, member);			\
 	     &pos->member != (head); 					\
-	     pos = n, n = list_entry(n->member.next, typeof(*n), member))
+	     pos = n, n = list_next_entry(n, member))
 
 /**
  * list_for_each_entry_safe_continue - continue list iteration safe against removal
@@ -522,10 +522,10 @@ static inline void list_splice_tail_init
  * safe against removal of list entry.
  */
 #define list_for_each_entry_safe_continue(pos, n, head, member) 		\
-	for (pos = list_entry(pos->member.next, typeof(*pos), member), 		\
-		n = list_entry(pos->member.next, typeof(*pos), member);		\
+	for (pos = list_next_entry(pos, member), 				\
+		n = list_next_entry(pos, member);				\
 	     &pos->member != (head);						\
-	     pos = n, n = list_entry(n->member.next, typeof(*n), member))
+	     pos = n, n = list_next_entry(n, member))
 
 /**
  * list_for_each_entry_safe_from - iterate over list from current point safe against removal
@@ -538,9 +538,9 @@ static inline void list_splice_tail_init
  * removal of list entry.
  */
 #define list_for_each_entry_safe_from(pos, n, head, member) 			\
-	for (n = list_entry(pos->member.next, typeof(*pos), member);		\
+	for (n = list_next_entry(pos, member);					\
 	     &pos->member != (head);						\
-	     pos = n, n = list_entry(n->member.next, typeof(*n), member))
+	     pos = n, n = list_next_entry(n, member))
 
 /**
  * list_for_each_entry_safe_reverse - iterate backwards over list safe against removal
@@ -554,9 +554,9 @@ static inline void list_splice_tail_init
  */
 #define list_for_each_entry_safe_reverse(pos, n, head, member)		\
 	for (pos = list_entry((head)->prev, typeof(*pos), member),	\
-		n = list_entry(pos->member.prev, typeof(*pos), member);	\
+		n = list_prev_entry(pos, member);			\
 	     &pos->member != (head); 					\
-	     pos = n, n = list_entry(n->member.prev, typeof(*n), member))
+	     pos = n, n = list_prev_entry(n, member))
 
 /**
  * list_safe_reset_next - reset a stale list_for_each_entry_safe loop
@@ -571,7 +571,7 @@ static inline void list_splice_tail_init
  * completing the current iteration of the loop body.
  */
 #define list_safe_reset_next(pos, n, member)				\
-	n = list_entry(pos->member.next, typeof(*pos), member)
+	n = list_next_entry(pos, member)
 
 /*
  * Double linked lists with a single pointer list head.
_

Patches currently in -mm which might be from oleg@redhat.com are

kthread-make-kthread_create-killable.patch
list-introduce-list_next_entry-and-list_prev_entry.patch
list-change-list_for_each_entry-to-use-list__entry.patch
list-introduce-list_last_entry-use-list_firstlast_entry.patch
debugfs-use-list_next_entry-in-debugfs_remove_recursive.patch
exec-ptrace-fix-get_dumpable-incorrect-tests.patch
linux-next.patch
mm-avoid-increase-sizeofstruct-page-due-to-split-page-table-lock.patch
mm-rename-use_split_ptlocks-to-use_split_pte_ptlocks.patch
mm-convert-mm-nr_ptes-to-atomic_long_t.patch
mm-introduce-api-for-split-page-table-lock-for-pmd-level.patch
mm-thp-change-pmd_trans_huge_lock-to-return-taken-lock.patch
mm-thp-move-ptl-taking-inside-page_check_address_pmd.patch
mm-thp-do-not-access-mm-pmd_huge_pte-directly.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock.patch
mm-convert-the-rest-to-new-page-table-lock-api.patch
mm-implement-split-page-table-lock-for-pmd-level.patch
x86-mm-enable-split-page-table-lock-for-pmd-level.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch

