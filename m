From: akpm@linux-foundation.org
Subject: - drivers-net-sfc-falconc-fix-min-warnings.patch removed from -mm tree
Date: Wed, 29 Oct 2008 14:35:50 -0700
Message-ID: <200810292135.m9TLZppO025527@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755614AbYJ2Vgf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Oct 2008 17:36:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bhutchings@solarflare.com, jgarzik@redhat.com, mm-commits@vger.kernel.org


The patch titled
     drivers/net/sfc/falcon.c: fix min() warnings
has been removed from the -mm tree.  Its filename was
     drivers-net-sfc-falconc-fix-min-warnings.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/sfc/falcon.c: fix min() warnings
From: Andrew Morton <akpm@linux-foundation.org>

drivers/net/sfc/falcon.c: In function 'falcon_spi_write_limit':
drivers/net/sfc/falcon.c:1679: warning: comparison of distinct pointer types lacks a cast
drivers/net/sfc/falcon.c: In function 'falcon_spi_read':
drivers/net/sfc/falcon.c:1720: warning: comparison of distinct pointer types lacks a cast

Driver seems rather confused about types.  Try to help it.

Cc: Ben Hutchings <bhutchings@solarflare.com>
Cc: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sfc/falcon.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/net/sfc/falcon.c~drivers-net-sfc-falconc-fix-min-warnings drivers/net/sfc/falcon.c
--- a/drivers/net/sfc/falcon.c~drivers-net-sfc-falconc-fix-min-warnings
+++ a/drivers/net/sfc/falcon.c
@@ -1685,8 +1685,8 @@ static int falcon_spi_cmd(const struct e
 	return 0;
 }
 
-static unsigned int
-falcon_spi_write_limit(const struct efx_spi_device *spi, unsigned int start)
+static size_t
+falcon_spi_write_limit(const struct efx_spi_device *spi, size_t start)
 {
 	return min(FALCON_SPI_MAX_LEN,
 		   (spi->block_size - (start & (spi->block_size - 1))));
@@ -1729,8 +1729,7 @@ int falcon_spi_read(const struct efx_spi
 	int rc = 0;
 
 	while (pos < len) {
-		block_len = min((unsigned int)len - pos,
-				FALCON_SPI_MAX_LEN);
+		block_len = min(len - pos, FALCON_SPI_MAX_LEN);
 
 		command = efx_spi_munge_command(spi, SPI_READ, start + pos);
 		rc = falcon_spi_cmd(spi, command, start + pos, NULL,
@@ -1764,7 +1763,7 @@ int falcon_spi_write(const struct efx_sp
 		if (rc)
 			break;
 
-		block_len = min((unsigned int)len - pos,
+		block_len = min(len - pos,
 				falcon_spi_write_limit(spi, start + pos));
 		command = efx_spi_munge_command(spi, SPI_WRITE, start + pos);
 		rc = falcon_spi_cmd(spi, command, start + pos,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

freezer_cg-use-thaw_process-in-unfreeze_cgroup.patch
fs-remove-prepare_write-commit_write.patch
mm-write_cache_pages-writepage-error-fix.patch
nfsd-fix-vm-overcommit-crash.patch
autofs4-collect-version-check-return-checkpatch-fixes.patch
maintainers-make-ioat-easier-to-find.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
linux-next-rejects.patch
next-remove-localversion.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
linux-timexh-cleanup-for-userspace.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
drivers-rtc-rtc-ds1286c-is-borked.patch
drivers-rtc-rtc-m48t35c-is-borked-too.patch
drivers-net-sfc-falconc-fix-min-warnings.patch
pci-uninline-pci_ioremap_bar.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
fs-truncate-blocks-outside-i_size-after-generic_file_direct_write-error-fix.patch
init-properly-placing-noinline-keyword.patch
spi_gpio-driver-cleanups.patch
rtc-rtc-wm8350-add-support-for-wm8350-rtc.patch
rtc-basic-implementation-of-epson-rx-8581-i2c-real-time-clock-fix.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix-2.patch
quota-convert-union-in-mem_dqinfo-to-a-pointer-cleanup.patch
quota-support-64-bit-quota-format-fix.patch
quota-support-64-bit-quota-format-fix-2.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
w1-export-w1_read_8-function-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
reiser4-broke.patch
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

