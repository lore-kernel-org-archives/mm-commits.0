Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3F72EB64DC
	for <mm-commits@archiver.kernel.org>; Mon, 17 Jul 2023 18:07:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbjGQSH7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Jul 2023 14:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbjGQSHx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Jul 2023 14:07:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B79818E
        for <mm-commits@vger.kernel.org>; Mon, 17 Jul 2023 11:07:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C731611CA
        for <mm-commits@vger.kernel.org>; Mon, 17 Jul 2023 18:07:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F013C433C8;
        Mon, 17 Jul 2023 18:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689617271;
        bh=3SHu3TQVrVRqQvlx/uuNcLWFbnSy8qMuK8jkX+mSQVo=;
        h=Date:To:From:Subject:From;
        b=SA1BLPaD3e0qApfyFRPAIwzNrK3OUg8tHYQWtiJ38ysUIlPVmCbmzclR9LajAMwyf
         31dZ1uNiBMldTAWp4GkrLQZHs7/SF5iA0PoMhfb7D+qv2sRUsPCHttDAll9wpgncB6
         Q9ZZksjnPbydaFgb+bLYlDbN3v/zqM1+rUl8YKMY=
Date:   Mon, 17 Jul 2023 11:07:50 -0700
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
Subject: + mm-tlbbatch-introduce-arch_flush_tlb_batched_pending.patch added to mm-unstable branch
Message-Id: <20230717180751.9F013C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/tlbbatch: Introduce arch_flush_tlb_batched_pending()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-tlbbatch-introduce-arch_flush_tlb_batched_pending.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-tlbbatch-introduce-arch_flush_tlb_batched_pending.patch

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
From: Yicong Yang <yangyicong@hisilicon.com>
Subject: mm/tlbbatch: Introduce arch_flush_tlb_batched_pending()
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
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Barry Song <baohua@kernel.org>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
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

mm-tlbbatch-introduce-arch_flush_tlb_batched_pending.patch

