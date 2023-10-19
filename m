Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61E3DCDB465
	for <mm-commits@archiver.kernel.org>; Thu, 19 Oct 2023 16:55:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbjJSQzX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Oct 2023 12:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbjJSQzV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Oct 2023 12:55:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E298B12A
        for <mm-commits@vger.kernel.org>; Thu, 19 Oct 2023 09:55:19 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A75AC433CA;
        Thu, 19 Oct 2023 16:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697734519;
        bh=t+5pWuHnJmg6zCNyxNLuWSugbn0O2FzFRl1WFIkDDYw=;
        h=Date:To:From:Subject:From;
        b=DBS/QlKCk471FxbWn4hSylIdYwAcHEg0mZfQlmwW/fSSVkjeUFKOKdfPROfyZssVb
         EE/0AY3Kk0BtSdMCYn5RglS2V6sX4iP797ISbEbiJWkwHsGl40I4hQthfaksQG1HTU
         1yOdgN9zbXYF0kt5H4+1bq1aNp+dfUOYR0jTyGHA=
Date:   Thu, 19 Oct 2023 09:55:18 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-report-correct-node-id.patch added to mm-unstable branch
Message-Id: <20231019165519.7A75AC433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: report correct node id
has been added to the -mm mm-unstable branch.  Its filename is
     mm-cma-report-correct-node-id.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-report-correct-node-id.patch

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
Subject: mm: cma: report correct node id
Date: Thu, 19 Oct 2023 09:32:53 +0800

cma_declare_contiguous_nid()'s printk can show an invalid node ID:

cma: Reserved 32 MiB at 0x00000000fe000000 on node -1

Use early_pfn_to_nid() to get correct node id from base instead of the
default NUMA_NO_NODE in cma_declare_contiguous_nid(), so users will
instead see

cma: Reserved 32 MiB at 0x00000000fe000000 on node 0

Link: https://lkml.kernel.org/r/20231019013253.2792048-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/cma.c~mm-cma-report-correct-node-id
+++ a/mm/cma.c
@@ -375,6 +375,9 @@ int __init cma_declare_contiguous_nid(ph
 	if (ret)
 		goto free_mem;
 
+	if (nid == NUMA_NO_NODE)
+		nid = early_pfn_to_nid(PHYS_PFN(base));
+
 	pr_info("Reserved %ld MiB at %pa on node %d\n", (unsigned long)size / SZ_1M,
 		&base, nid);
 	return 0;
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
mm-cma-report-correct-node-id.patch

