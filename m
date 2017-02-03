From: akpm@linux-foundation.org
Subject: [patch 4/8] jump label: pass kbuild_cflags when checking for asm
 goto support
Date: Fri, 03 Feb 2017 13:13:18 -0800
Message-ID: <5894f26e.RaT+XMO/Ajd+UpF8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50280 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752508AbdBCVNT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2017 16:13:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, dtwlin@google.com, mmarek@suse.com, rostedt@goodmis.org

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
