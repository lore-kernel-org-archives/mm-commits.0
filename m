Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3B41C1F02
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343084; cv=none; b=jz94/3BQpW4qjNgN4VBG5dIrq2HPoFtxsP41Hn9J+hQ+X1KGVifHRJCKsEACTCmbeFNQpbxD0+9X5R63O6cveySscnkqAsKtLvGkJQP0S5Xq0IegyezIkXNVFjIm/ae3cIULe+oj3qBED98SdrotBrNTIJenPzkh7pSuL6owZjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343084; c=relaxed/simple;
	bh=BMqsFINozzffOhZ1nIYohButG56qel1I2fhWRkyIgDs=;
	h=Date:To:From:Subject:Message-Id; b=V3KUYprojGNTbeiiX73upjVoTHQdgKDVDKiwIQZ8yXQixzliNOxmJ0HrqbmdE8Dj7opoBY5hvqcCJlA2GdBgH/5/lzb9VpJ4/7mCMQgVXStbugkRTx12A4RrX1mKnLRr0e2LjIWKw8vkq9xuBzg8BQmiILH0bVrX0WViGjBHrQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yyGU3oET; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yyGU3oET"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D293C19421;
	Mon, 17 Nov 2025 01:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343084;
	bh=BMqsFINozzffOhZ1nIYohButG56qel1I2fhWRkyIgDs=;
	h=Date:To:From:Subject:From;
	b=yyGU3oETLLHBF9wpgzl6tuIBo3Yr5cHlQiyzHs24rxJjS1in+Io8ADRSSXbPtL6t7
	 6KhBTzIOjJsQXFjb5Zh/vxnBxgUM/kfwW6yR0ttCDI8TI9SU1uoygvkwjt7yDvnoPR
	 92ZLrjaHwSYSJ+yqcov52NIksCQTsEVTzZiHn4vU=
Date: Sun, 16 Nov 2025 17:31:23 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,mhocko@suse.com,mhocko@kernel.org,glider@google.com,elver@google.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-handle-non-blocking-gfp-in-__vmalloc_area_node.patch removed from -mm tree
Message-Id: <20251117013124.1D293C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: handle non-blocking GFP in __vmalloc_area_node()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-handle-non-blocking-gfp-in-__vmalloc_area_node.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: handle non-blocking GFP in __vmalloc_area_node()
Date: Tue, 7 Oct 2025 14:20:30 +0200

Make __vmalloc_area_node() respect non-blocking GFP masks such as
GFP_ATOMIC and GFP_NOWAIT.

- Add memalloc_apply_gfp_scope()/memalloc_restore_scope()
  helpers to apply a proper scope.
- Apply memalloc_apply_gfp_scope()/memalloc_restore_scope()
  around vmap_pages_range() for page table setup.
- Set "nofail" to false if a non-blocking mask is used, as
  they are mutually exclusive.

This is particularly important for page table allocations that internally
use GFP_PGTABLE_KERNEL, which may sleep unless such scope restrictions are
applied.  For example:

<snip>
__pte_alloc_kernel()
  pte_alloc_one_kernel(&init_mm);
    pagetable_alloc_noprof(GFP_PGTABLE_KERNEL & ~__GFP_HIGHMEM, 0);
<snip>

Note: in most cases, PTE entries are established only up to the level
required by current vmap space usage, meaning the page tables are
typically fully populated during the mapping process.

Link: https://lkml.kernel.org/r/20251007122035.56347-6-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    2 +
 mm/vmalloc.c            |   52 ++++++++++++++++++++++++++++++--------
 2 files changed, 44 insertions(+), 10 deletions(-)

--- a/include/linux/vmalloc.h~mm-vmalloc-handle-non-blocking-gfp-in-__vmalloc_area_node
+++ a/include/linux/vmalloc.h
@@ -332,4 +332,6 @@ bool vmalloc_dump_obj(void *object);
 static inline bool vmalloc_dump_obj(void *object) { return false; }
 #endif
 
+unsigned int memalloc_apply_gfp_scope(gfp_t gfp_mask);
+void memalloc_restore_scope(unsigned int flags);
 #endif /* _LINUX_VMALLOC_H */
--- a/mm/vmalloc.c~mm-vmalloc-handle-non-blocking-gfp-in-__vmalloc_area_node
+++ a/mm/vmalloc.c
@@ -3716,6 +3716,42 @@ static void defer_vm_area_cleanup(struct
 		schedule_work(&cleanup_vm_area);
 }
 
+/*
+ * Page tables allocations ignore external GFP. Enforces it by
+ * the memalloc scope API. It is used by vmalloc internals and
+ * KASAN shadow population only.
+ *
+ * GFP to scope mapping:
+ *
+ * non-blocking (no __GFP_DIRECT_RECLAIM) - memalloc_noreclaim_save()
+ * GFP_NOFS - memalloc_nofs_save()
+ * GFP_NOIO - memalloc_noio_save()
+ *
+ * Returns a flag cookie to pair with restore.
+ */
+unsigned int
+memalloc_apply_gfp_scope(gfp_t gfp_mask)
+{
+	unsigned int flags = 0;
+
+	if (!gfpflags_allow_blocking(gfp_mask))
+		flags = memalloc_noreclaim_save();
+	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
+		flags = memalloc_nofs_save();
+	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
+		flags = memalloc_noio_save();
+
+	/* 0 - no scope applied. */
+	return flags;
+}
+
+void
+memalloc_restore_scope(unsigned int flags)
+{
+	if (flags)
+		memalloc_flags_restore(flags);
+}
+
 static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 				 pgprot_t prot, unsigned int page_shift,
 				 int node)
@@ -3732,6 +3768,10 @@ static void *__vmalloc_area_node(struct
 
 	array_size = (unsigned long)nr_small_pages * sizeof(struct page *);
 
+	/* __GFP_NOFAIL and "noblock" flags are mutually exclusive. */
+	if (!gfpflags_allow_blocking(gfp_mask))
+		nofail = false;
+
 	if (!(gfp_mask & (GFP_DMA | GFP_DMA32)))
 		gfp_mask |= __GFP_HIGHMEM;
 
@@ -3797,22 +3837,14 @@ static void *__vmalloc_area_node(struct
 	 * page tables allocations ignore external gfp mask, enforce it
 	 * by the scope API
 	 */
-	if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
-		flags = memalloc_nofs_save();
-	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
-		flags = memalloc_noio_save();
-
+	flags = memalloc_apply_gfp_scope(gfp_mask);
 	do {
 		ret = vmap_pages_range(addr, addr + size, prot, area->pages,
 			page_shift);
 		if (nofail && (ret < 0))
 			schedule_timeout_uninterruptible(1);
 	} while (nofail && (ret < 0));
-
-	if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
-		memalloc_nofs_restore(flags);
-	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
-		memalloc_noio_restore(flags);
+	memalloc_restore_scope(flags);
 
 	if (ret < 0) {
 		warn_alloc(gfp_mask, NULL,
_

Patches currently in -mm which might be from urezki@gmail.com are


