From: akpm@linux-foundation.org
Subject: [patch 10/51] sh: sh7269: remove nonexistent GPIO_PH[0-7] to fix
 pinctrl registration
Date: Tue, 03 Oct 2017 16:14:44 -0700
Message-ID: <59d419e4.KRu2Xg4RkbSsDSff%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58442 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdJCXOp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 19:14:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, geert+renesas@glider.be, dalias@libc.org, jacopo+renesas@jmondi.org, laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com, yoshihiro.shimoda.uh@renesas.com, ysato@users.sourceforge.jp

From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: sh: sh7269: remove nonexistent GPIO_PH[0-7] to fix pinctrl registration

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

Link: http://lkml.kernel.org/r/1505205657-18012-5-git-send-email-geert+renesas@glider.be
Fixes: ef0fa5331a73e479 ("sh: Add pinmux for sh7269")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/cpu-sh2a/cpu/sh7269.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN arch/sh/include/cpu-sh2a/cpu/sh7269.h~sh-sh7269-remove-nonexistent-gpio_ph-to-fix-pinctrl-registration arch/sh/include/cpu-sh2a/cpu/sh7269.h
--- a/arch/sh/include/cpu-sh2a/cpu/sh7269.h~sh-sh7269-remove-nonexistent-gpio_ph-to-fix-pinctrl-registration
+++ a/arch/sh/include/cpu-sh2a/cpu/sh7269.h
@@ -45,9 +45,7 @@ enum {
 	GPIO_PG7, GPIO_PG6, GPIO_PG5, GPIO_PG4,
 	GPIO_PG3, GPIO_PG2, GPIO_PG1, GPIO_PG0,
 
-	/* Port H */
-	GPIO_PH7, GPIO_PH6, GPIO_PH5, GPIO_PH4,
-	GPIO_PH3, GPIO_PH2, GPIO_PH1, GPIO_PH0,
+	/* Port H - Port H does not have a Data Register */
 
 	/* Port I - not on device */
 
_
