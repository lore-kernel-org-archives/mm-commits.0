Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638741D5ADE
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744741; cv=none; b=mk38irg6sAwF7lp3hZ+r4oXgzefFEBt7M6ulL/7r1l/9KZK7mCN6oeO+PO4gPG1smsO50plBrABD2GSGufMcd8RA0qbkvtFlbObiW8lsftG7idwdGnDwCkziTix9HIi/anhpLLCfxTU4qMGqPQOFMqJHOl4b4XlDSR0pc9CuDj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744741; c=relaxed/simple;
	bh=B9sLJrAT4O4xmqWHk6BmiPMa95iGPEaGYaushQTbEFQ=;
	h=Date:To:From:Subject:Message-Id; b=bWNMUqYlCGlrGxFOKKQQODNPXE7YOGQmOf9+PhspXBeTMnj4Iy37KuVandVgvZQn/Xf5z1KZWlk6A/Y6Af7Ef9GPARfXEK3e+HllqwzEIiZMz/lXK5V+o3xUIQT4PWiNUoLOXoV8mLuu1Tg8MvfIA/CDfZb+88u9axJKN0r/wq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vrEPEITZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vrEPEITZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A55C4CEF7;
	Sun, 29 Mar 2026 00:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744741;
	bh=B9sLJrAT4O4xmqWHk6BmiPMa95iGPEaGYaushQTbEFQ=;
	h=Date:To:From:Subject:From;
	b=vrEPEITZ4t5CAquUWGATdJj06gZuRUaCjDUH2jiIJekie3KZyaY9wi6jbgC5NSUf7
	 wOdsY1MUxb400M+LK5LeQn5RQDHmyo3GEfQj8ImlcCiwdGhARnQD/i8HAzD55oMV5z
	 d0eGJE2clWMB5+M1BjE6o0Syaaao1b1sPRLicg8M=
Date: Sat, 28 Mar 2026 17:39:00 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vincenzo.frascino@arm.com,tursulin@ursulin.net,tkjos@android.com,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rodrigo.vivi@intel.com,rientjes@google.com,puranjay@kernel.org,pfalcato@suse.de,peterz@infradead.org,pabeni@redhat.com,ojeda@kernel.org,ncardwell@google.com,namhyung@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maddy@linux.ibm.com,luto@kernel.org,ljs@kernel.org,liam.howlett@oracle.com,leon@kernel.org,kuba@kernel.org,joonas.lahtinen@linux.intel.com,jgg@ziepe.ca,jarkko@kernel.org,jannh@google.com,jani.nikula@linux.intel.com,imbrenda@linux.ibm.com,hsweeten@visionengravers.com,hca@linux.ibm.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,edumazet@google.com,dsahern@kernel.org,dimitri.sivanich@hpe.com,davem@davemloft.net,daniel@iogearbox.net,cmllamas@google.com,brauner@kernel.org,bp@alien8.de,borntraeger@linux.ibm.com,ast@kernel.org,arve@android.com,arnd@arndb.de,andrii@kernel.org,aliceryhl@google.com,airlied@gmail.com,agordeev@linux.ibm.com,acme@kernel.org,abbotti@mev.co.uk,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-remove-zap_details-parameter-from-zap_page_range_single.patch removed from -mm tree
Message-Id: <20260329003900.D4A55C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: remove "zap_details" parameter from zap_page_range_single()
has been removed from the -mm tree.  Its filename was
     mm-memory-remove-zap_details-parameter-from-zap_page_range_single.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/memory: remove "zap_details" parameter from zap_page_range_single()
Date: Fri, 27 Feb 2026 21:08:33 +0100

Nobody except memory.c should really set that parameter to non-NULL.  So
let's just drop it and make unmap_mapping_range_vma() use
zap_page_range_single_batched() instead.

[david@kernel.org: format on a single line]
  Link: https://lkml.kernel.org/r/8a27e9ac-2025-4724-a46d-0a7c90894ba7@kernel.org
