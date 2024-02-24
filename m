Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347FF4688
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739379; cv=none; b=bg7xOM2K2OSbF/JKk53w4zdbF5hlPZjfXCKImUoOHlABxdP5C85ddS2l06HE0uAwPCCN5DBbGVP3MlAGIZEqFc47gqXlDLM5839+5iytN/2sl6uVhPmQvKwXAZTaEPSwVutgV6WZp99l9x+jgUedqdmaKwL5nduVd+5Yo1K67u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739379; c=relaxed/simple;
	bh=nA7h1RZy78iafipvKP+drTaLTzhg0UwMPvctbe1ccio=;
	h=Date:To:From:Subject:Message-Id; b=BAtT/jYWE7VWYVTiKs/Bbf5l2uxSrYqY85Cf9EqlwsCoN9WpEUQXbsJF4xgT+TskEYKON6TyxTLeIN+Y//cND917sKIKQXSn3MQkJ3NDD8bnHdej052g/V3qJSb609+v1Q2hgSa4VI1TACEW4tMY7A1fEEULIVGnr2FvDWIJe7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N0U4lyhz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N0U4lyhz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA2EC433C7;
	Sat, 24 Feb 2024 01:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739379;
	bh=nA7h1RZy78iafipvKP+drTaLTzhg0UwMPvctbe1ccio=;
	h=Date:To:From:Subject:From;
	b=N0U4lyhz8eDlbCPiXU+Ih+fzcoCSyjZqzm0eKHIIEKMuJ0Fl2H7pGk4dv2Uz9hbE4
	 3PkdFogCBnaVwYu3H3ee1ipZlAVRlNgI3QyHAXKyLo+OOlXecrr13BPi0bVA5aRk0C
	 xTPvLpBN9ZS6kIc7w7OF3j5B2pJ0LtZjxR9CF8ic=
Date: Fri, 23 Feb 2024 17:49:38 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,paulmck@kernel.org,oleksiy.avramchenko@sony.com,lstoakes@gmail.com,Liam.Howlett@oracle.com,k-hagio-ab@nec.com,joel@joelfernandes.org,hch@lst.de,david@fromorbit.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-support-multiple-nodes-in-vmallocinfo.patch removed from -mm tree
Message-Id: <20240224014938.EEA2EC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmalloc: support multiple nodes in vmallocinfo
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-support-multiple-nodes-in-vmallocinfo.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


