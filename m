From: akpm@linux-foundation.org
Subject: + more-fix-x86_64-mm-xen-xen-smp-guest-support.patch added to -mm tree
Date: Thu, 07 Jun 2007 17:52:41 -0700
Message-ID: <200706080052.l580qfdZ014142@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38958 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933871AbXFHAwu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jun 2007 20:52:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, jbeulich@novell.com, jeremy@xensource.com


The patch titled
     xen: fix xen-smp.patch: setup_runstate_info
has been added to the -mm tree.  Its filename is
     more-fix-x86_64-mm-xen-xen-smp-guest-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-kbuild.patch
add-kstrndup-fix.patch
xen-build-fix.patch
fix-x86_64-mm-xen-xen-smp-guest-support.patch
more-fix-x86_64-mm-xen-xen-smp-guest-support.patch
fix-x86_64-mm-xen-core-xen-implementation.patch
fix-x86_64-mm-xen-add-xen-virtual-block-device-driver.patch
x86-use-elfnoteh-to-generate-vsyscall-notes-fix.patch
paravirt-helper-to-disable-all-io-space-fix-2.patch
paravirt-helper-to-disable-all-io-space-fix-3.patch
xen-use-iret-directly-where-possible.patch
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
tidy-up-usermode-helper-waiting-a-bit-fix.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
lguest-the-guest-code.patch
