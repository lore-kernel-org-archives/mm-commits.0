From: akpm@linux-foundation.org
Subject: + xen-suppress-abs-symbol-warnings-for-unused-reloc-pointers.patch added to -mm tree
Date: Tue, 03 Jul 2007 14:35:51 -0700
Message-ID: <200707032135.l63LZp40017165@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40681 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756189AbXGCVg2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jul 2007 17:36:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, ak@suse.de, bunk@stusta.de, ebiederm@xmission.com, jeremy@xensource.com


The patch titled
     xen: suppress abs symbol warnings for unused reloc pointers
has been added to the -mm tree.  Its filename is
     xen-suppress-abs-symbol-warnings-for-unused-reloc-pointers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: xen: suppress abs symbol warnings for unused reloc pointers
From: Jeremy Fitzhardinge <jeremy@goop.org>

arch/i386/xen/xen-asm.S defines some small pieces of code which are used to
implement a few paravirt_ops.  They're designed so they can be used either
in-place, or be inline patched into their callsites if there's enough
space.

Some of those operations need to make calls out (specifically, if you
re-enable events [interrupts], and there's a pending event at that time). 
These calls need the call instruction to be relocated if the code is
patched inline.  In this case xen_foo_reloc is a section-relative symbol
which points to xen_foo's required relocation.

Other operations have no need of a relocation, and so their corresponding
xen_bar_reloc is absolute 0.  These are the cases which are triggering the
warning.

This patch adds those symbols to the list of safe abs symbols.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Adrian Bunk <bunk@stusta.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/boot/compressed/relocs.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN arch/i386/boot/compressed/relocs.c~xen-suppress-abs-symbol-warnings-for-unused-reloc-pointers arch/i386/boot/compressed/relocs.c
--- a/arch/i386/boot/compressed/relocs.c~xen-suppress-abs-symbol-warnings-for-unused-reloc-pointers
+++ a/arch/i386/boot/compressed/relocs.c
@@ -31,6 +31,8 @@ static const char* safe_abs_relocs[] = {
 		"__kernel_rt_sigreturn",
 		"__kernel_sigreturn",
 		"SYSENTER_RETURN",
+		"xen_irq_disable_direct_reloc",
+		"xen_save_fl_direct_reloc",
 };
 
 static int is_safe_abs_reloc(const char* sym_name)
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
