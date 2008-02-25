From: akpm@linux-foundation.org
Subject: + misc-phantom-fix-poll.patch added to -mm tree
Date: Mon, 25 Feb 2008 10:22:21 -0800
Message-ID: <200802251823.m1PINDRv012924@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50676 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757579AbYBYSXo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Feb 2008 13:23:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Misc, phantom, fix poll
has been added to the -mm tree.  Its filename is
     misc-phantom-fix-poll.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Misc, phantom, fix poll
From: Jiri Slaby <jirislaby@gmail.com>

Return ERR even if there are pending data, but hw is not running.  Do not
decrement count in poll, do it in ioctl, where data are actually read.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/phantom.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/misc/phantom.c~misc-phantom-fix-poll drivers/misc/phantom.c
--- a/drivers/misc/phantom.c~misc-phantom-fix-poll
+++ a/drivers/misc/phantom.c
@@ -169,6 +169,7 @@ static long phantom_ioctl(struct file *f
 		for (i = 0; i < m; i++)
 			if (rs.mask & BIT(i))
 				rs.values[i] = ioread32(dev->iaddr + i);
+		atomic_set(&dev->counter, 0);
 		spin_unlock_irqrestore(&dev->regs_lock, flags);
 
 		if (copy_to_user(argp, &rs, sizeof(rs)))
@@ -254,11 +255,12 @@ static unsigned int phantom_poll(struct 
 
 	pr_debug("phantom_poll: %d\n", atomic_read(&dev->counter));
 	poll_wait(file, &dev->wait, wait);
-	if (atomic_read(&dev->counter)) {
+
+	if (!(dev->status & PHB_RUNNING))
+		mask = POLLERR;
+	else if (atomic_read(&dev->counter))
 		mask = POLLIN | POLLRDNORM;
-		atomic_dec(&dev->counter);
-	} else if ((dev->status & PHB_RUNNING) == 0)
-		mask = POLLIN | POLLRDNORM | POLLERR;
+
 	pr_debug("phantom_poll end: %x/%d\n", mask, atomic_read(&dev->counter));
 
 	return mask;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

git-drm.patch
drm-i915-fix-oops-after-killing-x.patch
wdev-ath5k-typecheck-on-nondebug.patch
misc-phantom-add-compat-ioctl.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
misc-phantom-fix-poll.patch
mxser-prepare-for-bkl-pushdown.patch
tty-bkl-pushdown-fix.patch
tty-bkl-pushdown-fix1.patch
mxser-convert-large-macros-to-functions.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
