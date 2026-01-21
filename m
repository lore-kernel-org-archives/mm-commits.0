Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8EC30214D
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967425; cv=none; b=Qv0VqYAiitsL8Nawy4HEKLE9Kjaq8AwohkcoCxAvBSWScddGqzZ9lNe12IavcfA88fga2JCMtgXMcPqRjH3GYd0fgfN6byAVJEWXgZIFU92Z+iyAEodlygfYzluuPhdlWZK5ZJPJSr6G4PCLOP47CUjtlhAFLvDS+q/VEl0YxKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967425; c=relaxed/simple;
	bh=Tr2he0AzldAxBLt56R75ZuJ5BDUX63G3yv6dmv80QFc=;
	h=Date:To:From:Subject:Message-Id; b=fVm1rvkzD0yG13bNnkiCq+jAXjM38Ae2dMWZ/h0bDmcRz/st5Wn5CDOixMwIkGHt9rGivdMRGASIrW1+EoZSX5a/DziYahl+Yv1anbZywYZTsI8fnGMsKfiVqL/YfKcesnZ0P3nPIUuWeMvlT2eGlEV39Jsv9JYuafYb56CDYiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eFMu52Li; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eFMu52Li"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB630C116D0;
	Wed, 21 Jan 2026 03:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967424;
	bh=Tr2he0AzldAxBLt56R75ZuJ5BDUX63G3yv6dmv80QFc=;
	h=Date:To:From:Subject:From;
	b=eFMu52LiJPPoPy6EsS43mIgBq666JvxFrRiv30poUmCgttg27m+rIAgkAtowKp2ee
	 3wPIo8L9kRguoKFiJLVElOpIPBxksvHNC7E0XA60fItlqAtg43KuGFB7TjSrEz36Yy
	 ukru/LBq/VGWonzV+SFQ+0kCMPTC1oey0DHGuH6g=
Date: Tue, 20 Jan 2026 19:50:24 -0800
To: mm-commits@vger.kernel.org,skhawaja@google.com,rppt@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,dmatlack@google.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kho-print-which-scratch-buffer-failed-to-be-reserved.patch removed from -mm tree
Message-Id: <20260121035024.BB630C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: print which scratch buffer failed to be reserved
has been removed from the -mm tree.  Its filename was
     kho-print-which-scratch-buffer-failed-to-be-reserved.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
Subject: kho: print which scratch buffer failed to be reserved
Date: Fri, 16 Jan 2026 16:54:11 +0000

When scratch area fails to reserve, KHO prints a message indicating that. 
But it doesn't say which scratch failed to allocate.  This can be useful
information for debugging.  Even more so when the failure is hard to
reproduce.

Along with the current message, also print which exact scratch area failed
to be reserved.

Link: https://lkml.kernel.org/r/20260116165416.1262531-1-pratyush@kernel.org
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: David Matlack <dmatlack@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-print-which-scratch-buffer-failed-to-be-reserved
+++ a/kernel/liveupdate/kexec_handover.c
@@ -637,8 +637,10 @@ static void __init kho_reserve_scratch(v
 	kho_scratch_cnt = num_online_nodes() + 2;
 	size = kho_scratch_cnt * sizeof(*kho_scratch);
 	kho_scratch = memblock_alloc(size, PAGE_SIZE);
-	if (!kho_scratch)
+	if (!kho_scratch) {
+		pr_err("Failed to reserve scratch array\n");
 		goto err_disable_kho;
+	}
 
 	/*
 	 * reserve scratch area in low memory for lowmem allocations in the
@@ -647,8 +649,10 @@ static void __init kho_reserve_scratch(v
 	size = scratch_size_lowmem;
 	addr = memblock_phys_alloc_range(size, CMA_MIN_ALIGNMENT_BYTES, 0,
 					 ARCH_LOW_ADDRESS_LIMIT);
-	if (!addr)
+	if (!addr) {
+		pr_err("Failed to reserve lowmem scratch buffer\n");
 		goto err_free_scratch_desc;
+	}
 
 	kho_scratch[i].addr = addr;
 	kho_scratch[i].size = size;
@@ -657,8 +661,10 @@ static void __init kho_reserve_scratch(v
 	/* reserve large contiguous area for allocations without nid */
 	size = scratch_size_global;
 	addr = memblock_phys_alloc(size, CMA_MIN_ALIGNMENT_BYTES);
-	if (!addr)
+	if (!addr) {
+		pr_err("Failed to reserve global scratch buffer\n");
 		goto err_free_scratch_areas;
+	}
 
 	kho_scratch[i].addr = addr;
 	kho_scratch[i].size = size;
@@ -669,8 +675,10 @@ static void __init kho_reserve_scratch(v
 		addr = memblock_alloc_range_nid(size, CMA_MIN_ALIGNMENT_BYTES,
 						0, MEMBLOCK_ALLOC_ACCESSIBLE,
 						nid, true);
-		if (!addr)
+		if (!addr) {
+			pr_err("Failed to reserve nid %d scratch buffer\n", nid);
 			goto err_free_scratch_areas;
+		}
 
 		kho_scratch[i].addr = addr;
 		kho_scratch[i].size = size;
_

Patches currently in -mm which might be from pratyush@kernel.org are

kho-use-unsigned-long-for-nr_pages.patch
kho-simplify-page-initialization-in-kho_restore_page.patch

