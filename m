From: akpm@linux-foundation.org
Subject: [nacked] cachefiles-cleanup-redundant-tests-on-unsigned.patch removed from -mm tree
Date: Thu, 29 Oct 2009 08:37:42 -0700
Message-ID: <200910291537.n9TFbgj0017032@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754905AbZJ2Phy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Oct 2009 11:37:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     CacheFiles: Cleanup redundant tests on unsigned
has been removed from the -mm tree.  Its filename was
     cachefiles-cleanup-redundant-tests-on-unsigned.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: CacheFiles: Cleanup redundant tests on unsigned
From: Roel Kluin <roel.kluin@gmail.com>

The variables are unsigned so the test `>= 0' is always true, the `< 0'
test always fails.  The other part of the test catches wrapped values.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/cachefiles/bind.c~cachefiles-cleanup-redundant-tests-on-unsigned fs/cachefiles/bind.c
--- a/fs/cachefiles/bind.c~cachefiles-cleanup-redundant-tests-on-unsigned
+++ a/fs/cachefiles/bind.c
@@ -39,13 +39,11 @@ int cachefiles_daemon_bind(struct cachef
 	       args);
 
 	/* start by checking things over */
-	ASSERT(cache->fstop_percent >= 0 &&
-	       cache->fstop_percent < cache->fcull_percent &&
+	ASSERT(cache->fstop_percent < cache->fcull_percent &&
 	       cache->fcull_percent < cache->frun_percent &&
 	       cache->frun_percent  < 100);
 
-	ASSERT(cache->bstop_percent >= 0 &&
-	       cache->bstop_percent < cache->bcull_percent &&
+	ASSERT(cache->bstop_percent < cache->bcull_percent &&
 	       cache->bcull_percent < cache->brun_percent &&
 	       cache->brun_percent  < 100);
 
diff -puN fs/cachefiles/daemon.c~cachefiles-cleanup-redundant-tests-on-unsigned fs/cachefiles/daemon.c
--- a/fs/cachefiles/daemon.c~cachefiles-cleanup-redundant-tests-on-unsigned
+++ a/fs/cachefiles/daemon.c
@@ -220,7 +220,7 @@ static ssize_t cachefiles_daemon_write(s
 	if (test_bit(CACHEFILES_DEAD, &cache->flags))
 		return -EIO;
 
-	if (datalen < 0 || datalen > PAGE_SIZE - 1)
+	if (datalen > PAGE_SIZE - 1)
 		return -EOPNOTSUPP;
 
 	/* drag the command string into the kernel so we can parse it */
@@ -385,7 +385,7 @@ static int cachefiles_daemon_fstop(struc
 	if (args[0] != '%' || args[1] != '\0')
 		return -EINVAL;
 
-	if (fstop < 0 || fstop >= cache->fcull_percent)
+	if (fstop >= cache->fcull_percent)
 		return cachefiles_daemon_range_error(cache, args);
 
 	cache->fstop_percent = fstop;
@@ -457,7 +457,7 @@ static int cachefiles_daemon_bstop(struc
 	if (args[0] != '%' || args[1] != '\0')
 		return -EINVAL;
 
-	if (bstop < 0 || bstop >= cache->bcull_percent)
+	if (bstop >= cache->bcull_percent)
 		return cachefiles_daemon_range_error(cache, args);
 
 	cache->bstop_percent = bstop;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
frv-fix-check-on-unsigned-in-do_signal.patch
get_maintainer-fix-usage-comment.patch
linux-next.patch
fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return.patch
omap-fix-unlikelyx-y.patch
powernow-k8-fix-test-in-get_transition_latency.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
hfc_usb-fix-read-buffer-overflow.patch
hisax-fix-test-in-waitforxfw.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
st-fix-test-of-value-range-in-st_set_options.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
bfa-fix-test-in-bfad_os_fc_host_init.patch
page-types-unsigned-cannot-be-less-than-0-in-add_page.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
gpio-fix-test-on-unsigned-in-lnw_irq_type.patch
fbdev-tv_paln-bit-set-twice-in-sisfb_detect_vb_connect.patch
hvc_console-fix-test-on-unsigned-in-hvc_console_print.patch
irq-fix-test-in-__exit-parport_mfc3_exit.patch
cachefiles-cleanup-redundant-tests-on-unsigned.patch

