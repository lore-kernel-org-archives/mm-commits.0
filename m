Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28865C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:07:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6FAD20774
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266431;
	bh=sTzzyrieT22kbiphvovn/JrBZA91H8Y/MmTkUiepBvg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ubKGQOIGnYE8eQ/UT8wGvY8M62T1SA+Se+zVw+rdQ0CaQCLoKGBZ8S8oiecVtEhDa
	 IdOYVUQgC1I3KbxLaDnCCa/uTe8ZtWvqzlu2Ghl9mdAthDI1GdDvtQWFNyf8C5JggF
	 7ijLO/h+jAN4DpjwrHbUF3S1d0eBrlELPAGM9I14=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgHLVHK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:07:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:34928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbgHLVHK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:07:10 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E885207F7;
        Wed, 12 Aug 2020 21:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266429;
        bh=sTzzyrieT22kbiphvovn/JrBZA91H8Y/MmTkUiepBvg=;
        h=Date:From:To:Subject:From;
        b=gGIzu3TKA2oIIedebFwpAqoajoSru0C9ZcyeYFk2Kq6yFVhOeGj8zq3ZIBT/c4fH+
         NZtIswYKuJgHwnzvqhm7C8ltI78iUnht0xxSDzUmVaURueBfvHxQBFK3fsFC1tkPvW
         RKYtrAAKsKt2HxtONlWqxYyMxF0pzoqLkDrEGyDw=
Date:   Wed, 12 Aug 2020 14:07:07 -0700
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
        tglx@linutronix.de, tony.luck@intel.com, tsbogend@alpha.franken.de,
        vgupta@synopsys.com, will@kernel.org, ysato@users.sourceforge.jp
Subject:  [merged]
 mm-clean-up-the-last-pieces-of-page-fault-accountings.patch removed from
 -mm tree
Message-ID: <20200812210707._OQRs--Am%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: clean up the last pieces of page fault accountings
has been removed from the -mm tree.  Its filename was
     mm-clean-up-the-last-pieces-of-page-fault-accountings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm: clean up the last pieces of page fault accountings

Here're the last pieces of page fault accounting that were still done
outside handle_mm_fault() where we still have regs==NULL when calling
handle_mm_fault():

arch/powerpc/mm/copro_fault.c:   copro_handle_mm_fault
arch/sparc/mm/fault_32.c:        force_user_fault
arch/um/kernel/trap.c:           handle_page_fault
mm/gup.c:                        faultin_page
                                 fixup_user_fault
mm/hmm.c:                        hmm_vma_fault
mm/ksm.c:                        break_ksm

Some of them has the issue of duplicated accounting for page fault
retries.  Some of them didn't do the accounting at all.

This patch cleans all these up by letting handle_mm_fault() to do per-task
page fault accounting even if regs==NULL (though we'll still skip the perf
event accountings).  With that, we can safely remove all the outliers now.

There's another functional change in that now we account the page faults
to the caller of gup, rather than the task_struct that passed into the gup
code.  More information of this can be found at [1].

After this patch, below things should never be touched again outside
handle_mm_fault():

  - task_struct.[maj|min]_flt
  - PERF_COUNT_SW_PAGE_FAULTS_[MAJ|MIN]

[1] https://lore.kernel.org/lkml/CAHk-=wj_V2Tps2QrMn20_W0OJF9xqNh52XSGA42s-ZJ8Y+GyKw@mail.gmail.com/

Link: http://lkml.kernel.org/r/20200707225021.200906-25-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
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

 arch/powerpc/mm/copro_fault.c |    5 -----
 arch/um/kernel/trap.c         |    4 ----
 mm/gup.c                      |   13 -------------
 mm/memory.c                   |   17 ++++++++++-------
 4 files changed, 10 insertions(+), 29 deletions(-)

--- a/arch/powerpc/mm/copro_fault.c~mm-clean-up-the-last-pieces-of-page-fault-accountings
+++ a/arch/powerpc/mm/copro_fault.c
@@ -76,11 +76,6 @@ int copro_handle_mm_fault(struct mm_stru
 		BUG();
 	}
 
-	if (*flt & VM_FAULT_MAJOR)
-		current->maj_flt++;
-	else
-		current->min_flt++;
-
 out_unlock:
 	mmap_read_unlock(mm);
 	return ret;
--- a/arch/um/kernel/trap.c~mm-clean-up-the-last-pieces-of-page-fault-accountings
+++ a/arch/um/kernel/trap.c
@@ -88,10 +88,6 @@ good_area:
 			BUG();
 		}
 		if (flags & FAULT_FLAG_ALLOW_RETRY) {
-			if (fault & VM_FAULT_MAJOR)
-				current->maj_flt++;
-			else
-				current->min_flt++;
 			if (fault & VM_FAULT_RETRY) {
 				flags |= FAULT_FLAG_TRIED;
 
--- a/mm/gup.c~mm-clean-up-the-last-pieces-of-page-fault-accountings
+++ a/mm/gup.c
@@ -893,13 +893,6 @@ static int faultin_page(struct task_stru
 		BUG();
 	}
 
-	if (tsk) {
-		if (ret & VM_FAULT_MAJOR)
-			tsk->maj_flt++;
-		else
-			tsk->min_flt++;
-	}
-
 	if (ret & VM_FAULT_RETRY) {
 		if (locked && !(fault_flags & FAULT_FLAG_RETRY_NOWAIT))
 			*locked = 0;
@@ -1255,12 +1248,6 @@ retry:
 		goto retry;
 	}
 
-	if (tsk) {
-		if (major)
-			tsk->maj_flt++;
-		else
-			tsk->min_flt++;
-	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(fixup_user_fault);
--- a/mm/memory.c~mm-clean-up-the-last-pieces-of-page-fault-accountings
+++ a/mm/memory.c
@@ -4400,20 +4400,23 @@ static inline void mm_account_fault(stru
 	 */
 	major = (ret & VM_FAULT_MAJOR) || (flags & FAULT_FLAG_TRIED);
 
+	if (major)
+		current->maj_flt++;
+	else
+		current->min_flt++;
+
 	/*
-	 * If the fault is done for GUP, regs will be NULL, and we will skip
-	 * the fault accounting.
+	 * If the fault is done for GUP, regs will be NULL.  We only do the
+	 * accounting for the per thread fault counters who triggered the
+	 * fault, and we skip the perf event updates.
 	 */
 	if (!regs)
 		return;
 
-	if (major) {
-		current->maj_flt++;
+	if (major)
 		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1, regs, address);
-	} else {
-		current->min_flt++;
+	else
 		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1, regs, address);
-	}
 }
 
 /*
_

Patches currently in -mm which might be from peterx@redhat.com are


