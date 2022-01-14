Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B02DCC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 21:35:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbiANVfs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 16:35:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58168 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiANVfr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 16:35:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61B5861FB3
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 21:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67FAAC36AE5;
        Fri, 14 Jan 2022 21:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642196146;
        bh=uiJQZVDNh3IjgKaWPsQTw5qKUN/ngIIPYSdpXJ7Xcyg=;
        h=Date:From:To:Subject:From;
        b=NVGrHpS4lUIgKcRBK0lhP1ANyrGVckK14V5nvKuxAjpSFy/VwZZzssLeda5B/eGsZ
         q0RPxGLgEAe6NmilTpUaYFghiP0//e66Jc2hl4Lq5OOFZND7Sgb2nbOUkHzd+77PPE
         4OtOWR0Z1bLA7k3xOp40HavRuBQf5SOVCr2g8KAs=
Date:   Fri, 14 Jan 2022 13:35:45 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, akpm@linux-foundation.org,
        dave.hansen@linux.intel.com, elver@google.com, luto@kernel.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        namit@vmware.com, will@kernel.org, ying.huang@intel.com,
        yuzhao@google.com
Subject:  [folded-merged]
 mm-rmap-fix-potential-batched-tlb-flush-race-fix.patch removed from -mm
 tree
Message-ID: <20220114213545.hyhCLztiW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-rmap-fix-potential-batched-tlb-flush-race-fix
has been removed from the -mm tree.  Its filename was
     mm-rmap-fix-potential-batched-tlb-flush-race-fix.patch

This patch was dropped because it was folded into mm-rmap-fix-potential-batched-tlb-flush-race.patch

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

mm-rmap-fix-potential-batched-tlb-flush-race.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix2.patch
proc-make-the-proc_create-stubs-static-inlines-fix2-fix.patch
kernel-sys-only-take-tasklist_lock-for-get-setpriorityprio_pgrp-checkpatch-fixes.patch
hashh-remove-unused-define-directive-fix.patch
panic-use-error_report_end-tracepoint-on-warnings-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
arch-x86-include-asm-pgtableh-needs-spinlockh.patch
sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch
sysctl-add-helper-to-register-a-sysctl-mount-point-fix.patch
sysctl-move-maxolduid-as-a-sysctl-specific-const-fix.patch
proc-remove-pde_data-completely-fix.patch
proc-remove-pde_data-completely-fix-fix.patch
mm-remove-cleancache-fix.patch
mm-simplify-try_to_unuse-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

