From: akpm@linux-foundation.org
Subject: +
 x86-always-define-bug-and-have_arch_bug-even-with-config_bug.patch added to -mm tree
Date: Mon, 10 Mar 2014 12:50:33 -0700
Message-ID: <531e1789.YLqVmHJhZmPA+78v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40565 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667AbaCJTue (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Mar 2014 15:50:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com, arnd@arndb.de, josh@joshtriplett.org

Subject: + x86-always-define-bug-and-have_arch_bug-even-with-config_bug.patch added to -mm tree
To: josh@joshtriplett.org,arnd@arndb.de,hpa@zytor.com,mingo@elte.hu,tglx@linutronix.de
From: akpm@linux-foundation.org
Date: Mon, 10 Mar 2014 12:50:33 -0700


The patch titled
     Subject: x86: always define BUG() and HAVE_ARCH_BUG, even with !CONFIG_BUG
has been added to the -mm tree.  Its filename is
     x86-always-define-bug-and-have_arch_bug-even-with-config_bug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-always-define-bug-and-have_arch_bug-even-with-config_bug.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-always-define-bug-and-have_arch_bug-even-with-config_bug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Josh Triplett <josh@joshtriplett.org>
Subject: x86: always define BUG() and HAVE_ARCH_BUG, even with !CONFIG_BUG

This ensures that BUG() always has a definition that causes a trap (via an
undefined instruction), and that the compiler still recognizes the code
following BUG() as unreachable, avoiding warnings that would otherwise
appear (such as on non-void functions that don't return a value after
BUG()).

In addition to saving a few bytes over the generic infinite-loop
implementation, this implementation traps rather than looping, which
potentially allows for better error-recovery behavior (such as by
rebooting).

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/bug.h |    3 ---
 1 file changed, 3 deletions(-)

diff -puN arch/x86/include/asm/bug.h~x86-always-define-bug-and-have_arch_bug-even-with-config_bug arch/x86/include/asm/bug.h
--- a/arch/x86/include/asm/bug.h~x86-always-define-bug-and-have_arch_bug-even-with-config_bug
+++ a/arch/x86/include/asm/bug.h
@@ -1,7 +1,6 @@
 #ifndef _ASM_X86_BUG_H
 #define _ASM_X86_BUG_H
 
-#ifdef CONFIG_BUG
 #define HAVE_ARCH_BUG
 
 #ifdef CONFIG_DEBUG_BUGVERBOSE
@@ -33,8 +32,6 @@ do {								\
 } while (0)
 #endif
 
-#endif /* !CONFIG_BUG */
-
 #include <asm-generic/bug.h>
 
 #endif /* _ASM_X86_BUG_H */
_

Patches currently in -mm which might be from josh@joshtriplett.org are

mm-compactionc-mark-function-as-static.patch
mm-memoryc-mark-functions-as-static.patch
mm-mmapc-mark-function-as-static.patch
mm-process_vm_accessc-mark-function-as-static.patch
mm-process_vm_accessc-mark-function-as-static-fix.patch
mm-page_cgroupc-mark-functions-as-static.patch
mm-nobootmemc-mark-function-as-static.patch
include-linux-mmh-remove-ifdef-condition.patch
include-linux-syscallsh-add-sys32_quotactl-prototype.patch
fs-kernel-permit-disabling-the-uselib-syscall.patch
fs-kernel-permit-disabling-the-uselib-syscall-v2.patch
submittingpatches-add-style-recommendation-to-use-imperative-descriptions.patch
submittingpatches-add-recommendation-for-mailing-list-references.patch
submittingpatches-document-the-use-of-git.patch
lglock-map-to-spinlock-when-config_smp.patch
lib-clz_ctzc-add-prototype-declarations-in-lib-clz_ctzc.patch
lib-decompress_inflatec-include-appropriate-header-file.patch
checkpatch-make-return-is-not-a-function-test-quieter.patch
fs-reiserfs-move-prototype-declaration-to-header-file.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
cris-make-etrax_arch_v10-select-tty-for-use-in-debugport.patch
ia64-select-config_tty-for-use-of-tty_write_message-in-unaligned.patch
ppc-make-ppc_book3s_64-select-irq_work.patch
s390-select-config_tty-for-use-of-tty-in-unconditional-keyboard-driver.patch
kconfig-make-allnoconfig-disable-options-behind-embedded-and-expert.patch
bug-when-config_bug-simplify-warn_on_once-and-family.patch
include-asm-generic-bugh-style-fix-s-while0-while-0.patch
bug-when-config_bug-make-warn-call-no_printk-to-check-format-and-args.patch
bug-make-bug-always-stop-the-machine.patch
x86-always-define-bug-and-have_arch_bug-even-with-config_bug.patch
linux-next.patch

