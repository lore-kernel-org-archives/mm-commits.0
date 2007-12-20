From: akpm@linux-foundation.org
Subject: + ia64-remove-dead-code.patch added to -mm tree
Date: Thu, 20 Dec 2007 13:40:50 -0800
Message-ID: <200712202140.lBKLeorV014096@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48899 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759239AbXLTVk4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 16:40:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com, tony.luck@intel.com


The patch titled
     ia64: remove dead code
has been added to the -mm tree.  Its filename is
     ia64-remove-dead-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ia64: remove dead code
From: "Jan Beulich" <jbeulich@novell.com>

Neither __cpu_down() nor __cpu_die() are being referenced without
CONFIG_HOTPLUG_CPU.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/smpboot.c |   11 -----------
 1 file changed, 11 deletions(-)

diff -puN arch/ia64/kernel/smpboot.c~ia64-remove-dead-code arch/ia64/kernel/smpboot.c
--- a/arch/ia64/kernel/smpboot.c~ia64-remove-dead-code
+++ a/arch/ia64/kernel/smpboot.c
@@ -767,17 +767,6 @@ void __cpu_die(unsigned int cpu)
 	}
  	printk(KERN_ERR "CPU %u didn't die...\n", cpu);
 }
-#else /* !CONFIG_HOTPLUG_CPU */
-int __cpu_disable(void)
-{
-	return -ENOSYS;
-}
-
-void __cpu_die(unsigned int cpu)
-{
-	/* We said "no" in __cpu_disable */
-	BUG();
-}
 #endif /* CONFIG_HOTPLUG_CPU */
 
 void
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
