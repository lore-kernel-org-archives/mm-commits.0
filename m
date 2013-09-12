From: akpm@linux-foundation.org
Subject: [merged] mm-vmstats-track-tlb-flush-stats-on-up-too.patch removed from -mm tree
Date: Thu, 12 Sep 2013 12:42:29 -0700
Message-ID: <52321925.d3J2eFaFL/CVmbOo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58009 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab3ILTm3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:42:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com, dave.hansen@linux.intel.com, a.p.zijlstra@chello.nl, dave@sr71.net

Subject: [merged] mm-vmstats-track-tlb-flush-stats-on-up-too.patch removed from -mm tree
To: dave@sr71.net,a.p.zijlstra@chello.nl,dave.hansen@linux.intel.com,hpa@zytor.com,mingo@elte.hu,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:42:29 -0700


The patch titled
     Subject: mm: vmstats: track TLB flush stats on UP too
has been removed from the -mm tree.  Its filename was
     mm-vmstats-track-tlb-flush-stats-on-up-too.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Hansen <dave@sr71.net>
Subject: mm: vmstats: track TLB flush stats on UP too

The previous patch doing vmstats for TLB flushes ("mm: vmstats: tlb flush
counters") effectively missed UP since arch/x86/mm/tlb.c is only compiled
for SMP.

UP systems do not do remote TLB flushes, so compile those counters out on
UP.

arch/x86/kernel/cpu/mtrr/generic.c calls __flush_tlb() directly.  This is
probably an optimization since both the mtrr code and __flush_tlb() write
cr4.  It would probably be safe to make that a flush_tlb_all() (and then
get these statistics), but the mtrr code is ancient and I'm hesitant to
touch it other than to just stick in the counters.

[akpm@linux-foundation.org: tweak comments]
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/tlbflush.h    |   37 ++++++++++++++++++++++-----
 arch/x86/kernel/cpu/mtrr/generic.c |    2 +
 arch/x86/mm/tlb.c                  |    4 --
 include/linux/vm_event_item.h      |    3 +-
 mm/vmstat.c                        |    3 +-
 5 files changed, 38 insertions(+), 11 deletions(-)

diff -puN arch/x86/include/asm/tlbflush.h~mm-vmstats-track-tlb-flush-stats-on-up-too arch/x86/include/asm/tlbflush.h
--- a/arch/x86/include/asm/tlbflush.h~mm-vmstats-track-tlb-flush-stats-on-up-too
+++ a/arch/x86/include/asm/tlbflush.h
@@ -62,6 +62,7 @@ static inline void __flush_tlb_all(void)
 
 static inline void __flush_tlb_one(unsigned long addr)
 {
+	count_vm_event(NR_TLB_LOCAL_FLUSH_ONE);
 	__flush_tlb_single(addr);
 }
 
@@ -84,14 +85,38 @@ static inline void __flush_tlb_one(unsig
 
 #ifndef CONFIG_SMP
 
-#define flush_tlb() __flush_tlb()
-#define flush_tlb_all() __flush_tlb_all()
-#define local_flush_tlb() __flush_tlb()
+/* "_up" is for UniProcessor.
+ *
+ * This is a helper for other header functions.  *Not* intended to be called
+ * directly.  All global TLB flushes need to either call this, or to bump the
+ * vm statistics themselves.
+ */
+static inline void __flush_tlb_up(void)
+{
+	count_vm_event(NR_TLB_LOCAL_FLUSH_ALL);
+	__flush_tlb();
+}
+
+static inline void flush_tlb_all(void)
+{
+	count_vm_event(NR_TLB_LOCAL_FLUSH_ALL);
+	__flush_tlb_all();
+}
+
+static inline void flush_tlb(void)
+{
+	__flush_tlb_up();
+}
+
+static inline void local_flush_tlb(void)
+{
+	__flush_tlb_up();
+}
 
 static inline void flush_tlb_mm(struct mm_struct *mm)
 {
 	if (mm == current->active_mm)
-		__flush_tlb();
+		__flush_tlb_up();
 }
 
 static inline void flush_tlb_page(struct vm_area_struct *vma,
@@ -105,14 +130,14 @@ static inline void flush_tlb_range(struc
 				   unsigned long start, unsigned long end)
 {
 	if (vma->vm_mm == current->active_mm)
-		__flush_tlb();
+		__flush_tlb_up();
 }
 
 static inline void flush_tlb_mm_range(struct mm_struct *mm,
 	   unsigned long start, unsigned long end, unsigned long vmflag)
 {
 	if (mm == current->active_mm)
-		__flush_tlb();
+		__flush_tlb_up();
 }
 
 static inline void native_flush_tlb_others(const struct cpumask *cpumask,
diff -puN arch/x86/kernel/cpu/mtrr/generic.c~mm-vmstats-track-tlb-flush-stats-on-up-too arch/x86/kernel/cpu/mtrr/generic.c
--- a/arch/x86/kernel/cpu/mtrr/generic.c~mm-vmstats-track-tlb-flush-stats-on-up-too
+++ a/arch/x86/kernel/cpu/mtrr/generic.c
@@ -683,6 +683,7 @@ static void prepare_set(void) __acquires
 	}
 
 	/* Flush all TLBs via a mov %cr3, %reg; mov %reg, %cr3 */
+	count_vm_event(NR_TLB_LOCAL_FLUSH_ALL);
 	__flush_tlb();
 
 	/* Save MTRR state */
@@ -696,6 +697,7 @@ static void prepare_set(void) __acquires
 static void post_set(void) __releases(set_atomicity_lock)
 {
 	/* Flush TLBs (no need to flush caches - they are disabled) */
+	count_vm_event(NR_TLB_LOCAL_FLUSH_ALL);
 	__flush_tlb();
 
 	/* Intel (P6) standard MTRRs */
diff -puN arch/x86/mm/tlb.c~mm-vmstats-track-tlb-flush-stats-on-up-too arch/x86/mm/tlb.c
--- a/arch/x86/mm/tlb.c~mm-vmstats-track-tlb-flush-stats-on-up-too
+++ a/arch/x86/mm/tlb.c
@@ -280,10 +280,8 @@ static void do_kernel_range_flush(void *
 	unsigned long addr;
 
 	/* flush range by one by one 'invlpg' */
-	for (addr = f->flush_start; addr < f->flush_end; addr += PAGE_SIZE) {
-		count_vm_event(NR_TLB_LOCAL_FLUSH_ONE_KERNEL);
+	for (addr = f->flush_start; addr < f->flush_end; addr += PAGE_SIZE)
 		__flush_tlb_single(addr);
-	}
 }
 
 void flush_tlb_kernel_range(unsigned long start, unsigned long end)
diff -puN include/linux/vm_event_item.h~mm-vmstats-track-tlb-flush-stats-on-up-too include/linux/vm_event_item.h
--- a/include/linux/vm_event_item.h~mm-vmstats-track-tlb-flush-stats-on-up-too
+++ a/include/linux/vm_event_item.h
@@ -70,11 +70,12 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		THP_ZERO_PAGE_ALLOC,
 		THP_ZERO_PAGE_ALLOC_FAILED,
 #endif
+#ifdef CONFIG_SMP
 		NR_TLB_REMOTE_FLUSH,	/* cpu tried to flush others' tlbs */
 		NR_TLB_REMOTE_FLUSH_RECEIVED,/* cpu received ipi for flush */
+#endif
 		NR_TLB_LOCAL_FLUSH_ALL,
 		NR_TLB_LOCAL_FLUSH_ONE,
-		NR_TLB_LOCAL_FLUSH_ONE_KERNEL,
 		NR_VM_EVENT_ITEMS
 };
 
diff -puN mm/vmstat.c~mm-vmstats-track-tlb-flush-stats-on-up-too mm/vmstat.c
--- a/mm/vmstat.c~mm-vmstats-track-tlb-flush-stats-on-up-too
+++ a/mm/vmstat.c
@@ -817,11 +817,12 @@ const char * const vmstat_text[] = {
 	"thp_zero_page_alloc",
 	"thp_zero_page_alloc_failed",
 #endif
+#ifdef CONFIG_SMP
 	"nr_tlb_remote_flush",
 	"nr_tlb_remote_flush_received",
+#endif
 	"nr_tlb_local_flush_all",
 	"nr_tlb_local_flush_one",
-	"nr_tlb_local_flush_one_kernel",
 
 #endif /* CONFIG_VM_EVENTS_COUNTERS */
 };
_

Patches currently in -mm which might be from dave@sr71.net are

origin.patch

