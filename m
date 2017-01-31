From: akpm@linux-foundation.org
Subject: +
 jump-label-pass-kbuild_cflags-when-checking-for-asm-goto-support.patch
 added to -mm tree
Date: Tue, 31 Jan 2017 14:14:33 -0800
Message-ID: <58910c49.XdjP0c+2LGQquLlG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41838 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750978AbdAaWOe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2017 17:14:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dtwlin@google.com, mmarek@suse.com, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: jump label: pass kbuild_cflags when checking for asm goto support
has been added to the -mm tree.  Its filename is
     jump-label-pass-kbuild_cflags-when-checking-for-asm-goto-support.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/jump-label-pass-kbuild_cflags-when-checking-for-asm-goto-support.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/jump-label-pass-kbuild_cflags-when-checking-for-asm-goto-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

jump-label-pass-kbuild_cflags-when-checking-for-asm-goto-support.patch

