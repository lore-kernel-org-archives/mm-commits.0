Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4FD20FAAB
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343127; cv=none; b=Txi3ROtVs1iJ1jTwpX9PKz3hE9w1fgkSu38Iyn+B1VVTVGFDo08Yf1wjlOgNXqDUiwsxcd7AK9Tt4SaCPbzYBTAYUK/rarpF2yKfhtDTM/0M7liAihPTGeZnZBCMMWNzvmcgmZoSorHaJcnBtVZyHgRZf4LTVMFcEYcePVOqy1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343127; c=relaxed/simple;
	bh=GIyF8c+XabW3xnjUE761N65r5zs/93MznGMLcydNqxI=;
	h=Date:To:From:Subject:Message-Id; b=GfGXy0g8XyY+h3MfbZ8AaPgjZDUKhw+uOrufyhaKTgTNzbznqyChn99JjXA/uPBt8G5frLeZRZ99KwcxykZzpnVoWRIuA/wEydXiNpEYrADEqRsik2CYNcVr6LlFWbjgmhyKnLKxTmhXdH7UDiRxcC8fo8VDUjBTAZHLMUs0dWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q55sv9TX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q55sv9TX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30EF0C116D0;
	Mon, 17 Nov 2025 01:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343127;
	bh=GIyF8c+XabW3xnjUE761N65r5zs/93MznGMLcydNqxI=;
	h=Date:To:From:Subject:From;
	b=q55sv9TXhWj2Kx9itEUD5MA5977U3RwAxa86FP5ovmLTyrat94JcGhC4cKHGLKk1z
	 JYQiryg2si4qFyKT0vpkvSf8lc1U5NuoZyTA1vAXsz4C3nKcW0gAYvyOkJi7vInRh0
	 DIKL45OeW5r0lsIVqmmvP7fhGYTjKu/sB9zW7Xxs=
Date: Sun, 16 Nov 2025 17:32:06 -0800
To: mm-commits@vger.kernel.org,ying.huang@linux.alibaba.com,urezki@gmail.com,dev.jain@arm.com,yadong.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-warn_on-if-mapping-size-is-not-page_size-aligned.patch removed from -mm tree
Message-Id: <20251117013207.30EF0C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmalloc: WARN_ON if mapping size is not PAGE_SIZE aligned
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-warn_on-if-mapping-size-is-not-page_size-aligned.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[yadong.qi@linux.alibaba.com: fix uninitialized value issue]
  Closes: https://lore.kernel.org/r/202510110050.VG9YKMRK-lkp@intel.com/
Link: https://lkml.kernel.org/r/20251010014311.1689-1-yadong.qi@linux.alibaba.com
Signed-off-by: Yadong Qi <yadong.qi@linux.alibaba.com>
Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
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
+	int err = 0;
 
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
+	int err = 0;
 
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
+	int err = 0;
 
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


