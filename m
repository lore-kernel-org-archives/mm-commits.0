Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E638D310;
	Fri, 26 Jan 2024 07:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706255756; cv=none; b=Iec8/TdYq4a7VxklsGrsZ2r904R7qejk05nT+9KFCdLKa1mfqs/rOX2I//80FJRtpuj71MsZlZni/JwvzsSLt0P6+ikRT3PDrW1Kdkt6WB1AJA+m3mqtr3QFRkmE6nsMysiMbW12RsDUHfcJz3MhETWrqici3bt7NtBiDMIlR5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706255756; c=relaxed/simple;
	bh=BjerNLWjsFh3mk3AkNv8qY6cZa/FzwsAh7PiMLhXKBE=;
	h=Date:To:From:Subject:Message-Id; b=q+mVAeyq33bATCU87dKObn9+nfEq28fqrguz7RhbLffphDZxDIbV3G/s9Lvk/AnBibX4FPhUoXvpQBKSluJFu1H9rpNKs77wgDcVuM+gX9sBXcPNw9cjj51ux2Dq0JIR+0GVaBicjbjujhG89K3N4nhZU6MyorOESXs6KIeCuV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=px5es3rZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="px5es3rZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 311C0C433F1;
	Fri, 26 Jan 2024 07:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706255755;
	bh=BjerNLWjsFh3mk3AkNv8qY6cZa/FzwsAh7PiMLhXKBE=;
	h=Date:To:From:Subject:From;
	b=px5es3rZbqdiq+uiqobql6LnYQhCzey9P7H0om9y52nhA/d1sx59UyJiv7wm1PoHU
	 XYe3A1MvDVbw+GL+BddWWcdeGJe++/5CjeI4EfT8MQyOyDzYyYh3ECTLg7PrcX8U23
	 yj7V3v17lGrRIppJMxwS53neywWZl1fliG3yFOaU=
Date: Thu, 25 Jan 2024 23:55:52 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,peterx@redhat.com,ngeoffray@google.com,kaleshsingh@google.com,jannh@google.com,david@redhat.com,bgeffon@google.com,axelrasmussen@google.com,aarcange@redhat.com,lokeshgidra@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] userfaultfd-fix-mmap_changing-checking-in-mfill_atomic_hugetlb.patch removed from -mm tree
Message-Id: <20240126075555.311C0C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfaultfd: fix mmap_changing checking in mfill_atomic_hugetlb
has been removed from the -mm tree.  Its filename was
     userfaultfd-fix-mmap_changing-checking-in-mfill_atomic_hugetlb.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lokesh Gidra <lokeshgidra@google.com>
Subject: userfaultfd: fix mmap_changing checking in mfill_atomic_hugetlb
Date: Wed, 17 Jan 2024 14:37:29 -0800

In mfill_atomic_hugetlb(), mmap_changing isn't being checked
again if we drop mmap_lock and reacquire it. When the lock is not held,
mmap_changing could have been incremented. This is also inconsistent
with the behavior in mfill_atomic().

Link: https://lkml.kernel.org/r/20240117223729.1444522-1-lokeshgidra@google.com
Fixes: df2cc96e77011 ("userfaultfd: prevent non-cooperative events vs mcopy_atomic races") 
Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nicolas Geoffray <ngeoffray@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
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

