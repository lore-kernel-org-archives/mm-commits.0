Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89A99C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:22:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 638F161CF9
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:22:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbhF2AYr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 20:24:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:59570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231996AbhF2AYq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 20:24:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D730261CF4;
        Tue, 29 Jun 2021 00:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624926139;
        bh=odqT29MD4wbESj3uJEqib4IYLhvV7+MV9YlRYEM9xvA=;
        h=Date:From:To:Subject:From;
        b=wOmHuHIh4tCKeGMzqIxf1771QsnF/ToWAC5MXjPXH5oqnRbKB9k66peIk73R4PXl5
         8dV4t/ziM6bRTxoM+6+T7ZR/4VYmAK23PUugvSS2cCTrg0ehByFFr20oGKRKErdF8f
         +z8Z/5VuaqhyCqxG/mpx32uEx9GnansbRe7v+j7s=
Date:   Mon, 28 Jun 2021 17:22:18 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        chris@chrisdown.name, cl@linux.com, guro@fb.com,
        hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, laoar.shao@gmail.com,
        longman@redhat.com, mhocko@kernel.org, mm-commits@vger.kernel.org,
        msys.mizuma@gmail.com, penberg@kernel.org,
        richard.weiyang@gmail.com, rientjes@google.com,
        shakeelb@google.com, songmuchun@bytedance.com, tj@kernel.org,
        vbabka@suse.cz, vdavydov.dev@gmail.com, willy@infradead.org,
        zhengjun.xing@linux.intel.com
Subject:  [folded-merged]
 mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
 removed from -mm tree
Message-ID: <20210629002218.ictI2SyKA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-memcg-optimize-user-context-object-stock-access.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes

WARNING: else is not generally useful after a break or return
#138: FILE: mm/memcontrol.c:2121:
+		return &stock->task_obj;
+	} else {

total: 0 errors, 1 warnings, 193 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-memcg-optimize-user-context-object-stock-access.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Masayoshi Mizuma <msys.mizuma@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Waiman Long <longman@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Xing Zhengjun <zhengjun.xing@linux.intel.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes
+++ a/mm/memcontrol.c
@@ -2118,11 +2118,11 @@ static inline struct obj_stock *get_obj_
 		preempt_disable();
 		stock = this_cpu_ptr(&memcg_stock);
 		return &stock->task_obj;
-	} else {
-		local_irq_save(*pflags);
-		stock = this_cpu_ptr(&memcg_stock);
-		return &stock->irq_obj;
 	}
+
+	local_irq_save(*pflags);
+	stock = this_cpu_ptr(&memcg_stock);
+	return &stock->irq_obj;
 }
 
 static inline void put_obj_stock(unsigned long flags)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memcg-optimize-user-context-object-stock-access.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5-fix.patch
binfmt-remove-in-tree-usage-of-map_executable-fix.patch
mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix-checkpatch-fixes.patch
mm.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
mmmemory_hotplug-drop-unneeded-locking-fix.patch
fs-proc-kcorec-add-mmap-interface-fix.patch
kernelh-split-out-panic-and-oops-helpers-fix.patch
lib-math-rational-add-kunit-test-cases-fix.patch
lib-decompressors-remove-set-but-not-used-variabled-level-fix.patch
ipc-utilc-use-binary-search-for-max_idx-fix.patch
linux-next-pre.patch
linux-next-post.patch
linux-next-rejects.patch
kernel-cgroup-cgroupc-dont-export-cgroup_get_e_css-twice.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

