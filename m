From: akpm@linux-foundation.org
Subject: + cris-make-etrax_arch_v10-select-tty-for-use-in-debugport.patch
 added to -mm tree
Date: Tue, 04 Mar 2014 12:14:16 -0800
Message-ID: <53163418.10SpSVdeztuiwSHI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41892 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbaCDUOR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 15:14:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, starvik@axis.com, sfr@canb.auug.org.au, jesper.nilsson@axis.com, josh@joshtriplett.org

Subject: + cris-make-etrax_arch_v10-select-tty-for-use-in-debugport.patch added to -mm tree
To: josh@joshtriplett.org,jesper.nilsson@axis.com,sfr@canb.auug.org.au,starvik@axis.com
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 12:14:16 -0800


The patch titled
     Subject: cris: make ETRAX_ARCH_V10 select TTY for use in debugport
has been added to the -mm tree.  Its filename is
     cris-make-etrax_arch_v10-select-tty-for-use-in-debugport.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cris-make-etrax_arch_v10-select-tty-for-use-in-debugport.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cris-make-etrax_arch_v10-select-tty-for-use-in-debugport.patch

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
Subject: cris: make ETRAX_ARCH_V10 select TTY for use in debugport

Fix breakage which will be exposed by the patch "kconfig: make allnoconfig
disable options behind EMBEDDED and EXPERT".

arch/cris/arch-v10/kernel/debugport.c, compiled in unconditionally with
ETRAX_ARCH_V10, requires TTY, so select TTY to avoid a build failure.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/cris/Kconfig~cris-make-etrax_arch_v10-select-tty-for-use-in-debugport arch/cris/Kconfig
--- a/arch/cris/Kconfig~cris-make-etrax_arch_v10-select-tty-for-use-in-debugport
+++ a/arch/cris/Kconfig
@@ -138,6 +138,7 @@ config ETRAX_ARCH_V10
        bool
        default y if ETRAX100LX || ETRAX100LX_V2
        default n if !(ETRAX100LX || ETRAX100LX_V2)
+       select TTY
 
 config ETRAX_ARCH_V32
        bool
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

