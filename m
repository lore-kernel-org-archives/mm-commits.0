From: akpm@linux-foundation.org
Subject: [alternative-merged]
 hwmon-applesmc-fix-format-string-overflow.patch removed from -mm tree
Date: Mon, 24 Jul 2017 13:37:55 -0700
Message-ID: <20170724203755.T9bCBny-3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40144 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754113AbdGXUh4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2017 16:37:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: hwmon: applesmc: fix format string overflow
has been removed from the -mm tree.  Its filename was
     hwmon-applesmc-fix-format-string-overflow.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: hwmon: applesmc: fix format string overflow

gcc-7 warns that the key might exceed five bytes for lage index
values:

drivers/hwmon/applesmc.c: In function 'applesmc_show_fan_position':
drivers/hwmon/applesmc.c:906:18: error: '%d' directive writing between 1 and 5 bytes into a region of size 4 [-Werror=format-overflow=]
sprintf(newkey, FAN_ID_FMT, to_index(attr));
                ^~~~~~~
drivers/hwmon/applesmc.c:906:18: note: directive argument in the range [0, 65535]
drivers/hwmon/applesmc.c:906:2: note: 'sprintf' output between 5 and 9 bytes into a destination of size 5

As the key is required to be four characters plus trailing zero,
we know that the index has to be small here. I'm using snprintf()
to avoid the warning. This would truncate the string instead of
overflowing.

Link: http://lkml.kernel.org/r/20170714120720.906842-16-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/applesmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/hwmon/applesmc.c~hwmon-applesmc-fix-format-string-overflow drivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~hwmon-applesmc-fix-format-string-overflow
+++ a/drivers/hwmon/applesmc.c
@@ -903,7 +903,7 @@ static ssize_t applesmc_show_fan_positio
 	char newkey[5];
 	u8 buffer[17];
 
-	sprintf(newkey, FAN_ID_FMT, to_index(attr));
+	snprintf(newkey, sizeof(newkey), FAN_ID_FMT, to_index(attr));
 
 	ret = applesmc_read_key(newkey, buffer, 16);
 	buffer[16] = 0;
_

Patches currently in -mm which might be from arnd@arndb.de are

kasan-avoid-wmaybe-uninitialized-warning.patch
scsi-megaraid-fix-format-overflow-warning.patch
scsi-mpt3sas-fix-format-overflow-warning.patch
scsi-fusion-fix-string-overflow-warning.patch
scsi-gdth-avoid-buffer-overflow-warning.patch
scsi-fnic-fix-format-string-overflow-warning.patch
scsi-gdth-increase-the-procfs-event-buffer-size.patch
block-dac960-shut-up-format-overflow-warning.patch
fscache-fix-fscache_objlist_show-format-processing.patch
ib-mlx4-fix-sprintf-format-warning.patch

