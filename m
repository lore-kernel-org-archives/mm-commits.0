Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50695B1EC
	for <mm-commits@vger.kernel.org>; Thu, 15 Feb 2024 22:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708036695; cv=none; b=ONVzxHQPYkUG/s32XS0DYP09Itw/4iNLSSCKtztxtuYOVHelL2751NjZQKejIklrXVrSn080vSHZbJbcfV4cD83hmBPAvaOuj7eB5p/q3incSlSCqMM8N9sEZlkHRiJd7G/lJ9hjUAPta5zPYKLyNNBCoC1Oq3KIKruzsGAJrG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708036695; c=relaxed/simple;
	bh=98ZShHs1rJUl08hhv17jw3lgjh4meiNBAGAdsZqX0FA=;
	h=Date:To:From:Subject:Message-Id; b=lnKhV/IU7+PPsS8qjJ9i/pNHiU63EsTi+ohZsQT1mpunzB4Pa74wUs4C3MdK1UxPv2s+a27hAPieBIZYpb/iwsEF0biF/WegCa9wHSIu2QWm06FrnegW9+UAx5uex95Oy7YPr0kf9A4vbBOWamsBGPq0rBalo5l7ymB9r7v/y8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T9egQind; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T9egQind"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3848BC433C7;
	Thu, 15 Feb 2024 22:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708036695;
	bh=98ZShHs1rJUl08hhv17jw3lgjh4meiNBAGAdsZqX0FA=;
	h=Date:To:From:Subject:From;
	b=T9egQindTdNABEIuMjDrC1csO/QTf74F4IMRn6GDYrSe2LSwwyEOVolLTHnOSf8Ad
	 ZFxchUzM/FcdZu8FcbnzPQUNezPbXEZhW6DoT8P2CJY3qkwosGztWevNap9pOiDq6a
	 0RPPDy4gajBOqbP1fitbQ74odimAdFGRzFeRd9a0=
Date: Thu, 15 Feb 2024 14:38:14 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,timmurray@google.com,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,ngeoffray@google.com,Liam.Howlett@oracle.com,kaleshsingh@google.com,jannh@google.com,david@redhat.com,bgeffon@google.com,axelrasmussen@google.com,aarcange@redhat.com,lokeshgidra@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-vma_assert_locked-for-config_per_vma_lock.patch added to mm-unstable branch
Message-Id: <20240215223815.3848BC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add vma_assert_locked() for !CONFIG_PER_VMA_LOCK
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-vma_assert_locked-for-config_per_vma_lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-vma_assert_locked-for-config_per_vma_lock.patch

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
Subject: mm: add vma_assert_locked() for !CONFIG_PER_VMA_LOCK
Date: Thu, 15 Feb 2024 10:27:55 -0800

vma_assert_locked() is needed to replace mmap_assert_locked() once we
start using per-vma locks in userfaultfd operations.

In !CONFIG_PER_VMA_LOCK case when mm is locked, it implies that the given
VMA is locked.

Link: https://lkml.kernel.org/r/20240215182756.3448972-4-lokeshgidra@google.com
Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Nicolas Geoffray <ngeoffray@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tim Murray <timmurray@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/include/linux/mm.h~mm-add-vma_assert_locked-for-config_per_vma_lock
+++ a/include/linux/mm.h
@@ -781,6 +781,11 @@ static inline struct vm_area_struct *loc
 	return NULL;
 }
 
+static inline void vma_assert_locked(struct vm_area_struct *vma)
+{
+	mmap_assert_locked(vma->vm_mm);
+}
+
 static inline void release_fault_lock(struct vm_fault *vmf)
 {
 	mmap_read_unlock(vmf->vma->vm_mm);
_

Patches currently in -mm which might be from lokeshgidra@google.com are

userfaultfd-fix-return-error-if-mmap_changing-is-non-zero-in-move-ioctl.patch
userfaultfd-move-userfaultfd_ctx-struct-to-header-file.patch
userfaultfd-protect-mmap_changing-with-rw_sem-in-userfaulfd_ctx.patch
mm-add-vma_assert_locked-for-config_per_vma_lock.patch
userfaultfd-use-per-vma-locks-in-userfaultfd-operations.patch

