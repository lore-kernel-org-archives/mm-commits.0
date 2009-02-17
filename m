From: akpm@linux-foundation.org
Subject: [merged] jffs2-force-the-jffs2-gc-daemon-to-behave-a-bit-better.patch removed from -mm tree
Date: Tue, 17 Feb 2009 12:08:51 -0800
Message-ID: <200902172008.n1HK8p6X001174@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50057 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753366AbZBQUPV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Feb 2009 15:15:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, dilinger@debian.org, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     jffs2: force the jffs2 GC daemon to behave a bit better
has been removed from the -mm tree.  Its filename was
     jffs2-force-the-jffs2-gc-daemon-to-behave-a-bit-better.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
drivers-video-sgivwfbc-fix-memory-leaks-in-removal-path.patch
tdfxfb-fix-memory-leaks-in-removal-path.patch
tridentfb-fix-memory-leaks-in-removal-path.patch
vfb-fix-memory-leaks-in-removal-path.patch
skeletonfb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
sm501fb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
sstfb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
stifb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
valkyriefb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
sunxvr500-fix-cmap-memory-leaks.patch
tgafb-fix-cmap-memory-leak.patch
68328fb-fix-cmap-memory-leaks.patch
amba-clcd-fix-cmap-memory-leaks.patch
amifb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch

