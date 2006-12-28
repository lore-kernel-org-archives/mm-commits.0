From: akpm@osdl.org
Subject: + use-correct-macros-in-raid-code-not-raw-asm.patch added to -mm tree
Date: Thu, 28 Dec 2006 15:57:22 -0800
Message-ID: <200612282357.kBSNvMrg016701@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:43624 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905AbWL1X6G (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Dec 2006 18:58:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, ak@muc.de, mingo@elte.hu, neilb@suse.de


The patch titled
     Use correct macros in raid code, not raw asm
has been added to the -mm tree.  Its filename is
     use-correct-macros-in-raid-code-not-raw-asm.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use correct macros in raid code, not raw asm
From: Rusty Russell <rusty@rustcorp.com.au>

This make sure it's paravirtualized correctly when CONFIG_PARAVIRT=y.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@muc.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/raid6x86.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/md/raid6x86.h~use-correct-macros-in-raid-code-not-raw-asm drivers/md/raid6x86.h
--- a/drivers/md/raid6x86.h~use-correct-macros-in-raid-code-not-raw-asm
+++ a/drivers/md/raid6x86.h
@@ -75,13 +75,14 @@ static inline unsigned long raid6_get_fp
 	unsigned long cr0;
 
 	preempt_disable();
-	asm volatile("mov %%cr0,%0 ; clts" : "=r" (cr0));
+	cr0 = read_cr0();
+	clts();
 	return cr0;
 }
 
 static inline void raid6_put_fpu(unsigned long cr0)
 {
-	asm volatile("mov %0,%%cr0" : : "r" (cr0));
+	write_cr0(cr0);
 	preempt_enable();
 }
 
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

use-correct-macros-in-raid-code-not-raw-asm.patch
use-correct-macros-in-raid-code-not-raw-asm-include.patch
paravirt-page-allocation-hooks-for-vmi-backend.patch
paravirt-paravirt-cpu-hypercall-batching-mode.patch
paravirt-iopl-handling-for-paravirt-guests.patch
paravirt-smp-boot-hook-for-paravirt.patch
paravirt-vmi-backend-for-paravirt-ops.patch
paravirt-vmi-timer-patches.patch
vmi-versus-hrtimers.patch

