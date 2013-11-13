From: akpm@linux-foundation.org
Subject: [merged]
 backlight-ld9040-staticize-local-variable-gamma_table.patch removed from
 -mm tree
Date: Wed, 13 Nov 2013 12:40:38 -0800
Message-ID: <5283e3c6.WDQAnWHdRIbcfNs7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42944 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab3KMUki (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:40:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] backlight-ld9040-staticize-local-variable-gamma_table.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:40:38 -0800


The patch titled
     Subject: backlight: ld9040: Staticize local variable gamma_table
has been removed from the -mm tree.  Its filename was
     backlight-ld9040-staticize-local-variable-gamma_table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: ld9040: Staticize local variable gamma_table

Fix the following sparse warnings:

drivers/video/backlight/ld9040_gamma.h:172:3: warning: symbol 'gamma_table' was not declared. Should it be static?

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ld9040_gamma.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/video/backlight/ld9040_gamma.h~backlight-ld9040-staticize-local-variable-gamma_table drivers/video/backlight/ld9040_gamma.h
--- a/drivers/video/backlight/ld9040_gamma.h~backlight-ld9040-staticize-local-variable-gamma_table
+++ a/drivers/video/backlight/ld9040_gamma.h
@@ -169,7 +169,9 @@ static const unsigned int ld9040_22_50[]
 
 struct ld9040_gamma {
 	unsigned int *gamma_22_table[MAX_GAMMA_LEVEL];
-} gamma_table = {
+};
+
+static struct ld9040_gamma gamma_table = {
 	.gamma_22_table[0] = (unsigned int *)&ld9040_22_50,
 	.gamma_22_table[1] = (unsigned int *)&ld9040_22_70,
 	.gamma_22_table[2] = (unsigned int *)&ld9040_22_80,
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
drivers-block-sx8c-use-module_pci_driver.patch
drivers-block-sx8c-remove-unnecessary-pci_set_drvdata.patch
linux-next.patch
drivers-rtc-rtc-hid-sensor-timec-use-dev_get_platdata.patch
w1-w1-gpio-use-dev_get_platdata.patch

