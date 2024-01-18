Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80ADF1E486
	for <mm-commits@vger.kernel.org>; Thu, 18 Jan 2024 22:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705616180; cv=none; b=ZVMaNr/V+jX1SJoFPNE8yjEvPA48qiJnOk4y9PkXeFxPOtFeuj4xcRtmtN1Yg8ck3/gI/Epo9l6OJm/6dPjF/uCWyp7Q2HJZxcZCZ29ShKSxN8CWg9uzw+yjKqQqgwlV4N/Kb4AS5n3qTq7pCwtKOGM+hjlG/jgLa4P3MFbVtj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705616180; c=relaxed/simple;
	bh=A3Snl3zRADFt1HK2Rf/ZgPsxgh8RX4oGawQE94z14R8=;
	h=Date:To:From:Subject:Message-Id; b=oHEPhFNlgg6/gcewhYN8KO7NI0yI8rhrptWEwOes2m+f6SKcGffuUP0RvbxRAb1Q0IeE4vQkPbFe4ue+2QCxKBcr1hxZBqrPbUm8ZbwAx+NeNtAAnMxK2/rFMVAkaBLEpm6A4szzEjU2/hZZUnjRnbingSDYBjQncbvGxcx7Bn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1CmVbOyA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1CmVbOyA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D19DC433C7;
	Thu, 18 Jan 2024 22:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705616180;
	bh=A3Snl3zRADFt1HK2Rf/ZgPsxgh8RX4oGawQE94z14R8=;
	h=Date:To:From:Subject:From;
	b=1CmVbOyAGmU98PhJsFf3E6vFFerJMh4SfBz4SLY4nCBFiLuv71pfrfb987UFzuLr0
	 RU/s/LbiDolGtVTpm/IzRaAdNy9VKC1LO9l/BT2xZ8VlMVLeY7M+nesPN8rmhMFhJQ
	 SIrZ2ger2RPX0M4C+HDb1s83qcb7oJmuMZ0MDTAg=
Date: Thu, 18 Jan 2024 14:16:17 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,peterx@redhat.com,ngeoffray@google.com,kaleshsingh@google.com,jannh@google.com,david@redhat.com,bgeffon@google.com,axelrasmussen@google.com,aarcange@redhat.com,lokeshgidra@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-fix-mmap_changing-checking-in-mfill_atomic_hugetlb.patch added to mm-unstable branch
Message-Id: <20240118221619.9D19DC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd: fix mmap_changing checking in mfill_atomic_hugetlb
has been added to the -mm mm-unstable branch.  Its filename is
     userfaultfd-fix-mmap_changing-checking-in-mfill_atomic_hugetlb.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-fix-mmap_changing-checking-in-mfill_atomic_hugetlb.patch

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
From: Lokesh Gidra <lokeshgidra@google.com>
Subject: userfaultfd: fix mmap_changing checking in mfill_atomic_hugetlb
Date: Wed, 17 Jan 2024 14:37:29 -0800

In mfill_atomic_hugetlb(), mmap_changing isn't being checked
again if we drop mmap_lock and reacquire it. When the lock is not held,
mmap_changing could have been incremented. This is also inconsistent
with the behavior in mfill_atomic().

Link: https://lkml.kernel.org/r/20240117223729.1444522-1-lokeshgidra@google.com
Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nicolas Geoffray <ngeoffray@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/mm/userfaultfd.c~userfaultfd-fix-mmap_changing-checking-in-mfill_atomic_hugetlb
+++ a/mm/userfaultfd.c
@@ -357,6 +357,7 @@ static __always_inline ssize_t mfill_ato
 					      unsigned long dst_start,
 					      unsigned long src_start,
 					      unsigned long len,
+					      atomic_t *mmap_changing,
 					      uffd_flags_t flags)
 {
 	struct mm_struct *dst_mm = dst_vma->vm_mm;
@@ -472,6 +473,15 @@ retry:
 				goto out;
 			}
 			mmap_read_lock(dst_mm);
+			/*
+			 * If memory mappings are changing because of non-cooperative
+			 * operation (e.g. mremap) running in parallel, bail out and
+			 * request the user to retry later
+			 */
+			if (mmap_changing && atomic_read(mmap_changing)) {
+				err = -EAGAIN;
+				break;
+			}
 
 			dst_vma = NULL;
 			goto retry;
@@ -506,6 +516,7 @@ extern ssize_t mfill_atomic_hugetlb(stru
 				    unsigned long dst_start,
 				    unsigned long src_start,
 				    unsigned long len,
+				    atomic_t *mmap_changing,
 				    uffd_flags_t flags);
 #endif /* CONFIG_HUGETLB_PAGE */
 
@@ -622,8 +633,8 @@ retry:
 	 * If this is a HUGETLB vma, pass off to appropriate routine
 	 */
 	if (is_vm_hugetlb_page(dst_vma))
-		return  mfill_atomic_hugetlb(dst_vma, dst_start,
-					     src_start, len, flags);
+		return  mfill_atomic_hugetlb(dst_vma, dst_start, src_start,
+					     len, mmap_changing, flags);
 
 	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
 		goto out_unlock;
_

Patches currently in -mm which might be from lokeshgidra@google.com are

userfaultfd-fix-return-error-if-mmap_changing-is-non-zero-in-move-ioctl.patch
userfaultfd-fix-mmap_changing-checking-in-mfill_atomic_hugetlb.patch

