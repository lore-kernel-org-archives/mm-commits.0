Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC5D2222CF
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 18:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744050472; cv=none; b=RyKU8Al/+5sr20vX898Efc1rit/LWYcBEBtL4mLFCcMQ2fmj67OP7tZP8x89d47pCV9ybvIqe3Hnyre+KJIYOKLR/mLhMm/u0h/yhxaIdnzAW3UmtpPB99MymQLKVd8JwBPhoRwiQH3ie4KbZ8s6lVY2wLFJA6LGFLhLWnJc9b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744050472; c=relaxed/simple;
	bh=BhrBEACKGaOZ+oYb/R8HCVugpKomPl/wLOa4gIhi2L8=;
	h=Date:To:From:Subject:Message-Id; b=qiBXiWgxUF6oyUOpZ/uxSbxzSlBmClA+G4L252ENyTejfZZc7qv/nMwtM8DRL3AM5N3YEKYhf6WPyUuAdaKrXUw493t5nEhR34NHr4jWcBO4g0KbYGcBB6yIkBkQlx/a/BARbc/wkeHNw+SI+btBdRw2qACbu+b2S5Yh1+qwl1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZHNy5ZOv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZHNy5ZOv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B58EC4CEDD;
	Mon,  7 Apr 2025 18:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744050472;
	bh=BhrBEACKGaOZ+oYb/R8HCVugpKomPl/wLOa4gIhi2L8=;
	h=Date:To:From:Subject:From;
	b=ZHNy5ZOvnC0Xi+XG8ZXUwCTcIWx0YwhlRSoU0IEvVory3RoxEBBHtS8jvZy/6qbg+
	 zPSsEsY/ubzV/XSfb0kwosv8uVl+pEPP0seZF1ZdkqVVFa3Mpp3/h96j61NqRQK259
	 /jfZc9vE0vZkOytaKKQKiUaP3L7pgr2J+i2hps1o=
Date: Mon, 07 Apr 2025 11:27:51 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,geert@linux-m68k.org,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-report-base-address-of-single-range-correctly.patch added to mm-hotfixes-unstable branch
Message-Id: <20250407182752.2B58EC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/cma: report base address of single range correctly
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-cma-report-base-address-of-single-range-correctly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-report-base-address-of-single-range-correctly.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Link: https://lkml.kernel.org/r/20250407165435.2567898-1-fvdl@google.com
Fixes: c009da4258f9 ("mm, cma: support multiple contiguous ranges, if requested")
Signed-off-by: Frank van der Linden <fvdl@google.com>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Closes: https://lore.kernel.org/linux-mm/CAMuHMdVWviQ7O9yBFE3f=ev0eVb1CnsQvR6SKtEROBbM6z7g3w@mail.gmail.com/
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

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
@@ -724,8 +724,10 @@ static int __init __cma_declare_contiguo
 	ret = cma_init_reserved_mem(base, size, order_per_bit, name, res_cma);
 	if (ret)
 		memblock_phys_free(base, size);
-
-	(*res_cma)->nid = nid;
+	else {
+		(*res_cma)->nid = nid;
+		*basep = base;
+	}
 
 	return ret;
 }
_

Patches currently in -mm which might be from fvdl@google.com are

mm-cma-report-base-address-of-single-range-correctly.patch
mm-hugetlb-use-separate-nodemask-for-bootmem-allocations.patch

