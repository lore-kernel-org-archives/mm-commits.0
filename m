From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-hugetlb-fix-build-failure-with-hugetlb_page-but-not-hugebtlbfs.patch
 added to -mm tree
Date: Tue, 17 Mar 2020 22:02:44 -0700
Message-ID: <20200318050244.ZhnhWsT2M%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726227AbgCRFCq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 18 Mar 2020 01:02:46 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agl@us.ibm.com, ak@suse.de, bhe@redhat.com, christophe.leroy@c-s.fr, lkp@intel.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, nacc@us.ibm.com, npiggin@suse.de


The patch titled
     Subject: mm/hugetlb: fix build failure with HUGETLB_PAGE but not HUGEBTLBFS
has been added to the -mm tree.  Its filename is
     mm-hugetlb-fix-build-failure-with-hugetlb_page-but-not-hugebtlbfs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-fix-build-failure-with-hugetlb_page-but-not-hugebtlbfs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-fix-build-failure-with-hugetlb_page-but-not-hugebtlbfs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -435,7 +435,10 @@ static inline bool is_file_hugepages(str
 	return is_file_shm_hugepages(file);
 }
 
-
+static inline struct hstate *hstate_inode(struct inode *i)
+{
+	return HUGETLBFS_SB(i->i_sb)->hstate;
+}
 #else /* !CONFIG_HUGETLBFS */
 
 #define is_file_hugepages(file)			false
@@ -447,6 +450,10 @@ hugetlb_file_setup(const char *name, siz
 	return ERR_PTR(-ENOSYS);
 }
 
+static inline struct hstate *hstate_inode(struct inode *i)
+{
+	return NULL;
+}
 #endif /* !CONFIG_HUGETLBFS */
 
 #ifdef HAVE_ARCH_HUGETLB_UNMAPPED_AREA
@@ -517,11 +524,6 @@ extern unsigned int default_hstate_idx;
 
 #define default_hstate (hstates[default_hstate_idx])
 
-static inline struct hstate *hstate_inode(struct inode *i)
-{
-	return HUGETLBFS_SB(i->i_sb)->hstate;
-}
-
 static inline struct hstate *hstate_file(struct file *f)
 {
 	return hstate_inode(file_inode(f));
@@ -773,11 +775,6 @@ static inline struct hstate *hstate_vma(
 {
 	return NULL;
 }
