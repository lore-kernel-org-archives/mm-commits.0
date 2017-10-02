From: akpm@linux-foundation.org
Subject: + sh-boot-add-static-stack-protector-to-pre-kernel.patch added to -mm tree
Date: Mon, 02 Oct 2017 14:43:53 -0700
Message-ID: <59d2b319.Jq/08EKJLgq0GgJd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41282 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750770AbdJBVnz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 2 Oct 2017 17:43:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, dalias@libc.org, labbott@redhat.com, mingo@kernel.org, mmarek@suse.com, npiggin@gmail.com, viro@zeniv.linux.org.uk, yamada.masahiro@socionext.com, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: sh/boot: add static stack-protector to pre-kernel
has been added to the -mm tree.  Its filename is
     sh-boot-add-static-stack-protector-to-pre-kernel.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sh-boot-add-static-stack-protector-to-pre-kernel.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sh-boot-add-static-stack-protector-to-pre-kernel.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

sh-boot-add-static-stack-protector-to-pre-kernel.patch
makefile-move-stackprotector-availability-out-of-kconfig.patch
makefile-introduce-config_cc_stackprotector_auto.patch

