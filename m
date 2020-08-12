Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 029EEC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:06:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0B6C20838
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266379;
	bh=8FfdrxLPdGD5k0P7vSGNxj1q8sFs2nvDZ3Vfvu3LVnU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=GEYhLr5K3C6IKYOwq6kOrKS0ct95NAGS31Xu4FMgFIR2YZt9yoHbVZ4JcVN8038fb
	 zB67YFsUTpoGHR/hwBtMgchiSoGGIsFCB8I3tersasqEwiCc51Zet7zUXzvMEZ/ODs
	 4uclKib/nMHoCCEqqz3EA/jrmRI4dQsixKYkCs6I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgHLVGT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:06:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:60998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726508AbgHLVGT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:06:19 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADD9F2078B;
        Wed, 12 Aug 2020 21:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266375;
        bh=8FfdrxLPdGD5k0P7vSGNxj1q8sFs2nvDZ3Vfvu3LVnU=;
        h=Date:From:To:Subject:From;
        b=epNs+2vJL3hWp4f/ssw183coWopxJGkNSKpjNICqIfDp/IKz6TRXRJvKPZeuGao0p
         RlNJgovUek1IOGDiyFDbw6BehghlkVtSGsgAhr3ugRsQIEjJagznZRyH1q8LCkmHtf
         8/cFUsAxbqj2RRl87PR6Un/bPaiXCAISEfj7Y1EU=
Date:   Wed, 12 Aug 2020 14:06:13 -0700
From:   akpm@linux-foundation.org
To:     agordeev@linux.ibm.com, aou@eecs.berkeley.edu,
        bcain@codeaurora.org, benh@kernel.crashing.org,
        borntraeger@de.ibm.com, bp@alien8.de, catalin.marinas@arm.com,
        chris@zankel.net, dalias@libc.org, dave.hansen@linux.intel.com,
        davem@davemloft.net, deanbo422@gmail.com, deller@gmx.de,
        geert@linux-m68k.org, gerald.schaefer@de.ibm.com,
        gor@linux.ibm.com, green.hu@gmail.com, guoren@kernel.org,
        heiko.carstens@de.ibm.com, hpa@zytor.com, ink@jurassic.park.msu.ru,
        James.Bottomley@HansenPartnership.com, jcmvbkbc@gmail.com,
        jhubbard@nvidia.com, jonas@southpole.se, ley.foon.tan@intel.com,
        linux@armlinux.org.uk, luto@kernel.org, mattst88@gmail.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, monstr@monstr.eu,
        mpe@ellerman.id.au, nickhu@andestech.com, palmer@dabbelt.com,
        paul.walmsley@sifive.com, paulus@samba.org, penberg@kernel.org,
        peterx@redhat.com, peterz@infradead.org, rth@twiddle.net,
        shorne@gmail.com, stefan.kristiansson@saunalahti.fi,
        tglx@linutronix.de, tony.luck@intel.com,
        torvalds@linux-foundation.org, tsbogend@alpha.franken.de,
        vgupta@synopsys.com, will@kernel.org, ysato@users.sourceforge.jp
Subject:  [merged]
 mm-do-page-fault-accounting-in-handle_mm_fault.patch removed from -mm tree
Message-ID: <20200812210613.nEiBPHjM6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: do page fault accounting in handle_mm_fault
has been removed from the -mm tree.  Its filename was
     mm-do-page-fault-accounting-in-handle_mm_fault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm: do page fault accounting in handle_mm_fault

Patch series "mm: Page fault accounting cleanups", v5.

