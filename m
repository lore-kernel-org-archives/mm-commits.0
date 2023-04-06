Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 936FBC7619A
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:59:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235043AbjDFC72 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234554AbjDFC71 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:59:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C8E5FCF
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:59:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0284864125
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:59:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D3CFC433D2;
        Thu,  6 Apr 2023 02:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749965;
        bh=HFU1lX7yuVw2PDulPMWbDD5bNrKXtmXbeaAaPRwO9h8=;
        h=Date:To:From:Subject:From;
        b=D6R3EfDZCkL28i0Rxzr1WEYKkpWq9Wq1UB/xE0opwJElE2AYib5LQsIO0zYlHGwPm
         RCL9TrU+gF69rUjahXkwFiZdWJwbaU06I8uiuA6ix25BBFNhoR32gBvyHkKKPk483x
         k0nOoPN1bLrSQTbR+J8qz7xcZqUpQ6AtNPGCw9Uw=
Date:   Wed, 05 Apr 2023 19:59:24 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        sfr@canb.auug.org.au, pasha.tatashin@soleen.com,
        mathieu.desnoyers@efficios.com, Liam.Howlett@oracle.com,
        laurent.dufour@fr.ibm.com, jgg@ziepe.ca, hughd@google.com,
        error27@gmail.com, dhowells@redhat.com, david@redhat.com,
        surenb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-fault_flag_vma_lock-flag-fix.patch removed from -mm tree
Message-Id: <20230406025925.5D3CFC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: document FAULT_FLAG_VMA_LOCK flag
has been removed from the -mm tree.  Its filename was
     mm-add-fault_flag_vma_lock-flag-fix.patch

This patch was dropped because it was folded into mm-add-fault_flag_vma_lock-flag.patch

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: document FAULT_FLAG_VMA_LOCK flag
Date: Tue, 28 Feb 2023 18:27:20 -0800

FAULT_FLAG_VMA_LOCK flag was introduced without proper description.  Fix
this by documenting it.

Link: https://lkml.kernel.org/r/20230301022720.1380780-2-surenb@google.com
Fixes: 863be34fc093 ("mm: add FAULT_FLAG_VMA_LOCK flag")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
  Link: https://lore.kernel.org/all/20230301113648.7c279865@canb.auug.org.au/
Cc: Dan Carpenter <error27@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Laurent Dufour <laurent.dufour@fr.ibm.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/mm_types.h~mm-add-fault_flag_vma_lock-flag-fix
+++ a/include/linux/mm_types.h
@@ -1055,6 +1055,7 @@ typedef struct {
  *                      mapped after the fault.
  * @FAULT_FLAG_ORIG_PTE_VALID: whether the fault has vmf->orig_pte cached.
  *                        We should only access orig_pte if this flag set.
+ * @FAULT_FLAG_VMA_LOCK: The fault is handled under VMA lock.
  *
  * About @FAULT_FLAG_ALLOW_RETRY and @FAULT_FLAG_TRIED: we can specify
  * whether we would allow page faults to retry by specifying these two
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
mm-conditionally-write-lock-vma-in-free_pgtables.patch
kernel-fork-assert-no-vma-readers-during-its-destruction.patch
mm-mmap-prevent-pagefault-handler-from-racing-with-mmu_notifier-registration.patch
mm-introduce-vma-detached-flag.patch
mm-introduce-lock_vma_under_rcu-to-be-used-from-arch-specific-code.patch
mm-fall-back-to-mmap_lock-if-vma-anon_vma-is-not-yet-set.patch
mm-add-fault_flag_vma_lock-flag.patch
mm-prevent-do_swap_page-from-handling-page-faults-under-vma-lock.patch
mm-prevent-userfaults-to-be-handled-under-per-vma-lock.patch
mm-introduce-per-vma-lock-statistics.patch
x86-mm-try-vma-lock-based-page-fault-handling-first.patch
arm64-mm-try-vma-lock-based-page-fault-handling-first.patch
mm-mmap-free-vm_area_struct-without-call_rcu-in-exit_mmap.patch
mm-separate-vma-lock-from-vm_area_struct.patch

