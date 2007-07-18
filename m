From: akpm@linux-foundation.org
Subject: - more-fix-x86_64-mm-xen-xen-smp-guest-support.patch removed from -mm tree
Date: Wed, 18 Jul 2007 11:52:28 -0700
Message-ID: <200707181852.l6IIqSCe023679@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47663 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934470AbXGRSxI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 14:53:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, jbeulich@novell.com, jeremy@xensource.com, mm-commits@vger.kernel.org


The patch titled
     xen: fix xen-smp.patch: setup_runstate_info
has been removed from the -mm tree.  Its filename was
     more-fix-x86_64-mm-xen-xen-smp-guest-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: xen: fix xen-smp.patch: setup_runstate_info
From: Jeremy Fitzhardinge <jeremy@goop.org>

Somehow an smp_processor_id() survived the transition to passing the
cpu around.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/xen/time.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/xen/time.c~more-fix-x86_64-mm-xen-xen-smp-guest-support arch/i386/xen/time.c
--- a/arch/i386/xen/time.c~more-fix-x86_64-mm-xen-xen-smp-guest-support
+++ a/arch/i386/xen/time.c
@@ -110,7 +110,7 @@ static void setup_runstate_info(int cpu)
 	area.addr.v = &per_cpu(runstate, cpu);
 
 	if (HYPERVISOR_vcpu_op(VCPUOP_register_runstate_memory_area,
-			       smp_processor_id(), &area))
+			       cpu, &area))
 		BUG();
 }
 
_

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
fix-the-softlockup-watchdog-to-actually-work.patch
git-kbuild.patch
fix-x86_64-mm-xen-xen-smp-guest-support.patch
fix-x86_64-mm-xen-xen-event-channels.patch
i386-minor-nx-handling-adjustment.patch
x86-fix-iounmaps-use-of-vm_structs-size-field.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
lguest-the-guest-code.patch
