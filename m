Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E502348C55
	for <mm-commits@vger.kernel.org>; Thu, 21 May 2026 23:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779404797; cv=none; b=F6F0ds96UbHWLwyuqjq8CS8ylviozKu93XF/BMfGfyJU+7b4b/Muidef2lutKCFq00UvHCgSulWOKDp3udLh6bXQ0cyqAkz2+t8X6cON/DJUPoEUFMxfpxDzTUTh27vKuB9DE+0mzMkfo7j/RUVlEi9cLXdvKRLK/+pMrxZzFys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779404797; c=relaxed/simple;
	bh=+tjsKyWyXgm6zoTO8agvhiFcDSHA0bvGtvpgZ257bH0=;
	h=Date:To:From:Subject:Message-Id; b=vEViYjP5odsYXDxskrJP60oPUXWdpiOw9rAT906d+3d2tDVbL0pA75oR0pvm/qluhP5+zpIAaXquq+FXBrnwN2Un3mWf+E6UU/qWzbM0S58IWCe9HXxWkr/8cjgwkBp3QilnsoFwpOis70+Dh8rvK28Azob0vKmVJ2upeiQw+bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bcgJo6Xv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bcgJo6Xv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20BD1F000E9;
	Thu, 21 May 2026 23:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779404795;
	bh=OpYFyr6uuKTlwdMag0PPz4SuQ6YOZT9SBe3rV57gHjQ=;
	h=Date:To:From:Subject;
	b=bcgJo6XvkuFVaY5u524f9FpBJfOYQmYssbpXJMRi/cINkBcJiEPxSKcORmI+n92Ys
	 xJS1qygnoeW6PBZN9KmNZd7fZDK/YHRsniD6ttyH/O1NG3YSGWjZIOJJXqOdPIttjB
	 Ze219m3jl5y8DYhnj1LFag05VfAn/e/dpaQoTD1s=
Date: Thu, 21 May 2026 16:06:35 -0700
To: mm-commits@vger.kernel.org,leon@kernel.org,jgg@ziepe.ca,apopple@nvidia.com,liuqiang@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_hmm-check-alloc_page_vma-return-value-and-handle-oom.patch added to mm-new branch
Message-Id: <20260521230635.B20BD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/test_hmm: check alloc_page_vma() return value and handle OOM
has been added to the -mm mm-new branch.  Its filename is
     lib-test_hmm-check-alloc_page_vma-return-value-and-handle-oom.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_hmm-check-alloc_page_vma-return-value-and-handle-oom.patch

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
From: Qiang Liu <liuqiang@kylinos.cn>
Subject: lib/test_hmm: check alloc_page_vma() return value and handle OOM
Date: Thu, 21 May 2026 10:18:58 +0800

Check alloc_page_vma() return status for page allocation failures, free
allocated pages and return VM_FAULT_OOM on error.

Handle return codes of dmirror_devmem_fault_alloc_and_copy(), call
migrate_vma_finalize() to remove migration entries from
migrate_vma_setup().

Link: https://lore.kernel.org/20260521021858.21511-1-liuqiangneo@163.com
Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c |   29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

--- a/lib/test_hmm.c~lib-test_hmm-check-alloc_page_vma-return-value-and-handle-oom
+++ a/lib/test_hmm.c
@@ -1063,6 +1063,25 @@ static vm_fault_t dmirror_devmem_fault_a
 			/* Try with smaller pages if large allocation fails */
 			if (!dpage && order) {
 				dpage = alloc_page_vma(GFP_HIGHUSER_MOVABLE, args->vma, addr);
+				if (!dpage) {
+					/* Unlock and free pages already allocated. */
+					while (i > 0) {
+						struct page *fpage;
+
+						fpage = migrate_pfn_to_page(dst[--i]);
+						unlock_page(fpage);
+						__free_page(fpage);
+					}
+					/* Clear remaining dst entries to avoid
+					 * migrate_vma_pages/finalize() using
+					 * uninitialized values.
+					 */
+					while (i < (1 << order)) {
+						dst[i] = 0;
+						i++;
+					}
+					return VM_FAULT_OOM;
+				}
 				lock_page(dpage);
 				dst[i] = migrate_pfn(page_to_pfn(dpage));
 				dst_page = pfn_to_page(page_to_pfn(dpage));
@@ -1148,7 +1167,11 @@ static int dmirror_migrate_to_system(str
 			goto out;
 
 		pr_debug("Migrating from device mem to sys mem\n");
-		dmirror_devmem_fault_alloc_and_copy(&args, dmirror);
+		ret = dmirror_devmem_fault_alloc_and_copy(&args, dmirror);
+		if (ret) {
+			migrate_vma_finalize(&args);
+			goto out;
+		}
 
 		migrate_vma_pages(&args);
 		cmd->cpages += dmirror_successful_migrated_pages(&args);
@@ -1689,8 +1712,10 @@ static vm_fault_t dmirror_devmem_fault(s
 	}
 
 	ret = dmirror_devmem_fault_alloc_and_copy(&args, dmirror);
-	if (ret)
+	if (ret) {
+		migrate_vma_finalize(&args);
 		goto err;
+	}
 	migrate_vma_pages(&args);
 	/*
 	 * No device finalize step is needed since
_

Patches currently in -mm which might be from liuqiang@kylinos.cn are

lib-test_hmm-fix-error-path-in-dmirror_devmem_fault.patch
lib-test_hmm-check-alloc_page_vma-return-value-and-handle-oom.patch

