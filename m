From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-rtc-ds1307c-enable-the-mcp794xx-alarm-after-programming-time.patch added to -mm tree
Date: Tue, 21 Apr 2015 15:25:34 -0700
Message-ID: <5536ce5e.VItekvPkO8X9bNRO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34323 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137AbbDUWZf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Apr 2015 18:25:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nm@ti.com, a.zummo@towertech.it, alexandre.belloni@free-electrons.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-ds1307.c: enable the mcp794xx alarm after programming time
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-ds1307c-enable-the-mcp794xx-alarm-after-programming-time.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-ds1307c-enable-the-mcp794xx-alarm-after-programming-time.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-ds1307c-enable-the-mcp794xx-alarm-after-programming-time.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nishanth Menon <nm@ti.com>
Subject: drivers/rtc/rtc-ds1307.c: enable the mcp794xx alarm after programming time

Alarm interrupt enable register is at offset 0x7, while the time registers
for the alarm follow that.  When we program Alarm interrupt enable prior
to programming the time, it is possible that previous time value could be
close or match at the time of alarm enable resulting in interrupt trigger
which is unexpected (and does not match the time we expect it to trigger).

To prevent this scenario from occuring, program the ALM0_EN bit only after
the alarm time is appropriately programmed.

Ofcourse, I2C programming is non-atomic, so there are loopholes where the
interrupt wont trigger if the time requested is in the past at the time of
programming the ALM0_EN bit.  However, we will not have unexpected
interrupts while the time is programmed after the interrupt are enabled.

Signed-off-by: Nishanth Menon <nm@ti.com>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1307.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/rtc/rtc-ds1307.c~drivers-rtc-rtc-ds1307c-enable-the-mcp794xx-alarm-after-programming-time drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~drivers-rtc-rtc-ds1307c-enable-the-mcp794xx-alarm-after-programming-time
+++ a/drivers/rtc/rtc-ds1307.c
@@ -742,17 +742,17 @@ static int mcp794xx_set_alarm(struct dev
 	regs[6] &= ~MCP794XX_BIT_ALMX_IF;
 	/* Set alarm match: second, minute, hour, day, date, month. */
 	regs[6] |= MCP794XX_MSK_ALMX_MATCH;
-
-	if (t->enabled)
-		regs[0] |= MCP794XX_BIT_ALM0_EN;
-	else
-		regs[0] &= ~MCP794XX_BIT_ALM0_EN;
+	/* Disable interrupt. We will not enable until completely programmed */
+	regs[0] &= ~MCP794XX_BIT_ALM0_EN;
 
 	ret = ds1307->write_block_data(client, MCP794XX_REG_CONTROL, 10, regs);
 	if (ret < 0)
 		return ret;
 
-	return 0;
+	if (!t->enabled)
+		return 0;
+	regs[0] |= MCP794XX_BIT_ALM0_EN;
+	return i2c_smbus_write_byte_data(client, MCP794XX_REG_CONTROL, regs[0]);
 }
 
 static int mcp794xx_alarm_irq_enable(struct device *dev, unsigned int enabled)
_

Patches currently in -mm which might be from nm@ti.com are

origin.patch
drivers-rtc-rtc-ds1307c-enable-the-mcp794xx-alarm-after-programming-time.patch
linux-next.patch

