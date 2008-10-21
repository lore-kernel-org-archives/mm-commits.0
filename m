From: akpm@linux-foundation.org
Subject: + spi_gpio-driver-cleanups.patch added to -mm tree
Date: Tue, 21 Oct 2008 12:12:48 -0700
Message-ID: <200810211912.m9LJCmtG031100@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43078 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753517AbYJUTNj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Oct 2008 15:13:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, damm@igel.co.jp, dbrownell@users.sourceforge.net, mb@bu3sch.de, torgil.svensson@gmail.com


The patch titled
     spi_gpio-driver cleanups
has been added to the -mm tree.  Its filename is
     spi_gpio-driver-cleanups.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi_gpio-driver cleanups
From: Andrew Morton <akpm@linux-foundation.org>

- fix checkpatch whine.

- spi_master_put() already returns void, and that (void) thing is
  pointless and fugly.

Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Magnus Damm <damm@igel.co.jp>
Cc: Michael Buesch <mb@bu3sch.de>
Cc: Torgil Svensson <torgil.svensson@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_gpio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/spi/spi_gpio.c~spi_gpio-driver-cleanups drivers/spi/spi_gpio.c
--- a/drivers/spi/spi_gpio.c~spi_gpio-driver-cleanups
+++ a/drivers/spi/spi_gpio.c
@@ -125,7 +125,7 @@ static inline int getmiso(const struct s
  * reaching even one Mbit/sec (except when we can inline bitops), so for now
  * we'll just assume we never need additional per-bit slowdowns.
  */
-#define spidelay(nsecs)	do{} while(0)
+#define spidelay(nsecs)	do {} while (0)
 
 #define	EXPAND_BITBANG_TXRX
 #include <linux/spi/spi_bitbang.h>
@@ -323,7 +323,7 @@ static int __exit spi_gpio_remove(struct
 
 	/* stop() unregisters child devices too */
 	status = spi_bitbang_stop(&spi_gpio->bitbang);
-	(void) spi_master_put(spi_gpio->bitbang.master);
+	spi_master_put(spi_gpio->bitbang.master);
 
 	platform_set_drvdata(pdev, NULL);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
epoll-avoid-double-inserts-in-case-of-efault-checkpatch-fixes.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
linux-next-git-rejects.patch
git-tests-git-rejects.patch
revert-i7300_idle-driver-v155.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module-checkpatch-fixes.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
leds-driver-for-hp-harddisk-protection-led-fix.patch
drivers-rtc-rtc-ds1286c-is-borked.patch
drivers-rtc-rtc-m48t35c-is-borked-too.patch
drivers-net-sfc-falconc-fix-min-warnings.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
init-properly-placing-noinline-keyword.patch
spi_gpio-driver-cleanups.patch
w1-export-w1_read_8-function-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