This is v5 of the pf accounting cleanup series.  It originates from Gerald
Schaefer's report on an issue a week ago regarding to incorrect page fault
accountings for retried page fault after commit 4064b9827063 ("mm: allow
VM_FAULT_RETRY for multiple times"):

  https://lore.kernel.org/lkml/20200610174811.44b94525@thinkpad/

What this series did:

  - Correct page fault accounting: we do accounting for a page fault
    (no matter whether it's from #PF handling, or gup, or anything else)
    only with the one that completed the fault.  For example, page fault
    retries should not be counted in page fault counters.  Same to the
    perf events.

  - Unify definition of PERF_COUNT_SW_PAGE_FAULTS: currently this perf
    event is used in an adhoc way across different archs.

    Case (1): for many archs it's done at the entry of a page fault
    handler, so that it will also cover e.g.  errornous faults.

    Case (2): for some other archs, it is only accounted when the page
    fault is resolved successfully.

    Case (3): there're still quite some archs that have not enabled
    this perf event.

    Since this series will touch merely all the archs, we unify this
    perf event to always follow case (1), which is the one that makes most
    sense.  And since we moved the accounting into handle_mm_fault, the
    other two MAJ/MIN perf events are well taken care of naturally.

  - Unify definition of "major faults": the definition of "major
    fault" is slightly changed when used in accounting (not
    VM_FAULT_MAJOR).  More information in patch 1.

  - Always account the page fault onto the one that triggered the page
    fault.  This does not matter much for #PF handlings, but mostly for
    gup.  More information on this in patch 25.

Patchset layout:

Patch 1:     Introduced the accounting in handle_mm_fault(), not enabled.
Patch 2-23:  Enable the new accounting for arch #PF handlers one by one.
Patch 24:    Enable the new accounting for the rest outliers (gup, iommu, etc.)
Patch 25:    Cleanup GUP task_struct pointer since it's not needed any more


This patch (of 25):

This is a preparation patch to move page fault accountings into the
general code in handle_mm_fault().  This includes both the per task
flt_maj/flt_min counters, and the major/minor page fault perf events.  To
do this, the pt_regs pointer is passed into handle_mm_fault().

PERF_COUNT_SW_PAGE_FAULTS should still be kept in per-arch page fault
handlers.

So far, all the pt_regs pointer that passed into handle_mm_fault() is
NULL, which means this patch should have no intented functional change.

Link: http://lkml.kernel.org/r/20200707225021.200906-1-peterx@redhat.com
Link: http://lkml.kernel.org/r/20200707225021.200906-2-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brian Cain <bcain@codeaurora.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Guo Ren <guoren@kernel.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Ley Foon Tan <ley.foon.tan@intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Rich Felker <dalias@libc.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vincent Chen <deanbo422@gmail.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/mm/fault.c         |    2 -
 arch/arc/mm/fault.c           |    2 -
 arch/arm/mm/fault.c           |    2 -
 arch/arm64/mm/fault.c         |    2 -
 arch/csky/mm/fault.c          |    3 +
 arch/hexagon/mm/vm_fault.c    |    2 -
 arch/ia64/mm/fault.c          |    2 -
 arch/m68k/mm/fault.c          |    2 -
 arch/microblaze/mm/fault.c    |    2 -
 arch/mips/mm/fault.c          |    2 -
 arch/nds32/mm/fault.c         |    2 -
 arch/nios2/mm/fault.c         |    2 -
 arch/openrisc/mm/fault.c      |    2 -
 arch/parisc/mm/fault.c        |    2 -
 arch/powerpc/mm/copro_fault.c |    2 -
 arch/powerpc/mm/fault.c       |    2 -
 arch/riscv/mm/fault.c         |    2 -
 arch/s390/mm/fault.c          |    2 -
 arch/sh/mm/fault.c            |    2 -
 arch/sparc/mm/fault_32.c      |    4 +-
 arch/sparc/mm/fault_64.c      |    2 -
 arch/um/kernel/trap.c         |    2 -
 arch/x86/mm/fault.c           |    2 -
 arch/xtensa/mm/fault.c        |    2 -
 drivers/iommu/amd/iommu_v2.c  |    2 -
 drivers/iommu/intel/svm.c     |    3 +
 include/linux/mm.h            |    7 ++-
 mm/gup.c                      |    4 +-
 mm/hmm.c                      |    3 +
 mm/ksm.c                      |    3 +
 mm/memory.c                   |   64 +++++++++++++++++++++++++++++++-
 31 files changed, 103 insertions(+), 34 deletions(-)

--- a/arch/alpha/mm/fault.c~mm-do-page-fault-accounting-in-handle_mm_fault
+++ a/arch/alpha/mm/fault.c
@@ -148,7 +148,7 @@ retry:
 	/* If for any reason at all we couldn't handle the fault,
 	   make sure we exit gracefully rather than endlessly redo
 	   the fault.  */
-	fault = handle_mm_fault(vma, address, flags);
+	fault = handle_mm_fault(vma, address, flags, NULL);
 
 	if (fault_signal_pending(fault, regs))
 		return;
--- a/arch/arc/mm/fault.c~mm-do-page-fault-accounting-in-handle_mm_fault
+++ a/arch/arc/mm/fault.c
@@ -130,7 +130,7 @@ retry:
 		goto bad_area;
 	}
 
