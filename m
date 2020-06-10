From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged]
 ipc-convert-ipcs_idr-to-xarray-update.patch removed from -mm tree
Date: Tue, 09 Jun 2020 20:59:31 -0700
Message-ID: <20200610035931.R5FXC4Z8c%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbgFJD7d (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 23:59:33 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, manfred@colorfullife.com, mm-commits@vger.kernel.org, willy@infradead.org


The patch titled
     Subject: ipc-convert-ipcs_idr-to-xarray-update
has been removed from the -mm tree.  Its filename was
     ipc-convert-ipcs_idr-to-xarray-update.patch

This patch was dropped because it was folded into ipc-convert-ipcs_idr-to-xarray.patch

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: ipc-convert-ipcs_idr-to-xarray-update

implement change suggested by Manfred

Link: http://lkml.kernel.org/r/20200421183342.GQ5820@bombadil.infradead.org
Signed-off-by: Matthew Wilcox <willy@infradead.org>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/xarray.h |    1 
 ipc/util.c             |   52 +++++++++++++++------------------------
 lib/xarray.c           |    2 -
 3 files changed, 21 insertions(+), 34 deletions(-)

--- a/include/linux/xarray.h~ipc-convert-ipcs_idr-to-xarray-update
+++ a/include/linux/xarray.h
@@ -1501,7 +1501,6 @@ void *xas_find_marked(struct xa_state *,
 void xas_init_marks(const struct xa_state *);
 
 bool xas_nomem(struct xa_state *, gfp_t);
-bool __xas_nomem(struct xa_state *, gfp_t);
 void xas_pause(struct xa_state *);
 
 void xas_create_range(struct xa_state *);
--- a/ipc/util.c~ipc-convert-ipcs_idr-to-xarray-update
+++ a/ipc/util.c
@@ -210,52 +210,40 @@ static inline int ipc_id_alloc(struct ip
 	int err;
 
 	if (get_restore_id(ids) < 0) {
-		XA_STATE(xas, &ids->ipcs, 0);
-		int min_idx, max_idx;
+		int max_idx;
 
 		max_idx = max(ids->in_use*3/2, ipc_min_cycle);
 		max_idx = min(max_idx, ipc_mni) - 1;
 
-		xas_lock(&xas);
+		xa_lock(&ids->ipcs);
 
-		min_idx = ids->next_idx;
-		new->seq = ids->seq;
+		err = __xa_alloc_cyclic(&ids->ipcs, &idx, NULL,
+				XA_LIMIT(0, max_idx), &ids->next_idx,
+				GFP_KERNEL);
+		if (err == 1) {
+			ids->seq++;
+			if (ids->seq >= ipcid_seq_max())
+				ids->seq = 0;
+		}
+
+		if (err >= 0) {
+			new->seq = ids->seq;
+			new->id = (new->seq << ipcmni_seq_shift()) + idx;
+			/* xa_store contains a write barrier */
+			__xa_store(&ids->ipcs, idx, new, GFP_KERNEL);
+		}
 
-		/* Modified version of __xa_alloc */
-		do {
-			xas.xa_index = min_idx;
-			xas_find_marked(&xas, max_idx, XA_FREE_MARK);
-			if (xas.xa_node == XAS_RESTART && min_idx > 0) {
-				ids->seq++;
-				if (ids->seq >= ipcid_seq_max())
-					ids->seq = 0;
-				new->seq = ids->seq;
-				xas.xa_index = 0;
-				min_idx = 0;
-				xas_find_marked(&xas, max_idx, XA_FREE_MARK);
-			}
-			if (xas.xa_node == XAS_RESTART)
-				xas_set_err(&xas, -ENOSPC);
-			else
-				new->id = (new->seq << ipcmni_seq_shift()) +
-					xas.xa_index;
-			xas_store(&xas, new);
-			xas_clear_mark(&xas, XA_FREE_MARK);
-		} while (__xas_nomem(&xas, GFP_KERNEL));
-
-		xas_unlock(&xas);
-		err = xas_error(&xas);
-		idx = xas.xa_index;
+		xa_unlock(&ids->ipcs);
 	} else {
 		new->id = get_restore_id(ids);
 		new->seq = ipcid_to_seqx(new->id);
 		idx = ipcid_to_idx(new->id);
 		err = xa_insert(&ids->ipcs, idx, new, GFP_KERNEL);
-		if (err == -EBUSY)
-			err = -ENOSPC;
 		set_restore_id(ids, -1);
 	}
 
+	if (err == -EBUSY)
+		return -ENOSPC;
 	if (err < 0)
 		return err;
 	return idx;
--- a/lib/xarray.c~ipc-convert-ipcs_idr-to-xarray-update
+++ a/lib/xarray.c
@@ -319,7 +319,7 @@ EXPORT_SYMBOL_GPL(xas_nomem);
  *
  * Return: true if memory was needed, and was successfully allocated.
  */
-bool __xas_nomem(struct xa_state *xas, gfp_t gfp)
+static bool __xas_nomem(struct xa_state *xas, gfp_t gfp)
 	__must_hold(xas->xa->xa_lock)
 {
 	unsigned int lock_type = xa_lock_type(xas->xa);
_

Patches currently in -mm which might be from willy@infradead.org are

ipc-convert-ipcs_idr-to-xarray.patch
