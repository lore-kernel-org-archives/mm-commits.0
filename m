Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E917C3A59D
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 20:02:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbiJUUCY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Oct 2022 16:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbiJUUCB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Oct 2022 16:02:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F24F2625CF
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 13:01:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23BFC61F6F
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 20:01:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC8BC433C1;
        Fri, 21 Oct 2022 20:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666382508;
        bh=3BY+iSwMIEuN7D82smPoN23kBZZMMnQkWdp+QknAzhY=;
        h=Date:To:From:Subject:From;
        b=wv8zkYjFToChhA4hLSQkgM0Z5T5owyWBLJt5mm91bFmkrmc2uTUmFaqvIPrt9BZI+
         bAFRASwPzUZH30R+dT+WL8Ru+GA5bo6D8jQiRXWo0yd4gjP89dVfhLpQIfQYKBwrmn
         nrVNxnQkoOGQDHAfnKiUIZMfjDOriwM5N0BbpDTE=
Date:   Fri, 21 Oct 2022 13:01:48 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shuah@kernel.org, peterx@redhat.com, jhubbard@nvidia.com,
        jgg@nvidia.com, hughd@google.com, aarcange@redhat.com,
        david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-vm_fault_write.patch added to mm-unstable branch
Message-Id: <20221021200148.7AC8BC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove VM_FAULT_WRITE
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-vm_fault_write.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-vm_fault_write.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm: remove VM_FAULT_WRITE
Date: Fri, 21 Oct 2022 12:11:35 +0200

All users -- GUP and KSM -- are gone, let's just remove it.

Link: https://lkml.kernel.org/r/20221021101141.84170-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    3 ---
 mm/huge_memory.c         |    2 +-
 mm/memory.c              |    9 ++++-----
 3 files changed, 5 insertions(+), 9 deletions(-)

--- a/include/linux/mm_types.h~mm-remove-vm_fault_write
+++ a/include/linux/mm_types.h
@@ -861,7 +861,6 @@ typedef __bitwise unsigned int vm_fault_
  * @VM_FAULT_OOM:		Out Of Memory
  * @VM_FAULT_SIGBUS:		Bad access
  * @VM_FAULT_MAJOR:		Page read from storage
- * @VM_FAULT_WRITE:		Special case for get_user_pages
  * @VM_FAULT_HWPOISON:		Hit poisoned small page
  * @VM_FAULT_HWPOISON_LARGE:	Hit poisoned large page. Index encoded
  *				in upper bits
@@ -882,7 +881,6 @@ enum vm_fault_reason {
 	VM_FAULT_OOM            = (__force vm_fault_t)0x000001,
 	VM_FAULT_SIGBUS         = (__force vm_fault_t)0x000002,
 	VM_FAULT_MAJOR          = (__force vm_fault_t)0x000004,
-	VM_FAULT_WRITE          = (__force vm_fault_t)0x000008,
 	VM_FAULT_HWPOISON       = (__force vm_fault_t)0x000010,
 	VM_FAULT_HWPOISON_LARGE = (__force vm_fault_t)0x000020,
 	VM_FAULT_SIGSEGV        = (__force vm_fault_t)0x000040,
@@ -908,7 +906,6 @@ enum vm_fault_reason {
 	{ (__force unsigned int) VM_FAULT_OOM,                 "OOM" },	\
 	{ (__force unsigned int) VM_FAULT_SIGBUS,              "SIGBUS" },	\
 	{ (__force unsigned int) VM_FAULT_MAJOR,               "MAJOR" },	\
-	{ (__force unsigned int) VM_FAULT_WRITE,               "WRITE" },	\
 	{ (__force unsigned int) VM_FAULT_HWPOISON,            "HWPOISON" },	\
 	{ (__force unsigned int) VM_FAULT_HWPOISON_LARGE,      "HWPOISON_LARGE" },	\
 	{ (__force unsigned int) VM_FAULT_SIGSEGV,             "SIGSEGV" },	\
--- a/mm/huge_memory.c~mm-remove-vm_fault_write
+++ a/mm/huge_memory.c
@@ -1333,7 +1333,7 @@ reuse:
 		if (pmdp_set_access_flags(vma, haddr, vmf->pmd, entry, 1))
 			update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);
 		spin_unlock(vmf->ptl);
-		return VM_FAULT_WRITE;
+		return 0;
 	}
 
 unlock_fallback:
--- a/mm/memory.c~mm-remove-vm_fault_write
+++ a/mm/memory.c
@@ -3242,7 +3242,7 @@ static vm_fault_t wp_page_copy(struct vm
 	}
 
 	delayacct_wpcopy_end();
-	return (page_copied && !unshare) ? VM_FAULT_WRITE : 0;
+	return 0;
 oom_free_new:
 	put_page(new_page);
 oom:
@@ -3306,14 +3306,14 @@ static vm_fault_t wp_pfn_shared(struct v
 		return finish_mkwrite_fault(vmf);
 	}
 	wp_page_reuse(vmf);
-	return VM_FAULT_WRITE;
+	return 0;
 }
 
 static vm_fault_t wp_page_shared(struct vm_fault *vmf)
 	__releases(vmf->ptl)
 {
 	struct vm_area_struct *vma = vmf->vma;
-	vm_fault_t ret = VM_FAULT_WRITE;
+	vm_fault_t ret = 0;
 
 	get_page(vmf->page);
 
@@ -3464,7 +3464,7 @@ reuse:
 			return 0;
 		}
 		wp_page_reuse(vmf);
-		return VM_FAULT_WRITE;
+		return 0;
 	} else if (unshare) {
 		/* No anonymous page -> nothing to do. */
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
@@ -3983,7 +3983,6 @@ vm_fault_t do_swap_page(struct vm_fault
 		if (vmf->flags & FAULT_FLAG_WRITE) {
 			pte = maybe_mkwrite(pte_mkdirty(pte), vma);
 			vmf->flags &= ~FAULT_FLAG_WRITE;
-			ret |= VM_FAULT_WRITE;
 		}
 		rmap_flags |= RMAP_EXCLUSIVE;
 	}
_

Patches currently in -mm which might be from david@redhat.com are

selftests-vm-anon_cow-test-cow-handling-of-anonymous-memory.patch
selftests-vm-factor-out-pagemap_is_populated-into-vm_util.patch
selftests-vm-anon_cow-thp-tests.patch
selftests-vm-anon_cow-hugetlb-tests.patch
selftests-vm-anon_cow-add-liburing-test-cases.patch
mm-gup_test-start-stop-read-functionality-for-pin-longterm-test.patch
mm-gup_test-start-stop-read-functionality-for-pin-longterm-test-fix.patch
selftests-vm-anon_cow-add-r-o-longterm-tests-via-gup_test.patch
selftests-vm-add-ksm-unmerge-tests.patch
mm-pagewalk-dont-trigger-test_walk-in-walk_page_vma.patch
selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch
mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch
mm-remove-vm_fault_write.patch
mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch
mm-pagewalk-add-walk_page_range_vma.patch
mm-ksm-convert-break_ksm-to-use-walk_page_range_vma.patch
mm-gup-remove-foll_migration.patch