-	fault = handle_mm_fault(vma, address, flags);
+	fault = handle_mm_fault(vma, address, flags, NULL);
 
 	/* Quick path to respond to signals */
 	if (fault_signal_pending(fault, regs)) {
--- a/arch/arm64/mm/fault.c~mm-do-page-fault-accounting-in-handle_mm_fault
+++ a/arch/arm64/mm/fault.c
@@ -428,7 +428,7 @@ static vm_fault_t __do_page_fault(struct
 	 */
 	if (!(vma->vm_flags & vm_flags))
 		return VM_FAULT_BADACCESS;
-	return handle_mm_fault(vma, addr & PAGE_MASK, mm_flags);
+	return handle_mm_fault(vma, addr & PAGE_MASK, mm_flags, NULL);
 }
 
 static bool is_el0_instruction_abort(unsigned int esr)
--- a/arch/arm/mm/fault.c~mm-do-page-fault-accounting-in-handle_mm_fault
+++ a/arch/arm/mm/fault.c
@@ -224,7 +224,7 @@ good_area:
 		goto out;
 	}
 
-	return handle_mm_fault(vma, addr & PAGE_MASK, flags);
+	return handle_mm_fault(vma, addr & PAGE_MASK, flags, NULL);
 
 check_stack:
 	/* Don't allow expansion below FIRST_USER_ADDRESS */
--- a/arch/csky/mm/fault.c~mm-do-page-fault-accounting-in-handle_mm_fault
+++ a/arch/csky/mm/fault.c
@@ -150,7 +150,8 @@ good_area:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(vma, address, write ? FAULT_FLAG_WRITE : 0);
+	fault = handle_mm_fault(vma, address, write ? FAULT_FLAG_WRITE : 0,
+				NULL);
 	if (unlikely(fault & VM_FAULT_ERROR)) {
 		if (fault & VM_FAULT_OOM)
 			goto out_of_memory;
--- a/arch/hexagon/mm/vm_fault.c~mm-do-page-fault-accounting-in-handle_mm_fault
+++ a/arch/hexagon/mm/vm_fault.c
@@ -88,7 +88,7 @@ good_area:
 		break;
 	}
 
-	fault = handle_mm_fault(vma, address, flags);
+	fault = handle_mm_fault(vma, address, flags, NULL);
 
 	if (fault_signal_pending(fault, regs))
 		return;
--- a/arch/ia64/mm/fault.c~mm-do-page-fault-accounting-in-handle_mm_fault
+++ a/arch/ia64/mm/fault.c
@@ -143,7 +143,7 @@ retry:
 	 * sure we exit gracefully rather than endlessly redo the
 	 * fault.
 	 */
-	fault = handle_mm_fault(vma, address, flags);
+	fault = handle_mm_fault(vma, address, flags, NULL);
 
 	if (fault_signal_pending(fault, regs))
 		return;
--- a/arch/m68k/mm/fault.c~mm-do-page-fault-accounting-in-handle_mm_fault
+++ a/arch/m68k/mm/fault.c
@@ -134,7 +134,7 @@ good_area:
 	 * the fault.
 	 */
 
