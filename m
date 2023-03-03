Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69142C6FA8E
	for <mm-commits@archiver.kernel.org>; Fri,  3 Mar 2023 03:06:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjCCDGq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Mar 2023 22:06:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjCCDGp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Mar 2023 22:06:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E0EEB5C
        for <mm-commits@vger.kernel.org>; Thu,  2 Mar 2023 19:06:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6C9EB8163D
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 03:06:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C64AC433D2;
        Fri,  3 Mar 2023 03:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677812801;
        bh=stChv5p2XVviyhxTF/gvrfK9haQIGw9RubI/E72M/es=;
        h=Date:To:From:Subject:From;
        b=kuz0P7SocrJLvXGlcTO7t3SfqsDfTZVyT5RRTcWxvHt5rDGC7Ex133aIH9W/42sBl
         UG/KlgO9bpLOs1eRe2SHQwmkKtMGF0NSBetd1NEoZ0YA7cg1dbXfMHT7ff1I4wMUaz
         iK84VNlQac7PY5NriARsryepqad/D/MvE6hx/jYg=
Date:   Thu, 02 Mar 2023 19:06:40 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        sfr@canb.auug.org.au, pasha.tatashin@soleen.com,
        mathieu.desnoyers@efficios.com, Liam.Howlett@oracle.com,
        laurent.dufour@fr.ibm.com, jgg@ziepe.ca, hughd@google.com,
        error27@gmail.com, dhowells@redhat.com, david@redhat.com,
        surenb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-fault_flag_vma_lock-flag-fix.patch added to mm-unstable branch
Message-Id: <20230303030641.4C64AC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: document FAULT_FLAG_VMA_LOCK flag
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-fault_flag_vma_lock-flag-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-fault_flag_vma_lock-flag-fix.patch

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


--- a/include/linux/mm_types.h~mm-add-fault_flag_vma_lock-flag-fix
+++ a/include/linux/mm_types.h
@@ -1060,6 +1060,7 @@ typedef struct {
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
mm-mmap-write-lock-vmas-in-vma_prepare-before-modifying-them-fix.patch
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

