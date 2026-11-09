Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794246352;
	b=LswOGnLGsm5gRhw/gjIVFj8lH5JC2BYWShGSk/ySfDwMOSRXtnZUcqRYLvelVP95OQBI
	 Owgw14XS7x2687PxDcXHu8XNy0B852qbgSue7hwV8Alld6ipDPNm6R4UlqJACPVOGcf8l
	 kgj1UMYyO8uFThgOmeJaxQ7q0qT1SR1+0j4gnIw34RJnDzav7U1cxFoqg2cK0orS0jvwT
	 v+rLzmBAJ4W3IEv15XRB1rGz6w6kv4q2m0DWoNbtW0rLRTrO1iBSfoltD4HsmRqoBruxC
	 vaXIbkxtQBAv/YbFxx/yjtyjet9UNXM6X2YRbYUNiYuta5+KEZzaI+EvPRLPlt6rsTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794246352;
	h=Received:DKIM-Signature:Date:To:Cc:From:Subject:Message-Id;
	bh=uPSckW132yFmqX9aFe81cvv51iJcJfP2e3T5DkwR5nY=;
	b=Sb1jBWDbRWmy8z8RsA6PvJQoSiHZZBHZymehtnGWAVlCZohI1AFzQSXPYHybcw/MfEPt
	 uxe81U3Bmc0vvSK9TSuNtxtVh+bnoo8G+A1zhk8TbTzaTZ67QsqhhzLMvOYJC9i/RSBxi
	 O56xyYdNVeYgDdXXq69sUmqdbvEz7y7FAWm3mWSsPO0L5jkwkbKc4lTinRewc0k7zsSPa
	 N9sFGlSR9DBjGzH1qD3FzPRqhktF9a3K0saV48tFn9gCXMGYdQoTGt/LQ/DGVyYZvb28W
	 +NTxOY7z/Eczqv0TI6sXF8I4GWzeOFBAAKmRPbSDsus/9KJS7tbWjisTWiIGcPwyatg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=AJMnwxx4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5061B606A326
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 17:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=AJMnwxx4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6ADE1F0089F;
	Mon,  9 Nov 2026 17:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794246352;
	bh=uPSckW132yFmqX9aFe81cvv51iJcJfP2e3T5DkwR5nY=;
	h=Date:To:Cc:From:Subject;
	b=AJMnwxx45sxit2HzTAUeAlgtRyOK43ASvloUiIae0m8uLYZaRDO3RdiK3dHCsnJGp
	 oE06u1M3gvHQsDnIhVeyMHaeBVFAOUIav8OdELH5OGaXO1Db8cO9Lh4GQrUxxQ69TD
	 Vocfe2E50a7I5aKPTtZ1oG1D0r1Pr7iXtka8T5lI=
Date: Mon, 09 Nov 2026 09:45:51 -0800
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org
Cc: David Hildenbrand <david@kernel.org>
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-filemap-convert-fault-and-readahead-logic-to-use-vma_flags_t-fix.patch removed from -mm tree
Message-Id: <20261109174551.E6ADE1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/filemap: cache random-read flag before dropping fault lock
has been removed from the -mm tree.  Its filename was
     mm-filemap-convert-fault-and-readahead-logic-to-use-vma_flags_t-fix.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/filemap: cache random-read flag before dropping fault lock
Date: Thu, 05 Nov 2026 14:52:01 -0800

An unprivileged process racing a file-backed fault against munmap()
can potentially trigger a kernel oops in the forced-THP readahead path.

The conversion of do_sync_mmap_readahead() to vma_flags_t replaced its
saved vm_flags value with accesses through a VMA pointer. The random-read
flag is now tested after maybe_unlock_mmap_for_io() can release the
fault lock. That helper pins the file, not the VMA, so a concurrent
munmap() can free the VMA before the flag test.

Save the random-read flag before releasing the lock. Also remove the
redundant inner VMA declaration in the executable-mapping block.

Link: https://lore.kernel.org/au2_PPpdAMgRJZtX@gremlin
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/r/sashiko-outbox-200257@kernel.org
Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---

 mm/filemap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/filemap.c~mm-filemap-convert-fault-and-readahead-logic-to-use-vma_flags_t-fix
+++ a/mm/filemap.c
@@ -3409,6 +3409,7 @@ static struct file *do_sync_mmap_readahe
 
 	if (force_thp_readahead) {
 		unsigned long folio_nr_pages = 1UL << thp_order;
+		bool random_read = vma_test(vma, VMA_RAND_READ_BIT);
 
 		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
 		ractl._index &= ~(folio_nr_pages - 1);
@@ -3417,7 +3418,7 @@ static struct file *do_sync_mmap_readahe
 		 * Fetch two folios so we get the chance to actually
 		 * readahead, unless we've been told not to.
 		 */
-		if (!vma_test(vma, VMA_RAND_READ_BIT))
+		if (!random_read)
 			ra->size *= 2;
 		ra->async_size = folio_nr_pages;
 		ra->order = thp_order;
@@ -3437,7 +3438,6 @@ static struct file *do_sync_mmap_readahe
 		 * pad that might exist between sections, which would be a waste
 		 * of memory.
 		 */
-		struct vm_area_struct *vma = vmf->vma;
 		const unsigned long start = vma_start_pgoff(vma);
 		const unsigned long end = vma_end_pgoff(vma);
 		unsigned long ra_end;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mempolicy-use-one-node-set-for-interleave-weights.patch
maple_tree-fix-reverse-iterator-state-when-the-root-disappears.patch
shmem-consume-the-reserved-xattr-space-despite-remount.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix.patch
mm-filemap-convert-fault-and-readahead-logic-to-use-vma_flags_t-fix-fix.patch
profile-account-for-partial-proc-profile-reads.patch
profile-simplify-proc-profile-read-layout.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

