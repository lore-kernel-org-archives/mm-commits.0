From: akpm@google.com
Subject: [merged] llist-return-whether-list-is-empty-before-adding-in-llist_add.patch removed from -mm tree
Date: Wed, 05 Oct 2011 12:12:55 -0700
Message-ID: <201110051912.p95JCtxo030549@wpaz33.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:29282 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933236Ab1JETND (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Oct 2011 15:13:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, mathieu.desnoyers@efficios.com, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: llist: return whether list is empty before adding in llist_add
has been removed from the -mm tree.  Its filename was
     llist-return-whether-list-is-empty-before-adding-in-llist_add.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: llist: return whether list is empty before adding in llist_add

This is needed by irq_work.  And because list_add_xxx functions are
inline, this can be optimized out if not needed by callers.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/llist.h |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN include/linux/llist.h~llist-return-whether-list-is-empty-before-adding-in-llist_add include/linux/llist.h
--- a/include/linux/llist.h~llist-return-whether-list-is-empty-before-adding-in-llist_add
+++ a/include/linux/llist.h
@@ -150,8 +150,10 @@ static inline bool llist_empty(const str
  * llist_add - add a new entry
  * @new:	new entry to be added
  * @head:	the head for your lock-less list
+ *
+ * Return whether list is empty before adding.
  */
-static inline void llist_add(struct llist_node *new, struct llist_head *head)
+static inline bool llist_add(struct llist_node *new, struct llist_head *head)
 {
 	struct llist_node *entry, *old_entry;
 
@@ -166,6 +168,8 @@ static inline void llist_add(struct llis
 			break;
 		cpu_relax();
 	}
+
+	return old_entry == NULL;
 }
 
 /**
@@ -173,8 +177,10 @@ static inline void llist_add(struct llis
  * @new_first:	first entry in batch to be added
  * @new_last:	last entry in batch to be added
  * @head:	the head for your lock-less list
+ *
+ * Return whether list is empty before adding.
  */
-static inline void llist_add_batch(struct llist_node *new_first,
+static inline bool llist_add_batch(struct llist_node *new_first,
 				   struct llist_node *new_last,
 				   struct llist_head *head)
 {
@@ -191,6 +197,8 @@ static inline void llist_add_batch(struc
 			break;
 		cpu_relax();
 	}
+
+	return old_entry == NULL;
 }
 
 /**
_

Patches currently in -mm which might be from ying.huang@intel.com are

linux-next.patch
lib-bitmapc-quiet-sparse-noise-about-address-space.patch
lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch
llist-return-whether-list-is-empty-before-adding-in-llist_add-fix.patch

