From: akpm@linux-foundation.org
Subject: + i386-minor-nx-handling-adjustment.patch added to -mm tree
Date: Tue, 12 Jun 2007 13:23:39 -0700
Message-ID: <200706122023.l5CKNdwh020525@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55163 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755083AbXFLUXw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 16:23:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com, ak@suse.de


The patch titled
     i386: minor nx handling adjustment
has been added to the -mm tree.  Its filename is
     i386-minor-nx-handling-adjustment.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: minor nx handling adjustment
From: "Jan Beulich" <jbeulich@novell.com>

Constrain __supported_pte_mask and NX handling to just the PAE kernel.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/mm/init.c     |    7 ++++---
 include/asm-i386/page.h |    1 -
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/i386/mm/init.c~i386-minor-nx-handling-adjustment arch/i386/mm/init.c
--- a/arch/i386/mm/init.c~i386-minor-nx-handling-adjustment
+++ a/arch/i386/mm/init.c
@@ -472,6 +472,10 @@ void zap_low_mappings (void)
 	flush_tlb_all();
 }
 
+int nx_enabled = 0;
+
+#ifdef CONFIG_X86_PAE
+
 static int disable_nx __initdata = 0;
 u64 __supported_pte_mask __read_mostly = ~_PAGE_NX;
 EXPORT_SYMBOL_GPL(__supported_pte_mask);
@@ -501,9 +505,6 @@ static int __init noexec_setup(char *str
 }
 early_param("noexec", noexec_setup);
 
-int nx_enabled = 0;
-#ifdef CONFIG_X86_PAE
-
 static void __init set_nx(void)
 {
 	unsigned int v[4], l, h;
diff -puN include/asm-i386/page.h~i386-minor-nx-handling-adjustment include/asm-i386/page.h
--- a/include/asm-i386/page.h~i386-minor-nx-handling-adjustment
+++ a/include/asm-i386/page.h
@@ -44,7 +44,6 @@
 extern int nx_enabled;
 
 #ifdef CONFIG_X86_PAE
-extern unsigned long long __supported_pte_mask;
 typedef struct { unsigned long pte_low, pte_high; } pte_t;
 typedef struct { unsigned long long pmd; } pmd_t;
 typedef struct { unsigned long long pgd; } pgd_t;
_

Patches currently in -mm which might be from jbeulich@novell.com are

remove-pci_dac_dma_-apis.patch
more-fix-x86_64-mm-xen-xen-smp-guest-support.patch
i386-minor-nx-handling-adjustment.patch
mm-fix-improper-init-type-section-references.patch
page-table-handling-cleanup.patch
modpost-white-list-pattern-adjustment.patch
adjust-nosmp-handling.patch
kill-vmalloc_earlyreserve.patch
x86-fix-change_page_attr-tlb-and-cache-flushing.patch
x86-smp-alt-once-option-is-only-useful-with-hotplug_cpu.patch
x86-64-remove-unused-variable-maxcpus.patch
