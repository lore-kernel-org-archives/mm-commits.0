Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0421134D4
	for <mm-commits@vger.kernel.org>; Sat, 12 Apr 2025 00:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744418020; cv=none; b=krxGeQ6DEL7oyfJdNjCqUfYnVmCrTs+uGxoeqhHsCSAv4VrNkpgc9drXSzi03YYelukzDINlf5cLvLLaBy6raHyi24ojPqy91fGFItw2FN5+CH2gNT1dsd77I5i/T8SJEcLhIGtrmPilnt8cbwt3lep0PiumJPr2Nnpqqnu6H00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744418020; c=relaxed/simple;
	bh=m0I8MQLaYsxf8dR6Bov5BwRCEHfRk+sYTyn5EWwbllw=;
	h=Date:To:From:Subject:Message-Id; b=T8E08sJhb1WISwilftyBCHaSGMJURBaVd3sJyDr9bM2O1/HTAYVLtH3vBUP3DM8dRBQS+L+oB+RMT2jmj2FRkn9QlXeGxXEzT0oPizEELD2lWd8+fnyGIxhH5RzypH6/AUDA2q2CTvEuNHKNprMx326yxanxGw7SvS7iq+rG1yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mMyoRW2h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mMyoRW2h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758E9C4CEE2;
	Sat, 12 Apr 2025 00:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744418020;
	bh=m0I8MQLaYsxf8dR6Bov5BwRCEHfRk+sYTyn5EWwbllw=;
	h=Date:To:From:Subject:From;
	b=mMyoRW2h8AWJYy1w5ip4dpS8CDYtxkeH7IMyqXIMKCWMhKsyPEg8bDI0DEHivIkuh
	 xkjLPBnSGBJJ9SGOivLnO/DpS5UMUDWdHB/jeb/YS+1FpUT5bB6yjKHGChOXOURuqD
	 ZYFJPf7lpW1OGMLdPLdO5GXDgQfZurL9Fet7+Cbc=
Date: Fri, 11 Apr 2025 17:33:39 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,geert@linux-m68k.org,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-cma-report-base-address-of-single-range-correctly.patch removed from -mm tree
Message-Id: <20250412003340.758E9C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/cma: report base address of single range correctly
has been removed from the -mm tree.  Its filename was
     mm-cma-report-base-address-of-single-range-correctly.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Frank van der Linden <fvdl@google.com>
Subject: mm/cma: report base address of single range correctly
Date: Mon, 7 Apr 2025 16:54:35 +0000

The cma_declare_contiguous_nid code was refactored by commit c009da4258f9
("mm, cma: support multiple contiguous ranges, if requested"), so that it
could use an internal function to attempt a single range area first, and
then try a multi-range one.

However, that meant that the actual base address used for the !fixed case
(base == 0) wasn't available one level up to be printed in the
informational message, and it would always end up printing a base address
of 0 in the boot message.

Make the internal function take a phys_addr_t pointer to the base address,
so that the value is available to the caller.

[fvdl@google.com: v2]
  Link: https://lkml.kernel.org/r/20250408164000.3215690-1-fvdl@google.com
Link: https://lkml.kernel.org/r/20250407165435.2567898-1-fvdl@google.com
Fixes: c009da4258f9 ("mm, cma: support multiple contiguous ranges, if requested")
Signed-off-by: Frank van der Linden <fvdl@google.com>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Closes: https://lore.kernel.org/linux-mm/CAMuHMdVWviQ7O9yBFE3f=ev0eVb1CnsQvR6SKtEROBbM6z7g3w@mail.gmail.com/
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/mm/cma.c~mm-cma-report-base-address-of-single-range-correctly
+++ a/mm/cma.c
@@ -35,7 +35,7 @@
 struct cma cma_areas[MAX_CMA_AREAS];
 unsigned int cma_area_count;
 
-static int __init __cma_declare_contiguous_nid(phys_addr_t base,
+static int __init __cma_declare_contiguous_nid(phys_addr_t *basep,
 			phys_addr_t size, phys_addr_t limit,
 			phys_addr_t alignment, unsigned int order_per_bit,
 			bool fixed, const char *name, struct cma **res_cma,
@@ -370,7 +370,7 @@ int __init cma_declare_contiguous_multi(
 			phys_addr_t align, unsigned int order_per_bit,
 			const char *name, struct cma **res_cma, int nid)
 {
-	phys_addr_t start, end;
+	phys_addr_t start = 0, end;
 	phys_addr_t size, sizesum, sizeleft;
 	struct cma_init_memrange *mrp, *mlp, *failed;
 	struct cma_memrange *cmrp;
@@ -384,7 +384,7 @@ int __init cma_declare_contiguous_multi(
 	/*
 	 * First, try it the normal way, producing just one range.
 	 */
-	ret = __cma_declare_contiguous_nid(0, total_size, 0, align,
+	ret = __cma_declare_contiguous_nid(&start, total_size, 0, align,
 			order_per_bit, false, name, res_cma, nid);
 	if (ret != -ENOMEM)
 		goto out;
@@ -580,7 +580,7 @@ int __init cma_declare_contiguous_nid(ph
 {
 	int ret;
 
-	ret = __cma_declare_contiguous_nid(base, size, limit, alignment,
+	ret = __cma_declare_contiguous_nid(&base, size, limit, alignment,
 			order_per_bit, fixed, name, res_cma, nid);
 	if (ret != 0)
 		pr_err("Failed to reserve %ld MiB\n",
@@ -592,14 +592,14 @@ int __init cma_declare_contiguous_nid(ph
 	return ret;
 }
 
-static int __init __cma_declare_contiguous_nid(phys_addr_t base,
+static int __init __cma_declare_contiguous_nid(phys_addr_t *basep,
 			phys_addr_t size, phys_addr_t limit,
 			phys_addr_t alignment, unsigned int order_per_bit,
 			bool fixed, const char *name, struct cma **res_cma,
 			int nid)
 {
 	phys_addr_t memblock_end = memblock_end_of_DRAM();
-	phys_addr_t highmem_start;
+	phys_addr_t highmem_start, base = *basep;
 	int ret;
 
 	/*
@@ -722,12 +722,15 @@ static int __init __cma_declare_contiguo
 	}
 
 	ret = cma_init_reserved_mem(base, size, order_per_bit, name, res_cma);
-	if (ret)
+	if (ret) {
 		memblock_phys_free(base, size);
+		return ret;
+	}
 
 	(*res_cma)->nid = nid;
+	*basep = base;
 
-	return ret;
+	return 0;
 }
 
 static void cma_debug_show_areas(struct cma *cma)
_

Patches currently in -mm which might be from fvdl@google.com are

mm-hugetlb-use-separate-nodemask-for-bootmem-allocations.patch

