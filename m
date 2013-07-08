From: akpm@linux-foundation.org
Subject: [merged]
 drivers-rtc-rtc-pcf2123c-replace-strict_strtoul-with-kstrtoul.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:35:14 -0700
Message-ID: <51db1472.CjCuoWeCtXjdaM6F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51476 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab3GHTfp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:35:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, andriy.shevchenko@linux.intel.com, jg1.han@samsung.com

Subject: [merged] drivers-rtc-rtc-pcf2123c-replace-strict_strtoul-with-kstrtoul.patch removed from -mm tree
To: jg1.han@samsung.com,andriy.shevchenko@linux.intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:35:14 -0700


The patch titled
     Subject: drivers/rtc/rtc-pcf2123.c: replace strict_strtoul() with kstrtoul()
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-pcf2123c-replace-strict_strtoul-with-kstrtoul.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/rtc/rtc-pcf2123.c: replace strict_strtoul() with kstrtoul()

The usage of strict_strtoul() is not preferred, because strict_strtoul()
is obsolete.  Thus, kstrtoul() should be used.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf2123.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-pcf2123.c~drivers-rtc-rtc-pcf2123c-replace-strict_strtoul-with-kstrtoul drivers/rtc/rtc-pcf2123.c
--- a/drivers/rtc/rtc-pcf2123.c~drivers-rtc-rtc-pcf2123c-replace-strict_strtoul-with-kstrtoul
+++ a/drivers/rtc/rtc-pcf2123.c
@@ -94,8 +94,9 @@ static ssize_t pcf2123_show(struct devic
 
 	r = container_of(attr, struct pcf2123_sysfs_reg, attr);
 
-	if (strict_strtoul(r->name, 16, &reg))
-		return -EINVAL;
+	ret = kstrtoul(r->name, 16, &reg);
+	if (ret)
+		return ret;
 
 	txbuf[0] = PCF2123_READ | reg;
 	ret = spi_write_then_read(spi, txbuf, 1, rxbuf, 1);
@@ -117,9 +118,13 @@ static ssize_t pcf2123_store(struct devi
 
 	r = container_of(attr, struct pcf2123_sysfs_reg, attr);
 
-	if (strict_strtoul(r->name, 16, &reg)
-		|| strict_strtoul(buffer, 10, &val))
-		return -EINVAL;
+	ret = kstrtoul(r->name, 16, &reg);
+	if (ret)
+		return ret;
+
+	ret = kstrtoul(buffer, 10, &val);
+	if (ret)
+		return ret;
 
 	txbuf[0] = PCF2123_WRITE | reg;
 	txbuf[1] = val;
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch

