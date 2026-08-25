Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D8937F01B
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622982; cv=none; b=KFx5QotBgF3GB354GWHFPOMfwAIKjVF860SLmuiyYTgV824nx27vfDbQfce7FwR9hEkEdmR+tzfljbaXqg8B9gWGOfSs1OtrHhta+IiezcHEiJsxDP2SNKs6/9lLUF6QmRdlEZ131rfzYJ2saMK+YacRXKgpfc1a8ht1r6h7WRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622982; c=relaxed/simple;
	bh=lWD0xkcRqa+ZcaikvkUxXdBmzuHuekHRoCmLM/OW3KE=;
	h=Date:To:From:Subject:Message-Id; b=U5rmQC7z35LEUv9wapm23WqFrneX8V4XbPJyc9KZgmVGP5QYUFJlRQkiKp5f8CvicKNORfwjt4X4giJRNP4W4AxQJkrCdCaXN89Urjaby9OYp8uEsydvcjZ/C/3uuv9QhEqoHfOvMpAM32eC6yKOEOmqIEMG1vubJB1V3laK3zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dOPHNTQ8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dOPHNTQ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C8D1F000E9;
	Tue, 25 Aug 2026 01:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622980;
	bh=kPSCTY5UbYxoLT4GBPCneiOWRNhQlK/eZ5lkGsMkq2Q=;
	h=Date:To:From:Subject;
	b=dOPHNTQ8QZaFo5xhCDVRPMtkVxQBmXXWgvAQUjr66aY4Ze/53CJy6ztvzZ4zbzQRH
	 wls+Bx7WBuqVO4J7dPvav1swHGWUyC+4fAkNwpIuSkVmI/8cgDB41NMVApOhpyvPFA
	 x561XNcUB1wmRYIccLvkXb7UULCgcZrBNv/l6PJg=
Date: Mon, 24 Aug 2026 18:56:20 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,longman@redhat.com,leitao@debian.org,joe@perches.com,jgg@ziepe.ca,clm@meta.com,cel@kernel.org,boqun.feng@gmail.com,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-document-that-erase-may-use-gfp_kernel-for-allocations.patch removed from -mm tree
Message-Id: <20260825015620.B0C8D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: document that erase may use GFP_KERNEL for allocations
has been removed from the -mm tree.  Its filename was
     maple_tree-document-that-erase-may-use-gfp_kernel-for-allocations.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: maple_tree: document that erase may use GFP_KERNEL for allocations
Date: Fri, 21 Aug 2026 15:26:21 -0400

State that the mas_erase() and mtree_erase() functions may use GFP_KERNEL
on allocation retry.  Don't just depend on people reading the
documentation by adding a check that will warn of the use.

Link: https://lore.kernel.org/20260821192627.4085470-14-liam@infradead.org
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Reviewed-by: Rik van Riel <riel@surriel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Chris Mason <clm@meta.com>
Cc: Chuck Lever <cel@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-document-that-erase-may-use-gfp_kernel-for-allocations
+++ a/lib/maple_tree.c
@@ -5658,6 +5658,10 @@ EXPORT_SYMBOL_GPL(mas_find_range_rev);
  * Searches for @mas->index, sets @mas->index and @mas->last to the range and
  * erases that range.
  *
+ * Note that erase requires allocations and will use GFP_KERNEL to do so if
+ * necessary.  If the allocation fails, the internal lock will be dropped to
+ * retry.
+ *
  * Return: the entry that was erased or %NULL, @mas->index and @mas->last are updated.
  */
 void *mas_erase(struct ma_state *mas)
@@ -5666,13 +5670,21 @@ void *mas_erase(struct ma_state *mas)
 	unsigned long index = mas->index;
 	MA_WR_STATE(wr_mas, mas, NULL);
 
+	/*
+	 * In low memory situations, the allocation is retried with the gfp flag
+	 * GFP_KERNEL.  The internal spinlock is dropped in mas_nomem(), however
+	 * the external lock is not dropped.
+	 */
+	if (mt_external_lock(mas->tree))
+		might_alloc(GFP_KERNEL);
+
 	if (!mas_is_active(mas) || !mas_is_start(mas))
 		mas->status = ma_start;
 
 write_retry:
 	entry = mas_state_walk(mas);
 	if (!entry)
-		return NULL;
+		goto out;
 
 	/* Must reset to ensure spanning writes of last slot are detected */
 	mas_reset(mas);
@@ -5683,8 +5695,10 @@ write_retry:
 		goto write_retry;
 	}
 
-	if (mas_is_err(mas))
+	if (mas_is_err(mas)) {
+		entry = NULL;
 		goto out;
+	}
 
 	mas_wr_store_entry(&wr_mas);
 out:
@@ -6012,6 +6026,10 @@ EXPORT_SYMBOL(mtree_alloc_rrange);
  * Erasing is the same as a walk to an entry then a store of a NULL to that
  * ENTIRE range.  In fact, it is implemented as such using the advanced API.
  *
+ * Note that erase requires allocations and will use GFP_KERNEL to do so if
+ * necessary.  If the allocation fails, the internal lock will be dropped to
+ * retry.
+ *
  * Return: The entry stored at the @index or %NULL
  */
 void *mtree_erase(struct maple_tree *mt, unsigned long index)
@@ -6021,6 +6039,7 @@ void *mtree_erase(struct maple_tree *mt,
 	MA_STATE(mas, mt, index, index);
 	trace_ma_op(TP_FCT, &mas);
 
+	might_alloc(GFP_KERNEL);
 	mtree_lock(mt);
 	entry = mas_erase(&mas);
 	mtree_unlock(mt);
_

Patches currently in -mm which might be from liam@infradead.org are


