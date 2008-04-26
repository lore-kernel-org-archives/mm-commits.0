From: akpm@linux-foundation.org
Subject: - rculisth-use-the-rcu-api.patch removed from -mm tree
Date: Sat, 26 Apr 2008 07:22:26 -0700
Message-ID: <200804261422.m3QEMQpX025970@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46373 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752536AbYDZOX1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Apr 2008 10:23:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fbuihuu@gmail.com, josh@kernel.org, paulmck@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     rculist.h: use the rcu API
has been removed from the -mm tree.  Its filename was
     rculisth-use-the-rcu-api.patch

This patch was dropped because Linus changes wrecked it

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rculist.h: use the rcu API
From: Franck Bui-Huu <fbuihuu@gmail.com>

Make almost all list mutation primitives use rcu_assign_pointer().

The main point of this being readability improvement.

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Josh Triplett <josh@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rculist.h |   23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff -puN include/linux/rculist.h~rculisth-use-the-rcu-api include/linux/rculist.h
--- a/include/linux/rculist.h~rculisth-use-the-rcu-api
+++ a/include/linux/rculist.h
@@ -7,6 +7,7 @@
  * RCU-protected list version
  */
 #include <linux/list.h>
+#include <linux/rcupdate.h>
 
 /*
  * Insert a new entry between two known consecutive entries.
@@ -19,9 +20,8 @@ static inline void __list_add_rcu(struct
 {
 	new->next = next;
 	new->prev = prev;
-	smp_wmb();
+	rcu_assign_pointer(prev->next, new);
 	next->prev = new;
-	prev->next = new;
 }
 
 /**
@@ -110,9 +110,8 @@ static inline void list_replace_rcu(stru
 {
 	new->next = old->next;
 	new->prev = old->prev;
-	smp_wmb();
+	rcu_assign_pointer(new->prev->next, new);
 	new->next->prev = new;
-	new->prev->next = new;
 	old->prev = LIST_POISON2;
 }
 
@@ -166,8 +165,7 @@ static inline void list_splice_init_rcu(
 	 */
 
 	last->next = at;
-	smp_wmb();
-	head->next = first;
+	rcu_assign_pointer(head->next, first);
 	first->prev = head;
 	at->prev = last;
 }
@@ -280,10 +278,9 @@ static inline void hlist_replace_rcu(str
 
 	new->next = next;
 	new->pprev = old->pprev;
-	smp_wmb();
+	rcu_assign_pointer(*new->pprev, new);
 	if (next)
 		new->next->pprev = &new->next;
-	*new->pprev = new;
 	old->pprev = LIST_POISON2;
 }
 
@@ -310,12 +307,12 @@ static inline void hlist_add_head_rcu(st
 					struct hlist_head *h)
 {
 	struct hlist_node *first = h->first;
+
 	n->next = first;
 	n->pprev = &h->first;
-	smp_wmb();
+	rcu_assign_pointer(h->first, n);
 	if (first)
 		first->pprev = &n->next;
-	h->first = n;
 }
 
 /**
@@ -341,9 +338,8 @@ static inline void hlist_add_before_rcu(
 {
 	n->pprev = next->pprev;
 	n->next = next;
-	smp_wmb();
+	rcu_assign_pointer(*(n->pprev), n);
 	next->pprev = &n->next;
-	*(n->pprev) = n;
 }
 
 /**
@@ -369,8 +365,7 @@ static inline void hlist_add_after_rcu(s
 {
 	n->next = prev->next;
 	n->pprev = &prev->next;
-	smp_wmb();
-	prev->next = n;
+	rcu_assign_pointer(prev->next, n);
 	if (n->next)
 		n->next->pprev = &n->next;
 }
_

Patches currently in -mm which might be from fbuihuu@gmail.com are

rculisth-use-the-rcu-api.patch

