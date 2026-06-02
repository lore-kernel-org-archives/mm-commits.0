Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666893BC664
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439121; cv=none; b=GdGj6b2ametbADrEe+dHQiWRKziLxaxe31Nr6DypnHAKCh762c+rWWVW1MVCMIXdh2COqcWU6FrmvOKvUZr2Tj6/mEtQufTnKJ6pXu+ePFHbBvigZVVapSDS/c/Zxi/JGpyRX5gWvHByqP+ZENHE4JoCG6oMW0A+lFFlD7NJH2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439121; c=relaxed/simple;
	bh=Nwa0PcmIM1cQ8Mus2ht0KE21oLazOjOT7moQuymQ5OE=;
	h=Date:To:From:Subject:Message-Id; b=BFzOtxe0o8bPkSWq1icfll2FOJTMY0Za/hcDMvP/3Yoa03MY9p7T22pSHiezqNXj3A3+cvgwniz3/eU5rAAQFcBYb/1EPBwXkIrRykge69jJbeMNWQi/qfo9y5Nb7fvVUHcCFKMoegNicBNYhuVFnDrCbjI2zm+3uD7iEi0FqFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yAcpmYYc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yAcpmYYc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011081F00893;
	Tue,  2 Jun 2026 22:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439120;
	bh=XhbghSPE74NyPwicKpbJ2eLH8nv5FujtrAnjVZPUf7E=;
	h=Date:To:From:Subject;
	b=yAcpmYYcrC5LaBkIiikwjJsyx4W4Gi4F3Q3ZypC9agUizkozFfI+UYIJxuZpuz+Gp
	 2OReJFYOocf22LkKtzh3fvo4ARDeQ63sSjV3hGt9k8vJ5L8S3jC3KNP7bdeR3RLi+Y
	 IZkZU59LN05XY7JUmowZzG/48ZLsSDQheWQ1MKFY=
Date: Tue, 02 Jun 2026 15:25:19 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,dakr@kernel.org,aliceryhl@google.com,shivamkalra98@zohomail.in,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-extract-vm_area_free_pages-helper-from-vfree.patch removed from -mm tree
Message-Id: <20260602222520.011081F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: extract vm_area_free_pages() helper from vfree()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-extract-vm_area_free_pages-helper-from-vfree.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shivam Kalra <shivamkalra98@zohomail.in>
Subject: mm/vmalloc: extract vm_area_free_pages() helper from vfree()
Date: Tue, 19 May 2026 17:42:14 +0530

Patch series "mm/vmalloc: free unused pages on vrealloc() shrink", v14.

This series implements the TODO in vrealloc() to unmap and free unused
pages when shrinking across a page boundary.

Problem:
When vrealloc() shrinks an allocation, it updates bookkeeping
(requested_size, KASAN shadow) but does not free the underlying physical
pages. This wastes memory for the lifetime of the allocation.

Solution:
- Patch 1: Extracts a vm_area_free_pages(vm, start_idx, end_idx) helper
  from vfree() that frees a range of pages with memcg and nr_vmalloc_pages
  accounting. Freed page pointers are set to NULL to prevent stale
  references.
- Patch 2: Update the grow-in-place check in vrealloc() to compare the
  requested size against the actual physical page count (vm->nr_pages) 
  rather than the virtual area sizes. This is a prerequisite for shrinking.
- Patch 3: For VM_ALLOC areas in vread_iter(), derive the vm area size 
  from vm->nr_pages rather than get_vm_area_size(), which would 
  overestimate the mapped range after a shrink. Other mapping types
  (vmap, ioremap) don't set nr_pages and keep using get_vm_area_size().
- Patch 4: Uses the helper to free tail pages when vrealloc() shrinks
  across a page boundary. 
- Patch 5: Adds a vrealloc test case to lib/test_vmalloc that exercises
  grow-realloc, shrink-across-boundary, shrink-within-page, and
  grow-in-place paths.

The virtual address reservation is kept intact to preserve the range for
potential future grow-in-place support.  A concrete user is the Rust
binder driver's KVVec::shrink_to [1], which performs explicit vrealloc()
shrinks for memory reclamation.


This patch (of 5):

Extract page freeing and NR_VMALLOC stat accounting from vfree() into a
reusable vm_area_free_pages() helper.  The helper operates on a range
[start_idx, end_idx) of pages from a vm_struct, making it suitable for
both full free (vfree) and partial free (upcoming vrealloc shrink).

Freed page pointers in vm->pages[] are set to NULL to prevent stale
references when the vm_struct outlives the free (as in vrealloc shrink).

Link: https://lore.kernel.org/20260519-vmalloc-shrink-v14-0-70b96ee3e9c9@zohomail.in
Link: https://lore.kernel.org/20260519-vmalloc-shrink-v14-1-70b96ee3e9c9@zohomail.in
Link: https://lore.kernel.org/all/20260216-binder-shrink-vec-v3-v6-0-ece8e8593e53@zohomail.in/ [1]
Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-extract-vm_area_free_pages-helper-from-vfree
+++ a/mm/vmalloc.c
@@ -3416,6 +3416,32 @@ void vfree_atomic(const void *addr)
 		schedule_work(&p->wq);
 }
 
+/*
+ * vm_area_free_pages - free a range of pages from a vmalloc allocation
+ * @vm: the vm_struct containing the pages
+ * @start_idx: first page index to free (inclusive)
+ * @end_idx: last page index to free (exclusive)
+ *
+ * Free pages [start_idx, end_idx) updating NR_VMALLOC stat accounting.
+ * Freed vm->pages[] entries are set to NULL.
+ * Caller is responsible for unmapping (vunmap_range) and KASAN
+ * poisoning before calling this.
+ */
+static void vm_area_free_pages(struct vm_struct *vm, unsigned int start_idx,
+			       unsigned int end_idx)
+{
+	unsigned int i;
+
+	if (!(vm->flags & VM_MAP_PUT_PAGES)) {
+		for (i = start_idx; i < end_idx; i++)
+			mod_lruvec_page_state(vm->pages[i], NR_VMALLOC, -1);
+	}
+	free_pages_bulk(vm->pages + start_idx, end_idx - start_idx);
+
+	for (i = start_idx; i < end_idx; i++)
+		vm->pages[i] = NULL;
+}
+
 /**
  * vfree - Release memory allocated by vmalloc()
  * @addr:  Memory base address
@@ -3436,7 +3462,6 @@ void vfree_atomic(const void *addr)
 void vfree(const void *addr)
 {
 	struct vm_struct *vm;
-	int i;
 
 	if (unlikely(in_interrupt())) {
 		vfree_atomic(addr);
@@ -3460,12 +3485,7 @@ void vfree(const void *addr)
 	if (unlikely(vm->flags & VM_FLUSH_RESET_PERMS))
 		vm_reset_perms(vm);
 
-	if (!(vm->flags & VM_MAP_PUT_PAGES)) {
-		for (i = 0; i < vm->nr_pages; i++)
-			mod_lruvec_page_state(vm->pages[i], NR_VMALLOC, -1);
-	}
-	free_pages_bulk(vm->pages, vm->nr_pages);
-
+	vm_area_free_pages(vm, 0, vm->nr_pages);
 	kvfree(vm->pages);
 	kfree(vm);
 }
_

Patches currently in -mm which might be from shivamkalra98@zohomail.in are


