From: akpm@linux-foundation.org
Subject: [to-be-updated]
 sh-boot-add-static-stack-protector-to-pre-kernel.patch removed from -mm
 tree
Date: Tue, 17 Oct 2017 12:56:56 -0700
Message-ID: <59e66088.WvIzNkWQYI6sXtQL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36692 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760136AbdJQT47 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Oct 2017 15:56:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, dalias@libc.org, labbott@redhat.com, mingo@kernel.org, mmarek@suse.com, npiggin@gmail.com, viro@zeniv.linux.org.uk, yamada.masahiro@socionext.com, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: sh/boot: add static stack-protector to pre-kernel
has been removed from the -mm tree.  Its filename was
     sh-boot-add-static-stack-protector-to-pre-kernel.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: sh/boot: add static stack-protector to pre-kernel

The sh decompressor code triggers stack-protector code generation when
using CONFIG_CC_STACKPROTECTOR_STRONG.  As done for arm and mips, add a
simple static stack-protector canary.  As this wasn't protected before,
the risk of using a weak canary is minimized.  Once the kernel is actually
up, a better canary is chosen.

Link: http://lkml.kernel.org/r/1506972007-80614-2-git-send-email-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Michal Marek <mmarek@suse.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/boot/compressed/misc.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN arch/sh/boot/compressed/misc.c~sh-boot-add-static-stack-protector-to-pre-kernel arch/sh/boot/compressed/misc.c
--- a/arch/sh/boot/compressed/misc.c~sh-boot-add-static-stack-protector-to-pre-kernel
+++ a/arch/sh/boot/compressed/misc.c
@@ -103,6 +103,18 @@ static void error(char *x)
 	while(1);	/* Halt */
 }
 
+unsigned long __stack_chk_guard;
+
+void __stack_chk_guard_setup(void)
+{
+	__stack_chk_guard = 0x000a0dff;
+}
+
+void __stack_chk_fail(void)
+{
+	error("stack-protector: Kernel stack is corrupted\n");
+}
+
 #ifdef CONFIG_SUPERH64
 #define stackalign	8
 #else
@@ -117,6 +129,8 @@ void decompress_kernel(void)
 {
 	unsigned long output_addr;
 
+	__stack_chk_guard_setup();
+
 #ifdef CONFIG_SUPERH64
 	output_addr = (CONFIG_MEMORY_START + 0x2000);
 #else
_

Patches currently in -mm which might be from keescook@chromium.org are

writeback-convert-timers-to-use-timer_setup.patch
makefile-move-stackprotector-availability-out-of-kconfig.patch
makefile-introduce-config_cc_stackprotector_auto.patch
makefile-introduce-config_cc_stackprotector_auto-fix.patch
makefile-introduce-config_cc_stackprotector_auto-fix-2.patch
makefile-introduce-config_cc_stackprotector_auto-fix-3.patch

