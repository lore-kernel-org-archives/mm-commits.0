From: akpm@linux-foundation.org
Subject: - xen-suppress-abs-symbol-warnings-for-unused-reloc-pointers.patch removed from -mm tree
Date: Wed, 18 Jul 2007 11:52:46 -0700
Message-ID: <200707181852.l6IIqke5023707@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51772 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934039AbXGRSzS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 14:55:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, ak@suse.de, bunk@stusta.de, ebiederm@xmission.com, jeremy@xensource.com, mm-commits@vger.kernel.org


The patch titled
     xen: suppress abs symbol warnings for unused reloc pointers
has been removed from the -mm tree.  Its filename was
     xen-suppress-abs-symbol-warnings-for-unused-reloc-pointers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
