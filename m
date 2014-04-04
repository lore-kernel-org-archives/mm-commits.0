From: akpm@linux-foundation.org
Subject: [merged] sh-sh7757-switch-rspi-clock-to-dev-id-match.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:29:53 -0700
Message-ID: <533f0831.9DpxAWWvDVZRP6VN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42690 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374AbaDDT3x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:29:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yoshihiro.shimoda.uh@renesas.com, geert+renesas@linux-m68k.org

Subject: [merged] sh-sh7757-switch-rspi-clock-to-dev-id-match.patch removed from -mm tree
To: geert+renesas@linux-m68k.org,yoshihiro.shimoda.uh@renesas.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:29:53 -0700


The patch titled
     Subject: sh: sh7757: switch RSPI clock to dev ID match
has been removed from the -mm tree.  Its filename was
     sh-sh7757-switch-rspi-clock-to-dev-id-match.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: sh: sh7757: switch RSPI clock to dev ID match

Switch the RSPI MSTP clock on SH7757 from a con ID match to a dev ID
match, so we can start looking it up using clk_get() with a NULL ID.

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/kernel/cpu/sh4a/clock-sh7757.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/sh/kernel/cpu/sh4a/clock-sh7757.c~sh-sh7757-switch-rspi-clock-to-dev-id-match arch/sh/kernel/cpu/sh4a/clock-sh7757.c
--- a/arch/sh/kernel/cpu/sh4a/clock-sh7757.c~sh-sh7757-switch-rspi-clock-to-dev-id-match
+++ a/arch/sh/kernel/cpu/sh4a/clock-sh7757.c
@@ -132,7 +132,7 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_CON_ID("usb_fck", &mstp_clks[MSTP103]),
 	CLKDEV_DEV_ID("renesas_usbhs.0", &mstp_clks[MSTP102]),
 	CLKDEV_CON_ID("mmc0", &mstp_clks[MSTP220]),
-	CLKDEV_CON_ID("rspi2", &mstp_clks[MSTP127]),
+	CLKDEV_DEV_ID("rspi.2", &mstp_clks[MSTP127]),
 };
 
 int __init arch_clk_init(void)
_

Patches currently in -mm which might be from geert+renesas@linux-m68k.org are

origin.patch
linux-next.patch

