From: akpm@linux-foundation.org
Subject: +
 platform-x86-alienware-wmi-fix-format-string-overflow-warning.patch added
 to -mm tree
Date: Wed, 19 Jul 2017 14:50:32 -0700
Message-ID: <596fd428.BeAyucTbN7AWK9JA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34138 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755113AbdGSVud (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jul 2017 17:50:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: platform/x86: alienware-wmi: fix format string overflow warning
has been added to the -mm tree.  Its filename is
     platform-x86-alienware-wmi-fix-format-string-overflow-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/platform-x86-alienware-wmi-fix-format-string-overflow-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/platform-x86-alienware-wmi-fix-format-string-overflow-warning.patch

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
Subject: platform/x86: alienware-wmi: fix format string overflow warning

gcc points out a possible format string overflow for a large value of 'zone':

drivers/platform/x86/alienware-wmi.c: In function 'alienware_wmi_init':
drivers/platform/x86/alienware-wmi.c:461:24: error: '%02X' directive writing between 2 and 8 bytes into a region of size 6 [-Werror=format-overflow=]
   sprintf(buffer, "zone%02X", i);
                        ^~~~
drivers/platform/x86/alienware-wmi.c:461:19: note: directive argument in the range [0, 2147483646]
   sprintf(buffer, "zone%02X", i);
                   ^~~~~~~~~~
drivers/platform/x86/alienware-wmi.c:461:3: note: 'sprintf' output between 7 and 13 bytes into a destination of size 10

While the zone should never be that large, it's easy to make the
buffer a few bytes longer so gcc can prove this to be safe.

Link: http://lkml.kernel.org/r/20170714120720.906842-18-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/alienware-wmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/platform/x86/alienware-wmi.c~platform-x86-alienware-wmi-fix-format-string-overflow-warning drivers/platform/x86/alienware-wmi.c
--- a/drivers/platform/x86/alienware-wmi.c~platform-x86-alienware-wmi-fix-format-string-overflow-warning
+++ a/drivers/platform/x86/alienware-wmi.c
@@ -421,7 +421,7 @@ static DEVICE_ATTR(lighting_control_stat
 static int alienware_zone_init(struct platform_device *dev)
 {
 	int i;
-	char buffer[10];
+	char buffer[13];
 	char *name;
 
 	if (interface == WMAX) {
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

