From: akpm@linux-foundation.org
Subject: +
 ia64-select-config_tty-for-use-of-tty_write_message-in-unaligned.patch
 added to -mm tree
Date: Tue, 04 Mar 2014 12:14:19 -0800
Message-ID: <5316341b.Q1Hob81AKvB1JaFZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41904 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757680AbaCDUOU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 15:14:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tony.luck@intel.com, sfr@canb.auug.org.au, josh@joshtriplett.org

Subject: + ia64-select-config_tty-for-use-of-tty_write_message-in-unaligned.patch added to -mm tree
To: josh@joshtriplett.org,sfr@canb.auug.org.au,tony.luck@intel.com
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 12:14:19 -0800


The patch titled
     Subject: ia64: select CONFIG_TTY for use of tty_write_message in unaligned
has been added to the -mm tree.  Its filename is
     ia64-select-config_tty-for-use-of-tty_write_message-in-unaligned.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ia64-select-config_tty-for-use-of-tty_write_message-in-unaligned.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ia64-select-config_tty-for-use-of-tty_write_message-in-unaligned.patch

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
Subject: ia64: select CONFIG_TTY for use of tty_write_message in unaligned

Fix breakage which will be exposed by the patch "kconfig: make allnoconfig
disable options behind EMBEDDED and EXPERT".

arch/ia64/kernel/unaligned.c uses tty_write_message to print an
unaligned access exception to the TTY of the current user process.
Enable TTY to prevent a build error.

Minimal fix, on the basis that few people on ia64 will care deeply about
kernel size enough to turn off TTY.  Ideally, I'd instead suggest
dropping the tty_write_message entirely, and just leaving the printk.
Bonus: no need to sprintf first.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/ia64/Kconfig~ia64-select-config_tty-for-use-of-tty_write_message-in-unaligned arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~ia64-select-config_tty-for-use-of-tty_write_message-in-unaligned
+++ a/arch/ia64/Kconfig
@@ -44,6 +44,7 @@ config IA64
 	select HAVE_MOD_ARCH_SPECIFIC
 	select MODULES_USE_ELF_RELA
 	select ARCH_USE_CMPXCHG_LOCKREF
+	select TTY
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
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

