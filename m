From: akpm@linux-foundation.org
Subject: + char-mxser-ratelimit-ioctl-warning.patch added to -mm tree
Date: Tue, 29 Jul 2008 00:23:36 -0700
Message-ID: <200807290723.m6T7NaXP020761@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58097 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752340AbYG2HXp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 03:23:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk


The patch titled
     Char: mxser, ratelimit ioctl warning
has been added to the -mm tree.  Its filename is
     char-mxser-ratelimit-ioctl-warning.patch

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
Subject: Char: mxser, ratelimit ioctl warning
From: Jiri Slaby <jirislaby@gmail.com>

The GET_MAJOR ioctl prints out a warning, make it ratelimited.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
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
ath5k-fix-memory-corruption.patch
ath5k-kill-tasklets-on-shutdown.patch
ath5k-flush-work.patch
ath5k-fix-dma-operation.patch
ath5k-suspend-resume-fixes.patch
ath5k-fix-beacon-update-deadlock.patch
ath5k-mask-out-unneeded-interrupts.patch
ath5k-unify-resets.patch
mac80211-tx-use-dev_kfree_skb_any-for-beacon_get.patch
mac80211-return-correct-error-return-from-ieee80211_wep_init.patch
drm-dont-enable-irqs-in-locking.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
ip2-avoid-add_timer-with-pending-timer.patch
char-ds1286-eliminate-busy-waiting.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
char-mxser-ratelimit-ioctl-warning.patch

