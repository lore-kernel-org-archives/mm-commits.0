Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793928453;
	b=oClcgdThynBWlVcXqgPzFmXKx5rpJ3t6v4wb9jWYpHkuLliHAtHRMw1dOsPNUzHDdBMA
	 NXm/nwxYQa2QBthnonJMxAzsxMIGCFokaHYdn++qNMOahjDLR5WG5UTOn4tkFCd2pQVT3
	 nDtRkCSLWOwBwJIwSHWtwidEmwbZqbIiSkJn1RJqTUwChpfkrFWbmnVx9HmKDuVjstK9p
	 3hTCUZHct6qR8X9uIo8Xcr2HxmTSXmWBaUFPVWIOpLqzwZQNiwymx5/zS2vCnXr4piWBC
	 JMW/Y6bA+dVbjL5mUtrWBIFJtbJKhYXb3d50AGIeS5HZlfURcPgMleY72HBGGJH97Sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793928453;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Ggexvz+DRBtx3a3Vl/nT0GwYPhBHbH2HXrv6jdI2Fj8=;
	b=SMvK+woAMRmKJRXV1y05mraqjlR42f2aTnusfT4/JtgV/DUSa7RNnAlMVpLRl0bth14O
	 WkrUBIFom8MJwBU5cs6QVJntKwGh64lTV0DFjxYthVQQzqHJgjDdmiEMbPxjNrOYl/mx7
	 auGYXeHE4tooiRZwLuMR7gRwDDcfvpaGAQ5K/aFnGbQIPviLdbyYIM5OeqXNtqwgItvxH
	 lEkRNllc40NKn2DnFYfiW+r98Uv0p/EyCP5rDQ2ZHsS3Hg97Bw0Yv70Y7Rfp4dBBlcuvl
	 HkT6LjfLvCN+hVjOM0b5WFv8nrfaNc6HeTe8EN3MAjMkS2EZyqNOddFSCrNQWf72x5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=eYN+GB9N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D872606A31B;
	Fri,  6 Nov 2026 01:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=eYN+GB9N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E234C1F0089F;
	Fri,  6 Nov 2026 01:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793928453;
	bh=Ggexvz+DRBtx3a3Vl/nT0GwYPhBHbH2HXrv6jdI2Fj8=;
	h=Date:To:From:Subject;
	b=eYN+GB9NCVGDJg4IFBd+Jr5EjLWAkPTbMmIvnlrvzwhdBlmGvC2csIo+SpByAXDOP
	 hUhsPhQb3tHtVMHfXRt1Qz9s9GjkzJkysIAP4339f773bRsFekvWDT7BSRVSyNEvFL
	 K7V4bDF6VCEZ5STnY0fMlZI0lDCb29sFyfHq5FAU=
Date: Thu, 05 Nov 2026 17:27:32 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,
	sarthak.sharma@arm.com,pfalcato@suse.de,osalvador@suse.de,
	muchun.song@linux.dev,ljs@kernel.org,liam@infradead.org,jannh@google.com,
	david@kernel.org,azpijr@gmail.com,josef@toxicpanda.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-fix-hugetlb-reservation-leak-on-partial-move.patch added to mm-new branch
Message-Id: <20261106012732.E234C1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mremap: fix hugetlb reservation leak on partial move
has been added to the -mm mm-new branch.  Its filename is
     mm-mremap-fix-hugetlb-reservation-leak-on-partial-move.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-fix-hugetlb-reservation-leak-on-partial-move.patch

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
From: Josef Bacik <josef@toxicpanda.com>
Subject: mm/mremap: fix hugetlb reservation leak on partial move
Date: Thu, 05 Nov 2026 14:02:03 +0000

Patch series "mm/mremap: fix accounting on a partial move", v3.


This patch (of 5):

Moving a part of a private hugetlb mapping with mremap() leaks the huge
page reservations of the parts that stay.  They are not returned when the
mapping is unmapped, when the process exits or when the pool is resized.

fixup_hugetlb_reservations() takes the reservation map away from the old
VMA while that VMA still spans its whole range, because the moved part is
only split off by the unmap at the end of the move.  hugetlb_vm_op_close()
then finds no map in the parts that remain and returns nothing for them:

    mmap() of 4 pages, MAP_PRIVATE | MAP_HUGETLB    HugePages_Rsvd: 4
    mremap() of the second page to a new address    HugePages_Rsvd: 4
    munmap() of all of it                           HugePages_Rsvd: 3

