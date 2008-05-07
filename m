From: akpm@linux-foundation.org
Subject: + idr-make-idr_find-rcu-safe.patch added to -mm tree
Date: Wed, 07 May 2008 13:40:32 -0700
Message-ID: <200805072040.m47KeW8D015474@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752954AbYEGUlw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 16:41:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Nadia.Derbey@bull.net, jim.houston@comcast.net, manfred@colorfullife.com, paulmck@us.ibm.com, peifferp@gmail.com


The patch titled
     idr: make idr_find rcu-safe
has been added to the -mm tree.  Its filename is
     idr-make-idr_find-rcu-safe.patch

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
Subject: idr: make idr_find rcu-safe
From: Nadia Derbey <Nadia.Derbey@bull.net>

Make idr_find rcu-safe: it can now be called inside an rcu_read critical
section.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Jim Houston <jim.houston@comcast.net>
Cc: Pierre Peiffer <peifferp@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/idr.h |   16 ++++++++++++++++
 lib/idr.c           |   11 ++++++-----
 2 files changed, 22 insertions(+), 5 deletions(-)

diff -puN include/linux/idr.h~idr-make-idr_find-rcu-safe include/linux/idr.h
--- a/include/linux/idr.h~idr-make-idr_find-rcu-safe
+++ a/include/linux/idr.h
@@ -80,6 +80,22 @@ struct idr {
 
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
@@ -459,7 +459,8 @@ EXPORT_SYMBOL(idr_destroy);
  * return indicates that @id is not valid or you passed %NULL in
  * idr_get_new().
  *
- * The caller must serialize idr_find() vs idr_get_new() and idr_remove().
+ * This function can be called under rcu_read_lock(), given that the leaf
+ * pointers lifetimes are correctly managed.
  */
 void *idr_find(struct idr *idp, int id)
 {
@@ -467,7 +468,7 @@ void *idr_find(struct idr *idp, int id)
 	struct idr_layer *p;
 
 	n = idp->layers * IDR_BITS;
-	p = idp->top;
+	p = rcu_dereference(idp->top);
 
 	/* Mask off upper bits we don't use for the search. */
 	id &= MAX_ID_MASK;
@@ -477,7 +478,7 @@ void *idr_find(struct idr *idp, int id)
 
 	while (n > 0 && p) {
 		n -= IDR_BITS;
-		p = p->ary[(id >> n) & IDR_MASK];
+		p = rcu_dereference(p->ary[(id >> n) & IDR_MASK]);
 	}
 	return((void *)p);
 }
@@ -510,7 +511,7 @@ int idr_for_each(struct idr *idp,
 	struct idr_layer **paa = &pa[0];
 
 	n = idp->layers * IDR_BITS;
-	p = idp->top;
+	p = rcu_dereference(idp->top);
 	max = 1 << n;
 
 	id = 0;
@@ -518,7 +519,7 @@ int idr_for_each(struct idr *idp,
 		while (n > 0 && p) {
 			n -= IDR_BITS;
 			*paa++ = p;
-			p = p->ary[(id >> n) & IDR_MASK];
+			p = rcu_dereference(p->ary[(id >> n) & IDR_MASK]);
 		}
 
 		if (p) {
_

Patches currently in -mm which might be from Nadia.Derbey@bull.net are

idr-change-the-idr-structure.patch
idr-rename-some-of-the-idr-apis-internal-routines.patch
idr-fix-a-printk-call.patch
idr-error-checking-factorization.patch
idr-make-idr_get_new-rcu-safe.patch
idr-make-idr_find-rcu-safe.patch
idr-make-idr_remove-rcu-safe.patch
ipc-call-idr_find-without-locking-in-ipc_lock.patch
ipc-get-rid-of-ipc_lock_down.patch

