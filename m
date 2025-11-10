Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E322E888A
	for <mm-commits@vger.kernel.org>; Mon, 10 Nov 2025 05:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762752047; cv=none; b=Kq1POzo2CQAX9LKhiXwfnjzjXttvzhDAM3oCFPOLCLb1bSZbgY9cIjmVtRY28GXdG/OcjLhUZ5dKoBIVv6ULywSU3HDBOjhUjV9vaPFfGj4I6HADNian0hoX8TNG+AYocIDKo4g7yXRnvnk+8vny4b5Xa4jTfYqtukWdWrR11Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762752047; c=relaxed/simple;
	bh=78/XbFib1HxBWXqnesUIfXMtYdvzEvimVF6HovYBmBg=;
	h=Date:To:From:Subject:Message-Id; b=IcxiOa75DhWMMixwwPIuwIiTzPkiirXU+igevHcy1VaAJh2YapEbtSBS4nhhzMLmPFHEen8t73in8UY6RG5rxn66F1HpQjsdCXuzJp26/C8Sfj6NCAu0UL367lN3c7Z+Xymlq3ferTT9hhj2sR3VUySNoYctAaGxMrsuGbkq11M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SdE5yLsP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SdE5yLsP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D4DC116B1;
	Mon, 10 Nov 2025 05:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762752047;
	bh=78/XbFib1HxBWXqnesUIfXMtYdvzEvimVF6HovYBmBg=;
	h=Date:To:From:Subject:From;
	b=SdE5yLsPQlqVLBMFDrPwb/hx1/05QZ+wrEcpqXy7J1nINP6I59/oAcDmIvdTOvxAj
	 wJC1o3zoyD6FSrFBG5Higq0drTkek8YULO51He3BvNyTnxWE985i+d/nC3PiQmowPg
	 KpLBcLJ3XYN/6xUppHY3fcf7utrCKWYcFGabLJt0=
Date: Sun, 09 Nov 2025 21:20:46 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,bhe@redhat.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kho-fix-unpreservation-of-higher-order-vmalloc-preservations.patch removed from -mm tree
Message-Id: <20251110052047.32D4DC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: fix unpreservation of higher-order vmalloc preservations
has been removed from the -mm tree.  Its filename was
     kho-fix-unpreservation-of-higher-order-vmalloc-preservations.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Fixes: a667300bd53f ("kho: add support for preserving vmalloc allocations")
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
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

maintainers-add-myself-as-a-reviewer-for-kho.patch
liveupdate-luo_file-add-private-argument-to-store-runtime-state.patch

