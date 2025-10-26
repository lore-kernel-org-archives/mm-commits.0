Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B901DFDAB
	for <mm-commits@vger.kernel.org>; Sun, 26 Oct 2025 04:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761452694; cv=none; b=kIrpl60+A5wv3XiYFSV8d+nDyqVoXAeJSI059Az4vrH+/aOC+h5oc0IYIYf5UxyQPE6KSpnckKa9osUHYN/DBVtofpt/iY8J1xbhDT94ky8+Km7JZ9E4yFmHppeXzaymmTcEHPPp6EKSjpBDDSUEvYlWTcV1GV1ViydeLC68d/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761452694; c=relaxed/simple;
	bh=c15xncAuOkoswJc3NRLiwmZBeWm1+BnbbjRYyzn/cSk=;
	h=Date:To:From:Subject:Message-Id; b=YqeFLpm5vDdIMTA7YoPaRsjiQ4FUo9DzLt+EZuwfysxesGJ4X7r8IlfJTRDiYPCb/pUzR0/HJeuHy8kXzsY65yy6c4lJuzg27K89GYyafqbjCLRUo9KggPfYYQylQABhZH3wU1jEkMG4KL6PlWD+9hbH66U7Cws6yb2tyMcoViA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nKJy39dM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nKJy39dM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51814C4CEE7;
	Sun, 26 Oct 2025 04:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761452694;
	bh=c15xncAuOkoswJc3NRLiwmZBeWm1+BnbbjRYyzn/cSk=;
	h=Date:To:From:Subject:From;
	b=nKJy39dMtNnx8OFTtPxeZRsBL84sEHB7hkzbbZxMk+XGo4uXdKPgvAGLQq57OOyBJ
	 j05ITWOmYvRshahRLD19feDKZCT14m92fWEu9nSp+avDSxlyxd5EucbCFQsZAOtS6+
	 OV+A8CCFzMe7zPUc9HCUX/GwuLlHRtq9cEaHZ3Qo=
Date: Sat, 25 Oct 2025 21:24:53 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,liam.howlett@oracle.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-small-vma-lock-cleanups.patch added to mm-new branch
Message-Id: <20251026042454.51814C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: small VMA lock cleanups
has been added to the -mm mm-new branch.  Its filename is
     mm-vma-small-vma-lock-cleanups.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-small-vma-lock-cleanups.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/vma: small VMA lock cleanups
Date: Fri, 24 Oct 2025 10:09:02 +0100

We declare vma_start_read() as a static function in mm/mmap_lock.c, so
there is no need to provide a stub for !CONFIG_PER_VMA_LOCK.

__is_vma_write_locked() is declared in a header and should therefore be
static inline.

Put parens around (refcnt & VMA_LOCK_OFFSET) in is_vma_writer_only() to
make precedence clear.

Link: https://lkml.kernel.org/r/20251024090902.1118174-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmap_lock.h |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/include/linux/mmap_lock.h~mm-vma-small-vma-lock-cleanups
+++ a/include/linux/mmap_lock.h
@@ -130,7 +130,7 @@ static inline bool is_vma_writer_only(in
 	 * a detached vma happens only in vma_mark_detached() and is a rare
 	 * case, therefore most of the time there will be no unnecessary wakeup.
 	 */
-	return refcnt & VMA_LOCK_OFFSET && refcnt <= VMA_LOCK_OFFSET + 1;
+	return (refcnt & VMA_LOCK_OFFSET) && refcnt <= VMA_LOCK_OFFSET + 1;
 }
 
 static inline void vma_refcount_put(struct vm_area_struct *vma)
@@ -183,7 +183,7 @@ static inline void vma_end_read(struct v
 }
 
 /* WARNING! Can only be used if mmap_lock is expected to be write-locked */
-static bool __is_vma_write_locked(struct vm_area_struct *vma, unsigned int *mm_lock_seq)
+static inline bool __is_vma_write_locked(struct vm_area_struct *vma, unsigned int *mm_lock_seq)
 {
 	mmap_assert_write_locked(vma->vm_mm);
 
@@ -281,9 +281,6 @@ static inline bool mmap_lock_speculate_r
 	return true;
 }
 static inline void vma_lock_init(struct vm_area_struct *vma, bool reset_refcnt) {}
-static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
-						    struct vm_area_struct *vma)
-		{ return NULL; }
 static inline void vma_end_read(struct vm_area_struct *vma) {}
 static inline void vma_start_write(struct vm_area_struct *vma) {}
 static inline void vma_assert_write_locked(struct vm_area_struct *vma)
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-shmem-update-shmem-to-use-mmap_prepare.patch
device-dax-update-devdax-to-use-mmap_prepare.patch
mm-vma-remove-unused-function-make-internal-functions-static.patch
mm-add-vma_desc_size-vma_desc_pages-helpers.patch
relay-update-relay-to-use-mmap_prepare.patch
mm-vma-rename-__mmap_prepare-function-to-avoid-confusion.patch
mm-add-remap_pfn_range_prepare-remap_pfn_range_complete.patch
mm-abstract-io_remap_pfn_range-based-on-pfn.patch
mm-introduce-io_remap_pfn_range_.patch
mm-add-ability-to-take-further-action-in-vm_area_desc.patch
doc-update-porting-vfs-documentation-for-mmap_prepare-actions.patch
mm-hugetlbfs-update-hugetlbfs-to-use-mmap_prepare.patch
mm-add-shmem_zero_setup_desc.patch
mm-update-mem-char-driver-to-use-mmap_prepare.patch
mm-update-resctl-to-use-mmap_prepare.patch
mm-vma-small-vma-lock-cleanups.patch

