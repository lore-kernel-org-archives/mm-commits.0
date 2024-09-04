Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8647406F
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423513; cv=none; b=dpmPbweffYNYpmiwijOsJtVrnjrX4Knmes7kwwLhugSlCrDyycd/m3PIuToleQW1avLM1mBeuuixM2Begnzji70EK5XN4hkm3BnBbp3IogwdW645j1m8NKFWu5XYTjeLmlR8EBlBktZDocfmQDeX3CGf3sS8NA2fgpRyIk0xz4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423513; c=relaxed/simple;
	bh=3ctbMDHXACKudujduTA5gPYYraRy5cAM4NDd18ja9FI=;
	h=Date:To:From:Subject:Message-Id; b=tA24Fby0r5CPb8xmjxYKQrY7cVngaiYkxZytZaNqm8jK6Hti8YZXV2o/FM0upquwFfd47LDDWyRC1ArxPtUNylocNFvupolBVjAFG3dF8meFbUzDuU45Ql5JBOwk1w7uILlt8wLN2QXKUot1xczLUnexfcJ8W3vfacJkNTFnAPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=heWRqQKq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="heWRqQKq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6EC0C4CEC2;
	Wed,  4 Sep 2024 04:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423512;
	bh=3ctbMDHXACKudujduTA5gPYYraRy5cAM4NDd18ja9FI=;
	h=Date:To:From:Subject:From;
	b=heWRqQKqTlhFHW1gcrhOCCS8Z3/7uM085kRe2/tAIgPr+UOOwlpe83BvzCKHVc8Ow
	 wJ6l0pUW5qFC4oNIkHG3IB4RKvxFprRwHwegI8zRdTrJkH20zc7Go3mxkZp/T7GeXj
	 yiT5bkI+bpNAwH1WNzWGV4I9nszAw3s13p9nuyX4=
Date: Tue, 03 Sep 2024 21:18:32 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,shuah@kernel.org,mpe@ellerman.id.au,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,kees@kernel.org,jeffxu@chromium.org,pedro.falcato@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mremap-replace-can_modify_mm-with-can_modify_vma.patch removed from -mm tree
Message-Id: <20240904041832.D6EC0C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mremap: replace can_modify_mm with can_modify_vma
has been removed from the -mm tree.  Its filename was
     mm-mremap-replace-can_modify_mm-with-can_modify_vma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pedro Falcato <pedro.falcato@gmail.com>
Subject: mm/mremap: replace can_modify_mm with can_modify_vma
Date: Sat, 17 Aug 2024 01:18:31 +0100

Delegate all can_modify checks to the proper places.  Unmap checks are
done in do_unmap (et al).  The source VMA check is done purposefully
before unmapping, to keep the original mseal semantics.

Link: https://lkml.kernel.org/r/20240817-mseal-depessimize-v3-4-d8d2e037df30@gmail.com
Signed-off-by: Pedro Falcato <pedro.falcato@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   32 ++++++--------------------------
 1 file changed, 6 insertions(+), 26 deletions(-)

--- a/mm/mremap.c~mm-mremap-replace-can_modify_mm-with-can_modify_vma
+++ a/mm/mremap.c
@@ -902,19 +902,6 @@ static unsigned long mremap_to(unsigned
 	if ((mm->map_count + 2) >= sysctl_max_map_count - 3)
 		return -ENOMEM;
 
-	/*
-	 * In mremap_to().
-	 * Move a VMA to another location, check if src addr is sealed.
-	 *
-	 * Place can_modify_mm here because mremap_to()
-	 * does its own checking for address range, and we only
-	 * check the sealing after passing those checks.
-	 *
-	 * can_modify_mm assumes we have acquired the lock on MM.
-	 */
-	if (unlikely(!can_modify_mm(mm, addr, addr + old_len)))
-		return -EPERM;
-
 	if (flags & MREMAP_FIXED) {
 		/*
 		 * In mremap_to().
@@ -1052,6 +1039,12 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 		goto out;
 	}
 
+	/* Don't allow remapping vmas when they have already been sealed */
+	if (!can_modify_vma(vma)) {
+		ret = -EPERM;
+		goto out;
+	}
+
 	if (is_vm_hugetlb_page(vma)) {
 		struct hstate *h __maybe_unused = hstate_vma(vma);
 
@@ -1079,19 +1072,6 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 		goto out;
 	}
 
-	/*
-	 * Below is shrink/expand case (not mremap_to())
-	 * Check if src address is sealed, if so, reject.
-	 * In other words, prevent shrinking or expanding a sealed VMA.
-	 *
-	 * Place can_modify_mm here so we can keep the logic related to
-	 * shrink/expand together.
-	 */
-	if (unlikely(!can_modify_mm(mm, addr, addr + old_len))) {
-		ret = -EPERM;
-		goto out;
-	}
-
 	/*
 	 * Always allow a shrinking remap: that just unmaps
 	 * the unnecessary pages..
_

Patches currently in -mm which might be from pedro.falcato@gmail.com are


