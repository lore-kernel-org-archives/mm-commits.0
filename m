Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A390C25B6B
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:49:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233009AbjJYXtg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232000AbjJYXsu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:50 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7E6D181
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:47 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DAA1C433CC;
        Wed, 25 Oct 2023 23:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277727;
        bh=jCeOpc2Upyzt2MTYVioOputKBNR3/WwC9WJbgXqrslA=;
        h=Date:To:From:Subject:From;
        b=AkENaVP1aQ7BKJpteVO73F9UwcYs/x9HwmOnxriF50OnI0CfQNCRlM41ORHXTP6gw
         aLq1a3QKuBtyB8HqkeUWUIRpUCOJCQV0niJQ9DFhi+Li/PBro1ROSW5mQ66OD7vL9d
         P+4Q9hUMr55+Fx270KFjj/U46tR3kqd6A+ZJLPCQ=
Date:   Wed, 25 Oct 2023 16:48:46 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, ying.huang@intel.com,
        willy@infradead.org, vincent.guittot@linaro.org,
        peterz@infradead.org, mingo@redhat.com, juri.lelli@redhat.com,
        david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-make-finish_mkwrite_fault-static.patch removed from -mm tree
Message-Id: <20231025234847.3DAA1C433CC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: make finish_mkwrite_fault() static
has been removed from the -mm tree.  Its filename was
     mm-make-finish_mkwrite_fault-static.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: make finish_mkwrite_fault() static
Date: Wed, 18 Oct 2023 22:08:03 +0800

Make finish_mkwrite_fault static since it is not used outside of
memory.c.

Link: https://lkml.kernel.org/r/20231018140806.2783514-17-wangkefeng.wang@huawei.com
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

 include/linux/mm.h |    1 -
 mm/memory.c        |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-make-finish_mkwrite_fault-static
+++ a/include/linux/mm.h
@@ -1348,7 +1348,6 @@ void set_pte_range(struct vm_fault *vmf,
 		struct page *page, unsigned int nr, unsigned long addr);
 
 vm_fault_t finish_fault(struct vm_fault *vmf);
-vm_fault_t finish_mkwrite_fault(struct vm_fault *vmf);
 #endif
 
 /*
--- a/mm/memory.c~mm-make-finish_mkwrite_fault-static
+++ a/mm/memory.c
@@ -3269,7 +3269,7 @@ out:
  * Return: %0 on success, %VM_FAULT_NOPAGE when PTE got changed before
  * we acquired PTE lock.
  */
-vm_fault_t finish_mkwrite_fault(struct vm_fault *vmf)
+static vm_fault_t finish_mkwrite_fault(struct vm_fault *vmf)
 {
 	WARN_ON_ONCE(!(vmf->vma->vm_flags & VM_SHARED));
 	vmf->pte = pte_offset_map_lock(vmf->vma->vm_mm, vmf->pmd, vmf->address,
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


