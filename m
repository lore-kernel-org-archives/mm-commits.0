From: akpm@linux-foundation.org
Subject: +
 s390-select-config_tty-for-use-of-tty-in-unconditional-keyboard-driver.patch added to -mm tree
Date: Tue, 04 Mar 2014 12:14:21 -0800
Message-ID: <5316341d.e6bxcsmpT01TOntG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41915 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757688AbaCDUOW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 15:14:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sfr@canb.auug.org.au, schwidefsky@de.ibm.com, josh@joshtriplett.org

Subject: + s390-select-config_tty-for-use-of-tty-in-unconditional-keyboard-driver.patch added to -mm tree
To: josh@joshtriplett.org,schwidefsky@de.ibm.com,sfr@canb.auug.org.au
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 12:14:21 -0800


The patch titled
     Subject: s390: select CONFIG_TTY for use of tty in unconditional keyboard driver
has been added to the -mm tree.  Its filename is
     s390-select-config_tty-for-use-of-tty-in-unconditional-keyboard-driver.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/s390-select-config_tty-for-use-of-tty-in-unconditional-keyboard-driver.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/s390-select-config_tty-for-use-of-tty-in-unconditional-keyboard-driver.patch

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
Subject: s390: select CONFIG_TTY for use of tty in unconditional keyboard driver

Fix breakage which will be exposed by the patch "kconfig: make allnoconfig
disable options behind EMBEDDED and EXPERT".

The unconditionally built keyboard driver, drivers/s390/char/keyboard.c,
requires CONFIG_TTY, so select it from CONFIG_S390 to prevent a build
error.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/s390/Kconfig~s390-select-config_tty-for-use-of-tty-in-unconditional-keyboard-driver arch/s390/Kconfig
--- a/arch/s390/Kconfig~s390-select-config_tty-for-use-of-tty-in-unconditional-keyboard-driver
+++ a/arch/s390/Kconfig
@@ -140,6 +140,7 @@ config S390
 	select OLD_SIGACTION
 	select OLD_SIGSUSPEND3
 	select SYSCTL_EXCEPTION_TRACE
+	select TTY
 	select VIRT_CPU_ACCOUNTING
 	select VIRT_TO_BUS
 
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
bug-use-a-common-definition-of-bug_on-regardless-of-config_bug.patch
linux-next.patch

