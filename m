From: akpm@linux-foundation.org
Subject: [merged] idr-remove-_idr_rc_to_errno-hack.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:13:03 -0800
Message-ID: <20130228201303.B15C45A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:36018 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770Ab3B1UNE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:13:04 -0500
Received: by mail-qe0-f74.google.com with SMTP id 9so245086qea.3
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:13:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: idr: remove _idr_rc_to_errno() hack
has been removed from the -mm tree.  Its filename was
     idr-remove-_idr_rc_to_errno-hack.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: idr: remove _idr_rc_to_errno() hack

idr uses -1, IDR_NEED_TO_GROW and IDR_NOMORE_SPACE to communicate
exception conditions internally.  The return value is later translated
to errno values using _idr_rc_to_errno().

This is confusing.  Drop the custom ones and consistently use -EAGAIN
for "tree needs to grow", -ENOMEM for "need more memory" and -ENOSPC
for "ran out of ID space".

Due to the weird memory preloading mechanism, [ra]_get_new*() return
-EAGAIN on memory shortage, so we need to substitute -ENOMEM w/
-EAGAIN on those interface functions.  They'll eventually be cleaned
up and the translations will go away.

This patch doesn't introduce any functional changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/idr.h |    6 ------
 lib/idr.c           |   35 +++++++++++++++++++++++------------
 2 files changed, 23 insertions(+), 18 deletions(-)

diff -puN include/linux/idr.h~idr-remove-_idr_rc_to_errno-hack include/linux/idr.h
--- a/include/linux/idr.h~idr-remove-_idr_rc_to_errno-hack
+++ a/include/linux/idr.h
@@ -70,12 +70,6 @@ struct idr {
 }
 #define DEFINE_IDR(name)	struct idr name = IDR_INIT(name)
 
-/* Actions to be taken after a call to _idr_sub_alloc */
-#define IDR_NEED_TO_GROW -2
-#define IDR_NOMORE_SPACE -3
-
-#define _idr_rc_to_errno(rc) ((rc) == -1 ? -EAGAIN : -ENOSPC)
-
 /**
  * DOC: idr sync
  * idr synchronization (stolen from radix-tree.h)
diff -puN lib/idr.c~idr-remove-_idr_rc_to_errno-hack lib/idr.c
--- a/lib/idr.c~idr-remove-_idr_rc_to_errno-hack
+++ a/lib/idr.c
@@ -133,6 +133,21 @@ int idr_pre_get(struct idr *idp, gfp_t g
 }
 EXPORT_SYMBOL(idr_pre_get);
 
+/**
+ * sub_alloc - try to allocate an id without growing the tree depth
+ * @idp: idr handle
+ * @starting_id: id to start search at
+ * @id: pointer to the allocated handle
+ * @pa: idr_layer[MAX_IDR_LEVEL] used as backtrack buffer
+ *
+ * Allocate an id in range [@starting_id, INT_MAX] from @idp without
+ * growing its depth.  Returns
+ *
+ *  the allocated id >= 0 if successful,
+ *  -EAGAIN if the tree needs to grow for allocation to succeed,
+ *  -ENOSPC if the id space is exhausted,
+ *  -ENOMEM if more idr_layers need to be allocated.
+ */
 static int sub_alloc(struct idr *idp, int *starting_id, struct idr_layer **pa)
 {
 	int n, m, sh;
@@ -161,7 +176,7 @@ static int sub_alloc(struct idr *idp, in
 			/* if already at the top layer, we need to grow */
 			if (id >= 1 << (idp->layers * IDR_BITS)) {
 				*starting_id = id;
-				return IDR_NEED_TO_GROW;
+				return -EAGAIN;
 			}
 			p = pa[l];
 			BUG_ON(!p);
@@ -180,7 +195,7 @@ static int sub_alloc(struct idr *idp, in
 			id = ((id >> sh) ^ n ^ m) << sh;
 		}
 		if ((id >= MAX_IDR_BIT) || (id < 0))
-			return IDR_NOMORE_SPACE;
+			return -ENOSPC;
 		if (l == 0)
 			break;
 		/*
@@ -189,7 +204,7 @@ static int sub_alloc(struct idr *idp, in
 		if (!p->ary[m]) {
 			new = get_from_free_list(idp);
 			if (!new)
-				return -1;
+				return -ENOMEM;
 			new->layer = l-1;
 			rcu_assign_pointer(p->ary[m], new);
 			p->count++;
@@ -215,7 +230,7 @@ build_up:
 	layers = idp->layers;
 	if (unlikely(!p)) {
 		if (!(p = get_from_free_list(idp)))
-			return -1;
+			return -ENOMEM;
 		p->layer = 0;
 		layers = 1;
 	}
@@ -246,7 +261,7 @@ build_up:
 				__move_to_free_list(idp, new);
 			}
 			spin_unlock_irqrestore(&idp->lock, flags);
-			return -1;
+			return -ENOMEM;
 		}
 		new->ary[0] = p;
 		new->count = 1;
@@ -258,7 +273,7 @@ build_up:
 	rcu_assign_pointer(idp->top, p);
 	idp->layers = layers;
 	v = sub_alloc(idp, &id, pa);
-	if (v == IDR_NEED_TO_GROW)
+	if (v == -EAGAIN)
 		goto build_up;
 	return(v);
 }
@@ -306,12 +321,8 @@ int idr_get_new_above(struct idr *idp, v
 	int rv;
 
 	rv = idr_get_new_above_int(idp, ptr, starting_id);
-	/*
-	 * This is a cheap hack until the IDR code can be fixed to
-	 * return proper error values.
-	 */
 	if (rv < 0)
-		return _idr_rc_to_errno(rv);
+		return rv == -ENOMEM ? -EAGAIN : rv;
 	*id = rv;
 	return 0;
 }
@@ -766,7 +777,7 @@ int ida_get_new_above(struct ida *ida, i
 	/* get vacant slot */
 	t = idr_get_empty_slot(&ida->idr, idr_id, pa);
 	if (t < 0)
-		return _idr_rc_to_errno(t);
+		return t == -ENOMEM ? -EAGAIN : t;
 
 	if (t * IDA_BITMAP_BITS >= MAX_IDR_BIT)
 		return -ENOSPC;
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
slub-correctly-bootstrap-boot-caches.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
coredump-make-wait_for_dump_helpers-freezable.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch

