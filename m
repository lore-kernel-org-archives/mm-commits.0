From: akpm@linux-foundation.org
Subject: - drivers-char-synclinkc-inbreak-mgsl_put_char.patch removed from -mm tree
Date: Fri, 02 May 2008 12:43:36 -0700
Message-ID: <200805021943.m42Jha5B011303@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49557 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765479AbYEBTwa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:52:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, alan@redhat.com, jirislaby@gmail.com, paulkf@microgate.com, mm-commits@vger.kernel.org


The patch titled
     drivers/char/synclink.c: unbreak mgsl_put_char()
has been removed from the -mm tree.  Its filename was
     drivers-char-synclinkc-inbreak-mgsl_put_char.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/char/synclink.c: unbreak mgsl_put_char()
From: Andrew Morton <akpm@linux-foundation.org>

Repair the effects of

commit 55da77899c1472d83452c914fa179d00ea96df65
Author: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date:   Wed Apr 30 00:54:07 2008 -0700

    synclink series: switch to int put_char method
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Cc: Paul Fulghum <paulkf@microgate.com>
    Cc: Jiri Slaby <jirislaby@gmail.com>

drivers/char/synclink_gt.c: In function 'put_char':
drivers/char/synclink_gt.c:919: warning: 'ret' may be used uninitialized in this function

and do some whitespace repair and unneeded-cast-removal in there as well.

Cc: Paul Fulghum <paulkf@microgate.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/synclink.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/char/synclink.c~drivers-char-synclinkc-inbreak-mgsl_put_char drivers/char/synclink.c
--- a/drivers/char/synclink.c~drivers-char-synclinkc-inbreak-mgsl_put_char
+++ a/drivers/char/synclink.c
@@ -2028,13 +2028,13 @@ static void mgsl_change_params(struct mg
  */
 static int mgsl_put_char(struct tty_struct *tty, unsigned char ch)
 {
-	struct mgsl_struct *info = (struct mgsl_struct *)tty->driver_data;
+	struct mgsl_struct *info = tty->driver_data;
 	unsigned long flags;
-	int ret;
+	int ret = 0;
 
-	if ( debug_level >= DEBUG_LEVEL_INFO ) {
-		printk( "%s(%d):mgsl_put_char(%d) on %s\n",
-			__FILE__,__LINE__,ch,info->device_name);
+	if (debug_level >= DEBUG_LEVEL_INFO) {
+		printk("%s(%d):mgsl_put_char(%d) on %s\n",
+			__FILE__, __LINE__, ch, info->device_name);
 	}		
 	
 	if (mgsl_paranoia_check(info, tty->name, "mgsl_put_char"))
@@ -2043,9 +2043,9 @@ static int mgsl_put_char(struct tty_stru
 	if (!tty || !info->xmit_buf)
 		return 0;
 
-	spin_lock_irqsave(&info->irq_spinlock,flags);
+	spin_lock_irqsave(&info->irq_spinlock, flags);
 	
-	if ( (info->params.mode == MGSL_MODE_ASYNC ) || !info->tx_active ) {
+	if ((info->params.mode == MGSL_MODE_ASYNC ) || !info->tx_active) {
 		if (info->xmit_cnt < SERIAL_XMIT_SIZE - 1) {
 			info->xmit_buf[info->xmit_head++] = ch;
 			info->xmit_head &= SERIAL_XMIT_SIZE-1;
@@ -2053,7 +2053,7 @@ static int mgsl_put_char(struct tty_stru
 			ret = 1;
 		}
 	}
-	spin_unlock_irqrestore(&info->irq_spinlock,flags);
+	spin_unlock_irqrestore(&info->irq_spinlock, flags);
 	return ret;
 	
 }	/* end of mgsl_put_char() */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-memory-hotplug-register-section-node-id-to-free.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
git-x86-fixup.patch
rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline.patch
cifs-suppress-warning.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
git-dvb.patch
i2c-renesas-highlander-fpga-smbus-support.patch
touch-screen-driver-for-the-superh-migor-board.patch
git-kvm.patch
pata_atiixp-simplex-clear.patch
git-mips.patch
git-mips-git-rejects.patch
git-mmc.patch
sundance-set-carrier-status-on-link-change-events.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
power_supply-bump-ec-version-check-that-we-refuse-to-run-with-in-olpc_battery-checkpatch-fixes.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
git-sched.patch
drivers-base-topologyc-add-conditionals-around-show_cpumap.patch
add-rcu_assign_index-if-ever-needed.patch
git-scsi-misc.patch
aic79xx_core-remove-ascii-art.patch
sparc32-export-empty_zero_page.patch
git-unionfs.patch
git-v9fs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system-fix.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system-fix-checkpatch-fixes.patch
xfs-suppress-uninitialized-var-warnings.patch
git-xtensa.patch
make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch
ext4-is-busted-on-m68k.patch
pci-export-resource_wc-in-pci-sysfs-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-checkpatch-fixes.patch
add-warn_on_secs-macro.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
sxc-fix-printk-warnings-on-sparc32.patch
reiser4.patch
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

