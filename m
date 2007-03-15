From: akpm@linux-foundation.org
Subject: + ia64-platform_kernel_launch_event-is-noop-on-generic-kernel.patch added to -mm tree
Date: Thu, 15 Mar 2007 13:17:58 -0700
Message-ID: <200703152017.l2FKHwqi025458@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39277 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933784AbXCOUSN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 16:18:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jpk@sgi.com, bwalle@suse.de, horms@verge.net.au, jlan@sgi.com, tony.luck@intel.com


The patch titled
     ia64: platform_kernel_launch_event is noop on generic kernel
has been added to the -mm tree.  Its filename is
     ia64-platform_kernel_launch_event-is-noop-on-generic-kernel.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ia64: platform_kernel_launch_event is noop on generic kernel
From: John Keller <jpk@sgi.com>

Add a missing #define for the platform_kernel_launch_event.  Without this
fix, a call to platform_kernel_launch_event() becomes a noop on generic
kernels.  SN systems require this fix to successfully kdump/kexec from
certain hardware errors.

[bwalle@suse.de: fix it]
Signed-off-by: John Keller <jpk@sgi.com>
Cc: Bernhard Walle <bwalle@suse.de>
Acked-by: Simon Horman <horms@verge.net.au>
Acked-by: Jay Lan <jlan@sgi.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-ia64/machvec.h |    2 ++
 1 files changed, 2 insertions(+)

diff -puN include/asm-ia64/machvec.h~ia64-platform_kernel_launch_event-is-noop-on-generic-kernel include/asm-ia64/machvec.h
--- a/include/asm-ia64/machvec.h~ia64-platform_kernel_launch_event-is-noop-on-generic-kernel
+++ a/include/asm-ia64/machvec.h
@@ -168,6 +168,7 @@ extern void machvec_tlb_migrate_finish (
 #  define platform_setup_msi_irq	ia64_mv.setup_msi_irq
 #  define platform_teardown_msi_irq	ia64_mv.teardown_msi_irq
 #  define platform_pci_fixup_bus	ia64_mv.pci_fixup_bus
+#  define platform_kernel_launch_event	ia64_mv.kernel_launch_event
 # endif
 
 /* __attribute__((__aligned__(16))) is required to make size of the
@@ -269,6 +270,7 @@ struct ia64_machine_vector {
 	platform_setup_msi_irq,			\
 	platform_teardown_msi_irq,		\
 	platform_pci_fixup_bus,			\
+	platform_kernel_launch_event            \
 }
 
 extern struct ia64_machine_vector ia64_mv;
_

Patches currently in -mm which might be from jpk@sgi.com are

git-acpi.patch
fix-wrong-proc-iomem-on-sgi-altix.patch
ia64-platform_kernel_launch_event-is-noop-on-generic-kernel.patch
