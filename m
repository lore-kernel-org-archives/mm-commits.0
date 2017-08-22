From: akpm@linux-foundation.org
Subject: [merged]
 mm-hwpoison-clear-present-bit-for-kernel-1-1-mappings-of-poison-pages.patch
 removed from -mm tree
Date: Tue, 22 Aug 2017 13:54:56 -0700
Message-ID: <20170822205456.2mc5DR8pP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36344 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751069AbdHVUy5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Aug 2017 16:54:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bp@suse.de, dave.hansen@intel.com, elliott@hpe.com, hpa@zytor.com, mingo@elte.hu, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, stable@vger.kernel.org, tglx@linutronix.de, tony.luck@intel.com


The patch titled
     Subject: mm/hwpoison: clear PRESENT bit for kernel 1:1 mappings of poison pages
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-clear-present-bit-for-kernel-1-1-mappings-of-poison-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tony Luck <tony.luck@intel.com>
Subject: mm/hwpoison: clear PRESENT bit for kernel 1:1 mappings of poison pages

Speculative processor accesses may reference any memory that has a valid
page table entry.  While a speculative access won't generate a machine
check, it will log the error in a machine check bank.  That could cause
escalation of a subsequent error since the overflow bit will be then set
in the machine check bank status register.

Code has to be double-plus-tricky to avoid mentioning the 1:1 virtual
address of the page we want to map out otherwise we may trigger the very
problem we are trying to avoid.  We use a non-canonical address that
passes through the usual Linux table walking code to get to the same
"pte".

Thanks to Dave Hansen for reviewing several iterations of this.

Full previous thread here:
http://marc.info/?l=linux-mm&m=149860136413338&w=2 but the Cliff notes
are: Discussion on this stalled out at the end of June.  Robert Elliott
had raised questions on whether there needed to be a method to re-enable
the 1:1 mapping if the poison was cleared. I replied that would be a good
follow-on patch when we have a way to clear poison. Robert also asked
whether this needs to integrate with the handling of poison in NVDIMMs,
But discussions with Dan Williams ended up concluding that this code is
executed much earlier (right as the fault is detected) than the NVDIMM
code is prepared to take action. Dan thought this patch could move ahead.

Robert Elliott said:

: In general, the system is subject to halting due to uncorrectable
: memory errors at addresses that software is not even accessing.  
: 
: The first error doesn't cause the crash, but if a second error happens
: before the machine check handler services the first one, it'll find the
: Overflow bit set and won't know what errors or how many errors happened
: (e.g., it might have been problems in an instruction fetch, and the
: instructions the CPU is slated to run are bogus).  Halting is the only
: safe thing to do.
: 
: For persistent memory, the BIOS reports known-bad addresses in the ACPI
: ARS (address range scrub) table.  They are likely to keep reappearing
: every boot since it is persistent memory, so you can't just reboot and
: hope they go away.  Software is supposed to avoid reading those
: addresses until it fixes them (e.g., writes new data to those
: locations).  Even if it follows this rule, the system can still crash
: due to speculative reads (e.g., prefetches) touching those addresses.
: 
: Tony's patch marks those addresses in the page tables so the CPU won't
: speculatively try to read them.

Link: http://lkml.kernel.org/r/20170816171803.28342-1-tony.luck@intel.com
Signed-off-by: Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/page_64.h   |    4 ++
 arch/x86/kernel/cpu/mcheck/mce.c |   43 +++++++++++++++++++++++++++++
 include/linux/mm_inline.h        |    6 ++++
 mm/memory-failure.c              |    2 +
 4 files changed, 55 insertions(+)

