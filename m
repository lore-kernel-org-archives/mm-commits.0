Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4FE4189BBD
	for <mm-commits@vger.kernel.org>; Mon,  7 Oct 2024 21:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728335262; cv=none; b=qmbCbP5VkMTp6RWePRWzP2WqN47EfxhjmSt6ppIFrwz/7FBTsslP4++6Q7aoTvEyVTqmEx8vD+sXUMJ2qspTNBiwSa3pTL9FXxwJtkfvTeqx1/nfF8RvF5/6FpRk8gpjYNh1idgpeyVPfA5fobnWL7a01D0vCSyZihFj1azvfq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728335262; c=relaxed/simple;
	bh=zOJjuUWAhzPqyU2WPjoheywyEYp40/FVng+rf+Jv3eo=;
	h=Date:To:From:Subject:Message-Id; b=MKcgfWH65frjnDTvKmz9rOPpurSLyOeHiFtm7CQN4UM4naKz//NXdt2a0yLBJy/TsMpOGjm9MstJ6f1bokW6ADQaUZCo9d3Y/CFaGG5kP28JhZWCY3MQNNPlcHBR/+WmohQCWASmBKKMHq5kMr4f5mk703KuMxzkzRvKqjIJhZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=brhElUn1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="brhElUn1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56744C4CEC6;
	Mon,  7 Oct 2024 21:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728335262;
	bh=zOJjuUWAhzPqyU2WPjoheywyEYp40/FVng+rf+Jv3eo=;
	h=Date:To:From:Subject:From;
	b=brhElUn1QtZjPNtbAJAa+C2Htkwh82eyphtyyPL7GGgy4tFuBlk+mEFxf4R54w2Pe
	 ko9kHiJrELbgRN1KUDW4RsO2QUM7wkRybvoK1tEf1QQSmuPvJhYk8vLc5xiRdQeslf
	 xsnWWZQ9zvg8U4LYPXOo4t+dXLa57sxcf+foqkSU=
Date: Mon, 07 Oct 2024 14:07:41 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,peterx@redhat.com,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,donettom@linux.ibm.com,david@redhat.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-hugetlb-mappings-go-through-mm_get_unmapped_area_vmflags.patch added to mm-unstable branch
Message-Id: <20241007210742.56744C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: make hugetlb mappings go through mm_get_unmapped_area_vmflags
has been added to the -mm mm-unstable branch.  Its filename is
     mm-make-hugetlb-mappings-go-through-mm_get_unmapped_area_vmflags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-hugetlb-mappings-go-through-mm_get_unmapped_area_vmflags.patch

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
From: Oscar Salvador <osalvador@suse.de>
Subject: mm: make hugetlb mappings go through mm_get_unmapped_area_vmflags
Date: Mon, 7 Oct 2024 09:50:34 +0200

Hugetlb mappings will no longer be special cased but rather go through the
generic mm_get_unmapped_area_vmflags function.  For that to happen, let us
remove the .get_unmapped_area from hugetlbfs_file_operations struct, and
hint __get_unmapped_area that it should not send hugetlb mappings through
thp_get_unmapped_area_vmflags but through mm_get_unmapped_area_vmflags.

Create also a function called hugetlb_mmap_check_and_align() where a
couple of safety checks are being done and the addr is aligned to the huge
page size.  Otherwise we will have to do this in every single function,
which duplicates quite a lot of code.

Link: https://lkml.kernel.org/r/20241007075037.267650-7-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c    |   24 ++++++++++++++++--------
 include/linux/hugetlb.h |    9 ++++-----
 2 files changed, 20 insertions(+), 13 deletions(-)

--- a/fs/hugetlbfs/inode.c~mm-make-hugetlb-mappings-go-through-mm_get_unmapped_area_vmflags
+++ a/fs/hugetlbfs/inode.c
@@ -258,15 +258,23 @@ generic_hugetlb_get_unmapped_area(struct
 			pgoff, flags);
 }
 
-#ifndef HAVE_ARCH_HUGETLB_UNMAPPED_AREA
-static unsigned long
-hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
-			  unsigned long len, unsigned long pgoff,
-			  unsigned long flags)
+unsigned long
+__hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
+			    unsigned long len, unsigned long flags)
 {
-	return generic_hugetlb_get_unmapped_area(file, addr, len, pgoff, flags);
+	unsigned long addr0 = 0;
+	struct hstate *h = hstate_file(file);
+
+	if (len & ~huge_page_mask(h))
+		return -EINVAL;
+	if ((flags & MAP_FIXED) && prepare_hugepage_range(file, addr, len))
+		return -EINVAL;
+	if (addr)
+		addr0 = ALIGN(addr, huge_page_size(h));
+
+	return mm_get_unmapped_area_vmflags(current->mm, file, addr, len, pgoff,
+					    flags, 0);
 }
-#endif
 
 /*
  * Someone wants to read @bytes from a HWPOISON hugetlb @page from @offset.
@@ -1300,7 +1308,7 @@ static const struct file_operations huge
 	.read_iter		= hugetlbfs_read_iter,
 	.mmap			= hugetlbfs_file_mmap,
 	.fsync			= noop_fsync,
-	.get_unmapped_area	= hugetlb_get_unmapped_area,
+	.get_unmapped_area	= __hugetlb_get_unmapped_area,
 	.llseek			= default_llseek,
 	.fallocate		= hugetlbfs_fallocate,
 	.fop_flags		= FOP_HUGE_PAGES,
--- a/include/linux/hugetlb.h~mm-make-hugetlb-mappings-go-through-mm_get_unmapped_area_vmflags
+++ a/include/linux/hugetlb.h
@@ -546,11 +546,10 @@ static inline struct hstate *hstate_inod
 }
 #endif /* !CONFIG_HUGETLBFS */
 
-#ifdef HAVE_ARCH_HUGETLB_UNMAPPED_AREA
-unsigned long hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
-					unsigned long len, unsigned long pgoff,
-					unsigned long flags);
-#endif /* HAVE_ARCH_HUGETLB_UNMAPPED_AREA */
+unsigned long
+__generic_hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
+				    unsigned long len, unsigned long pgoff,
+				    unsigned long flags);
 
 unsigned long
 generic_hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
_

Patches currently in -mm which might be from osalvador@suse.de are

mm-mmap-teach-generic_get_unmapped_area_topdown-to-handle-hugetlb-mappings.patch
arch-s390-teach-arch_get_unmapped_area_topdown-to-handle-hugetlb-mappings.patch
arch-x86-teach-arch_get_unmapped_area_vmflags-to-handle-hugetlb-mappings.patch
arch-sparc-teach-arch_get_unmapped_area_topdown-to-handle-hugetlb-mappings.patch
arch-powerpc-teach-book3s64-arch_get_unmapped_area_topdown-to-handle-hugetlb-mappings.patch
mm-make-hugetlb-mappings-go-through-mm_get_unmapped_area_vmflags.patch
mm-drop-hugetlb_get_unmapped_area_-functions.patch
arch-s390-clean-up-hugetlb-definitions.patch
mm-consolidate-common-checks-in-hugetlb_get_unmapped_area.patch

