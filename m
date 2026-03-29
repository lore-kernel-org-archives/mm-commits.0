Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641631FE471
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744766; cv=none; b=QD/LsnPL5/3yAD4Qr33sctV4iFN2najtyjXvJJIIBCycUgw6VpogK+dVbpV1tRqFhyh8czEbufO9TffyEEUUUQqLBmS1iULs3zks79HZsF2mBnQzuZaRWsJ/3kWopAYOZxuTKkyA52GdVB2Vk+S/wVyQDdVc1LmqscN8Db1F+Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744766; c=relaxed/simple;
	bh=DDsvChVWjr27xmKzbmsqZKwPec7VOHMe25Wp5pd8jQE=;
	h=Date:To:From:Subject:Message-Id; b=UsY+xYK4fv44SIJyVLKr5dDIYAPvIKZgbdlRUh4LbWQpfJjYpNJAHi4wqWq8V7FLrqSuQVOfrMyGC89VRo5L1VvZ31mqHmH8qUlW6p52/U8n86yqi6FCS8F7hRKu4Vto7a6jGM1234nkGxs4+sBg67NEEo7fT19kHdiPisABb2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q6ER2vKe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q6ER2vKe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36FB3C4CEF7;
	Sun, 29 Mar 2026 00:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744766;
	bh=DDsvChVWjr27xmKzbmsqZKwPec7VOHMe25Wp5pd8jQE=;
	h=Date:To:From:Subject:From;
	b=q6ER2vKez/84seDd235O+GvrEssy4WSc6TVOxZmtHkQveJ1QVRQyQdISU8+rsHf5p
	 bduAcazu6IpdKMax+cJW7X3ADK784015xU51OT3CTmKavpM/jTftCgNC8f1fHZJCDr
	 8WzwquUUWHZPhRIjIRmVyfQNswtJXwcktNFQ6jd4=
Date: Sat, 28 Mar 2026 17:39:25 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vincenzo.frascino@arm.com,tursulin@ursulin.net,tkjos@android.com,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rodrigo.vivi@intel.com,rientjes@google.com,pfalcato@suse.de,peterz@infradead.org,pabeni@redhat.com,ojeda@kernel.org,ncardwell@google.com,namhyung@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maddy@linux.ibm.com,luto@kernel.org,ljs@kernel.org,liam.howlett@oracle.com,leon@kernel.org,kuba@kernel.org,joonas.lahtinen@linux.intel.com,jgg@ziepe.ca,jarkko@kernel.org,jannh@google.com,jani.nikula@linux.intel.com,imbrenda@linux.ibm.com,hsweeten@visionengravers.com,hca@linux.ibm.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,edumazet@google.com,dsahern@kernel.org,dimitri.sivanich@hpe.com,davem@davemloft.net,daniel@iogearbox.net,cmllamas@google.com,brauner@kernel.org,bp@alien8.de,borntraeger@linux.ibm.com,ast@kernel.org,arve@android.com,arnd@arndb.de,andrii@kernel.org,aliceryhl@google.com,airlied@gmail.com,agordeev@linux.ibm.com,acme@kernel.org,abbotti@mev.co.uk,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rename-zap_vma_ptes-to-zap_special_vma_range.patch removed from -mm tree
Message-Id: <20260329003926.36FB3C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: rename zap_vma_ptes() to zap_special_vma_range()
has been removed from the -mm tree.  Its filename was
     mm-rename-zap_vma_ptes-to-zap_special_vma_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm: rename zap_vma_ptes() to zap_special_vma_range()
Date: Fri, 27 Feb 2026 21:08:46 +0100

zap_vma_ptes() is the only zapping function we export to modules.

It's essentially a wrapper around zap_vma_range(), however, with some
safety checks:
* That the passed range fits fully into the VMA
* That it's only used for VM_PFNMAP

We will add support for VM_MIXEDMAP next, so use the more-generic term
"special vma", although "special" is a bit overloaded.  Maybe we'll later
just support any VM_SPECIAL flag.

