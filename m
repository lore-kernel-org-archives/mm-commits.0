Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 171D8C001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:05:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236755AbjHKXFA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237074AbjHKXDi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:03:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A61B135BE
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:01:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4429D666E3
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:01:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4ABC433C8;
        Fri, 11 Aug 2023 23:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794904;
        bh=quCq6jR0ZbPUmXjDF4/me4tSsWq911NTH/lezpsnTuE=;
        h=Date:To:From:Subject:From;
        b=Ijozq8GAULB5A9wQW2wRHoua5Xmqwh5Bpfm+WW7eMlVb4fdcPBRxYL2e0EsSro9H0
         a+A/yTTnmZDj/STY1Pt+dTKhvBnnIlIbuxt964PYDBxviqgnOb/b8lp6CFMMFmA9JB
         HLfyWAgZxaetbVj1J2gK/cd0E7lDvKl5L61f0oZU=
Date:   Fri, 11 Aug 2023 16:01:44 -0700
To:     mm-commits@vger.kernel.org, yangyicong@hisilicon.com,
        xhao@linux.alibaba.com, will@kernel.org,
        wangkefeng.wang@huawei.com, ryan.roberts@arm.com,
        realmz6@gmail.com, punit.agrawal@bytedance.com,
        prime.zeng@hisilicon.com, peterz@infradead.org, namit@vmware.com,
        mgorman@suse.de, mark.rutland@arm.com, lipeifeng@oppo.com,
        khandual@linux.vnet.ibm.com, Jonathan.Cameron@huawei.com,
        darren@os.amperecomputing.com, corbet@lwn.net,
        catalin.marinas@arm.com, baohua@kernel.org, arnd@arndb.de,
        anshuman.khandual@arm.com, v-songbaohua@oppo.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-tlbbatch-rename-and-extend-some-functions.patch removed from -mm tree
Message-Id: <20230811230144.9E4ABC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/tlbbatch: rename and extend some functions
has been removed from the -mm tree.  Its filename was
     mm-tlbbatch-rename-and-extend-some-functions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm/tlbbatch: rename and extend some functions
Date: Mon, 17 Jul 2023 21:10:02 +0800

This patch does some preparation works to extend batched TLB flush to
arm64. Including:
- Extend set_tlb_ubc_flush_pending() and arch_tlbbatch_add_mm()
  to accept an additional argument for address, architectures
  like arm64 may need this for tlbi.
- Rename arch_tlbbatch_add_mm() to arch_tlbbatch_add_pending()
  to match its current function since we don't need to handle
  mm on architectures like arm64 and add_mm is not proper,
  add_pending will make sense to both as on x86 we're pending the
  TLB flush operations while on arm64 we're pending the synchronize
  operations.

This intends no functional changes on x86.

Link: https://lkml.kernel.org/r/20230717131004.12662-3-yangyicong@huawei.com
Tested-by: Yicong Yang <yangyicong@hisilicon.com>
Tested-by: Xin Hao <xhao@linux.alibaba.com>
Tested-by: Punit Agrawal <punit.agrawal@bytedance.com>
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Xin Hao <xhao@linux.alibaba.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Nadav Amit <namit@vmware.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Barry Song <baohua@kernel.org>
Cc: Darren Hart <darren@os.amperecomputing.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: lipeifeng <lipeifeng@oppo.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Miao <realmz6@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zeng Tao <prime.zeng@hisilicon.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/tlbflush.h |    5 +++--
 include/linux/mm_types_task.h   |    4 ++--
 mm/rmap.c                       |   12 +++++++-----
 3 files changed, 12 insertions(+), 9 deletions(-)

--- a/arch/x86/include/asm/tlbflush.h~mm-tlbbatch-rename-and-extend-some-functions
+++ a/arch/x86/include/asm/tlbflush.h
@@ -276,8 +276,9 @@ static inline u64 inc_mm_tlb_gen(struct
 	return atomic64_inc_return(&mm->context.tlb_gen);
 }
 
-static inline void arch_tlbbatch_add_mm(struct arch_tlbflush_unmap_batch *batch,
-					struct mm_struct *mm)
+static inline void arch_tlbbatch_add_pending(struct arch_tlbflush_unmap_batch *batch,
+					     struct mm_struct *mm,
+					     unsigned long uaddr)
 {
 	inc_mm_tlb_gen(mm);
 	cpumask_or(&batch->cpumask, &batch->cpumask, mm_cpumask(mm));
--- a/include/linux/mm_types_task.h~mm-tlbbatch-rename-and-extend-some-functions
+++ a/include/linux/mm_types_task.h
@@ -52,8 +52,8 @@ struct tlbflush_unmap_batch {
 #ifdef CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
 	/*
 	 * The arch code makes the following promise: generic code can modify a
-	 * PTE, then call arch_tlbbatch_add_mm() (which internally provides all
-	 * needed barriers), then call arch_tlbbatch_flush(), and the entries
+	 * PTE, then call arch_tlbbatch_add_pending() (which internally provides
+	 * all needed barriers), then call arch_tlbbatch_flush(), and the entries
 	 * will be flushed on all CPUs by the time that arch_tlbbatch_flush()
 	 * returns.
 	 */
--- a/mm/rmap.c~mm-tlbbatch-rename-and-extend-some-functions
+++ a/mm/rmap.c
@@ -642,7 +642,8 @@ void try_to_unmap_flush_dirty(void)
 #define TLB_FLUSH_BATCH_PENDING_LARGE			\
 	(TLB_FLUSH_BATCH_PENDING_MASK / 2)
 
-static void set_tlb_ubc_flush_pending(struct mm_struct *mm, pte_t pteval)
+static void set_tlb_ubc_flush_pending(struct mm_struct *mm, pte_t pteval,
+				      unsigned long uaddr)
 {
 	struct tlbflush_unmap_batch *tlb_ubc = &current->tlb_ubc;
 	int batch;
@@ -651,7 +652,7 @@ static void set_tlb_ubc_flush_pending(st
 	if (!pte_accessible(mm, pteval))
 		return;
 
-	arch_tlbbatch_add_mm(&tlb_ubc->arch, mm);
+	arch_tlbbatch_add_pending(&tlb_ubc->arch, mm, uaddr);
 	tlb_ubc->flush_required = true;
 
 	/*
@@ -726,7 +727,8 @@ void flush_tlb_batched_pending(struct mm
 	}
 }
 #else
-static void set_tlb_ubc_flush_pending(struct mm_struct *mm, pte_t pteval)
+static void set_tlb_ubc_flush_pending(struct mm_struct *mm, pte_t pteval,
+				      unsigned long uaddr)
 {
 }
 
@@ -1579,7 +1581,7 @@ static bool try_to_unmap_one(struct foli
 				 */
 				pteval = ptep_get_and_clear(mm, address, pvmw.pte);
 
-				set_tlb_ubc_flush_pending(mm, pteval);
+				set_tlb_ubc_flush_pending(mm, pteval, address);
 			} else {
 				pteval = ptep_clear_flush(vma, address, pvmw.pte);
 			}
@@ -1962,7 +1964,7 @@ static bool try_to_migrate_one(struct fo
 				 */
 				pteval = ptep_get_and_clear(mm, address, pvmw.pte);
 
-				set_tlb_ubc_flush_pending(mm, pteval);
+				set_tlb_ubc_flush_pending(mm, pteval, address);
 			} else {
 				pteval = ptep_clear_flush(vma, address, pvmw.pte);
 			}
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are


