Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2DB1C71153
	for <mm-commits@archiver.kernel.org>; Mon,  4 Sep 2023 19:54:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235721AbjIDTyV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Sep 2023 15:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235876AbjIDTyR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Sep 2023 15:54:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E85F912E
        for <mm-commits@vger.kernel.org>; Mon,  4 Sep 2023 12:54:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 515B6CE0EA6
        for <mm-commits@vger.kernel.org>; Mon,  4 Sep 2023 19:54:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE62C433C7;
        Mon,  4 Sep 2023 19:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693857250;
        bh=2ypn6h8st/wDhWu2GBGUh1d5KllH9EQctVn78yWrD1M=;
        h=Date:To:From:Subject:From;
        b=WX+vfNoiaS5PlqqNt1YtmHOGvU6uO29c7RZzEOz9wmKZOQR7+Dr5iLmxOnYoqhrdV
         K99vwXaNDtjmw2wPDptwNXZ8EKNlFS9nnXQBnFS4YDk0tq6cbAhfODLNQLdSJD7eVS
         7kU46I868HGlEp+UGrCNLRQJj7X79m4qex522DqA=
Date:   Mon, 04 Sep 2023 12:54:10 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        paulmck@kernel.org, oleksiy.avramchenko@sony.com,
        lstoakes@gmail.com, Liam.Howlett@oracle.com,
        joel@joelfernandes.org, hch@lst.de, david@fromorbit.com,
        bhe@redhat.com, urezki@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-support-multiple-nodes-in-vread_iter.patch added to mm-unstable branch
Message-Id: <20230904195410.9DE62C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmalloc: support multiple nodes in vread_iter
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-support-multiple-nodes-in-vread_iter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-support-multiple-nodes-in-vread_iter.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm: vmalloc: support multiple nodes in vread_iter
Date: Tue, 29 Aug 2023 10:11:40 +0200

Extend the vread_iter() to be able to perform a sequential reading of VAs
which are spread among multiple nodes.  So a data read over the /dev/kmem
correctly reflects a vmalloc memory layout.

Link: https://lkml.kernel.org/r/20230829081142.3619-8-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
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
@@ -870,7 +870,7 @@ unsigned long vmalloc_nr_pages(void)
 
 /* Look up the first VA which satisfies addr < va_end, NULL if none. */
 static struct vmap_area *
-find_vmap_area_exceed_addr(unsigned long addr, struct rb_root *root)
+__find_vmap_area_exceed_addr(unsigned long addr, struct rb_root *root)
 {
 	struct vmap_area *va = NULL;
 	struct rb_node *n = root->rb_node;
@@ -894,6 +894,41 @@ find_vmap_area_exceed_addr(unsigned long
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
+	for (i = 0; i < nr_nodes; i++) {
+		vn = &nodes[i];
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
@@ -4052,6 +4087,7 @@ long vread_iter(struct iov_iter *iter, c
 	struct vm_struct *vm;
 	char *vaddr;
 	size_t n, size, flags, remains;
+	unsigned long next;
 
 	addr = kasan_reset_tag(addr);
 
@@ -4061,19 +4097,15 @@ long vread_iter(struct iov_iter *iter, c
 
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
@@ -4088,10 +4120,10 @@ long vread_iter(struct iov_iter *iter, c
 		WARN_ON(flags == VMAP_BLOCK);
 
 		if (!vm && !flags)
-			continue;
+			goto next_va;
 
 		if (vm && (vm->flags & VM_UNINITIALIZED))
-			continue;
+			goto next_va;
 
 		/* Pair with smp_wmb() in clear_vm_uninitialized_flag() */
 		smp_rmb();
@@ -4100,7 +4132,7 @@ long vread_iter(struct iov_iter *iter, c
 		size = vm ? get_vm_area_size(vm) : va_size(va);
 
 		if (addr >= vaddr + size)
-			continue;
+			goto next_va;
 
 		if (addr < vaddr) {
 			size_t to_zero = min_t(size_t, vaddr - addr, remains);
@@ -4129,15 +4161,22 @@ long vread_iter(struct iov_iter *iter, c
 
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

mm-vmalloc-add-va_alloc-helper.patch
mm-vmalloc-rename-adjust_va_to_fit_type-function.patch
mm-vmalloc-move-vmap_init_free_space-down-in-vmallocc.patch
mm-vmalloc-remove-global-vmap_area_root-rb-tree.patch
mm-vmalloc-remove-global-vmap_area_root-rb-tree-fix.patch
mm-vmalloc-remove-global-purge_vmap_area_root-rb-tree.patch
mm-vmalloc-offload-free_vmap_area_lock-lock.patch
mm-vmalloc-support-multiple-nodes-in-vread_iter.patch
mm-vmalloc-support-multiple-nodes-in-vmallocinfo.patch
mm-vmalloc-set-nr_nodes-node_size-based-on-cpu-cores.patch