Link: https://lkml.kernel.org/r/20260227200848.114019-3-david@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: Puranjay Mohan <puranjay@kernel.org>
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
Cc: Leon Romanovsky <leon@kernel.org>
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

 arch/s390/mm/gmap_helpers.c    |    2 +-
 drivers/android/binder_alloc.c |    2 +-
 include/linux/mm.h             |    5 ++---
 kernel/bpf/arena.c             |    3 +--
 kernel/events/core.c           |    2 +-
 mm/madvise.c                   |    3 +--
 mm/memory.c                    |   16 ++++++++++------
 net/ipv4/tcp.c                 |    5 ++---
 rust/kernel/mm/virt.rs         |    4 +---
 9 files changed, 20 insertions(+), 22 deletions(-)

--- a/arch/s390/mm/gmap_helpers.c~mm-memory-remove-zap_details-parameter-from-zap_page_range_single
+++ a/arch/s390/mm/gmap_helpers.c
@@ -89,7 +89,7 @@ void gmap_helper_discard(struct mm_struc
 		if (!vma)
 			return;
 		if (!is_vm_hugetlb_page(vma))
-			zap_page_range_single(vma, vmaddr, min(end, vma->vm_end) - vmaddr, NULL);
+			zap_page_range_single(vma, vmaddr, min(end, vma->vm_end) - vmaddr);
 		vmaddr = vma->vm_end;
 	}
 }
--- a/drivers/android/binder_alloc.c~mm-memory-remove-zap_details-parameter-from-zap_page_range_single
+++ a/drivers/android/binder_alloc.c
@@ -1185,7 +1185,7 @@ enum lru_status binder_alloc_free_page(s
 	if (vma) {
 		trace_binder_unmap_user_start(alloc, index);
 
-		zap_page_range_single(vma, page_addr, PAGE_SIZE, NULL);
+		zap_page_range_single(vma, page_addr, PAGE_SIZE);
 
 		trace_binder_unmap_user_end(alloc, index);
 	}
--- a/include/linux/mm.h~mm-memory-remove-zap_details-parameter-from-zap_page_range_single
+++ a/include/linux/mm.h
@@ -2804,11 +2804,10 @@ struct page *vm_normal_page_pud(struct v
 void zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
 		  unsigned long size);
 void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
-			   unsigned long size, struct zap_details *details);
+			   unsigned long size);
 static inline void zap_vma_pages(struct vm_area_struct *vma)
 {
-	zap_page_range_single(vma, vma->vm_start,
-			      vma->vm_end - vma->vm_start, NULL);
+	zap_page_range_single(vma, vma->vm_start, vma->vm_end - vma->vm_start);
 }
 struct mmu_notifier_range;
 
--- a/kernel/bpf/arena.c~mm-memory-remove-zap_details-parameter-from-zap_page_range_single
+++ a/kernel/bpf/arena.c
@@ -656,8 +656,7 @@ static void zap_pages(struct bpf_arena *
 	guard(mutex)(&arena->lock);
 	/* iterate link list under lock */
 	list_for_each_entry(vml, &arena->vma_list, head)
-		zap_page_range_single(vml->vma, uaddr,
-				      PAGE_SIZE * page_cnt, NULL);
+		zap_page_range_single(vml->vma, uaddr, PAGE_SIZE * page_cnt);
 }
 
 static void arena_free_pages(struct bpf_arena *arena, long uaddr, long page_cnt, bool sleepable)
--- a/kernel/events/core.c~mm-memory-remove-zap_details-parameter-from-zap_page_range_single
+++ a/kernel/events/core.c
@@ -7213,7 +7213,7 @@ static int map_range(struct perf_buffer
 #ifdef CONFIG_MMU
 	/* Clear any partial mappings on error. */
 	if (err)
-		zap_page_range_single(vma, vma->vm_start, nr_pages * PAGE_SIZE, NULL);
+		zap_page_range_single(vma, vma->vm_start, nr_pages * PAGE_SIZE);
 #endif
 
 	return err;
--- a/mm/madvise.c~mm-memory-remove-zap_details-parameter-from-zap_page_range_single
+++ a/mm/madvise.c
@@ -1193,8 +1193,7 @@ static long madvise_guard_install(struct
 		 * OK some of the range have non-guard pages mapped, zap
 		 * them. This leaves existing guard pages in place.
 		 */
-		zap_page_range_single(vma, range->start,
-				range->end - range->start, NULL);
+		zap_page_range_single(vma, range->start, range->end - range->start);
 	}
 
 	/*
--- a/mm/memory.c~mm-memory-remove-zap_details-parameter-from-zap_page_range_single
+++ a/mm/memory.c
@@ -2203,17 +2203,16 @@ void zap_page_range_single_batched(struc
  * @vma: vm_area_struct holding the applicable pages
  * @address: starting address of pages to zap
  * @size: number of bytes to zap
- * @details: details of shared cache invalidation
  *
  * The range must fit into one VMA.
  */
 void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
-		unsigned long size, struct zap_details *details)
+		unsigned long size)
 {
 	struct mmu_gather tlb;
 
 	tlb_gather_mmu(&tlb, vma->vm_mm);
-	zap_page_range_single_batched(&tlb, vma, address, size, details);
+	zap_page_range_single_batched(&tlb, vma, address, size, NULL);
 	tlb_finish_mmu(&tlb);
 }
 
