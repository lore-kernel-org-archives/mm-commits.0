Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973D72472AE
	for <mm-commits@vger.kernel.org>; Thu,  9 Jul 2026 23:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783638324; cv=none; b=PsC6PVixsFrZy2EUbO1DhQetVBjrOXWRT7irdqEVD9tuFoc3ge68H//mmjsCyPu+WHAMzqIfwNRdMsjJxWt7vSvMJ7GIeW179AHpa0XQiP1te2eKd70sBc8bSd7+ni5xm9DxGpZPyQ6RVl0UmvIZ0ugUgCaKUHlo0g9fYdRVebo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783638324; c=relaxed/simple;
	bh=/ctCUMKOkm+4uYtfgtFrWQoWG0UOwJThGzLcOiZ5A94=;
	h=Date:To:From:Subject:Message-Id; b=jpNu2rQbq/zTDp2XNns4S3jXED+op0eYfp+CmurbW87I7Vv1el0pHk+yMXHEK2ZrVSRdwi1eEbESQo1FEKxPU+rz1VutI+BLIXYc1zrVkvhhYWwjK5tNfvvs1vxq5F5W3AjX6WW35l1S2dxFBMke16QK0k1ZeJmtwP8CRVOizkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hn6w/rmK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hn6w/rmK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D7F1F000E9;
	Thu,  9 Jul 2026 23:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783638323;
	bh=GJEI0QHl07u8ikh5lg9yN4g8WAlNnUcEYTVb4RgXMJc=;
	h=Date:To:From:Subject;
	b=hn6w/rmKBjIhkKVSbBZXTzqoHqn8EdT4Ht9pcF+mA5WMw6JtIwBOH0GXCAWUrKsJs
	 WdyUqN1HT5jij1x/RKerVnrWQH0fYlyfRtwQ+Kg1eWicbiOh0kuyCuz3U1UMBvGbGa
	 oVs3FvBzaAHaCcBKsDxRoHvf/fwtDz3Vp59yXDbg=
Date: Thu, 09 Jul 2026 16:05:22 -0700
To: mm-commits@vger.kernel.org,xueyuan.chen21@gmail.com,will@kernel.org,urezki@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,leo.yan@arm.com,jiangwen6@xiaomi.com,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,baohua@kernel.org,anshuman.khandual@arm.com,ajd@linux.ibm.com,jiangwenxiaomi@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-extract-vmap_set_ptes-to-consolidate-pte-mapping-logic.patch added to mm-new branch
Message-Id: <20260709230523.24D7F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: extract vmap_set_ptes() to consolidate PTE mapping logic
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-extract-vmap_set_ptes-to-consolidate-pte-mapping-logic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-extract-vmap_set_ptes-to-consolidate-pte-mapping-logic.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Wen Jiang <jiangwenxiaomi@gmail.com>
Subject: mm/vmalloc: extract vmap_set_ptes() to consolidate PTE mapping logic
Date: Thu, 9 Jul 2026 15:38:20 +0800

Extract the common PTE mapping logic from vmap_pte_range() into a shared
helper vmap_set_ptes().  This handles both CONT_PTE and regular PTE
mappings in a single function, preparing for the next patch which will
extend vmap_pages_pte_range() to also use this helper.

The #ifdef CONFIG_HUGETLB_PAGE guard is moved inside vmap_set_ptes(), so
callers no longer need to handle the conditional compilation.

No functional change.

Link: https://lore.kernel.org/20260709073823.6643-4-jiangwen6@xiaomi.com
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Andrew Donnellan <ajd@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-extract-vmap_set_ptes-to-consolidate-pte-mapping-logic
+++ a/mm/vmalloc.c
@@ -92,6 +92,33 @@ struct vfree_deferred {
 static DEFINE_PER_CPU(struct vfree_deferred, vfree_deferred);
 
 /*** Page table manipulation functions ***/
+
+/*
+ * Try contiguous mappings at the PTE level for arches which support them, and if
+ * requested by the caller. Fall back to PAGE_SIZE mappings otherwise.
+ *
+ * Return: mapping size.
+ */
+static __always_inline unsigned long vmap_set_ptes(pte_t *pte,
+		unsigned long addr, unsigned long end, u64 pfn,
+		pgprot_t prot, unsigned int max_page_shift)
+{
+#ifdef CONFIG_HUGETLB_PAGE
+	unsigned long size;
+
+	size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
+	if (size != PAGE_SIZE) {
+		pte_t entry = pfn_pte(pfn, prot);
+
+		entry = arch_make_huge_pte(entry, ilog2(size), 0);
+		set_huge_pte_at(&init_mm, addr, pte, entry, size);
+		return size;
+	}
+#endif
+	set_pte_at(&init_mm, addr, pte, pfn_pte(pfn, prot));
+	return PAGE_SIZE;
+}
+
 static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			phys_addr_t phys_addr, pgprot_t prot,
 			unsigned int max_page_shift, pgtbl_mod_mask *mask)
@@ -120,19 +147,8 @@ static int vmap_pte_range(pmd_t *pmd, un
 			BUG();
 		}
 
-#ifdef CONFIG_HUGETLB_PAGE
-		size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
-		if (size != PAGE_SIZE) {
-			pte_t entry = pfn_pte(pfn, prot);
-
-			entry = arch_make_huge_pte(entry, ilog2(size), 0);
-			set_huge_pte_at(&init_mm, addr, pte, entry, size);
-			pfn += PFN_DOWN(size);
-			continue;
-		}
-#endif
-		set_pte_at(&init_mm, addr, pte, pfn_pte(pfn, prot));
-		pfn++;
+		size = vmap_set_ptes(pte, addr, end, pfn, prot, max_page_shift);
+		pfn += PFN_DOWN(size);
 	} while (pte += PFN_DOWN(size), addr += size, addr != end);
 
 	lazy_mmu_mode_disable();
_

Patches currently in -mm which might be from jiangwenxiaomi@gmail.com are

mm-vmalloc-extract-vmap_set_ptes-to-consolidate-pte-mapping-logic.patch

