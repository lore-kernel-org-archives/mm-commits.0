Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6FF1D5CF1
	for <mm-commits@vger.kernel.org>; Thu, 17 Oct 2024 21:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729201260; cv=none; b=PPjICZZ6dVmQTEL7THFllViu1q8IKvCS8WNOnuamw8BnBmLab5UEL6186eBOQKUI/f1xX8lmSvbomCzgea8r4xerLMDJlxKhBkcrFaES5WT5dFU66zJD3RhjV9QplHMRzIfQX8xRbKOCumafyhEiA5MleJ1zgd7rxVvpZlIXfj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729201260; c=relaxed/simple;
	bh=TKdbqzz0vApoPDRtJw3Aa4ioWF0lKQ+boxe79bVbQHc=;
	h=Date:To:From:Subject:Message-Id; b=MeSITx74msRFgiF97hBMLDA7768hZ/M/w5HcVybxKVZ+7AoCYQGuGRA6opMn5jF+1LIpiHUkKjxeQyEOwqByZetXx+wWVeJtON1A2kqtCCGQpR5A0P/j5IN/uGw6k95h7EZQpunO4z2pQjTczxSniYiw87yLdKjJlScgom2Pk3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L9SfMJUG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L9SfMJUG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD1E1C4CEC3;
	Thu, 17 Oct 2024 21:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729201259;
	bh=TKdbqzz0vApoPDRtJw3Aa4ioWF0lKQ+boxe79bVbQHc=;
	h=Date:To:From:Subject:From;
	b=L9SfMJUGPGI9cYe4rg8tbxD6GwEWl0vUr9hz0JWKzTJwL48UO6Boxq0y64aHUViKw
	 NV/FsJLFCOlJRLRx74YWR6cQQw3VL1ugnR1fAOLS8XmaPjqquSjQ6feRBDpPIkxkYy
	 Dk47bKcTccHSWXNOcUPs24TohZubQ1/A3aqS4Hj0=
Date: Thu, 17 Oct 2024 14:40:58 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ryan.roberts@arm.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-move-file_thp_enabled-into-huge_memoryc.patch added to mm-unstable branch
Message-Id: <20241017214059.AD1E1C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: huge_memory: move file_thp_enabled() into huge_memory.c
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-move-file_thp_enabled-into-huge_memoryc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-move-file_thp_enabled-into-huge_memoryc.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: huge_memory: move file_thp_enabled() into huge_memory.c
Date: Thu, 17 Oct 2024 22:14:56 +0800

file_thp_enabled() is only used in __thp_vma_allowable_orders(), so move
it into huge_memory.c, also check READ_ONLY_THP_FOR_FS ahead to avoid
unnecessary code if config disabled.

Link: https://lkml.kernel.org/r/20241017141457.1169092-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   13 -------------
 mm/huge_memory.c        |   15 +++++++++++++++
 2 files changed, 15 insertions(+), 13 deletions(-)

--- a/include/linux/huge_mm.h~mm-huge_memory-move-file_thp_enabled-into-huge_memoryc
+++ a/include/linux/huge_mm.h
@@ -253,19 +253,6 @@ static inline unsigned long thp_vma_suit
 	return orders;
 }
 
-static inline bool file_thp_enabled(struct vm_area_struct *vma)
-{
-	struct inode *inode;
-
-	if (!vma->vm_file)
-		return false;
-
-	inode = vma->vm_file->f_inode;
-
-	return (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS)) &&
-	       !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
-}
-
 unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 					 unsigned long vm_flags,
 					 unsigned long tva_flags,
--- a/mm/huge_memory.c~mm-huge_memory-move-file_thp_enabled-into-huge_memoryc
+++ a/mm/huge_memory.c
@@ -83,6 +83,21 @@ unsigned long huge_anon_orders_madvise _
 unsigned long huge_anon_orders_inherit __read_mostly;
 static bool anon_orders_configured __initdata;
 
+static inline bool file_thp_enabled(struct vm_area_struct *vma)
+{
+	struct inode *inode;
+
+	if (!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS))
+		return false;
+
+	if (!vma->vm_file)
+		return false;
+
+	inode = file_inode(vma->vm_file);
+
+	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
+}
+
 unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 					 unsigned long vm_flags,
 					 unsigned long tva_flags,
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-remove-unused-hugepage-for-vma_alloc_folio.patch
tmpfs-dont-enable-large-folios-if-not-supported.patch
mm-huge_memory-move-file_thp_enabled-into-huge_memoryc.patch
mm-shmem-remove-__shmem_huge_global_enabled.patch

