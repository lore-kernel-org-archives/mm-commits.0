From: akpm@linux-foundation.org
Subject: [patch 07/51] sh: sh7722: remove nonexistent GPIO_PTQ7 to fix
 pinctrl registration
Date: Tue, 03 Oct 2017 16:14:34 -0700
Message-ID: <59d419da.F5kP8UykIreLcBDm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58378 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdJCXOg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 19:14:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, geert+renesas@glider.be, dalias@libc.org, jacopo+renesas@jmondi.org, laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com, yoshihiro.shimoda.uh@renesas.com, ysato@users.sourceforge.jp

From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: sh: sh7722: remove nonexistent GPIO_PTQ7 to fix pinctrl registration

Patch series "sh: sh7722/sh7757i/sh7264/sh7269: Fix pinctrl registration",
v2.

Magnus Damm reported that on sh7722/Migo-R, pinctrl registration fails
with:

    sh-pfc pfc-sh7722: pin 0 already registered
    sh-pfc pfc-sh7722: error during pin registration
    sh-pfc pfc-sh7722: could not register: -22
    sh-pfc: probe of pfc-sh7722 failed with error -22

pinmux_pins[] is initialized through PINMUX_GPIO(), using designated array
initializers, where the GPIO_* enums serve as indices.  Apparently
GPIO_PTQ7 was defined in the enum, but never used.  If enum values are
defined, but never used, pinmux_pins[] contains (zero-filled) holes. 
Hence such entries are treated as pin zero, which was registered before,
and pinctrl registration fails.

I can't see how this ever worked, as at the time of f5e25ae52feff2dc
("sh-pfc: Add sh7722 pinmux support"), pinmux_gpios[] in
drivers/pinctrl/sh-pfc/pfc-sh7722.c already had the hole, and
drivers/pinctrl/core.c already had the check.

Some scripting revealed a few more broken drivers:
  - sh7757 has four holes, due to nonexistent GPIO_PT[JLNQ]7_RESV.
  - sh7264 and sh7269 define GPIO_PH[0-7], but don't use it with
    PINMUX_GPIO().

Patch 1 fixes the issue on sh7722, and was tested.  Patches 3-4 should fix
the issue on the other 3 SoCs, but was untested due to lack of hardware.


This patch (of 4):

On sh7722/Migo-R, pinctrl registration fails with:

    sh-pfc pfc-sh7722: pin 0 already registered
    sh-pfc pfc-sh7722: error during pin registration
    sh-pfc pfc-sh7722: could not register: -22
    sh-pfc: probe of pfc-sh7722 failed with error -22

pinmux_pins[] is initialized through PINMUX_GPIO(), using designated array
initializers, where the GPIO_* enums serve as indices.  As GPIO_PTQ7 is
defined in the enum, but never used, pinmux_pins[] contains a
(zero-filled) hole.  Hence this entry is treated as pin zero, which was
registered before, and pinctrl registration fails.

According to the datasheet, port PTQ7 does not exist.  Hence remove
GPIO_PTQ7 from the enum to fix this.

Link: http://lkml.kernel.org/r/1505205657-18012-2-git-send-email-geert+renesas@glider.be
Fixes: 8d7b5b0af7e070b9 ("sh: Add sh7722 pinmux code")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reported-by: Magnus Damm <magnus.damm@gmail.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Tested-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/cpu-sh4/cpu/sh7722.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/sh/include/cpu-sh4/cpu/sh7722.h~sh-sh7722-remove-nonexistent-gpio_ptq7-to-fix-pinctrl-registration arch/sh/include/cpu-sh4/cpu/sh7722.h
--- a/arch/sh/include/cpu-sh4/cpu/sh7722.h~sh-sh7722-remove-nonexistent-gpio_ptq7-to-fix-pinctrl-registration
+++ a/arch/sh/include/cpu-sh4/cpu/sh7722.h
@@ -67,7 +67,7 @@ enum {
 	GPIO_PTN3, GPIO_PTN2, GPIO_PTN1, GPIO_PTN0,
 
 	/* PTQ */
-	GPIO_PTQ7, GPIO_PTQ6, GPIO_PTQ5, GPIO_PTQ4,
+	GPIO_PTQ6, GPIO_PTQ5, GPIO_PTQ4,
 	GPIO_PTQ3, GPIO_PTQ2, GPIO_PTQ1, GPIO_PTQ0,
 
 	/* PTR */
_
