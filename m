Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32EB07E1
	for <mm-commits@vger.kernel.org>; Mon, 29 Jul 2024 23:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722295899; cv=none; b=tPUoap7LvQWPSYtaI3gekqXW+zo7xqYIZKoluaRbhqIfR1BNkMNoExnZlLOBPEg3PAB/whutYxdIlVvhWdqQMcVGOD0SyX9Tutqs0KoIQ6E2URrVgrcqDZCpcwPvw5FKWzcb2i0MqeXcqzEU0e1RCYQLO9DjKN8Yvv5vFj7QNzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722295899; c=relaxed/simple;
	bh=NRrJH1sE1e7JC+RUinsbKaxv+aJ5NecSsRDnMhIrsQM=;
	h=Date:To:From:Subject:Message-Id; b=T1TjbZQ+8NCjYbowrRagnulvtsdm3lXioaZYc7Iw4LuNez/7eNfYMs1izlQYk9WJ4sMnDJBNTew/9Q/TpngjII2n6qFiR/V+xPZxWGNsv4U9eXNo0yWaRtg9sOb2E9UdUk2S8gdIuex0keFqm0ULbI88h1Cx6Wv4VfDyY6TkXXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vTcMl67F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vTcMl67F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B707AC32786;
	Mon, 29 Jul 2024 23:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722295898;
	bh=NRrJH1sE1e7JC+RUinsbKaxv+aJ5NecSsRDnMhIrsQM=;
	h=Date:To:From:Subject:From;
	b=vTcMl67F6ZvufTakUELPM8gDiML1qEicidC6M8iMCHQSsqoEdC77eok12qJXpGFWM
	 ncR47ldu7mE/w6o7/7CiFmDTxI/6dfsaFvz0UsVQT9zXBW3QhP9W9TTuMjC8LPNDoJ
	 PmoY1+w/ezE/NqQfS4Kl/vIvDWnRtYhOYjuE63BY=
Date: Mon, 29 Jul 2024 16:31:38 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,peterx@redhat.com,muchun.song@linux.dev,mhocko@suse.com,donettom@linux.ibm.com,david@redhat.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-hugetlb-mappings-go-through-mm_get_unmapped_area_vmflags.patch added to mm-unstable branch
Message-Id: <20240729233138.B707AC32786@smtp.kernel.org>
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
Date: Mon, 29 Jul 2024 11:10:15 +0200

Hugetlb mappings will no longer be special cased but rather go through the
generic mm_get_unmapped_area_vmflags function.  For that to happen, let us
remove the .get_unmapped_area from hugetlbfs_file_operations struct, and
hint __get_unmapped_area that it should not send hugetlb mappings through
thp_get_unmapped_area_vmflags but through mm_get_unmapped_area_vmflags.

Create also a function called hugetlb_mmap_check_and_align() where a
couple of safety checks are being done and the addr is aligned to the huge
page size.  Otherwise we will have to do this in every single function,
which duplicates quite a lot of code.

Link: https://lkml.kernel.org/r/20240729091018.2152-7-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c    |   22 ++++++++++++++--------
 include/linux/hugetlb.h |    8 +++-----
 mm/mmap.c               |   15 ++++++++++++++-
 3 files changed, 31 insertions(+), 14 deletions(-)

--- a/fs/hugetlbfs/inode.c~mm-make-hugetlb-mappings-go-through-mm_get_unmapped_area_vmflags
+++ a/fs/hugetlbfs/inode.c
@@ -258,15 +258,22 @@ generic_hugetlb_get_unmapped_area(struct
 			pgoff, flags);
 }
 
-#ifndef HAVE_ARCH_HUGETLB_UNMAPPED_AREA
-static unsigned long
-hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
-			  unsigned long len, unsigned long pgoff,
-			  unsigned long flags)
+unsigned long
+hugetlb_mmap_check_and_align(struct file *file, unsigned long addr,
+			     unsigned long len, unsigned long flags)
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
+	return addr0;
 }
-#endif
 
 /*
  * Someone wants to read @bytes from a HWPOISON hugetlb @page from @offset.
@@ -1300,7 +1307,6 @@ static const struct file_operations huge
 	.read_iter		= hugetlbfs_read_iter,
 	.mmap			= hugetlbfs_file_mmap,
 	.fsync			= noop_fsync,
-	.get_unmapped_area	= hugetlb_get_unmapped_area,
 	.llseek			= default_llseek,
 	.fallocate		= hugetlbfs_fallocate,
 	.fop_flags		= FOP_HUGE_PAGES,
--- a/include/linux/hugetlb.h~mm-make-hugetlb-mappings-go-through-mm_get_unmapped_area_vmflags
+++ a/include/linux/hugetlb.h
@@ -549,11 +549,9 @@ static inline struct hstate *hstate_inod
 }
 #endif /* !CONFIG_HUGETLBFS */
 
-#ifdef HAVE_ARCH_HUGETLB_UNMAPPED_AREA
-unsigned long hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
-					unsigned long len, unsigned long pgoff,
-					unsigned long flags);
-#endif /* HAVE_ARCH_HUGETLB_UNMAPPED_AREA */
+unsigned long
+hugetlb_mmap_check_and_align(struct file *file, unsigned long addr,
+			     unsigned long len, unsigned long flags);
 
 unsigned long
 generic_hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
--- a/mm/mmap.c~mm-make-hugetlb-mappings-go-through-mm_get_unmapped_area_vmflags
+++ a/mm/mmap.c
@@ -879,6 +879,7 @@ __get_unmapped_area(struct file *file, u
 				  unsigned long, unsigned long, unsigned long)
 				  = NULL;
 
+	bool is_hugetlb = false;
 	unsigned long error = arch_mmap_check(addr, len, flags);
 	if (error)
 		return error;
@@ -887,6 +888,9 @@ __get_unmapped_area(struct file *file, u
 	if (len > TASK_SIZE)
 		return -ENOMEM;
 
+	if (file && is_file_hugepages(file))
+		is_hugetlb = true;
+
 	if (file) {
 		if (file->f_op->get_unmapped_area)
 			get_area = file->f_op->get_unmapped_area;
@@ -904,11 +908,20 @@ __get_unmapped_area(struct file *file, u
 
 	if (get_area) {
 		addr = get_area(file, addr, len, pgoff, flags);
-	} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
+	} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && !is_hugetlb) {
 		/* Ensures that larger anonymous mappings are THP aligned. */
 		addr = thp_get_unmapped_area_vmflags(file, addr, len,
 						     pgoff, flags, vm_flags);
 	} else {
+		/*
+		 * Consolidate hugepages checks in one place, and also align addr
+		 * to hugepage size.
+		 */
+		if (is_hugetlb) {
+			addr = hugetlb_mmap_check_and_align(file, addr, len, flags);
+			if (IS_ERR_VALUE(addr))
+				return addr;
+		}
 		addr = mm_get_unmapped_area_vmflags(current->mm, file, addr, len,
 						    pgoff, flags, vm_flags);
 	}
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
mm-consolidate-common-checks-in-hugetlb_mmap_check_and_align.patch

