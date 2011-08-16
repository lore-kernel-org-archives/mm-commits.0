From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Tue, 16 Aug 2011 11:47:39 -0700
Message-ID: <201108161844.p7GIikOI014783@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50041 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753084Ab1HPSpO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Aug 2011 14:45:14 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id p7GIikrB018123
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Tue, 16 Aug 2011 11:44:47 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-kcopyd.c    |    7 -------
 drivers/watchdog/nv_tco.c |    4 ----
 include/linux/dm-kcopyd.h |    3 ---
 3 files changed, 14 deletions(-)

diff -puN drivers/md/dm-kcopyd.c~linux-next-git-rejects drivers/md/dm-kcopyd.c
--- a/drivers/md/dm-kcopyd.c~linux-next-git-rejects
+++ a/drivers/md/dm-kcopyd.c
@@ -603,9 +603,6 @@ int dm_kcopyd_copy(struct dm_kcopyd_clie
 	job->num_dests = num_dests;
 	memcpy(&job->dests, dests, sizeof(*dests) * num_dests);
 
-<<<<<<< HEAD
-	job->pages = NULL;
-=======
 	if (from) {
 		job->source = *from;
 		job->pages = NULL;
@@ -616,7 +613,6 @@ int dm_kcopyd_copy(struct dm_kcopyd_clie
 		job->pages = &zero_page_list;
 		job->rw = WRITE;
 	}
->>>>>>> linux-next/akpm-end
 
 	job->fn = fn;
 	job->context = context;
@@ -665,8 +661,6 @@ void dm_kcopyd_do_callback(void *j, int 
 }
 EXPORT_SYMBOL(dm_kcopyd_do_callback);
 
-<<<<<<< HEAD
-=======
 int dm_kcopyd_zero(struct dm_kcopyd_client *kc,
 		   unsigned num_dests, struct dm_io_region *dests,
 		   unsigned flags, dm_kcopyd_notify_fn fn, void *context)
@@ -675,7 +669,6 @@ int dm_kcopyd_zero(struct dm_kcopyd_clie
 }
 EXPORT_SYMBOL(dm_kcopyd_zero);
 
->>>>>>> linux-next/akpm-end
 /*
  * Cancels a kcopyd job, eg. someone might be deactivating a
  * mirror.
diff -puN drivers/watchdog/nv_tco.c~linux-next-git-rejects drivers/watchdog/nv_tco.c
--- a/drivers/watchdog/nv_tco.c~linux-next-git-rejects
+++ a/drivers/watchdog/nv_tco.c
@@ -463,11 +463,7 @@ static void nv_tco_shutdown(struct platf
 	tco_timer_stop();
 
 	/* Some BIOSes fail the POST (once) if the NO_REBOOT flag is not
-<<<<<<< HEAD
 	 * unset during shutdown. */
-=======
-	* unset during shutdown. */
->>>>>>> linux-next/akpm-end
 	pci_read_config_dword(tco_pci, MCP51_SMBUS_SETUP_B, &val);
 	val &= ~MCP51_SMBUS_SETUP_B_TCO_REBOOT;
 	pci_write_config_dword(tco_pci, MCP51_SMBUS_SETUP_B, val);
diff -puN include/linux/dm-kcopyd.h~linux-next-git-rejects include/linux/dm-kcopyd.h
--- a/include/linux/dm-kcopyd.h~linux-next-git-rejects
+++ a/include/linux/dm-kcopyd.h
@@ -57,12 +57,9 @@ void *dm_kcopyd_prepare_callback(struct 
 				 dm_kcopyd_notify_fn fn, void *context);
 void dm_kcopyd_do_callback(void *job, int read_err, unsigned long write_err);
 
-<<<<<<< HEAD
-=======
 int dm_kcopyd_zero(struct dm_kcopyd_client *kc,
 		   unsigned num_dests, struct dm_io_region *dests,
 		   unsigned flags, dm_kcopyd_notify_fn fn, void *context);
 
->>>>>>> linux-next/akpm-end
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_DM_KCOPYD_H */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
headers_check-is-broken.patch
samples-hidraw-is-busted.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-mrst-pmuc-needs-moduleh.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
leds-new-pcengines-alix-system-driver-enables-leds-via-gpio-interface-fix.patch
mm.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
pps-new-client-driver-using-gpio-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
kexec-remove-kmsg_dump_kexec.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

