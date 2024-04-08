Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A93433BD
	for <mm-commits@vger.kernel.org>; Mon,  8 Apr 2024 19:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712603863; cv=none; b=GOAvKPHXamjDLJnRLNYAILVqwqlvHNoECVg1ea1rjhFPiB01jNLCt6OlgF+J1nat+cV8i34HudLLK+fI80STtIGxyRoqf+1Kq8+qKgRhT5v30/SXQbdDZu+JQ4O44zoeMy56PhW/1mnaivlIQ+ImWjN8HtzQY1KloKPEWoFFxno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712603863; c=relaxed/simple;
	bh=TYHILt3GNW9IBGIbtx0+vy09R2+mMBYq5i6aCcvQbRA=;
	h=Date:To:From:Subject:Message-Id; b=bQTzbyK0Sr5joQURqLcsf205TP5tUva1GNIO1Aws/Wjs7t+5h4ErFOvA51YuQiDF+19GK6Zmdt+qu1i2i4cmiQaiqho15kW7vpzlF29qkdNJo0satVx4HfwtmRoq/seXlLRU7qtAWF5teznGhpPUM77C57w2Hi5/ykReaapDm/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iCo7ZaMb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iCo7ZaMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E4AC433F1;
	Mon,  8 Apr 2024 19:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712603862;
	bh=TYHILt3GNW9IBGIbtx0+vy09R2+mMBYq5i6aCcvQbRA=;
	h=Date:To:From:Subject:From;
	b=iCo7ZaMbm0dezr3B69oiTK3b8tH3/7vbKv+CrHEcCwDhG1pjRt1v6MwuJ+xUkKJ64
	 dR1E2mI5ZJPujCUaqWimfyofyIyHrnfiDMFS4u6PzxyM9nFz8yFbkhdL2KHcGhCWcU
	 bs3bRn/QKnFC3lVz+wjoACmvy3BQTuVKH1NVDTk8=
Date: Mon, 08 Apr 2024 12:17:37 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,lstoakes@gmail.com,Liam.Howlett@oracle.com,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-make-vma_wants_writenotify-return-bool.patch added to mm-unstable branch
Message-Id: <20240408191742.C9E4AC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mmap: make vma_wants_writenotify return bool
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-make-vma_wants_writenotify-return-bool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-make-vma_wants_writenotify-return-bool.patch

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
From: Hao Ge <gehao@kylinos.cn>
Subject: mm/mmap: make vma_wants_writenotify return bool
Date: Sun, 7 Apr 2024 14:26:53 +0800

vma_wants_writenotify should return bool,so we change it

Link: https://lkml.kernel.org/r/20240407062653.803142-1-gehao@kylinos.cn
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 mm/mmap.c          |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/include/linux/mm.h~mm-mmap-make-vma_wants_writenotify-return-bool
+++ a/include/linux/mm.h
@@ -2575,7 +2575,7 @@ extern unsigned long move_page_tables(st
 					    MM_CP_UFFD_WP_RESOLVE)
 
 bool vma_needs_dirty_tracking(struct vm_area_struct *vma);
-int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot);
+bool vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot);
 static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma)
 {
 	/*
--- a/mm/mmap.c~mm-mmap-make-vma_wants_writenotify-return-bool
+++ a/mm/mmap.c
@@ -1514,32 +1514,32 @@ bool vma_needs_dirty_tracking(struct vm_
  * to the private version (using protection_map[] without the
  * VM_SHARED bit).
  */
-int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
+bool vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot)
 {
 	/* If it was private or non-writable, the write bit is already clear */
 	if (!vma_is_shared_writable(vma))
-		return 0;
+		return false;
 
 	/* The backer wishes to know when pages are first written to? */
 	if (vm_ops_needs_writenotify(vma->vm_ops))
-		return 1;
+		return true;
 
 	/* The open routine did something to the protections that pgprot_modify
 	 * won't preserve? */
 	if (pgprot_val(vm_page_prot) !=
 	    pgprot_val(vm_pgprot_modify(vm_page_prot, vma->vm_flags)))
-		return 0;
+		return false;
 
 	/*
 	 * Do we need to track softdirty? hugetlb does not support softdirty
 	 * tracking yet.
 	 */
 	if (vma_soft_dirty_enabled(vma) && !is_vm_hugetlb_page(vma))
-		return 1;
+		return true;
 
 	/* Do we need write faults for uffd-wp tracking? */
 	if (userfaultfd_wp(vma))
-		return 1;
+		return true;
 
 	/* Can the mapping track the dirty pages? */
 	return vma_fs_can_writeback(vma);
_

Patches currently in -mm which might be from gehao@kylinos.cn are

mm-page-flags-make-__pagemovable-return-bool.patch
mm-page-flags-make-pagemappingflags-return-bool.patch
mm-mmap-make-vma_wants_writenotify-return-bool.patch

