From: akpm@linux-foundation.org
Subject: + drivers-media-video-pmsc-needs-linux-slabh.patch added to -mm tree
Date: Thu, 21 Jun 2012 14:32:23 -0700
Message-ID: <20120621213223.57CDCA0329@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:63177 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932742Ab2FUVcY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jun 2012 17:32:24 -0400
Received: by qcsp5 with SMTP id p5so123475qcs.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Jun 2012 14:32:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdunlap@xenotime.net, hans.verkuil@cisco.com, hverkuil@xs4all.nl, mchehab@infradead.org


The patch titled
     Subject: drivers/media/video/pms.c needs linux/slab.h
has been added to the -mm tree.  Its filename is
     drivers-media-video-pmsc-needs-linux-slabh.patch

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
Subject: Subject: drivers/media/video/pms.c needs linux/slab.h

Patches currently in -mm which might be from rdunlap@xenotime.net are

origin.patch
linux-next.patch
drivers-media-video-pmsc-needs-linux-slabh.patch
lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

