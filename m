Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2778F5C
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 02:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706235410; cv=none; b=drAy4Novgfua3EnDS1ndlTcg0REmQ+bACRqSgfoshxAvk2nKCuJeM7MGSsyXCmu3jItnc8DyHulo2ZKlO2hQVakx0sicYn3AqkfQKxHXDC/gauhUXapV4Z15ORgMhbCtg6yqP9vha2t6BpOZ2M+3l4YJ8EtlpCx61dZYPpGLuh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706235410; c=relaxed/simple;
	bh=aApnxVIIHTmiTIsCDU6+bf8rbdIgQgoT5VVeNZsPrWU=;
	h=Date:To:From:Subject:Message-Id; b=PsAJwkhKYGWhuGNj1o9zXt2kuYsMOQl/Q6a917MpAS8W5iKzvln/xcqSutjuMEqGBh8WTlGF9RrLlfvhXsLbakiyYOzkq7+DjDT/+eFXfF/+oBYVJk37H44wUmMxr3uyOQkdbEnyxtIq4X2DangBlwNRkVa332eGVBuO4sCSonw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sS4IQ1Vx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sS4IQ1Vx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CFB8C43390;
	Fri, 26 Jan 2024 02:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706235409;
	bh=aApnxVIIHTmiTIsCDU6+bf8rbdIgQgoT5VVeNZsPrWU=;
	h=Date:To:From:Subject:From;
	b=sS4IQ1VxaFghx/KwEKiMjcEfb9XDevM2MYmfcVSU8ivYzS9m3zc+iX0iqTEh7r9HY
	 JxkbC7lOt24R6/zhjg8r9MqzUyIcXGAI2FEixOTMXG4q/SZ/ZO5Ynx/txyrsPOzWt6
	 jbeb983UdRDmkP8fEMoXPSyTdKP/myJKpN+4r8WE=
Date: Thu, 25 Jan 2024 18:16:46 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,oleksiy.avramchenko@sony.com,lstoakes@gmail.com,hch@infradead.org,david@fromorbit.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-refactor-vmalloc_dump_obj-function.patch added to mm-unstable branch
Message-Id: <20240126021649.4CFB8C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmalloc: refactor vmalloc_dump_obj() function
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-refactor-vmalloc_dump_obj-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-refactor-vmalloc_dump_obj-function.patch

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
Subject: mm: vmalloc: refactor vmalloc_dump_obj() function
Date: Wed, 24 Jan 2024 19:09:20 +0100

This patch tends to simplify the function in question, by removing an
extra stack "objp" variable, returning back to an early exit approach if
spin_trylock() fails or VA was not found.

Link: https://lkml.kernel.org/r/20240124180920.50725-2-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-refactor-vmalloc_dump_obj-function
+++ a/mm/vmalloc.c
@@ -4696,34 +4696,35 @@ void pcpu_free_vm_areas(struct vm_struct
 #ifdef CONFIG_PRINTK
 bool vmalloc_dump_obj(void *object)
 {
-	void *objp = (void *)PAGE_ALIGN((unsigned long)object);
 	const void *caller;
+	struct vm_struct *vm;
 	struct vmap_area *va;
 	struct vmap_node *vn;
 	unsigned long addr;
 	unsigned int nr_pages;
-	bool success = false;
 
-	vn = addr_to_node((unsigned long)objp);
+	addr = PAGE_ALIGN((unsigned long) object);
+	vn = addr_to_node(addr);
 
-	if (spin_trylock(&vn->busy.lock)) {
-		va = __find_vmap_area((unsigned long)objp, &vn->busy.root);
-
-		if (va && va->vm) {
-			addr = (unsigned long)va->vm->addr;
-			caller = va->vm->caller;
-			nr_pages = va->vm->nr_pages;
-			success = true;
-		}
+	if (!spin_trylock(&vn->busy.lock))
+		return false;
 
+	va = __find_vmap_area(addr, &vn->busy.root);
+	if (!va || !va->vm) {
 		spin_unlock(&vn->busy.lock);
+		return false;
 	}
 
-	if (success)
-		pr_cont(" %u-page vmalloc region starting at %#lx allocated at %pS\n",
-			nr_pages, addr, caller);
+	vm = va->vm;
+	addr = (unsigned long) vm->addr;
+	caller = vm->caller;
+	nr_pages = vm->nr_pages;
+	spin_unlock(&vn->busy.lock);
+
+	pr_cont(" %u-page vmalloc region starting at %#lx allocated at %pS\n",
+		nr_pages, addr, caller);
 
-	return success;
+	return true;
 }
 #endif
 
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-add-va_alloc-helper.patch
mm-vmalloc-rename-adjust_va_to_fit_type-function.patch
mm-vmalloc-move-vmap_init_free_space-down-in-vmallocc.patch
mm-vmalloc-remove-global-vmap_area_root-rb-tree.patch
mm-vmalloc-remove-global-vmap_area_root-rb-tree-fix.patch
mm-vmalloc-remove-global-vmap_area_root-rb-tree-fix-2.patch
mm-vmalloc-remove-vmap_area_list-fix.patch
mm-vmalloc-remove-global-purge_vmap_area_root-rb-tree.patch
mm-vmalloc-offload-free_vmap_area_lock-lock.patch
mm-vmalloc-support-multiple-nodes-in-vread_iter.patch
mm-vmalloc-support-multiple-nodes-in-vmallocinfo.patch
mm-vmalloc-set-nr_nodes-based-on-cpus-in-a-system.patch
mm-vmalloc-add-a-shrinker-to-drain-vmap-pools.patch
mm-vmalloc-improve-description-of-vmap-node-layer.patch
mm-vmalloc-refactor-vmalloc_dump_obj-function.patch

