Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1FF3C76195
	for <mm-commits@archiver.kernel.org>; Mon, 27 Mar 2023 20:02:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbjC0UCv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Mar 2023 16:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjC0UCu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Mar 2023 16:02:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E7BCC
        for <mm-commits@vger.kernel.org>; Mon, 27 Mar 2023 13:02:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67C0C614BE
        for <mm-commits@vger.kernel.org>; Mon, 27 Mar 2023 20:02:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5A08C433D2;
        Mon, 27 Mar 2023 20:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679947367;
        bh=r2BMwQdo7nS9VTafVns/LF2nDaHd6QAWL6ovuEb1Nyc=;
        h=Date:To:From:Subject:From;
        b=BQsAYpG3/kGMX7j+63sEYwnbsPfZExk7Jit74uBI+t5PeUNhNTLCX5rZ/2hekguCO
         vS8pJgSlcWM73HSbrBCO6UfNPj/iOQInqHOJqslSes7TzOujyHa9jUqp8+LgilY1jB
         G0lBJL3S8RoWSUx6y/9EC4j5OqsD2tA7Qc4a9dhg=
Date:   Mon, 27 Mar 2023 13:02:46 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        oleksiy.avramchenko@sony.com, lstoakes@gmail.com,
        hch@infradead.org, david@fromorbit.com, bhe@redhat.com,
        urezki@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-remove-a-global-vmap_blocks-xarray.patch added to mm-unstable branch
Message-Id: <20230327200247.B5A08C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmalloc: remove a global vmap_blocks xarray
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-remove-a-global-vmap_blocks-xarray.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-remove-a-global-vmap_blocks-xarray.patch

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
Subject: mm: vmalloc: remove a global vmap_blocks xarray
Date: Mon, 27 Mar 2023 19:01:25 +0200

A global vmap_blocks-xarray array can be contented under heavy usage of
the vm_map_ram()/vm_unmap_ram() APIs.  The lock_stat shows that a
"vmap_blocks.xa_lock" lock is a second in a top-list when it comes to
contentions:

<snip>
----------------------------------------
class name con-bounces contentions ...
----------------------------------------
vmap_area_lock:         2554079 2554276 ...
  --------------
  vmap_area_lock        1297948  [<00000000dd41cbaa>] alloc_vmap_area+0x1c7/0x910
  vmap_area_lock        1256330  [<000000009d927bf3>] free_vmap_block+0x4a/0xe0
  vmap_area_lock              1  [<00000000c95c05a7>] find_vm_area+0x16/0x70
  --------------
  vmap_area_lock        1738590  [<00000000dd41cbaa>] alloc_vmap_area+0x1c7/0x910
  vmap_area_lock         815688  [<000000009d927bf3>] free_vmap_block+0x4a/0xe0
  vmap_area_lock              1  [<00000000c1d619d7>] __get_vm_area_node+0xd2/0x170

vmap_blocks.xa_lock:    862689  862698 ...
  -------------------
  vmap_blocks.xa_lock   378418    [<00000000625a5626>] vm_map_ram+0x359/0x4a0
  vmap_blocks.xa_lock   484280    [<00000000caa2ef03>] xa_erase+0xe/0x30
  -------------------
  vmap_blocks.xa_lock   576226    [<00000000caa2ef03>] xa_erase+0xe/0x30
  vmap_blocks.xa_lock   286472    [<00000000625a5626>] vm_map_ram+0x359/0x4a0
...
<snip>

that is a result of running vm_map_ram()/vm_unmap_ram() in
a loop. The test creates 64(on 64 CPUs system) threads and
each one maps/unmaps 1 page.

After this change the "xa_lock" can be considered as a noise
in the same test condition:

<snip>
...
&xa->xa_lock#1:         10333 10394 ...
  --------------
  &xa->xa_lock#1        5349      [<00000000bbbc9751>] xa_erase+0xe/0x30
  &xa->xa_lock#1        5045      [<0000000018def45d>] vm_map_ram+0x3a4/0x4f0
  --------------
  &xa->xa_lock#1        7326      [<0000000018def45d>] vm_map_ram+0x3a4/0x4f0
  &xa->xa_lock#1        3068      [<00000000bbbc9751>] xa_erase+0xe/0x30
