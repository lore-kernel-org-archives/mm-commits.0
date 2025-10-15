Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD331A2547
	for <mm-commits@vger.kernel.org>; Wed, 15 Oct 2025 01:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760492220; cv=none; b=L1FvFje50DUBHDUwcFl1PcCXZkJUzEB9kPlLTZZ9/Qx+MhZ5O5bL30nSPwFECzM2pGx0+LgAPZTnTlKDi6A+BiX8ccCS0xPObRmyC6BPuoUIFPM4dmLuyPmolp2TTBPRNE5WuhP4V1ewoFEn/HkvqeYGsiDTJfYMh3yEIIRdzjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760492220; c=relaxed/simple;
	bh=++PDgqDYYnJTLeS8gs4lbVkOEbucbuvNMWdfgzrXKmA=;
	h=Date:To:From:Subject:Message-Id; b=UMvu1l8XakoLLf8EzWWEFxu0ZMdAGGnCKZ2ex83s76pTFESJDwi3xPEnvfd8Es4qz6NOvw7/cAKrNmyyAzLIpI4P5t+nwDON1JZoKTSE+jEUGB265rGJTKJzm8odyXmyMdtU80GfF3jw1RPM32/+UmMm1tIoWLMrdJ62toVPo6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bhqYUftL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bhqYUftL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 550F3C4CEE7;
	Wed, 15 Oct 2025 01:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760492219;
	bh=++PDgqDYYnJTLeS8gs4lbVkOEbucbuvNMWdfgzrXKmA=;
	h=Date:To:From:Subject:From;
	b=bhqYUftLn4SRZ4PcFxFzSWTDkqmssZ85/nBRV/+gBjebe8nke9SkXMXfXwhowD90o
	 vfX3GJU/R5yp7cQ/AwoGCEtw1799Y4pcuXQtin28DMhMCIsKDi/s7+82UmGTAVqCEy
	 uI+NOpH8HrzsCojRCgZKKPcpeF4gmjv3xdxRJEgQ=
Date: Tue, 14 Oct 2025 18:36:58 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,sidhartha.kumar@oracle.com,ryan.roberts@arm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mprotect-always-skip-dma-pinned-folio-in-prot_numa_skip.patch added to mm-new branch
Message-Id: <20251015013659.550F3C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: mprotect: always skip dma pinned folio in prot_numa_skip()
has been added to the -mm mm-new branch.  Its filename is
     mm-mprotect-always-skip-dma-pinned-folio-in-prot_numa_skip.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mprotect-always-skip-dma-pinned-folio-in-prot_numa_skip.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: mprotect: always skip dma pinned folio in prot_numa_skip()
Date: Tue, 14 Oct 2025 19:33:47 +0800

Patch series "mm: some optimizations for prot numa", v2.


This patch (of 3):

If the folio(even not CoW folio) is dma pinned, it can't be migrated, so
always skip pinned folio to avoid a waste of cycles when folios migration.

Link: https://lkml.kernel.org/r/20251014113349.2618158-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20251014113349.2618158-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/mprotect.c~mm-mprotect-always-skip-dma-pinned-folio-in-prot_numa_skip
+++ a/mm/mprotect.c
@@ -136,9 +136,12 @@ static bool prot_numa_skip(struct vm_are
 	if (folio_is_zone_device(folio) || folio_test_ksm(folio))
 		goto skip;
 
-	/* Also skip shared copy-on-write pages */
-	if (is_cow_mapping(vma->vm_flags) &&
-	    (folio_maybe_dma_pinned(folio) || folio_maybe_mapped_shared(folio)))
+	/* Also skip shared copy-on-write folios */
+	if (is_cow_mapping(vma->vm_flags) && folio_maybe_mapped_shared(folio))
+		goto skip;
+
+	/* Folios are pinned and can't be migrated */
+	if (folio_maybe_dma_pinned(folio))
 		goto skip;
 
 	/*
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-mprotect-always-skip-dma-pinned-folio-in-prot_numa_skip.patch
mm-mprotect-avoid-unnecessary-struct-page-accessing-if-pte_protnone.patch
mm-huge_memory-use-folio_skip_prot_numa-for-pmd-folio.patch

