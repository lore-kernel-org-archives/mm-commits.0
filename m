Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 360F5C43334
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jul 2022 01:04:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbiGQBET (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 16 Jul 2022 21:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbiGQBES (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 16 Jul 2022 21:04:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31ACB4A9
        for <mm-commits@vger.kernel.org>; Sat, 16 Jul 2022 18:04:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A73C3B80D28
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 01:04:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48353C34114;
        Sun, 17 Jul 2022 01:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658019852;
        bh=xyTQlI9UeMcS3KqyDODj/VHvMAaUpnkS+NplDgmWC6w=;
        h=Date:To:From:Subject:From;
        b=16pcd1SNep/yaXiob9AKShtDV4FIKFusghBxvsNlWVrTnrKo7xymR3eL71+Lnhhmf
         19OBFBt0DzYDVit9rnKpbMH/IEXD95lH2s8CBId3d5a3JP6QDLu/qA5ZgBCUaiM9xt
         bRSPhZYkF0wG376MO8XNLpk8WjZ09Kyqwvgzwt9Y=
Date:   Sat, 16 Jul 2022 18:04:11 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        vbabka@suse.cz, tsbogend@alpha.franken.de, songliubraving@fb.com,
        sj@kernel.org, shy828301@gmail.com, rongwei.wang@linux.alibaba.com,
        rientjes@google.com, peterx@redhat.com, pasha.tatashin@soleen.com,
        minchan@kernel.org, mhocko@suse.com, mattst88@gmail.com,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        jcmvbkbc@gmail.com, James.Bottomley@HansenPartnership.com,
        ink@jurassic.park.msu.ru, hughd@google.com, deller@gmx.de,
        david@redhat.com, ckennelly@google.com, chris@zankel.net,
        axelrasmussen@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        arnd@arndb.de, alex.shi@linux.alibaba.com, aarcange@redhat.com,
        zokeefe@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] proc-smaps-add-pmdmappable-field-to-smaps.patch removed from -mm tree
Message-Id: <20220717010412.48353C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: proc/smaps: add PMDMappable field to smaps
has been removed from the -mm tree.  Its filename was
     proc-smaps-add-pmdmappable-field-to-smaps.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: "Zach O'Keefe" <zokeefe@google.com>
Subject: proc/smaps: add PMDMappable field to smaps
Date: Wed, 6 Jul 2022 16:59:31 -0700

Add PMDMappable field to smaps output which informs the user if memory in
the VMA can be PMD-mapped by MADV_COLLAPSE.

The distinction from THPeligible is needed for two reasons:

1) For THP, MADV_COLLAPSE is not coupled to THP sysfs controls, which
   THPeligible reports.

2) PMDMappable can also be used in HugeTLB fine-granularity mappings,
   which are independent from THP.

Link: https://lkml.kernel.org/r/20220706235936.2197195-14-zokeefe@google.com
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Kennelly <ckennelly@google.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rongwei Wang <rongwei.wang@linux.alibaba.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |   10 ++++++++--
 fs/proc/task_mmu.c                 |    2 ++
 2 files changed, 10 insertions(+), 2 deletions(-)

--- a/Documentation/filesystems/proc.rst~proc-smaps-add-pmdmappable-field-to-smaps
+++ a/Documentation/filesystems/proc.rst
@@ -466,6 +466,7 @@ Memory Area, or VMA) there is a series o
     MMUPageSize:           4 kB
     Locked:                0 kB
     THPeligible:           0
+    PMDMappable:           0
     VmFlags: rd ex mr mw me dw
 
 The first of these lines shows the same information as is displayed for the
@@ -518,9 +519,14 @@ replaced by copy-on-write) part of the u
 does not take into account swapped out page of underlying shmem objects.
 "Locked" indicates whether the mapping is locked in memory or not.
 
+"PMDMappable" indicates if the memory can be mapped by PMDs - 1 if true, 0
+otherwise.  It just shows the current status. Note that this is memory
+operable on explicitly by MADV_COLLAPSE.
+
 "THPeligible" indicates whether the mapping is eligible for allocating THP
-pages as well as the THP is PMD mappable or not - 1 if true, 0 otherwise.
-It just shows the current status.
+pages by the kernel, as well as the THP is PMD mappable or not - 1 if true, 0
+otherwise. It just shows the current status.  Note this is memory the kernel can
+transparently provide as THPs.
 
 "VmFlags" field deserves a separate description. This member represents the
 kernel flags associated with the particular virtual memory area in two letter
--- a/fs/proc/task_mmu.c~proc-smaps-add-pmdmappable-field-to-smaps
+++ a/fs/proc/task_mmu.c
@@ -867,6 +867,8 @@ static int show_smap(struct seq_file *m,
 
 	seq_printf(m, "THPeligible:    %d\n",
 		   hugepage_vma_check(vma, vma->vm_flags, true, false, true));
+	seq_printf(m, "PMDMappable:    %d\n",
+		   hugepage_vma_check(vma, vma->vm_flags, true, false, false));
 
 	if (arch_pkeys_enabled())
 		seq_printf(m, "ProtectionKey:  %8u\n", vma_pkey(vma));
_

Patches currently in -mm which might be from zokeefe@google.com are

mm-khugepaged-remove-redundant-transhuge_vma_suitable-check.patch
mm-khugepaged-add-struct-collapse_control.patch
mm-khugepaged-dedup-and-simplify-hugepage-alloc-and-charging.patch
mm-khugepaged-pipe-enum-scan_result-codes-back-to-callers.patch
mm-khugepaged-add-flag-to-predicate-khugepaged-only-behavior.patch
mm-thp-add-flag-to-enforce-sysfs-thp-in-hugepage_vma_check.patch
mm-khugepaged-record-scan_pmd_mapped-when-scan_pmd-finds-hugepage.patch
mm-madvise-introduce-madv_collapse-sync-hugepage-collapse.patch
mm-madvise-introduce-madv_collapse-sync-hugepage-collapse-fix-2.patch
mm-khugepaged-rename-prefix-of-shared-collapse-functions.patch
mm-madvise-add-huge_memory-mm_madvise_collapse-tracepoint.patch
mm-madvise-add-madv_collapse-to-process_madvise.patch
selftests-vm-modularize-collapse-selftests.patch
selftests-vm-dedup-hugepage-allocation-logic.patch
selftests-vm-add-madv_collapse-collapse-context-to-selftests.patch
selftests-vm-add-selftest-to-verify-recollapse-of-thps.patch
selftests-vm-add-selftest-to-verify-multi-thp-collapse.patch

