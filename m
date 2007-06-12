From: akpm@linux-foundation.org
Subject: + x86-64-remove-unused-variable-maxcpus.patch added to -mm tree
Date: Tue, 12 Jun 2007 13:23:58 -0700
Message-ID: <200706122023.l5CKNwd7020559@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49972 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756877AbXFLUYN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 16:24:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com, ak@suse.de


The patch titled
     x86-64: remove unused variable maxcpus
has been added to the -mm tree.  Its filename is
     x86-64-remove-unused-variable-maxcpus.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86-64: remove unused variable maxcpus
From: "Jan Beulich" <jbeulich@novell.com>

.. and adjust documentation to properly reflect options that are
x86-64 specific.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/x86_64/boot-options.txt |    6 ------
 arch/x86_64/kernel/mpparse.c          |    1 -
 2 files changed, 7 deletions(-)

diff -puN Documentation/x86_64/boot-options.txt~x86-64-remove-unused-variable-maxcpus Documentation/x86_64/boot-options.txt
--- a/Documentation/x86_64/boot-options.txt~x86-64-remove-unused-variable-maxcpus
+++ a/Documentation/x86_64/boot-options.txt
@@ -136,12 +136,6 @@ Non Executable Mappings
 
 SMP
 
-  nosmp	Only use a single CPU
-
-  maxcpus=NUMBER only use upto NUMBER CPUs
-
-  cpumask=MASK   only use cpus with bits set in mask
-
   additional_cpus=NUM Allow NUM more CPUs for hotplug
 		 (defaults are specified by the BIOS, see Documentation/x86_64/cpu-hotplug-spec)
 
diff -puN arch/x86_64/kernel/mpparse.c~x86-64-remove-unused-variable-maxcpus arch/x86_64/kernel/mpparse.c
--- a/arch/x86_64/kernel/mpparse.c~x86-64-remove-unused-variable-maxcpus
+++ a/arch/x86_64/kernel/mpparse.c
@@ -32,7 +32,6 @@
 
 /* Have we found an MP table */
 int smp_found_config;
-unsigned int __initdata maxcpus = NR_CPUS;
 
 /*
  * Various Linux-internal data structures created from the
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
