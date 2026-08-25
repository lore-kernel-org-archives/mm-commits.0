Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6D830F55F;
	Tue, 25 Aug 2026 01:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622820; cv=none; b=JY96iRgQQ5nubaOwzyVFhPPG3Rbh5b4aRxAsJzkPHTMKPLoTZmkINhtjC2EmtGSARHtC/V+zcAYtDRD373WCDABgSMb9QaiXNz3zpromDnUiWS46Vb9T8zm2ojMU2uzKhlhAXa8+VdPBDAPuv42zuilhJxBwqSB2fWokAGI1Eo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622820; c=relaxed/simple;
	bh=IWgwrN1jJfywTIYoyn5ASGcsKoOGhUJoXPQOAR9hfBw=;
	h=Date:To:From:Subject:Message-Id; b=TH5dBvVWi7jTvXil8FhgfvMQvkJT0Efromd1ajQkfx/DUVLAnOG5EF3GmyAiCQze2H6uvnyTwRIMqIU5AzM8K3HPEGsR8C1b5AyqcXrQ/z2AyRfwhsJ2zlSuUtbJeM1k6nl7ourdcS5Dqoxave+HGDXahRCuBQwyshaXopxw5XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qpEaHMHl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qpEaHMHl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5E8C1F00A3A;
	Tue, 25 Aug 2026 01:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622819;
	bh=77/cPFsUKZAIUly6cxCNMaQAxPi5AvuZa3DIGhNg/l4=;
	h=Date:To:From:Subject;
	b=qpEaHMHltMVHN5zUwpIDFFNnCEHbVS+He52S3zIUHJEOIA1nKotowncvIbC3wKEVm
	 JF3P9BWkb8oDUGl6FX71HO69m+tQnx6QqARxTFNXWTWdmUWyVjYcNsuOqB6xzTtUXN
	 FZ+0BHIhKMFDUTVqFa/oumRWLgrEurd6P6RXABaE=
Date: Mon, 24 Aug 2026 18:53:38 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,urezki@gmail.com,stable@vger.kernel.org,shivamkalra98@zohomail.in,akpm@linux-foundation.org,iprintercanon@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-make-vm_structnr_pages-an-unsigned-long.patch removed from -mm tree
Message-Id: <20260825015338.E5E8C1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: make vm_struct.nr_pages an unsigned long
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-make-vm_structnr_pages-an-unsigned-long.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Artem Lytkin <iprintercanon@gmail.com>
Subject: mm/vmalloc: make vm_struct.nr_pages an unsigned long
Date: Sat, 1 Aug 2026 14:49:15 +0300

vm_struct::nr_pages is an unsigned int, and the file keeps deriving byte
counts from it as nr_pages << PAGE_SHIFT.  A shift is evaluated in the
type of its promoted left operand, so those are 32-bit arithmetic and wrap
at 4 GiB of bytes, which is 2^20 pages.  Every site depends on a cast
being remembered; vmap() has one, two recent commits did not. 
vread_iter() then computes a size of zero for a 4 GiB VM_ALLOC area and
/proc/kcore returns it as zeros while reporting a successful read, which
drgn, crash or gdb cannot tell from real memory, and the vrealloc()
grow-in-place check declines a request that would have fit.

Widen the field so the class of bug goes away instead of one site at a
time.  Everything feeding or consuming it widens too:
vm_area_alloc_pages() and its accumulators, nr_small_pages, new_nr_pages
and old_nr_pages, the index range of vm_area_free_pages(), and three page
indexes that were plain int.  Five casts go.  Two prints needed fixing as
well, %u in vmalloc_dump_obj() and %d for the unsigned field in
vmalloc_info_show().

No bug report behind this, I found it reading the code.  The 4 GiB wrap
needs only a machine with over 4 GiB of memory.  Neither larger threshold
is a practical concern: 2^32 pages, where the field itself truncates, is
16 TiB and beyond what hardware can populate, and 2^31, where the plain
int indexes break, is 8 TiB and larger than anything in the tree asks for.
The int *nr cursor in the mapping path is unchanged and is separate work.
Users outside mm/vmalloc.c need no change either.  Those handing the
count to a narrower parameter cannot drive it near 2^31, and
kho_preserve_vmalloc() stores it into a 32-bit ABI field that still
receives the same low bits; above 2^32 pages the truncation just moves out
of vm_struct into that store.

sizeof(struct vm_struct) on x86-64 stays 72 bytes with
CONFIG_HAVE_ARCH_HUGE_VMALLOC=n and goes from 72 to 80 with it enabled,
both inside the kmalloc-96 bucket it already comes from.

