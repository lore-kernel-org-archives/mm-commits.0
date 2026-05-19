Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FF61DA0E1
	for <mm-commits@vger.kernel.org>; Tue, 19 May 2026 00:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779150249; cv=none; b=cAN4QegoVvdeIdszz4Nrk5iY5BbhlRc9cRcXPpuVSL2hOD2emZkP3li+XkmEJ4L01NNpyGU2iAe6phmuWfzFYhh66boUNoEvdEIH17GpnrIIOLy1DMokh3hj/99mtj47cRwuYwwru3OChxvlYfz0G3wC1lUSa2hAXAGe3253vXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779150249; c=relaxed/simple;
	bh=taIAyhcIsO6epverlcIcscL7Mf9/Pmk4kuxD7WDIADo=;
	h=Date:To:From:Subject:Message-Id; b=DsLztSeHa7XbDWnFwcCNzixUixvfNiIXTTp8b6yEuLuS48kmpQsujgPDZ1T/kB0gS/0K1wT6ptaIzAUY9nyXiqPigPX7xJAa6MzUR19Bsi4PDKgVqB1a8I+4gX4A4Sz5PwRRjWQwWO9LnOE/3XG4HQp1zDFeFP4y7Y3XJCV8d/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Kq/kMoHI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Kq/kMoHI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8801DC2BCB7;
	Tue, 19 May 2026 00:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779150248;
	bh=taIAyhcIsO6epverlcIcscL7Mf9/Pmk4kuxD7WDIADo=;
	h=Date:To:From:Subject:From;
	b=Kq/kMoHImbKrqjSaotwcVR3/rZ79VdoN2Eybg8OTV8ebyqvNT15b8C0EbBTQ1VnbL
	 rWd/OG73e4mzXho0OsWPKLijBgzIgM9o95y4L9ySKm0Lou4FDTFGGaXYDp1XKhhTXG
	 GySzVCuaxdZpWrs1U/kshZNRjNV88OwbtYwue6qI=
Date: Mon, 18 May 2026 17:24:07 -0700
To: mm-commits@vger.kernel.org,leon@kernel.org,jgg@ziepe.ca,apopple@nvidia.com,liuqiang@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_hmm-fix-error-path-in-dmirror_devmem_fault.patch added to mm-new branch
Message-Id: <20260519002408.8801DC2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/test_hmm: fix error path in dmirror_devmem_fault()
has been added to the -mm mm-new branch.  Its filename is
     lib-test_hmm-fix-error-path-in-dmirror_devmem_fault.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_hmm-fix-error-path-in-dmirror_devmem_fault.patch

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
Subject: lib/test_hmm: fix error path in dmirror_devmem_fault()
Date: Fri, 15 May 2026 15:03:11 +0800

Handle migrate_vma_setup() failure via goto err for unified cleanup.

Link: https://lore.kernel.org/20260515070312.130435-1-liuqiangneo@163.com
Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/lib/test_hmm.c~lib-test_hmm-fix-error-path-in-dmirror_devmem_fault
+++ a/lib/test_hmm.c
@@ -1690,8 +1690,14 @@ static vm_fault_t dmirror_devmem_fault(s
 	if (order)
 		args.flags |= MIGRATE_VMA_SELECT_COMPOUND;
 
-	if (migrate_vma_setup(&args))
-		return VM_FAULT_SIGBUS;
+	/*
+	 * In practice migrate_vma_setup() should never fail unless the
+	 * test is wrong as it just tests some static VMA properties.
+	 */
+	if (migrate_vma_setup(&args)) {
+		ret = VM_FAULT_SIGBUS;
+		goto err;
+	}
 
 	ret = dmirror_devmem_fault_alloc_and_copy(&args, dmirror);
 	if (ret)
_

Patches currently in -mm which might be from liuqiang@kylinos.cn are

lib-test_hmm-check-alloc_page_vma-return-value.patch
lib-test_hmm-fix-error-path-in-dmirror_devmem_fault.patch

