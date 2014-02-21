From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-rtc-ds1307c-fix-sysfs-wakealarm-attribute-creation.patch added
 to -mm tree
Date: Fri, 21 Feb 2014 11:59:56 -0800
Message-ID: <5307b03c.aAyaXQL9i2mtKqU/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57948 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaBUT75 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Feb 2014 14:59:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sebastian.hesselbarth@gmail.com, jason@lakedaemon.net, gregory.clement@free-electrons.com, andrew@lunn.ch, simon.guinot@sequanux.org

Subject: + drivers-rtc-rtc-ds1307c-fix-sysfs-wakealarm-attribute-creation.patch added to -mm tree
To: simon.guinot@sequanux.org,andrew@lunn.ch,gregory.clement@free-electrons.com,jason@lakedaemon.net,sebastian.hesselbarth@gmail.com
From: akpm@linux-foundation.org
Date: Fri, 21 Feb 2014 11:59:56 -0800


The patch titled
     Subject: drivers/rtc/rtc-ds1307.c: fix sysfs wakealarm attribute creation
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-ds1307c-fix-sysfs-wakealarm-attribute-creation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-ds1307c-fix-sysfs-wakealarm-attribute-creation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-ds1307c-fix-sysfs-wakealarm-attribute-creation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Simon Guinot <simon.guinot@sequanux.org>
Subject: drivers/rtc/rtc-ds1307.c: fix sysfs wakealarm attribute creation

In order to allow the creation of the sysfs attribute wakealarm, this
patch moves the device_set_wakeup_capable() call above the RTC device
registration.

Signed-off-by: Simon Guinot <simon.guinot@sequanux.org>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1307.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-ds1307.c~drivers-rtc-rtc-ds1307c-fix-sysfs-wakealarm-attribute-creation drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~drivers-rtc-rtc-ds1307c-fix-sysfs-wakealarm-attribute-creation
+++ a/drivers/rtc/rtc-ds1307.c
@@ -927,6 +927,7 @@ read_rtc:
 				bin2bcd(tmp));
 	}
 
+	device_set_wakeup_capable(&client->dev, want_irq);
 	ds1307->rtc = devm_rtc_device_register(&client->dev, client->name,
 				&ds13xx_rtc_ops, THIS_MODULE);
 	if (IS_ERR(ds1307->rtc)) {
@@ -945,7 +946,6 @@ read_rtc:
 			goto exit;
 		}
 
-		device_set_wakeup_capable(&client->dev, 1);
 		set_bit(HAS_ALARM, &ds1307->flags);
 		dev_dbg(&client->dev, "got IRQ %d\n", client->irq);
 	}
_

Patches currently in -mm which might be from simon.guinot@sequanux.org are

drivers-rtc-rtc-ds1307c-fix-sysfs-wakealarm-attribute-creation.patch
drivers-rtc-rtc-sirfsocc-add-alarm-support-for-mcp7941x-chips.patch

