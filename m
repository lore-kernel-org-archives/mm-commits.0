Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37132156962
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854777; cv=none; b=PMJPNBM6MejJDA2AlS7RVhJ4TYVTTHucvIs133tkFJTDq7vBqJwjF3iugBTUdu2dM9chdgCMKNwMJKuc+3IVtLBbDzy5lP+qVKFabHFjc8Bh3rv8R8xbwskW1BagPZT+Yi47xRlMf3QLFEhIf+2faBUkP9Kt/nWwFHO/GTNBfpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854777; c=relaxed/simple;
	bh=mm8tbmUY79H6KNEBixLzM/Oo7oOJIUxcT8lB1gWWRu4=;
	h=Date:To:From:Subject:Message-Id; b=iwarEk+7vLvmbf01WPIy9eWeYgGtSZL7lci9fykBqheHbZK89/CtA5iZhEHYcfDx34jjBi/TXuV6q4AsURYIpZto4hDLlBOt0G+Foi/Qx1VNPlB0WsCUA2CZGiAwWnvT112+NIZIJD9Wj5NWPl3PJ+VFdORe+SGs+9v28B9BUjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PKebBgcZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PKebBgcZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C908C4CECF;
	Wed,  6 Nov 2024 00:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854777;
	bh=mm8tbmUY79H6KNEBixLzM/Oo7oOJIUxcT8lB1gWWRu4=;
	h=Date:To:From:Subject:From;
	b=PKebBgcZKd68MTdZJX/XPI+Mr9Ieg0fqa4gxmHKNppx47fXOF/lqoIebJSLOeAVeE
	 oaR48j8RYGT00+hR1okPeGWSHpmIOkKIJ4LGwwdBrqKshvljnL84SAREW0938tAWhr
	 NCh4CX03sgmn8AhgTI0Ll2xDupQjfEvT+BxhKIjE=
Date: Tue, 05 Nov 2024 16:59:36 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,peterx@redhat.com,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,donettom@linux.ibm.com,david@redhat.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-make-hugetlb-mappings-go-through-mm_get_unmapped_area_vmflags.patch removed from -mm tree
Message-Id: <20241106005937.0C908C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: make hugetlb mappings go through mm_get_unmapped_area_vmflags
has been removed from the -mm tree.  Its filename was
     mm-make-hugetlb-mappings-go-through-mm_get_unmapped_area_vmflags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


