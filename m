From: akpm@linux-foundation.org
Subject: + video-mmp-fb-support-fix.patch added to -mm tree
Date: Fri, 15 Feb 2013 14:40:45 -0800
Message-ID: <20130215224045.C505431C27F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:34517 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab3BOWkr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Feb 2013 17:40:47 -0500
Received: by mail-ye0-f202.google.com with SMTP id r9so400332yen.3
        for <mm-commits@vger.kernel.org>; Fri, 15 Feb 2013 14:40:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arnd@arndb.de, FlorianSchandinat@gmx.de, cldu@marvell.com, greg@kroah.com, haojian.zhuang@gmail.com, ligq@marvell.com, zzhu3@marvell.com


The patch titled
     Subject: fb: mmp: include linux/platform_device.h
has been added to the -mm tree.  Its filename is
     video-mmp-fb-support-fix.patch

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
Subject: fb: mmp: include linux/platform_device.h

Patch 16559ae "kgdb: remove #include <linux/serial_8250.h> from kgdb.h"
changes the kgdb.h file so that drivers including it do not implicitly
include linux/platform_device.h. The mmp framebuffer driver is new,
so Greg did not have a chance to fix it up when introducing his change.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Zhou Zhu <zzhu3@marvell.com>
Cc: Lisa Du <cldu@marvell.com>
Cc: Guoqing Li <ligq@marvell.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/mmp/fb/mmpfb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/mmp/fb/mmpfb.c~video-mmp-fb-support-fix drivers/video/mmp/fb/mmpfb.c
--- a/drivers/video/mmp/fb/mmpfb.c~video-mmp-fb-support-fix
+++ a/drivers/video/mmp/fb/mmpfb.c
@@ -21,6 +21,7 @@
  */
 #include <linux/module.h>
 #include <linux/dma-mapping.h>
+#include <linux/platform_device.h>
 #include "mmpfb.h"
 
 static int var_to_pixfmt(struct fb_var_screeninfo *var)
_

Patches currently in -mm which might be from arnd@arndb.de are

linux-next.patch
video-mmp-fb-support-fix.patch
swap-add-per-partition-lock-for-swapfile-fix-for-nommu.patch
misc-c2port-convert-to-idr_alloc.patch
misc-tifm_core-convert-to-idr_alloc.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch

