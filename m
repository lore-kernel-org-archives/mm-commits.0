From: akpm@linux-foundation.org
Subject: + llist-return-whether-list-is-empty-before-adding-in-llist_add.patch added to -mm tree
Date: Thu, 08 Sep 2011 16:56:06 -0700
Message-ID: <201109082356.p88Nu6t4015978@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59842 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753130Ab1IHX4S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Sep 2011 19:56:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ying.huang@intel.com, mathieu.desnoyers@efficios.com, peterz@infradead.org


The patch titled
     llist: return whether list is empty before adding in llist_add
has been added to the -mm tree.  Its filename is
     llist-return-whether-list-is-empty-before-adding-in-llist_add.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: llist: return whether list is empty before adding in llist_add
From: Huang Ying <ying.huang@intel.com>

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
@@ -148,8 +148,10 @@ static inline bool llist_empty(const str
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
 
@@ -164,6 +166,8 @@ static inline void llist_add(struct llis
 			break;
 		cpu_relax();
 	}
+
+	return old_entry == NULL;
 }
 
 /**
@@ -171,8 +175,10 @@ static inline void llist_add(struct llis
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
@@ -189,6 +195,8 @@ static inline void llist_add_batch(struc
 			break;
 		cpu_relax();
 	}
+
+	return old_entry == NULL;
 }
 
 /**
_

Patches currently in -mm which might be from ying.huang@intel.com are

llist-make-all-llist-functions-inline.patch
llist-define-macro-to-check-nmi-safe-cmpxchg.patch
llist-move-cpu_relax-after-cmpxchg.patch
llist-return-whether-list-is-empty-before-adding-in-llist_add.patch
llist-return-whether-list-is-empty-before-adding-in-llist_add-fix.patch
kernel-irq_workc-use-llist.patch
net-rds-replace-xlist-in-net-rds-xlisth-with-llist.patch
lib-bitmapc-quiet-sparse-noise-about-address-space.patch
lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch

