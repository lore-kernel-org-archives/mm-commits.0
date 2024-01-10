Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B8232C7A
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 06:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BfkffgX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E443C433C7;
	Wed, 10 Jan 2024 06:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704867813;
	bh=okbG0/LhLIzPmlmJ8ZKkiEvegycyKoYsAdaQLi6Vsag=;
	h=Date:To:From:Subject:From;
	b=BfkffgX2dVITeq7xgcVfx3cUcJetu0pPuGGTCfKkXs0qmFJAdC3ytFhoVqAyXnRJp
	 7Xg/ClhlHRQYOuKEe+ph8vKHBUtdPD0QB5cTThe4e+Yg8CxDNJGtB/ohgxx7EXGNcE
	 wwVFfZQaAmkGn6Sskh0qnk0MJ2qdMw/5TwOAnJeU=
Date: Tue, 09 Jan 2024 22:23:32 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,paulmck@kernel.org,oleksiy.avramchenko@sony.com,lstoakes@gmail.com,Liam.Howlett@oracle.com,k-hagio-ab@nec.com,joel@joelfernandes.org,hch@lst.de,david@fromorbit.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-support-multiple-nodes-in-vmallocinfo.patch added to mm-unstable branch
Message-Id: <20240110062333.3E443C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmalloc: support multiple nodes in vmallocinfo
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-support-multiple-nodes-in-vmallocinfo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-support-multiple-nodes-in-vmallocinfo.patch

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
Subject: mm: vmalloc: support multiple nodes in vmallocinfo
Date: Tue, 2 Jan 2024 19:46:31 +0100

Allocated areas are spread among nodes, it implies that the scanning has
to be performed individually of each node in order to dump all existing
VAs.

Link: https://lkml.kernel.org/r/20240102184633.748113-10-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
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

 mm/vmalloc.c |  120 +++++++++++++++++++------------------------------
 1 file changed, 47 insertions(+), 73 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-support-multiple-nodes-in-vmallocinfo
+++ a/mm/vmalloc.c
@@ -4709,30 +4709,6 @@ bool vmalloc_dump_obj(void *object)
 #endif
 
 #ifdef CONFIG_PROC_FS