Link: https://lore.kernel.org/20260801114915.115224-1-iprintercanon@gmail.com
Fixes: 0bca23804632 ("mm/vmalloc: use physical page count in vread_iter() for VM_ALLOC areas")
Fixes: d57ac904ffdc ("mm/vmalloc: use physical page count for vrealloc() grow-in-place check")
Signed-off-by: Artem Lytkin <iprintercanon@gmail.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Assisted-by: Claude:claude-fable-5
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <shivamkalra98@zohomail.in>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    2 -
 mm/vmalloc.c            |   60 ++++++++++++++++++--------------------
 2 files changed, 30 insertions(+), 32 deletions(-)

--- a/include/linux/vmalloc.h~mm-vmalloc-make-vm_structnr_pages-an-unsigned-long
+++ a/include/linux/vmalloc.h
@@ -62,7 +62,7 @@ struct vm_struct {
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMALLOC
 	unsigned int		page_order;
 #endif
-	unsigned int		nr_pages;
+	unsigned long		nr_pages;
 	phys_addr_t		phys_addr;
 	const void		*caller;
 	unsigned long		requested_size;
--- a/mm/vmalloc.c~mm-vmalloc-make-vm_structnr_pages-an-unsigned-long
+++ a/mm/vmalloc.c
@@ -3361,7 +3361,7 @@ struct vm_struct *remove_vm_area(const v
 static inline void set_area_direct_map(const struct vm_struct *area,
 				       int (*set_direct_map)(struct page *page))
 {
-	int i;
+	unsigned long i;
 
 	/* HUGE_VMALLOC passes small pages to set_direct_map */
 	for (i = 0; i < area->nr_pages; i++)
@@ -3377,7 +3377,7 @@ static void vm_reset_perms(struct vm_str
 	unsigned long start = ULONG_MAX, end = 0;
 	unsigned int page_order = vm_area_page_order(area);
 	int flush_dmap = 0;
-	int i;
+	unsigned long i;
 
 	/*
 	 * Find the start and end range of the direct mappings to make sure that
@@ -3450,10 +3450,10 @@ void vfree_atomic(const void *addr)
  * Caller is responsible for unmapping (vunmap_range) and KASAN
  * poisoning before calling this.
  */
-static void vm_area_free_pages(struct vm_struct *vm, unsigned int start_idx,
-			       unsigned int end_idx)
+static void vm_area_free_pages(struct vm_struct *vm, unsigned long start_idx,
+			       unsigned long end_idx)
 {
-	unsigned int i;
+	unsigned long i;
 
 	if (!(vm->flags & VM_MAP_PUT_PAGES)) {
 		for (i = start_idx; i < end_idx; i++)
@@ -3665,12 +3665,12 @@ static inline gfp_t vmalloc_gfp_adjust(g
 	return flags;
 }
 
-static inline unsigned int
+static inline unsigned long
 vm_area_alloc_pages(gfp_t gfp, int nid,
-		unsigned int order, unsigned int nr_pages, struct page **pages)
+		unsigned int order, unsigned long nr_pages, struct page **pages)
 {
-	unsigned int nr_allocated = 0;
-	unsigned int nr_remaining = nr_pages;
+	unsigned long nr_allocated = 0;
+	unsigned long nr_remaining = nr_pages;
 	unsigned int max_attempt_order = MAX_PAGE_ORDER;
 	struct page *page;
 	int i;
@@ -3718,7 +3718,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 	if (!order) {
 		while (nr_allocated < nr_pages) {
 			unsigned int nr, nr_pages_request;
-			int i;
+			unsigned long i;
 
 			/*
 			 * A maximum allowed request is hard-coded and is 100
@@ -3726,7 +3726,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 			 * long preemption off scenario in the bulk-allocator
 			 * so the range is [1:100].
 			 */
-			nr_pages_request = min(100U, nr_pages - nr_allocated);
+			nr_pages_request = min(100UL, nr_pages - nr_allocated);
 
 			/* memory allocation should consider mempolicy, we can't
 			 * wrongly use nearest node when nid == NUMA_NO_NODE,
@@ -3872,12 +3872,12 @@ static void *__vmalloc_area_node(struct
 	unsigned long addr = (unsigned long)area->addr;
 	unsigned long size = get_vm_area_size(area);
 	unsigned long array_size;
-	unsigned int nr_small_pages = size >> PAGE_SHIFT;
+	unsigned long nr_small_pages = size >> PAGE_SHIFT;
 	unsigned int page_order;
 	unsigned int flags;
 	int ret;
 
-	array_size = (unsigned long)nr_small_pages * sizeof(struct page *);
+	array_size = nr_small_pages * sizeof(struct page *);
 
 	/* __GFP_NOFAIL and "noblock" flags are mutually exclusive. */
 	if (!gfpflags_allow_blocking(gfp_mask))
@@ -4375,7 +4375,7 @@ void *vrealloc_node_align_noprof(const v
 	}
 
 	if (size <= old_size) {
-		unsigned int new_nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
+		unsigned long new_nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
 
 		/* Zero out "freed" memory, potentially for future realloc. */
 		if (want_init_on_free() || want_init_on_alloc(flags))
@@ -4404,7 +4404,7 @@ void *vrealloc_node_align_noprof(const v
 		    !(vm->flags & (VM_FLUSH_RESET_PERMS | VM_USERMAP)) &&
 		    gfp_has_io_fs(flags)) {
 			unsigned long addr = (unsigned long)kasan_reset_tag(p);
-			unsigned int old_nr_pages = vm->nr_pages;
+			unsigned long old_nr_pages = vm->nr_pages;
 
 			/*
 			 * Use the node lock to synchronize with concurrent
@@ -4417,16 +4417,13 @@ void *vrealloc_node_align_noprof(const v
 			spin_unlock(&vn->busy.lock);
 
 			/* Notify kmemleak of the reduced allocation size before unmapping. */
-			kmemleak_free_part(
-				(void *)addr + ((unsigned long)new_nr_pages
-						<< PAGE_SHIFT),
-				(unsigned long)(old_nr_pages - new_nr_pages)
-					<< PAGE_SHIFT);
-
-			vunmap_range(addr + ((unsigned long)new_nr_pages
-					     << PAGE_SHIFT),
-				     addr + ((unsigned long)old_nr_pages
-					     << PAGE_SHIFT));
+			kmemleak_free_part((void *)addr +
+					   (new_nr_pages << PAGE_SHIFT),
+					   (old_nr_pages - new_nr_pages)
+						<< PAGE_SHIFT);
+
+			vunmap_range(addr + (new_nr_pages << PAGE_SHIFT),
+				     addr + (old_nr_pages << PAGE_SHIFT));
 
 			vm_area_free_pages(vm, new_nr_pages, old_nr_pages);
 		}
@@ -5250,7 +5247,7 @@ bool vmalloc_dump_obj(void *object)
 	struct vmap_area *va;
 	struct vmap_node *vn;
 	unsigned long addr;
-	unsigned int nr_pages;
+	unsigned long nr_pages;
 
 	addr = PAGE_ALIGN((unsigned long) object);
 	vn = addr_to_node(addr);
@@ -5270,7 +5267,7 @@ bool vmalloc_dump_obj(void *object)
 	nr_pages = vm->nr_pages;
 	spin_unlock(&vn->busy.lock);
 
-	pr_cont(" %u-page vmalloc region starting at %#lx allocated at %pS\n",
+	pr_cont(" %lu-page vmalloc region starting at %#lx allocated at %pS\n",
 		nr_pages, addr, caller);
 
 	return true;
@@ -5288,16 +5285,17 @@ bool vmalloc_dump_obj(void *object)
 static void show_numa_info(struct seq_file *m, struct vm_struct *v,
 				 unsigned int *counters)
 {
-	unsigned int nr;
 	unsigned int step = 1U << vm_area_page_order(v);
+	unsigned long i;
+	unsigned int nr;
 
 	if (!counters)
 		return;
 
 	memset(counters, 0, nr_node_ids * sizeof(unsigned int));
 
-	for (nr = 0; nr < v->nr_pages; nr += step)
-		counters[page_to_nid(v->pages[nr])] += step;
+	for (i = 0; i < v->nr_pages; i += step)
+		counters[page_to_nid(v->pages[i])] += step;
 	for_each_node_state(nr, N_HIGH_MEMORY)
 		if (counters[nr])
 			seq_printf(m, " N%u=%u", nr, counters[nr]);
@@ -5355,7 +5353,7 @@ static int vmalloc_info_show(struct seq_
 				seq_printf(m, " %pS", v->caller);
 
 			if (v->nr_pages)
-				seq_printf(m, " pages=%d", v->nr_pages);
+				seq_printf(m, " pages=%lu", v->nr_pages);
 
 			if (v->phys_addr)
 				seq_printf(m, " phys=%pa", &v->phys_addr);
_

Patches currently in -mm which might be from iprintercanon@gmail.com are


