Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8703C7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:58:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbjDFC6K (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234554AbjDFC5z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:57:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23DF0E72
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:57:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 757DE62D65
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:57:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0085C433D2;
        Thu,  6 Apr 2023 02:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749872;
        bh=eaylHya19dfbjh1IDmMdU2p66vKJK625DwTy5t3GOAk=;
        h=Date:To:From:Subject:From;
        b=0QyGeCL6Is3RwyJhggLgJ/cb80DTMP1e75PtQ54kKMDydyc3P2ArBGrupOKpup3/N
         QS4UZfcfeYvSOPb5M3spVOYwo0ajQM/KpAWUGx2JcxTcUx9/mTAJ9YQ7zP9k5kqfQt
         sYdFIJdm86KIRGCisLmyLru3BdAWcbaxttI+D62o=
Date:   Wed, 05 Apr 2023 19:57:52 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        sfr@canb.auug.org.au, pasha.tatashin@soleen.com,
        mathieu.desnoyers@efficios.com, lkp@intel.com,
        Liam.Howlett@oracle.com, laurent.dufour@fr.ibm.com, jgg@ziepe.ca,
        hughd@google.com, error27@gmail.com, dhowells@redhat.com,
        david@redhat.com, surenb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-mmap-write-lock-vmas-in-vma_prepare-before-modifying-them-fix.patch removed from -mm tree
Message-Id: <20230406025752.D0085C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap: remove unnecessary vp->vma check in vma_prepare
has been removed from the -mm tree.  Its filename was
     mm-mmap-write-lock-vmas-in-vma_prepare-before-modifying-them-fix.patch

This patch was dropped because it was folded into mm-mmap-write-lock-vmas-in-vma_prepare-before-modifying-them.patch

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm/mmap: remove unnecessary vp->vma check in vma_prepare
Date: Tue, 28 Feb 2023 18:27:19 -0800

vp->vma in vma_prepare() is always non-NULL, therefore checking it is not
necessary.  Remove the extra check.

Link: https://lkml.kernel.org/r/20230301022720.1380780-1-surenb@google.com
Fixes: e8f071350ea5 ("mm/mmap: write-lock VMAs in vma_prepare before modifying them")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
  Link: https://lore.kernel.org/r/202302281802.J93Nma7q-lkp@intel.com/
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Laurent Dufour <laurent.dufour@fr.ibm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/mmap.c~mm-mmap-write-lock-vmas-in-vma_prepare-before-modifying-them-fix
+++ a/mm/mmap.c
@@ -502,8 +502,7 @@ static inline void init_vma_prep(struct
  */
 static inline void vma_prepare(struct vma_prepare *vp)
 {
-	if (vp->vma)
-		vma_start_write(vp->vma);
+	vma_start_write(vp->vma);
 	if (vp->adj_next)
 		vma_start_write(vp->adj_next);
 	/* vp->insert is always a newly created VMA, no need for locking */
_

Patches currently in -mm which might be from surenb@google.com are

mm-introduce-config_per_vma_lock.patch
mm-move-mmap_lock-assert-function-definitions.patch
mm-add-per-vma-lock-and-helper-functions-to-control-it.patch
mm-mark-vma-as-being-written-when-changing-vm_flags.patch
mm-mmap-move-vma_prepare-before-vma_adjust_trans_huge.patch
mm-khugepaged-write-lock-vma-while-collapsing-a-huge-page.patch
mm-mmap-write-lock-vmas-in-vma_prepare-before-modifying-them.patch
mm-mremap-write-lock-vma-while-remapping-it-to-a-new-address-range.patch
mm-write-lock-vmas-before-removing-them-from-vma-tree.patch
mm-write-lock-vmas-before-removing-them-from-vma-tree-fix.patch
mm-conditionally-write-lock-vma-in-free_pgtables.patch
kernel-fork-assert-no-vma-readers-during-its-destruction.patch
mm-mmap-prevent-pagefault-handler-from-racing-with-mmu_notifier-registration.patch
mm-introduce-vma-detached-flag.patch
mm-introduce-lock_vma_under_rcu-to-be-used-from-arch-specific-code.patch
mm-fall-back-to-mmap_lock-if-vma-anon_vma-is-not-yet-set.patch
mm-add-fault_flag_vma_lock-flag.patch
mm-add-fault_flag_vma_lock-flag-fix.patch
mm-prevent-do_swap_page-from-handling-page-faults-under-vma-lock.patch
mm-prevent-userfaults-to-be-handled-under-per-vma-lock.patch
mm-introduce-per-vma-lock-statistics.patch
x86-mm-try-vma-lock-based-page-fault-handling-first.patch
arm64-mm-try-vma-lock-based-page-fault-handling-first.patch
mm-mmap-free-vm_area_struct-without-call_rcu-in-exit_mmap.patch
mm-separate-vma-lock-from-vm_area_struct.patch

