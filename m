From: akpm@linux-foundation.org
Subject: + arm-hp-jornada-7xx-move-inline-before-return-type.patch added
 to -mm tree
Date: Wed, 05 Jul 2017 13:45:08 -0700
Message-ID: <595d4fd4.hrbTxAnX6OQTWD+M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54672 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753115AbdGEUpJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jul 2017 16:45:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, linux@armlinux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: ARM: HP Jornada 7XX: move inline before return type
has been added to the -mm tree.  Its filename is
     arm-hp-jornada-7xx-move-inline-before-return-type.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm-hp-jornada-7xx-move-inline-before-return-type.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm-hp-jornada-7xx-move-inline-before-return-type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: ARM: HP Jornada 7XX: move inline before return type

Convert 'u8 inline' to 'inline u8' to be the same style used
by the rest of the kernel.

Miscellanea:

jornada_ssp_reverse is an odd function.
It is declared inline but is also EXPORT_SYMBOL.
It is also apparently only used by jornada720_ssp.c
Likely the EXPORT_SYMBOL could be removed and the function
converted to static.

The addition of static and removal of EXPORT_SYMBOL was not done.

Link: http://lkml.kernel.org/r/5bd3b2bf39c6c9caf773949f18158f8f5ec08582.1499284835.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-sa1100/jornada720_ssp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/mach-sa1100/jornada720_ssp.c~arm-hp-jornada-7xx-move-inline-before-return-type arch/arm/mach-sa1100/jornada720_ssp.c
--- a/arch/arm/mach-sa1100/jornada720_ssp.c~arm-hp-jornada-7xx-move-inline-before-return-type
+++ a/arch/arm/mach-sa1100/jornada720_ssp.c
@@ -33,7 +33,7 @@ static unsigned long jornada_ssp_flags;
  * we need to reverse all data we receive from the mcu due to its physical location
  * returns : 01110111 -> 11101110
  */
-u8 inline jornada_ssp_reverse(u8 byte)
+inline u8 jornada_ssp_reverse(u8 byte)
 {
 	return
 		((0x80 & byte) >> 7) |
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-improve-the-unnecessary-oom-message-test.patch
checkpatch-warn-when-a-maintainers-entry-isnt-t.patch
checkpatch-fix-stepping-through-statements-with-stat-and-ctx_statement_block.patch
checkpatch-improve-tests-for-multiple-line-function-definitions.patch
checkpatch-improve-macro-reuse-test.patch
checkpatch-improve-multi-line-alignment-test.patch
checkpatch-improve-the-storage_class-test.patch
arm-kvm-move-asmlinkage-before-type.patch
arm-hp-jornada-7xx-move-inline-before-return-type.patch
cris-gpio-move-inline-before-return-type.patch
frv-tlbflush-move-asmlinkage-before-return-type.patch
ia64-move-inline-before-return-type.patch
ia64-sn-pci-move-inline-before-type.patch
m68k-coldfire-move-inline-before-return-type.patch
mips-smp-move-asmlinkage-before-return-type.patch
sh-move-inline-before-return-type.patch
x86-efi-move-asmlinkage-before-return-type.patch
drivers-s390-move-static-and-inline-before-return-type.patch
drivers-tty-serial-move-inline-before-return-type.patch
usb-serial-safe_serial-move-__inline__-before-return-type.patch
video-fbdev-intelfb-move-inline-before-return-type.patch
video-fbdev-omap-move-inline-before-return-type.patch
arm-samsung-usb-ohci-move-inline-before-return-type.patch
alsa-opl4-move-inline-before-return-type.patch

