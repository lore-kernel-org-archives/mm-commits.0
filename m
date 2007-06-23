From: akpm@linux-foundation.org
Subject: - fix-x86_64-mm-xen-core-xen-implementation.patch removed from -mm tree
Date: Sat, 23 Jun 2007 12:28:21 -0700
Message-ID: <200706231928.l5NJSLhr022138@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55075 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755477AbXFWTe4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 15:34:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, ak@suse.de, ebiederm@xmission.com, jeremy@xensource.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     xen_start_kernel is __init, so startup_xen should be too
has been removed from the -mm tree.  Its filename was
     fix-x86_64-mm-xen-core-xen-implementation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: xen_start_kernel is __init, so startup_xen should be too
From: Jeremy Fitzhardinge <jeremy@goop.org>

This needs an update to modpost to prevent warning about the reference from
.note* to the .init.text section.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/xen/xen-head.S |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/i386/xen/xen-head.S~fix-x86_64-mm-xen-core-xen-implementation arch/i386/xen/xen-head.S
--- a/arch/i386/xen/xen-head.S~fix-x86_64-mm-xen-core-xen-implementation
+++ a/arch/i386/xen/xen-head.S
@@ -7,11 +7,13 @@
 #include <asm/boot.h>
 #include <xen/interface/elfnote.h>
 
+.pushsection .init.text,"ax",@progbits
 ENTRY(startup_xen)
 	movl %esi,xen_start_info
 	cld
  	movl $(init_thread_union+THREAD_SIZE),%esp
 	jmp xen_start_kernel
+.popsection
 
 .pushsection ".bss.page_aligned"
 	.align PAGE_SIZE_asm
_

Patches currently in -mm which might be from jeremy@goop.org are

git-kbuild.patch
add-kstrndup-fix.patch
xen-build-fix.patch
fix-x86_64-mm-xen-xen-smp-guest-support.patch
more-fix-x86_64-mm-xen-xen-smp-guest-support.patch
fix-x86_64-mm-xen-add-xen-virtual-block-device-driver.patch
fix-x86_64-mm-add-common-orderly_poweroff.patch
x86-use-elfnoteh-to-generate-vsyscall-notes-fix.patch
paravirt-helper-to-disable-all-io-space-fix-2.patch
paravirt-helper-to-disable-all-io-space-fix-3.patch
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
