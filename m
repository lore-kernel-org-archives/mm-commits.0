From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-ds1307c-change-sysfs-function-pointer-assignment.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:59:03 -0700
Message-ID: <20130430185903.7749E31C27C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:39663 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933315Ab3D3S7F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:59:05 -0400
Received: by mail-qe0-f73.google.com with SMTP id 9so87134qea.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:59:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: s.trumtrar@pengutronix.de, Austin.Boyle@aviatnet.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-ds1307.c: change sysfs function pointer assignment
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-ds1307c-change-sysfs-function-pointer-assignment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: drivers/rtc/rtc-ds1307.c: change sysfs function pointer assignment

The current usage of commas instead of semicolons is not wrong, but
affects the readability of the code.

Also, the code would break, if someone puts something between those two
assignments.

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: Austin Boyle <Austin.Boyle@aviatnet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1307.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-ds1307.c~drivers-rtc-rtc-ds1307c-change-sysfs-function-pointer-assignment drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~drivers-rtc-rtc-ds1307c-change-sysfs-function-pointer-assignment
+++ a/drivers/rtc/rtc-ds1307.c
@@ -960,8 +960,8 @@ read_rtc:
 		ds1307->nvram->attr.name = "nvram";
 		ds1307->nvram->attr.mode = S_IRUGO | S_IWUSR;
 		sysfs_bin_attr_init(ds1307->nvram);
-		ds1307->nvram->read = ds1307_nvram_read,
-		ds1307->nvram->write = ds1307_nvram_write,
+		ds1307->nvram->read = ds1307_nvram_read;
+		ds1307->nvram->write = ds1307_nvram_write;
 		ds1307->nvram->size = chip->nvram_size;
 		ds1307->nvram_offset = chip->nvram_offset;
 		err = sysfs_create_bin_file(&client->dev.kobj, ds1307->nvram);
_

Patches currently in -mm which might be from s.trumtrar@pengutronix.de are

origin.patch
linux-next.patch

