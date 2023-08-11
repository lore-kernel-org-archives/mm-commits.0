Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8189BC04A94
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:05:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235890AbjHKXFF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236294AbjHKXDj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:03:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B653A85
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:01:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8663367AFA
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:01:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9855C433C7;
        Fri, 11 Aug 2023 23:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794905;
        bh=cipJFfnH0BU/SMuiXyggR9f723dDPP26mzdDG0nfv4c=;
        h=Date:To:From:Subject:From;
        b=L1czDE95GjxapY/dYokIy2x8Rz3Amuy0yL/V2oOPb7/yLJUtyuD8t9OnsJytdv4Zq
         uCVKSAtUfyucWaAty9JosZuK1USWmkJQ/+HdxH0DtYpM7uerdNYrmUKqt4djQsax6J
         HJef6QJ2Yo7PHrYVrdUvhC6//3RknOfHAPrDnbJQ=
Date:   Fri, 11 Aug 2023 16:01:45 -0700
To:     mm-commits@vger.kernel.org, xhao@linux.alibaba.com,
        will@kernel.org, wangkefeng.wang@huawei.com, v-songbaohua@oppo.com,
        ryan.roberts@arm.com, realmz6@gmail.com,
        punit.agrawal@bytedance.com, prime.zeng@hisilicon.com,
        peterz@infradead.org, namit@vmware.com, mgorman@suse.de,
        mark.rutland@arm.com, lipeifeng@oppo.com,
        khandual@linux.vnet.ibm.com, Jonathan.Cameron@huawei.com,
        darren@os.amperecomputing.com, corbet@lwn.net,
        catalin.marinas@arm.com, baohua@kernel.org, arnd@arndb.de,
        anshuman.khandual@arm.com, yangyicong@hisilicon.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-tlbbatch-introduce-arch_flush_tlb_batched_pending.patch removed from -mm tree
Message-Id: <20230811230145.D9855C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/tlbbatch: introduce arch_flush_tlb_batched_pending()
has been removed from the -mm tree.  Its filename was
     mm-tlbbatch-introduce-arch_flush_tlb_batched_pending.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yicong Yang <yangyicong@hisilicon.com>
Subject: mm/tlbbatch: introduce arch_flush_tlb_batched_pending()
Date: Mon, 17 Jul 2023 21:10:03 +0800

Currently we'll flush the mm in flush_tlb_batched_pending() to avoid race
between reclaim unmaps pages by batched TLB flush and mprotect/munmap/etc.
Other architectures like arm64 may only need a synchronization
barrier(dsb) here rather than a full mm flush.  So add
arch_flush_tlb_batched_pending() to allow an arch-specific implementation
here.  This intends no functional changes on x86 since still a full mm
flush for x86.

Link: https://lkml.kernel.org/r/20230717131004.12662-4-yangyicong@huawei.com
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Barry Song <baohua@kernel.org>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Darren Hart <darren@os.amperecomputing.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: lipeifeng <lipeifeng@oppo.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Nadav Amit <namit@vmware.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Punit Agrawal <punit.agrawal@bytedance.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Miao <realmz6@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Xin Hao <xhao@linux.alibaba.com>
Cc: Zeng Tao <prime.zeng@hisilicon.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/tlbflush.h |    5 +++++
 mm/rmap.c                       |    2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/tlbflush.h~mm-tlbbatch-introduce-arch_flush_tlb_batched_pending
+++ a/arch/x86/include/asm/tlbflush.h
@@ -284,6 +284,11 @@ static inline void arch_tlbbatch_add_pen
 	cpumask_or(&batch->cpumask, &batch->cpumask, mm_cpumask(mm));
 }
 
+static inline void arch_flush_tlb_batched_pending(struct mm_struct *mm)
+{
+	flush_tlb_mm(mm);
+}
+
 extern void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch);
 
 static inline bool pte_flags_need_flush(unsigned long oldflags,
--- a/mm/rmap.c~mm-tlbbatch-introduce-arch_flush_tlb_batched_pending
+++ a/mm/rmap.c
@@ -717,7 +717,7 @@ void flush_tlb_batched_pending(struct mm
 	int flushed = batch >> TLB_FLUSH_BATCH_FLUSHED_SHIFT;
 
 	if (pending != flushed) {
-		flush_tlb_mm(mm);
+		arch_flush_tlb_batched_pending(mm);
 		/*
 		 * If the new TLB flushing is pending during flushing, leave
 		 * mm->tlb_flush_batched as is, to avoid losing flushing.
_

Patches currently in -mm which might be from yangyicong@hisilicon.com are

arm64-tlbflush-add-some-comments-for-tlb-batched-flushing.patch

