Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A862EEE68
	for <mm-commits@vger.kernel.org>; Thu,  4 Jun 2026 21:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780609609; cv=none; b=lythw2W5HiZRllYITPqiHQ7qDQoUE+p2QXodSHVDlKrwecwOLcK8DyCwomJiGWbtCNNBzsCfFupIzlBOTGY/Amb/AdC7KUQV9eQAi7RN0lrFKmKk+Zqp4Zf1zbRZRzVMAG8T3DKZ/Rh03HK3pLMPUqeYW6x+M/dM4scfRs4A4QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780609609; c=relaxed/simple;
	bh=5hZRGDWix8izygUC4ZJaNB2ACmOZy11n+uliySO2DbE=;
	h=Date:To:From:Subject:Message-Id; b=Fb4A0IwA/+NcNyvvU6Qv485Q5mnCauexNmckza4jI9S61kbYvhuYZ10Z1O9qvrrFU1lXrz+GEJEAYKN5SHJYxesz24tppMTBZK6Vw59MARB88rgZVoRE1IHsh9jAiIdLKgCjBIqAJHa/4DPQ5JINfK+t38PXjtHK7dwD9UJijqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Rq2dcbhi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Rq2dcbhi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACDD81F00893;
	Thu,  4 Jun 2026 21:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780609607;
	bh=r9bWHxhYquqEFDMUvRoURBR5N8NVd47GUTrbAcveM8Q=;
	h=Date:To:From:Subject;
	b=Rq2dcbhiweD6tjW8kvl1o9I/3jmog9NwuBknRQsU9e+dbWk/uNdIh/r27VJIIJ164
	 PY4N0/bsXOcgD09FD0iP2lvgiVAgzeFYXjWI4LkOXeYdhjToLmYtWxNOQFcCaGoxUX
	 CViDo3FoTgmfQcQpiYs50WlvlCHb7Ee/uJInEsic=
Date: Thu, 04 Jun 2026 14:46:47 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,liuqiang@kylinos.cn,leon@kernel.org,jgg@ziepe.ca,apopple@nvidia.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] lib-test_hmm-check-alloc_page_vma-return-value-and-handle-oom-fix.patch removed from -mm tree
Message-Id: <20260604214647.ACDD81F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib-test_hmm-check-alloc_page_vma-return-value-and-handle-oom-fix
has been removed from the -mm tree.  Its filename was
     lib-test_hmm-check-alloc_page_vma-return-value-and-handle-oom-fix.patch

This patch was dropped because it was folded into lib-test_hmm-check-alloc_page_vma-return-value-and-handle-oom.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-test_hmm-check-alloc_page_vma-return-value-and-handle-oom-fix
Date: Mon Jun  1 05:49:07 PM PDT 2026

fix dmirror_devmem_fault_alloc_and_copy() retval handling

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202606011329.zWs2BKy4-lkp@intel.com/
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Qiang Liu <liuqiang@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/test_hmm.c~lib-test_hmm-check-alloc_page_vma-return-value-and-handle-oom-fix
+++ a/lib/test_hmm.c
@@ -1167,9 +1167,9 @@ static int dmirror_migrate_to_system(str
 			goto out;
 
 		pr_debug("Migrating from device mem to sys mem\n");
-		ret = dmirror_devmem_fault_alloc_and_copy(&args, dmirror);
-		if (ret) {
+		if (dmirror_devmem_fault_alloc_and_copy(&args, dmirror)) {
 			migrate_vma_finalize(&args);
+			ret = -ENOMEM;
 			goto out;
 		}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

lib-test_hmm-check-alloc_page_vma-return-value-and-handle-oom.patch
mm-khugepaged-generalize-collapse_huge_page-for-mthp-collapse-fix-2.patch
sparc-add-_mcount-prototype.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch
security-apparmor-apparmorfsc-conditionally-compile-get_loaddata_common_ref.patch

