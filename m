Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8994C4361A
	for <mm-commits@archiver.kernel.org>; Sat,  5 Dec 2020 00:26:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9559922D6F
	for <mm-commits@archiver.kernel.org>; Sat,  5 Dec 2020 00:26:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730489AbgLEA03 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Dec 2020 19:26:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:47542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726264AbgLEA03 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Dec 2020 19:26:29 -0500
Date:   Fri, 04 Dec 2020 16:25:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607127948;
        bh=kAz62I4YwaJP2npmA9NsasCZz11lxr3xYiT028V025k=;
        h=From:To:Subject:From;
        b=UD++2BEJ9nty+sCS7P9kLs+CrrjG5pZxNstmm5SsK3Z+1D6TbPbWjwK2ErRJHGPQ9
         +RqS4WAfAldfkp8K9xGMkbm97Gq6g2cqgem65mxByz+HjXG53QDBhaN4Yg/K4IuZEK
         F7Xay+AWAZlkDEhTM7iXxHRiZHpFWwlYZS/b8618=
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, ira.weiny@intel.com, jgg@nvidia.com,
        jhubbard@nvidia.com, mm-commits@vger.kernel.org,
        pasha.tatashin@soleen.com
Subject:  +
 mm-gup-remove-the-vma-allocation-from-gup_longterm_locked.patch added to
 -mm tree
Message-ID: <20201205002547.OBJdT0s4a%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: remove the vma allocation from gup_longterm_locked()
has been added to the -mm tree.  Its filename is
     mm-gup-remove-the-vma-allocation-from-gup_longterm_locked.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-gup-remove-the-vma-allocation-from-gup_longterm_locked.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-remove-the-vma-allocation-from-gup_longterm_locked.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jason Gunthorpe <jgg@nvidia.com>
Subject: mm/gup: remove the vma allocation from gup_longterm_locked()

Long ago there wasn't a FOLL_LONGTERM flag so this DAX check was done by
post-processing the VMA list.

These days it is trivial to just check each VMA to see if it is DAX before
processing it inside __get_user_pages() and return failure if a DAX VMA is
encountered with FOLL_LONGTERM.

Removing the allocation of the VMA list is a significant speed up for many
call sites.

Add an IS_ENABLED to vma_is_fsdax so that code generation is unchanged
when DAX is compiled out.

Remove the dummy version of __gup_longterm_locked() as !CONFIG_CMA already
makes memalloc_nocma_save(), check_and_migrate_cma_pages(), and
memalloc_nocma_restore() into a NOP.

Link: https://lkml.kernel.org/r/0-v1-5551df3ed12e+b8-gup_dax_speedup_jgg@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    2 -
 mm/gup.c           |   83 +++++++------------------------------------
 2 files changed, 16 insertions(+), 69 deletions(-)

