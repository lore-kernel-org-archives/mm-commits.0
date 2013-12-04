From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-ds1742c-add-devicetree-support.patch added to
 -mm tree
Date: Wed, 04 Dec 2013 14:02:46 -0800
Message-ID: <529fa686.BUnLW4AYzB12K0xY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35613 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab3LDWCr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Dec 2013 17:02:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mark.rutland@arm.com, shc_work@mail.ru

Subject: + drivers-rtc-rtc-ds1742c-add-devicetree-support.patch added to -mm tree
To: shc_work@mail.ru,mark.rutland@arm.com
From: akpm@linux-foundation.org
Date: Wed, 04 Dec 2013 14:02:46 -0800


The patch titled
     Subject: drivers/rtc/rtc-ds1742.c: add devicetree support
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-ds1742c-add-devicetree-support.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-ds1742c-add-devicetree-support.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-ds1742c-add-devicetree-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Shiyan <shc_work@mail.ru>
Subject: drivers/rtc/rtc-ds1742.c: add devicetree support

This patch allows the driver to be enabled with devicetree.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/rtc/maxim,ds1742.txt |   12 ++++++++++
 drivers/rtc/rtc-ds1742.c                               |   10 +++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff -puN /dev/null Documentation/devicetree/bindings/rtc/maxim,ds1742.txt
--- /dev/null
+++ a/Documentation/devicetree/bindings/rtc/maxim,ds1742.txt
@@ -0,0 +1,12 @@
+* Maxim (Dallas) DS1742/DS1743 Real Time Clock
+
+Required properties:
+- compatible: Should contain "maxim,ds1742".
+- reg: Physical base address of the RTC and length of memory
+  mapped region.
+
+Example:
+	rtc: rtc@10000000 {
+		compatible = "maxim,ds1742";
+		reg = <0x10000000 0x800>;
+	};
diff -puN drivers/rtc/rtc-ds1742.c~drivers-rtc-rtc-ds1742c-add-devicetree-support drivers/rtc/rtc-ds1742.c
--- a/drivers/rtc/rtc-ds1742.c~drivers-rtc-rtc-ds1742c-add-devicetree-support
+++ a/drivers/rtc/rtc-ds1742.c
@@ -13,12 +13,13 @@
  */
 
 #include <linux/bcd.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/gfp.h>
 #include <linux/delay.h>
 #include <linux/jiffies.h>
 #include <linux/rtc.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/module.h>
@@ -215,12 +216,19 @@ static int ds1742_rtc_remove(struct plat
 	return 0;
 }
 
+static struct of_device_id __maybe_unused ds1742_rtc_of_match[] = {
+	{ .compatible = "maxim,ds1742", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, ds1742_rtc_of_match);
+
 static struct platform_driver ds1742_rtc_driver = {
 	.probe		= ds1742_rtc_probe,
 	.remove		= ds1742_rtc_remove,
 	.driver		= {
 		.name	= "rtc-ds1742",
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(ds1742_rtc_of_match),
 	},
 };
 
_

Patches currently in -mm which might be from shc_work@mail.ru are

drivers-rtc-rtc-ds1742c-add-devicetree-support.patch
linux-next.patch

