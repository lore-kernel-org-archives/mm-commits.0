From: akpm@linux-foundation.org
Subject: - ia64-fix-kprobes-reentrancy.patch removed from -mm tree
Date: Fri, 11 May 2007 22:36:17 -0700
Message-ID: <200705120536.l4C5aHF3002362@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51834 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757505AbXELFgT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:36:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anil.s.keshavamurthy@intel.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64: fix Kprobes reentrancy
has been removed from the -mm tree.  Its filename was
     ia64-fix-kprobes-reentrancy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ia64: fix Kprobes reentrancy
From: "Anil S Keshvamurthy@intel.com" <anil.s.keshavamurthy@intel.com>

In case of reentrance i.e when a probe handler calls a functions which
inturn has a probe, we save a previous kprobe information and just single
step the reentrant probe without calling the actual probe handler.  During
this reentracy period, if an interrupt occurs and if probe happens to
trigger in the inturrupt path, then we were corrupting the previous kprobe(
as we were overriding the previous kprobe info) info their by crashing the
system.  This patch fixes this issues by having a an array of previous
kprobe info struct(with the array size of 2).

This similar technique is not needed on i386 and x86_64 because by default
interrupts are turn off in the break/int3 exception handler.

Signed-off-by: "Anil S Keshavamurthy" <anil.s.keshavamurthy@intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/kprobes.c |   12 ++++++++----
 include/asm-ia64/kprobes.h |    4 +++-
 2 files changed, 11 insertions(+), 5 deletions(-)

diff -puN arch/ia64/kernel/kprobes.c~ia64-fix-kprobes-reentrancy arch/ia64/kernel/kprobes.c
--- a/arch/ia64/kernel/kprobes.c~ia64-fix-kprobes-reentrancy
+++ a/arch/ia64/kernel/kprobes.c
@@ -370,14 +370,18 @@ static int __kprobes valid_kprobe_addr(i
 
 static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
 {
-	kcb->prev_kprobe.kp = kprobe_running();
-	kcb->prev_kprobe.status = kcb->kprobe_status;
+	unsigned int i;
+	i = atomic_add_return(1, &kcb->prev_kprobe_index);
+	kcb->prev_kprobe[i-1].kp = kprobe_running();
+	kcb->prev_kprobe[i-1].status = kcb->kprobe_status;
 }
 
 static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
 {
-	__get_cpu_var(current_kprobe) = kcb->prev_kprobe.kp;
-	kcb->kprobe_status = kcb->prev_kprobe.status;
+	unsigned int i;
+	i = atomic_sub_return(1, &kcb->prev_kprobe_index);
+	__get_cpu_var(current_kprobe) = kcb->prev_kprobe[i].kp;
+	kcb->kprobe_status = kcb->prev_kprobe[i].status;
 }
 
 static void __kprobes set_current_kprobe(struct kprobe *p,
diff -puN include/asm-ia64/kprobes.h~ia64-fix-kprobes-reentrancy include/asm-ia64/kprobes.h
--- a/include/asm-ia64/kprobes.h~ia64-fix-kprobes-reentrancy
+++ a/include/asm-ia64/kprobes.h
@@ -71,13 +71,15 @@ struct prev_kprobe {
 
 #define	MAX_PARAM_RSE_SIZE	(0x60+0x60/0x3f)
 /* per-cpu kprobe control block */
+#define ARCH_PREV_KPROBE_SZ 2
 struct kprobe_ctlblk {
 	unsigned long kprobe_status;
 	struct pt_regs jprobe_saved_regs;
 	unsigned long jprobes_saved_stacked_regs[MAX_PARAM_RSE_SIZE];
 	unsigned long *bsp;
 	unsigned long cfm;
-	struct prev_kprobe prev_kprobe;
+	atomic_t prev_kprobe_index;
+	struct prev_kprobe prev_kprobe[ARCH_PREV_KPROBE_SZ];
 };
 
 #define JPROBE_ENTRY(pentry)	(kprobe_opcode_t *)pentry
_

Patches currently in -mm which might be from anil.s.keshavamurthy@intel.com are

origin.patch
