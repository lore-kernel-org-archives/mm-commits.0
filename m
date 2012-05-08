From: akpm@linux-foundation.org
Subject: + clk-remove-redundant-depends-on-from-drivers-kconfig.patch added to -mm tree
Date: Tue, 08 May 2012 15:32:47 -0700
Message-ID: <20120508223247.E5A76A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:33759 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757553Ab2EHWcu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2012 18:32:50 -0400
Received: by eekd41 with SMTP id d41so76471eek.1
        for <mm-commits@vger.kernel.org>; Tue, 08 May 2012 15:32:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viresh.kumar@st.com, andrew@lunn.ch, bhupesh.sharma@st.com, gregkh@linuxfoundation.org, jgarzik@redhat.com, mturquette@linaro.org, peppe.cavallaro@st.com, rmk@arm.linux.org.uk, sshtylyov@ru.mvista.com, w.sang@pengutronix.de


The patch titled
     Subject: clk: remove redundant depends on from drivers/Kconfig
has been added to the -mm tree.  Its filename is
     clk-remove-redundant-depends-on-from-drivers-kconfig.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Viresh Kumar <viresh.kumar@st.com>
Subject: clk: remove redundant depends on from drivers/Kconfig

menu "Common Clock Framework" has "depends on COMMON_CLK" and so configs
defined within menu don't require these "depends on COMMON_CLK again".

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jeff Garzik <jgarzik@redhat.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Bhupesh Sharma <bhupesh.sharma@st.com>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/clk/Kconfig |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/clk/Kconfig~clk-remove-redundant-depends-on-from-drivers-kconfig drivers/clk/Kconfig
--- a/drivers/clk/Kconfig~clk-remove-redundant-depends-on-from-drivers-kconfig
+++ a/drivers/clk/Kconfig
@@ -24,7 +24,6 @@ menu "Common Clock Framework"
 
 config COMMON_CLK_DISABLE_UNUSED
 	bool "Disabled unused clocks at boot"
-	depends on COMMON_CLK
 	---help---
 	  Traverses the entire clock tree and disables any clocks that are
 	  enabled in hardware but have not been enabled by any device drivers.
@@ -35,7 +34,6 @@ config COMMON_CLK_DISABLE_UNUSED
 
 config COMMON_CLK_DEBUG
 	bool "DebugFS representation of clock tree"
-	depends on COMMON_CLK
 	select DEBUG_FS
 	---help---
 	  Creates a directory hierchy in debugfs for visualizing the clk
_
Subject: Subject: clk: remove redundant depends on from drivers/Kconfig

Patches currently in -mm which might be from viresh.kumar@st.com are

linux-next.patch
drivers-thermal-spear_thermalc-add-device-tree-probing-capability.patch
clk-add-non-config_have_clk-routines.patch
clk-remove-redundant-depends-on-from-drivers-kconfig.patch
i2c-i2c-pxa-remove-conditional-compilation-of-clk-code.patch
usb-marvell-remove-conditional-compilation-of-clk-code.patch
usb-musb-remove-conditional-compilation-of-clk-code.patch
ata-pata_arasan-remove-conditional-compilation-of-clk-code.patch
ata-sata_mv-remove-conditional-compilation-of-clk-code.patch
net-c_can-remove-conditional-compilation-of-clk-code.patch
net-stmmac-remove-conditional-compilation-of-clk-code.patch
gadget-m66592-remove-conditional-compilation-of-clk-code.patch
gadget-r8a66597-remove-conditional-compilation-of-clk-code.patch
usb-host-r8a66597-remove-conditional-compilation-of-clk-code.patch
rtc-spear-add-device-tree-probing-capability.patch

