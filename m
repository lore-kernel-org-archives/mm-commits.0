From: akpm@linux-foundation.org
Subject: + x86_32-fix-fault_msg-nul-termination.patch added to -mm tree
Date: Thu, 13 Mar 2008 12:52:11 -0700
Message-ID: <200803131952.m2DJqBmx030009@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50036 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753997AbYCMTxb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Mar 2008 15:53:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de


The patch titled
     x86_32: fix fault_msg nul termination
has been added to the -mm tree.  Its filename is
     x86_32-fix-fault_msg-nul-termination.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86_32: fix fault_msg nul termination
From: Jiri Slaby <jirislaby@gmail.com>

The fault_msg text is not explictly nul terminated now in startup assembly. 
Do so by converting .ascii to .asciz.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/head_32.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/kernel/head_32.S~x86_32-fix-fault_msg-nul-termination arch/x86/kernel/head_32.S
--- a/arch/x86/kernel/head_32.S~x86_32-fix-fault_msg-nul-termination
+++ a/arch/x86/kernel/head_32.S
@@ -657,7 +657,7 @@ int_msg:
 	.asciz "Unknown interrupt or fault at EIP %p %p %p\n"
 
 fault_msg:
-	.ascii								\
+	.asciz								\
 /* fault info: */	"BUG: Int %d: CR2 %p\n"				\
 /* pusha regs: */	"     EDI %p  ESI %p  EBP %p  ESP %p\n"		\
 			"     EBX %p  EDX %p  ECX %p  EAX %p\n"		\
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-riscom-fix-rc_board-indexing.patch
block-floppy-fix-rmmod-lockup.patch
git-drm.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
wdev-ath5k-typecheck-on-nondebug.patch
x86_32-fix-fault_msg-nul-termination.patch
capabilities-implement-per-process-securebits-fix.patch
misc-phantom-add-compat-ioctl.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
misc-phantom-fix-poll.patch
misc-phantom-consistent-whitespace.patch
mxser-prepare-for-bkl-pushdown.patch
tty-bkl-pushdown-fix.patch
tty-bkl-pushdown-fix1.patch
char-moxa-remove-static-isa-support.patch
char-moxa-cleanup-module-param-passed-isa-init.patch
char-moxa-pci-io-space-fixup.patch
char-moxa-fix-tiocg-ssoftcar-param.patch
char-moxa-add-firmware-loading.patch
char-moxa-merge-c2xx-and-c320-firmware-loading.patch
char-moxa-remove-port-port.patch
char-moxa-remove-unused-port-entries.patch
char-moxa-centralize-board-readiness.patch
char-moxa-timer-cleanup.patch
char-moxa-ioctl-cleanup.patch
char-moxa-merge-2-poll-functions.patch
char-moxa-cleanup-rx-tx.patch
char-moxa-serialise-timer.patch
char-moxa-rework-open-close.patch
char-moxa-little-cleanup.patch
char-moxa-remove-useless-tty-functions.patch
char-moxa-introduce-moxa_is_320-macro.patch
char-moxa-notify-about-board-readiness.patch
char-moxa-update-credits.patch
char-moxa-add-firmware-loading-fix.patch
char-espc-fix-possible-double-unlock.patch
mxser-convert-large-macros-to-functions.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

