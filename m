From: akpm@linux-foundation.org
Subject: + hwmon-applesmc-fix-format-string-overflow.patch added to -mm
 tree
Date: Wed, 19 Jul 2017 14:50:28 -0700
Message-ID: <596fd424.4WaDaDp8+x5WN+SE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34130 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755102AbdGSVu3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jul 2017 17:50:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: hwmon: applesmc: fix format string overflow
has been added to the -mm tree.  Its filename is
     hwmon-applesmc-fix-format-string-overflow.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hwmon-applesmc-fix-format-string-overflow.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hwmon-applesmc-fix-format-string-overflow.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kbuild-disable-wformat-truncation-warnings-by-default.patch
scsi-megaraid-fix-format-overflow-warning.patch
scsi-mpt3sas-fix-format-overflow-warning.patch
scsi-fusion-fix-string-overflow-warning.patch
scsi-gdth-avoid-buffer-overflow-warning.patch
scsi-fnic-fix-format-string-overflow-warning.patch
scsi-gdth-increase-the-procfs-event-buffer-size.patch
usbvision-i2c-fix-format-overflow-warning.patch
hwmon-applesmc-fix-format-string-overflow.patch
x86-intel-mid-fix-a-format-string-overflow-warning.patch
platform-x86-alienware-wmi-fix-format-string-overflow-warning.patch
block-dac960-shut-up-format-overflow-warning.patch
fscache-fix-fscache_objlist_show-format-processing.patch
ib-mlx4-fix-sprintf-format-warning.patch

