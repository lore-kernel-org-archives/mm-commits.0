Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 575B4C64ED6
	for <mm-commits@archiver.kernel.org>; Thu, 23 Feb 2023 22:13:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjBWWNm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Feb 2023 17:13:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjBWWNl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2023 17:13:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 770661A66D
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2023 14:13:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67456617AC
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2023 22:13:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A0EC433EF;
        Thu, 23 Feb 2023 22:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677190419;
        bh=pTw0xmrw4CNq5snKoSFRspJVDDO7YVWG3m+zIzLrBUs=;
        h=Date:To:From:Subject:From;
        b=TDxoILK7qOSLtyQBEv5woI0tVb2QEO1Wk7im72WNkdUTMqmkfB/OkrwjvtqD0lUrJ
         t0YOunAglCL59hEOyj9Gxm8Qz+Fhn7JduAGc1kvtaHDhyMfLDEX8DXDIcPQ9BRxjoi
         Jn79nRKtVWQj2sREyPYFWK/2LvYvBxgXWGMiW5y8=
Date:   Thu, 23 Feb 2023 14:13:38 -0800
To:     mm-commits@vger.kernel.org, toshi.kani@hp.com,
        syzbot+5f488e922d047d8f00cc@syzkaller.appspotmail.com,
        suresh.b.siddha@intel.com, peterz@infradead.org, luto@kernel.org,
        dave.hansen@linux.intel.com, bp@suse.de, mawupeng1@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-mm-pat-clear-vm_pat-if-copy_p4d_range-failed.patch added to mm-unstable branch
Message-Id: <20230223221339.60A0EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86/mm/pat: clear VM_PAT if copy_p4d_range failed
has been added to the -mm mm-unstable branch.  Its filename is
     x86-mm-pat-clear-vm_pat-if-copy_p4d_range-failed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-mm-pat-clear-vm_pat-if-copy_p4d_range-failed.patch

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
From: Ma Wupeng <mawupeng1@huawei.com>
Subject: x86/mm/pat: clear VM_PAT if copy_p4d_range failed
Date: Fri, 17 Feb 2023 10:56:15 +0800

Syzbot reports a warning in untrack_pfn().  Digging into the root we found
that this is due to memory allocation failure in pmd_alloc_one.  And this
failure is produced due to failslab.

In copy_page_range(), memory alloaction for pmd failed.  During the error
handling process in copy_page_range(), mmput() is called to remove all
vmas.  While untrack_pfn this empty pfn, warning happens.

Here's a simplified flow:

dup_mm
  dup_mmap
    copy_page_range
      copy_p4d_range
        copy_pud_range
          copy_pmd_range
            pmd_alloc
              __pmd_alloc
                pmd_alloc_one
                  page = alloc_pages(gfp, 0);
                    if (!page)
                      return NULL;
    mmput
        exit_mmap
          unmap_vmas
            unmap_single_vma
              untrack_pfn
                follow_phys
                  WARN_ON_ONCE(1);

Since this vma is not generate successfully, we can clear flag VM_PAT.  In
this case, untrack_pfn() will not be called while cleaning this vma.

Function untrack_pfn_moved() has also been renamed to fit the new logic.

Link: https://lkml.kernel.org/r/20230217025615.1595558-1-mawupeng1@huawei.com
Signed-off-by: Ma Wupeng <mawupeng1@huawei.com>
Reported-by: <syzbot+5f488e922d047d8f00cc@syzkaller.appspotmail.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pat/memtype.c |   12 ++++++++----
 include/linux/pgtable.h   |    7 ++++---
 mm/memory.c               |    1 +
 mm/mremap.c               |    2 +-
 4 files changed, 14 insertions(+), 8 deletions(-)

--- a/arch/x86/mm/pat/memtype.c~x86-mm-pat-clear-vm_pat-if-copy_p4d_range-failed
+++ a/arch/x86/mm/pat/memtype.c
@@ -1074,11 +1074,15 @@ void untrack_pfn(struct vm_area_struct *
 }
 
 /*
- * untrack_pfn_moved is called, while mremapping a pfnmap for a new region,
- * with the old vma after its pfnmap page table has been removed.  The new
- * vma has a new pfnmap to the same pfn & cache type with VM_PAT set.
+ * untrack_pfn_clear is called if the following situation fits:
+ *
+ * 1) while mremapping a pfnmap for a new region,  with the old vma after
+ * its pfnmap page table has been removed.  The new vma has a new pfnmap
+ * to the same pfn & cache type with VM_PAT set.
+ * 2) while duplicating vm area, the new vma fails to copy the pgtable from
+ * old vma.
  */
-void untrack_pfn_moved(struct vm_area_struct *vma)
+void untrack_pfn_clear(struct vm_area_struct *vma)
 {
 	vm_flags_clear(vma, VM_PAT);
 }
--- a/include/linux/pgtable.h~x86-mm-pat-clear-vm_pat-if-copy_p4d_range-failed
+++ a/include/linux/pgtable.h
@@ -1191,9 +1191,10 @@ static inline void untrack_pfn(struct vm
 }
 
 /*
- * untrack_pfn_moved is called while mremapping a pfnmap for a new region.
+ * untrack_pfn_clear is called while mremapping a pfnmap for a new region
+ * or fails to copy pgtable during duplicate vm area.
  */
-static inline void untrack_pfn_moved(struct vm_area_struct *vma)
+static inline void untrack_pfn_clear(struct vm_area_struct *vma)
 {
 }
 #else
@@ -1205,7 +1206,7 @@ extern void track_pfn_insert(struct vm_a
 extern int track_pfn_copy(struct vm_area_struct *vma);
 extern void untrack_pfn(struct vm_area_struct *vma, unsigned long pfn,
 			unsigned long size, bool mm_wr_locked);
-extern void untrack_pfn_moved(struct vm_area_struct *vma);
+extern void untrack_pfn_clear(struct vm_area_struct *vma);
 #endif
 
 #ifdef CONFIG_MMU
--- a/mm/memory.c~x86-mm-pat-clear-vm_pat-if-copy_p4d_range-failed
+++ a/mm/memory.c
@@ -1290,6 +1290,7 @@ copy_page_range(struct vm_area_struct *d
 			continue;
 		if (unlikely(copy_p4d_range(dst_vma, src_vma, dst_pgd, src_pgd,
 					    addr, next))) {
+			untrack_pfn_clear(dst_vma);
 			ret = -ENOMEM;
 			break;
 		}
--- a/mm/mremap.c~x86-mm-pat-clear-vm_pat-if-copy_p4d_range-failed
+++ a/mm/mremap.c
@@ -683,7 +683,7 @@ static unsigned long move_vma(struct vm_
 
 	/* Tell pfnmap has moved from this vma */
 	if (unlikely(vma->vm_flags & VM_PFNMAP))
-		untrack_pfn_moved(vma);
+		untrack_pfn_clear(vma);
 
 	if (unlikely(!err && (flags & MREMAP_DONTUNMAP))) {
 		/* We always clear VM_LOCKED[ONFAULT] on the old vma */
_

Patches currently in -mm which might be from mawupeng1@huawei.com are

x86-mm-pat-clear-vm_pat-if-copy_p4d_range-failed.patch

