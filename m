Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C76D24676C
	for <mm-commits@vger.kernel.org>; Tue,  7 Oct 2025 21:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759873000; cv=none; b=r342a8kTUnZRhdU71azOKyJx58ZefzCUEQVlI9nTne6TgKQ8e4VJTm6FpKta1LA6f8tyedJC1+xJCenWPaPGrbxEXh3FKGZfKCqCRZi/eoK1CuDDhPZ4ckilWUhivg1gWMjpHNcjunwLAO0enCrSmCemkvUmNQWipEzFkB/Kecg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759873000; c=relaxed/simple;
	bh=41wVTjZaZbGhnE7yXVCJUqEuY7vliV/PaMaDyo4Mk+8=;
	h=Date:To:From:Subject:Message-Id; b=PoSkcp4ZY69cNzagIhi6BlplKO9Cke+Trdbc+MapMjN4Zz+QZK+P7Ojt8sWvUHXV+LTizJrJPOcB6YWjdHP5b3ASCcE7GCOu2gUPH+D5bNWZmnZ/ZsmYT44P4mQc4qVJpPyjA6AFQ+yj57YqEQXr4Yz4eaN2xBnLiGn5/+vQin8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MsNQdzZK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MsNQdzZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD833C4CEF1;
	Tue,  7 Oct 2025 21:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759872999;
	bh=41wVTjZaZbGhnE7yXVCJUqEuY7vliV/PaMaDyo4Mk+8=;
	h=Date:To:From:Subject:From;
	b=MsNQdzZKhNiAsUF56UK9aKXut/f6vtX7IRH9yQqJtIelEpGNlfjZBAyk+yZbsX0j+
	 GqgwIDXv9OYBdILkAQs6IqNBxzEu3EmX+ZNqVwsmvlGWcouEqy7ki9sHk4+o7CWK1H
	 A3yF3iAmvdTOpIypeJ+z3qlwnUhLp+CFTmfvBLms=
Date: Tue, 07 Oct 2025 14:36:39 -0700
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,mhocko@suse.com,mhocko@kernel.org,glider@google.com,elver@google.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kmsan-remove-hard-coded-gfp_kernel-flags.patch added to mm-new branch
Message-Id: <20251007213639.BD833C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kmsan: remove hard-coded GFP_KERNEL flags
has been added to the -mm mm-new branch.  Its filename is
     kmsan-remove-hard-coded-gfp_kernel-flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmsan-remove-hard-coded-gfp_kernel-flags.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: kmsan: remove hard-coded GFP_KERNEL flags
Date: Tue, 7 Oct 2025 14:20:32 +0200

kmsan_vmap_pages_range_noflush() allocates its temp s_pages/o_pages arrays
with GFP_KERNEL, which may sleep.  This is inconsistent with vmalloc() as
it will support non-blocking requests later.

Plumb gfp_mask through the kmsan_vmap_pages_range_noflush(), so it can use
it internally for its demand.

Please note, the subsequent __vmap_pages_range_noflush() still uses
GFP_KERNEL and can sleep.  If a caller runs under reclaim constraints,
sleeping is forbidden, it must establish the appropriate memalloc scope
API.

Link: https://lkml.kernel.org/r/20251007122035.56347-8-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kmsan.h |    6 ++++--
 mm/internal.h         |    4 ++--
 mm/kmsan/shadow.c     |    6 +++---
 mm/percpu-vm.c        |    2 +-
 mm/vmalloc.c          |   26 +++++++++++++++++---------
 5 files changed, 27 insertions(+), 17 deletions(-)

--- a/include/linux/kmsan.h~kmsan-remove-hard-coded-gfp_kernel-flags
+++ a/include/linux/kmsan.h
@@ -133,6 +133,7 @@ void kmsan_kfree_large(const void *ptr);
  * @prot:	page protection flags used for vmap.
  * @pages:	array of pages.
  * @page_shift:	page_shift passed to vmap_range_noflush().
+ * @gfp_mask:	gfp_mask to use internally.
  *
  * KMSAN maps shadow and origin pages of @pages into contiguous ranges in
  * vmalloc metadata address range. Returns 0 on success, callers must check
@@ -142,7 +143,8 @@ int __must_check kmsan_vmap_pages_range_
 						unsigned long end,
 						pgprot_t prot,
 						struct page **pages,
