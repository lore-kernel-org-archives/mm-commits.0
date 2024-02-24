Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECD96FD2
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739378; cv=none; b=sVqCiyoCDU1lIPRmO1agW+pQ/h6Gue2lj3Rx1xWT7gFQQDweaGCn8o/j3PQcAYAhEVYuT09zVzx+mazQ9oWyJ1zlv5C8RNTr9Jl7DqdoTHKKEInZgzPlA5RXv+DLd4fPINA/nat1GtuMPCLXwy4ErpG6StN1/hFU95UX+ztgE5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739378; c=relaxed/simple;
	bh=S5woWugwR5HfRwnq6ZOvJojSRu3YHk30lzlbgMhcnx0=;
	h=Date:To:From:Subject:Message-Id; b=DSqWbqHhkLx8Evl9J1oQ3H5rAnmI8cjc03SgGRmliJZchHSp1otpV3StZu+VGP5OByIGHxIHgdt+geWq4UpMz11SgPMT1yVTdVYNwb6mpKLQda0E6XzNPxm6qluZCYOXi8OeWwxQ/IA/VavUuUCuX7cpJnOeIyIaE2ptyT67qXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TOLvAcxu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TOLvAcxu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B428EC433C7;
	Sat, 24 Feb 2024 01:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739377;
	bh=S5woWugwR5HfRwnq6ZOvJojSRu3YHk30lzlbgMhcnx0=;
	h=Date:To:From:Subject:From;
	b=TOLvAcxuxcf6vpKrL60R5WuCNbcTFCUgutwZDFup5DmVkyiBq0nUYcYhWhGyjo8OF
	 6HXmWKht9M/yf3pRTmD2mRqRrhN/hphDOWX2FICyvo4N7FUsGnB2ZkV4bTaCoVeOcB
	 SHjS+o41S1j5zu7TnU4PL7ZutxZPoLRdHGQtD7yU=
Date: Fri, 23 Feb 2024 17:49:37 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,paulmck@kernel.org,oleksiy.avramchenko@sony.com,lstoakes@gmail.com,Liam.Howlett@oracle.com,k-hagio-ab@nec.com,joel@joelfernandes.org,hch@lst.de,david@fromorbit.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-support-multiple-nodes-in-vread_iter.patch removed from -mm tree
Message-Id: <20240224014937.B428EC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmalloc: support multiple nodes in vread_iter
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-support-multiple-nodes-in-vread_iter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm: vmalloc: support multiple nodes in vread_iter
Date: Tue, 2 Jan 2024 19:46:30 +0100

Extend the vread_iter() to be able to perform a sequential reading of VAs
which are spread among multiple nodes.  So a data read over the /dev/kmem
correctly reflects a vmalloc memory layout.

Link: https://lkml.kernel.org/r/20240102184633.748113-9-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Kazuhito Hagio <k-hagio-ab@nec.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   67 ++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 53 insertions(+), 14 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-support-multiple-nodes-in-vread_iter
+++ a/mm/vmalloc.c
@@ -906,7 +906,7 @@ unsigned long vmalloc_nr_pages(void)
 
 /* Look up the first VA which satisfies addr < va_end, NULL if none. */
 static struct vmap_area *
-find_vmap_area_exceed_addr(unsigned long addr, struct rb_root *root)
+__find_vmap_area_exceed_addr(unsigned long addr, struct rb_root *root)
 {
 	struct vmap_area *va = NULL;
 	struct rb_node *n = root->rb_node;
@@ -930,6 +930,41 @@ find_vmap_area_exceed_addr(unsigned long
 	return va;
 }
 
+/*
+ * Returns a node where a first VA, that satisfies addr < va_end, resides.
+ * If success, a node is locked. A user is responsible to unlock it when a
+ * VA is no longer needed to be accessed.
+ *
+ * Returns NULL if nothing found.
+ */
+static struct vmap_node *
+find_vmap_area_exceed_addr_lock(unsigned long addr, struct vmap_area **va)
+{
+	struct vmap_node *vn, *va_node = NULL;
+	struct vmap_area *va_lowest;
+	int i;
+
+	for (i = 0; i < nr_vmap_nodes; i++) {
+		vn = &vmap_nodes[i];
+
+		spin_lock(&vn->busy.lock);
+		va_lowest = __find_vmap_area_exceed_addr(addr, &vn->busy.root);
+		if (va_lowest) {
+			if (!va_node || va_lowest->va_start < (*va)->va_start) {
+				if (va_node)
+					spin_unlock(&va_node->busy.lock);
+
+				*va = va_lowest;
+				va_node = vn;
+				continue;
+			}
+		}
+		spin_unlock(&vn->busy.lock);
+	}
+
+	return va_node;
+}
+
 static struct vmap_area *__find_vmap_area(unsigned long addr, struct rb_root *root)
 {
 	struct rb_node *n = root->rb_node;
@@ -4102,6 +4137,7 @@ long vread_iter(struct iov_iter *iter, c
 	struct vm_struct *vm;
 	char *vaddr;
 	size_t n, size, flags, remains;
+	unsigned long next;
 
 	addr = kasan_reset_tag(addr);
 
@@ -4111,19 +4147,15 @@ long vread_iter(struct iov_iter *iter, c
 
 	remains = count;
 
-	/* Hooked to node_0 so far. */
-	vn = addr_to_node(0);
-	spin_lock(&vn->busy.lock);
-
-	va = find_vmap_area_exceed_addr((unsigned long)addr, &vn->busy.root);
-	if (!va)
+	vn = find_vmap_area_exceed_addr_lock((unsigned long) addr, &va);
+	if (!vn)
 		goto finished_zero;
 
 	/* no intersects with alive vmap_area */
 	if ((unsigned long)addr + remains <= va->va_start)
 		goto finished_zero;
 
-	list_for_each_entry_from(va, &vn->busy.head, list) {
+	do {
 		size_t copied;
 
 		if (remains == 0)
@@ -4138,10 +4170,10 @@ long vread_iter(struct iov_iter *iter, c
 		WARN_ON(flags == VMAP_BLOCK);
 
 		if (!vm && !flags)
-			continue;
+			goto next_va;
 
 		if (vm && (vm->flags & VM_UNINITIALIZED))
-			continue;
+			goto next_va;
 
 		/* Pair with smp_wmb() in clear_vm_uninitialized_flag() */
 		smp_rmb();
@@ -4150,7 +4182,7 @@ long vread_iter(struct iov_iter *iter, c
 		size = vm ? get_vm_area_size(vm) : va_size(va);
 
 		if (addr >= vaddr + size)
-			continue;
+			goto next_va;
 
 		if (addr < vaddr) {
 			size_t to_zero = min_t(size_t, vaddr - addr, remains);
@@ -4179,15 +4211,22 @@ long vread_iter(struct iov_iter *iter, c
 
 		if (copied != n)
 			goto finished;
-	}
+
+	next_va:
+		next = va->va_end;
+		spin_unlock(&vn->busy.lock);
+	} while ((vn = find_vmap_area_exceed_addr_lock(next, &va)));
 
 finished_zero:
-	spin_unlock(&vn->busy.lock);
+	if (vn)
+		spin_unlock(&vn->busy.lock);
+
 	/* zero-fill memory holes */
 	return count - remains + zero_iter(iter, remains);
 finished:
 	/* Nothing remains, or We couldn't copy/zero everything. */
-	spin_unlock(&vn->busy.lock);
+	if (vn)
+		spin_unlock(&vn->busy.lock);
 
 	return count - remains;
 }
_

Patches currently in -mm which might be from urezki@gmail.com are


