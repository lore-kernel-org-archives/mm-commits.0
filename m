Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206002572;
	Tue, 12 Nov 2024 01:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731374452; cv=none; b=riipgwAlzI94kr/BHYtuAkqCvqkU6/b2vHg3p1mmlLy9k4MmXwdukl6x8cU6xDaEEJiyUEWJVCgYuFa+coEwSAOHKwLEFogzocP6BaYfXl8AVZBJ5lk02bkSgHRKwfqNG/cUe991Pk/HvalIz1wu0sO26OQALz2SPJoDTBMrauA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731374452; c=relaxed/simple;
	bh=oJfKOO7BPa24+JHvVFM8mhjc1hYpvybLKQbbCJGd4rc=;
	h=Date:To:From:Subject:Message-Id; b=cq1gbyv2tz5trM0aHX5gV5Oj/WNQFfxnqpQKL8X5Ihd6GYBMcs6bDW5MoRiXpYaPzAeDO1xBVDZGIPYBVEyt7bQmARYwUlecfeODwPwt+HnHcDgh4U5Z5sMyykGKefiM0jBmTP6hk9swE0GmAlXbm5z0JXbQzCqblI4WZVZDueY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oRzQZR6z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oRzQZR6z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6990C4CECF;
	Tue, 12 Nov 2024 01:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731374452;
	bh=oJfKOO7BPa24+JHvVFM8mhjc1hYpvybLKQbbCJGd4rc=;
	h=Date:To:From:Subject:From;
	b=oRzQZR6ztE/bY8YL8iu4pM0eNDnSUQJYdQqUwFz37uddG1Mv8C+fGwGgxieipbsQI
	 VNJkzIHlHVWrhbovuwZBhx16r1VAurUSbRRAA8BYN5SboFU9Xkz3iLSqkKZyZmc/9g
	 z9tmMKranlqqXt68AhpI08S9Mt7E0oYeOlY+2G9M=
Date: Mon, 11 Nov 2024 17:20:51 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,Liam.Howlett@Oracle.com,thehajime@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nommu-pass-null-argument-to-vma_iter_prealloc.patch removed from -mm tree
Message-Id: <20241112012051.E6990C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nommu: pass NULL argument to vma_iter_prealloc()
has been removed from the -mm tree.  Its filename was
     nommu-pass-null-argument-to-vma_iter_prealloc.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hajime Tazaki <thehajime@gmail.com>
Subject: nommu: pass NULL argument to vma_iter_prealloc()
Date: Sat, 9 Nov 2024 07:28:34 +0900

When deleting a vma entry from a maple tree, it has to pass NULL to
vma_iter_prealloc() in order to calculate internal state of the tree, but
it passed a wrong argument.  As a result, nommu kernels crashed upon
accessing a vma iterator, such as acct_collect() reading the size of vma
entries after do_munmap().

This commit fixes this issue by passing a right argument to the
preallocation call.

Link: https://lkml.kernel.org/r/20241108222834.3625217-1-thehajime@gmail.com
Fixes: b5df09226450 ("mm: set up vma iterator for vma_iter_prealloc() calls")
Signed-off-by: Hajime Tazaki <thehajime@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/nommu.c~nommu-pass-null-argument-to-vma_iter_prealloc
+++ a/mm/nommu.c
@@ -573,7 +573,7 @@ static int delete_vma_from_mm(struct vm_
 	VMA_ITERATOR(vmi, vma->vm_mm, vma->vm_start);
 
 	vma_iter_config(&vmi, vma->vm_start, vma->vm_end);
-	if (vma_iter_prealloc(&vmi, vma)) {
+	if (vma_iter_prealloc(&vmi, NULL)) {
 		pr_warn("Allocation of vma tree for process %d failed\n",
 		       current->pid);
 		return -ENOMEM;
_

Patches currently in -mm which might be from thehajime@gmail.com are


