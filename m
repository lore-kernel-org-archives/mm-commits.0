From: akpm@linux-foundation.org
Subject: + media-ak881x-needs-slabh.patch added to -mm tree
Date: Thu, 20 May 2010 14:12:47 -0700
Message-ID: <201005202112.o4KLClie005593@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48475 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757005Ab0ETVNd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 May 2010 17:13:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, g.liakhovetski@gmx.de, mchehab@infradead.org


The patch titled
     media: ak881x needs slab.h
has been added to the -mm tree.  Its filename is
     media-ak881x-needs-slabh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: media: ak881x needs slab.h
From: Randy Dunlap <randy.dunlap@oracle.com>

Add slab.h to fix ak881x build:

drivers/media/video/ak881x.c:265:error: implicit declaration of function 'kzalloc'
drivers/media/video/ak881x.c:265:warning: assignment makes pointer from integer without a cast
drivers/media/video/ak881x.c:283:error: implicit declaration of function 'kfree'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/ak881x.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/media/video/ak881x.c~media-ak881x-needs-slabh drivers/media/video/ak881x.c
--- a/drivers/media/video/ak881x.c~media-ak881x-needs-slabh
+++ a/drivers/media/video/ak881x.c
@@ -11,6 +11,7 @@
 #include <linux/i2c.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
+#include <linux/slab.h>
 #include <linux/videodev2.h>
 
 #include <media/ak881x.h>
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
dib3000mc-reduce-large-stack-usage-fix.patch
media-ak881x-needs-slabh.patch
led-driver-for-the-soekris-net5501-board.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
scsi-fix-pmcraid-build-errors.patch
scsi-fix-be2iscsi-build.patch
scsi-fix-bnx2i-build-errors.patch
virtio_9ph-include-linux-typesh.patch
mmcompaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
ad525x_dpot-add-support-for-spi-parts-fix-ad525x_dpot-build.patch
lib-hexdumpc-reduce-stack-variable-size-and-cleanups.patch
xen-fix-build-when-sysrq-is-disabled.patch
rtc-cmos-do-dev_set_drvdata-earlier-in-the-initialization.patch
documentation-submittingdrivers-resources.patch
memcg-move-charge-of-file-pages-fix-2.patch
memcg-update-documentation-v8.patch
aio-fix-the-compat-vectored-operations-fix.patch
numa-update-documentation-vm-numa-add-memoryless-node-info.patch
numa-update-documentation-vm-numa-add-memoryless-node-info-fix1.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch
backlight-fix-s6e63m0-kconfig.patch
backlight-fix-s6e63m0-device-attr-function-return-types.patch

