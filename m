From: akpm@linux-foundation.org
Subject: + xen-cant-support-numa-yet.patch added to -mm tree
Date: Thu, 05 Jul 2007 14:27:50 -0700
Message-ID: <200707052127.l65LRoer020593@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37688 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759731AbXGEV2I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 17:28:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, ak@suse.de, bunk@stusta.de, jeremy@xensource.com


The patch titled
     xen: can't support numa yet
has been added to the -mm tree.  Its filename is
     xen-cant-support-numa-yet.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: xen: can't support numa yet
From: Jeremy Fitzhardinge <jeremy@goop.org>

Xen currently relies on contigious memory (ie, no numa, discontig or sparse
memory).  Specifically it uses mem_map, which is only available if
CONFIG_NEED_MULTIPLE_NODES is not defined.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Adrian Bunk <bunk@stusta.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/xen/Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/xen/Kconfig~xen-cant-support-numa-yet arch/i386/xen/Kconfig
--- a/arch/i386/xen/Kconfig~xen-cant-support-numa-yet
+++ a/arch/i386/xen/Kconfig
@@ -4,7 +4,7 @@
 
 config XEN
 	bool "Enable support for Xen hypervisor"
-	depends on PARAVIRT && X86_CMPXCHG && X86_TSC
+	depends on PARAVIRT && X86_CMPXCHG && X86_TSC && !NEED_MULTIPLE_NODES
 	help
 	  This is the Linux Xen port.  Enabling this will allow the
 	  kernel to boot in a paravirtualized environment under the
_

Patches currently in -mm which might be from jeremy@goop.org are

i386-fix-regression-endless-loop-in-ptrace-singlestep.patch
git-kbuild.patch
add-kstrndup-fix.patch
xen-build-fix.patch
fix-x86_64-mm-xen-xen-smp-guest-support.patch
more-fix-x86_64-mm-xen-xen-smp-guest-support.patch
fix-x86_64-mm-xen-add-xen-virtual-block-device-driver.patch
fix-x86_64-mm-add-common-orderly_poweroff.patch
tidy-up-usermode-helper-waiting-a-bit-fix.patch
update-x86_64-mm-xen-use-iret-directly-where-possible.patch
x86-use-elfnoteh-to-generate-vsyscall-notes-fix.patch
paravirt-helper-to-disable-all-io-space-fix-2.patch
paravirt-helper-to-disable-all-io-space-fix-3.patch
i386-minor-nx-handling-adjustment-fix.patch
xen-fix-x86-config-dependencies.patch
xen-suppress-abs-symbol-warnings-for-unused-reloc-pointers.patch
xen-cant-support-numa-yet.patch
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
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
generic-bug-use-show_regs-instead-of-dump_stack.patch
lguest-the-guest-code.patch
