Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469402940B
	for <mm-commits@vger.kernel.org>; Fri, 10 Oct 2025 02:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760063502; cv=none; b=e4J+dZYwImiCroJw6ACCzaG+sveCvua/FtiLn/gvIyIdH4sdVChhK8pt3zcSABorRlZbjixPRHCGb8ODaTGYKFYLERySfv4SSaIkpDjmEBrstjOVyrWT52gihMWQE5Uqs+yt0nuDZbji1MLGY8eK7z2XEsBnutZTnJ3gCSKhKT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760063502; c=relaxed/simple;
	bh=5VXYbvIpvPf4Q/lrj1mLGHvPHrma7PAc0zzQeYLAp8s=;
	h=Date:To:From:Subject:Message-Id; b=OGCUzwZ3lbqYdrSm5BY2VOYG7BFagHYj7YQqHWnDORWV08mB8ReJGFgj7T7uwIIF45hoogHUbc1UzZEHyqOElueZrrL63PK/UwnmpCS5hQFvWUgjGJE4K1ZUNwMp+EkAYt7mlfsFi6X5y5444Qt+XYo9dIFi6kgsixy0QB4+sR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xszizcLx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xszizcLx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906FBC4CEE7;
	Fri, 10 Oct 2025 02:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760063501;
	bh=5VXYbvIpvPf4Q/lrj1mLGHvPHrma7PAc0zzQeYLAp8s=;
	h=Date:To:From:Subject:From;
	b=xszizcLxBG9Qxh+ZGJLy56u2E8b1AZHWNswhxmUbt49aAHArWiCnfv8fjoc1UJgMw
	 dXwxZkH5mYBNCanBCxOquZ20/FO0scUSrgVHekVXOZrhpSDmKz63noYMtLwVe/Ed4W
	 afzo5cBqxXRkf8LxXquJfhMJ2z9y7b25CJq29lDg=
Date: Thu, 09 Oct 2025 19:31:40 -0700
To: mm-commits@vger.kernel.org,ying.huang@linux.alibaba.com,urezki@gmail.com,yadong.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-warn_on-if-mapping-size-is-not-page_size-aligned.patch added to mm-new branch
Message-Id: <20251010023141.906FBC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmalloc: WARN_ON if mapping size is not PAGE_SIZE aligned
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-warn_on-if-mapping-size-is-not-page_size-aligned.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-warn_on-if-mapping-size-is-not-page_size-aligned.patch

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
From: Yadong Qi <yadong.qi@linux.alibaba.com>
Subject: mm: vmalloc: WARN_ON if mapping size is not PAGE_SIZE aligned
Date: Fri, 10 Oct 2025 09:43:11 +0800

In mm/vmalloc.c, the function vmap_pte_range() assumes that the mapping
size is aligned to PAGE_SIZE.  If this assumption is violated, the loop
will become infinite because the termination condition (`addr != end`)
will never be met.  This can lead to overwriting other VA ranges and/or
random pages physically follow the page table.

It's the caller's responsibility to ensure that the mapping size is
aligned to PAGE_SIZE.  However, the memory corruption is hard to root
cause.  To identify the programming error in the caller easier, check
whether the mapping size is PAGE_SIZE aligned with WARN_ON_ONCE().

Link: https://lkml.kernel.org/r/20251010014311.1689-1-yadong.qi@linux.alibaba.com
Signed-off-by: Yadong Qi <yadong.qi@linux.alibaba.com>
Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-warn_on-if-mapping-size-is-not-page_size-aligned
+++ a/mm/vmalloc.c
@@ -100,6 +100,9 @@ static int vmap_pte_range(pmd_t *pmd, un
 	struct page *page;
 	unsigned long size = PAGE_SIZE;
 
+	if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
+		return -EINVAL;
+
 	pfn = phys_addr >> PAGE_SHIFT;
 	pte = pte_alloc_kernel_track(pmd, addr, mask);
 	if (!pte)
@@ -167,6 +170,7 @@ static int vmap_pmd_range(pud_t *pud, un
 {
 	pmd_t *pmd;
 	unsigned long next;
+	int err;
 
 	pmd = pmd_alloc_track(&init_mm, pud, addr, mask);
 	if (!pmd)
@@ -180,10 +184,11 @@ static int vmap_pmd_range(pud_t *pud, un
 			continue;
 		}
 
-		if (vmap_pte_range(pmd, addr, next, phys_addr, prot, max_page_shift, mask))
-			return -ENOMEM;
+		err = vmap_pte_range(pmd, addr, next, phys_addr, prot, max_page_shift, mask);
+		if (err)
+			break;
 	} while (pmd++, phys_addr += (next - addr), addr = next, addr != end);
-	return 0;
+	return err;
 }
 
 static int vmap_try_huge_pud(pud_t *pud, unsigned long addr, unsigned long end,
@@ -217,6 +222,7 @@ static int vmap_pud_range(p4d_t *p4d, un
 {
 	pud_t *pud;
 	unsigned long next;
+	int err;
 
 	pud = pud_alloc_track(&init_mm, p4d, addr, mask);
 	if (!pud)
@@ -230,11 +236,11 @@ static int vmap_pud_range(p4d_t *p4d, un
 			continue;
 		}
 
-		if (vmap_pmd_range(pud, addr, next, phys_addr, prot,
-					max_page_shift, mask))
-			return -ENOMEM;
+		err = vmap_pmd_range(pud, addr, next, phys_addr, prot, max_page_shift, mask);
+		if (err)
+			break;
 	} while (pud++, phys_addr += (next - addr), addr = next, addr != end);
-	return 0;
+	return err;
 }
 
 static int vmap_try_huge_p4d(p4d_t *p4d, unsigned long addr, unsigned long end,
@@ -268,6 +274,7 @@ static int vmap_p4d_range(pgd_t *pgd, un
 {
 	p4d_t *p4d;
 	unsigned long next;
+	int err;
 
 	p4d = p4d_alloc_track(&init_mm, pgd, addr, mask);
 	if (!p4d)
@@ -281,11 +288,11 @@ static int vmap_p4d_range(pgd_t *pgd, un
 			continue;
 		}
 
-		if (vmap_pud_range(p4d, addr, next, phys_addr, prot,
-					max_page_shift, mask))
-			return -ENOMEM;
+		err = vmap_pud_range(p4d, addr, next, phys_addr, prot, max_page_shift, mask);
+		if (err)
+			break;
 	} while (p4d++, phys_addr += (next - addr), addr = next, addr != end);
-	return 0;
+	return err;
 }
 
 static int vmap_range_noflush(unsigned long addr, unsigned long end,
_

Patches currently in -mm which might be from yadong.qi@linux.alibaba.com are

mm-vmalloc-warn_on-if-mapping-size-is-not-page_size-aligned.patch

