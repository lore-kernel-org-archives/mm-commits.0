From: akpm@linux-foundation.org
Subject: + i2c-sh_mobile-ioresource_clk-support.patch added to -mm tree
Date: Fri, 18 Jul 2008 15:37:23 -0700
Message-ID: <200807182237.m6IMbNpr002229@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54220 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753701AbYGRWiK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jul 2008 18:38:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: damm@igel.co.jp, ben-linux@fluff.org, khali@linux-fr.org, lethal@linux-sh.org


The patch titled
     i2c-sh_mobile: IORESOURCE_CLK support
has been added to the -mm tree.  Its filename is
     i2c-sh_mobile-ioresource_clk-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: i2c-sh_mobile: IORESOURCE_CLK support
From: Magnus Damm <damm@igel.co.jp>

Make the i2c-sh_mobile driver get the clock name from the struct resource
with type IORESOURCE_CLK provided by the platform data.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/i2c-sh_mobile.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/i2c/busses/i2c-sh_mobile.c~i2c-sh_mobile-ioresource_clk-support drivers/i2c/busses/i2c-sh_mobile.c
--- a/drivers/i2c/busses/i2c-sh_mobile.c~i2c-sh_mobile-ioresource_clk-support
+++ a/drivers/i2c/busses/i2c-sh_mobile.c
@@ -390,13 +390,19 @@ static int sh_mobile_i2c_probe(struct pl
 	int size;
 	int ret;
 
+	res = platform_get_resource(dev, IORESOURCE_CLK, 0);
+	if (res == NULL || res->name == NULL) {
+		dev_err(&dev->dev, "cannot find CLK resource\n");
+		return -ENOENT;
+	}
+
 	pd = kzalloc(sizeof(struct sh_mobile_i2c_data), GFP_KERNEL);
 	if (pd == NULL) {
 		dev_err(&dev->dev, "cannot allocate private data\n");
 		return -ENOMEM;
 	}
 
-	pd->clk = clk_get(&dev->dev, "peripheral_clk");
+	pd->clk = clk_get(&dev->dev, res->name);
 	if (IS_ERR(pd->clk)) {
 		dev_err(&dev->dev, "cannot get peripheral clock\n");
 		ret = PTR_ERR(pd->clk);
_

Patches currently in -mm which might be from damm@igel.co.jp are

linux-next.patch
sh_keysc-remove-request_mem_region-and-release_mem_region.patch
video-superh-mobile-lcdc-driver.patch
video-superh-mobile-lcdc-driver-update.patch
resource-add-resource_size.patch
resource-add-resource_type-and-ioresource_type_bits.patch
resource-add-new-ioresource_clk-type-v2.patch
i2c-sh_mobile-ioresource_clk-support.patch

