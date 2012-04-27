From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-ds1307c-fix-bug-shown-with-lock-debugging-enabled.patch removed from -mm tree
Date: Fri, 27 Apr 2012 12:35:27 -0700
Message-ID: <20120427193527.B1538A02CD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:39420 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761022Ab2D0Tfa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Apr 2012 15:35:30 -0400
Received: by faaa25 with SMTP id a25so57350faa.1
        for <mm-commits@vger.kernel.org>; Fri, 27 Apr 2012 12:35:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agust@denx.de, a.zummo@towertech.it, ebiederm@xmission.com, gregkh@suse.de, sbabic@denx.de, w.sang@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-ds1307.c: fix BUG shown with lock debugging enabled
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-ds1307c-fix-bug-shown-with-lock-debugging-enabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Anatolij Gustschin <agust@denx.de>
Subject: drivers/rtc/rtc-ds1307.c: fix BUG shown with lock debugging enabled

Add struct bin_attribute initialization to fix the following bug:

rtc-ds1307 3-0068: rtc core: registered ds1307 as rtc0
BUG: key cfb14fcc not in .data!
------------[ cut here ]------------
WARNING: at kernel/lockdep.c:2986 sysfs_add_file_mode+0x84/0xdc()
Modules linked in:
[<c0018d94>] (unwind_backtrace+0x0/0xf8) from [<c0031f7c>] (warn_slowpath_common+0x4c/0x64)
[<c0031f7c>] (warn_slowpath_common+0x4c/0x64) from [<c0031fb0>] (warn_slowpath_null+0x1c/0x24)
[<c0031fb0>] (warn_slowpath_null+0x1c/0x24) from [<c012f7ac>] (sysfs_add_file_mode+0x84/0xdc)
[<c012f7ac>] (sysfs_add_file_mode+0x84/0xdc) from [<c04b11e4>] (ds1307_probe+0x5e4/0x6ac)
[<c04b11e4>] (ds1307_probe+0x5e4/0x6ac) from [<c036e600>] (i2c_device_probe+0xdc/0x108)
[<c036e600>] (i2c_device_probe+0xdc/0x108) from [<c02cdf84>] (driver_probe_device+0x90/0x210)
[<c02cdf84>] (driver_probe_device+0x90/0x210) from [<c02ce198>] (__driver_attach+0x94/0x98)
[<c02ce198>] (__driver_attach+0x94/0x98) from [<c02cc824>] (bus_for_each_dev+0x50/0x7c)
[<c02cc824>] (bus_for_each_dev+0x50/0x7c) from [<c02cd780>] (bus_add_driver+0x184/0x244)
[<c02cd780>] (bus_add_driver+0x184/0x244) from [<c02ce43c>] (driver_register+0x78/0x12c)
[<c02ce43c>] (driver_register+0x78/0x12c) from [<c03701ac>] (i2c_register_driver+0x2c/0xb4)
[<c03701ac>] (i2c_register_driver+0x2c/0xb4) from [<c0008798>] (do_one_initcall+0x34/0x178)
[<c0008798>] (do_one_initcall+0x34/0x178) from [<c0691860>] (kernel_init+0xdc/0x194)
[<c0691860>] (kernel_init+0xdc/0x194) from [<c0013cf0>] (kernel_thread_exit+0x0/0x8)

Since commit 6992f5334995af4 ("sysfs: Use one lockdep class per sysfs
attribute") this initialization is required.

Reported-by: Stefano Babic <sbabic@denx.de>
Tested-by: Stefano Babic <sbabic@denx.de>
Signed-off-by: Anatolij Gustschin <agust@denx.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Stefano Babic <sbabic@denx.de>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1307.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/rtc/rtc-ds1307.c~drivers-rtc-rtc-ds1307c-fix-bug-shown-with-lock-debugging-enabled drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~drivers-rtc-rtc-ds1307c-fix-bug-shown-with-lock-debugging-enabled
+++ a/drivers/rtc/rtc-ds1307.c
@@ -902,6 +902,7 @@ read_rtc:
 		}
 		ds1307->nvram->attr.name = "nvram";
 		ds1307->nvram->attr.mode = S_IRUGO | S_IWUSR;
+		sysfs_bin_attr_init(ds1307->nvram);
 		ds1307->nvram->read = ds1307_nvram_read,
 		ds1307->nvram->write = ds1307_nvram_write,
 		ds1307->nvram->size = chip->nvram_size;
_

Patches currently in -mm which might be from agust@denx.de are

origin.patch
linux-next.patch

