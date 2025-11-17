Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2D01FF5E3
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343087; cv=none; b=E4s2cqG5dP0K1v2mVy7EY5E+JU5tWa+fBqpYI85v8jhYbX32pTjL+JqC4obuqVH9tBEuW8JMIQxXmvg6ZlNRCdrXubWxw0HWut6t12RFNM8GlvdEX754424Hg/kknDYiEv44bMwGxWYnLrRyFgZxcwg4J1Ss7zI5n0EGuJCK64Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343087; c=relaxed/simple;
	bh=stcyQk2h8L70p5MogSxQSav+dN6HrBUpmBYjWlQANaQ=;
	h=Date:To:From:Subject:Message-Id; b=bif21mEMOAHpCQGNii7YT/f+x7WcmlnC15eC9YF5XgSwDPwEZBaHkeFsP8edTIW47Ex/CHvPlP2pYkjrCwJl+Tu/H3mZfXy1LSzzHRFe1W3I0+FOPdVe9hz/fsuO0r6bnbIVjzO8tsWqUIH3MY34dnb+7frkZQMYtIF8U4/XEYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SbYE4/d9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SbYE4/d9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5559C4CEF1;
	Mon, 17 Nov 2025 01:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343086;
	bh=stcyQk2h8L70p5MogSxQSav+dN6HrBUpmBYjWlQANaQ=;
	h=Date:To:From:Subject:From;
	b=SbYE4/d9t2g9PGSkqehdOFU8z4lxRv7LPDMW+Z9iMWnh3Kao0u0JaBIy4CLwvmlia
	 jTHqCKW3tLlaboiPEOXV7SE6xgSUaf/MZ375mx1J0c592XtHNV010ik18woxcJFBny
	 fqkLxuCsNtf5XjpNGpZze+LLito+nbt5fr2RuNu0=
Date: Sun, 16 Nov 2025 17:31:26 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,mhocko@suse.com,mhocko@kernel.org,glider@google.com,elver@google.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kmsan-remove-hard-coded-gfp_kernel-flags.patch removed from -mm tree
Message-Id: <20251117013126.B5559C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kmsan: remove hard-coded GFP_KERNEL flags
has been removed from the -mm tree.  Its filename was
     kmsan-remove-hard-coded-gfp_kernel-flags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


