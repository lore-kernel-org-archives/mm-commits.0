Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 204E1C43334
	for <mm-commits@archiver.kernel.org>; Wed, 20 Jul 2022 16:44:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbiGTQoB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 20 Jul 2022 12:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233075AbiGTQn6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jul 2022 12:43:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2181966AD6
        for <mm-commits@vger.kernel.org>; Wed, 20 Jul 2022 09:43:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BED9DB82149
        for <mm-commits@vger.kernel.org>; Wed, 20 Jul 2022 16:43:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B719C3411E;
        Wed, 20 Jul 2022 16:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658335429;
        bh=KLeXErz1FTCl/jmk5xDM4ZLwcNs9KDGqapHk76EEynU=;
        h=Date:To:From:Subject:From;
        b=0jOnrJJuvWWR8fUmfXn3ukKSNI+2jZenNTNX6FPkdiACKpd6y6CVQ3t9mtV7j/W/z
         yZGJJ32lQSO6O/qp4vd8AijjzM5ANwJLMzvd4DQ9Dztp4S5GGntBDWwOAZePqhut87
         s59+2wvK3uRf1FzgD583uKS1KtRiAV82SYSwlPdA=
Date:   Wed, 20 Jul 2022 09:43:48 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        vbabka@suse.cz, tsbogend@alpha.franken.de, songliubraving@fb.com,
        sj@kernel.org, shy828301@gmail.com, rongwei.wang@linux.alibaba.com,
        rientjes@google.com, peterx@redhat.com, pasha.tatashin@soleen.com,
        minchan@kernel.org, mhocko@suse.com, mattst88@gmail.com,
        lkp@intel.com, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, jrdr.linux@gmail.com,
        jcmvbkbc@gmail.com, James.Bottomley@HansenPartnership.com,
        ink@jurassic.park.msu.ru, hughd@google.com, deller@gmx.de,
        david@redhat.com, dan.carpenter@oracle.com, ckennelly@google.com,
        chris@zankel.net, axelrasmussen@google.com, axboe@kernel.dk,
        asml.silence@gmail.com, arnd@arndb.de, alex.shi@linux.alibaba.com,
        aarcange@redhat.com, zokeefe@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-add-struct-collapse_control-fix.patch added to mm-unstable branch
Message-Id: <20220720164349.3B719C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: use minimal bits to store num page < HPAGE_PMD_NR
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-add-struct-collapse_control-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-add-struct-collapse_control-fix.patch

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
Subject: mm/khugepaged: use minimal bits to store num page < HPAGE_PMD_NR
Date: Wed, 20 Jul 2022 07:06:00 -0700

Minimally, node_load[] entries just need to be able to hold the maximum
value of HPAGE_PMD_NR, which is compile-time defined per-arch based on
PMD_SHIFT and PAGE_SHIFT.  node_load[] is only written either via
memset(), or with via post-increment.  struct collapse_control may be
allocated via kmalloc() in other collapse contexts, and MAX_NUMNODES may
be arbitrarily large.  #define the underlying type of node_load[] based
off HPAGE_PMD_NR to avoid excessive memory allocated for this struct.

Link: https://lkml.kernel.org/r/20220720140603.1958773-2-zokeefe@google.com
Link: https://lore.kernel.org/linux-mm/Ys2CeIm%2FQmQwWh9a@google.com/
Fixes: 3b07f3bb225a ("mm/khugepaged: add struct collapse_control")
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
Cc: kernel test robot <lkp@intel.com>
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

 mm/khugepaged.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-add-struct-collapse_control-fix
+++ a/mm/khugepaged.c
@@ -87,8 +87,11 @@ static struct kmem_cache *mm_slot_cache
 
 struct collapse_control {
 	/* Num pages scanned per node */
-	int node_load[MAX_NUMNODES];
-
+#if HPAGE_PMD_ORDER < 16
+	u16 node_load[MAX_NUMNODES];
+#else
+	u32 node_load[MAX_NUMNODES];
+#endif
 	/* Last target selected in khugepaged_find_target_node() */
 	int last_target_node;
 };
_

Patches currently in -mm which might be from zokeefe@google.com are

mm-khugepaged-remove-redundant-transhuge_vma_suitable-check.patch
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
selftests-vm-modularize-collapse-selftests.patch
selftests-vm-dedup-hugepage-allocation-logic.patch
selftests-vm-add-madv_collapse-collapse-context-to-selftests.patch
selftests-vm-add-selftest-to-verify-recollapse-of-thps.patch
selftests-vm-add-selftest-to-verify-multi-thp-collapse.patch