--- a/include/linux/fs.h~mm-gup-remove-the-vma-allocation-from-gup_longterm_locked
+++ a/include/linux/fs.h
@@ -3230,7 +3230,7 @@ static inline bool vma_is_fsdax(struct v
 {
 	struct inode *inode;
 
-	if (!vma->vm_file)
+	if (!IS_ENABLED(CONFIG_FS_DAX) || !vma->vm_file)
 		return false;
 	if (!vma_is_dax(vma))
 		return false;
--- a/mm/gup.c~mm-gup-remove-the-vma-allocation-from-gup_longterm_locked
+++ a/mm/gup.c
@@ -923,6 +923,9 @@ static int check_vma_flags(struct vm_are
 	if (gup_flags & FOLL_ANON && !vma_is_anonymous(vma))
 		return -EFAULT;
 
+	if ((gup_flags & FOLL_LONGTERM) && vma_is_fsdax(vma))
+		return -EOPNOTSUPP;
+
 	if (write) {
 		if (!(vm_flags & VM_WRITE)) {
 			if (!(gup_flags & FOLL_FORCE))
@@ -1060,10 +1063,14 @@ static long __get_user_pages(struct mm_s
 				goto next_page;
 			}
 
-			if (!vma || check_vma_flags(vma, gup_flags)) {
+			if (!vma) {
 				ret = -EFAULT;
 				goto out;
 			}
+			ret = check_vma_flags(vma, gup_flags);
+			if (ret)
+				goto out;
+
 			if (is_vm_hugetlb_page(vma)) {
 				i = follow_hugetlb_page(mm, vma, pages, vmas,
 						&start, &nr_pages, i,
@@ -1567,26 +1574,6 @@ struct page *get_dump_page(unsigned long
 }
 #endif /* CONFIG_ELF_CORE */
 
-#if defined(CONFIG_FS_DAX) || defined (CONFIG_CMA)
-static bool check_dax_vmas(struct vm_area_struct **vmas, long nr_pages)
-{
-	long i;
-	struct vm_area_struct *vma_prev = NULL;
-
-	for (i = 0; i < nr_pages; i++) {
-		struct vm_area_struct *vma = vmas[i];
-
-		if (vma == vma_prev)
-			continue;
-
-		vma_prev = vma;
-
-		if (vma_is_fsdax(vma))
-			return true;
-	}
-	return false;
-}
-
 #ifdef CONFIG_CMA
 static long check_and_migrate_cma_pages(struct mm_struct *mm,
 					unsigned long start,
@@ -1705,63 +1692,23 @@ static long __gup_longterm_locked(struct
 				  struct vm_area_struct **vmas,
 				  unsigned int gup_flags)
 {
-	struct vm_area_struct **vmas_tmp = vmas;
 	unsigned long flags = 0;
-	long rc, i;
+	long rc;
 
-	if (gup_flags & FOLL_LONGTERM) {
-		if (!pages)
-			return -EINVAL;
-
-		if (!vmas_tmp) {
-			vmas_tmp = kcalloc(nr_pages,
-					   sizeof(struct vm_area_struct *),
-					   GFP_KERNEL);
-			if (!vmas_tmp)
-				return -ENOMEM;
-		}
+	if (gup_flags & FOLL_LONGTERM)
 		flags = memalloc_nocma_save();
-	}
 
-	rc = __get_user_pages_locked(mm, start, nr_pages, pages,
-				     vmas_tmp, NULL, gup_flags);
+	rc = __get_user_pages_locked(mm, start, nr_pages, pages, vmas, NULL,
+				     gup_flags);
 
 	if (gup_flags & FOLL_LONGTERM) {
-		if (rc < 0)
-			goto out;
-
-		if (check_dax_vmas(vmas_tmp, rc)) {
-			if (gup_flags & FOLL_PIN)
-				unpin_user_pages(pages, rc);
-			else
-				for (i = 0; i < rc; i++)
-					put_page(pages[i]);
-			rc = -EOPNOTSUPP;
-			goto out;
-		}
-
-		rc = check_and_migrate_cma_pages(mm, start, rc, pages,
-						 vmas_tmp, gup_flags);
-out:
+		if (rc > 0)
+			rc = check_and_migrate_cma_pages(mm, start, rc, pages,
+							 vmas, gup_flags);
 		memalloc_nocma_restore(flags);
 	}
-
-	if (vmas_tmp != vmas)
-		kfree(vmas_tmp);
 	return rc;
 }
-#else /* !CONFIG_FS_DAX && !CONFIG_CMA */
-static __always_inline long __gup_longterm_locked(struct mm_struct *mm,
-						  unsigned long start,
-						  unsigned long nr_pages,
-						  struct page **pages,
-						  struct vm_area_struct **vmas,
-						  unsigned int flags)
-{
-	return __get_user_pages_locked(mm, start, nr_pages, pages, vmas,
-				       NULL, flags);
-}
-#endif /* CONFIG_FS_DAX || CONFIG_CMA */
 
 static bool is_valid_gup_flags(unsigned int gup_flags)
 {
_

Patches currently in -mm which might be from jgg@nvidia.com are

mm-reorganize-internal_get_user_pages_fast.patch
mm-prevent-gup_fast-from-racing-with-cow-during-fork.patch
mm-gup-remove-the-vma-allocation-from-gup_longterm_locked.patch

