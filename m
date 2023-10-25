Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21A7BC25B6E
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:49:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbjJYXtL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234031AbjJYXsq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:46 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C2CD42
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:35 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C121C433C9;
        Wed, 25 Oct 2023 23:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277715;
        bh=B8yMGAl8zfseXSD5FM3ZXrr1frDvkNOcz3ZgEvVO8EM=;
        h=Date:To:From:Subject:From;
        b=Y3EA4K8LPGEgtIXdwzoU2OymnksqJFZxy15JB6I4nC/PJ41cQpL6pr1uuf+4O2eJn
         SfcSP0gVgJmQZaO7jPwX8YWLp3IrrrCpYQdKBikIrzoV5LDkbFNGInfo/mCY5uRpht
         IaMsSqytYBQtA50ahmfl1NZvDX6z/kYVCUMVPPQs=
Date:   Wed, 25 Oct 2023 16:48:34 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, vincent.guittot@linaro.org,
        peterz@infradead.org, mingo@redhat.com, juri.lelli@redhat.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-use-folio_last_cpupid-in-do_numa_page.patch removed from -mm tree
Message-Id: <20231025234835.7C121C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memory: use folio_last_cpupid() in do_numa_page()
has been removed from the -mm tree.  Its filename was
     mm-memory-use-folio_last_cpupid-in-do_numa_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory: use folio_last_cpupid() in do_numa_page()
Date: Wed, 18 Oct 2023 22:07:50 +0800

Convert to use folio_last_cpupid() in do_numa_page().

Link: https://lkml.kernel.org/r/20231018140806.2783514-4-wangkefeng.wang@huawei.com
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

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-memory-use-folio_last_cpupid-in-do_numa_page
+++ a/mm/memory.c
@@ -4858,7 +4858,7 @@ static vm_fault_t do_numa_page(struct vm
 	    !node_is_toptier(nid))
 		last_cpupid = (-1 & LAST_CPUPID_MASK);
 	else
-		last_cpupid = page_cpupid_last(&folio->page);
+		last_cpupid = folio_last_cpupid(folio);
 	target_nid = numa_migrate_prep(folio, vma, vmf->address, nid, &flags);
 	if (target_nid == NUMA_NO_NODE) {
 		folio_put(folio);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


