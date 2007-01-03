From: akpm@osdl.org
Subject: + add-an-rcu-version-of-list-splicing.patch added to -mm tree
Date: Wed, 03 Jan 2007 13:20:37 -0800
Message-ID: <200701032120.l03LKbGG031599@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51330 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140AbXACVUm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 3 Jan 2007 16:20:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minyard@acm.org, paulmck@linux.vnet.ibm.com


The patch titled
     add an RCU version of list splicing
has been added to the -mm tree.  Its filename is
     add-an-rcu-version-of-list-splicing.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: add an RCU version of list splicing
From: Corey Minyard <minyard@acm.org>

This patch is in support of the IPMI driver.  I have tested this with the
IPMI driver changes coming in the next patch.

Add a list_splice_init_rcu() function to splice an RCU-protected list into
another list.  This takes the sync function as an argument, so one would do
something like:

	INIT_LIST_HEAD(&list);
	list_splice_init_rcu(&source, &dest, synchronize_rcu);

The idea being to keep the RCU API proliferation down to a dull roar.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Corey Minyard <minyard@acm.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/list.h |   57 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 57 insertions(+)

diff -puN include/linux/list.h~add-an-rcu-version-of-list-splicing include/linux/list.h
--- a/include/linux/list.h~add-an-rcu-version-of-list-splicing
+++ a/include/linux/list.h
@@ -360,6 +360,63 @@ static inline void list_splice_init(stru
 }
 
 /**
+ * list_splice_init_rcu - splice an RCU-protected list into an existing list.
+ * @list:	the RCU-protected list to splice
+ * @head:	the place in the list to splice the first list into
+ * @sync:	function to sync: synchronize_rcu(), synchronize_sched(), ...
+ *
+ * @head can be RCU-read traversed concurrently with this function.
+ *
+ * Note that this function blocks.
+ *
+ * Important note: the caller must take whatever action is necessary to
+ *	prevent any other updates to @head.  In principle, it is possible
+ *	to modify the list as soon as sync() begins execution.
+ *	If this sort of thing becomes necessary, an alternative version
+ *	based on call_rcu() could be created.  But only if -really-
+ *	needed -- there is no shortage of RCU API members.
+ */
+static inline void list_splice_init_rcu(struct list_head *list,
+					struct list_head *head,
+					void (*sync)(void))
+{
+	struct list_head *first = list->next;
+	struct list_head *last = list->prev;
+	struct list_head *at = head->next;
+
+	might_sleep();
+	if (list_empty(head))
+		return;
+
+	/* "first" and "last" tracking list, so initialize it. */
+
+	INIT_LIST_HEAD(list);
+
+	/*
+	 * At this point, the list body still points to the source list.
+	 * Wait for any readers to finish using the list before splicing
+	 * the list body into the new list.  Any new readers will see
+	 * an empty list.
+	 */
+
+	sync();
+
+	/*
+	 * Readers are finished with the source list, so perform splice.
+	 * The order is important if the new list is global and accessible
+	 * to concurrent RCU readers.  Note that RCU readers are not
+	 * permitted to traverse the prev pointers without excluding
+	 * this function.
+	 */
+
+	last->next = at;
+	smp_wmb();
+	head->next = first;
+	first->prev = head;
+	at->prev = last;
+}
+
+/**
  * list_entry - get the struct for this entry
  * @ptr:	the &struct list_head pointer.
  * @type:	the type of the struct this is embedded in.
_

Patches currently in -mm which might be from minyard@acm.org are

add-an-rcu-version-of-list-splicing.patch
ipmi-fix-some-rcu-problems.patch
