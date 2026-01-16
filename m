Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBEE338594
	for <mm-commits@vger.kernel.org>; Fri, 16 Jan 2026 17:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768586217; cv=none; b=FJECC3g/F1Hl0JyUPmBz2v7SzjdglF4dy/6BNcDXVPpJxjmmsJ/sik+u0PF+MZkwf7NEvjH185rMfvFEKSKUpUMJs0QcpTlPS54J0E9Z6yXQIDWMjuN895BDITvKbTGaj+Y0uPntaPWkaNg6ubo0VsRR3FHo/W1IbwoglLrE7qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768586217; c=relaxed/simple;
	bh=FqhgiUw4fbz73Rn0shtxbE4vFgL4pb9ANJw6oWY4XnY=;
	h=Date:To:From:Subject:Message-Id; b=U7la4T+vXSgAUrY9nnya3m0SgLqicFuAgblm3Vmjvc+TQ5VTtM+0bstGom9LQkwcr5kPGipbUEkfGFoxjsAD0WCRlmN/SrvLDb2HGsBRDLtiL5c+ONg29MjaqJlnvD3u1NUeZv9xthIrUU8Zqp3LRLmiew+Jv9B+oZYOpv2leu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fcOQXm1z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fcOQXm1z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0148DC116C6;
	Fri, 16 Jan 2026 17:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768586217;
	bh=FqhgiUw4fbz73Rn0shtxbE4vFgL4pb9ANJw6oWY4XnY=;
	h=Date:To:From:Subject:From;
	b=fcOQXm1z5n9ZkAWG0aSOT08tFqtVmFN880dnKXg/JuEEhfdrzY5Jy/UA/yWYLphw5
	 H4KKEkrx8Ry9fpvplPv5THAXKYKiTH0RLJV4K7ComUlHAb8R+natFcy6cwdGiLw4kN
	 bcXqq2wrA1tjX5VqjPrn3oe1wtCkDyrAXd/vKgoY=
Date: Fri, 16 Jan 2026 09:56:56 -0800
To: mm-commits@vger.kernel.org,skhawaja@google.com,rppt@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,dmatlack@google.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-print-which-scratch-buffer-failed-to-be-reserved.patch added to mm-nonmm-unstable branch
Message-Id: <20260116175657.0148DC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: print which scratch buffer failed to be reserved
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-print-which-scratch-buffer-failed-to-be-reserved.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-print-which-scratch-buffer-failed-to-be-reserved.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Alexander Graf <graf@amazon.com>
Cc: David Matlack <dmatlack@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-print-which-scratch-buffer-failed-to-be-reserved
+++ a/kernel/liveupdate/kexec_handover.c
@@ -651,8 +651,10 @@ static void __init kho_reserve_scratch(v
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
@@ -661,8 +663,10 @@ static void __init kho_reserve_scratch(v
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
@@ -671,8 +675,10 @@ static void __init kho_reserve_scratch(v
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
@@ -683,8 +689,10 @@ static void __init kho_reserve_scratch(v
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

kho-simplify-page-initialization-in-kho_restore_page.patch
kho-print-which-scratch-buffer-failed-to-be-reserved.patch

