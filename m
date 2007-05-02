From: akpm@linux-foundation.org
Subject: + lguest-the-guest-code-handle-new-paravirt-lazy-mode-fix-userspace.patch added to -mm tree
Date: Tue, 01 May 2007 17:06:58 -0700
Message-ID: <200705020006.l4206w2b009768@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47735 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946111AbXEBAHD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 May 2007 20:07:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au


The patch titled
     lguest: handle new paravirt lazy mode (fix userspace segfaults)
has been added to the -mm tree.  Its filename is
     lguest-the-guest-code-handle-new-paravirt-lazy-mode-fix-userspace.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lguest: handle new paravirt lazy mode (fix userspace segfaults)
From: Rusty Russell <rusty@rustcorp.com.au>

There's a new paravirt_lazy_mode mode in town.

Well, it's spelled "mode", but it's pronounced "hack".

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/lguest.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/lguest/lguest.c~lguest-the-guest-code-handle-new-paravirt-lazy-mode-fix-userspace drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c~lguest-the-guest-code-handle-new-paravirt-lazy-mode-fix-userspace
+++ a/drivers/lguest/lguest.c
@@ -58,9 +58,13 @@ static __initdata const struct lguest_bo
 static enum paravirt_lazy_mode lazy_mode;
 static void lguest_lazy_mode(enum paravirt_lazy_mode mode)
 {
-	lazy_mode = mode;
-	if (mode == PARAVIRT_LAZY_NONE)
+	if (mode == PARAVIRT_LAZY_FLUSH)
 		hcall(LHCALL_FLUSH_ASYNC, 0, 0, 0);
+	else {
+		lazy_mode = mode;
+		if (mode == PARAVIRT_LAZY_NONE)
+			hcall(LHCALL_FLUSH_ASYNC, 0, 0, 0);
+	}
 }
 
 static void lazy_hcall(unsigned long call,
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
extend-print_symbol-capability.patch
git-kbuild.patch
xfs-clean-up-shrinker-games.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
array_size-check-for-type.patch
module-use-krealloc.patch
futex-restartable-futex_wait.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
simplify-module_get_kallsym-by-dropping-length-arg.patch
fix-race-between-rmmod-and-cat-proc-kallsyms.patch
simplify-kallsyms_lookup.patch
fix-race-between-cat-proc-wchan-and-rmmod-et-al.patch
fix-race-between-cat-proc-slab_allocators-and-rmmod.patch
____call_usermodehelper-dont-flush_signals.patch
wait_for_helper-remove-unneeded-do_sigaction.patch
futex-new-private-futexes.patch
lguest-the-guest-code.patch
lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda.patch
lguest-the-guest-code-update-lguests-patch-code-for-new-paravirt-patch.patch
lguest-the-guest-code-handle-new-paravirt-lazy-mode-fix-userspace.patch
lguest-the-host-code.patch
lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
lguest-the-host-code-fix-lguest-oops-when-guest-dies-while-receiving-i-o.patch
lguest-the-host-code-simplification-dont-pin-guest-trap-handlers.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-console-driver.patch
lguest-the-net-driver.patch
lguest-the-block-driver.patch
lguest-the-documentation-example-launcher.patch
lguest-the-documentation-example-launcher-fix-lguest-documentation-error.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
