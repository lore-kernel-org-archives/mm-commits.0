From: akpm@linux-foundation.org
Subject: - ia64-make-flush_tlb_kernel_range-an-inline-function.patch removed from -mm tree
Date: Thu, 20 Dec 2007 15:37:38 -0800
Message-ID: <200712202337.lBKNbc0j018909@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57411 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755424AbXLTXri (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 18:47:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64: make flush_tlb_kernel_range() an inline function
has been removed from the -mm tree.  Its filename was
     ia64-make-flush_tlb_kernel_range-an-inline-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ia64: make flush_tlb_kernel_range() an inline function
From: "Jan Beulich" <jbeulich@novell.com>

This fixes an unused variable warning in mm/vmalloc.c.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-ia64/tlbflush.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN include/asm-ia64/tlbflush.h~ia64-make-flush_tlb_kernel_range-an-inline-function include/asm-ia64/tlbflush.h
--- a/include/asm-ia64/tlbflush.h~ia64-make-flush_tlb_kernel_range-an-inline-function
+++ a/include/asm-ia64/tlbflush.h
@@ -92,6 +92,10 @@ void smp_local_flush_tlb(void);
 #define smp_local_flush_tlb()
 #endif
 
-#define flush_tlb_kernel_range(start, end)	flush_tlb_all()	/* XXX fix me */
+static inline void flush_tlb_kernel_range(unsigned long start,
+					  unsigned long end)
+{
+	flush_tlb_all();	/* XXX fix me */
+}
 
 #endif /* _ASM_IA64_TLBFLUSH_H */
_

Patches currently in -mm which might be from jbeulich@novell.com are

origin.patch
git-acpi.patch
ia64-remove-dead-code.patch
ia64-honor-notify_die-returning-notify_stop.patch
pci-remove-default-pci-expansion-rom-memory-allocation.patch
git-x86.patch
xen-fiddle_vdso-must-be-__init.patch
