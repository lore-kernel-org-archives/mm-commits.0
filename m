Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF6A1C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  1 Dec 2021 02:45:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234763AbhLACtJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 Nov 2021 21:49:09 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:54224 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346235AbhLACtF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 Nov 2021 21:49:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 399C3CE1D63
        for <mm-commits@vger.kernel.org>; Wed,  1 Dec 2021 02:45:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04FC0C53FCB;
        Wed,  1 Dec 2021 02:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638326741;
        bh=D2J7j+ELAZgzbzYfmNsVG3CCj7gzcj4ehIBShRWWMFg=;
        h=Date:From:To:Subject:From;
        b=Y3VVSvoPbAOz3KnfWeHahvCV8eDgcFNY9y/lWv+JhdAdU1DAMo1cVXm2B2Cyo2MMc
         2PDpwBPcYMTiqw0n+asSloAkYOS3DGahlEOxJw9hylKY9+Sln//IRm/2B0BxH9cK/g
         qmaOtLDOmDT4TJaRbwf0TK1uRx+pmOVVKYlgVqDc=
Date:   Tue, 30 Nov 2021 18:45:40 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, akpm@linux-foundation.org,
        dave.hansen@linux.intel.com, elver@google.com, luto@kernel.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        namit@vmware.com, will@kernel.org, ying.huang@intel.com,
        yuzhao@google.com
Subject:  + mm-rmap-fix-potential-batched-tlb-flush-race-fix.patch
 added to -mm tree
Message-ID: <20211201024540.in40T2Uln%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-rmap-fix-potential-batched-tlb-flush-race-fix
has been added to the -mm tree.  Its filename is
     mm-rmap-fix-potential-batched-tlb-flush-race-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-rmap-fix-potential-batched-tlb-flush-race-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-rmap-fix-potential-batched-tlb-flush-race-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-rmap-fix-potential-batched-tlb-flush-race-fix

tweak comments

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Marco Elver <elver@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Nadav Amit <namit@vmware.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/mm/rmap.c~mm-rmap-fix-potential-batched-tlb-flush-race-fix
+++ a/mm/rmap.c
@@ -622,8 +622,8 @@ void try_to_unmap_flush_dirty(void)
 }
 
 /*
- * The 0-14 bit of mm->tlb_flush_batched records pending generations,
- * and the 16-30 bit records flushed generations.
+ * Bits 0-14 of mm->tlb_flush_batched record pending generations.
+ * Bits 16-30 of mm->tlb_flush_batched bit record flushed generations.
  */
 #define TLB_FLUSH_BATCH_FLUSHED_SHIFT	16
 #define TLB_FLUSH_BATCH_PENDING_MASK			\
@@ -648,9 +648,9 @@ static void set_tlb_ubc_flush_pending(st
 retry:
 	if ((batch & TLB_FLUSH_BATCH_PENDING_MASK) > TLB_FLUSH_BATCH_PENDING_LARGE) {
 		/*
-		 * To avoid ""pending"" to catch up with ""flushed""
-		 * because of overflow.  Reset "pending" and "flushed"
-		 * to be "1" and "0" if "pending" becomes large.
+		 * Prevent `pending' from catching up with `flushed' because of
+		 * overflow.  Reset `pending' and `flushed' to be 1 and 0 if
+		 * `pending' becomes large.
 		 */
 		nbatch = atomic_cmpxchg(&mm->tlb_flush_batched, batch, 1);
 		if (nbatch != batch) {
@@ -713,9 +713,8 @@ void flush_tlb_batched_pending(struct mm
 	if (pending != flushed) {
 		flush_tlb_mm(mm);
 		/*
-		 * If the new TLB flushing is pended during flushing,
-		 * leave mm->tlb_flush_batched as is, to avoid to lose
-		 * flushing.
+		 * If the new TLB flushing is pending during flushing, leave
+		 * mm->tlb_flush_batched as is, to avoid losing flushing.
 		 */
 		atomic_cmpxchg(&mm->tlb_flush_batched, batch,
 			       pending | (pending << TLB_FLUSH_BATCH_FLUSHED_SHIFT));
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode-checkpatch-fixes.patch
kthread-add-the-helper-function-kthread_run_on_cpu-fix.patch
mm.patch
kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable-fix.patch
mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes.patch
mm-page-table-check-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups-fix.patch
mm-rmap-fix-potential-batched-tlb-flush-race-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix.patch
panic-use-error_report_end-tracepoint-on-warnings-fix.patch
sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch
sysctl-add-helper-to-register-a-sysctl-mount-point-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

