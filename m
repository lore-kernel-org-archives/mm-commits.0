From: akpm@linux-foundation.org
Subject: - mx3fb-initialize-mm_lock-in-init_fb_chan.patch removed from -mm tree
Date: Mon, 13 Jul 2009 14:05:04 -0700
Message-ID: <200907132105.n6DL55ns003721@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39853 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756643AbZGMVH3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Jul 2009 17:07:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel@caiaq.de, a.p.zijlstra@chello.nl, krzysztof.h1@wp.pl, rjw@sisk.pl, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mx3fb: initialize mm_lock in init_fb_chan()
has been removed from the -mm tree.  Its filename was
     mx3fb-initialize-mm_lock-in-init_fb_chan.patch

This patch was dropped because of confusion

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mx3fb: initialize mm_lock in init_fb_chan()
From: Daniel Mack <daniel@caiaq.de>

In 537a1bf05 ("fbdev: add mutex for fb_mmap locking"), a per-fbinfo mutex
was added and framebuffer drivers were adopted accordingly.  This new lock
is currently initialized in register_framebuffer().

The mx3fb driver takes this lock in mx3fb_map_video_memory() _before_
register_framebuffer() is called and hence crashes the system very early.

To fix this, initialize this lock init_fb_chan() in the mx3fb driver.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/mx3fb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/mx3fb.c~mx3fb-initialize-mm_lock-in-init_fb_chan drivers/video/mx3fb.c
--- a/drivers/video/mx3fb.c~mx3fb-initialize-mm_lock-in-init_fb_chan
+++ a/drivers/video/mx3fb.c
@@ -1362,6 +1362,7 @@ static int init_fb_chan(struct mx3fb_dat
 	mx3fbi->mx3fb		= mx3fb;
 	mx3fbi->blank		= FB_BLANK_NORMAL;
 
+	mutex_init(&fbi->mm_lock);
 	init_completion(&mx3fbi->flip_cmpl);
 	disable_irq(ichan->eof_irq);
 	dev_dbg(mx3fb->dev, "disabling irq %d\n", ichan->eof_irq);
_

Patches currently in -mm which might be from daniel@caiaq.de are

origin.patch
mx3fb-initialize-mm_lock-in-init_fb_chan.patch
linux-next.patch
lis3-fix-typo.patch
lis3-add-free-fall-wakeup-function-via-platform_data.patch
lis3-add-power-management-functions.patch
lis3-add-power-management-functions-fix.patch
lis3_spi-code-cleanups.patch
rtc-add-driver-for-mxcs-internal-rtc-module.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix.patch

