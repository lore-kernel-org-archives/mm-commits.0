Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92E0FC41513
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:05:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233643AbjHKXFE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237019AbjHKXDi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:03:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68BC2423E
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:01:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F230467ADC
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:01:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5179CC433C7;
        Fri, 11 Aug 2023 23:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794903;
        bh=WYJpDYNS4C2QsB7hJMkJwjpVlr3JMcMn983WcwLBHmY=;
        h=Date:To:From:Subject:From;
        b=OHlhuXvxYKIMUW3CcPm0LUf8Oldzekw2pRVp0F+kcIMnZmWmd0oyGrsz6mWYW8S28
         ncNNZhs+SUH8A+9+U8m5Y4VOKUGf++eYUoYVwdeNlF/SNvpY2nx94mfDxR+UDJQI26
         9Fv2rJ7jroex3ytyW/b56pV5lZGDYeHqCvGOMFik=
Date:   Fri, 11 Aug 2023 16:01:42 -0700
To:     mm-commits@vger.kernel.org, yangyicong@hisilicon.com,
        xhao@linux.alibaba.com, will@kernel.org,
        wangkefeng.wang@huawei.com, v-songbaohua@oppo.com,
        ryan.roberts@arm.com, realmz6@gmail.com,
        punit.agrawal@bytedance.com, prime.zeng@hisilicon.com,
        peterz@infradead.org, namit@vmware.com, mgorman@suse.de,
        mark.rutland@arm.com, lipeifeng@oppo.com,
        Jonathan.Cameron@huawei.com, darren@os.amperecomputing.com,
        corbet@lwn.net, catalin.marinas@arm.com, baohua@kernel.org,
        arnd@arndb.de, anshuman.khandual@arm.com,
        khandual@linux.vnet.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-tlbbatch-introduce-arch_tlbbatch_should_defer.patch removed from -mm tree
Message-Id: <20230811230143.5179CC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/tlbbatch: introduce arch_tlbbatch_should_defer()
has been removed from the -mm tree.  Its filename was
     mm-tlbbatch-introduce-arch_tlbbatch_should_defer.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: mm/tlbbatch: introduce arch_tlbbatch_should_defer()
Date: Mon, 17 Jul 2023 21:10:01 +0800

Patch series "arm64: support batched/deferred tlb shootdown during page
reclamation/migration", v11.

Though ARM64 has the hardware to do tlb shootdown, the hardware
broadcasting is not free.  A simplest micro benchmark shows even on
snapdragon 888 with only 8 cores, the overhead for ptep_clear_flush is
huge even for paging out one page mapped by only one process: 5.36% a.out
[kernel.kallsyms] [k] ptep_clear_flush

While pages are mapped by multiple processes or HW has more CPUs, the cost
should become even higher due to the bad scalability of tlb shootdown. 
The same benchmark can result in 16.99% CPU consumption on ARM64 server
with around 100 cores according to the test on patch 4/4.

This patchset leverages the existing BATCHED_UNMAP_TLB_FLUSH by
1. only send tlbi instructions in the first stage -
	arch_tlbbatch_add_mm()
2. wait for the completion of tlbi by dsb while doing tlbbatch
	sync in arch_tlbbatch_flush()

Testing on snapdragon shows the overhead of ptep_clear_flush is removed by
the patchset.  The micro benchmark becomes 5% faster even for one page
mapped by single process on snapdragon 888.

Since BATCHED_UNMAP_TLB_FLUSH is implemented only on x86, the patchset
does some renaming/extension for the current implementation first (Patch
1-3), then add the support on arm64 (Patch 4).
		

This patch (of 4):

The entire scheme of deferred TLB flush in reclaim path rests on the fact
that the cost to refill TLB entries is less than flushing out individual
entries by sending IPI to remote CPUs.  But architecture can have
different ways to evaluate that.  Hence apart from checking
TTU_BATCH_FLUSH in the TTU flags, rest of the decision should be
architecture specific.

[yangyicong@hisilicon.com: rebase and fix incorrect return value type]
Link: https://lkml.kernel.org/r/20230717131004.12662-1-yangyicong@huawei.com
Link: https://lkml.kernel.org/r/20230717131004.12662-2-yangyicong@huawei.com
Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
[https://lore.kernel.org/linuxppc-dev/20171101101735.2318-2-khandual@linux.vnet.ibm.com/]
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Xin Hao <xhao@linux.alibaba.com>
Tested-by: Punit Agrawal <punit.agrawal@bytedance.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Darren Hart <darren@os.amperecomputing.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: lipeifeng <lipeifeng@oppo.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Miao <realmz6@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zeng Tao <prime.zeng@hisilicon.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Nadav Amit <namit@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/tlbflush.h |   12 ++++++++++++
 mm/rmap.c                       |    9 +--------
 2 files changed, 13 insertions(+), 8 deletions(-)

--- a/arch/x86/include/asm/tlbflush.h~mm-tlbbatch-introduce-arch_tlbbatch_should_defer
+++ a/arch/x86/include/asm/tlbflush.h
@@ -253,6 +253,18 @@ static inline void flush_tlb_page(struct
 	flush_tlb_mm_range(vma->vm_mm, a, a + PAGE_SIZE, PAGE_SHIFT, false);
 }
 
+static inline bool arch_tlbbatch_should_defer(struct mm_struct *mm)
+{
+	bool should_defer = false;
+
+	/* If remote CPUs need to be flushed then defer batch the flush */
+	if (cpumask_any_but(mm_cpumask(mm), get_cpu()) < nr_cpu_ids)
+		should_defer = true;
+	put_cpu();
+
+	return should_defer;
+}
+
 static inline u64 inc_mm_tlb_gen(struct mm_struct *mm)
 {
 	/*
--- a/mm/rmap.c~mm-tlbbatch-introduce-arch_tlbbatch_should_defer
+++ a/mm/rmap.c
@@ -688,17 +688,10 @@ retry:
  */
 static bool should_defer_flush(struct mm_struct *mm, enum ttu_flags flags)
 {
-	bool should_defer = false;
-
 	if (!(flags & TTU_BATCH_FLUSH))
 		return false;
 
-	/* If remote CPUs need to be flushed then defer batch the flush */
-	if (cpumask_any_but(mm_cpumask(mm), get_cpu()) < nr_cpu_ids)
-		should_defer = true;
-	put_cpu();
-
-	return should_defer;
+	return arch_tlbbatch_should_defer(mm);
 }
 
 /*
_

Patches currently in -mm which might be from khandual@linux.vnet.ibm.com are