@@ -2235,7 +2234,7 @@ void zap_vma_ptes(struct vm_area_struct
 	    		!(vma->vm_flags & VM_PFNMAP))
 		return;
 
-	zap_page_range_single(vma, address, size, NULL);
+	zap_page_range_single(vma, address, size);
 }
 EXPORT_SYMBOL_GPL(zap_vma_ptes);
 
@@ -3003,7 +3002,7 @@ static int remap_pfn_range_notrack(struc
 	 * maintain page reference counts, and callers may free
 	 * pages due to the error. So zap it early.
 	 */
-	zap_page_range_single(vma, addr, size, NULL);
+	zap_page_range_single(vma, addr, size);
 	return error;
 }
 
@@ -4226,7 +4225,12 @@ static void unmap_mapping_range_vma(stru
 		unsigned long start_addr, unsigned long end_addr,
 		struct zap_details *details)
 {
-	zap_page_range_single(vma, start_addr, end_addr - start_addr, details);
+	struct mmu_gather tlb;
+
+	tlb_gather_mmu(&tlb, vma->vm_mm);
+	zap_page_range_single_batched(&tlb, vma, start_addr,
+				      end_addr - start_addr, details);
+	tlb_finish_mmu(&tlb);
 }
 
 static inline void unmap_mapping_range_tree(struct rb_root_cached *root,
--- a/net/ipv4/tcp.c~mm-memory-remove-zap_details-parameter-from-zap_page_range_single
+++ a/net/ipv4/tcp.c
@@ -2105,7 +2105,7 @@ static int tcp_zerocopy_vm_insert_batch_
 		maybe_zap_len = total_bytes_to_map -  /* All bytes to map */
 				*length + /* Mapped or pending */
 				(pages_remaining * PAGE_SIZE); /* Failed map. */
-		zap_page_range_single(vma, *address, maybe_zap_len, NULL);
+		zap_page_range_single(vma, *address, maybe_zap_len);
 		err = 0;
 	}
 
@@ -2270,8 +2270,7 @@ static int tcp_zerocopy_receive(struct s
 	total_bytes_to_map = avail_len & ~(PAGE_SIZE - 1);
 	if (total_bytes_to_map) {
 		if (!(zc->flags & TCP_RECEIVE_ZEROCOPY_FLAG_TLB_CLEAN_HINT))
-			zap_page_range_single(vma, address, total_bytes_to_map,
-					      NULL);
+			zap_page_range_single(vma, address, total_bytes_to_map);
 		zc->length = total_bytes_to_map;
 		zc->recv_skip_hint = 0;
 	} else {
--- a/rust/kernel/mm/virt.rs~mm-memory-remove-zap_details-parameter-from-zap_page_range_single
+++ a/rust/kernel/mm/virt.rs
@@ -123,9 +123,7 @@ impl VmaRef {
         // SAFETY: By the type invariants, the caller has read access to this VMA, which is
         // sufficient for this method call. This method has no requirements on the vma flags. The
         // address range is checked to be within the vma.
-        unsafe {
-            bindings::zap_page_range_single(self.as_ptr(), address, size, core::ptr::null_mut())
-        };
+        unsafe { bindings::zap_page_range_single(self.as_ptr(), address, size) };
     }
 
     /// If the [`VM_MIXEDMAP`] flag is set, returns a [`VmaMixedMap`] to this VMA, otherwise
_

Patches currently in -mm which might be from david@kernel.org are


