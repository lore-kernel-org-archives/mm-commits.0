From: akpm@linux-foundation.org
Subject: + rtc-ds1307-generalise-ram-size-and-offset-fix.patch added to -mm tree
Date: Mon, 27 Feb 2012 16:08:58 -0800
Message-ID: <20120228000858.BFC1FA0128@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:61331 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085Ab2B1AJB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2012 19:09:01 -0500
Received: by bkty7 with SMTP id y7so79905bkt.1
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2012 16:08:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdunlap@xenotime.net, Austin.Boyle@aviatnet.com, a.zummo@towertech.it, danders.dev@gmail.com, w.sang@pengutronix.de


The patch titled
     Subject: rtc: fix rtc-ds1307 printk format warning
has been added to the -mm tree.  Its filename is
     rtc-ds1307-generalise-ram-size-and-offset-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: rtc: fix rtc-ds1307 printk format warning

Patches currently in -mm which might be from rdunlap@xenotime.net are

origin.patch
linux-next.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
crc32-bolt-on-crc32c-dont-reference-unnecessary-crc32-tables-in-single-bit-mode.patch
rtc-ds1307-generalise-ram-size-and-offset-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
ramoops-use-pstore-interface.patch
ramoops-use-pstore-interface-fix.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