diff -puN arch/x86/include/asm/page_64.h~mm-hwpoison-clear-present-bit-for-kernel-1-1-mappings-of-poison-pages arch/x86/include/asm/page_64.h
--- a/arch/x86/include/asm/page_64.h~mm-hwpoison-clear-present-bit-for-kernel-1-1-mappings-of-poison-pages
+++ a/arch/x86/include/asm/page_64.h
@@ -51,6 +51,10 @@ static inline void clear_page(void *page
 
 void copy_page(void *to, void *from);
 
+#ifdef CONFIG_X86_MCE
+#define arch_unmap_kpfn arch_unmap_kpfn
+#endif
+
 #endif	/* !__ASSEMBLY__ */
 
 #ifdef CONFIG_X86_VSYSCALL_EMULATION
diff -puN arch/x86/kernel/cpu/mcheck/mce.c~mm-hwpoison-clear-present-bit-for-kernel-1-1-mappings-of-poison-pages arch/x86/kernel/cpu/mcheck/mce.c
--- a/arch/x86/kernel/cpu/mcheck/mce.c~mm-hwpoison-clear-present-bit-for-kernel-1-1-mappings-of-poison-pages
+++ a/arch/x86/kernel/cpu/mcheck/mce.c
@@ -51,6 +51,7 @@
 #include <asm/mce.h>
 #include <asm/msr.h>
 #include <asm/reboot.h>
+#include <asm/set_memory.h>
 
 #include "mce-internal.h"
 
@@ -1051,6 +1052,48 @@ static int do_memory_failure(struct mce
 	return ret;
 }
 
+#if defined(arch_unmap_kpfn) && defined(CONFIG_MEMORY_FAILURE)
+
+void arch_unmap_kpfn(unsigned long pfn)
+{
+	unsigned long decoy_addr;
+
+	/*
+	 * Unmap this page from the kernel 1:1 mappings to make sure
+	 * we don't log more errors because of speculative access to
+	 * the page.
+	 * We would like to just call:
+	 *	set_memory_np((unsigned long)pfn_to_kaddr(pfn), 1);
+	 * but doing that would radically increase the odds of a
+	 * speculative access to the posion page because we'd have
+	 * the virtual address of the kernel 1:1 mapping sitting
+	 * around in registers.
+	 * Instead we get tricky.  We create a non-canonical address
+	 * that looks just like the one we want, but has bit 63 flipped.
+	 * This relies on set_memory_np() not checking whether we passed
+	 * a legal address.
+	 */
+
+/*
+ * Build time check to see if we have a spare virtual bit. Don't want
+ * to leave this until run time because most developers don't have a
+ * system that can exercise this code path. This will only become a
+ * problem if/when we move beyond 5-level page tables.
+ *
+ * Hard code "9" here because cpp doesn't grok ilog2(PTRS_PER_PGD)
+ */
+#if PGDIR_SHIFT + 9 < 63
+	decoy_addr = (pfn << PAGE_SHIFT) + (PAGE_OFFSET ^ BIT(63));
+#else
+#error "no unused virtual bit available"
+#endif
+
+	if (set_memory_np(decoy_addr, 1))
+		pr_warn("Could not invalidate pfn=0x%lx from 1:1 map\n", pfn);
+
+}
+#endif
+
 /*
  * The actual machine check handler. This only handles real
  * exceptions when something got corrupted coming in through int 18.
diff -puN include/linux/mm_inline.h~mm-hwpoison-clear-present-bit-for-kernel-1-1-mappings-of-poison-pages include/linux/mm_inline.h
--- a/include/linux/mm_inline.h~mm-hwpoison-clear-present-bit-for-kernel-1-1-mappings-of-poison-pages
+++ a/include/linux/mm_inline.h
@@ -126,4 +126,10 @@ static __always_inline enum lru_list pag
 
 #define lru_to_page(head) (list_entry((head)->prev, struct page, lru))
 
+#ifdef arch_unmap_kpfn
+extern void arch_unmap_kpfn(unsigned long pfn);
+#else
+static __always_inline void arch_unmap_kpfn(unsigned long pfn) { }
+#endif
+
 #endif
diff -puN mm/memory-failure.c~mm-hwpoison-clear-present-bit-for-kernel-1-1-mappings-of-poison-pages mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hwpoison-clear-present-bit-for-kernel-1-1-mappings-of-poison-pages
+++ a/mm/memory-failure.c
@@ -1146,6 +1146,8 @@ int memory_failure(unsigned long pfn, in
 		return 0;
 	}
 
+	arch_unmap_kpfn(pfn);
+
 	orig_head = hpage = compound_head(p);
 	num_poisoned_pages_inc();
 
_

Patches currently in -mm which might be from tony.luck@intel.com are


