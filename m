From: akpm@linux-foundation.org
Subject: [failures] arch-x86-platform-uv-tlb_uvc-fix-incorrect-tlb-flush-all-issue.patch removed from -mm tree
Date: Thu, 06 Sep 2012 15:23:48 -0700
Message-ID: <20120906231147.1109B100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:42715 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624Ab2IFXLs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Sep 2012 19:11:48 -0400
Received: by yenq6 with SMTP id q6so257795yen.1
        for <mm-commits@vger.kernel.org>; Thu, 06 Sep 2012 16:11:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.shi@intel.com, hpa@zytor.com, jbeulich@suse.com, mingo@elte.hu, steiner@sgi.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/x86/platform/uv/tlb_uv.c: fix incorrect tlb flush all issue
has been removed from the -mm tree.  Its filename was
     arch-x86-platform-uv-tlb_uvc-fix-incorrect-tlb-flush-all-issue.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Alex Shi <alex.shi@intel.com>
Subject: arch/x86/platform/uv/tlb_uv.c: fix incorrect tlb flush all issue

The flush tlb optimization code has a logical issue on the UV platform. 
It doesn't flush the full range at all, since it simply ignores its 'end'
parameter (and hence also the "all" indicator) in uv_flush_tlb_others().

This patch fixes this issue, but is untested due to lack of hardware.

Reported-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Alex Shi <alex.shi@intel.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/uv/uv_bau.h |    6 ++++--
 arch/x86/platform/uv/tlb_uv.c    |   14 ++++++++------
 2 files changed, 12 insertions(+), 8 deletions(-)

diff -puN arch/x86/include/asm/uv/uv_bau.h~arch-x86-platform-uv-tlb_uvc-fix-incorrect-tlb-flush-all-issue arch/x86/include/asm/uv/uv_bau.h
--- a/arch/x86/include/asm/uv/uv_bau.h~arch-x86-platform-uv-tlb_uvc-fix-incorrect-tlb-flush-all-issue
+++ a/arch/x86/include/asm/uv/uv_bau.h
@@ -225,8 +225,10 @@ struct bau_local_cpumask {
  * The payload is software-defined for INTD transactions
  */
 struct bau_msg_payload {
-	unsigned long	address;		/* signifies a page or all
-						   TLB's of the cpu */
+	unsigned long	start;			/* start address to flush TLB
+						   of the cpu */
+	unsigned long	end;			/* end address to flush TLB
+						   of the cpu */
 	/* 64 bits */
 	unsigned short	sending_cpu;		/* filled in by sender */
 	/* 16 bits */
diff -puN arch/x86/platform/uv/tlb_uv.c~arch-x86-platform-uv-tlb_uvc-fix-incorrect-tlb-flush-all-issue arch/x86/platform/uv/tlb_uv.c
--- a/arch/x86/platform/uv/tlb_uv.c~arch-x86-platform-uv-tlb_uvc-fix-incorrect-tlb-flush-all-issue
+++ a/arch/x86/platform/uv/tlb_uv.c
@@ -280,12 +280,12 @@ static void bau_process_message(struct m
 	/*
 	 * This must be a normal message, or retry of a normal message
 	 */
-	if (msg->address == TLB_FLUSH_ALL) {
+	if (msg->end == 0) {
+		__flush_tlb_one(msg->start);
+		stat->d_onetlb++;
+	} else {
 		local_flush_tlb();
 		stat->d_alltlb++;
-	} else {
-		__flush_tlb_one(msg->address);
-		stat->d_onetlb++;
 	}
 	stat->d_requestee++;
 
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
@@ -1113,7 +1114,8 @@ const struct cpumask *uv_flush_tlb_other
 
 	record_send_statistics(stat, locals, hubs, remotes, bau_desc);
 
-	bau_desc->payload.address = start;
+	bau_desc->payload.start = start;
+	bau_desc->payload.end	= end;
 	bau_desc->payload.sending_cpu = cpu;
 	/*
 	 * uv_flush_send_and_wait returns 0 if all cpu's were messaged,
_

Patches currently in -mm which might be from alex.shi@intel.com are

linux-next.patch

