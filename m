From: akpm@linux-foundation.org
Subject: [merged] hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:43:38 -0700
Message-ID: <200909222043.n8MKhcT4012031@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40747 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753145AbZIVUnx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:43:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebmunson@us.ibm.com, agl@us.ibm.com, arnd@arndb.de, david@gibson.dropbear.id.au, hugh.dickins@tiscali.co.uk, lee.schermerhorn@hp.com, mel@csn.ul.ie, nickpiggin@yahoo.com.au, rientjes@


The patch titled
     hugetlb: add MAP_HUGETLB for mmaping pseudo-anonymous huge page regions
has been removed from the -mm tree.  Its filename was
     hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: add MAP_HUGETLB for mmaping pseudo-anonymous huge page regions
From: Eric B Munson <ebmunson@us.ibm.com>

Add a flag for mmap that will be used to request a huge page region that
will look like anonymous memory to userspace.  This is accomplished by
using a file on the internal vfsmount.  MAP_HUGETLB is a modifier of
MAP_ANONYMOUS and so must be specified with it.  The region will behave
the same as a MAP_ANONYMOUS region using small pages.

[akpm@linux-foundation.org: fix arch definitions of MAP_HUGETLB]
Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Adam Litke <agl@us.ibm.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    7 +++++++
 mm/mmap.c               |   18 ++++++++++++++++++
 2 files changed, 25 insertions(+)

diff -puN include/linux/hugetlb.h~hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions
+++ a/include/linux/hugetlb.h
@@ -112,12 +112,19 @@ static inline void hugetlb_report_meminf
 
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
@@ -949,6 +949,24 @@ unsigned long do_mmap_pgoff(struct file 
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

origin.patch

