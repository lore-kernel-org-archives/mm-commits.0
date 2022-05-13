Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3324C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:21:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383674AbiEMTVY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383678AbiEMTVB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:21:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 077AF1156
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:20:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9881562246
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:20:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC7C7C34113;
        Fri, 13 May 2022 19:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469653;
        bh=Kcl/vl0cHfF+ler/mBiSs3PPaxx3YGgbsZaBclr3tzo=;
        h=Date:To:From:Subject:From;
        b=aVtyhgd+5URr4Zi9HxzjyqBchyS3HqCsVeKWuJ/hDzZupiLakjbowibdm1u6Tt6Tb
         ip8n2R91F6yk8uAI+k2h8GRDp6b1IS3w91LsrgRv4vVpIMSuQOgYZDwrXudfEgwfvr
         oA9ZCFntJByf1aPt/1GOLOy5s1ZoMScBnyNhH3hA=
Date:   Fri, 13 May 2022 12:20:52 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rppt@linux.vnet.ibm.com, nadav.amit@gmail.com,
        mike.kravetz@oracle.com, kirill@shutemov.name, jglisse@redhat.com,
        hughd@google.com, david@redhat.com, axelrasmussen@google.com,
        apopple@nvidia.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-take-care-of-uffdio_copy_mode_wp.patch removed from -mm tree
Message-Id: <20220513192052.EC7C7C34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/shmem: take care of UFFDIO_COPY_MODE_WP
has been removed from the -mm tree.  Its filename was
     mm-shmem-take-care-of-uffdio_copy_mode_wp.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/shmem: take care of UFFDIO_COPY_MODE_WP

Pass wp_copy into shmem_mfill_atomic_pte() through the stack, then apply
the UFFD_WP bit properly when the UFFDIO_COPY on shmem is with
UFFDIO_COPY_MODE_WP.  wp_copy lands mfill_atomic_install_pte() finally.

Note: we must do pte_wrprotect() if !writable in
mfill_atomic_install_pte(), as mk_pte() could return a writable pte (e.g.,
when VM_SHARED on a shmem file).

Link: https://lkml.kernel.org/r/20220405014841.14185-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |    4 ++--
 mm/shmem.c               |    4 ++--
 mm/userfaultfd.c         |   23 ++++++++++++++++++-----
 3 files changed, 22 insertions(+), 9 deletions(-)

--- a/include/linux/shmem_fs.h~mm-shmem-take-care-of-uffdio_copy_mode_wp
+++ a/include/linux/shmem_fs.h
@@ -145,11 +145,11 @@ extern int shmem_mfill_atomic_pte(struct
 				  struct vm_area_struct *dst_vma,
 				  unsigned long dst_addr,
 				  unsigned long src_addr,
-				  bool zeropage,
+				  bool zeropage, bool wp_copy,
 				  struct page **pagep);
 #else /* !CONFIG_SHMEM */
 #define shmem_mfill_atomic_pte(dst_mm, dst_pmd, dst_vma, dst_addr, \
-			       src_addr, zeropage, pagep)       ({ BUG(); 0; })
+			       src_addr, zeropage, wp_copy, pagep) ({ BUG(); 0; })
 #endif /* CONFIG_SHMEM */
 #endif /* CONFIG_USERFAULTFD */
 
--- a/mm/shmem.c~mm-shmem-take-care-of-uffdio_copy_mode_wp
+++ a/mm/shmem.c
@@ -2319,7 +2319,7 @@ int shmem_mfill_atomic_pte(struct mm_str
 			   struct vm_area_struct *dst_vma,
 			   unsigned long dst_addr,
 			   unsigned long src_addr,
-			   bool zeropage,
+			   bool zeropage, bool wp_copy,
 			   struct page **pagep)
 {
 	struct inode *inode = file_inode(dst_vma->vm_file);
@@ -2392,7 +2392,7 @@ int shmem_mfill_atomic_pte(struct mm_str
 		goto out_release;
 
 	ret = mfill_atomic_install_pte(dst_mm, dst_pmd, dst_vma, dst_addr,
-				       page, true, false);
+				       page, true, wp_copy);
 	if (ret)
 		goto out_delete_from_cache;
 
--- a/mm/userfaultfd.c~mm-shmem-take-care-of-uffdio_copy_mode_wp
+++ a/mm/userfaultfd.c
@@ -78,10 +78,19 @@ int mfill_atomic_install_pte(struct mm_s
 	 * Always mark a PTE as write-protected when needed, regardless of
 	 * VM_WRITE, which the user might change.
 	 */
-	if (wp_copy)
+	if (wp_copy) {
 		_dst_pte = pte_mkuffd_wp(_dst_pte);
-	else if (writable)
+		writable = false;
+	}
+
+	if (writable)
 		_dst_pte = pte_mkwrite(_dst_pte);
+	else
+		/*
+		 * We need this to make sure write bit removed; as mk_pte()
+		 * could return a pte with write bit set.
+		 */
+		_dst_pte = pte_wrprotect(_dst_pte);
 
 	dst_pte = pte_offset_map_lock(dst_mm, dst_pmd, dst_addr, &ptl);
 
@@ -96,7 +105,12 @@ int mfill_atomic_install_pte(struct mm_s
 	}
 
 	ret = -EEXIST;
-	if (!pte_none(*dst_pte))
+	/*
+	 * We allow to overwrite a pte marker: consider when both MISSING|WP
+	 * registered, we firstly wr-protect a none pte which has no page cache
+	 * page backing it, then access the page.
+	 */
+	if (!pte_none_mostly(*dst_pte))
 		goto out_unlock;
 
 	if (page_in_cache) {
@@ -480,11 +494,10 @@ static __always_inline ssize_t mfill_ato
 			err = mfill_zeropage_pte(dst_mm, dst_pmd,
 						 dst_vma, dst_addr);
 	} else {
-		VM_WARN_ON_ONCE(wp_copy);
 		err = shmem_mfill_atomic_pte(dst_mm, dst_pmd, dst_vma,
 					     dst_addr, src_addr,
 					     mode != MCOPY_ATOMIC_NORMAL,
-					     page);
+					     wp_copy, page);
 	}
 
 	return err;
_

Patches currently in -mm which might be from peterx@redhat.com are


