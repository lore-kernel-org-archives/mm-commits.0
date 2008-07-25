From: akpm@linux-foundation.org
Subject: + char-ds1286-eliminate-busy-waiting.patch added to -mm tree
Date: Fri, 25 Jul 2008 14:30:46 -0700
Message-ID: <200807252130.m6PLUklX032153@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56223 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751357AbYGYVa5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 17:30:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, ralf@linux-mips.org


The patch titled
     Char: ds1286, eliminate busy waiting
has been added to the -mm tree.  Its filename is
     char-ds1286-eliminate-busy-waiting.patch

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
Subject: Char: ds1286, eliminate busy waiting
From: Jiri Slaby <jirislaby@gmail.com>

ds1286_get_time(); is not called from atomic context, sleep for 20 ms is
better choice than a (home-made) busy waiting for such a situation.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ds1286.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/char/ds1286.c~char-ds1286-eliminate-busy-waiting drivers/char/ds1286.c
--- a/drivers/char/ds1286.c~char-ds1286-eliminate-busy-waiting
+++ a/drivers/char/ds1286.c
@@ -443,7 +443,6 @@ static void ds1286_get_time(struct rtc_t
 {
 	unsigned char save_control;
 	unsigned long flags;
-	unsigned long uip_watchdog = jiffies;
 
 	/*
 	 * read RTC once any update in progress is done. The update
@@ -456,8 +455,7 @@ static void ds1286_get_time(struct rtc_t
 	 */
 
 	if (ds1286_is_updating() != 0)
-		while (time_before(jiffies, uip_watchdog + 2*HZ/100))
-			barrier();
+		msleep(20);
 
 	/*
 	 * Only the values that we read from the RTC are set. We leave
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
add-a-warn-macro-this-is-warn_on-printk-arguments.patch
ip2-push-bkl-down-for-the-firmware-interface.patch
rio-push-down-the-bkl-into-the-firmware-ioctl-handler.patch
sx-push-bkl-down-into-the-firmware-ioctl-handler.patch
ppdev-wrap-ioctl-handler-in-driver-and-push-lock-down.patch
dsp56k-bkl-pushdown.patch
char-mxser-ioctl-cleanup.patch
char-mxser-globals-cleanup.patch
char-mxser-update-documentation.patch
char-mxser-prints-cleanup.patch
char-mxser-remove-predefined-isa-support.patch
char-mxser-various-cleanups.patch
drivers-misc-phantom-note-pci.patch
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
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
ip2-avoid-add_timer-with-pending-timer.patch
char-ds1286-eliminate-busy-waiting.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

