From: akpm@linux-foundation.org
Subject: + fbcon-fix-lockdep-warning-from-fbcon_deinit.patch added to -mm tree
Date: Mon, 13 Sep 2010 15:48:55 -0700
Message-ID: <201009132248.o8DMmt10025741@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51753 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751495Ab0IMWs4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Sep 2010 18:48:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jarkao2@gmail.com


The patch titled
     fbcon: fix lockdep warning from fbcon_deinit()
has been added to the -mm tree.  Its filename is
     fbcon-fix-lockdep-warning-from-fbcon_deinit.patch

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
Subject: fbcon: fix lockdep warning from fbcon_deinit()
From: Jarek Poplawski <jarkao2@gmail.com>

Fix the lockdep warning:

[   13.657164] INFO: trying to register non-static key.
[   13.657169] the code is fine but needs lockdep annotation.
[   13.657171] turning off the locking correctness validator.
[   13.657177] Pid: 622, comm: modprobe Not tainted 2.6.36-rc3c #8
[   13.657180] Call Trace:
[   13.657194]  [<c13002c8>] ? printk+0x18/0x20
[   13.657202]  [<c1056cf6>] register_lock_class+0x336/0x350
[   13.657208]  [<c1058bf9>] __lock_acquire+0x449/0x1180
[   13.657215]  [<c1059997>] lock_acquire+0x67/0x80
[   13.657222]  [<c1042bf1>] ? __cancel_work_timer+0x51/0x230
[   13.657227]  [<c1042c23>] __cancel_work_timer+0x83/0x230
[   13.657231]  [<c1042bf1>] ? __cancel_work_timer+0x51/0x230
[   13.657236]  [<c10582b2>] ? mark_held_locks+0x62/0x80
[   13.657243]  [<c10b3a2f>] ? kfree+0x7f/0xe0
[   13.657248]  [<c105853c>] ? trace_hardirqs_on_caller+0x11c/0x160
[   13.657253]  [<c105858b>] ? trace_hardirqs_on+0xb/0x10
[   13.657259]  [<c117f4cd>] ? fbcon_deinit+0x16d/0x1e0
[   13.657263]  [<c117f4cd>] ? fbcon_deinit+0x16d/0x1e0
[   13.657268]  [<c1042dea>] cancel_work_sync+0xa/0x10
[   13.657272]  [<c117f444>] fbcon_deinit+0xe4/0x1e0
...

The warning is caused by trying to cancel an uninitialized work from
fbcon_exit().  Fix it by adding a check for queue.func, similarly to other
places in this code.

Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/video/console/fbcon.c~fbcon-fix-lockdep-warning-from-fbcon_deinit drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbcon-fix-lockdep-warning-from-fbcon_deinit
+++ a/drivers/video/console/fbcon.c
@@ -3508,7 +3508,7 @@ static void fbcon_exit(void)
 	softback_buf = 0UL;
 
 	for (i = 0; i < FB_MAX; i++) {
-		int pending;
+		int pending = 0;
 
 		mapped = 0;
 		info = registered_fb[i];
@@ -3516,7 +3516,8 @@ static void fbcon_exit(void)
 		if (info == NULL)
 			continue;
 
-		pending = cancel_work_sync(&info->queue);
+		if (info->queue.func)
+			pending = cancel_work_sync(&info->queue);
 		DPRINTK("fbcon: %s pending work\n", (pending ? "canceled" :
 			"no"));
 
_

Patches currently in -mm which might be from jarkao2@gmail.com are

fbcon-fix-lockdep-warning-from-fbcon_deinit.patch

