From: akpm@linux-foundation.org
Subject: - lists-add-list-splice-tail.patch removed from -mm tree
Date: Mon, 26 Mar 2007 15:37:13 -0700
Message-ID: <200703262237.l2QMbEVp032420@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56491 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933736AbXCZWhZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2007 18:37:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, akpm@linux-foundation.org, kernel@kolivas.org, mingo@elte.hu, nickpiggin@yahoo.com.au, suresh.b.siddha@intel.com, mm-commits@vger.kernel.org


The patch titled
     lists: add list splice tail
has been removed from the -mm tree.  Its filename was
     lists-add-list-splice-tail.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: lists: add list splice tail
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Add a list_splice_tail variant of list_splice.

Signed-off-by: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list.h |   42 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff -puN include/linux/list.h~lists-add-list-splice-tail include/linux/list.h
--- a/include/linux/list.h~lists-add-list-splice-tail
+++ a/include/linux/list.h
@@ -333,6 +333,20 @@ static inline void __list_splice(struct 
 	at->prev = last;
 }
 
+static inline void __list_splice_tail(struct list_head *list,
+				      struct list_head *head)
+{
+	struct list_head *first = list->next;
+	struct list_head *last = list->prev;
+	struct list_head *at = head->prev;
+
+	first->prev = at;
+	at->next = first;
+
+	last->next = head;
+	head->prev = last;
+}
+
 /**
  * list_splice - join two lists
  * @list: the new list to add.
@@ -345,6 +359,18 @@ static inline void list_splice(struct li
 }
 
 /**
+ * list_splice_tail - join two lists at one's tail
+ * @list: the new list to add.
+ * @head: the place to add it in the first list.
+ */
+static inline void list_splice_tail(struct list_head *list,
+				    struct list_head *head)
+{
+	if (!list_empty(list))
+		__list_splice_tail(list, head);
+}
+
+/**
  * list_splice_init - join two lists and reinitialise the emptied list.
  * @list: the new list to add.
  * @head: the place to add it in the first list.
@@ -417,6 +443,22 @@ static inline void list_splice_init_rcu(
 }
 
 /**
+ * list_splice_tail_init - join 2 lists at one's tail & reinitialise emptied
+ * @list: the new list to add.
+ * @head: the place to add it in the first list.
+ *
+ * The list at @list is reinitialised
+ */
+static inline void list_splice_tail_init(struct list_head *list,
+					 struct list_head *head)
+{
+	if (!list_empty(list)) {
+		__list_splice_tail(list, head);
+		INIT_LIST_HEAD(list);
+	}
+}
+
+/**
  * list_entry - get the struct for this entry
  * @ptr:	the &struct list_head pointer.
  * @type:	the type of the struct this is embedded in.
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

lumpy-reclaim-v4.patch
exec-fix-remove_arg_zero-add-comment.patch
lists-add-list-splice-tail.patch
nfs-fix-congestion-control-use-atomic_longs.patch
