From: akpm@linux-foundation.org
Subject: - ivtv-dont-recompile-needlessly.patch removed from -mm tree
Date: Wed, 18 Jul 2007 11:52:09 -0700
Message-ID: <200707181852.l6IIq9FQ023642@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53035 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759495AbXGRSxY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 14:53:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, hverkuil@xs4all.nl, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     ivtv: don't recompile needlessly
has been removed from the -mm tree.  Its filename was
     ivtv-dont-recompile-needlessly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ivtv: don't recompile needlessly
From: Alexey Dobriyan <adobriyan@sw.ru>

Driver prints 3l33t banner including kernel version.  Could we _please_
never do this in future.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/ivtv/ivtv-driver.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/media/video/ivtv/ivtv-driver.c~ivtv-dont-recompile-needlessly drivers/media/video/ivtv/ivtv-driver.c
--- a/drivers/media/video/ivtv/ivtv-driver.c~ivtv-dont-recompile-needlessly
+++ a/drivers/media/video/ivtv/ivtv-driver.c
@@ -56,7 +56,6 @@
 #include "ivtv-gpio.h"
 #include "ivtv-yuv.h"
 
-#include <linux/vermagic.h>
 #include <media/tveeprom.h>
 #include <media/v4l2-chip-ident.h>
 
@@ -1314,7 +1313,7 @@ static struct pci_driver ivtv_pci_driver
 static int module_start(void)
 {
 	printk(KERN_INFO "ivtv:  ==================== START INIT IVTV ====================\n");
-	printk(KERN_INFO "ivtv:  version %s (" VERMAGIC_STRING ") loading\n", IVTV_VERSION);
+	printk(KERN_INFO "ivtv:  version %s loading\n", IVTV_VERSION);
 
 	memset(ivtv_cards, 0, sizeof(ivtv_cards));
 
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
git-dvb.patch
use-list_head-in-binfmt-handling.patch
make-unregister_binfmt-return-void.patch
fix-leaks-on-proc-schedsched_debugtimer_listtimer_stats.patch
fix-leak-on-proc-lockdep_stats.patch
