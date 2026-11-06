Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793980797;
	b=34A/N8trMsXEn53O4OijKaWe+Gdpn9OdzbG8p9E6HVP1IHkiJkNxIRKG90vZCpp3nnYi
	 LFvAxvS0hNOdCJAOdrr19Cq2h1BrF2N9useVzhlwWr2pfc6lATFzwYHpudGEnE+/Hl4bA
	 7GllRU0LSz3cr1MRRlj/cY1LLFsaGFOOos6LJqqg1PGXSPnA9fLIAF6pgtW0v9pAVy0Cc
	 7sWQmkRon8HbJrX3MxtRgHwqLSJiETbL9k54oLqz81iLAIkoVbILxtnLlLPJYpaEc6N6s
	 G5VXvobEoo35MsLjMKD2IZoeoPijVC1A210ArgdBPCZt0Q92HAY+c695ky35dPSQefg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793980797;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=eMEJ9SREcRD1R8e1DNCPLSbqp99GVSSd2HggQ6Dzkw8=;
	b=z7ML1AMQIQxYBpDL+4ahaFF3NaPBwoMw+VWdwpZXo2GyzfNgDRx1VZDSq6CisB0wmDYE
	 oWFnBfz5e7WD1oIH48shP23uuXNYxBTygsTnR84ZzIXZEHeCnUk5YWPSPF9tAMEEYYnzJ
	 RM2djOR2SbOpvYZ3Fh8HYrHGDZlhlyS/xz7HQqCYr/I5e9NEX+NsAxBHYlGN0XTgzFcmK
	 DY5DBcrtbSF3epZAhga1KH50P3KiIr8oFPvrP+3BE3jDKkp0+cSO3RibFVzGJQw/xeuko
	 aUJWzUsSS9V0gxpvKCoCNFLd3/8BtO1T4Y/uPLdpeDBnxm5gZeMKwycnn+h4N9bkzVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="0/5TQtkw";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D23606A326
	for <mm-commits@vger.kernel.org>; Fri,  6 Nov 2026 15:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=0/5TQtkw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986651F008A1;
	Fri,  6 Nov 2026 15:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793980796;
	bh=eMEJ9SREcRD1R8e1DNCPLSbqp99GVSSd2HggQ6Dzkw8=;
	h=Date:To:From:Subject;
	b=0/5TQtkwSg+0d1rDOldYdDFf9tZMbrZKn/3D4qglLvV3tJ7r6gCAja/lZtQt8GHZ6
	 q4ZJE/O1X2GoWwpQ51Ypc8OnommolLiZlEMm/Kr0FJTz+nxiZrop5vwvv461XuXc8e
	 JAXFgrz5CGeWjmmfa5qDgl+jHsSMgR9LxuZnBQAM=
Date: Fri, 06 Nov 2026 07:59:56 -0800
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-convert-fault-and-readahead-logic-to-use-vma_flags_t-fix-fix.patch added to mm-new branch
Message-Id: <20261106155956.986651F008A1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm-filemap-convert-fault-and-readahead-logic-to-use-vma_flags_t-fix-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-filemap-convert-fault-and-readahead-logic-to-use-vma_flags_t-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-convert-fault-and-readahead-logic-to-use-vma_flags_t-fix-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-filemap-convert-fault-and-readahead-logic-to-use-vma_flags_t-fix-fix
Date: Fri Nov  6 07:58:08 AM PST 2026

make random_read const, per Lorenzo

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c~mm-filemap-convert-fault-and-readahead-logic-to-use-vma_flags_t-fix-fix
+++ a/mm/filemap.c
@@ -3410,7 +3410,7 @@ static struct file *do_sync_mmap_readahe
 
 	if (force_thp_readahead) {
 		unsigned long folio_nr_pages = 1UL << thp_order;
-		bool random_read = vma_test(vma, VMA_RAND_READ_BIT);
+		const bool random_read = vma_test(vma, VMA_RAND_READ_BIT);
 
 		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
 		ractl._index &= ~(folio_nr_pages - 1);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mempolicy-use-one-node-set-for-interleave-weights.patch
maple_tree-fix-reverse-iterator-state-when-the-root-disappears.patch
shmem-consume-the-reserved-xattr-space-despite-remount.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix.patch
mm-filemap-convert-fault-and-readahead-logic-to-use-vma_flags_t-fix.patch
mm-filemap-convert-fault-and-readahead-logic-to-use-vma_flags_t-fix-fix.patch
selftests-mm-test-fork-of-pmd-mapped-shmem-thps-fix.patch
iommufd-enforce-memfd-write-seals-for-file-mappings.patch
profile-account-for-partial-proc-profile-reads.patch
profile-simplify-proc-profile-read-layout.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

