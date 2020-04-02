From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 154/155] mm/hugetlb: fix build failure with
 HUGETLB_PAGE but not HUGEBTLBFS
Date: Wed, 01 Apr 2020 21:11:54 -0700
Message-ID: <20200402041154.rvrGUeBta%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgDBEL4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:11:56 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agl@us.ibm.com, ak@suse.de, akpm@linux-foundation.org, bhe@redhat.com, christophe.leroy@c-s.fr, linux-mm@kvack.org, lkp@intel.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, nacc@us.ibm.com, npiggin@suse.de, torvalds@linux-foundation.org

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
