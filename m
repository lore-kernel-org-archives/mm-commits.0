From: akpm@linux-foundation.org
Subject: + debugobjects-fix-lockdep-warning.patch added to -mm tree
Date: Thu, 28 Aug 2008 17:17:22 -0700
Message-ID: <200808290017.m7T0HMcO021866@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755482AbYH2ASJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Aug 2008 20:18:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vegard.nossum@gmail.com, a.p.zijlstra@chello.nl, daniel.blueman@gmail.com, mingo@elte.hu, rjw@sisk.pl, tglx@linutronix.de


The patch titled
     debugobjects: fix lockdep warning
has been added to the -mm tree.  Its filename is
     debugobjects-fix-lockdep-warning.patch

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
Subject: debugobjects: fix lockdep warning
From: Vegard Nossum <vegard.nossum@gmail.com>

Daniel J. Blueman reported:
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.27-rc4-224c #1
> -------------------------------------------------------
> hald/4680 is trying to acquire lock:
>  (&n->list_lock){++..}, at: [<ffffffff802bfa26>] add_partial+0x26/0x80
>
> but task is already holding lock:
>  (&obj_hash[i].lock){++..}, at: [<ffffffff8041cfdc>]
> debug_object_free+0x5c/0x120

We fix it by moving the actual freeing to outside the lock (the lock
now only protects the list).

The lock is also promoted to irq-safe (suggested by Dan).

Reported-by: Daniel J Blueman <daniel.blueman@gmail.com>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/debugobjects.c |   38 +++++++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 9 deletions(-)

diff -puN lib/debugobjects.c~debugobjects-fix-lockdep-warning lib/debugobjects.c
--- a/lib/debugobjects.c~debugobjects-fix-lockdep-warning
+++ a/lib/debugobjects.c
@@ -116,9 +116,10 @@ static struct debug_obj *lookup_object(v
 static struct debug_obj *
 alloc_object(void *addr, struct debug_bucket *b, struct debug_obj_descr *descr)
 {
+	unsigned long flags;
 	struct debug_obj *obj = NULL;
 
-	spin_lock(&pool_lock);
+	spin_lock_irqsave(&pool_lock, flags);
 	if (obj_pool.first) {
 		obj	    = hlist_entry(obj_pool.first, typeof(*obj), node);
 
@@ -137,7 +138,7 @@ alloc_object(void *addr, struct debug_bu
 		if (obj_pool_free < obj_pool_min_free)
 			obj_pool_min_free = obj_pool_free;
 	}
-	spin_unlock(&pool_lock);
+	spin_unlock_irqrestore(&pool_lock, flags);
 
 	return obj;
 }
@@ -147,18 +148,19 @@ alloc_object(void *addr, struct debug_bu
  */
 static void free_object(struct debug_obj *obj)
 {
+	unsigned long flags;
 	unsigned long idx = (unsigned long)(obj - obj_static_pool);
 
 	if (obj_pool_free < ODEBUG_POOL_SIZE || idx < ODEBUG_POOL_SIZE) {
-		spin_lock(&pool_lock);
+		spin_lock_irqsave(&pool_lock, flags);
 		hlist_add_head(&obj->node, &obj_pool);
 		obj_pool_free++;
 		obj_pool_used--;
-		spin_unlock(&pool_lock);
+		spin_unlock_irqrestore(&pool_lock, flags);
 	} else {
-		spin_lock(&pool_lock);
+		spin_lock_irqsave(&pool_lock, flags);
 		obj_pool_used--;
-		spin_unlock(&pool_lock);
+		spin_unlock_irqrestore(&pool_lock, flags);
 		kmem_cache_free(obj_cache, obj);
 	}
 }
@@ -171,19 +173,28 @@ static void debug_objects_oom(void)
 {
 	struct debug_bucket *db = obj_hash;
 	struct hlist_node *node, *tmp;
+	HLIST_HEAD(freelist);
 	struct debug_obj *obj;
 	unsigned long flags;
 	int i;
 
 	printk(KERN_WARNING "ODEBUG: Out of memory. ODEBUG disabled\n");
 
+	/* XXX: Could probably be optimized by transplantation of more than
+	 * one entry at a time. */
 	for (i = 0; i < ODEBUG_HASH_SIZE; i++, db++) {
 		spin_lock_irqsave(&db->lock, flags);
 		hlist_for_each_entry_safe(obj, node, tmp, &db->list, node) {
 			hlist_del(&obj->node);
-			free_object(obj);
+			hlist_add_head(&obj->node, &freelist);
 		}
 		spin_unlock_irqrestore(&db->lock, flags);
+
+		/* Now free them */
+		hlist_for_each_entry_safe(obj, node, tmp, &freelist, node) {
+			hlist_del(&obj->node);
+			free_object(obj);
+		}
 	}
 }
 
@@ -498,8 +509,9 @@ void debug_object_free(void *addr, struc
 		return;
 	default:
 		hlist_del(&obj->node);
+		spin_unlock_irqrestore(&db->lock, flags);
 		free_object(obj);
-		break;
+		return;
 	}
 out_unlock:
 	spin_unlock_irqrestore(&db->lock, flags);
@@ -510,6 +522,7 @@ static void __debug_check_no_obj_freed(c
 {
 	unsigned long flags, oaddr, saddr, eaddr, paddr, chunks;
 	struct hlist_node *node, *tmp;
+	HLIST_HEAD(freelist);
 	struct debug_obj_descr *descr;
 	enum debug_obj_state state;
 	struct debug_bucket *db;
@@ -545,11 +558,18 @@ repeat:
 				goto repeat;
 			default:
 				hlist_del(&obj->node);
-				free_object(obj);
+				hlist_add_head(&obj->node, &freelist);
 				break;
 			}
 		}
 		spin_unlock_irqrestore(&db->lock, flags);
+
+		/* Now free them */
+		hlist_for_each_entry_safe(obj, node, tmp, &freelist, node) {
+			hlist_del(&obj->node);
+			free_object(obj);
+		}
+
 		if (cnt > debug_objects_maxchain)
 			debug_objects_maxchain = cnt;
 	}
_

Patches currently in -mm which might be from vegard.nossum@gmail.com are

origin.patch
linux-next.patch
debugobjects-fix-lockdep-warning.patch

