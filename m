From: akpm@linux-foundation.org
Subject: + plist-add-helper-functions.patch added to -mm tree
Date: Mon, 12 May 2014 14:01:27 -0700
Message-ID: <537136a7.yGYheRXLN6qTz/jQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38635 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbaELVB3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 May 2014 17:01:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, weijieut@gmail.com, tglx@linutronix.de, shli@fusionio.com, rostedt@goodmis.org, riel@redhat.com, peterz@infradead.org, paul.gortmaker@windriver.com, mhocko@suse.cz, mgorman@suse.de, hughd@google.com, hannes@cmpxchg.org, ehrhardt@linux.vnet.ibm.com, bob.liu@oracle.com, ddstreet@ieee.org

Subject: + plist-add-helper-functions.patch added to -mm tree
To: ddstreet@ieee.org,bob.liu@oracle.com,ehrhardt@linux.vnet.ibm.com,hannes@cmpxchg.org,hughd@google.com,mgorman@suse.de,mhocko@suse.cz,paul.gortmaker@windriver.com,peterz@infradead.org,riel@redhat.com,rostedt@goodmis.org,shli@fusionio.com,tglx@linutronix.de,weijieut@gmail.com
From: akpm@linux-foundation.org
Date: Mon, 12 May 2014 14:01:27 -0700


The patch titled
     Subject: lib/plist: add helper functions
has been added to the -mm tree.  Its filename is
     plist-add-helper-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/plist-add-helper-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/plist-add-helper-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Streetman <ddstreet@ieee.org>
Subject: lib/plist: add helper functions

Add PLIST_HEAD() to plist.h, equivalent to LIST_HEAD() from list.h, to
define and initialize a struct plist_head.

Add plist_for_each_continue() and plist_for_each_entry_continue(),
equivalent to list_for_each_continue() and list_for_each_entry_continue(),
to iterate over a plist continuing after the current position.

Add plist_prev() and plist_next(), equivalent to (struct list_head*)->prev
and ->next, implemented by list_prev_entry() and list_next_entry(), to
access the prev/next struct plist_node entry.  These are needed because
unlike struct list_head, direct access of the prev/next struct plist_node
isn't possible; the list must be navigated via the contained struct
list_head.  e.g.  instead of accessing the prev by list_prev_entry(node,
node_list) it can be accessed by plist_prev(node).

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Shaohua Li <shli@fusionio.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Cc: Weijie Yang <weijieut@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Bob Liu <bob.liu@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/plist.h |   43 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff -puN include/linux/plist.h~plist-add-helper-functions include/linux/plist.h
--- a/include/linux/plist.h~plist-add-helper-functions
+++ a/include/linux/plist.h
@@ -98,6 +98,13 @@ struct plist_node {
 }
 
 /**
+ * PLIST_HEAD - declare and init plist_head
+ * @head:	name for struct plist_head variable
+ */
+#define PLIST_HEAD(head) \
+	struct plist_head head = PLIST_HEAD_INIT(head)
+
+/**
  * PLIST_NODE_INIT - static struct plist_node initializer
  * @node:	struct plist_node variable name
  * @__prio:	initial node priority
@@ -143,6 +150,16 @@ extern void plist_del(struct plist_node
 	 list_for_each_entry(pos, &(head)->node_list, node_list)
 
 /**
+ * plist_for_each_continue - continue iteration over the plist
+ * @pos:	the type * to use as a loop cursor
+ * @head:	the head for your list
+ *
+ * Continue to iterate over plist, continuing after the current position.
+ */
+#define plist_for_each_continue(pos, head)	\
+	 list_for_each_entry_continue(pos, &(head)->node_list, node_list)
+
+/**
  * plist_for_each_safe - iterate safely over a plist of given type
  * @pos:	the type * to use as a loop counter
  * @n:	another type * to use as temporary storage
@@ -163,6 +180,18 @@ extern void plist_del(struct plist_node
 	 list_for_each_entry(pos, &(head)->node_list, mem.node_list)
 
 /**
+ * plist_for_each_entry_continue - continue iteration over list of given type
+ * @pos:	the type * to use as a loop cursor
+ * @head:	the head for your list
+ * @m:		the name of the list_struct within the struct
+ *
+ * Continue to iterate over list of given type, continuing after
+ * the current position.
+ */
+#define plist_for_each_entry_continue(pos, head, m)	\
+	list_for_each_entry_continue(pos, &(head)->node_list, m.node_list)
+
+/**
  * plist_for_each_entry_safe - iterate safely over list of given type
  * @pos:	the type * to use as a loop counter
  * @n:		another type * to use as temporary storage
@@ -229,6 +258,20 @@ static inline int plist_node_empty(const
 #endif
 
 /**
+ * plist_next - get the next entry in list
+ * @pos:	the type * to cursor
+ */
+#define plist_next(pos) \
+	list_next_entry(pos, node_list)
+
+/**
+ * plist_prev - get the prev entry in list
+ * @pos:	the type * to cursor
+ */
+#define plist_prev(pos) \
+	list_prev_entry(pos, node_list)
+
+/**
  * plist_first - return the first node (and thus, highest priority)
  * @head:	the &struct plist_head pointer
  *
_

Patches currently in -mm which might be from ddstreet@ieee.org are

swap-change-swap_info-singly-linked-list-to-list_head.patch
plist-add-helper-functions.patch
plist-add-plist_requeue.patch
swap-change-swap_list_head-to-plist-add-swap_avail_head.patch
documentation-expand-clarify-debug-documentation.patch
lib-plistc-replace-pr_debug-with-printk-in-plist_test.patch
lib-plistc-make-config_debug_pi_list-selectable.patch

