Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2D7172764
	for <mm-commits@vger.kernel.org>; Fri,  5 Apr 2024 18:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712341331; cv=none; b=QANhLpg1nLMvmdByM5V4cKf/3m/FnCzIs5zs9GS/+vBzdnWIsKBO7YC1Nb94jeFDGnopmF3wuOrrEaXexZYl8v506rlszTJ2SoGxigGNdsP+oFpDo0CFvFYHuTxSd/hIxYQJn/yixE7R2cf2cKwkPCNgh0WlkcoI0mFkqQcHbyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712341331; c=relaxed/simple;
	bh=J/eWMxmi9g11eQLT2CxHMhbXTU4WzcrziWEqVwh3las=;
	h=Date:To:From:Subject:Message-Id; b=HjNEFynjxZ7vchnWq+3A07u7nppe0WoUur0M6lVzERTGeKbyS2MSm/tXWqveuFpeFc/2tQTfEt1bBXVq0mCNWbsAe7ulGXyFsYRIIgJ7WRInKMCggiNzEACZmk6H4UQZv+r8cyfh5wqtqdFbFdqhZ2JUH9m/2DM3Fq9nVUSqUw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dLjJL4KQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dLjJL4KQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD8FC433F1;
	Fri,  5 Apr 2024 18:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712341331;
	bh=J/eWMxmi9g11eQLT2CxHMhbXTU4WzcrziWEqVwh3las=;
	h=Date:To:From:Subject:From;
	b=dLjJL4KQ35boiOnw03D0FxCPhbdU97W8xitdeY09CXCOSBuu6TyGuxSayds9IVjMF
	 XxgYz5iusjhXSn16QCesMTa6uW0gWf4oyx+Vmw64Wn8fxUoDKRZs2aae0PYT757Et5
	 mcXqgEXQhcnHgrBu0A4uRiUSwH6hIFW2vFX4qCj4=
Date: Fri, 05 Apr 2024 11:22:10 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,osandov@fb.com,oleksiy.avramchenko@sony.com,lstoakes@gmail.com,hch@infradead.org,david@fromorbit.com,bhe@redhat.com,axboe@kernel.dk,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-vmalloc-fix-lockdep-warning.patch removed from -mm tree
Message-Id: <20240405182211.3DD8FC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmalloc: fix lockdep warning
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-fix-lockdep-warning.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm: vmalloc: fix lockdep warning
Date: Thu, 28 Mar 2024 15:03:30 +0100

A lockdep reports a possible deadlock in the find_vmap_area_exceed_addr_lock()
function:

============================================
WARNING: possible recursive locking detected
6.9.0-rc1-00060-ged3ccc57b108-dirty #6140 Not tainted
--------------------------------------------
drgn/455 is trying to acquire lock:
ffff0000c00131d0 (&vn->busy.lock/1){+.+.}-{2:2}, at: find_vmap_area_exceed_addr_lock+0x64/0x124

but task is already holding lock:
ffff0000c0011878 (&vn->busy.lock/1){+.+.}-{2:2}, at: find_vmap_area_exceed_addr_lock+0x64/0x124

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&vn->busy.lock/1);
  lock(&vn->busy.lock/1);

 *** DEADLOCK ***

indeed it can happen if the find_vmap_area_exceed_addr_lock() gets called
concurrently because it tries to acquire two nodes locks.  It was done to
prevent removing a lowest VA found on a previous step.

To address this a lowest VA is found first without holding a node lock
where it resides.  As a last step we check if a VA still there because it
can go away, if removed, proceed with next lowest.

[akpm@linux-foundation.org: fix comment typos, per Baoquan]
Link: https://lkml.kernel.org/r/20240328140330.4747-1-urezki@gmail.com
Fixes: 53becf32aec1 ("mm: vmalloc: support multiple nodes in vread_iter")
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Tested-by: Jens Axboe <axboe@kernel.dk>
Tested-by: Omar Sandoval <osandov@fb.com>
Reported-by: Jens Axboe <axboe@kernel.dk>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   73 ++++++++++++++++++++++++++++---------------------
 1 file changed, 43 insertions(+), 30 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-fix-lockdep-warning
+++ a/mm/vmalloc.c
@@ -989,6 +989,27 @@ unsigned long vmalloc_nr_pages(void)
 	return atomic_long_read(&nr_vmalloc_pages);
 }
 
+static struct vmap_area *__find_vmap_area(unsigned long addr, struct rb_root *root)
+{
+	struct rb_node *n = root->rb_node;
+
+	addr = (unsigned long)kasan_reset_tag((void *)addr);
+
+	while (n) {
+		struct vmap_area *va;
+
+		va = rb_entry(n, struct vmap_area, rb_node);
+		if (addr < va->va_start)
+			n = n->rb_left;
+		else if (addr >= va->va_end)
+			n = n->rb_right;
+		else
+			return va;
+	}
+
+	return NULL;
+}
+
 /* Look up the first VA which satisfies addr < va_end, NULL if none. */
 static struct vmap_area *
 __find_vmap_area_exceed_addr(unsigned long addr, struct rb_root *root)
@@ -1025,47 +1046,39 @@ __find_vmap_area_exceed_addr(unsigned lo
 static struct vmap_node *
 find_vmap_area_exceed_addr_lock(unsigned long addr, struct vmap_area **va)
 {
-	struct vmap_node *vn, *va_node = NULL;
-	struct vmap_area *va_lowest;
+	unsigned long va_start_lowest;
+	struct vmap_node *vn;
 	int i;
 
-	for (i = 0; i < nr_vmap_nodes; i++) {
+repeat:
+	for (i = 0, va_start_lowest = 0; i < nr_vmap_nodes; i++) {
 		vn = &vmap_nodes[i];
 
 		spin_lock(&vn->busy.lock);
-		va_lowest = __find_vmap_area_exceed_addr(addr, &vn->busy.root);
-		if (va_lowest) {
-			if (!va_node || va_lowest->va_start < (*va)->va_start) {
-				if (va_node)
-					spin_unlock(&va_node->busy.lock);
-
-				*va = va_lowest;
-				va_node = vn;
-				continue;
-			}
-		}
+		*va = __find_vmap_area_exceed_addr(addr, &vn->busy.root);
+
+		if (*va)
+			if (!va_start_lowest || (*va)->va_start < va_start_lowest)
+				va_start_lowest = (*va)->va_start;
 		spin_unlock(&vn->busy.lock);
 	}
 
-	return va_node;
-}
+	/*
+	 * Check if found VA exists, it might have gone away.  In this case we
+	 * repeat the search because a VA has been removed concurrently and we
+	 * need to proceed to the next one, which is a rare case.
+	 */
+	if (va_start_lowest) {
+		vn = addr_to_node(va_start_lowest);
 
-static struct vmap_area *__find_vmap_area(unsigned long addr, struct rb_root *root)
-{
-	struct rb_node *n = root->rb_node;
+		spin_lock(&vn->busy.lock);
+		*va = __find_vmap_area(va_start_lowest, &vn->busy.root);
 
-	addr = (unsigned long)kasan_reset_tag((void *)addr);
+		if (*va)
+			return vn;
 
-	while (n) {
-		struct vmap_area *va;
-
-		va = rb_entry(n, struct vmap_area, rb_node);
-		if (addr < va->va_start)
-			n = n->rb_left;
-		else if (addr >= va->va_end)
-			n = n->rb_right;
-		else
-			return va;
+		spin_unlock(&vn->busy.lock);
+		goto repeat;
 	}
 
 	return NULL;
_

Patches currently in -mm which might be from urezki@gmail.com are


