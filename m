Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F6D14F9D6
	for <mm-commits@vger.kernel.org>; Tue,  4 Nov 2025 01:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762219300; cv=none; b=mn+EVmho9dKtAw91hA37akiqLNUZqlWEAipelPuGNHmAa7mrdatsi3NxDW1q4SZ0q4ju9/U8eanzn/2/zZYfTKNBkSTYObMN5+KANTP3nhtoAanCoyNie//xPRulDECuxR5g9dsTjWruVLxZPfsJXoW1KsXd59BYkgJtYVJ1zeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762219300; c=relaxed/simple;
	bh=GzNpdfFNfzOfQgeNd5wuPyKycrA9DpPsmSvZP4xqIkI=;
	h=Date:To:From:Subject:Message-Id; b=U0ee//e2UD9HeU71vdQhNZeToMwH9ktcNGlehkcJ+xA+wyjG3yHwxU/Mhr2kkdE5woMUUnwiuEYhQ3tBshRgFW3QU4uQCJlSS1pwV16dNf/ml/c552CbOn2L1bWffR58Zm3nm6zkoJ5Y8MsoA5TNP9cBnoWquuxW5nqD9D2uUXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VVsGm+nw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VVsGm+nw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4086C4CEE7;
	Tue,  4 Nov 2025 01:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762219299;
	bh=GzNpdfFNfzOfQgeNd5wuPyKycrA9DpPsmSvZP4xqIkI=;
	h=Date:To:From:Subject:From;
	b=VVsGm+nwZT62Ev0Iq+sWcaqXnknkzo9WHU/0PGhKQyRJMYEDimaRKNTzC3C8AMZ+f
	 cIWVun34gQBt+H42rNSQEPclsXLy6QSb3lvzs7HWNIOozZuOSp94tqRgL0AFLFNU62
	 er1wJkOE4wKKfXFIKsxa5Zy1FgswD+bqUK8CUXog=
Date: Mon, 03 Nov 2025 17:21:39 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,bhe@redhat.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-fix-unpreservation-of-higher-order-vmalloc-preservations.patch added to mm-hotfixes-unstable branch
Message-Id: <20251104012139.B4086C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: fix unpreservation of higher-order vmalloc preservations
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kho-fix-unpreservation-of-higher-order-vmalloc-preservations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-fix-unpreservation-of-higher-order-vmalloc-preservations.patch

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
Subject: kho: fix unpreservation of higher-order vmalloc preservations
Date: Mon, 3 Nov 2025 19:02:31 +0100

kho_vmalloc_unpreserve_chunk() calls __kho_unpreserve() with end_pfn as
pfn + 1.  This happens to work for 0-order pages, but leaks higher order
pages.

For example, say order 2 pages back the allocation.  During preservation,
they get preserved in the order 2 bitmaps, but
kho_vmalloc_unpreserve_chunk() would try to unpreserve them from the order
0 bitmaps, which should not have these bits set anyway, leaving the order
2 bitmaps untouched.  This results in the pages being carried over to the
next kernel.  Nothing will free those pages in the next boot, leaking
them.

Fix this by taking the order into account when calculating the end PFN for
__kho_unpreserve().

Link: https://lkml.kernel.org/r/20251103180235.71409-2-pratyush@kernel.org
Fixes: a667300bd53f2 ("kho: add support for preserving vmalloc allocations")
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_handover.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/kernel/kexec_handover.c~kho-fix-unpreservation-of-higher-order-vmalloc-preservations
+++ a/kernel/kexec_handover.c
@@ -882,7 +882,8 @@ err_free:
 	return NULL;
 }
 
-static void kho_vmalloc_unpreserve_chunk(struct kho_vmalloc_chunk *chunk)
+static void kho_vmalloc_unpreserve_chunk(struct kho_vmalloc_chunk *chunk,
+					 unsigned short order)
 {
 	struct kho_mem_track *track = &kho_out.ser.track;
 	unsigned long pfn = PHYS_PFN(virt_to_phys(chunk));
@@ -891,7 +892,7 @@ static void kho_vmalloc_unpreserve_chunk
 
 	for (int i = 0; i < ARRAY_SIZE(chunk->phys) && chunk->phys[i]; i++) {
 		pfn = PHYS_PFN(chunk->phys[i]);
-		__kho_unpreserve(track, pfn, pfn + 1);
+		__kho_unpreserve(track, pfn, pfn + (1 << order));
 	}
 }
 
@@ -902,7 +903,7 @@ static void kho_vmalloc_free_chunks(stru
 	while (chunk) {
 		struct kho_vmalloc_chunk *tmp = chunk;
 
-		kho_vmalloc_unpreserve_chunk(chunk);
+		kho_vmalloc_unpreserve_chunk(chunk, kho_vmalloc->order);
 
 		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
 		free_page((unsigned long)tmp);
_

Patches currently in -mm which might be from pratyush@kernel.org are

kho-fix-out-of-bounds-access-of-vmalloc-chunk.patch
kho-fix-unpreservation-of-higher-order-vmalloc-preservations.patch
kho-warn-and-exit-when-unpreserved-page-wasnt-preserved.patch

