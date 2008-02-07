From: akpm@linux-foundation.org
Subject: - make-sys_poll-wait-at-least-timeout-ms.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:25:15 -0800
Message-ID: <200802070024.m170Ouvc006671@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36907 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935144AbYBGAp7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:45:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fzu@wemgehoertderstaat.de, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     make sys_poll() wait at least timeout ms
has been removed from the -mm tree.  Its filename was
     make-sys_poll-wait-at-least-timeout-ms.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: make sys_poll() wait at least timeout ms
From: Karsten Wiese <fzu@wemgehoertderstaat.de>

schedule_timeout(jiffies) waits for at least jiffies - 1.  Add 1 jiffie to
the timeout_jiffies calculated in sys_poll() to wait at least
timeout_msecs, like poll() manpage says.

Signed-off-by: Karsten Wiese <fzu@wemgehoertderstaat.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/select.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/select.c~make-sys_poll-wait-at-least-timeout-ms fs/select.c
--- a/fs/select.c~make-sys_poll-wait-at-least-timeout-ms
+++ a/fs/select.c
@@ -739,7 +739,7 @@ asmlinkage long sys_poll(struct pollfd _
 			timeout_jiffies = -1;
 		else
 #endif
-			timeout_jiffies = msecs_to_jiffies(timeout_msecs);
+			timeout_jiffies = msecs_to_jiffies(timeout_msecs) + 1;
 	} else {
 		/* Infinite (< 0) or no (0) timeout */
 		timeout_jiffies = timeout_msecs;
_

Patches currently in -mm which might be from fzu@wemgehoertderstaat.de are

origin.patch
