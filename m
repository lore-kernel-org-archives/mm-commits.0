From: akpm@linux-foundation.org
Subject: + list-introduce-list_last_entry-use-list_firstlast_entry.patch
 added to -mm tree
Date: Mon, 11 Nov 2013 15:18:54 -0800
Message-ID: <528165de.Aj929kp7nwBaQq0/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51415 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159Ab3KKXSz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Nov 2013 18:18:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, gregkh@linuxfoundation.org, eilong@broadcom.com, a.p.zijlstra@chello.nl, oleg@redhat.com

Subject: + list-introduce-list_last_entry-use-list_firstlast_entry.patch added to -mm tree
To: oleg@redhat.com,a.p.zijlstra@chello.nl,eilong@broadcom.com,gregkh@linuxfoundation.org
From: akpm@linux-foundation.org
Date: Mon, 11 Nov 2013 15:18:54 -0800


The patch titled
     Subject: list: introduce list_last_entry(), use list_{first,last}_entry()
has been added to the -mm tree.  Its filename is
     list-introduce-list_last_entry-use-list_firstlast_entry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/list-introduce-list_last_entry-use-list_firstlast_entry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/list-introduce-list_last_entry-use-list_firstlast_entry.patch

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
Subject: list: introduce list_last_entry(), use list_{first,last}_entry()

We already have list_first_entry(), it makes sense to also add
list_last_entry() for consistency.  And we use both helpers in
list_for_each_*().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Eilon Greenstein <eilong@broadcom.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list.h |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff -puN include/linux/list.h~list-introduce-list_last_entry-use-list_firstlast_entry include/linux/list.h
--- a/include/linux/list.h~list-introduce-list_last_entry-use-list_firstlast_entry
+++ a/include/linux/list.h
@@ -362,6 +362,17 @@ static inline void list_splice_tail_init
 	list_entry((ptr)->next, type, member)
 
 /**
+ * list_last_entry - get the last element from a list
+ * @ptr:	the list head to take the element from.
+ * @type:	the type of the struct this is embedded in.
+ * @member:	the name of the list_struct within the struct.
+ *
+ * Note, that list is expected to be not empty.
+ */
+#define list_last_entry(ptr, type, member) \
+	list_entry((ptr)->prev, type, member)
+
+/**
  * list_first_entry_or_null - get the first element from a list
  * @ptr:	the list head to take the element from.
  * @type:	the type of the struct this is embedded in.
@@ -432,7 +443,7 @@ static inline void list_splice_tail_init
  * @member:	the name of the list_struct within the struct.
  */
 #define list_for_each_entry(pos, head, member)				\
-	for (pos = list_entry((head)->next, typeof(*pos), member);	\
+	for (pos = list_first_entry(head, typeof(*pos), member);	\
 	     &pos->member != (head);					\
 	     pos = list_next_entry(pos, member))
 
@@ -443,7 +454,7 @@ static inline void list_splice_tail_init
  * @member:	the name of the list_struct within the struct.
  */
 #define list_for_each_entry_reverse(pos, head, member)			\
-	for (pos = list_entry((head)->prev, typeof(*pos), member);	\
+	for (pos = list_last_entry(head, typeof(*pos), member);		\
 	     &pos->member != (head); 					\
 	     pos = list_prev_entry(pos, member))
 
@@ -506,7 +517,7 @@ static inline void list_splice_tail_init
  * @member:	the name of the list_struct within the struct.
  */
 #define list_for_each_entry_safe(pos, n, head, member)			\
-	for (pos = list_entry((head)->next, typeof(*pos), member),	\
+	for (pos = list_first_entry(head, typeof(*pos), member),	\
 		n = list_next_entry(pos, member);			\
 	     &pos->member != (head); 					\
 	     pos = n, n = list_next_entry(n, member))
@@ -553,7 +564,7 @@ static inline void list_splice_tail_init
  * of list entry.
  */
 #define list_for_each_entry_safe_reverse(pos, n, head, member)		\
-	for (pos = list_entry((head)->prev, typeof(*pos), member),	\
+	for (pos = list_last_entry(head, typeof(*pos), member),		\
 		n = list_prev_entry(pos, member);			\
 	     &pos->member != (head); 					\
 	     pos = n, n = list_prev_entry(n, member))
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

