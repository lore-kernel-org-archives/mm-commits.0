Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4F15CB0
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714956986; cv=none; b=mpDa2A2cRoJCMcAxGw80PYyKxjv5xTSfYlUY79+vPvcqtHbUX2ti7ZbCaM5zLk8Kdu0MP2d2X8Wm3SI9OGs7LEB8/GoYcorT9deG18qPQ1JPoJGqEQ/BDkTcXtboccW5mAYrCQ9zNIVSrrkRj6jtpxd0DgAZ5SgRA13GlxjgJFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714956986; c=relaxed/simple;
	bh=yBW/N4rKF+biZcry/2uSi4KKPJDhOvqPSQ61w7RsEug=;
	h=Date:To:From:Subject:Message-Id; b=U52Gwf8Si6aeSmiwwOM0QOVJ2Tg8UCgcywMsXkieoHG4WvSrHLehVLVRDqxhoxpiD33lFD+jVcOx+V58+mY74D+KSxogeeNkx2L9ewKdTPbuOLJMt/gUwHQIMh8CCV4FDQciH8wAdlnBnUPJJ3VTfRu7ll5qezgymxi48kTGX70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tErTdTdm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tErTdTdm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32AF7C113CC;
	Mon,  6 May 2024 00:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714956986;
	bh=yBW/N4rKF+biZcry/2uSi4KKPJDhOvqPSQ61w7RsEug=;
	h=Date:To:From:Subject:From;
	b=tErTdTdmHxti3zbvmGeRfg5rbG1lrp4UaqdY7EsCvqawhJQxvNrhmEtyvGM3DX8D6
	 WHY0IpSezkzMSXI/Ubub6gXxviYjVJMCVuQhI9sBWM5GAjJauQg+/xH2saYhX0htCt
	 PEjzRajULdnDVhytz5BbdKaXtc67oGCbPHmf5KmQ=
Date: Sun, 05 May 2024 17:56:25 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,lstoakes@gmail.com,Liam.Howlett@oracle.com,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-make-vma_wants_writenotify-return-bool.patch removed from -mm tree
Message-Id: <20240506005626.32AF7C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mmap: make vma_wants_writenotify return bool
has been removed from the -mm tree.  Its filename was
     mm-mmap-make-vma_wants_writenotify-return-bool.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hao Ge <gehao@kylinos.cn>
Subject: mm/mmap: make vma_wants_writenotify return bool
Date: Sun, 7 Apr 2024 14:26:53 +0800

vma_wants_writenotify() should return bool, so change it.

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


