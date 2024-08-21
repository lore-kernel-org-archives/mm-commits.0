Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ADBE53370
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 02:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724206078; cv=none; b=JN6fz6Cpmf0ETbzE4NfDGtjWd1crjtOxsruHjWcJU2erM8Ajbp7EBHIm9CSthrkfhcc3gT2/mbREW520DbNL1lnPxjIJrryMAYIwHjH0SksRIq9pyqTObaiYiDHHIDnRd2W4RLorqZfEsvTl7g9dIaPQfw/MdR0q5oMy8/LyPOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724206078; c=relaxed/simple;
	bh=xXwFJnc6/Je+iDAJU0QV1fRawZCG1Xq70h3WoLBBhOE=;
	h=Date:To:From:Subject:Message-Id; b=UPxYErFHGoEzSjS5+HY+yGl1fG0B6XuLF4QjQVgWf+SqYGDH/t3QZjHJMioplPoV0RWMPBEt8BV9wh1OTaTWQ9HMD+hVT+xsKpExteS83+nt55oVfBElIrqVf6ZkcfovEChbCcCWfq4xOYYaGljYfGuHufk0ZMWQulocRwNk5Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=krvTmUd7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="krvTmUd7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15220C4AF17;
	Wed, 21 Aug 2024 02:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724206078;
	bh=xXwFJnc6/Je+iDAJU0QV1fRawZCG1Xq70h3WoLBBhOE=;
	h=Date:To:From:Subject:From;
	b=krvTmUd7vJCA0i56gTtMbhjU02IwH/I6jFyD1L+WZColoy3QJQZW/gVg5Ho0zrySX
	 Z1p0gMkd3SNEMPMArJP71J2mJbFF0dMRaytARmyLCS1cdfVheCuEUl1fDPmr/LhS40
	 wZOtMgnBRtmHOt8VlPEDXrYt2UlFR0zwQEFZ/sGA=
Date: Tue, 20 Aug 2024 19:07:57 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,shuah@kernel.org,mpe@ellerman.id.au,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,kees@kernel.org,jeffxu@chromium.org,pedro.falcato@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-replace-can_modify_mm-with-can_modify_vma.patch added to mm-unstable branch
Message-Id: <20240821020758.15220C4AF17@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mremap: replace can_modify_mm with can_modify_vma
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mremap-replace-can_modify_mm-with-can_modify_vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-replace-can_modify_mm-with-can_modify_vma.patch

This patch will later appear in the mm-unstable branch at
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
From: Pedro Falcato <pedro.falcato@gmail.com>
Subject: mm/mremap: replace can_modify_mm with can_modify_vma
Date: Sat, 17 Aug 2024 01:18:31 +0100

Delegate all can_modify checks to the proper places.  Unmap checks are
done in do_unmap (et al).  The source VMA check is done purposefully
before unmapping, to keep the original mseal semantics.

Link: https://lkml.kernel.org/r/20240817-mseal-depessimize-v3-4-d8d2e037df30@gmail.com
Signed-off-by: Pedro Falcato <pedro.falcato@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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

selftests-mm-add-mseal-test-for-no-discard-madvise.patch
selftests-mm-add-mseal-test-for-no-discard-madvise-fix.patch
mm-move-can_modify_vma-to-mm-vmah.patch
mm-munmap-replace-can_modify_mm-with-can_modify_vma.patch
mm-mprotect-replace-can_modify_mm-with-can_modify_vma.patch
mm-mremap-replace-can_modify_mm-with-can_modify_vma.patch
mseal-replace-can_modify_mm_madv-with-a-vma-variant.patch
mm-remove-can_modify_mm.patch
selftests-mm-add-more-mseal-traversal-tests.patch

