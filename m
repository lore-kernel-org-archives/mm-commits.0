From: akpm@linux-foundation.org
Subject: + cleanup-initialize-esp0-properly-all-the-time.patch added to -mm tree
Date: Mon, 12 Feb 2007 23:03:06 -0800
Message-ID: <200702130703.l1D7366a024508@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56968 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbXBMHDO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 02:03:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, ak@suse.de


The patch titled
     cleanup: Initialize esp0 properly all the time
has been added to the -mm tree.  Its filename is
     cleanup-initialize-esp0-properly-all-the-time.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cleanup: Initialize esp0 properly all the time
From: Rusty Russell <rusty@rustcorp.com.au>

Whenever we schedule, __switch_to calls load_esp0 which does:

	tss->esp0 = thread->esp0;

This is never initialized for the initial thread (ie "swapper"), so when we're
scheduling that, we end up setting esp0 to 0.  This is fine: the swapper never
leaves ring 0, so this field is never used.

lguest, however, gets upset that we're trying to used an unmapped page as our
kernel stack.  Rather than work around it there, let's initialize it.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/processor.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/asm-i386/processor.h~cleanup-initialize-esp0-properly-all-the-time include/asm-i386/processor.h
--- a/include/asm-i386/processor.h~cleanup-initialize-esp0-properly-all-the-time
+++ a/include/asm-i386/processor.h
@@ -429,6 +429,7 @@ struct thread_struct {
 };
 
 #define INIT_THREAD  {							\
+	.esp0 = sizeof(init_stack) + (long)&init_stack,			\
 	.vm86_info = NULL,						\
 	.sysenter_cs = __KERNEL_CS,					\
 	.io_bitmap_ptr = NULL,						\
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
cleanup-paravirt-unhandled-fallthrough.patch
cleanup-initialize-esp0-properly-all-the-time.patch
cleanup-make-hvc_consolec-compile-on-non-powerpc.patch
cleanup-move-mce_disabled-to-asm-mceh.patch
cleanup-rename-cpu_gdt_descr-and-remove-extern.patch
cleanup-remove-extern-declaration-from.patch
cleanup-make-disable_acpi-valid-w-o-config_acpi.patch
lguest-preparation-export_symbol_gpl-5-functions.patch
lguest-preparation-expose-futex-infrastructure.patch
lguest-kconfig-and-headers.patch
lguest-the-host-code-lgko.patch
lguest-guest-code.patch
lguest-makefile.patch
lguest-trivial-guest-network-driver.patch
lguest-trivial-guest-network-driver-fix.patch
lguest-trivial-guest-console-driver.patch
lguest-trivial-guest-block-driver.patch
lguest-documentatation-and-example-launcher.patch
vmi-versus-hrtimers.patch
