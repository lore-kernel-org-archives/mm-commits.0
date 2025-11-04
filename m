Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64403186284
	for <mm-commits@vger.kernel.org>; Tue,  4 Nov 2025 01:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762219298; cv=none; b=LKmyxyDfcs2IR7PPQ7jnXTXk1vacRjlo45eQVq6Q5K97hoYayrl0MAa4R9uZqWHvQEkDooij82YG1mhRvDjRJgVa0oowwu70tAOY+ZId1Mzi7fsGSQnDDuRs/My40COf5jEH/liakv6KZ5opsrMwhGUuNNXMEy7//2XkymCsHNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762219298; c=relaxed/simple;
	bh=+R5OYr0Xk3IyO14BhhzDGsDN3vXHb0jwT9rVj+PChDc=;
	h=Date:To:From:Subject:Message-Id; b=c2NAshQWMZykD/rkb8EwrSOL25XULQChRtKXdlOkTpc3FlpRooBp0vJOwXMEDzv8kIVxo1UHP/c8C0yxMQJuvq7YtrjD6grEZvErrxNQ0zB4iWUOcuf0kBN3NgdELHBW2rg+bNy4TLTgRba2vXpDDHyb45vWB8csN11LEt1Rl+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IjsjfKLp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IjsjfKLp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7EFFC4CEFD;
	Tue,  4 Nov 2025 01:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762219297;
	bh=+R5OYr0Xk3IyO14BhhzDGsDN3vXHb0jwT9rVj+PChDc=;
	h=Date:To:From:Subject:From;
	b=IjsjfKLpWvLvU0uJLzM6mir25g1Ap6PlJh+nSJwDPZG6nS2EFaIdjRkP+yKhlLi1e
	 CC2J//0Gmfm/RqGaTSiGxai3gRg22QydSbhWlwLf8ALNYmZ8vZrhXgaVWpI/5ZHIRK
	 bQd/V+LN0yQ1CAkKkt8gQkitKtVJRiTHMTL/pZ3s=
Date: Mon, 03 Nov 2025 17:21:37 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,bhe@redhat.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-fix-out-of-bounds-access-of-vmalloc-chunk.patch added to mm-hotfixes-unstable branch
Message-Id: <20251104012137.B7EFFC4CEFD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: fix out-of-bounds access of vmalloc chunk
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kho-fix-out-of-bounds-access-of-vmalloc-chunk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-fix-out-of-bounds-access-of-vmalloc-chunk.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Pratyush Yadav <pratyush@kernel.org>
Subject: kho: fix out-of-bounds access of vmalloc chunk
Date: Mon, 3 Nov 2025 12:01:57 +0100

The list of pages in a vmalloc chunk is NULL-terminated.  So when looping
through the pages in a vmalloc chunk, both kho_restore_vmalloc() and
kho_vmalloc_unpreserve_chunk() rightly make sure to stop when encountering
a NULL page.  But when the chunk is full, the loops do not stop and go
past the bounds of chunk->phys, resulting in out-of-bounds memory access,
and possibly the restoration or unpreservation of an invalid page.

Fix this by making sure the processing of chunk stops at the end of the
array.

Link: https://lkml.kernel.org/r/20251103110159.8399-1-pratyush@kernel.org
Fixes: a667300bd53f2 ("kho: add support for preserving vmalloc allocations")
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_handover.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/kexec_handover.c~kho-fix-out-of-bounds-access-of-vmalloc-chunk
+++ a/kernel/kexec_handover.c
@@ -889,7 +889,7 @@ static void kho_vmalloc_unpreserve_chunk
 
 	__kho_unpreserve(track, pfn, pfn + 1);
 
-	for (int i = 0; chunk->phys[i]; i++) {
+	for (int i = 0; i < ARRAY_SIZE(chunk->phys) && chunk->phys[i]; i++) {
 		pfn = PHYS_PFN(chunk->phys[i]);
 		__kho_unpreserve(track, pfn, pfn + 1);
 	}
@@ -1012,7 +1012,7 @@ void *kho_restore_vmalloc(const struct k
 	while (chunk) {
 		struct page *page;
 
-		for (int i = 0; chunk->phys[i]; i++) {
+		for (int i = 0; i < ARRAY_SIZE(chunk->phys) && chunk->phys[i]; i++) {
 			phys_addr_t phys = chunk->phys[i];
 
 			if (idx + contig_pages > total_pages)
_

Patches currently in -mm which might be from pratyush@kernel.org are

kho-fix-out-of-bounds-access-of-vmalloc-chunk.patch
kho-fix-unpreservation-of-higher-order-vmalloc-preservations.patch
kho-warn-and-exit-when-unpreserved-page-wasnt-preserved.patch

