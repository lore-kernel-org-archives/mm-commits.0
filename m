Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9784A36E496
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 21:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769896706; cv=none; b=XNjCjWIhRiFSnpBN1aBu8M30ypY1rK89gzwsbnzIYanYGjyKnc1PMvJKHk0QBMuqRfJ4UQkYWYZrEInni8sfQfziUdwANEiXO7khdxXN6NDMeYQAHBmk2hfBglmCVtcmVBajj1RJ4Wbb78HHonoTK5Ecoki7fsMILRnNNa+9jVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769896706; c=relaxed/simple;
	bh=3AGt1FizqIkHRMZGqPIOjx+5/gbu9yQE3qMcJgpS0n0=;
	h=Date:To:From:Subject:Message-Id; b=nBm0qtuzQpoaRXobyEwrE92bIxnWZKXEB0UVYEW7KFsgkAdetm/n8a13g+Ohxo2VUb0a/4LyFNtcxAfadnkoOk41i5Sh9Jyl4xNRj6a+0x12AlG+Y5gA/69If8JM78zTD/Qh24unikt+jC+xPgpYbTCMNao2BjVHdV5UlKC6LMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OeQIVY8V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OeQIVY8V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DE00C4CEF1;
	Sat, 31 Jan 2026 21:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769896706;
	bh=3AGt1FizqIkHRMZGqPIOjx+5/gbu9yQE3qMcJgpS0n0=;
	h=Date:To:From:Subject:From;
	b=OeQIVY8VOOtRn8FvavwJU2WfcKZS//7bXFZaNOEEGxOuBknJfQWeHmW9wb/CeBgQK
	 oK4itLEKvyj4g7WCWVGuJc7+dxNH8qImMdbR07imy+USJHeFT8MAXZh8C2ET01Xd6T
	 ecv8QCnHlsf2zhlmfbcd9Wd6oMPBnZlbwChYF544=
Date: Sat, 31 Jan 2026 13:58:25 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,yi1.lai@linux.intel.com,rafael@kernel.org,nphamcs@gmail.com,kasong@tencent.com,kartikey406@gmail.com,hannes@cmpxchg.org,clm@meta.com,clm@fb.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,ryncsn@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-swap-cleanup-swap-entry-management-workflow-fix-2.patch removed from -mm tree
Message-Id: <20260131215826.1DE00C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-swap-cleanup-swap-entry-management-workflow-fix-2
has been removed from the -mm tree.  Its filename was
     mm-swap-cleanup-swap-entry-management-workflow-fix-2.patch

This patch was dropped because it was folded into mm-swap-cleanup-swap-entry-management-workflow.patch

------------------------------------------------------
From: Kairui Song <ryncsn@gmail.com>
Subject: mm-swap-cleanup-swap-entry-management-workflow-fix-2
Date: Sat, 31 Jan 2026 00:48:07 +0800

fix KSM copy pages for swapoff, per Chris

Link: https://lkml.kernel.org/r/aXxkANcET3l2Xu6J@KASONG-MC4
Signed-off-by: Kairui Song <ryncsn@gmail.com>
Cc: Chris Mason <clm@meta.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lai Yi <yi1.lai@linux.intel.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swap-cleanup-swap-entry-management-workflow-fix-2
+++ a/mm/swapfile.c
@@ -2305,7 +2305,7 @@ static int unuse_pte(struct vm_area_stru
 		new_pte = pte_mkuffd_wp(new_pte);
 setpte:
 	set_pte_at(vma->vm_mm, addr, pte, new_pte);
-	folio_put_swap(folio, page);
+	folio_put_swap(swapcache, folio_file_page(swapcache, swp_offset(entry)));
 out:
 	if (pte)
 		pte_unmap_unlock(pte, ptl);
_

Patches currently in -mm which might be from ryncsn@gmail.com are

mm-swap-cleanup-swap-entry-management-workflow.patch

