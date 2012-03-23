From: akpm@linux-foundation.org
Subject: [folded] rtc-ds1307-generalise-ram-size-and-offset-fix.patch removed from -mm tree
Date: Fri, 23 Mar 2012 14:30:36 -0700
Message-ID: <20120323213037.14F6FA02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:38060 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052Ab2CWVaj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 17:30:39 -0400
Received: by eaaq10 with SMTP id q10so188432eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 14:30:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@xenotime.net, Austin.Boyle@aviatnet.com, a.zummo@towertech.it, danders.dev@gmail.com, w.sang@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: fix rtc-ds1307 printk format warning
has been removed from the -mm tree.  Its filename was
     rtc-ds1307-generalise-ram-size-and-offset-fix.patch

This patch was dropped because it was folded into rtc-ds1307-generalise-ram-size-and-offset.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Randy Dunlap <rdunlap@xenotime.net>
Subject: rtc: fix rtc-ds1307 printk format warning

fix printk format warning

drivers/rtc/rtc-ds1307.c:915:3: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Austin Boyle <Austin.Boyle@aviatnet.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: David Anders <danders.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1307.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-ds1307.c~rtc-ds1307-generalise-ram-size-and-offset-fix drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~rtc-ds1307-generalise-ram-size-and-offset-fix
+++ a/drivers/rtc/rtc-ds1307.c
@@ -912,7 +912,7 @@ read_rtc:
 			goto exit_nvram;
 		}
 		set_bit(HAS_NVRAM, &ds1307->flags);
-		dev_info(&client->dev, "%d bytes nvram\n", ds1307->nvram->size);
+		dev_info(&client->dev, "%zu bytes nvram\n", ds1307->nvram->size);
 	}
 
 	return 0;
_

Patches currently in -mm which might be from rdunlap@xenotime.net are

origin.patch
remove-remaining-bits-of-io_remap_page_range.patch
backlight-fix-ot200_bl-build.patch
crc32-bolt-on-crc32c.patch
rtc-ds1307-generalise-ram-size-and-offset.patch

