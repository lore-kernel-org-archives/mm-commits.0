From: akpm@linux-foundation.org
Subject: + scsi-fix-config_scsi_wait_scan=m.patch added to -mm tree
Date: Tue, 03 Apr 2007 13:06:05 -0700
Message-ID: <200704032006.l33K67TG001874@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41057 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422675AbXDCUGQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 3 Apr 2007 16:06:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, James.Bottomley@steeleye.com


The patch titled
     scsi: fix CONFIG_SCSI_WAIT_SCAN=m
has been added to the -mm tree.  Its filename is
     scsi-fix-config_scsi_wait_scan=m.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: scsi: fix CONFIG_SCSI_WAIT_SCAN=m
From: Hugh Dickins <hugh@veritas.com>

CONFIG_MODULES=y
CONFIG_SCSI=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

2.6.21-rc5-mm2 VFS panics unable to find my root on /dev/sda2, but boots
okay if I change drivers/scsi/Kconfig to "default y" instead of "default m"
for SCSI_WAIT_SCAN.

Make sure there's a late_initcall to scsi_complete_async_scans when it's
built in, so a monolithic SCSI_SCAN_ASYNC kernel can rely on the scans
being completed before trying to mount root, even if they're slow.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_scan.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/scsi/scsi_scan.c~scsi-fix-config_scsi_wait_scan=m drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c~scsi-fix-config_scsi_wait_scan=m
+++ a/drivers/scsi/scsi_scan.c
@@ -183,6 +183,7 @@ int scsi_complete_async_scans(void)
 
 /* Only exported for the benefit of scsi_wait_scan */
 EXPORT_SYMBOL_GPL(scsi_complete_async_scans);
+late_initcall(scsi_complete_async_scans);
 
 /**
  * scsi_unlock_floptical - unlock device via a special MODE SENSE command
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
git-drm.patch
scsi-fix-config_scsi_wait_scan=m.patch
scsi-fix-config_scsi_wait_scan=m-fix.patch
mm-more-rmap-checking.patch
mm-make-read_cache_page-synchronous.patch
fs-buffer-dont-pageuptodate-without-page-locked.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
i386-add-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix-2.patch
smaps-use-ptep_test_and_clear_young.patch
tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up-fix.patch
ext2-reservations.patch
ext2-balloc-use-io_error-label.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
