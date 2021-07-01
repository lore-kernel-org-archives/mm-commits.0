Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D00DEC11F6A
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:49:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B28986120C
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:49:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238405AbhGABvt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:51:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:41144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238384AbhGABvr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:51:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8987261090;
        Thu,  1 Jul 2021 01:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104158;
        bh=DT/+NfgrdZQOYp4/8qPtS9HhRkjG+rqHo6nhOV5Ir2w=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=N2FV295DAJsUOKRLcLBjHMAaxBifxfthi49Sx7zK3aZKMiJmimCKA0gJ5d293v7RB
         /Pdz9eW+LtmjaeMz3jd83XI8EXg/QFz9RLiNzQe71U0sX6lnibYFYwW/M6d5jIl2uT
         57M9kHIkFwZdjU3+0+uPTKHTHmeB4wov0WEZWIBw=
Date:   Wed, 30 Jun 2021 18:49:17 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org,
        almasrymina@google.com, axelrasmussen@google.com,
        bgeffon@google.com, dgilbert@redhat.com, hughd@google.com,
        jglisse@redhat.com, joe@perches.com, kirill@shutemov.name,
        linux-mm@kvack.org, lokeshgidra@google.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        oupton@google.com, peterx@redhat.com, rppt@linux.vnet.ibm.com,
        sfr@canb.auug.org.au, shli@fb.com, shuah@kernel.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        wangqing@vivo.com
Subject:  [patch 040/192] userfaultfd/shmem: combine
 shmem_{mcopy_atomic,mfill_zeropage}_pte
Message-ID: <20210701014917.RD2G3TGCN%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Axel Rasmussen <axelrasmussen@google.com>
Subject: userfaultfd/shmem: combine shmem_{mcopy_atomic,mfill_zeropage}_pte

Patch series "userfaultfd: add minor fault handling for shmem", v6.

Overview
========

See the series which added minor faults for hugetlbfs [3] for a detailed
overview of minor fault handling in general.  This series adds the same
support for shmem-backed areas.

This series is structured as follows:

- Commits 1 and 2 are cleanups.
- Commits 3 and 4 implement the new feature (minor fault handling for shmem).
- Commit 5 advertises that the feature is now available since at this point it's
  fully implemented.
- Commit 6 is a final cleanup, modifying an existing code path to re-use a new
  helper we've introduced.
- Commits 7, 8, 9, 10 update the userfaultfd selftest to exercise the feature.

Use Case
========

In some cases it is useful to have VM memory backed by tmpfs instead of
hugetlbfs.  So, this feature will be used to support the same VM live
migration use case described in my original series.

Additionally, Android folks (Lokesh Gidra <lokeshgidra@google.com>) hope
to optimize the Android Runtime garbage collector using this feature:

"The plan is to use userfaultfd for concurrently compacting the heap. 
With this feature, the heap can be shared-mapped at another location where
the GC-thread(s) could continue the compaction operation without the need
to invoke userfault ioctl(UFFDIO_COPY) each time.  OTOH, if and when Java
threads get faults on the heap, UFFDIO_CONTINUE can be used to resume
execution.  Furthermore, this feature enables updating references in the
'non-moving' portion of the heap efficiently.  Without this feature,
uneccessary page copying (ioctl(UFFDIO_COPY)) would be required."

[1] https://lore.kernel.org/patchwork/cover/1388144/
[2] https://lore.kernel.org/patchwork/patch/1408161/
[3] https://lore.kernel.org/linux-fsdevel/20210301222728.176417-1-axelrasmussen@google.com/T/#t


This patch (of 9):

Previously, we did a dance where we had one calling path in userfaultfd.c
(mfill_atomic_pte), but then we split it into two in shmem_fs.h
(shmem_{mcopy_atomic,mfill_zeropage}_pte), and then rejoined into a single
shared function in shmem.c (shmem_mfill_atomic_pte).

This is all a bit overly complex.  Just call the single combined shmem
function directly, allowing us to clean up various branches, boilerplate,
etc.

