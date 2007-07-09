From: akpm@linux-foundation.org
Subject: - paravirt-helper-to-disable-all-io-space-fix-2.patch removed from -mm tree
Date: Mon, 09 Jul 2007 12:22:42 -0700
Message-ID: <200707091922.l69JMh8P003961@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60152 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754207AbXGITWv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 15:22:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, jeremy@xensource.com, mm-commits@vger.kernel.org


The patch titled
     paravirt: fix error handling in paravirt_disable_iospace
has been removed from the -mm tree.  Its filename was
     paravirt-helper-to-disable-all-io-space-fix-2.patch

This patch was dropped because it was folded into paravirt-helper-to-disable-all-io-space-fix.patch

------------------------------------------------------
Subject: paravirt: fix error handling in paravirt_disable_iospace
From: Jeremy Fitzhardinge <jeremy@goop.org>

Make sure everything is backed out if it fails.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/paravirt.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN arch/i386/kernel/paravirt.c~paravirt-helper-to-disable-all-io-space-fix-2 arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c~paravirt-helper-to-disable-all-io-space-fix-2
+++ a/arch/i386/kernel/paravirt.c
@@ -254,8 +254,11 @@ int paravirt_disable_iospace(void)
 	int ret;
 
 	ret = request_resource(&ioport_resource, &reserve_ioports);
-	if (ret == 0)
+	if (ret == 0) {
 		ret = request_resource(&iomem_resource, &reserve_iomem);
+		if (ret)
+			release_resource(&reserve_ioports);
+	}
 
 	return ret;
 }
_

Patches currently in -mm which might be from jeremy@goop.org are

git-kbuild.patch
add-kstrndup-fix.patch
xen-build-fix.patch
fix-x86_64-mm-xen-xen-smp-guest-support.patch
more-fix-x86_64-mm-xen-xen-smp-guest-support.patch
fix-x86_64-mm-xen-add-xen-virtual-block-device-driver.patch
fix-x86_64-mm-add-common-orderly_poweroff.patch
fix-x86_64-mm-xen-xen-event-channels.patch
arch-i386-xen-mmuc-must-include-linux-schedh.patch
tidy-up-usermode-helper-waiting-a-bit-fix.patch
update-x86_64-mm-xen-use-iret-directly-where-possible.patch
x86-use-elfnoteh-to-generate-vsyscall-notes-fix.patch
paravirt-helper-to-disable-all-io-space-fix.patch
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
