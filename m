From: akpm@linux-foundation.org
Subject: + dts-add-esdhc-weird-voltage-bits-workaround.patch added to -mm tree
Date: Tue, 03 Aug 2010 16:45:36 -0700
Message-ID: <201008032345.o73NjaO1018139__24614.4757875756$1280879149$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36802 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756841Ab0HCXpm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Aug 2010 19:45:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tie-fei.zang@freescale.com, Chang-Ming.Huang@freescale.com, benh@kernel.crashing.org, galak@gate.crashing.org, grant.likely@secretlab.ca, linux-mmc@vger.kernel.org


The patch titled
     dts: add ESDHC weird voltage bits workaround
has been added to the -mm tree.  Its filename is
     dts-add-esdhc-weird-voltage-bits-workaround.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dts: add ESDHC weird voltage bits workaround
From: Roy Zang <tie-fei.zang@freescale.com>

P4080 ESDHC controller does not support 1.8V and 3.0V voltage.  but the
host controller capabilities register wrongly set the bits.  This patch
adds the workaround to correct the weird voltage setting bits.  Only 3.3V
voltage is supported for P4080 ESDHC controller.

Signed-off-by: Roy Zang <tie-fei.zang@freescale.com>
Cc: Jerry Huang <Chang-Ming.Huang@freescale.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/boot/dts/p4080ds.dts |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/powerpc/boot/dts/p4080ds.dts~dts-add-esdhc-weird-voltage-bits-workaround arch/powerpc/boot/dts/p4080ds.dts
--- a/arch/powerpc/boot/dts/p4080ds.dts~dts-add-esdhc-weird-voltage-bits-workaround
+++ a/arch/powerpc/boot/dts/p4080ds.dts
@@ -280,6 +280,7 @@
 			reg = <0x114000 0x1000>;
 			interrupts = <48 2>;
 			interrupt-parent = <&mpic>;
+			voltage-ranges = <3300 3300>;
 			sdhci,auto-cmd12;
 		};
 
_

Patches currently in -mm which might be from tie-fei.zang@freescale.com are

sdhci-add-auto-cmd12-support-for-esdhc-driver.patch
dts-add-sdhciauto-cmd12-field-for-p4080-device-tree.patch
dts-add-esdhc-weird-voltage-bits-workaround.patch
rtc-add-support-for-ds3232-rtc.patch
rtc-add-support-for-ds3232-rtc-fix.patch