While at it, improve the kerneldoc.

Link: https://lkml.kernel.org/r/20260227200848.114019-16-david@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Leon Romanovsky <leon@kernel.org>	[drivers/infiniband]
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Arve <arve@android.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Carlos Llamas <cmllamas@google.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Daniel Borkman <daniel@iogearbox.net>
Cc: Dave Airlie <airlied@gmail.com>
Cc: David Ahern <dsahern@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dimitri Sivanich <dimitri.sivanich@hpe.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Namhyung kim <namhyung@kernel.org>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Todd Kjos <tkjos@android.com>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/sgx/encl.c        |    2 +-
 drivers/comedi/comedi_fops.c          |    2 +-
 drivers/gpu/drm/i915/i915_mm.c        |    4 ++--
 drivers/infiniband/core/uverbs_main.c |    6 +++---
 drivers/misc/sgi-gru/grumain.c        |    2 +-
 include/linux/mm.h                    |    2 +-
 mm/memory.c                           |   16 +++++++---------
 7 files changed, 16 insertions(+), 18 deletions(-)

--- a/arch/x86/kernel/cpu/sgx/encl.c~mm-rename-zap_vma_ptes-to-zap_special_vma_range
+++ a/arch/x86/kernel/cpu/sgx/encl.c
@@ -1220,7 +1220,7 @@ void sgx_zap_enclave_ptes(struct sgx_enc
 
 			ret = sgx_encl_find(encl_mm->mm, addr, &vma);
 			if (!ret && encl == vma->vm_private_data)
-				zap_vma_ptes(vma, addr, PAGE_SIZE);
+				zap_special_vma_range(vma, addr, PAGE_SIZE);
 
 			mmap_read_unlock(encl_mm->mm);
 
--- a/drivers/comedi/comedi_fops.c~mm-rename-zap_vma_ptes-to-zap_special_vma_range
+++ a/drivers/comedi/comedi_fops.c
@@ -2588,7 +2588,7 @@ static int comedi_mmap(struct file *file
 	 * remap_pfn_range() because we call remap_pfn_range() in a loop.
 	 */
 	if (retval)
-		zap_vma_ptes(vma, vma->vm_start, size);
+		zap_special_vma_range(vma, vma->vm_start, size);
 #endif
 
 	if (retval == 0) {
--- a/drivers/gpu/drm/i915/i915_mm.c~mm-rename-zap_vma_ptes-to-zap_special_vma_range
+++ a/drivers/gpu/drm/i915/i915_mm.c
@@ -108,7 +108,7 @@ int remap_io_mapping(struct vm_area_stru
 
 	err = apply_to_page_range(r.mm, addr, size, remap_pfn, &r);
 	if (unlikely(err)) {
-		zap_vma_ptes(vma, addr, (r.pfn - pfn) << PAGE_SHIFT);
+		zap_special_vma_range(vma, addr, (r.pfn - pfn) << PAGE_SHIFT);
 		return err;
 	}
 
@@ -156,7 +156,7 @@ int remap_io_sg(struct vm_area_struct *v
 
 	err = apply_to_page_range(r.mm, addr, size, remap_sg, &r);
 	if (unlikely(err)) {
-		zap_vma_ptes(vma, addr, r.pfn << PAGE_SHIFT);
+		zap_special_vma_range(vma, addr, r.pfn << PAGE_SHIFT);
 		return err;
 	}
 
--- a/drivers/infiniband/core/uverbs_main.c~mm-rename-zap_vma_ptes-to-zap_special_vma_range
+++ a/drivers/infiniband/core/uverbs_main.c
@@ -756,7 +756,7 @@ out_zap:
 	 * point, so zap it.
 	 */
 	vma->vm_private_data = NULL;
-	zap_vma_ptes(vma, vma->vm_start, vma->vm_end - vma->vm_start);
+	zap_special_vma_range(vma, vma->vm_start, vma->vm_end - vma->vm_start);
 }
 
 static void rdma_umap_close(struct vm_area_struct *vma)
@@ -782,7 +782,7 @@ static void rdma_umap_close(struct vm_ar
 }
 
 /*
- * Once the zap_vma_ptes has been called touches to the VMA will come here and
+ * Once the zap_special_vma_range has been called touches to the VMA will come here and
  * we return a dummy writable zero page for all the pfns.
  */
 static vm_fault_t rdma_umap_fault(struct vm_fault *vmf)
@@ -878,7 +878,7 @@ void uverbs_user_mmap_disassociate(struc
 				continue;
 			list_del_init(&priv->list);
 
-			zap_vma_ptes(vma, vma->vm_start,
+			zap_special_vma_range(vma, vma->vm_start,
 				     vma->vm_end - vma->vm_start);
 
 			if (priv->entry) {
--- a/drivers/misc/sgi-gru/grumain.c~mm-rename-zap_vma_ptes-to-zap_special_vma_range
+++ a/drivers/misc/sgi-gru/grumain.c
@@ -542,7 +542,7 @@ void gru_unload_context(struct gru_threa
 	int ctxnum = gts->ts_ctxnum;
 
 	if (!is_kernel_context(gts))
-		zap_vma_ptes(gts->ts_vma, UGRUADDR(gts), GRU_GSEG_PAGESIZE);
+		zap_special_vma_range(gts->ts_vma, UGRUADDR(gts), GRU_GSEG_PAGESIZE);
 	cch = get_cch(gru->gs_gru_base_vaddr, ctxnum);
 
 	gru_dbg(grudev, "gts %p, cbrmap 0x%lx, dsrmap 0x%lx\n",
--- a/include/linux/mm.h~mm-rename-zap_vma_ptes-to-zap_special_vma_range
+++ a/include/linux/mm.h
@@ -2802,7 +2802,7 @@ struct page *vm_normal_page_pmd(struct v
 struct page *vm_normal_page_pud(struct vm_area_struct *vma, unsigned long addr,
 		pud_t pud);
 
-void zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
+void zap_special_vma_range(struct vm_area_struct *vma, unsigned long address,
 		  unsigned long size);
 void zap_vma_range(struct vm_area_struct *vma, unsigned long address,
 			   unsigned long size);
--- a/mm/memory.c~mm-rename-zap_vma_ptes-to-zap_special_vma_range
+++ a/mm/memory.c
@@ -2233,17 +2233,15 @@ void zap_vma_range(struct vm_area_struct
 }
 
 /**
- * zap_vma_ptes - remove ptes mapping the vma
- * @vma: vm_area_struct holding ptes to be zapped
- * @address: starting address of pages to zap
+ * zap_special_vma_range - zap all page table entries in a special vma range
+ * @vma: the vma covering the range to zap
+ * @address: starting address of the range to zap
  * @size: number of bytes to zap
  *
- * This function only unmaps ptes assigned to VM_PFNMAP vmas.
- *
- * The entire address range must be fully contained within the vma.
- *
+ * This function does nothing when the provided address range is not fully
+ * contained in @vma, or when the @vma is not VM_PFNMAP.
  */
-void zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
+void zap_special_vma_range(struct vm_area_struct *vma, unsigned long address,
 		unsigned long size)
 {
 	if (!range_in_vma(vma, address, address + size) ||
@@ -2252,7 +2250,7 @@ void zap_vma_ptes(struct vm_area_struct
 
 	zap_vma_range(vma, address, size);
 }
-EXPORT_SYMBOL_GPL(zap_vma_ptes);
+EXPORT_SYMBOL_GPL(zap_special_vma_range);
 
 static pmd_t *walk_to_pmd(struct mm_struct *mm, unsigned long addr)
 {
_

Patches currently in -mm which might be from david@kernel.org are


