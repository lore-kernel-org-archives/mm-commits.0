From: akpm@linux-foundation.org
Subject: - fs-sysfs-remove-spin_lock_unlocked.patch removed from -mm tree
Date: Mon, 26 Nov 2007 13:48:28 -0800
Message-ID: <200711262148.lAQLmSRG024600@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58680 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754847AbXKZVsd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 16:48:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     FS: sysfs, remove SPIN_LOCK_UNLOCKED
has been removed from the -mm tree.  Its filename was
     fs-sysfs-remove-spin_lock_unlocked.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: FS: sysfs, remove SPIN_LOCK_UNLOCKED
From: Jiri Slaby <jirislaby@gmail.com>

SPIN_LOCK_UNLOCKED is deprecated, use DEFINE_SPINLOCK instead

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/sysfs/file.c~fs-sysfs-remove-spin_lock_unlocked fs/sysfs/file.c
--- a/fs/sysfs/file.c~fs-sysfs-remove-spin_lock_unlocked
+++ a/fs/sysfs/file.c
@@ -37,7 +37,7 @@ void sysfs_printk_last_file(void)
  * sysfs_dirent->s_attr.open points to sysfs_open_dirent.  s_attr.open
  * is protected by sysfs_open_dirent_lock.
  */
-static spinlock_t sysfs_open_dirent_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(sysfs_open_dirent_lock);
 
 struct sysfs_open_dirent {
 	atomic_t		refcnt;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

net-sunrpc-remove-spin_lock_unlocked.patch
net-ibm_newemac-remove-spin_lock_unlocked.patch
git-watchdog.patch
git-wireless.patch
drm-i915-fix-pointer-strip.patch
dzh-remove-useless-unused-module-junk.patch
dz-always-check-if-it-is-safe-to-console_putchar.patch
dz-dont-panic-when-request_irq-fails.patch
dz-add-and-reorder-inclusions-remove-unneeded-ones.patch
dz-update-kconfig-description.patch
dz-rename-the-serial-console-structure.patch
dz-fix-locking-issues.patch
dz-handle-special-conditions-on-reception-correctly.patch
maintainers-add-self-for-the-dz-serial-driver.patch
char-rocket-switch-long-delay-to-sleep.patch
char-rocket-printk-cleanup.patch
char-rocket-remove-useless-macros.patch
char-char-serial-remove-serial_type_normal-redefines.patch
char-mxser_new-ioaddresses-are-ulong.patch
char-stallion-fix-compiler-warnings.patch
char-riscom8-change-rc_init_drivers-prototype.patch
char-esp-remove-hangup-and-wakeup-bottomhalves.patch
char-istallion-remove-hangup-bottomhalf.patch
char-specialix-remove-bottomhalves.patch
char-stallion-remove-bottomhalf.patch
char-serial167-remove-bottomhalf.patch
char-riscom8-remove-wakeup-anf-hangup-bottomhalves.patch
moxa-first-pass-at-termios-reporting.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
