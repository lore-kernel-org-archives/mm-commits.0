From: akpm@linux-foundation.org
Subject: + x86-smp-alt-once-option-is-only-useful-with-hotplug_cpu.patch added to -mm tree
Date: Tue, 12 Jun 2007 13:23:56 -0700
Message-ID: <200706122023.l5CKNuGK020556@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59714 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756826AbXFLUYG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 16:24:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com, ak@suse.de


The patch titled
     x86: smp-alt-once option is only useful with HOTPLUG_CPU
has been added to the -mm tree.  Its filename is
     x86-smp-alt-once-option-is-only-useful-with-hotplug_cpu.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86: smp-alt-once option is only useful with HOTPLUG_CPU
From: "Jan Beulich" <jbeulich@novell.com>

Hence remove its handling in the opposite case.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/alternative.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff -puN arch/i386/kernel/alternative.c~x86-smp-alt-once-option-is-only-useful-with-hotplug_cpu arch/i386/kernel/alternative.c
--- a/arch/i386/kernel/alternative.c~x86-smp-alt-once-option-is-only-useful-with-hotplug_cpu
+++ a/arch/i386/kernel/alternative.c
@@ -5,9 +5,8 @@
 #include <asm/alternative.h>
 #include <asm/sections.h>
 
-static int noreplace_smp     = 0;
-static int smp_alt_once      = 0;
-static int debug_alternative = 0;
+#ifdef CONFIG_HOTPLUG_CPU
+static int smp_alt_once;
 
 static int __init bootonly(char *str)
 {
@@ -15,6 +14,11 @@ static int __init bootonly(char *str)
 	return 1;
 }
 __setup("smp-alt-boot", bootonly);
+#else
+#define smp_alt_once 1
+#endif
+
+static int debug_alternative;
 
 static int __init debug_alt(char *str)
 {
@@ -23,6 +27,8 @@ static int __init debug_alt(char *str)
 }
 __setup("debug-alternative", debug_alt);
 
+static int noreplace_smp;
+
 static int __init setup_noreplace_smp(char *str)
 {
 	noreplace_smp = 1;
@@ -376,8 +382,6 @@ void __init alternative_instructions(voi
 #ifdef CONFIG_HOTPLUG_CPU
 	if (num_possible_cpus() < 2)
 		smp_alt_once = 1;
-#else
-	smp_alt_once = 1;
 #endif
 
 #ifdef CONFIG_SMP
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
