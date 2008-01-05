From: akpm@linux-foundation.org
Subject: + make-sys_poll-wait-at-least-timeout-ms.patch added to -mm tree
Date: Fri, 04 Jan 2008 22:55:21 -0800
Message-ID: <200801050656.m056u7Mc032661@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35054 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752479AbYAEG4s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 5 Jan 2008 01:56:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fzu@wemgehoertderstaat.de, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     make sys_poll() wait at least timeout ms
has been added to the -mm tree.  Its filename is
     make-sys_poll-wait-at-least-timeout-ms.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

make-sys_poll-wait-at-least-timeout-ms.patch