The source is unmapped in this case, so the number of VMAs ends up where
it did before and the check against sysctl_max_map_count stays as it is.

Fix by splitting a hugetlb VMA in prep_move_vma() before a part of it is
moved, as commit 597e4b9ab48a ("mm/mremap: fix locked_vm leak by splitting
VMA for MREMAP_DONTUNMAP") does for an mlock()'d VMA.  A backport needs
that commit, which is tagged for stable itself.

Link: https://lore.kernel.org/20261105-b4-mremap-pre-split-v3-0-f8789de76849@toxicpanda.com
Link: https://lore.kernel.org/20261105-b4-mremap-pre-split-v3-1-f8789de76849@toxicpanda.com
Fixes: 550a7d60bd5e ("mm, hugepages: add mremap() support for hugepage backed vma")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: <stable@vger.kernel.org>
---

 mm/mremap.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

--- a/mm/mremap.c~mm-mremap-fix-hugetlb-reservation-leak-on-partial-move
+++ a/mm/mremap.c
@@ -1038,7 +1038,7 @@ static void vrm_stat_account(struct vma_
 }
 
 static bool __check_map_count_against_split(struct mm_struct *mm,
-					    bool pre_split,
+					    bool source_stays,
 					    bool before_unmaps)
 {
 	const int sys_map_count = get_sysctl_max_map_count();
@@ -1092,14 +1092,14 @@ static bool __check_map_count_against_sp
 	 */
 	map_count += 2;
 
-	/* If pre-split, the -1 observed above doesn't apply. */
-	if (pre_split)
+	/* If the split off source stays, the -1 observed above doesn't apply. */
+	if (source_stays)
 		map_count++;
 
 	return map_count <= sys_map_count;
 }
 
-static bool needs_pre_split(struct vma_remap_struct *vrm)
+static bool split_source_stays(struct vma_remap_struct *vrm)
 {
 	/*
 	 * An MREMAP_DONTUNMAP of a mlock()'d VMA needs to unlock the
@@ -1109,11 +1109,23 @@ static bool needs_pre_split(struct vma_r
 		vma_test(vrm->vma, VMA_LOCKED_BIT);
 }
 
+static bool needs_pre_split(struct vma_remap_struct *vrm)
+{
+	/*
+	 * fixup_hugetlb_reservations() takes the reservations away from the
+	 * source VMA.  The parts of it that do not move have to keep theirs.
+	 */
+	if (vma_is_hugetlb(vrm->vma))
+		return true;
+
+	return split_source_stays(vrm);
+}
+
 /* Do we violate the map count limit if we split VMAs when moving the VMA? */
 static bool check_map_count_against_split(struct vma_remap_struct *vrm)
 {
 	return __check_map_count_against_split(current->mm,
-		needs_pre_split(vrm), /*before_unmaps=*/false);
+		split_source_stays(vrm), /*before_unmaps=*/false);
 }
 
 /* Do we violate the map count limit if we split VMAs prior to early unmaps? */
@@ -1162,10 +1174,7 @@ static unsigned long prep_move_vma(struc
 	if (err)
 		return err;
 
-	/*
-	 * To account mlock()'d pages correctly in the MREMAP_DONTUNMAP
-	 * case perform any split ahead of time for an mlock()'d VMA.
-	 */
+	/* Perform any split ahead of time if the source VMA has to be distinct. */
 	if (needs_pre_split(vrm)) {
 		VMA_ITERATOR(vmi, vma->vm_mm, old_addr);
 
_

Patches currently in -mm which might be from josef@toxicpanda.com are

mm-zswap-drop-the-stale-zswap-entry-of-a-zero-folio.patch
mm-swap-account-synchronous-swap-reads-as-memory-stall.patch
mm-mremap-fix-hugetlb-reservation-leak-on-partial-move.patch
selftests-mm-test-a-partial-mremap-of-hugetlb-memory.patch
mm-mremap-reaccount-on-unmap-failure-only-if-accounted.patch
mm-mremap-restore-vma_account_bit-if-the-unmap-fails.patch
selftests-mm-test-mremap-with-an-old-size-of-0.patch
zram-lz4-lz4hc-accept-dictionaries-of-more-than-64-kib.patch

