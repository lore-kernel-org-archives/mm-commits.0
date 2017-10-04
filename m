From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?sh-sh7757-remove-nonexistent-gpio=5Fpt7=5Fresv-to-fix-pinctr?=
 =?US-ASCII?Q?l-registration.patch?= removed from -mm tree
Date: Wed, 04 Oct 2017 12:40:13 -0700
Message-ID: <20171004194013.M416_-USL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33326 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751209AbdJDTkO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2017 15:40:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dalias@libc.org, geert+renesas@glider.be, jacopo+renesas@jmondi.org, laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com, mm-commits@vger.kernel.org, yoshihiro.shimoda.uh@renesas.com, ysato@users.sourceforge.jp


The patch titled
     Subject: sh: sh7757: remove nonexistent GPIO_PT[JLNQ]7_RESV to fix pinctrl registration
has been removed from the -mm tree.  Its filename was
     sh-sh7757-remove-nonexistent-gpio_pt7_resv-to-fix-pinctrl-registration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: sh: sh7757: remove nonexistent GPIO_PT[JLNQ]7_RESV to fix pinctrl registration

3810e96056ffddf6 ("sh: modify pinmux for SH7757 2nd cut") renamed
GPIO_PT[JLNQ]7 to GPIO_PT[JLNQ]7_RESV, and removed the existing users from
the pinmux_pins[] array.

However, pinmux_pins[] is initialized through PINMUX_GPIO(), using
designated array initializers, where the GPIO_* enums serve as indices. 
Hence entries were not really removed, but replaced by (zero-filled)
holes.  Such entries are treated as pin zero, which was registered before,
thus leading to pinctrl registration failures, as seen on sh7722:

    sh-pfc pfc-sh7722: pin 0 already registered
    sh-pfc pfc-sh7722: error during pin registration
    sh-pfc pfc-sh7722: could not register: -22
    sh-pfc: probe of pfc-sh7722 failed with error -22

Remove GPIO_PT[JLNQ]7_RESV from the enum to fix this.

Link: http://lkml.kernel.org/r/1505205657-18012-3-git-send-email-geert+renesas@glider.be
Fixes: 3810e96056ffddf6 ("sh: modify pinmux for SH7757 2nd cut")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/cpu-sh4/cpu/sh7757.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/sh/include/cpu-sh4/cpu/sh7757.h~sh-sh7757-remove-nonexistent-gpio_pt7_resv-to-fix-pinctrl-registration arch/sh/include/cpu-sh4/cpu/sh7757.h
--- a/arch/sh/include/cpu-sh4/cpu/sh7757.h~sh-sh7757-remove-nonexistent-gpio_pt7_resv-to-fix-pinctrl-registration
+++ a/arch/sh/include/cpu-sh4/cpu/sh7757.h
@@ -40,7 +40,7 @@ enum {
 
 	/* PTJ */
 	GPIO_PTJ0, GPIO_PTJ1, GPIO_PTJ2, GPIO_PTJ3,
-	GPIO_PTJ4, GPIO_PTJ5, GPIO_PTJ6, GPIO_PTJ7_RESV,
+	GPIO_PTJ4, GPIO_PTJ5, GPIO_PTJ6,
 
 	/* PTK */
 	GPIO_PTK0, GPIO_PTK1, GPIO_PTK2, GPIO_PTK3,
@@ -48,7 +48,7 @@ enum {
 
 	/* PTL */
 	GPIO_PTL0, GPIO_PTL1, GPIO_PTL2, GPIO_PTL3,
-	GPIO_PTL4, GPIO_PTL5, GPIO_PTL6, GPIO_PTL7_RESV,
+	GPIO_PTL4, GPIO_PTL5, GPIO_PTL6,
 
 	/* PTM */
 	GPIO_PTM0, GPIO_PTM1, GPIO_PTM2, GPIO_PTM3,
@@ -56,7 +56,7 @@ enum {
 
 	/* PTN */
 	GPIO_PTN0, GPIO_PTN1, GPIO_PTN2, GPIO_PTN3,
-	GPIO_PTN4, GPIO_PTN5, GPIO_PTN6, GPIO_PTN7_RESV,
+	GPIO_PTN4, GPIO_PTN5, GPIO_PTN6,
 
 	/* PTO */
 	GPIO_PTO0, GPIO_PTO1, GPIO_PTO2, GPIO_PTO3,
@@ -68,7 +68,7 @@ enum {
 
 	/* PTQ */
 	GPIO_PTQ0, GPIO_PTQ1, GPIO_PTQ2, GPIO_PTQ3,
-	GPIO_PTQ4, GPIO_PTQ5, GPIO_PTQ6, GPIO_PTQ7_RESV,
+	GPIO_PTQ4, GPIO_PTQ5, GPIO_PTQ6,
 
 	/* PTR */
 	GPIO_PTR0, GPIO_PTR1, GPIO_PTR2, GPIO_PTR3,
_

Patches currently in -mm which might be from geert+renesas@glider.be are


