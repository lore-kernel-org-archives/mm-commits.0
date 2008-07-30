From: akpm@linux-foundation.org
Subject: - char-mxser-ratelimit-ioctl-warning.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:15:01 -0700
Message-ID: <200807301915.m6UJF1xw010946@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57675 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752576AbYG3TPj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:15:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: mxser, ratelimit ioctl warning
has been removed from the -mm tree.  Its filename was
     char-mxser-ratelimit-ioctl-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: mxser, ratelimit ioctl warning
From: Jiri Slaby <jirislaby@gmail.com>

The GET_MAJOR ioctl prints out a warning, make it ratelimited.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/char/mxser.c~char-mxser-ratelimit-ioctl-warning drivers/char/mxser.c
--- a/drivers/char/mxser.c~char-mxser-ratelimit-ioctl-warning
+++ a/drivers/char/mxser.c
@@ -1612,8 +1612,10 @@ static int mxser_ioctl_special(unsigned 
 
 	switch (cmd) {
 	case MOXA_GET_MAJOR:
-		printk(KERN_WARNING "mxser: '%s' uses deprecated ioctl %x, fix "
-				"your userspace\n", current->comm, cmd);
+		if (printk_ratelimit())
+			printk(KERN_WARNING "mxser: '%s' uses deprecated ioctl "
+					"%x (GET_MAJOR), fix your userspace\n",
+					current->comm, cmd);
 		return put_user(ttymajor, (int __user *)argp);
 
 	case MOXA_CHKPORTENABLE:
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
ath5k-mask-out-unneeded-interrupts.patch
ath5k-unify-resets.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
ip2-avoid-add_timer-with-pending-timer.patch
char-ds1286-eliminate-busy-waiting.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