-	fault = handle_mm_fault(vma, address, flags);
+	fault = handle_mm_fault(vma, address, flags, NULL);
 	pr_debug("handle_mm_fault returns %x\n", fault);
 
 	if (fault_signal_pending(fault, regs))
--- a/arch/microblaze/mm/fault.c~mm-do-page-fault-accounting-in-handle_mm_fault
+++ a/arch/microblaze/mm/fault.c
@@ -214,7 +214,7 @@ good_area:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(vma, address, flags);
+	fault = handle_mm_fault(vma, address, flags, NULL);
 
 	if (fault_signal_pending(fault, regs))
 		return;
--- a/arch/mips/mm/fault.c~mm-do-page-fault-accounting-in-handle_mm_fault
+++ a/arch/mips/mm/fault.c
@@ -152,7 +152,7 @@ good_area:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(vma, address, flags);
+	fault = handle_mm_fault(vma, address, flags, NULL);
 
 	if (fault_signal_pending(fault, regs))
 		return;
--- a/arch/nds32/mm/fault.c~mm-do-page-fault-accounting-in-handle_mm_fault
+++ a/arch/nds32/mm/fault.c
@@ -206,7 +206,7 @@ good_area:
 	 * the fault.
 	 */
 
-	fault = handle_mm_fault(vma, addr, flags);
+	fault = handle_mm_fault(vma, addr, flags, NULL);
 
 	/*
 	 * If we need to retry but a fatal signal is pending, handle the
--- a/arch/nios2/mm/fault.c~mm-do-page-fault-accounting-in-handle_mm_fault
+++ a/arch/nios2/mm/fault.c
@@ -131,7 +131,7 @@ good_area:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(vma, address, flags);
+	fault = handle_mm_fault(vma, address, flags, NULL);
 
 	if (fault_signal_pending(fault, regs))
 		return;
--- a/arch/openrisc/mm/fault.c~mm-do-page-fault-accounting-in-handle_mm_fault
+++ a/arch/openrisc/mm/fault.c
@@ -159,7 +159,7 @@ good_area:
 	 * the fault.
 	 */
 
-	fault = handle_mm_fault(vma, address, flags);
+	fault = handle_mm_fault(vma, address, flags, NULL);
 
 	if (fault_signal_pending(fault, regs))
 		return;
--- a/arch/parisc/mm/fault.c~mm-do-page-fault-accounting-in-handle_mm_fault
+++ a/arch/parisc/mm/fault.c
@@ -302,7 +302,7 @@ good_area:
 	 * fault.
 	 */
 
-	fault = handle_mm_fault(vma, address, flags);
+	fault = handle_mm_fault(vma, address, flags, NULL);
 
 	if (fault_signal_pending(fault, regs))
 		return;
--- a/arch/powerpc/mm/copro_fault.c~mm-do-page-fault-accounting-in-handle_mm_fault
+++ a/arch/powerpc/mm/copro_fault.c
@@ -64,7 +64,7 @@ int copro_handle_mm_fault(struct mm_stru
 	}
 
 	ret = 0;
