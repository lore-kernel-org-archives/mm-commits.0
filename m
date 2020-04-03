From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-fix-build-failure-with-hugetlb_page-but-not-hugebtlbfs.patch
 removed from -mm tree
Date: Fri, 03 Apr 2020 13:41:07 -0700
Message-ID: <20200403204107.oiQqATmLv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727907AbgDCUlI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:41:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agl@us.ibm.com, ak@suse.de, bhe@redhat.com, christophe.leroy@c-s.fr, lkp@intel.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, nacc@us.ibm.com, npiggin@suse.de


The patch titled
     Subject: mm/hugetlb: fix build failure with HUGETLB_PAGE but not HUGEBTLBFS
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-build-failure-with-hugetlb_page-but-not-hugebtlbfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: mm/hugetlb: fix build failure with HUGETLB_PAGE but not HUGEBTLBFS

When CONFIG_HUGETLB_PAGE is set but not CONFIG_HUGETLBFS, the following
build failure is encoutered:

In file included from arch/powerpc/mm/fault.c:33:0:
./include/linux/hugetlb.h: In function 'hstate_inode':
./include/linux/hugetlb.h:477:9: error: implicit declaration of function 'HUGETLBFS_SB' [-Werror=implicit-function-declaration]
  return HUGETLBFS_SB(i->i_sb)->hstate;
         ^
./include/linux/hugetlb.h:477:30: error: invalid type argument of '->' (have 'int')
  return HUGETLBFS_SB(i->i_sb)->hstate;
                              ^

Gate hstate_inode() with CONFIG_HUGETLBFS instead of CONFIG_HUGETLB_PAGE.

Link: http://lkml.kernel.org/r/7e8c3a3c9a587b9cd8a2f146df32a421b961f3a2.1584432148.git.christophe.leroy@c-s.fr
Link: https://patchwork.ozlabs.org/patch/1255548/#2386036
Fixes: a137e1cc6d6e ("hugetlbfs: per mount huge page sizes")
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Reported-by: kbuild test robot <lkp@intel.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-fix-build-failure-with-hugetlb_page-but-not-hugebtlbfs
+++ a/include/linux/hugetlb.h
@@ -443,7 +443,10 @@ static inline bool is_file_hugepages(str
 	return is_file_shm_hugepages(file);
 }
 
-
+static inline struct hstate *hstate_inode(struct inode *i)
+{
+	return HUGETLBFS_SB(i->i_sb)->hstate;
+}
 #else /* !CONFIG_HUGETLBFS */
 
 #define is_file_hugepages(file)			false
@@ -455,6 +458,10 @@ hugetlb_file_setup(const char *name, siz
 	return ERR_PTR(-ENOSYS);
 }
 
+static inline struct hstate *hstate_inode(struct inode *i)
+{
+	return NULL;
+}
 #endif /* !CONFIG_HUGETLBFS */
 
 #ifdef HAVE_ARCH_HUGETLB_UNMAPPED_AREA
@@ -525,11 +532,6 @@ extern unsigned int default_hstate_idx;
 
 #define default_hstate (hstates[default_hstate_idx])
 
-static inline struct hstate *hstate_inode(struct inode *i)
-{
-	return HUGETLBFS_SB(i->i_sb)->hstate;
-}
-
 static inline struct hstate *hstate_file(struct file *f)
 {
 	return hstate_inode(file_inode(f));
@@ -781,11 +783,6 @@ static inline struct hstate *hstate_vma(
 {
 	return NULL;
 }
