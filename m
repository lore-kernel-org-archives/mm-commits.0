From: akpm@linux-foundation.org
Subject: + jffs2-force-the-jffs2-gc-daemon-to-behave-a-bit-better.patch added to -mm tree
Date: Tue, 04 Nov 2008 19:49:21 -0800
Message-ID: <200811050349.mA53nL6X014064@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750890AbYKEDtc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2008 22:49:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, dilinger@debian.org, dwmw2@infradead.org


The patch titled
     jffs2: force the jffs2 GC daemon to behave a bit better
has been added to the -mm tree.  Its filename is
     jffs2-force-the-jffs2-gc-daemon-to-behave-a-bit-better.patch

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
Subject: jffs2: force the jffs2 GC daemon to behave a bit better
From: Andres Salomon <dilinger@queued.net>

I've noticed some pretty poor behavior on OLPC machines after bootup, when
gdm/X are starting.  The GCD monopolizes the scheduler (which in turns
means it gets to do more nand i/o), which results in processes taking much
much longer than they should to start.

As an example, on an OLPC machine going from OFW to a usable X (via
auto-login gdm) takes 2m 30s.  The majority of this time is consumed by
the switch into graphical mode.  With this patch, we cut a full 60s off of
bootup time.  After bootup, things are much snappier as well.

Note that we have seen a CRC node error with this patch that causes the machine
to fail to boot, but we've also seen that problem without this patch.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/background.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff -puN fs/jffs2/background.c~jffs2-force-the-jffs2-gc-daemon-to-behave-a-bit-better fs/jffs2/background.c
--- a/fs/jffs2/background.c~jffs2-force-the-jffs2-gc-daemon-to-behave-a-bit-better
+++ a/fs/jffs2/background.c
@@ -95,13 +95,17 @@ static int jffs2_garbage_collect_thread(
 			spin_unlock(&c->erase_completion_lock);
 			
 
-		/* This thread is purely an optimisation. But if it runs when
-		   other things could be running, it actually makes things a
-		   lot worse. Use yield() and put it at the back of the runqueue
-		   every time. Especially during boot, pulling an inode in
-		   with read_inode() is much preferable to having the GC thread
-		   get there first. */
-		yield();
+		/* Problem - immediately after bootup, the GCD spends a lot
+		 * of time in places like jffs2_kill_fragtree(); so much so
+		 * that userspace processes (like gdm and X) are starved
+		 * despite plenty of cond_resched()s and renicing.  Yield()
+		 * doesn't help, either (presumably because userspace and GCD
+		 * are generally competing for a higher latency resource -
+		 * disk).
+		 * This forces the GCD to slow the hell down.   Pulling an
+		 * inode in with read_inode() is much preferable to having
+		 * the GC thread get there first. */
+		schedule_timeout_interruptible(msecs_to_jiffies(50));
 
 		/* Put_super will send a SIGKILL and then wait on the sem.
 		 */
_

Patches currently in -mm which might be from dilinger@queued.net are

jffs2-force-the-jffs2-gc-daemon-to-behave-a-bit-better.patch

