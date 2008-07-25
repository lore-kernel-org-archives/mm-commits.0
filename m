From: akpm@linux-foundation.org
Subject: - idr-make-idr_find-rcu-safe.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:00:45 -0700
Message-ID: <200807252300.m6PN0jYw003615@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60300 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754216AbYGYXIn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:08:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Nadia.Derbey@bull.net, jim.houston@comcast.net, manfred@colorfullife.com, paulmck@us.ibm.com, peifferp@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     idr: make idr_find rcu-safe
has been removed from the -mm tree.  Its filename was
     idr-make-idr_find-rcu-safe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: idr: make idr_find rcu-safe
From: Nadia Derbey <Nadia.Derbey@bull.net>

Make idr_find rcu-safe: it can now be called inside an rcu_read critical
section.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Reviewed-by: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Jim Houston <jim.houston@comcast.net>
Cc: Pierre Peiffer <peifferp@gmail.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/idr.h |   16 ++++++++++++++++
 lib/idr.c           |   11 ++++++-----
 2 files changed, 22 insertions(+), 5 deletions(-)

diff -puN include/linux/idr.h~idr-make-idr_find-rcu-safe include/linux/idr.h
--- a/include/linux/idr.h~idr-make-idr_find-rcu-safe
+++ a/include/linux/idr.h
@@ -79,6 +79,22 @@ struct idr {
 
 #define _idr_rc_to_errno(rc) ((rc) == -1 ? -EAGAIN : -ENOSPC)
 
+/**
+ * idr synchronization (stolen from radix-tree.h)
+ *
+ * idr_find() is able to be called locklessly, using RCU. The caller must
+ * ensure calls to this function are made within rcu_read_lock() regions.
+ * Other readers (lock-free or otherwise) and modifications may be running
+ * concurrently.
+ *
+ * It is still required that the caller manage the synchronization and
+ * lifetimes of the items. So if RCU lock-free lookups are used, typically
+ * this would mean that the items have their own locks, or are amenable to
+ * lock-free access; and that the items are freed by RCU (or only freed after
+ * having been deleted from the idr tree *and* a synchronize_rcu() grace
+ * period).
+ */
+
 /*
  * This is what we export.
  */
diff -puN lib/idr.c~idr-make-idr_find-rcu-safe lib/idr.c
--- a/lib/idr.c~idr-make-idr_find-rcu-safe
+++ a/lib/idr.c
@@ -456,7 +456,8 @@ EXPORT_SYMBOL(idr_destroy);
  * return indicates that @id is not valid or you passed %NULL in
  * idr_get_new().
  *
- * The caller must serialize idr_find() vs idr_get_new() and idr_remove().
+ * This function can be called under rcu_read_lock(), given that the leaf
+ * pointers lifetimes are correctly managed.
  */
 void *idr_find(struct idr *idp, int id)
 {
@@ -464,7 +465,7 @@ void *idr_find(struct idr *idp, int id)
 	struct idr_layer *p;
 
 	n = idp->layers * IDR_BITS;
-	p = idp->top;
+	p = rcu_dereference(idp->top);
 
 	/* Mask off upper bits we don't use for the search. */
 	id &= MAX_ID_MASK;
@@ -474,7 +475,7 @@ void *idr_find(struct idr *idp, int id)
 
 	while (n > 0 && p) {
 		n -= IDR_BITS;
-		p = p->ary[(id >> n) & IDR_MASK];
+		p = rcu_dereference(p->ary[(id >> n) & IDR_MASK]);
 	}
 	return((void *)p);
 }
@@ -507,7 +508,7 @@ int idr_for_each(struct idr *idp,
 	struct idr_layer **paa = &pa[0];
 
 	n = idp->layers * IDR_BITS;
-	p = idp->top;
+	p = rcu_dereference(idp->top);
 	max = 1 << n;
 
 	id = 0;
@@ -515,7 +516,7 @@ int idr_for_each(struct idr *idp,
 		while (n > 0 && p) {
 			n -= IDR_BITS;
 			*paa++ = p;
-			p = p->ary[(id >> n) & IDR_MASK];
+			p = rcu_dereference(p->ary[(id >> n) & IDR_MASK]);
 		}
 
 		if (p) {
_

Patches currently in -mm which might be from Nadia.Derbey@bull.net are

origin.patch

