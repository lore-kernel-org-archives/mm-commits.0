From: akpm@linux-foundation.org
Subject: + hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch added to -mm tree
Date: Wed, 26 Aug 2009 16:24:43 -0700
Message-ID: <200908262324.n7QNOh9F014868@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56444 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753742AbZHZXZq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Aug 2009 19:25:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebmunson@us.ibm.com, agl@us.ibm.com, david@gibson.dropbear.id.au, hugh.dickins@tiscali.co.uk, lee.schermerhorn@hp.com, mel@csn.ul.ie, nickpiggin@yahoo.com.au, rientjes@google.com


The patch titled
     hugetlb: add MAP_HUGETLB for mmaping pseudo-anonymous huge page regions
has been added to the -mm tree.  Its filename is
     hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: add MAP_HUGETLB for mmaping pseudo-anonymous huge page regions
From: Eric B Munson <ebmunson@us.ibm.com>

Add a flag for mmap that will be used to request a huge page region that
will look like anonymous memory to userspace.  This is accomplished by
using a file on the internal vfsmount.  MAP_HUGETLB is a modifier of
MAP_ANONYMOUS and so must be specified with it.  The region will behave
the same as a MAP_ANONYMOUS region using small pages.

Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Adam Litke <agl@us.ibm.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/mman-common.h |    1 +
 include/linux/hugetlb.h           |    7 +++++++
 mm/mmap.c                         |   19 +++++++++++++++++++
 3 files changed, 27 insertions(+)

diff -puN include/asm-generic/mman-common.h~hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions include/asm-generic/mman-common.h
--- a/include/asm-generic/mman-common.h~hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions
+++ a/include/asm-generic/mman-common.h
@@ -19,6 +19,7 @@
 #define MAP_TYPE	0x0f		/* Mask for type of mapping */
 #define MAP_FIXED	0x10		/* Interpret addr exactly */
 #define MAP_ANONYMOUS	0x20		/* don't use a file */
+#define MAP_HUGETLB	0x40		/* create a huge page mapping */
 
 #define MS_ASYNC	1		/* sync memory asynchronously */
 #define MS_INVALIDATE	2		/* invalidate the caches */
diff -puN include/linux/hugetlb.h~hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions
+++ a/include/linux/hugetlb.h
@@ -110,12 +110,19 @@ static inline void hugetlb_report_meminf
 
 #endif /* !CONFIG_HUGETLB_PAGE */
 
+#define HUGETLB_ANON_FILE "anon_hugepage"
+
 enum {
 	/*
 	 * The file will be used as an shm file so shmfs accounting rules
 	 * apply
 	 */
 	HUGETLB_SHMFS_INODE     = 1,
+	/*
+	 * The file is being created on the internal vfs mount and shmfs
+	 * accounting rules do not apply
+	 */
+	HUGETLB_ANONHUGE_INODE  = 2,
 };
 
 #ifdef CONFIG_HUGETLBFS
diff -puN mm/mmap.c~hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions mm/mmap.c
--- a/mm/mmap.c~hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions
+++ a/mm/mmap.c
@@ -30,6 +30,7 @@
 #include <linux/ksm.h>
 #include <linux/mmu_notifier.h>
 #include <linux/perf_counter.h>
+#include <linux/hugetlb.h>
 
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
@@ -950,6 +951,24 @@ unsigned long do_mmap_pgoff(struct file 
 	if (mm->map_count > sysctl_max_map_count)
 		return -ENOMEM;
 
+	if (flags & MAP_HUGETLB) {
+		struct user_struct *user = NULL;
+		if (file)
+			return -EINVAL;
+
+		/*
+		 * VM_NORESERVE is used because the reservations will be
+		 * taken when vm_ops->mmap() is called
+		 * A dummy user value is used because we are not locking
+		 * memory so no accounting is necessary
+		 */
+		len = ALIGN(len, huge_page_size(&default_hstate));
+		file = hugetlb_file_setup(HUGETLB_ANON_FILE, len, VM_NORESERVE,
+						&user, HUGETLB_ANONHUGE_INODE);
+		if (IS_ERR(file))
+			return PTR_ERR(file);
+	}
+
 	/* Obtain the address to map to. we verify (or select) it and ensure
 	 * that it represents a valid section of the address space.
 	 */
_

Patches currently in -mm which might be from ebmunson@us.ibm.com are

hugetlbfs-allow-the-creation-of-files-suitable-for-map_private-on-the-vfs-internal-mount.patch
hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch
hugetlb-add-map_hugetlb-example.patch

