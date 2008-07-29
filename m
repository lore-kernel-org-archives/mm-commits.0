From: akpm@linux-foundation.org
Subject: + drm-dont-enable-irqs-in-locking.patch added to -mm tree
Date: Mon, 28 Jul 2008 20:59:02 -0700
Message-ID: <200807290359.m6T3x2k3013005@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40750 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753566AbYG2D7r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 23:59:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, airlied@linux.ie


The patch titled
     drm: don't enable irqs in locking
has been added to the -mm tree.  Its filename is
     drm-dont-enable-irqs-in-locking.patch

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
Subject: drm: don't enable irqs in locking
From: Jiri Slaby <jirislaby@gmail.com>

drm_lock_take(); and drm_lock_free(); are called from
drm_locked_tasklet_func(); which disables interrupts when grabbing its
spinlock.

Don't allow these locking functions to re-enable interrupts when the
tasklet expects them disabled.  I.e.  use spin_lock_irqsave instead of
spin_lock_bh (with their unlock opposites).

We will get such a warnings otherwise:
------------[ cut here ]------------
WARNING: at kernel/softirq.c:136 local_bh_enable_ip+0x8b/0xb0()
Modules linked in: arc4 ecb crypto_blkcipher cryptomgr crypto_algapi ath5k usbhid mac80211 ohci1394 hid led_class floppy cfg80211 ff_memless ieee1394 rtc_cmos evdev [last unloaded: freq_table]
Pid: 0, comm: swapper Not tainted 2.6.26-rc8-mm1_64 #427

Call Trace:
 <IRQ>  [<ffffffff8023813f>] warn_on_slowpath+0x5f/0x90
[...]
 [<ffffffff8023e1fb>] local_bh_enable_ip+0x8b/0xb0
 [<ffffffff8055b2cf>] _spin_unlock_bh+0xf/0x20
 [<ffffffff803b0bd1>] drm_lock_take+0x81/0xe0
 [<ffffffff803b006b>] drm_locked_tasklet_func+0x4b/0xb0
 [<ffffffff8023daf9>] tasklet_hi_action+0x69/0xf0
 [<ffffffff8023e3e4>] __do_softirq+0x84/0xf0
[stack snipped]

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_lock.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN drivers/gpu/drm/drm_lock.c~drm-dont-enable-irqs-in-locking drivers/gpu/drm/drm_lock.c
--- a/drivers/gpu/drm/drm_lock.c~drm-dont-enable-irqs-in-locking
+++ a/drivers/gpu/drm/drm_lock.c
@@ -196,10 +196,11 @@ int drm_unlock(struct drm_device *dev, v
 int drm_lock_take(struct drm_lock_data *lock_data,
 		  unsigned int context)
 {
+	unsigned long flags;
 	unsigned int old, new, prev;
 	volatile unsigned int *lock = &lock_data->hw_lock->lock;
 
-	spin_lock_bh(&lock_data->spinlock);
+	spin_lock_irqsave(&lock_data->spinlock, flags);
 	do {
 		old = *lock;
 		if (old & _DRM_LOCK_HELD)
@@ -211,7 +212,7 @@ int drm_lock_take(struct drm_lock_data *
 		}
 		prev = cmpxchg(lock, old, new);
 	} while (prev != old);
-	spin_unlock_bh(&lock_data->spinlock);
+	spin_unlock_irqrestore(&lock_data->spinlock, flags);
 
 	if (_DRM_LOCKING_CONTEXT(old) == context) {
 		if (old & _DRM_LOCK_HELD) {
@@ -270,17 +271,18 @@ static int drm_lock_transfer(struct drm_
  */
 int drm_lock_free(struct drm_lock_data *lock_data, unsigned int context)
 {
+	unsigned long flags;
 	unsigned int old, new, prev;
 	volatile unsigned int *lock = &lock_data->hw_lock->lock;
 
-	spin_lock_bh(&lock_data->spinlock);
+	spin_lock_irqsave(&lock_data->spinlock, flags);
 	if (lock_data->kernel_waiters != 0) {
 		drm_lock_transfer(lock_data, 0);
 		lock_data->idle_has_lock = 1;
-		spin_unlock_bh(&lock_data->spinlock);
+		spin_unlock_irqrestore(&lock_data->spinlock, flags);
 		return 1;
 	}
-	spin_unlock_bh(&lock_data->spinlock);
+	spin_unlock_irqrestore(&lock_data->spinlock, flags);
 
 	do {
 		old = *lock;
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

