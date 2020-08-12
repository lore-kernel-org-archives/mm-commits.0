Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68B3FC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:07:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4154A20774
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266424;
	bh=6bmRWMRph2R4LB45hiyjk/v3woSDmYFDD8MNpo3g2L4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=sTxKCru7q7+Lmb2JLAhuN/j9PiASrKqu6LBRUzcMqO9PSyF6MlKmiij65PF7zrQab
	 6Ht29yy18wSWe2tSjQ+auN00k4aLIXfsJv6ZuDhw3svJ59csu3uHJSrTpoIqqEqC/m
	 gQ3d733kQBl8/miJHj626EhJCsITpKBCcQ0M1jxQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgHLVHE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:07:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:34682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbgHLVHD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:07:03 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5B3D2078B;
        Wed, 12 Aug 2020 21:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266423;
        bh=6bmRWMRph2R4LB45hiyjk/v3woSDmYFDD8MNpo3g2L4=;
        h=Date:From:To:Subject:From;
        b=x86UtnjiaVhnVS44WkpxktZWZLFeCZSH5AqA0SFFRe+whc7eHJ+dLUK89abnKgaLC
         Ab1ZxyKJFNzV3/KaIIo152RoXR6rVU1qAZEeK3s0Vx9sf4WfcHOgGY1coWGDeUsD6Q
         P/wBYMCvq9uvXgk60Vt/AFaE6LVhIanqBmqJPjeI=
Date:   Wed, 12 Aug 2020 14:07:02 -0700
From:   akpm@linux-foundation.org
To:     bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        luto@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org,
        peterx@redhat.com, peterz@infradead.org, tglx@linutronix.de
Subject:  [merged] mm-x86-use-general-page-fault-accounting.patch
 removed from -mm tree
Message-ID: <20200812210702.3pr_rV7FA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/x86: use general page fault accounting
has been removed from the -mm tree.  Its filename was
     mm-x86-use-general-page-fault-accounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/x86: use general page fault accounting

Use the general page fault accounting by passing regs into
handle_mm_fault().

Link: http://lkml.kernel.org/r/20200707225021.200906-23-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/fault.c |   17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

--- a/arch/x86/mm/fault.c~mm-x86-use-general-page-fault-accounting
+++ a/arch/x86/mm/fault.c
@@ -1139,7 +1139,7 @@ void do_user_addr_fault(struct pt_regs *
 	struct vm_area_struct *vma;
 	struct task_struct *tsk;
 	struct mm_struct *mm;
-	vm_fault_t fault, major = 0;
+	vm_fault_t fault;
 	unsigned int flags = FAULT_FLAG_DEFAULT;
 
 	tsk = current;
@@ -1291,8 +1291,7 @@ good_area:
 	 * userland). The return to userland is identified whenever
 	 * FAULT_FLAG_USER|FAULT_FLAG_KILLABLE are both set in flags.
 	 */
-	fault = handle_mm_fault(vma, address, flags, NULL);
-	major |= fault & VM_FAULT_MAJOR;
+	fault = handle_mm_fault(vma, address, flags, regs);
 
 	/* Quick path to respond to signals */
 	if (fault_signal_pending(fault, regs)) {
@@ -1319,18 +1318,6 @@ good_area:
 		return;
 	}
 
-	/*
-	 * Major/minor page fault accounting. If any of the events
-	 * returned VM_FAULT_MAJOR, we account it as a major fault.
-	 */
-	if (major) {
-		tsk->maj_flt++;
-		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1, regs, address);
-	} else {
-		tsk->min_flt++;
-		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1, regs, address);
-	}
-
 	check_v8086_mode(regs, address, tsk);
 }
 NOKPROBE_SYMBOL(do_user_addr_fault);
_

Patches currently in -mm which might be from peterx@redhat.com are


