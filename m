Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795513842;
	b=DTiF0VPyxbYxEZ0rcSZvpJO7QSJr12bP1pPyPSwDJSse8kMwDFzmwbKNpqL0P880H3uE
	 iTh2qv4fNvXGZLsmsMsbyTLYG1/GPVKWbVK21CwmZIVIesRvK2pcAUSEo/O/ENlcfxYD7
	 +9/qp3UNojxSSEgeV3giiTyLAtviahuSEmp3aBkV6+Ailx8CmoYs3tH2lyAh01XsXK9L8
	 ZJbkBpXWZ/b3yw7SZ9Eud+YtvuxLLLnnNFa7bQtFRJk/zicgDQpRluo89KX/9QkS48bht
	 mURJ1aj9YocV1GCzKBOlmDPtP46413Dc1U3zWcyN70sOwoV4zuPSzUtWnK22qzOdPLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795513842;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=2N9vqFRdS7BHpDt2dFjb+fbudP9W7Ms9agH4ALz0www=;
	b=3KwzhBfjIGxwT1hS/GMsX7KdMAnFaY7+7uT4xAGCM9VAmikNHYmG2gK8PwcSMIc9c93r
	 B+czvkudDjBsrDdd7i8/PEHEwRgdHfIqbI/0Im41PYy6YG5jrsrmU8zifxZRuOuS6D2vd
	 gjIvsajOtCqzCfbQPy26NE4FHLc+lxmTB26HK7QxzMS/XYeqPLJtRuv2iyCHLqlja+xD5
	 shYpFXpp2lztzaSkNpztnhWY9z1BJ8okxM5wg/M72U4nFAZS2ex2X85Rb7xF5v0N6s56B
	 3hXzY2HFxDBAAfBd2QM12aWdBq7nju/MluWjFgxxmFcmcUdX5sr1BOtrgTMxrQEHOpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=l+XyvkM9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE68E606A68E
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 09:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=l+XyvkM9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24EE51F000E6;
	Tue, 24 Nov 2026 09:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795513842;
	bh=2N9vqFRdS7BHpDt2dFjb+fbudP9W7Ms9agH4ALz0www=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=l+XyvkM9B9RAC3mfXB3HL1ENvPdHEcDZK8nJGtxitV21RfstVqn4CK5H5mCrypfmx
	 XuydtHHxXNOKYVEamyFJIWraA6vkRtq92DvAc0+wqpVhyR/yjrPEaB7RuV26OT4uK4
	 nqHbuGUK793rDj4UrXVwfurIvtuaXXPHfHxWS+K8=
Date: Tue, 24 Nov 2026 01:50:41 -0800
To: mm-commits@vger.kernel.org,usama.anjum@arm.com,rppt@kernel.org,
	peterx@redhat.com,pankaj.gupta@amd.com,mason@kernel.org,gourry@gourry.net,
	azpijr@gmail.com,1045704958@qq.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261118-dax_uffd-v1-1-d776cca1ae17@kernel.org>
References: <20261118-dax_uffd-v1-1-d776cca1ae17@kernel.org>
Subject: + mm-userfaultfd-reject-dax-mappings.patch added to mm-new branch
Message-Id: <20261124095042.24EE51F000E6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/userfaultfd: reject DAX mappings
has been added to the -mm mm-new branch.  Its filename is
     mm-userfaultfd-reject-dax-mappings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-reject-dax-mappings.patch

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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/userfaultfd: reject DAX mappings
Date: Wed, 18 Nov 2026 11:03:00 +0100

UFFD_FEATURE_WP_ASYNC made DAX mappings eligible for userfaultfd
write-protection, but the DAX fault paths have never fully supported it.

DAX faults use vmf_insert_mixed() and vmf_insert_mixed_mkwrite(), which
treats any non-empty PTE, including uffd-wp markers, as an existing
mapping.  A read fault on an uffd-wp marker therefore returns
VM_FAULT_NOPAGE without replacing the marker, causing the fault to repeat
indefinitely.

PAGEMAP_SCAN can also write-protect a DAX PMD, but the huge DAX
write-fault path can make it writable without clearing its uffd-wp bit,
breaking async write tracking.

Device DAX mappings requiring huge-page alignment and cannot serve PTE
faults after UFFDIO_WRITEPROTECT has split their huge mappings.

So let's just disallow DAX mappings in vma_can_userfault() entirely,
making UFFDIO_REGISTER fail with EINVAL.

Link: https://patch.msgid.link/20261118-dax_uffd-v1-1-d776cca1ae17@kernel.org
Fixes: d61ea1cb0095 ("userfaultfd: UFFD_FEATURE_WP_ASYNC")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Chris Mason <mason@kernel.org>
Reported-by: Jingyi Sun <1045704958@qq.com>
Closes: https://lore.kernel.org/all/tencent_1874C71D4177A1624528043E008DB1A5EF05@qq.com
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>

 mm/userfaultfd.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/userfaultfd.c~mm-userfaultfd-reject-dax-mappings
+++ a/mm/userfaultfd.c
@@ -2156,6 +2156,9 @@ static bool vma_can_userfault(struct vm_
 	/* Only mm-backed memory can have its faults handled by userspace. */
 	if (!vma_is_mm_backed(vma))
 		return false;
+	/* DAX fault handlers do not support uffd-wp. */
+	if (vma_is_dax(vma))
+		return false;
 	/* Core mm may discard droppable memory at any time. */
 	if (vma_test_single_mask(vma, VMA_DROPPABLE))
 		return false;
_

Patches currently in -mm which might be from david@kernel.org are

mm-mprotect-dont-skip-uffd-marker-install-when-racing-with-pte-table-reclaim.patch
mm-khugepaged-free-unused-page-table-when-setting-a-huge-pmd-fails.patch
mm-userfaultfd-prevent-poison-marker-loss.patch
mm-hugetlb-compare-against-persistent-count-when-freeing-lowmem-folios.patch
mm-hugetlb-preserve-reservations-when-shrinking-on-highmem.patch
mm-hugetlb-account-temporary-folios-separately.patch
mm-hugetlb-account-temporary-folios-separately-fix.patch
mm-hugetlb-serialize-page-cache-allocations-with-truncation.patch
mm-hugetlb-serialize-page-cache-allocations-with-truncation-fix.patch
mm-memfd-recheck-the-page-cache-before-allocating-a-hugetlb-folio.patch
mm-hugetlb-count-again-if-the-reserve-map-shrank.patch
mm-hugetlb-account-restored-reservations-before-freeing-folios.patch
mm-hugetlb-delay-anon-folio-rmap-removal-until-after-the-tlb-flush.patch
mm-userfaultfd-reject-dax-mappings.patch

