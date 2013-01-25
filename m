From: akpm@linux-foundation.org
Subject: [merged] uv-fix-incorrect-tlb-flush-all-issue.patch removed from -mm tree
Date: Fri, 25 Jan 2013 13:37:43 -0800
Message-ID: <20130125213743.D3CD25A4241@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:32772 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011Ab3AYVhp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 Jan 2013 16:37:45 -0500
Received: by mail-qa0-f74.google.com with SMTP id r4so84560qaq.5
        for <mm-commits@vger.kernel.org>; Fri, 25 Jan 2013 13:37:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.shi@intel.com, cpw@sgi.com, hpa@zytor.com, jbeulich@suse.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/x86/platform/uv: fix incorrect tlb flush all issue
has been removed from the -mm tree.  Its filename was
     uv-fix-incorrect-tlb-flush-all-issue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alex Shi <alex.shi@intel.com>
Subject: arch/x86/platform/uv: fix incorrect tlb flush all issue

The flush tlb optimization code has logical issue on UV platform.  It
doesn't flush the full range at all, since it simply ignores its 'end'
parameter (and hence also the "all" indicator) in uv_flush_tlb_others()
function.

Cliff's notes:

: I tested the patch on a UV.  It has the effect of either clearing 1 or all
: TLBs in a cpu.  I added some debugging to test for the cases when clearing
: all TLBs is overkill, and in practice it happens very seldom.

Reported-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Alex Shi <alex.shi@intel.com>
Signed-off-by: Cliff Wickman <cpw@sgi.com>
Tested-by: Cliff Wickman <cpw@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/uv/uv.h  |    2 +-
 arch/x86/platform/uv/tlb_uv.c |   10 +++++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

diff -puN arch/x86/include/asm/uv/uv.h~uv-fix-incorrect-tlb-flush-all-issue arch/x86/include/asm/uv/uv.h
--- a/arch/x86/include/asm/uv/uv.h~uv-fix-incorrect-tlb-flush-all-issue
+++ a/arch/x86/include/asm/uv/uv.h
@@ -16,7 +16,7 @@ extern void uv_system_init(void);
 extern const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
 						 struct mm_struct *mm,
 						 unsigned long start,
-						 unsigned end,
+						 unsigned long end,
 						 unsigned int cpu);
 
 #else	/* X86_UV */
diff -puN arch/x86/platform/uv/tlb_uv.c~uv-fix-incorrect-tlb-flush-all-issue arch/x86/platform/uv/tlb_uv.c
--- a/arch/x86/platform/uv/tlb_uv.c~uv-fix-incorrect-tlb-flush-all-issue
+++ a/arch/x86/platform/uv/tlb_uv.c
@@ -1034,7 +1034,8 @@ static int set_distrib_bits(struct cpuma
  * globally purge translation cache of a virtual address or all TLB's
  * @cpumask: mask of all cpu's in which the address is to be removed
  * @mm: mm_struct containing virtual address range
- * @va: virtual address to be removed (or TLB_FLUSH_ALL for all TLB's on cpu)
+ * @start: start virtual address to be removed from TLB
+ * @end: end virtual address to be remove from TLB
  * @cpu: the current cpu
  *
  * This is the entry point for initiating any UV global TLB shootdown.
@@ -1056,7 +1057,7 @@ static int set_distrib_bits(struct cpuma
  */
 const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
 				struct mm_struct *mm, unsigned long start,
-				unsigned end, unsigned int cpu)
+				unsigned long end, unsigned int cpu)
 {
 	int locals = 0;
 	int remotes = 0;
@@ -1113,7 +1114,10 @@ const struct cpumask *uv_flush_tlb_other
 
 	record_send_statistics(stat, locals, hubs, remotes, bau_desc);
 
-	bau_desc->payload.address = start;
+	if (!end || (end - start) <= PAGE_SIZE)
+		bau_desc->payload.address = start;
+	else
+		bau_desc->payload.address = TLB_FLUSH_ALL;
 	bau_desc->payload.sending_cpu = cpu;
 	/*
 	 * uv_flush_send_and_wait returns 0 if all cpu's were messaged,
_

Patches currently in -mm which might be from alex.shi@intel.com are

linux-next.patch

