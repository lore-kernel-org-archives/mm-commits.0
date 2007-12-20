From: akpm@linux-foundation.org
Subject: + ia64-make-flush_tlb_kernel_range-an-inline-function.patch added to -mm tree
Date: Thu, 20 Dec 2007 13:40:52 -0800
Message-ID: <200712202140.lBKLeqvN014099@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55322 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760220AbXLTVk4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 16:40:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com, tony.luck@intel.com


The patch titled
     ia64: make flush_tlb_kernel_range() an inline function
has been added to the -mm tree.  Its filename is
     ia64-make-flush_tlb_kernel_range-an-inline-function.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
ia64-make-flush_tlb_kernel_range-an-inline-function.patch
ia64-honor-notify_die-returning-notify_stop.patch
pci-remove-default-pci-expansion-rom-memory-allocation.patch
git-x86.patch
xen-fiddle_vdso-must-be-__init.patch
