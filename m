From: akpm@linux-foundation.org
Subject: + sh-sh7757-switch-rspi-clock-to-dev-id-match.patch added to -mm
 tree
Date: Tue, 11 Mar 2014 14:50:41 -0700
Message-ID: <531f8531.4DeXcBkVzM3bLaI/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45530 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208AbaCKVum (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Mar 2014 17:50:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yoshihiro.shimoda.uh@renesas.com, geert+renesas@linux-m68k.org

Subject: + sh-sh7757-switch-rspi-clock-to-dev-id-match.patch added to -mm tree
To: geert+renesas@linux-m68k.org,yoshihiro.shimoda.uh@renesas.com
From: akpm@linux-foundation.org
Date: Tue, 11 Mar 2014 14:50:41 -0700


The patch titled
     Subject: sh: sh7757: switch RSPI clock to dev ID match
has been added to the -mm tree.  Its filename is
     sh-sh7757-switch-rspi-clock-to-dev-id-match.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sh-sh7757-switch-rspi-clock-to-dev-id-match.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sh-sh7757-switch-rspi-clock-to-dev-id-match.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

sh-sh7757-switch-rspi-clock-to-dev-id-match.patch
maintainers-mark-superh-orphan.patch
linux-next.patch