...
<snip>

This patch does not fix vmap_area_lock/free_vmap_area_lock and
purge_vmap_area_lock bottle-necks, it is rather a separate rework.

Link: https://lkml.kernel.org/r/20230327170126.406044-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   85 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 64 insertions(+), 21 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-remove-a-global-vmap_blocks-xarray
+++ a/mm/vmalloc.c
@@ -1908,9 +1908,22 @@ static struct vmap_area *find_unlink_vma
 #define VMAP_BLOCK		0x2 /* mark out the vmap_block sub-type*/
 #define VMAP_FLAGS_MASK		0x3
 
+/*
+ * We should probably have a fallback mechanism to allocate virtual memory
+ * out of partially filled vmap blocks. However vmap block sizing should be
+ * fairly reasonable according to the vmalloc size, so it shouldn't be a
+ * big problem.
+ */
 struct vmap_block_queue {
 	spinlock_t lock;
 	struct list_head free;
+
+	/*
+	 * An xarray requires an extra memory dynamically to
+	 * be allocated. If it is an issue, we can use rb-tree
+	 * instead.
+	 */
+	struct xarray vmap_blocks;
 };
 
 struct vmap_block {
@@ -1928,24 +1941,46 @@ struct vmap_block {
 static DEFINE_PER_CPU(struct vmap_block_queue, vmap_block_queue);
 
 /*
- * XArray of vmap blocks, indexed by address, to quickly find a vmap block
- * in the free path. Could get rid of this if we change the API to return a
- * "cookie" from alloc, to be passed to free. But no big deal yet.
+ * In order to fast access to any "vmap_block" associated with a
+ * specific address, we store them into a per-cpu xarray. A hash
+ * function is addr_to_vbq() whereas a key is a vb->va->va_start
+ * value.
+ *
+ * Please note, a vmap_block_queue, which is a per-cpu, is not
+ * serialized by a raw_smp_processor_id() current CPU, instead
+ * it is chosen based on a CPU-index it belongs to, i.e. it is
+ * a hash-table.
+ *
+ * An example:
+ *
+ *  CPU_1  CPU_2  CPU_0
+ *    |      |      |
+ *    V      V      V
+ * 0     10     20     30     40     50     60
+ * |------|------|------|------|------|------|...<vmap address space>
+ *   CPU0   CPU1   CPU2   CPU0   CPU1   CPU2
+ *
+ * - CPU_1 invokes vm_unmap_ram(6), 6 belongs to CPU0 zone, thus
+ *   it access: CPU0/INDEX0 -> vmap_blocks -> xa_lock;
+ *
+ * - CPU_2 invokes vm_unmap_ram(11), 11 belongs to CPU1 zone, thus
+ *   it access: CPU1/INDEX1 -> vmap_blocks -> xa_lock;
+ *
+ * - CPU_0 invokes vm_unmap_ram(20), 20 belongs to CPU2 zone, thus
+ *   it access: CPU2/INDEX2 -> vmap_blocks -> xa_lock.
  */
-static DEFINE_XARRAY(vmap_blocks);
+static struct vmap_block_queue *
+addr_to_vbq(unsigned long addr)
+{
+	int index = (addr / VMAP_BLOCK_SIZE) % num_possible_cpus();
 
-/*
- * We should probably have a fallback mechanism to allocate virtual memory
- * out of partially filled vmap blocks. However vmap block sizing should be
- * fairly reasonable according to the vmalloc size, so it shouldn't be a
- * big problem.
- */
+	return &per_cpu(vmap_block_queue, index);
+}
 
-static unsigned long addr_to_vb_idx(unsigned long addr)
+static unsigned long
+addr_to_vb_va_start(unsigned long addr)
 {
-	addr -= VMALLOC_START & ~(VMAP_BLOCK_SIZE-1);
-	addr /= VMAP_BLOCK_SIZE;
-	return addr;
+	return rounddown(addr, VMAP_BLOCK_SIZE);
 }
 
 static void *vmap_block_vaddr(unsigned long va_start, unsigned long pages_off)
@@ -1953,7 +1988,7 @@ static void *vmap_block_vaddr(unsigned l
 	unsigned long addr;
 
 	addr = va_start + (pages_off << PAGE_SHIFT);
-	BUG_ON(addr_to_vb_idx(addr) != addr_to_vb_idx(va_start));
+	WARN_ON_ONCE(addr_to_vb_va_start(addr) != va_start);
 	return (void *)addr;
 }
 
@@ -1970,7 +2005,6 @@ static void *new_vmap_block(unsigned int
 	struct vmap_block_queue *vbq;
 	struct vmap_block *vb;
 	struct vmap_area *va;
-	unsigned long vb_idx;
 	int node, err;
 	void *vaddr;
 
@@ -2003,8 +2037,8 @@ static void *new_vmap_block(unsigned int
 	bitmap_set(vb->used_map, 0, (1UL << order));
 	INIT_LIST_HEAD(&vb->free_list);
 
-	vb_idx = addr_to_vb_idx(va->va_start);
-	err = xa_insert(&vmap_blocks, vb_idx, vb, gfp_mask);
+	vbq = addr_to_vbq(va->va_start);
+	err = xa_insert(&vbq->vmap_blocks, va->va_start, vb, gfp_mask);
 	if (err) {
 		kfree(vb);
 		free_vmap_area(va);
@@ -2021,9 +2055,11 @@ static void *new_vmap_block(unsigned int
 
 static void free_vmap_block(struct vmap_block *vb)
 {
+	struct vmap_block_queue *vbq;
 	struct vmap_block *tmp;
 
-	tmp = xa_erase(&vmap_blocks, addr_to_vb_idx(vb->va->va_start));
+	vbq = addr_to_vbq(vb->va->va_start);
+	tmp = xa_erase(&vbq->vmap_blocks, vb->va->va_start);
 	BUG_ON(tmp != vb);
 
 	spin_lock(&vmap_area_lock);
@@ -2135,6 +2171,7 @@ static void vb_free(unsigned long addr,
 	unsigned long offset;
 	unsigned int order;
 	struct vmap_block *vb;
+	struct vmap_block_queue *vbq;
 
 	BUG_ON(offset_in_page(size));
 	BUG_ON(size > PAGE_SIZE*VMAP_MAX_ALLOC);
@@ -2143,7 +2180,10 @@ static void vb_free(unsigned long addr,
 
 	order = get_order(size);
 	offset = (addr & (VMAP_BLOCK_SIZE - 1)) >> PAGE_SHIFT;
-	vb = xa_load(&vmap_blocks, addr_to_vb_idx(addr));
+
+	vbq = addr_to_vbq(addr);
+	vb = xa_load(&vbq->vmap_blocks, addr_to_vb_va_start(addr));
+
 	spin_lock(&vb->lock);
 	bitmap_clear(vb->used_map, offset, (1UL << order));
 	spin_unlock(&vb->lock);
@@ -3519,6 +3559,7 @@ static size_t vmap_ram_vread_iter(struct
 {
 	char *start;
 	struct vmap_block *vb;
+	struct vmap_block_queue *vbq;
 	unsigned long offset;
 	unsigned int rs, re;
 	size_t remains, n;
@@ -3537,7 +3578,8 @@ static size_t vmap_ram_vread_iter(struct
 	 * Area is split into regions and tracked with vmap_block, read out
 	 * each region and zero fill the hole between regions.
 	 */
-	vb = xa_load(&vmap_blocks, addr_to_vb_idx((unsigned long)addr));
+	vbq = addr_to_vbq((unsigned long) addr);
+	vb = xa_load(&vbq->vmap_blocks, addr_to_vb_va_start((unsigned long) addr));
 	if (!vb)
 		goto finished_zero;
 
@@ -4331,6 +4373,7 @@ void __init vmalloc_init(void)
 		p = &per_cpu(vfree_deferred, i);
 		init_llist_head(&p->list);
 		INIT_WORK(&p->wq, delayed_vfree_work);
+		xa_init(&vbq->vmap_blocks);
 	}
 
 	/* Import existing vmlist entries. */
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-remove-a-global-vmap_blocks-xarray.patch
lib-test_vmallocc-add-vm_map_ram-vm_unmap_ram-test-case.patch

