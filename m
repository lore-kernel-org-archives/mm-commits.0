From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Wed, 03 Aug 2011 11:57:42 -0700
Message-ID: <201108031855.p73ItB5e006588@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49853 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753872Ab1HCSzj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2011 14:55:39 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id p73ItC1w006690
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 3 Aug 2011 11:55:12 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory-fix.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-mrst-pmuc-needs-moduleh.patch
drivers-acpi-apei-ghesc-fix-32-bit-build.patch
cris-fix-a-build-error-in-kernel-forkc.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
leds-new-pcengines-alix-system-driver-enables-leds-via-gpio-interface-fix.patch
drivers-video-backlight-aat2870_blc-make-it-buildable-as-a-module.patch
drivers-cdrom-cdromc-relax-check-on-dvd-manufacturer-value.patch
drivers-staging-speakup-devsynthc-fix-buffer-size-is-not-provably-correct-error.patch
drivers-staging-solo6x10-corec-needs-slabh.patch
drivers-staging-solo6x10-p2mc-needs-slabh.patch
staging-more-missing-slabh-inclusions.patch
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

