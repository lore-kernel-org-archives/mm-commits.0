From: akpm@linux-foundation.org
Subject: + fs-sysfs-remove-spin_lock_unlocked.patch added to -mm tree
Date: Mon, 12 Nov 2007 13:47:29 -0800
Message-ID: <200711122147.lACLlTC7010521@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56300 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752625AbXKLVrg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 16:47:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, gregkh@suse.de


The patch titled
     FS: sysfs, remove SPIN_LOCK_UNLOCKED
has been added to the -mm tree.  Its filename is
     fs-sysfs-remove-spin_lock_unlocked.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-wireless.patch
crisv10-serial-driver-rewrite-take-three.patch
dzh-remove-useless-unused-module-junk.patch
dz-always-check-if-it-is-safe-to-console_putchar.patch
dz-dont-panic-when-request_irq-fails.patch
dz-add-and-reorder-inclusions-remove-unneeded-ones.patch
dz-update-kconfig-description.patch
dz-rename-the-serial-console-structure.patch
dz-fix-locking-issues.patch
dz-handle-special-conditions-on-reception-correctly.patch
maintainers-add-self-for-the-dz-serial-driver.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
net-ibm_newemac-remove-spin_lock_unlocked.patch
watchdog-bfin_wdt-remove-spin_lock_unlocked.patch
sbus-cpwatchdog-remove-spin_lock_unlocked.patch
fs-sysfs-remove-spin_lock_unlocked.patch
net-sunrpc-remove-spin_lock_unlocked.patch
