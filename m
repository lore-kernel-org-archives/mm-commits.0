From: akpm@linux-foundation.org
Subject: + fbcon-fix-workqueue-shutdown-update.patch added to -mm tree
Date: Mon, 08 Dec 2008 16:31:09 -0800
Message-ID: <200812090031.mB90V9kQ014678@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33489 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753779AbYLIAbf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Dec 2008 19:31:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geoffrey.levand@am.sony.com, geert@linux-m68k.org, krzysztof.h1@poczta.fm


The patch titled
     fbcon: fix workqueue shutdown
has been added to the -mm tree.  Its filename is
     fbcon-fix-workqueue-shutdown-update.patch

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

fbcon-fix-workqueue-shutdown-update.patch
linux-next.patch

