From: akpm@linux-foundation.org
Subject: - fbcon-fix-workqueue-shutdown-update.patch removed from -mm tree
Date: Wed, 10 Dec 2008 11:28:52 -0800
Message-ID: <200812101928.mBAJSqHO021435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42932 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755416AbYLJT33 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Dec 2008 14:29:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geoffrey.levand@am.sony.com, geert@linux-m68k.org, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     fbcon: fix workqueue shutdown
has been removed from the -mm tree.  Its filename was
     fbcon-fix-workqueue-shutdown-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbcon: fix workqueue shutdown
From: Geoff Levand <geoffrey.levand@am.sony.com>

Add a call to cancel_work_sync() in fbcon_exit() to cancel any pending
work in the fbcon workqueue.

The current implementation of fbcon_exit() sets the fbcon workqueue
function info->queue.func to NULL, but does not assure that there is no
work pending when it does so.  On occasion, depending on system timing,
there will still be pending work in the queue when fbcon_exit() is
called.  This results in a null pointer deference when run_workqueue()
tries to call the queue's work function.

Fixes errors on shutdown similar to these:

  Console: switching to colour dummy device 80x25
  Unable to handle kernel paging request for data at address 0x00000000

Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/video/console/fbcon.c~fbcon-fix-workqueue-shutdown-update drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbcon-fix-workqueue-shutdown-update
+++ a/drivers/video/console/fbcon.c
@@ -3531,12 +3531,18 @@ static void fbcon_exit(void)
 	softback_buf = 0UL;
 
 	for (i = 0; i < FB_MAX; i++) {
+		int pending;
+
 		mapped = 0;
 		info = registered_fb[i];
 
 		if (info == NULL)
 			continue;
 
+		pending = cancel_work_sync(&info->queue);
+		DPRINTK("fbcon: %s pending work\n", (pending ? "canceled" :
+			"no"));
+
 		for (j = first_fb_vc; j <= last_fb_vc; j++) {
 			if (con2fb_map[j] == i)
 				mapped = 1;
_

Patches currently in -mm which might be from geoffrey.levand@am.sony.com are

origin.patch
linux-next.patch

