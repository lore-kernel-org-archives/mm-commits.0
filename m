Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA7BFC25B6B
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:49:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233876AbjJYXtQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234338AbjJYXsq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:46 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0280D43
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:36 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2F0C433C8;
        Wed, 25 Oct 2023 23:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277716;
        bh=CH2psMqMkPPNUCAiOkR3qTBbDLik16Bmvus/c8B1VXo=;
        h=Date:To:From:Subject:From;
        b=iM6smgBN5gPjnt800xnT9/L0GqtVMN+Cqp3s2+fnVSQGzeo+zLpDN9FQrHTA1/1Qg
         5GNg1BD9SQiFQ33jQcFuwGuXZhZqFwZzU33TaTi4ufoGWVsIEfETtB3d+ydEns9mnI
         iygYwHKoOV8qDGmjI6D9xsuUfwzQxXbdBBLQ2dUk=
Date:   Wed, 25 Oct 2023 16:48:35 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, vincent.guittot@linaro.org,
        peterz@infradead.org, mingo@redhat.com, juri.lelli@redhat.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-use-folio_last_cpupid-in-do_huge_pmd_numa_page.patch removed from -mm tree
Message-Id: <20231025234836.7B2F0C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: huge_memory: use folio_last_cpupid() in do_huge_pmd_numa_page()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-use-folio_last_cpupid-in-do_huge_pmd_numa_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


