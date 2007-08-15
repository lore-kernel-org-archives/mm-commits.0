From: akpm@linux-foundation.org
Subject: + alpm-increase-number-of-allowable-device-flags-fix.patch added to -mm tree
Date: Wed, 15 Aug 2007 14:11:15 -0700
Message-ID: <200708152111.l7FLBFfs015229@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40291 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765699AbXHOVLu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 17:11:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, alan@lxorguk.ukuu.org.uk, htejun@gmail.com, jeff@garzik.org, kristen.c.accardi@intel.com


The patch titled
     2.6.23-rc2-mm2: sata disk going slow
has been added to the -mm tree.  Its filename is
     alpm-increase-number-of-allowable-device-flags-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: 2.6.23-rc2-mm2: sata disk going slow
From: Hugh Dickins <hugh@veritas.com>

Why is the G5 so slow with 2.6.23-rc2-mm2?  hdparm -t shows 1.8MB/sec
instead of 58MB/sec.  alpm-increase-number-of-allowable-device-flags.patch
(raising ATA_DFLAG_CFG_MASK) turns out to be the guilty party: though the
problem doesn't appear until the next patch, which adds ATA_DFLAG_IPM as
the same bit as ATA_DFLAG_PIO.  Here's a hotfix against top of -rc2-mm2.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/libata.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/libata.h~alpm-increase-number-of-allowable-device-flags-fix include/linux/libata.h
--- a/include/linux/libata.h~alpm-increase-number-of-allowable-device-flags-fix
+++ a/include/linux/libata.h
@@ -141,9 +141,9 @@ enum {
 	ATA_DFLAG_ACPI_FAILED	= (1 << 6), /* ACPI on devcfg has failed */
 	ATA_DFLAG_CFG_MASK	= (1 << 12) - 1,
 
-	ATA_DFLAG_PIO		= (1 << 8), /* device limited to PIO mode */
-	ATA_DFLAG_NCQ_OFF	= (1 << 9), /* device limited to non-NCQ mode */
-	ATA_DFLAG_SPUNDOWN	= (1 << 10), /* XXX: for spindown_compat */
+	ATA_DFLAG_PIO		= (1 << 12), /* device limited to PIO mode */
+	ATA_DFLAG_NCQ_OFF	= (1 << 13), /* device limited to non-NCQ mode */
+	ATA_DFLAG_SPUNDOWN	= (1 << 14), /* XXX: for spindown_compat */
 	ATA_DFLAG_INIT_MASK	= (1 << 16) - 1,
 
 	ATA_DFLAG_DETACH	= (1 << 16),
_

Patches currently in -mm which might be from hugh@veritas.com are

check-for-pageslab-in-arch-flush_dcache_page-to-avoid-triggering-vm_bug_on.patch
alpm-increase-number-of-allowable-device-flags-fix.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
mm-clarify-__add_to_swap_cache-locking.patch
mm-clarify-__add_to_swap_cache-locking-fix.patch
radix-tree-use-indirect-bit.patch
introduce-write_begin-write_end-aops-important-fix.patch
reiserfs-convert-to-new-aops-fix.patch
hostfs-convert-to-new-aops-fix.patch
affs-convert-to-new-aops-fix.patch
flush-cache-before-installing-new-page-at-migraton.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte.patch
mm-shmemc-make-3-functions-static.patch
ext2-reservations.patch
fix-for-ext2-reservation.patch
ext2-balloc-use-io_error-label.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
prio_tree-debugging-patch.patch
