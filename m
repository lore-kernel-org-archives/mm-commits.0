Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D01ACDB483
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 15:37:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbjJRPhL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 11:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbjJRPhI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 11:37:08 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80DDD116
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 08:37:06 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A17BC433CA;
        Wed, 18 Oct 2023 15:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697643426;
        bh=dE8VaHFBuduh7Or5pyPAg6+G1T9UNyXxPQb5k/AE3kw=;
        h=Date:To:From:Subject:From;
        b=iA7V6LyN1tz4gpQQ/0503FPec2FWMby3Kb0HOPFigbPWRNfFVjzvczeRMK8iBTxiz
         Wg1xCNKblAhBwDGrF5NwapWqpRr+pHa4qw1ryWeueb84lJF3DyJHibXmvw70oW3bRi
         YtM0hN58qA4i2zExaIeNVMg/S3e/54O+tlj/hEZk=
Date:   Wed, 18 Oct 2023 08:37:05 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, vincent.guittot@linaro.org,
        peterz@infradead.org, mingo@redhat.com, juri.lelli@redhat.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-use-folio_last_cpupid-in-do_huge_pmd_numa_page.patch added to mm-unstable branch
Message-Id: <20231018153706.1A17BC433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: huge_memory: use folio_last_cpupid() in do_huge_pmd_numa_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-use-folio_last_cpupid-in-do_huge_pmd_numa_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-use-folio_last_cpupid-in-do_huge_pmd_numa_page.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: huge_memory: use folio_last_cpupid() in do_huge_pmd_numa_page()
Date: Wed, 18 Oct 2023 22:07:51 +0800

Convert to use folio_last_cpupid() in do_huge_pmd_numa_page().

Link: https://lkml.kernel.org/r/20231018140806.2783514-5-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memory-use-folio_last_cpupid-in-do_huge_pmd_numa_page
+++ a/mm/huge_memory.c
@@ -1562,7 +1562,7 @@ vm_fault_t do_huge_pmd_numa_page(struct
 	 * to record page access time.  So use default value.
 	 */
 	if (node_is_toptier(nid))
-		last_cpupid = page_cpupid_last(&folio->page);
+		last_cpupid = folio_last_cpupid(folio);
 	target_nid = numa_migrate_prep(folio, vma, haddr, nid, &flags);
 	if (target_nid == NUMA_NO_NODE) {
 		folio_put(folio);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm_types-add-virtual-and-_last_cpupid-into-struct-folio.patch
mm-add-folio_last_cpupid.patch
mm-memory-use-folio_last_cpupid-in-do_numa_page.patch
mm-huge_memory-use-folio_last_cpupid-in-do_huge_pmd_numa_page.patch
mm-huge_memory-use-folio_last_cpupid-in-__split_huge_page_tail.patch
mm-remove-page_cpupid_last.patch
mm-add-folio_xchg_access_time.patch
sched-fair-use-folio_xchg_access_time-in-numa_hint_fault_latency.patch
mm-mprotect-use-a-folio-in-change_pte_range.patch
mm-huge_memory-use-a-folio-in-change_huge_pmd.patch
mm-remove-xchg_page_access_time.patch
mm-add-folio_xchg_last_cpupid.patch
sched-fair-use-folio_xchg_last_cpupid-in-should_numa_migrate_memory.patch
mm-migrate-use-folio_xchg_last_cpupid-in-folio_migrate_flags.patch
mm-huge_memory-use-folio_xchg_last_cpupid-in-__split_huge_page_tail.patch
mm-make-finish_mkwrite_fault-static.patch
mm-convert-wp_page_reuse-and-finish_mkwrite_fault-to-take-a-folio.patch
mm-use-folio_xchg_last_cpupid-in-wp_page_reuse.patch
mm-remove-page_cpupid_xchg_last.patch

