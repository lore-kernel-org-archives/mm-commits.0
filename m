From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-ds1307c-change-sysfs-function-pointer-assignment.patch added to -mm tree
Date: Wed, 27 Mar 2013 15:57:27 -0700
Message-ID: <20130327225727.7141A31C088@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:46030 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058Ab3C0W53 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Mar 2013 18:57:29 -0400
Received: by mail-qc0-f201.google.com with SMTP id o22so886387qcr.0
        for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2013 15:57:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: s.trumtrar@pengutronix.de, Austin.Boyle@aviatnet.com


The patch titled
     Subject: drivers/rtc/rtc-ds1307.c: change sysfs function pointer assignment
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-ds1307c-change-sysfs-function-pointer-assignment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -908,8 +908,8 @@ read_rtc:
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

linux-next.patch
drivers-rtc-rtc-ds1307c-change-sysfs-function-pointer-assignment.patch

