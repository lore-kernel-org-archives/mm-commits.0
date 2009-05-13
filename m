From: akpm@linux-foundation.org
Subject: [merged] dm-table-fix-printk-formats.patch removed from -mm tree
Date: Wed, 13 May 2009 11:32:03 -0700
Message-ID: <200905131832.n4DIW3SH018758@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41696 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755446AbZEMSeq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 May 2009 14:34:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, agk@redhat.com, mm-commits@vger.kernel.org


The patch titled
     dm-table: fix printk formats
has been removed from the -mm tree.  Its filename was
     dm-table-fix-printk-formats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dm-table: fix printk formats
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings:

drivers/md/dm-table.c:408: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'sector_t'
drivers/md/dm-table.c:414: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'sector_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-table.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/md/dm-table.c~dm-table-fix-printk-formats drivers/md/dm-table.c
--- a/drivers/md/dm-table.c~dm-table-fix-printk-formats
+++ a/drivers/md/dm-table.c
@@ -405,14 +405,16 @@ static int device_area_is_valid(struct d
 		return 1;
 
 	if (start & (hardsect_size_sectors - 1)) {
-		DMWARN("%s: start=%lu not aligned to h/w sector of %s",
-		       dm_device_name(ti->table->md), start, bdevname(bdev, b));
+		DMWARN("%s: start=%llu not aligned to h/w sector of %s",
+		       dm_device_name(ti->table->md),
+		       (unsigned long long)start, bdevname(bdev, b));
 		return 0;
 	}
 
 	if (len & (hardsect_size_sectors - 1)) {
-		DMWARN("%s: len=%lu not aligned to h/w sector size %hu of %s",
-		       dm_device_name(ti->table->md), len,
+		DMWARN("%s: len=%llu not aligned to h/w sector size %hu of %s",
+		       dm_device_name(ti->table->md),
+		       (unsigned long long)len,
 		       ti->limits.hardsect_size, bdevname(bdev, b));
 		return 0;
 	}
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
menu-fix-embedded-menu-presentation.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
qla2x-fix-printk-format-warnings.patch
slqbinfo-eliminate-warnings.patch
lockd-fix-file_locking=n-build-error.patch
xen-use-header-for-export_symbol_gpl.patch
kmap_types-make-most-arches-use-generic-header-file.patch
irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list.patch
cgroups-make-messages-more-readable.patch
linuxpps-core-support.patch
reiser4-export-remove_from_page_cache-fix.patch