While we're touching this function, two other small cleanup changes:
- offset is equivalent to pgoff, so we can get rid of offset entirely.
- Split two VM_BUG_ON cases into two statements. This means the line
  number reported when the BUG is hit specifies exactly which condition
  was true.

Link: https://lkml.kernel.org/r/20210503180737.2487560-1-axelrasmussen@google.com
Link: https://lkml.kernel.org/r/20210503180737.2487560-3-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Oliver Upton <oupton@google.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Wang Qing <wangqing@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |   19 +++++--------
 mm/shmem.c               |   52 +++++++++++--------------------------
 mm/userfaultfd.c         |   10 ++-----
 3 files changed, 27 insertions(+), 54 deletions(-)

--- a/include/linux/shmem_fs.h~userfaultfd-shmem-combine-shmem_mcopy_atomicmfill_zeropage_pte
+++ a/include/linux/shmem_fs.h
@@ -122,21 +122,18 @@ static inline bool shmem_file(struct fil
 extern bool shmem_charge(struct inode *inode, long pages);
 extern void shmem_uncharge(struct inode *inode, long pages);
 
+#ifdef CONFIG_USERFAULTFD
 #ifdef CONFIG_SHMEM
-extern int shmem_mcopy_atomic_pte(struct mm_struct *dst_mm, pmd_t *dst_pmd,
+extern int shmem_mfill_atomic_pte(struct mm_struct *dst_mm, pmd_t *dst_pmd,
 				  struct vm_area_struct *dst_vma,
 				  unsigned long dst_addr,
 				  unsigned long src_addr,
+				  bool zeropage,
 				  struct page **pagep);
-extern int shmem_mfill_zeropage_pte(struct mm_struct *dst_mm,
-				    pmd_t *dst_pmd,
-				    struct vm_area_struct *dst_vma,
-				    unsigned long dst_addr);
-#else
-#define shmem_mcopy_atomic_pte(dst_mm, dst_pte, dst_vma, dst_addr, \
-			       src_addr, pagep)        ({ BUG(); 0; })
-#define shmem_mfill_zeropage_pte(dst_mm, dst_pmd, dst_vma, \
-				 dst_addr)      ({ BUG(); 0; })
-#endif
+#else /* !CONFIG_SHMEM */
+#define shmem_mfill_atomic_pte(dst_mm, dst_pmd, dst_vma, dst_addr, \
+			       src_addr, zeropage, pagep)       ({ BUG(); 0; })
+#endif /* CONFIG_SHMEM */
+#endif /* CONFIG_USERFAULTFD */
 
 #endif
--- a/mm/shmem.c~userfaultfd-shmem-combine-shmem_mcopy_atomicmfill_zeropage_pte
+++ a/mm/shmem.c
@@ -2352,13 +2352,14 @@ static struct inode *shmem_get_inode(str
 	return inode;
 }
 
