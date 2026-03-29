Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931E51C5F1B
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744764; cv=none; b=QFEXBv7rmlKhUvg6MWvHxK2CwX28N4Hw2D89HryMXBZoQCsF8F9uBdEvgafPzA2i/dV3NdlazMYx6Uu8h6jSf0rUiZmlG4NcLV5Ql4n/YG6VbAXmgAL6qXptqaWahCMVEpQp9fK1dTgo1IjjxCpQwGLSoh34a5N5YQRTR1Q4ar0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744764; c=relaxed/simple;
	bh=GSF1+uHpOGlsoxY2o53BgPrl+Bb2aG/+NAeYObm61as=;
	h=Date:To:From:Subject:Message-Id; b=k9wH9DZUOxrolo0daIfkdiKLmeauwNq7zSZFEP+LdqJ4MEzNS2m/I1uU+KKrmJ8AriE4y9Qxw50M2fGWYZXmdH7yPUtwFFFgowQyiPBj3jWzUG6z5NT9QzGJHA8Po+HrtjEOsrDnTO41XDtryEWy0NI2F3e1//2dAUxoVFE/Sq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xlKgk/Jf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xlKgk/Jf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64371C4CEF7;
	Sun, 29 Mar 2026 00:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744764;
	bh=GSF1+uHpOGlsoxY2o53BgPrl+Bb2aG/+NAeYObm61as=;
	h=Date:To:From:Subject:From;
	b=xlKgk/JfslN2iv3NvD4D5+qb9lmoKvUCSretZxp7bmvbmlYJNT/z0yXyS4k4c7z+3
	 s/K/1Eq0WUZInwY2fr/BIJwV3HwPoXiI08Sp0N1lRwoRxvs3ifQvMRs9VSgBPUK/JD
	 I+epbo3yebxHFBonoaVGQUWIkfx9u9QZ+d71vjEk=
Date: Sat, 28 Mar 2026 17:39:23 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vincenzo.frascino@arm.com,tursulin@ursulin.net,tkjos@android.com,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rodrigo.vivi@intel.com,rientjes@google.com,puranjay@kernel.org,pfalcato@suse.de,peterz@infradead.org,pabeni@redhat.com,ojeda@kernel.org,ncardwell@google.com,namhyung@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maddy@linux.ibm.com,luto@kernel.org,ljs@kernel.org,liam.howlett@oracle.com,leon@kernel.org,kuba@kernel.org,joonas.lahtinen@linux.intel.com,jgg@ziepe.ca,jarkko@kernel.org,jannh@google.com,jani.nikula@linux.intel.com,imbrenda@linux.ibm.com,hsweeten@visionengravers.com,hca@linux.ibm.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,edumazet@google.com,dsahern@kernel.org,dimitri.sivanich@hpe.com,davem@davemloft.net,daniel@iogearbox.net,cmllamas@google.com,brauner@kernel.org,bp@alien8.de,borntraeger@linux.ibm.com,ast@kernel.org,arve@android.com,arnd@arndb.de,andrii@kernel.org,aliceryhl@google.com,airlied@gmail.com,agordeev@linux.ibm.com,acme@kernel.org,abbotti@mev.co.uk,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rename-zap_page_range_single-to-zap_vma_range.patch removed from -mm tree
Message-Id: <20260329003924.64371C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: rename zap_page_range_single() to zap_vma_range()
has been removed from the -mm tree.  Its filename was
     mm-rename-zap_page_range_single-to-zap_vma_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm: rename zap_page_range_single() to zap_vma_range()
Date: Fri, 27 Feb 2026 21:08:45 +0100

Let's rename it to make it better match our new naming scheme.

While at it, polish the kerneldoc.

[akpm@linux-foundation.org: fix rustfmtcheck]
Link: https://lkml.kernel.org/r/20260227200848.114019-15-david@kernel.org
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

 arch/s390/mm/gmap_helpers.c          |    2 +-
 drivers/android/binder/page_range.rs |    4 ++--
 drivers/android/binder_alloc.c       |    2 +-
 include/linux/mm.h                   |    4 ++--
 kernel/bpf/arena.c                   |    2 +-
 kernel/events/core.c                 |    2 +-
 mm/madvise.c                         |    4 ++--
 mm/memory.c                          |   14 +++++++-------
 net/ipv4/tcp.c                       |    6 +++---
 rust/kernel/mm/virt.rs               |    4 ++--
 10 files changed, 22 insertions(+), 22 deletions(-)

--- a/arch/s390/mm/gmap_helpers.c~mm-rename-zap_page_range_single-to-zap_vma_range
+++ a/arch/s390/mm/gmap_helpers.c
@@ -89,7 +89,7 @@ void gmap_helper_discard(struct mm_struc
 		if (!vma)
 			return;
 		if (!is_vm_hugetlb_page(vma))
-			zap_page_range_single(vma, vmaddr, min(end, vma->vm_end) - vmaddr);
+			zap_vma_range(vma, vmaddr, min(end, vma->vm_end) - vmaddr);
 		vmaddr = vma->vm_end;
 	}
 }
