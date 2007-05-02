From: akpm@linux-foundation.org
Subject: + cx88-video-build-fix.patch added to -mm tree
Date: Wed, 02 May 2007 16:27:48 -0700
Message-ID: <200705022330.l42NUbID032742@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57887 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767243AbXEBXao (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 May 2007 19:30:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mchehab@infradead.org


The patch titled
     cx88-video build fix
has been added to the -mm tree.  Its filename is
     cx88-video-build-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cx88-video build fix
From: Andrew Morton <akpm@linux-foundation.org>

alpha:

drivers/media/video/cx88/cx88-video.c: In function 'cx8800_initdev':
drivers/media/video/cx88/cx88-video.c:1782: error: 'DMA_32BIT_MASK' undeclared (first use in this function)
drivers/media/video/cx88/cx88-video.c:1782: error: (Each undeclared identifier is reported only once
drivers/media/video/cx88/cx88-video.c:1782: error: for each function it appears in.)

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/cx88/cx88-alsa.c  |    2 ++
 drivers/media/video/cx88/cx88-mpeg.c  |    1 +
 drivers/media/video/cx88/cx88-video.c |    2 +-
 3 files changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/media/video/cx88/cx88-video.c~cx88-video-build-fix drivers/media/video/cx88/cx88-video.c
--- a/drivers/media/video/cx88/cx88-video.c~cx88-video-build-fix
+++ a/drivers/media/video/cx88/cx88-video.c
@@ -1,4 +1,3 @@
-
 /*
  *
  * device driver for Conexant 2388x based TV cards
@@ -34,6 +33,7 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
+#include <linux/dma-mapping.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
 #include <asm/div64.h>
diff -puN drivers/media/video/cx88/cx88-mpeg.c~cx88-video-build-fix drivers/media/video/cx88/cx88-mpeg.c
--- a/drivers/media/video/cx88/cx88-mpeg.c~cx88-video-build-fix
+++ a/drivers/media/video/cx88/cx88-mpeg.c
@@ -26,6 +26,7 @@
 #include <linux/moduleparam.h>
 #include <linux/init.h>
 #include <linux/device.h>
+#include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
 #include <asm/delay.h>
 
diff -puN drivers/media/video/cx88/cx88-alsa.c~cx88-video-build-fix drivers/media/video/cx88/cx88-alsa.c
--- a/drivers/media/video/cx88/cx88-alsa.c~cx88-video-build-fix
+++ a/drivers/media/video/cx88/cx88-alsa.c
@@ -27,6 +27,8 @@
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/interrupt.h>
+#include <linux/dma-mapping.h>
+
 #include <asm/delay.h>
 #include <sound/driver.h>
 #include <sound/core.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slab-introduce-krealloc.patch
rm9000-serial-driver.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
smaps-add-clear_refs-file-to-clear-reference.patch
slab-mark-set_up_list3s-__init.patch
slub-core.patch
mm-optimize-kill_bdev.patch
get_unmapped_area-handles-map_fixed-in-hugetlbfs-fix.patch
lazy-freeing-of-memory-through-madv_free.patch
srmcons-fix-kmallocgfp_kernel-inside-spinlock.patch
uml-driver-formatting-fixes-fix.patch
cx88-video-build-fix.patch