-static int shmem_mfill_atomic_pte(struct mm_struct *dst_mm,
-				  pmd_t *dst_pmd,
-				  struct vm_area_struct *dst_vma,
-				  unsigned long dst_addr,
-				  unsigned long src_addr,
-				  bool zeropage,
-				  struct page **pagep)
+#ifdef CONFIG_USERFAULTFD
+int shmem_mfill_atomic_pte(struct mm_struct *dst_mm,
+			   pmd_t *dst_pmd,
+			   struct vm_area_struct *dst_vma,
+			   unsigned long dst_addr,
+			   unsigned long src_addr,
+			   bool zeropage,
+			   struct page **pagep)
 {
 	struct inode *inode = file_inode(dst_vma->vm_file);
 	struct shmem_inode_info *info = SHMEM_I(inode);
@@ -2370,7 +2371,7 @@ static int shmem_mfill_atomic_pte(struct
 	struct page *page;
 	pte_t _dst_pte, *dst_pte;
 	int ret;
-	pgoff_t offset, max_off;
+	pgoff_t max_off;
 
 	ret = -ENOMEM;
 	if (!shmem_inode_acct_block(inode, 1)) {
@@ -2391,7 +2392,7 @@ static int shmem_mfill_atomic_pte(struct
 		if (!page)
 			goto out_unacct_blocks;
 
-		if (!zeropage) {	/* mcopy_atomic */
+		if (!zeropage) {	/* COPY */
 			page_kaddr = kmap_atomic(page);
 			ret = copy_from_user(page_kaddr,
 					     (const void __user *)src_addr,
@@ -2405,7 +2406,7 @@ static int shmem_mfill_atomic_pte(struct
 				/* don't free the page */
 				return -ENOENT;
 			}
-		} else {		/* mfill_zeropage_atomic */
+		} else {		/* ZEROPAGE */
 			clear_highpage(page);
 		}
 	} else {
@@ -2413,15 +2414,15 @@ static int shmem_mfill_atomic_pte(struct
 		*pagep = NULL;
 	}
 
-	VM_BUG_ON(PageLocked(page) || PageSwapBacked(page));
+	VM_BUG_ON(PageLocked(page));
+	VM_BUG_ON(PageSwapBacked(page));
 	__SetPageLocked(page);
 	__SetPageSwapBacked(page);
 	__SetPageUptodate(page);
 
 	ret = -EFAULT;
-	offset = linear_page_index(dst_vma, dst_addr);
 	max_off = DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
-	if (unlikely(offset >= max_off))
+	if (unlikely(pgoff >= max_off))
 		goto out_release;
 
 	ret = shmem_add_to_page_cache(page, mapping, pgoff, NULL,
@@ -2447,7 +2448,7 @@ static int shmem_mfill_atomic_pte(struct
 
 	ret = -EFAULT;
 	max_off = DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
-	if (unlikely(offset >= max_off))
+	if (unlikely(pgoff >= max_off))
 		goto out_release_unlock;
 
 	ret = -EEXIST;
@@ -2484,28 +2485,7 @@ out_unacct_blocks:
 	shmem_inode_unacct_blocks(inode, 1);
 	goto out;
 }
-
-int shmem_mcopy_atomic_pte(struct mm_struct *dst_mm,
-			   pmd_t *dst_pmd,
-			   struct vm_area_struct *dst_vma,
-			   unsigned long dst_addr,
-			   unsigned long src_addr,
-			   struct page **pagep)
-{
-	return shmem_mfill_atomic_pte(dst_mm, dst_pmd, dst_vma,
-				      dst_addr, src_addr, false, pagep);
-}
-
-int shmem_mfill_zeropage_pte(struct mm_struct *dst_mm,
-			     pmd_t *dst_pmd,
-			     struct vm_area_struct *dst_vma,
-			     unsigned long dst_addr)
-{
-	struct page *page = NULL;
-
-	return shmem_mfill_atomic_pte(dst_mm, dst_pmd, dst_vma,
-				      dst_addr, 0, true, &page);
-}
+#endif /* CONFIG_USERFAULTFD */
 
 #ifdef CONFIG_TMPFS
 static const struct inode_operations shmem_symlink_inode_operations;
--- a/mm/userfaultfd.c~userfaultfd-shmem-combine-shmem_mcopy_atomicmfill_zeropage_pte
+++ a/mm/userfaultfd.c
@@ -392,13 +392,9 @@ static __always_inline ssize_t mfill_ato
 						 dst_vma, dst_addr);
 	} else {
 		VM_WARN_ON_ONCE(wp_copy);
-		if (!zeropage)
-			err = shmem_mcopy_atomic_pte(dst_mm, dst_pmd,
-						     dst_vma, dst_addr,
-						     src_addr, page);
-		else
-			err = shmem_mfill_zeropage_pte(dst_mm, dst_pmd,
-						       dst_vma, dst_addr);
+		err = shmem_mfill_atomic_pte(dst_mm, dst_pmd, dst_vma,
+					     dst_addr, src_addr, zeropage,
+					     page);
 	}
 
 	return err;
_
