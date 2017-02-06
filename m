From: akpm@linux-foundation.org
Subject: [merged]
 jump-label-pass-kbuild_cflags-when-checking-for-asm-goto-support.patch
 removed from -mm tree
Date: Mon, 06 Feb 2017 13:24:40 -0800
Message-ID: <5898e998.s6WgO1/rEMPZTrz4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57772 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752325AbdBFVYl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2017 16:24:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dtwlin@google.com, mmarek@suse.com, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: jump label: pass kbuild_cflags when checking for asm goto support
has been removed from the -mm tree.  Its filename was
     jump-label-pass-kbuild_cflags-when-checking-for-asm-goto-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Lin <dtwlin@google.com>
Subject: jump label: pass kbuild_cflags when checking for asm goto support

Some versions of ARM GCC compiler such as Android toolchain throws in a
'-fpic' flag by default.  This causes the gcc-goto check script to fail
although some config would have '-fno-pic' flag in the KBUILD_CFLAGS.

This patch passes the KBUILD_CFLAGS to the check script so that the script
does not rely on the default config from different compilers.

Link: http://lkml.kernel.org/r/20170120234329.78868-1-dtwlin@google.com
Signed-off-by: David Lin <dtwlin@google.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Michal Marek <mmarek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Makefile~jump-label-pass-kbuild_cflags-when-checking-for-asm-goto-support Makefile
--- a/Makefile~jump-label-pass-kbuild_cflags-when-checking-for-asm-goto-support
+++ a/Makefile
@@ -797,7 +797,7 @@ KBUILD_CFLAGS   += $(call cc-option,-Wer
 KBUILD_ARFLAGS := $(call ar-option,D)
 
 # check for 'asm goto'
-ifeq ($(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-goto.sh $(CC)), y)
+ifeq ($(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-goto.sh $(CC) $(KBUILD_CFLAGS)), y)
 	KBUILD_CFLAGS += -DCC_HAVE_ASM_GOTO
 	KBUILD_AFLAGS += -DCC_HAVE_ASM_GOTO
 endif
_

Patches currently in -mm which might be from dtwlin@google.com are


