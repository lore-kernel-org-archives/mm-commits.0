From: akpm@linux-foundation.org
Subject: + ivtv-dont-recompile-needlessly.patch added to -mm tree
Date: Tue, 17 Jul 2007 18:00:00 -0700
Message-ID: <200707180100.l6I1001T016639@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40089 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760894AbXGRBAN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 21:00:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru, hverkuil@xs4all.nl, mchehab@infradead.org


The patch titled
     ivtv: don't recompile needlessly
has been added to the -mm tree.  Its filename is
     ivtv-dont-recompile-needlessly.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
ivtv-dont-recompile-needlessly.patch
use-list_head-in-binfmt-handling.patch
make-unregister_binfmt-return-void.patch
fix-leaks-on-proc-schedsched_debugtimer_listtimer_stats.patch
fix-leak-on-proc-lockdep_stats.patch