-static void *s_start(struct seq_file *m, loff_t *pos)
-{
-	struct vmap_node *vn = addr_to_node(0);
-
-	mutex_lock(&vmap_purge_lock);
-	spin_lock(&vn->busy.lock);
-
-	return seq_list_start(&vn->busy.head, *pos);
-}
-
-static void *s_next(struct seq_file *m, void *p, loff_t *pos)
-{
-	struct vmap_node *vn = addr_to_node(0);
-	return seq_list_next(p, &vn->busy.head, pos);
-}
-
-static void s_stop(struct seq_file *m, void *p)
-{
-	struct vmap_node *vn = addr_to_node(0);
-
-	spin_unlock(&vn->busy.lock);
-	mutex_unlock(&vmap_purge_lock);
-}
-
 static void show_numa_info(struct seq_file *m, struct vm_struct *v)
 {
 	if (IS_ENABLED(CONFIG_NUMA)) {
@@ -4776,84 +4752,82 @@ static void show_purge_info(struct seq_f
 	}
 }
 
-static int s_show(struct seq_file *m, void *p)
+static int vmalloc_info_show(struct seq_file *m, void *p)
 {
 	struct vmap_node *vn;
 	struct vmap_area *va;
 	struct vm_struct *v;
+	int i;
 
-	vn = addr_to_node(0);
-	va = list_entry(p, struct vmap_area, list);
+	for (i = 0; i < nr_vmap_nodes; i++) {
+		vn = &vmap_nodes[i];
 
-	if (!va->vm) {
-		if (va->flags & VMAP_RAM)
-			seq_printf(m, "0x%pK-0x%pK %7ld vm_map_ram\n",
-				(void *)va->va_start, (void *)va->va_end,
-				va->va_end - va->va_start);
+		spin_lock(&vn->busy.lock);
+		list_for_each_entry(va, &vn->busy.head, list) {
+			if (!va->vm) {
+				if (va->flags & VMAP_RAM)
+					seq_printf(m, "0x%pK-0x%pK %7ld vm_map_ram\n",
+						(void *)va->va_start, (void *)va->va_end,
+						va->va_end - va->va_start);
 
-		goto final;
-	}
+				continue;
+			}
 
-	v = va->vm;
+			v = va->vm;
 
-	seq_printf(m, "0x%pK-0x%pK %7ld",
-		v->addr, v->addr + v->size, v->size);
+			seq_printf(m, "0x%pK-0x%pK %7ld",
+				v->addr, v->addr + v->size, v->size);
 
-	if (v->caller)
-		seq_printf(m, " %pS", v->caller);
+			if (v->caller)
+				seq_printf(m, " %pS", v->caller);
 
-	if (v->nr_pages)
-		seq_printf(m, " pages=%d", v->nr_pages);
+			if (v->nr_pages)
+				seq_printf(m, " pages=%d", v->nr_pages);
 
-	if (v->phys_addr)
-		seq_printf(m, " phys=%pa", &v->phys_addr);
+			if (v->phys_addr)
+				seq_printf(m, " phys=%pa", &v->phys_addr);
 
-	if (v->flags & VM_IOREMAP)
-		seq_puts(m, " ioremap");
+			if (v->flags & VM_IOREMAP)
+				seq_puts(m, " ioremap");
 
-	if (v->flags & VM_ALLOC)
-		seq_puts(m, " vmalloc");
+			if (v->flags & VM_ALLOC)
+				seq_puts(m, " vmalloc");
 
-	if (v->flags & VM_MAP)
-		seq_puts(m, " vmap");
+			if (v->flags & VM_MAP)
+				seq_puts(m, " vmap");
 
-	if (v->flags & VM_USERMAP)
-		seq_puts(m, " user");
+			if (v->flags & VM_USERMAP)
+				seq_puts(m, " user");
 
-	if (v->flags & VM_DMA_COHERENT)
-		seq_puts(m, " dma-coherent");
+			if (v->flags & VM_DMA_COHERENT)
+				seq_puts(m, " dma-coherent");
 
-	if (is_vmalloc_addr(v->pages))
-		seq_puts(m, " vpages");
+			if (is_vmalloc_addr(v->pages))
+				seq_puts(m, " vpages");
 
-	show_numa_info(m, v);
-	seq_putc(m, '\n');
+			show_numa_info(m, v);
+			seq_putc(m, '\n');
+		}
+		spin_unlock(&vn->busy.lock);
+	}
 
 	/*
 	 * As a final step, dump "unpurged" areas.
 	 */
-final:
-	if (list_is_last(&va->list, &vn->busy.head))
-		show_purge_info(m);
-
+	show_purge_info(m);
 	return 0;
 }
 
-static const struct seq_operations vmalloc_op = {
-	.start = s_start,
-	.next = s_next,
-	.stop = s_stop,
-	.show = s_show,
-};
-
 static int __init proc_vmalloc_init(void)
 {
+	void *priv_data = NULL;
+
 	if (IS_ENABLED(CONFIG_NUMA))
-		proc_create_seq_private("vmallocinfo", 0400, NULL,
-				&vmalloc_op,
-				nr_node_ids * sizeof(unsigned int), NULL);
-	else
-		proc_create_seq("vmallocinfo", 0400, NULL, &vmalloc_op);
+		priv_data = kmalloc(nr_node_ids * sizeof(unsigned int), GFP_KERNEL);
+
+	proc_create_single_data("vmallocinfo",
+		0400, NULL, vmalloc_info_show, priv_data);
+
 	return 0;
 }
 module_init(proc_vmalloc_init);
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-add-va_alloc-helper.patch
mm-vmalloc-rename-adjust_va_to_fit_type-function.patch
mm-vmalloc-move-vmap_init_free_space-down-in-vmallocc.patch
mm-vmalloc-remove-global-vmap_area_root-rb-tree.patch
mm-vmalloc-remove-global-purge_vmap_area_root-rb-tree.patch
mm-vmalloc-offload-free_vmap_area_lock-lock.patch
mm-vmalloc-support-multiple-nodes-in-vread_iter.patch
mm-vmalloc-support-multiple-nodes-in-vmallocinfo.patch
mm-vmalloc-set-nr_nodes-based-on-cpus-in-a-system.patch
mm-vmalloc-add-a-shrinker-to-drain-vmap-pools.patch

