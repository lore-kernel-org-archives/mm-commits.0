From: akpm@linux-foundation.org
Subject: + dm-table-fix-printk-formats.patch added to -mm tree
Date: Fri, 08 May 2009 12:14:41 -0700
Message-ID: <200905081914.n48JEfIi020818@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40001 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754455AbZEHTQr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 May 2009 15:16:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, agk@redhat.com


The patch titled
     dm-table: fix printk formats
has been added to the -mm tree.  Its filename is
     dm-table-fix-printk-formats.patch

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
dm-table-fix-printk-formats.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-add-missing-prototype-and-update-history.patch
menu-fix-embedded-menu-presentation.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
qla2x-fix-printk-format-warnings.patch
lockd-fix-file_locking=n-build-error.patch
xen-use-header-for-export_symbol_gpl.patch
kmap_types-make-most-arches-use-generic-header-file.patch
irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list.patch
cgroups-make-messages-more-readable.patch
linuxpps-core-support.patch
reiser4-export-remove_from_page_cache-fix.patch

