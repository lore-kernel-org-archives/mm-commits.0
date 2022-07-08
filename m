Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3720C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  8 Jul 2022 21:04:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240121AbiGHVEj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Jul 2022 17:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240108AbiGHVEi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2022 17:04:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 622562B196
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 14:04:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6E4F62916
        for <mm-commits@vger.kernel.org>; Fri,  8 Jul 2022 21:04:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E21C341C0;
        Fri,  8 Jul 2022 21:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657314276;
        bh=GhHcBsJTcQ0nu46gjfugdxqUNWfsyX+TKC7ib+H+0h0=;
        h=Date:To:From:Subject:From;
        b=vBkFWjblaS65+6rqbt4hoeCVfigLymposqjBLOLzob/RMNgPilzo+sdNw3OC8ddp6
         xeuLKtxg+h/vfFKuJbJJUGfMIsjSVN8jYRJutzDBich5g9khUvrZwsx/wDuUm+z0Zr
         jA7Et9mfM2SK+9+3kP20AA7UYR19yyf6ftFLI39I=
Date:   Fri, 08 Jul 2022 14:04:35 -0700
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
Subject: + mm-khugepaged-remove-redundant-transhuge_vma_suitable-check.patch added to mm-unstable branch
Message-Id: <20220708210436.18E21C341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: remove redundant transhuge_vma_suitable() check
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-remove-redundant-transhuge_vma_suitable-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-remove-redundant-transhuge_vma_suitable-check.patch

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
From: "Zach O'Keefe" <zokeefe@google.com>
Subject: mm/khugepaged: remove redundant transhuge_vma_suitable() check
Date: Wed, 6 Jul 2022 16:59:19 -0700

Patch series "mm: userspace hugepage collapse", v7.

Introduction
--------------------------------

This series provides a mechanism for userspace to induce a collapse of
eligible ranges of memory into transparent hugepages in process context,
thus permitting users to more tightly control their own hugepage
utilization policy at their own expense.

This idea was introduced by David Rientjes[5].

Interface
--------------------------------

The proposed interface adds a new madvise(2) mode, MADV_COLLAPSE, and
leverages the new process_madvise(2) call.

process_madvise(2)

	Performs a synchronous collapse of the native pages
	mapped by the list of iovecs into transparent hugepages.

	This operation is independent of the system THP sysfs settings,
	but attempts to collapse VMAs marked VM_NOHUGEPAGE will still fail.

	THP allocation may enter direct reclaim and/or compaction.

	When a range spans multiple VMAs, the semantics of the collapse
	over of each VMA is independent from the others.

	Caller must have CAP_SYS_ADMIN if not acting on self.

	Return value follows existing process_madvise(2) conventions.  A
	“success” indicates that all hugepage-sized/aligned regions
	covered by the provided range were either successfully
	collapsed, or were already pmd-mapped THPs.

madvise(2)

	Equivalent to process_madvise(2) on self, with 0 returned on
	“success”.

Current Use-Cases
--------------------------------

(1)	Immediately back executable text by THPs.  Current support provided
	by CONFIG_READ_ONLY_THP_FOR_FS may take a long time on a large
	system which might impair services from serving at their full rated
	load after (re)starting.  Tricks like mremap(2)'ing text onto
	anonymous memory to immediately realize iTLB performance prevents
	page sharing and demand paging, both of which increase steady state
	memory footprint.  With MADV_COLLAPSE, we get the best of both
	worlds: Peak upfront performance and lower RAM footprints.  Note
	that subsequent support for file-backed memory is required here.

(2)	malloc() implementations that manage memory in hugepage-sized
	chunks, but sometimes subrelease memory back to the system in
	native-sized chunks via MADV_DONTNEED; zapping the pmd.  Later,
	when the memory is hot, the implementation could
	madvise(MADV_COLLAPSE) to re-back the memory by THPs to regain
	hugepage coverage and dTLB performance.  TCMalloc is such an
	implementation that could benefit from this[6].  A prior study of
	Google internal workloads during evaluation of Temeraire, a
	hugepage-aware enhancement to TCMalloc, showed that nearly 20% of
	all cpu cycles were spent in dTLB stalls, and that increasing
	hugepage coverage by even small amount can help with that[7].

(3)	userfaultfd-based live migration of virtual machines satisfy UFFD
	faults by fetching native-sized pages over the network (to avoid
	latency of transferring an entire hugepage).  However, after guest
	memory has been fully copied to the new host, MADV_COLLAPSE can
	be used to immediately increase guest performance.  Note that
	subsequent support for file/shmem-backed memory is required here.

(4)	HugeTLB high-granularity mapping allows HugeTLB a HugeTLB page to
	be mapped at different levels in the page tables[8].  As it's not
	"transparent" like THP, HugeTLB high-granularity mappings require
	an explicit user API. It is intended that MADV_COLLAPSE be co-opted
	for this use case[9].  Note that subsequent support for HugeTLB
	memory is required here.

Future work
--------------------------------

Only private anonymous memory is supported by this series. File and
shmem memory support will be added later.

One possible user of this functionality is a userspace agent that
attempts to optimize THP utilization system-wide by allocating THPs
based on, for example, task priority, task performance requirements, or
heatmaps.  For the latter, one idea that has already surfaced is using
DAMON to identify hot regions, and driving THP collapse through a new
DAMOS_COLLAPSE scheme[10].

Sequence of Patches
--------------------------------
* Patch 1 is a cleanup patch.

* Patch 2 (Yang Shi) removes UMA hugepage preallocation and makes
  khugepaged hugepage allocation independent of CONFIG_NUMA

* Patches 3-8 perform refactoring of collapse logic within khugepaged.c
  and introduce the notion of a collapse context.

* Patch 9 introduces MADV_COLLAPSE and is the main patch in this series.

* Patches 10-13 add additional support: tracepoints, clean-ups,
  process_madvise(2), and /proc/<pid>/smaps output

* Patches 14-18 add selftests.


This patch (of 18):

transhuge_vma_suitable() is called twice in hugepage_vma_revalidate()
path.  Remove the first check, and rely on the second check inside
hugepage_vma_check().

Link: https://lkml.kernel.org/r/20220706235936.2197195-1-zokeefe@google.com
Link: https://lkml.kernel.org/r/20220706235936.2197195-2-zokeefe@google.com
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rongwei Wang <rongwei.wang@linux.alibaba.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Kennelly <ckennelly@google.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Helge Deller <deller@gmx.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-remove-redundant-transhuge_vma_suitable-check
+++ a/mm/khugepaged.c
@@ -918,8 +918,6 @@ static int hugepage_vma_revalidate(struc
 	if (!vma)
 		return SCAN_VMA_NULL;
 
-	if (!transhuge_vma_suitable(vma, address))
-		return SCAN_ADDRESS_RANGE;
 	if (!hugepage_vma_check(vma, vma->vm_flags, false, false))
 		return SCAN_VMA_CHECK;
 	/*
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
mm-khugepaged-rename-prefix-of-shared-collapse-functions.patch
mm-madvise-add-huge_memory-mm_madvise_collapse-tracepoint.patch
mm-madvise-add-madv_collapse-to-process_madvise.patch
proc-smaps-add-pmdmappable-field-to-smaps.patch
selftests-vm-modularize-collapse-selftests.patch
selftests-vm-dedup-hugepage-allocation-logic.patch
selftests-vm-add-madv_collapse-collapse-context-to-selftests.patch
selftests-vm-add-selftest-to-verify-recollapse-of-thps.patch
selftests-vm-add-selftest-to-verify-multi-thp-collapse.patch

