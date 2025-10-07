Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D9923816C
	for <mm-commits@vger.kernel.org>; Tue,  7 Oct 2025 21:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759872995; cv=none; b=KiiuNDqMemLmY/HUvZBW1g9Krfbn3yMl3IO1Qt2p4hlsYQNj+SCEUEuP3suQJfssDuQJzo25nOU9yIQ3kYqpXtA7hFPC08FVKcOTeQGoKCUM/7zFp1aRc58iPAj+HPbl3emPalJnVCrYVQy6P/mNGUBBi8M4Sq3s3/iz4jt6xa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759872995; c=relaxed/simple;
	bh=ZSXjlrjkawdiQKCoshiqkqMcmlMPPDltN/iki9GEztQ=;
	h=Date:To:From:Subject:Message-Id; b=qyl9D5LhEWOSYwf9Jnv+LZ9PqjpgTUTDD+DweFjc1PpCnm3mIO3HZ29W9yvUsaqeXUiU12EB56AM/MJsECDd7SQuk0svwcS7cV1m7rhoOxquEpSLN2LwzPHsvNoKeI7zd0/2HVAOUtc51Osan/9R3xT/eR6cMeBdzEZFtdUI2Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xl7HrsVW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xl7HrsVW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E80C4CEF1;
	Tue,  7 Oct 2025 21:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759872995;
	bh=ZSXjlrjkawdiQKCoshiqkqMcmlMPPDltN/iki9GEztQ=;
	h=Date:To:From:Subject:From;
	b=Xl7HrsVWK0JRFQ2EGu85yIkF+GYu5s6v2uPjADlq4ZaXPotS/3cnPzFOlryiLKvBl
	 fo+dRK4gQdngxEGi91kS9qoJ8PHv4w0+smZazxRz9GYOPWaj5ubmhDQSBJKC9KBs03
	 Hf6oKfWPP0cQLcQtSJeeq0g43eRgo4RR/bxBSci4=
Date: Tue, 07 Oct 2025 14:36:34 -0700
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,mhocko@suse.com,mhocko@kernel.org,glider@google.com,elver@google.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-handle-non-blocking-gfp-in-__vmalloc_area_node.patch added to mm-new branch
Message-Id: <20251007213635.32E80C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: handle non-blocking GFP in __vmalloc_area_node()
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-handle-non-blocking-gfp-in-__vmalloc_area_node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-handle-non-blocking-gfp-in-__vmalloc_area_node.patch

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