-						unsigned int page_shift);
+						unsigned int page_shift,
+						gfp_t gfp_mask);
 
 /**
  * kmsan_vunmap_kernel_range_noflush() - Notify KMSAN about a vunmap.
@@ -347,7 +349,7 @@ static inline void kmsan_kfree_large(con
 
 static inline int __must_check kmsan_vmap_pages_range_noflush(
 	unsigned long start, unsigned long end, pgprot_t prot,
-	struct page **pages, unsigned int page_shift)
+	struct page **pages, unsigned int page_shift, gfp_t gfp_mask)
 {
 	return 0;
 }
--- a/mm/internal.h~kmsan-remove-hard-coded-gfp_kernel-flags
+++ a/mm/internal.h
@@ -1355,7 +1355,7 @@ size_t splice_folio_into_pipe(struct pip
 #ifdef CONFIG_MMU
 void __init vmalloc_init(void);
 int __must_check vmap_pages_range_noflush(unsigned long addr, unsigned long end,
-                pgprot_t prot, struct page **pages, unsigned int page_shift);
+	pgprot_t prot, struct page **pages, unsigned int page_shift, gfp_t gfp_mask);
 unsigned int get_vm_area_page_order(struct vm_struct *vm);
 #else
 static inline void vmalloc_init(void)
@@ -1364,7 +1364,7 @@ static inline void vmalloc_init(void)
 
 static inline
 int __must_check vmap_pages_range_noflush(unsigned long addr, unsigned long end,
-                pgprot_t prot, struct page **pages, unsigned int page_shift)
+	pgprot_t prot, struct page **pages, unsigned int page_shift, gfp_t gfp_mask)
 {
 	return -EINVAL;
 }
--- a/mm/kmsan/shadow.c~kmsan-remove-hard-coded-gfp_kernel-flags
+++ a/mm/kmsan/shadow.c
@@ -215,7 +215,7 @@ void kmsan_free_page(struct page *page,
 
 int kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
 				   pgprot_t prot, struct page **pages,
-				   unsigned int page_shift)
+				   unsigned int page_shift, gfp_t gfp_mask)
 {
 	unsigned long shadow_start, origin_start, shadow_end, origin_end;
 	struct page **s_pages, **o_pages;
@@ -230,8 +230,8 @@ int kmsan_vmap_pages_range_noflush(unsig
 		return 0;
 
 	nr = (end - start) / PAGE_SIZE;
-	s_pages = kcalloc(nr, sizeof(*s_pages), GFP_KERNEL);
-	o_pages = kcalloc(nr, sizeof(*o_pages), GFP_KERNEL);
+	s_pages = kcalloc(nr, sizeof(*s_pages), gfp_mask);
+	o_pages = kcalloc(nr, sizeof(*o_pages), gfp_mask);
 	if (!s_pages || !o_pages) {
 		err = -ENOMEM;
 		goto ret;
--- a/mm/percpu-vm.c~kmsan-remove-hard-coded-gfp_kernel-flags
+++ a/mm/percpu-vm.c
@@ -194,7 +194,7 @@ static int __pcpu_map_pages(unsigned lon
 			    int nr_pages)
 {
 	return vmap_pages_range_noflush(addr, addr + (nr_pages << PAGE_SHIFT),
-					PAGE_KERNEL, pages, PAGE_SHIFT);
+			PAGE_KERNEL, pages, PAGE_SHIFT, GFP_KERNEL);
 }
 
 /**
--- a/mm/vmalloc.c~kmsan-remove-hard-coded-gfp_kernel-flags
+++ a/mm/vmalloc.c
@@ -671,16 +671,28 @@ int __vmap_pages_range_noflush(unsigned
 }
 
 int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
-		pgprot_t prot, struct page **pages, unsigned int page_shift)
+		pgprot_t prot, struct page **pages, unsigned int page_shift,
+		gfp_t gfp_mask)
 {
 	int ret = kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
-						 page_shift);
+						page_shift, gfp_mask);
 
 	if (ret)
 		return ret;
 	return __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
 }
 
+static int __vmap_pages_range(unsigned long addr, unsigned long end,
+		pgprot_t prot, struct page **pages, unsigned int page_shift,
+		gfp_t gfp_mask)
+{
+	int err;
+
+	err = vmap_pages_range_noflush(addr, end, prot, pages, page_shift, gfp_mask);
+	flush_cache_vmap(addr, end);
+	return err;
+}
+
 /**
  * vmap_pages_range - map pages to a kernel virtual address
  * @addr: start of the VM area to map
@@ -696,11 +708,7 @@ int vmap_pages_range_noflush(unsigned lo
 int vmap_pages_range(unsigned long addr, unsigned long end,
 		pgprot_t prot, struct page **pages, unsigned int page_shift)
 {
-	int err;
-
-	err = vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
-	flush_cache_vmap(addr, end);
-	return err;
+	return __vmap_pages_range(addr, end, prot, pages, page_shift, GFP_KERNEL);
 }
 
 static int check_sparse_vm_area(struct vm_struct *area, unsigned long start,
@@ -3839,8 +3847,8 @@ static void *__vmalloc_area_node(struct
 	 */
 	flags = memalloc_apply_gfp_scope(gfp_mask);
 	do {
-		ret = vmap_pages_range(addr, addr + size, prot, area->pages,
-			page_shift);
+		ret = __vmap_pages_range(addr, addr + size, prot, area->pages,
+				page_shift, nested_gfp);
 		if (nofail && (ret < 0))
 			schedule_timeout_uninterruptible(1);
 	} while (nofail && (ret < 0));
_

Patches currently in -mm which might be from urezki@gmail.com are

lib-test_vmalloc-add-no_block_alloc_test-case.patch
lib-test_vmalloc-remove-xfail-condition-check.patch
mm-vmalloc-support-non-blocking-gfp-flags-in-alloc_vmap_area.patch
mm-vmalloc-defer-freeing-partly-initialized-vm_struct.patch
mm-vmalloc-handle-non-blocking-gfp-in-__vmalloc_area_node.patch
mm-kasan-support-non-blocking-gfp-in-kasan_populate_vmalloc.patch
kmsan-remove-hard-coded-gfp_kernel-flags.patch
mm-skip-might_alloc-warnings-when-pf_memalloc-is-set.patch
mm-vmalloc-update-__vmalloc_node_range-documentation.patch
mm-kvmalloc-add-non-blocking-support-for-vmalloc.patch

