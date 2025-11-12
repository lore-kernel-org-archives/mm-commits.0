Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05C9EACD
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762906249; cv=none; b=SqQT6XG2pLjB7yzF04s78zz/PZk7uAAhLdawJfgC7Yxkg7Y+/BflgYUajq7ArEOg/mo1fIGuWKEI1K0nYrywhL/8+ZBHjRGG6bgRF2HPpRIwz/zCw+UUVyDBwKQoFV8B/m9t8vi1NMbTlbahZboUAwP6cmxi1ohb4uHMgMI/Ekk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762906249; c=relaxed/simple;
	bh=41its8oq8rq9O9YeGoft3lPlYKAZ1c24irbPlzwoC/8=;
	h=Date:To:From:Subject:Message-Id; b=jSULt0OqMbZr1NS7eYgQSEJckKsK7UlR4w5AOEaMMuep05/TXRQCyEuYxKz6xlB5Athm514L1BhrCVIjTsa5mEQFQD/Q6Nos5Pe5DvdPC4+pieCEQQjW2Doku5ksWREe4DikA/fI4D00fLpF5HwCLLcGbkwjE4khps2DZehIqeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KhHSQ55v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KhHSQ55v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DB22C4CEFB;
	Wed, 12 Nov 2025 00:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762906248;
	bh=41its8oq8rq9O9YeGoft3lPlYKAZ1c24irbPlzwoC/8=;
	h=Date:To:From:Subject:From;
	b=KhHSQ55vnc9kHI6UvzAcm/1XwjuEVgmT+rT9N8Mb2IzoZ4WcHACnVjbD1WXope3Ak
	 347IR/a4eRa0vU27xHDJoqgP8OKMl5tH+svmCRUrWRXl1o176AUm0pzfIXCLnx8lXt
	 XVzXrrabv26fWNCwDo4QQLwb7nE50E5KxTdGhDpM=
Date: Tue, 11 Nov 2025 16:10:47 -0800
To: mm-commits@vger.kernel.org,ying.huang@linux.alibaba.com,urezki@gmail.com,lkp@intel.com,dev.jain@arm.com,dan.carpenter@linaro.org,yadong.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vmalloc-warn_on-if-mapping-size-is-not-page_size-aligned-fix.patch removed from -mm tree
Message-Id: <20251112001048.3DB22C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmalloc: fix uninitialized value issue
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-warn_on-if-mapping-size-is-not-page_size-aligned-fix.patch

This patch was dropped because it was folded into mm-vmalloc-warn_on-if-mapping-size-is-not-page_size-aligned.patch

------------------------------------------------------
From: Yadong Qi <yadong.qi@linux.alibaba.com>
Subject: mm: vmalloc: fix uninitialized value issue
Date: Tue, 14 Oct 2025 18:23:37 +0800

Issues reported by LKP:
  mm/vmalloc.c:191 vmap_pmd_range() error: uninitialized symbol 'err'.
  mm/vmalloc.c:243 vmap_pud_range() error: uninitialized symbol 'err'.
  mm/vmalloc.c:295 vmap_p4d_range() error: uninitialized symbol 'err'.

Fix by initailizing err with 0.

Link: https://lkml.kernel.org/r/20251014102337.5453-1-yadong.qi@linux.alibaba.com
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202510110050.VG9YKMRK-lkp@intel.com/
Signed-off-by: Yadong Qi <yadong.qi@linux.alibaba.com>
Cc: Huang Ying <ying.huang@linux.alibaba.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-warn_on-if-mapping-size-is-not-page_size-aligned-fix
+++ a/mm/vmalloc.c
@@ -170,7 +170,7 @@ static int vmap_pmd_range(pud_t *pud, un
 {
 	pmd_t *pmd;
 	unsigned long next;
-	int err;
+	int err = 0;
 
 	pmd = pmd_alloc_track(&init_mm, pud, addr, mask);
 	if (!pmd)
@@ -222,7 +222,7 @@ static int vmap_pud_range(p4d_t *p4d, un
 {
 	pud_t *pud;
 	unsigned long next;
-	int err;
+	int err = 0;
 
 	pud = pud_alloc_track(&init_mm, p4d, addr, mask);
 	if (!pud)
@@ -274,7 +274,7 @@ static int vmap_p4d_range(pgd_t *pgd, un
 {
 	p4d_t *p4d;
 	unsigned long next;
-	int err;
+	int err = 0;
 
 	p4d = p4d_alloc_track(&init_mm, pgd, addr, mask);
 	if (!p4d)
_

Patches currently in -mm which might be from yadong.qi@linux.alibaba.com are

mm-vmalloc-warn_on-if-mapping-size-is-not-page_size-aligned.patch

