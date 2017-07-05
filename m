From: akpm@linux-foundation.org
Subject: + cris-gpio-move-inline-before-return-type.patch added to -mm
 tree
Date: Wed, 05 Jul 2017 13:45:10 -0700
Message-ID: <595d4fd6.KS+w7Ej9vRvJ2+kT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54678 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753282AbdGEUpR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jul 2017 16:45:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, jesper.nilsson@axis.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     Subject: CRIS: gpio: move inline before return type
has been added to the -mm tree.  Its filename is
     cris-gpio-move-inline-before-return-type.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cris-gpio-move-inline-before-return-type.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cris-gpio-move-inline-before-return-type.patch

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
Subject: CRIS: gpio: move inline before return type

Move inline to be like the rest of the kernel.

Link: http://lkml.kernel.org/r/6bf1bec049897c4158f698b866810f47c728f233.1499284835.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/drivers/gpio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/cris/arch-v10/drivers/gpio.c~cris-gpio-move-inline-before-return-type arch/cris/arch-v10/drivers/gpio.c
--- a/arch/cris/arch-v10/drivers/gpio.c~cris-gpio-move-inline-before-return-type
+++ a/arch/cris/arch-v10/drivers/gpio.c
@@ -399,7 +399,7 @@ out:
 /* Main device API. ioctl's to read/set/clear bits, as well as to
  * set alarms to wait for using a subsequent select().
  */
-unsigned long inline setget_input(struct gpio_private *priv, unsigned long arg)
+inline unsigned long setget_input(struct gpio_private *priv, unsigned long arg)
 {
 	/* Set direction 0=unchanged 1=input,
 	 * return mask with 1=input */
@@ -450,7 +450,7 @@ unsigned long inline setget_input(struct
 	return dir_g_in_bits;
 } /* setget_input */
 
-unsigned long inline setget_output(struct gpio_private *priv, unsigned long arg)
+inline unsigned long setget_output(struct gpio_private *priv, unsigned long arg)
 {
 	if (USE_PORTS(priv)) {
 		*priv->dir = *priv->dir_shadow |=
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

