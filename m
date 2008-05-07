From: akpm@linux-foundation.org
Subject: + idr-make-idr_get_new-rcu-safe.patch added to -mm tree
Date: Wed, 07 May 2008 13:40:30 -0700
Message-ID: <200805072040.m47KeU01015471@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42349 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755135AbYEGUmo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 16:42:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Nadia.Derbey@bull.net, jim.houston@comcast.net, manfred@colorfullife.com, paulmck@us.ibm.com, peifferp@gmail.com


The patch titled
     idr: make idr_get_new* rcu-safe
has been added to the -mm tree.  Its filename is
     idr-make-idr_get_new-rcu-safe.patch

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
Subject: idr: make idr_get_new* rcu-safe
From: Nadia Derbey <Nadia.Derbey@bull.net>

Make the idr_get_new* routines rcu-safe.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Jim Houston <jim.houston@comcast.net>
Cc: Pierre Peiffer <peifferp@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff -puN lib/idr.c~idr-make-idr_get_new-rcu-safe lib/idr.c
--- a/lib/idr.c~idr-make-idr_get_new-rcu-safe
+++ a/lib/idr.c
@@ -6,6 +6,8 @@
  * Modified by George Anzinger to reuse immediately and to use
  * find bit instructions.  Also removed _irq on spinlocks.
  *
+ * Modified by Nadia Derbey to make it RCU safe.
+ *
  * Small id to pointer translation service.
  *
  * It uses a radix tree like structure as a sparse array indexed
@@ -96,7 +98,7 @@ static void idr_mark_full(struct idr_lay
  * @gfp_mask:	memory allocation flags
  *
  * This function should be called prior to locking and calling the
- * following function.  It preallocates enough memory to satisfy
+ * idr_get_new* functions. It preallocates enough memory to satisfy
  * the worst possible allocation.
  *
  * If the system is REALLY out of memory this function returns 0,
@@ -170,7 +172,8 @@ static int sub_alloc(struct idr *idp, in
 			new = get_from_free_list(idp);
 			if (!new)
 				return -1;
-			p->ary[m] = new;
+			INIT_RCU_HEAD(&new->rcu_head);
+			rcu_assign_pointer(p->ary[m], new);
 			p->count++;
 		}
 		pa[l--] = p;
@@ -195,6 +198,7 @@ build_up:
 	if (unlikely(!p)) {
 		if (!(p = get_from_free_list(idp)))
 			return -1;
+		INIT_RCU_HEAD(&p->rcu_head);
 		layers = 1;
 	}
 	/*
@@ -222,11 +226,12 @@ build_up:
 		}
 		new->ary[0] = p;
 		new->count = 1;
+		INIT_RCU_HEAD(&new->rcu_head);
 		if (p->bitmap == IDR_FULL)
 			__set_bit(0, &new->bitmap);
 		p = new;
 	}
-	idp->top = p;
+	rcu_assign_pointer(idp->top, p);
 	idp->layers = layers;
 	v = sub_alloc(idp, &id, pa);
 	if (v == IDR_NEED_TO_GROW)
@@ -245,7 +250,8 @@ static int idr_get_new_above_int(struct 
 		 * Successfully found an empty slot.  Install the user
 		 * pointer and mark the slot full.
 		 */
-		pa[0]->ary[id & IDR_MASK] = (struct idr_layer *)ptr;
+		rcu_assign_pointer(pa[0]->ary[id & IDR_MASK],
+				(struct idr_layer *)ptr);
 		pa[0]->count++;
 		idr_mark_full(pa, id);
 	}
@@ -710,7 +716,8 @@ int ida_get_new_above(struct ida *ida, i
 			return -EAGAIN;
 
 		memset(bitmap, 0, sizeof(struct ida_bitmap));
-		pa[0]->ary[idr_id & IDR_MASK] = (void *)bitmap;
+		rcu_assign_pointer(pa[0]->ary[idr_id & IDR_MASK],
+				(void *)bitmap);
 		pa[0]->count++;
 	}
 
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

