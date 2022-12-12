Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFAB2C001B2
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:13:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbiLLCNz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:13:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbiLLCNl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:13:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B298ABE36
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:13:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE124B80B6A
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:13:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2B4C433F0;
        Mon, 12 Dec 2022 02:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811216;
        bh=IEJKUGblZX+hNmaSPBjKEqta1qmYlzPcIeozFC32uqo=;
        h=Date:To:From:Subject:From;
        b=NRJgxMG4n+beh/z+Bsi4qq1Ns3atolVUhX5OLGl5Q8fEzJHC9Y+3BR8Jxfdf/cXX6
         TTvLMuLfXlb2Q/eMGS1tuKZcTnMurBOoeD+zv23KD0ZaIE6VEkkO2/YpwHtx0gliFP
         b37TD9mhQzEJ8xesPOy9hvmfb1U/aepcsDiGnWVc=
Date:   Sun, 11 Dec 2022 18:13:35 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shuah@kernel.org, peterx@redhat.com, jhubbard@nvidia.com,
        jgg@nvidia.com, hughd@google.com, aarcange@redhat.com,
        david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-vm_fault_write.patch removed from -mm tree
Message-Id: <20221212021336.8F2B4C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove VM_FAULT_WRITE
has been removed from the -mm tree.  Its filename was
     mm-remove-vm_fault_write.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -929,7 +929,6 @@ typedef __bitwise unsigned int vm_fault_
  * @VM_FAULT_OOM:		Out Of Memory
  * @VM_FAULT_SIGBUS:		Bad access
  * @VM_FAULT_MAJOR:		Page read from storage
- * @VM_FAULT_WRITE:		Special case for get_user_pages
  * @VM_FAULT_HWPOISON:		Hit poisoned small page
  * @VM_FAULT_HWPOISON_LARGE:	Hit poisoned large page. Index encoded
  *				in upper bits
@@ -950,7 +949,6 @@ enum vm_fault_reason {
 	VM_FAULT_OOM            = (__force vm_fault_t)0x000001,
 	VM_FAULT_SIGBUS         = (__force vm_fault_t)0x000002,
 	VM_FAULT_MAJOR          = (__force vm_fault_t)0x000004,
-	VM_FAULT_WRITE          = (__force vm_fault_t)0x000008,
 	VM_FAULT_HWPOISON       = (__force vm_fault_t)0x000010,
 	VM_FAULT_HWPOISON_LARGE = (__force vm_fault_t)0x000020,
 	VM_FAULT_SIGSEGV        = (__force vm_fault_t)0x000040,
@@ -976,7 +974,6 @@ enum vm_fault_reason {
 	{ VM_FAULT_OOM,                 "OOM" },	\
 	{ VM_FAULT_SIGBUS,              "SIGBUS" },	\
 	{ VM_FAULT_MAJOR,               "MAJOR" },	\
-	{ VM_FAULT_WRITE,               "WRITE" },	\
 	{ VM_FAULT_HWPOISON,            "HWPOISON" },	\
 	{ VM_FAULT_HWPOISON_LARGE,      "HWPOISON_LARGE" },	\
 	{ VM_FAULT_SIGSEGV,             "SIGSEGV" },	\
--- a/mm/huge_memory.c~mm-remove-vm_fault_write
+++ a/mm/huge_memory.c
@@ -1376,7 +1376,7 @@ reuse:
 		if (pmdp_set_access_flags(vma, haddr, vmf->pmd, entry, 1))
 			update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);
 		spin_unlock(vmf->ptl);
-		return VM_FAULT_WRITE;
+		return 0;
 	}
 
 unlock_fallback:
--- a/mm/memory.c~mm-remove-vm_fault_write
+++ a/mm/memory.c
@@ -3213,7 +3213,7 @@ static vm_fault_t wp_page_copy(struct vm
 	}
 
 	delayacct_wpcopy_end();
-	return (page_copied && !unshare) ? VM_FAULT_WRITE : 0;
+	return 0;
 oom_free_new:
 	put_page(new_page);
 oom:
@@ -3277,14 +3277,14 @@ static vm_fault_t wp_pfn_shared(struct v
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
 
@@ -3430,7 +3430,7 @@ reuse:
 			return 0;
 		}
 		wp_page_reuse(vmf);
-		return VM_FAULT_WRITE;
+		return 0;
 	}
 copy:
 	/*
@@ -3944,7 +3944,6 @@ vm_fault_t do_swap_page(struct vm_fault
 		if (vmf->flags & FAULT_FLAG_WRITE) {
 			pte = maybe_mkwrite(pte_mkdirty(pte), vma);
 			vmf->flags &= ~FAULT_FLAG_WRITE;
-			ret |= VM_FAULT_WRITE;
 		}
 		rmap_flags |= RMAP_EXCLUSIVE;
 	}
_

Patches currently in -mm which might be from david@redhat.com are


