From: akpm@linux-foundation.org
Subject: + rculisth-use-the-rcu-api.patch added to -mm tree
Date: Thu, 15 May 2008 16:16:42 -0700
Message-ID: <200805152316.m4FNGgMP015458@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41364 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750920AbYEOXR5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 19:17:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fbuihuu@gmail.com, adobriyan@gmail.com, davem@davemloft.net, josh@kernel.org, paulmck@us.ibm.com


The patch titled
     rculist.h: use the rcu API
has been added to the -mm tree.  Its filename is
     rculisth-use-the-rcu-api.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rculist.h: use the rcu API
From: Franck Bui-Huu <fbuihuu@gmail.com>

This patch makes almost all list mutation primitives use
rcu_assign_pointer().

The main point of this being readability improvement.

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Josh Triplett <josh@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rculist.h |   23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff -puN include/linux/rculist.h~rculisth-use-the-rcu-api include/linux/rculist.h
--- a/include/linux/rculist.h~rculisth-use-the-rcu-api
+++ a/include/linux/rculist.h
@@ -5,6 +5,7 @@
  * RCU-protected list version
  */
 #include <linux/list.h>
+#include <linux/rcupdate.h>
 
 /*
  * Insert a new entry between two known consecutive entries.
@@ -17,9 +18,8 @@ static inline void __list_add_rcu(struct
 {
 	new->next = next;
 	new->prev = prev;
-	smp_wmb();
+	rcu_assign_pointer(prev->next, new);
 	next->prev = new;
-	prev->next = new;
 }
 
 /**
@@ -108,9 +108,8 @@ static inline void list_replace_rcu(stru
 {
 	new->next = old->next;
 	new->prev = old->prev;
-	smp_wmb();
+	rcu_assign_pointer(new->prev->next, new);
 	new->next->prev = new;
-	new->prev->next = new;
 	old->prev = LIST_POISON2;
 }
 
@@ -164,8 +163,7 @@ static inline void list_splice_init_rcu(
 	 */
 
 	last->next = at;
-	smp_wmb();
-	head->next = first;
+	rcu_assign_pointer(head->next, first);
 	first->prev = head;
 	at->prev = last;
 }
@@ -260,10 +258,9 @@ static inline void hlist_replace_rcu(str
 
 	new->next = next;
 	new->pprev = old->pprev;
-	smp_wmb();
+	rcu_assign_pointer(*new->pprev, new);
 	if (next)
 		new->next->pprev = &new->next;
-	*new->pprev = new;
 	old->pprev = LIST_POISON2;
 }
 
@@ -290,12 +287,12 @@ static inline void hlist_add_head_rcu(st
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
@@ -321,9 +318,8 @@ static inline void hlist_add_before_rcu(
 {
 	n->pprev = next->pprev;
 	n->next = next;
-	smp_wmb();
+	rcu_assign_pointer(*(n->pprev), n);
 	next->pprev = &n->next;
-	*(n->pprev) = n;
 }
 
 /**
@@ -349,8 +345,7 @@ static inline void hlist_add_after_rcu(s
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

split-listh-and-move-rcu-protected-lists-into-rculisth.patch
rculisth-use-the-rcu-api.patch

