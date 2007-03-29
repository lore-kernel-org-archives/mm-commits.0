From: akpm@linux-foundation.org
Subject: - cleanup-initialize-esp0-properly-all-the-time.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:38:44 -0700
Message-ID: <200703292338.l2TNcich015316@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43134 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934391AbXC2Xix (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:38:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     cleanup: Initialize esp0 properly all the time
has been removed from the -mm tree.  Its filename was
     cleanup-initialize-esp0-properly-all-the-time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -421,6 +421,7 @@ struct thread_struct {
 };
 
 #define INIT_THREAD  {							\
+	.esp0 = sizeof(init_stack) + (long)&init_stack,			\
 	.vm86_info = NULL,						\
 	.sysenter_cs = __KERNEL_CS,					\
 	.io_bitmap_ptr = NULL,						\
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

git-kbuild.patch
git-net.patch
allow-per-cpu-variables-to-be-page-aligned.patch
array_size-check-for-type.patch
array_size-check-for-type-uml-fix.patch
module-use-krealloc.patch
extend-print_symbol-capability.patch
extend-print_symbol-capability-fix.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
add-ability-to-keep-track-of-callers-of-symbol_getput-update.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
____call_usermodehelper-dont-flush_signals.patch
