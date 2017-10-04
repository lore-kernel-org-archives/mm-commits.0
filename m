From: akpm@linux-foundation.org
Subject: [merged]
 sh-sh7264-remove-nonexistent-gpio_ph-to-fix-pinctrl-registration.patch
 removed from -mm tree
Date: Wed, 04 Oct 2017 12:40:16 -0700
Message-ID: <20171004194016.RlWKqnfJ_%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33342 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751209AbdJDTkR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2017 15:40:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dalias@libc.org, geert+renesas@glider.be, jacopo+renesas@jmondi.org, laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com, mm-commits@vger.kernel.org, yoshihiro.shimoda.uh@renesas.com, ysato@users.sourceforge.jp


The patch titled
     Subject: sh: sh7264: remove nonexistent GPIO_PH[0-7] to fix pinctrl registration
has been removed from the -mm tree.  Its filename was
     sh-sh7264-remove-nonexistent-gpio_ph-to-fix-pinctrl-registration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: sh: sh7264: remove nonexistent GPIO_PH[0-7] to fix pinctrl registration

Pinmux_pins[] is initialized through PINMUX_GPIO(), using designated array
initializers, where the GPIO_* enums serve as indices.  If enum values are
defined, but never used, pinmux_pins[] contains (zero-filled) holes.  Such
entries are treated as pin zero, which was registered before, thus leading
to pinctrl registration failures, as seen on sh7722:

    sh-pfc pfc-sh7722: pin 0 already registered
    sh-pfc pfc-sh7722: error during pin registration
    sh-pfc pfc-sh7722: could not register: -22
    sh-pfc: probe of pfc-sh7722 failed with error -22

Remove GPIO_PH[0-7] from the enum to fix this.

Link: http://lkml.kernel.org/r/1505205657-18012-4-git-send-email-geert+renesas@glider.be
Fixes: 41797f75486d8ca3 ("sh: Add pinmux for sh7264")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/cpu-sh2a/cpu/sh7264.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN arch/sh/include/cpu-sh2a/cpu/sh7264.h~sh-sh7264-remove-nonexistent-gpio_ph-to-fix-pinctrl-registration arch/sh/include/cpu-sh2a/cpu/sh7264.h
--- a/arch/sh/include/cpu-sh2a/cpu/sh7264.h~sh-sh7264-remove-nonexistent-gpio_ph-to-fix-pinctrl-registration
+++ a/arch/sh/include/cpu-sh2a/cpu/sh7264.h
@@ -43,9 +43,7 @@ enum {
 	GPIO_PG7, GPIO_PG6, GPIO_PG5, GPIO_PG4,
 	GPIO_PG3, GPIO_PG2, GPIO_PG1, GPIO_PG0,
 
-	/* Port H */
-	GPIO_PH7, GPIO_PH6, GPIO_PH5, GPIO_PH4,
-	GPIO_PH3, GPIO_PH2, GPIO_PH1, GPIO_PH0,
+	/* Port H - Port H does not have a Data Register */
 
 	/* Port I - not on device */
 
_

Patches currently in -mm which might be from geert+renesas@glider.be are


