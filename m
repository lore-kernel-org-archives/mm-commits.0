Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B528C00140
	for <mm-commits@archiver.kernel.org>; Wed,  3 Aug 2022 00:17:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbiHCARf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 Aug 2022 20:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbiHCARf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2022 20:17:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8388F1C11F
        for <mm-commits@vger.kernel.org>; Tue,  2 Aug 2022 17:17:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CE5DB810B0
        for <mm-commits@vger.kernel.org>; Wed,  3 Aug 2022 00:17:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7182C433C1;
        Wed,  3 Aug 2022 00:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659485851;
        bh=SPha246HxH0Cwnd49Zjux4VtmfVH1IlWpiZfkM3FHM0=;
        h=Date:To:From:Subject:From;
        b=OiOn2lY671pcvoz21kRGjZA1M8ZkV75xkL1ffvjd1Z+Z821aEWU5VRskUUmW2QihG
         Ef/WhIl/7aZMY838OXADEmcHzW8RB/tv9c61ghvsVW7aDLKvhHSb5LkBYkdcv7EiIQ
         J4kl/hDxTzzlBIg8udqBjw0tCgvTOYm1XwCp1ZAs=
Date:   Tue, 02 Aug 2022 17:17:29 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        vbabka@suse.cz, tsbogend@alpha.franken.de, songliubraving@fb.com,
        sj@kernel.org, shy828301@gmail.com, rongwei.wang@linux.alibaba.com,
        rientjes@google.com, peterx@redhat.com, pasha.tatashin@soleen.com,
        minchan@kernel.org, mhocko@suse.com, mattst88@gmail.com,
        linmiaohe@huawei.com, kirill.shutemov@linux.intel.com,
        jrdr.linux@gmail.com, jcmvbkbc@gmail.com,
        James.Bottomley@HansenPartnership.com, ink@jurassic.park.msu.ru,
        hughd@google.com, deller@gmx.de, david@redhat.com,
        dan.carpenter@oracle.com, ckennelly@google.com, chris@zankel.net,
        axelrasmussen@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        arnd@arndb.de, alex.shi@linux.alibaba.com, aarcange@redhat.com,
        zokeefe@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-add-madv_collapse-to-process_madvise-fix.patch added to mm-unstable branch
Message-Id: <20220803001730.E7182C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/madvise: remove CAP_SYS_ADMIN requirement for process_madvise(MADV_COLLAPSE)
has been added to the -mm mm-unstable branch.  Its filename is
     mm-madvise-add-madv_collapse-to-process_madvise-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-add-madv_collapse-to-process_madvise-fix.patch

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
Subject: mm/madvise: remove CAP_SYS_ADMIN requirement for process_madvise(MADV_COLLAPSE)
Date: Mon, 1 Aug 2022 14:09:46 -0700

process_madvise(MADV_COLLAPSE) currently requires CAP_SYS_ADMIN when not
acting on the caller's own mm.  This is maximally restrictive, and
perpetuates existing issues with CAP_SYS_ADMIN.  Remove this requirement.

When acting on an external process' memory, the biggest concerns for
process_madvise(MADV_COLLAPSE) are (1) being able to influence process
performance by moving memory, possibly between nodes, that is mapped into
the address space of external process(es), (2) defeat of
address-space-layout randomization, and (3), being able to increase
process RSS and memcg usage, possibly causing memcg OOM.

process_madvise(2) already enforces CAP_SYS_NICE and PTRACE_MODE_READ (in
PTRACE_MODE_FSCREDS mode).  A process with these credentials can already
accomplish (1) and (2) via move_pages(MPOL_MF_MOVE_ALL), and (3) via
process_madvise(MADV_WILLNEED).

process_madvise(MADV_COLLAPSE) may also circumvent sysfs THP settings. 
When acting on one's own memory (which is equivalent to
madvise(MADV_COLLAPSE)), this is deemed acceptable, since aside from the
possibility of hoarding available hugepages (which is currently already
possible) no harm to the system can be done.  When acting on an external
process' memory, circumventing sysfs THP settings should provide no
additional threat compared to the ones listed.  As such, imposing
additional capabilities (such as CAP_SETUID, as a way to ensure the caller
could have just altered the sysfs THP settings themselves) provides no
extra protection.

Link: https://lkml.kernel.org/r/20220801210946.3069083-1-zokeefe@google.com
Fixes: 7ec952341312 ("mm/madvise: add MADV_COLLAPSE to process_madvise()")
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Kennelly <ckennelly@google.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
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
Cc: "Souptick Joarder (HPE)" <jrdr.linux@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/madvise.c~mm-madvise-add-madv_collapse-to-process_madvise-fix
+++ a/mm/madvise.c
@@ -1170,16 +1170,14 @@ madvise_behavior_valid(int behavior)
 	}
 }
 
-static bool
-process_madvise_behavior_valid(int behavior, struct task_struct *task)
+static bool process_madvise_behavior_valid(int behavior)
 {
 	switch (behavior) {
 	case MADV_COLD:
 	case MADV_PAGEOUT:
 	case MADV_WILLNEED:
-		return true;
 	case MADV_COLLAPSE:
-		return task == current || capable(CAP_SYS_ADMIN);
+		return true;
 	default:
 		return false;
 	}
@@ -1457,7 +1455,7 @@ SYSCALL_DEFINE5(process_madvise, int, pi
 		goto free_iov;
 	}
 
-	if (!process_madvise_behavior_valid(behavior, task)) {
+	if (!process_madvise_behavior_valid(behavior)) {
 		ret = -EINVAL;
 		goto release_task;
 	}
_

Patches currently in -mm which might be from zokeefe@google.com are

mm-khugepaged-add-struct-collapse_control.patch
mm-khugepaged-add-struct-collapse_control-fix.patch
mm-khugepaged-dedup-and-simplify-hugepage-alloc-and-charging.patch
mm-khugepaged-pipe-enum-scan_result-codes-back-to-callers.patch
mm-khugepaged-add-flag-to-predicate-khugepaged-only-behavior.patch
mm-thp-add-flag-to-enforce-sysfs-thp-in-hugepage_vma_check.patch
mm-khugepaged-add-flag-to-predicate-khugepaged-only-behavior-fix.patch
mm-khugepaged-record-scan_pmd_mapped-when-scan_pmd-finds-hugepage.patch
mm-madvise-introduce-madv_collapse-sync-hugepage-collapse.patch
mm-madvise-introduce-madv_collapse-sync-hugepage-collapse-fix-2.patch
mm-madvise-introduce-madv_collapse-sync-hugepage-collapse-fix-3.patch
mm-khugepaged-rename-prefix-of-shared-collapse-functions.patch
mm-madvise-add-madv_collapse-to-process_madvise.patch
mm-madvise-add-madv_collapse-to-process_madvise-fix.patch
selftests-vm-modularize-collapse-selftests.patch
selftests-vm-dedup-hugepage-allocation-logic.patch
selftests-vm-add-madv_collapse-collapse-context-to-selftests.patch
selftests-vm-add-selftest-to-verify-recollapse-of-thps.patch
selftests-vm-add-selftest-to-verify-multi-thp-collapse.patch