-	*flt = handle_mm_fault(vma, ea, is_write ? FAULT_FLAG_WRITE : 0);
+	*flt = handle_mm_fault(vma, ea, is_write ? FAULT_FLAG_WRITE : 0, NULL);
 	if (unlikely(*flt & VM_FAULT_ERROR)) {
 		if (*flt & VM_FAULT_OOM) {
 			ret = -ENOMEM;
--- a/arch/powerpc/mm/fault.c~mm-do-page-fault-accounting-in-handle_mm_fault
+++ a/arch/powerpc/mm/fault.c
@@ -511,7 +511,7 @@ retry:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(vma, address, flags);
+	fault = handle_mm_fault(vma, address, flags, NULL);
 
 	major |= fault & VM_FAULT_MAJOR;
 
--- a/arch/riscv/mm/fault.c~mm-do-page-fault-accounting-in-handle_mm_fault
+++ a/arch/riscv/mm/fault.c
@@ -109,7 +109,7 @@ good_area:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(vma, addr, flags);
+	fault = handle_mm_fault(vma, addr, flags, NULL);
 
 	/*
 	 * If we need to retry but a fatal signal is pending, handle the
--- a/arch/s390/mm/fault.c~mm-do-page-fault-accounting-in-handle_mm_fault
+++ a/arch/s390/mm/fault.c
@@ -476,7 +476,7 @@ retry:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(vma, address, flags);
+	fault = handle_mm_fault(vma, address, flags, NULL);
 	if (fault_signal_pending(fault, regs)) {
 		fault = VM_FAULT_SIGNAL;
 		if (flags & FAULT_FLAG_RETRY_NOWAIT)
--- a/arch/sh/mm/fault.c~mm-do-page-fault-accounting-in-handle_mm_fault
+++ a/arch/sh/mm/fault.c
@@ -482,7 +482,7 @@ good_area:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(vma, address, flags);
+	fault = handle_mm_fault(vma, address, flags, NULL);
 
 	if (unlikely(fault & (VM_FAULT_RETRY | VM_FAULT_ERROR)))
 		if (mm_fault_error(regs, error_code, address, fault))
--- a/arch/sparc/mm/fault_32.c~mm-do-page-fault-accounting-in-handle_mm_fault
+++ a/arch/sparc/mm/fault_32.c
@@ -234,7 +234,7 @@ good_area:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(vma, address, flags);
+	fault = handle_mm_fault(vma, address, flags, NULL);
 
 	if (fault_signal_pending(fault, regs))
 		return;
@@ -410,7 +410,7 @@ good_area:
 		if (!(vma->vm_flags & (VM_READ | VM_EXEC)))
 			goto bad_area;
 	}
-	switch (handle_mm_fault(vma, address, flags)) {
+	switch (handle_mm_fault(vma, address, flags, NULL)) {
 	case VM_FAULT_SIGBUS:
 	case VM_FAULT_OOM:
 		goto do_sigbus;
--- a/arch/sparc/mm/fault_64.c~mm-do-page-fault-accounting-in-handle_mm_fault
+++ a/arch/sparc/mm/fault_64.c
@@ -422,7 +422,7 @@ good_area:
 			goto bad_area;
 	}
 
-	fault = handle_mm_fault(vma, address, flags);
+	fault = handle_mm_fault(vma, address, flags, NULL);
 
 	if (fault_signal_pending(fault, regs))
 		goto exit_exception;
--- a/arch/um/kernel/trap.c~mm-do-page-fault-accounting-in-handle_mm_fault
+++ a/arch/um/kernel/trap.c
@@ -71,7 +71,7 @@ good_area:
 	do {
 		vm_fault_t fault;
 
-		fault = handle_mm_fault(vma, address, flags);
+		fault = handle_mm_fault(vma, address, flags, NULL);
 
 		if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
 			goto out_nosemaphore;
--- a/arch/x86/mm/fault.c~mm-do-page-fault-accounting-in-handle_mm_fault
+++ a/arch/x86/mm/fault.c
@@ -1291,7 +1291,7 @@ good_area:
 	 * userland). The return to userland is identified whenever
 	 * FAULT_FLAG_USER|FAULT_FLAG_KILLABLE are both set in flags.
 	 */
-	fault = handle_mm_fault(vma, address, flags);
+	fault = handle_mm_fault(vma, address, flags, NULL);
 	major |= fault & VM_FAULT_MAJOR;
 
 	/* Quick path to respond to signals */
--- a/arch/xtensa/mm/fault.c~mm-do-page-fault-accounting-in-handle_mm_fault
+++ a/arch/xtensa/mm/fault.c
@@ -107,7 +107,7 @@ good_area:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(vma, address, flags);
+	fault = handle_mm_fault(vma, address, flags, NULL);
 
 	if (fault_signal_pending(fault, regs))
 		return;
--- a/drivers/iommu/amd/iommu_v2.c~mm-do-page-fault-accounting-in-handle_mm_fault
+++ a/drivers/iommu/amd/iommu_v2.c
@@ -495,7 +495,7 @@ static void do_fault(struct work_struct
 	if (access_error(vma, fault))
 		goto out;
 
-	ret = handle_mm_fault(vma, address, flags);
+	ret = handle_mm_fault(vma, address, flags, NULL);
 out:
 	mmap_read_unlock(mm);
 
--- a/drivers/iommu/intel/svm.c~mm-do-page-fault-accounting-in-handle_mm_fault
+++ a/drivers/iommu/intel/svm.c
@@ -872,7 +872,8 @@ static irqreturn_t prq_event_thread(int
 			goto invalid;
 
 		ret = handle_mm_fault(vma, address,
-				      req->wr_req ? FAULT_FLAG_WRITE : 0);
+				      req->wr_req ? FAULT_FLAG_WRITE : 0,
+				      NULL);
 		if (ret & VM_FAULT_ERROR)
 			goto invalid;
 
--- a/include/linux/mm.h~mm-do-page-fault-accounting-in-handle_mm_fault
+++ a/include/linux/mm.h
@@ -38,6 +38,7 @@ struct file_ra_state;
 struct user_struct;
 struct writeback_control;
 struct bdi_writeback;
+struct pt_regs;
 
 void init_mm_internals(void);
 
@@ -1658,7 +1659,8 @@ int invalidate_inode_page(struct page *p
 
 #ifdef CONFIG_MMU
 extern vm_fault_t handle_mm_fault(struct vm_area_struct *vma,
-			unsigned long address, unsigned int flags);
+				  unsigned long address, unsigned int flags,
+				  struct pt_regs *regs);
 extern int fixup_user_fault(struct task_struct *tsk, struct mm_struct *mm,
 			    unsigned long address, unsigned int fault_flags,
 			    bool *unlocked);
@@ -1668,7 +1670,8 @@ void unmap_mapping_range(struct address_
 		loff_t const holebegin, loff_t const holelen, int even_cows);
 #else
 static inline vm_fault_t handle_mm_fault(struct vm_area_struct *vma,
-		unsigned long address, unsigned int flags)
+					 unsigned long address, unsigned int flags,
+					 struct pt_regs *regs)
 {
 	/* should never happen if there's no MMU */
 	BUG();
--- a/mm/gup.c~mm-do-page-fault-accounting-in-handle_mm_fault
+++ a/mm/gup.c
@@ -884,7 +884,7 @@ static int faultin_page(struct task_stru
 		fault_flags |= FAULT_FLAG_TRIED;
 	}
 
-	ret = handle_mm_fault(vma, address, fault_flags);
+	ret = handle_mm_fault(vma, address, fault_flags, NULL);
 	if (ret & VM_FAULT_ERROR) {
 		int err = vm_fault_to_errno(ret, *flags);
 
@@ -1238,7 +1238,7 @@ retry:
 	    fatal_signal_pending(current))
 		return -EINTR;
 
-	ret = handle_mm_fault(vma, address, fault_flags);
+	ret = handle_mm_fault(vma, address, fault_flags, NULL);
 	major |= ret & VM_FAULT_MAJOR;
 	if (ret & VM_FAULT_ERROR) {
 		int err = vm_fault_to_errno(ret, 0);
--- a/mm/hmm.c~mm-do-page-fault-accounting-in-handle_mm_fault
+++ a/mm/hmm.c
@@ -75,7 +75,8 @@ static int hmm_vma_fault(unsigned long a
 	}
 
 	for (; addr < end; addr += PAGE_SIZE)
-		if (handle_mm_fault(vma, addr, fault_flags) & VM_FAULT_ERROR)
+		if (handle_mm_fault(vma, addr, fault_flags, NULL) &
+		    VM_FAULT_ERROR)
 			return -EFAULT;
 	return -EBUSY;
 }
--- a/mm/ksm.c~mm-do-page-fault-accounting-in-handle_mm_fault
+++ a/mm/ksm.c
@@ -480,7 +480,8 @@ static int break_ksm(struct vm_area_stru
 			break;
 		if (PageKsm(page))
 			ret = handle_mm_fault(vma, addr,
-					FAULT_FLAG_WRITE | FAULT_FLAG_REMOTE);
+					      FAULT_FLAG_WRITE | FAULT_FLAG_REMOTE,
+					      NULL);
 		else
 			ret = VM_FAULT_WRITE;
 		put_page(page);
--- a/mm/memory.c~mm-do-page-fault-accounting-in-handle_mm_fault
+++ a/mm/memory.c
@@ -71,6 +71,8 @@
 #include <linux/dax.h>
 #include <linux/oom.h>
 #include <linux/numa.h>
+#include <linux/perf_event.h>
+#include <linux/ptrace.h>
 
 #include <trace/events/kmem.h>
 
@@ -4356,6 +4358,64 @@ retry_pud:
 	return handle_pte_fault(&vmf);
 }
 
+/**
+ * mm_account_fault - Do page fault accountings
+ *
+ * @regs: the pt_regs struct pointer.  When set to NULL, will skip accounting
+ *        of perf event counters, but we'll still do the per-task accounting to
+ *        the task who triggered this page fault.
+ * @address: the faulted address.
+ * @flags: the fault flags.
+ * @ret: the fault retcode.
+ *
+ * This will take care of most of the page fault accountings.  Meanwhile, it
+ * will also include the PERF_COUNT_SW_PAGE_FAULTS_[MAJ|MIN] perf counter
+ * updates.  However note that the handling of PERF_COUNT_SW_PAGE_FAULTS should
+ * still be in per-arch page fault handlers at the entry of page fault.
+ */
+static inline void mm_account_fault(struct pt_regs *regs,
+				    unsigned long address, unsigned int flags,
+				    vm_fault_t ret)
+{
+	bool major;
+
+	/*
+	 * We don't do accounting for some specific faults:
+	 *
+	 * - Unsuccessful faults (e.g. when the address wasn't valid).  That
+	 *   includes arch_vma_access_permitted() failing before reaching here.
+	 *   So this is not a "this many hardware page faults" counter.  We
+	 *   should use the hw profiling for that.
+	 *
+	 * - Incomplete faults (VM_FAULT_RETRY).  They will only be counted
+	 *   once they're completed.
+	 */
+	if (ret & (VM_FAULT_ERROR | VM_FAULT_RETRY))
+		return;
+
+	/*
+	 * We define the fault as a major fault when the final successful fault
+	 * is VM_FAULT_MAJOR, or if it retried (which implies that we couldn't
+	 * handle it immediately previously).
+	 */
+	major = (ret & VM_FAULT_MAJOR) || (flags & FAULT_FLAG_TRIED);
+
+	/*
+	 * If the fault is done for GUP, regs will be NULL, and we will skip
+	 * the fault accounting.
+	 */
+	if (!regs)
+		return;
+
+	if (major) {
+		current->maj_flt++;
+		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1, regs, address);
+	} else {
+		current->min_flt++;
+		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1, regs, address);
+	}
+}
+
 /*
  * By the time we get here, we already hold the mm semaphore
  *
@@ -4363,7 +4423,7 @@ retry_pud:
  * return value.  See filemap_fault() and __lock_page_or_retry().
  */
 vm_fault_t handle_mm_fault(struct vm_area_struct *vma, unsigned long address,
-		unsigned int flags)
+			   unsigned int flags, struct pt_regs *regs)
 {
 	vm_fault_t ret;
 
@@ -4404,6 +4464,8 @@ vm_fault_t handle_mm_fault(struct vm_are
 			mem_cgroup_oom_synchronize(false);
 	}
 
+	mm_account_fault(regs, address, flags, ret);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(handle_mm_fault);
_

Patches currently in -mm which might be from peterx@redhat.com are


