From: akpm@linux-foundation.org
Subject: [merged] drivers-media-video-pmsc-needs-linux-slabh.patch removed from -mm tree
Date: Mon, 25 Jun 2012 14:06:06 -0700
Message-ID: <20120625210608.908C8A02C5@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:49631 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756682Ab2FYVGK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jun 2012 17:06:10 -0400
Received: by yenl3 with SMTP id l3so509640yen.1
        for <mm-commits@vger.kernel.org>; Mon, 25 Jun 2012 14:06:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@xenotime.net, hans.verkuil@cisco.com, hverkuil@xs4all.nl, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/media/video/pms.c needs linux/slab.h
has been removed from the -mm tree.  Its filename was
     drivers-media-video-pmsc-needs-linux-slabh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Randy Dunlap <rdunlap@xenotime.net>
Subject: drivers/media/video/pms.c needs linux/slab.h

drivers/media/video/pms.c uses kzalloc() and kfree() so it should
include <linux/slab.h> to fix build errors and a warning.

drivers/media/video/pms.c:1047:2: error: implicit declaration of function 'kzalloc'
drivers/media/video/pms.c:1047:6: warning: assignment makes pointer from integer without a cast
drivers/media/video/pms.c:1116:2: error: implicit declaration of function 'kfree'

Found in mmotm but applies to mainline.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/pms.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/media/video/pms.c~drivers-media-video-pmsc-needs-linux-slabh drivers/media/video/pms.c
--- a/drivers/media/video/pms.c~drivers-media-video-pmsc-needs-linux-slabh
+++ a/drivers/media/video/pms.c
@@ -29,6 +29,7 @@
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 #include <linux/uaccess.h>
 #include <linux/isa.h>
 #include <asm/io.h>
_

Patches currently in -mm which might be from rdunlap@xenotime.net are

linux-next.patch
lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