--- a/drivers/android/binder_alloc.c~mm-rename-zap_page_range_single-to-zap_vma_range
+++ a/drivers/android/binder_alloc.c
@@ -1185,7 +1185,7 @@ enum lru_status binder_alloc_free_page(s
 	if (vma) {
 		trace_binder_unmap_user_start(alloc, index);
 
-		zap_page_range_single(vma, page_addr, PAGE_SIZE);
+		zap_vma_range(vma, page_addr, PAGE_SIZE);
 
 		trace_binder_unmap_user_end(alloc, index);
 	}
--- a/drivers/android/binder/page_range.rs~mm-rename-zap_page_range_single-to-zap_vma_range
+++ a/drivers/android/binder/page_range.rs
@@ -130,7 +130,7 @@ pub(crate) struct ShrinkablePageRange {
     pid: Pid,
     /// The mm for the relevant process.
     mm: ARef<Mm>,
-    /// Used to synchronize calls to `vm_insert_page` and `zap_page_range_single`.
+    /// Used to synchronize calls to `vm_insert_page` and `zap_vma_range`.
     #[pin]
     mm_lock: Mutex<()>,
     /// Spinlock protecting changes to pages.
@@ -762,7 +762,7 @@ unsafe extern "C" fn rust_shrink_free_pa
     if let Some(unchecked_vma) = mmap_read.vma_lookup(vma_addr) {
         if let Some(vma) = check_vma(unchecked_vma, range_ptr) {
             let user_page_addr = vma_addr + (page_index << PAGE_SHIFT);
-            vma.zap_page_range_single(user_page_addr, PAGE_SIZE);
+            vma.zap_vma_range(user_page_addr, PAGE_SIZE);
         }
     }
 
--- a/include/linux/mm.h~mm-rename-zap_page_range_single-to-zap_vma_range
+++ a/include/linux/mm.h
@@ -2804,7 +2804,7 @@ struct page *vm_normal_page_pud(struct v
 
 void zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
 		  unsigned long size);
-void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
+void zap_vma_range(struct vm_area_struct *vma, unsigned long address,
 			   unsigned long size);
 /**
  * zap_vma - zap all page table entries in a vma
@@ -2812,7 +2812,7 @@ void zap_page_range_single(struct vm_are
  */
 static inline void zap_vma(struct vm_area_struct *vma)
 {
-	zap_page_range_single(vma, vma->vm_start, vma->vm_end - vma->vm_start);
+	zap_vma_range(vma, vma->vm_start, vma->vm_end - vma->vm_start);
 }
 struct mmu_notifier_range;
 
--- a/kernel/bpf/arena.c~mm-rename-zap_page_range_single-to-zap_vma_range
+++ a/kernel/bpf/arena.c
@@ -656,7 +656,7 @@ static void zap_pages(struct bpf_arena *
 	guard(mutex)(&arena->lock);
 	/* iterate link list under lock */
 	list_for_each_entry(vml, &arena->vma_list, head)
-		zap_page_range_single(vml->vma, uaddr, PAGE_SIZE * page_cnt);
+		zap_vma_range(vml->vma, uaddr, PAGE_SIZE * page_cnt);
 }
 
 static void arena_free_pages(struct bpf_arena *arena, long uaddr, long page_cnt, bool sleepable)
--- a/kernel/events/core.c~mm-rename-zap_page_range_single-to-zap_vma_range
+++ a/kernel/events/core.c
@@ -7213,7 +7213,7 @@ static int map_range(struct perf_buffer
 #ifdef CONFIG_MMU
 	/* Clear any partial mappings on error. */
 	if (err)
-		zap_page_range_single(vma, vma->vm_start, nr_pages * PAGE_SIZE);
+		zap_vma_range(vma, vma->vm_start, nr_pages * PAGE_SIZE);
 #endif
 
 	return err;
--- a/mm/madvise.c~mm-rename-zap_page_range_single-to-zap_vma_range
+++ a/mm/madvise.c
@@ -832,7 +832,7 @@ static int madvise_free_single_vma(struc
  * Application no longer needs these pages.  If the pages are dirty,
  * it's OK to just throw them away.  The app will be more careful about
  * data it wants to keep.  Be sure to free swap resources too.  The
- * zap_page_range_single call sets things up for shrink_active_list to actually
+ * zap_vma_range call sets things up for shrink_active_list to actually
  * free these pages later if no one else has touched them in the meantime,
  * although we could add these pages to a global reuse list for
  * shrink_active_list to pick up before reclaiming other pages.
@@ -1191,7 +1191,7 @@ static long madvise_guard_install(struct
 		 * OK some of the range have non-guard pages mapped, zap
 		 * them. This leaves existing guard pages in place.
 		 */
-		zap_page_range_single(vma, range->start, range->end - range->start);
+		zap_vma_range(vma, range->start, range->end - range->start);
 	}
 
 	/*
--- a/mm/memory.c~mm-rename-zap_page_range_single-to-zap_vma_range
+++ a/mm/memory.c
@@ -2215,14 +2215,14 @@ void zap_vma_range_batched(struct mmu_ga
 }
 
 /**
- * zap_page_range_single - remove user pages in a given range
- * @vma: vm_area_struct holding the applicable pages
- * @address: starting address of pages to zap
+ * zap_vma_range - zap all page table entries in a vma range
+ * @vma: the vma covering the range to zap
+ * @address: starting address of the range to zap
  * @size: number of bytes to zap
  *
- * The range must fit into one VMA.
+ * The provided address range must be fully contained within @vma.
  */
-void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
+void zap_vma_range(struct vm_area_struct *vma, unsigned long address,
 		unsigned long size)
 {
 	struct mmu_gather tlb;
@@ -2250,7 +2250,7 @@ void zap_vma_ptes(struct vm_area_struct
 	    		!(vma->vm_flags & VM_PFNMAP))
 		return;
 
-	zap_page_range_single(vma, address, size);
+	zap_vma_range(vma, address, size);
 }
 EXPORT_SYMBOL_GPL(zap_vma_ptes);
 
@@ -3018,7 +3018,7 @@ static int remap_pfn_range_notrack(struc
 	 * maintain page reference counts, and callers may free
 	 * pages due to the error. So zap it early.
 	 */
-	zap_page_range_single(vma, addr, size);
+	zap_vma_range(vma, addr, size);
 	return error;
 }
 
--- a/net/ipv4/tcp.c~mm-rename-zap_page_range_single-to-zap_vma_range
+++ a/net/ipv4/tcp.c
@@ -2105,7 +2105,7 @@ static int tcp_zerocopy_vm_insert_batch_
 		maybe_zap_len = total_bytes_to_map -  /* All bytes to map */
 				*length + /* Mapped or pending */
 				(pages_remaining * PAGE_SIZE); /* Failed map. */
-		zap_page_range_single(vma, *address, maybe_zap_len);
+		zap_vma_range(vma, *address, maybe_zap_len);
 		err = 0;
 	}
 
@@ -2113,7 +2113,7 @@ static int tcp_zerocopy_vm_insert_batch_
 		unsigned long leftover_pages = pages_remaining;
 		int bytes_mapped;
 
-		/* We called zap_page_range_single, try to reinsert. */
+		/* We called zap_vma_range, try to reinsert. */
 		err = vm_insert_pages(vma, *address,
 				      pending_pages,
 				      &pages_remaining);
@@ -2270,7 +2270,7 @@ static int tcp_zerocopy_receive(struct s
 	total_bytes_to_map = avail_len & ~(PAGE_SIZE - 1);
 	if (total_bytes_to_map) {
 		if (!(zc->flags & TCP_RECEIVE_ZEROCOPY_FLAG_TLB_CLEAN_HINT))
-			zap_page_range_single(vma, address, total_bytes_to_map);
+			zap_vma_range(vma, address, total_bytes_to_map);
 		zc->length = total_bytes_to_map;
 		zc->recv_skip_hint = 0;
 	} else {
--- a/rust/kernel/mm/virt.rs~mm-rename-zap_page_range_single-to-zap_vma_range
+++ a/rust/kernel/mm/virt.rs
@@ -113,7 +113,7 @@ impl VmaRef {
     /// kernel goes further in freeing unused page tables, but for the purposes of this operation
     /// we must only assume that the leaf level is cleared.
     #[inline]
-    pub fn zap_page_range_single(&self, address: usize, size: usize) {
+    pub fn zap_vma_range(&self, address: usize, size: usize) {
         let (end, did_overflow) = address.overflowing_add(size);
         if did_overflow || address < self.start() || self.end() < end {
             // TODO: call WARN_ONCE once Rust version of it is added
@@ -123,7 +123,7 @@ impl VmaRef {
         // SAFETY: By the type invariants, the caller has read access to this VMA, which is
         // sufficient for this method call. This method has no requirements on the vma flags. The
         // address range is checked to be within the vma.
-        unsafe { bindings::zap_page_range_single(self.as_ptr(), address, size) };
+        unsafe { bindings::zap_vma_range(self.as_ptr(), address, size) };
     }
 
     /// If the [`VM_MIXEDMAP`] flag is set, returns a [`VmaMixedMap`] to this VMA, otherwise
_

Patches currently in -mm which might be from david@kernel.org are


