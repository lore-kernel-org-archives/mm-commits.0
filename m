Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0702E6CD8
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 02:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769482670; cv=none; b=iXiXREz/b3vL9hTluK9gw2QEtQ3lhsObEKhGJ5DpJn/7Amm+VVynytY2iM2DDO7PEQfO7oS03qyPL+tPcezWbXhOBRV/dZ0Fi7ROxfpIa1HVky1lng96caPsMrYXW1Kwr5JYBzWlDVtnkp4eQH3hqDhZqoa0g+TzyKYCMgekca8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769482670; c=relaxed/simple;
	bh=qjZcqc19Hesf4IumXBjfdC3zu0M0wCGkO9hXLjN4QVw=;
	h=Date:To:From:Subject:Message-Id; b=dgJ5CQpfkZ0wCCxRN8C2mRs59ECcL6G0SYM8fa5UghJGKnp+nyXDfWebh64cARgVqyI/Ncc9xKBIlgZtVx2h+OZ6BwHnCj0XHab/vqZc25YOOa85JRdfsxTaqiEpnPWUnEx1qZAd2ni+KQY3yE12u4Da6AnCvqekKIUQ6ed9NE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IfN8AWaD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IfN8AWaD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CBF8C116C6;
	Tue, 27 Jan 2026 02:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769482669;
	bh=qjZcqc19Hesf4IumXBjfdC3zu0M0wCGkO9hXLjN4QVw=;
	h=Date:To:From:Subject:From;
	b=IfN8AWaDqGQ0pJEh31t+NI5qD4D3eLrFj+Y6Nv2cGttHrru0wibvzY+BwQS7OeO3I
	 PRjQh5GODF4/Xf6ww+SgzxA+MFWCoHxH0iWCjwJxsTP3wBuQSsg18r6qzwiLag5pAu
	 47wMx+m+w4F6T7RM1pMUyk/KEgtLsranGzLTFf+8=
Date: Mon, 26 Jan 2026 18:57:49 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,lkp@intel.com,jgg@nvidia.com,graf@amazon.com,dan.carpenter@linaro.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kho-kho_preserve_vmalloc-dont-return-0-when-enomem.patch removed from -mm tree
Message-Id: <20260127025749.8CBF8C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: kho_preserve_vmalloc(): don't return 0 when ENOMEM
has been removed from the -mm tree.  Its filename was
     kho-kho_preserve_vmalloc-dont-return-0-when-enomem.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kho: kho_preserve_vmalloc(): don't return 0 when ENOMEM
Date: Wed Jan 21 12:36:17 PM PST 2026

kho_preserve_vmalloc() should return -ENOMEM when new_vmalloc_chunk()
fails.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202601211636.IRaejjdw-lkp@intel.com/
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-kho_preserve_vmalloc-dont-return-0-when-enomem
+++ a/kernel/liveupdate/kexec_handover.c
@@ -1014,8 +1014,10 @@ int kho_preserve_vmalloc(void *ptr, stru
 		chunk->phys[idx++] = phys;
 		if (idx == ARRAY_SIZE(chunk->phys)) {
 			chunk = new_vmalloc_chunk(chunk);
-			if (!chunk)
+			if (!chunk) {
+				err = -ENOMEM;
 				goto err_free;
+			}
 			idx = 0;
 		}
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix-fix.patch
mm-relocate-the-page-table-ceiling-and-floor-definitions-fix.patch
mm-add-wq_percpu-to-alloc_workqueue-users-fix.patch
mm-add-wq_percpu-to-alloc_workqueue-users-fix-fix.patch
sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests-fix.patch
mm-vma-document-possible-vma-vm_refcnt-values-and-reference-comment-fix.patch
mm-vma-introduce-helper-struct-thread-through-exclusive-lock-fns-fix.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch
mm-pagewalk-use-min-to-simplify-the-code-fix.patch

