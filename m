From: akpm@linux-foundation.org
Subject: - nommu-add-support-for-direct-mapping-through-mtdconcat.patch removed from -mm tree
Date: Fri, 14 Sep 2007 04:47:28 -0700
Message-ID: <200709141147.l8EBlS33003173@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54169 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754122AbXINLrt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 07:47:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, gavinl@compacsort.com, mm-commits@vger.kernel.org


The patch titled
     NOMMU: add support for direct mapping through mtdconcat if possible
has been removed from the -mm tree.  Its filename was
     nommu-add-support-for-direct-mapping-through-mtdconcat.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: NOMMU: add support for direct mapping through mtdconcat if possible
From: David Howells <dhowells@redhat.com>

Add support for direct mapping through mtdconcat, if possible, by attaching
the samebacking_dev_info structure to the master.

It has some restrictions:

 (1) It won't permit direct mapping of concatenated devices that have differing
     BDIs.

 (2) It doesn't support maps that span the 'gap' between devices, although it
     possibly could if the devices spanned across return compatible
     (ie. contiguous) addresses from their get_unmapped_area() ops.

Signed-off-by: Gavin Lambert <gavinl@compacsort.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/mtdconcat.c |   47 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 47 insertions(+)

diff -puN drivers/mtd/mtdconcat.c~nommu-add-support-for-direct-mapping-through-mtdconcat drivers/mtd/mtdconcat.c
--- a/drivers/mtd/mtdconcat.c~nommu-add-support-for-direct-mapping-through-mtdconcat
+++ a/drivers/mtd/mtdconcat.c
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/sched.h>
 #include <linux/types.h>
+#include <linux/backing-dev.h>
 
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/concat.h>
@@ -686,6 +687,40 @@ static int concat_block_markbad(struct m
 }
 
 /*
+ * try to support NOMMU mmaps on concatenated devices
+ * - we don't support subdev spanning as we can't guarantee it'll work
+ */
+static unsigned long concat_get_unmapped_area(struct mtd_info *mtd,
+					      unsigned long len,
+					      unsigned long offset,
+					      unsigned long flags)
+{
+	struct mtd_concat *concat = CONCAT(mtd);
+	int i;
+
+	for (i = 0; i < concat->num_subdev; i++) {
+		struct mtd_info *subdev = concat->subdev[i];
+
+		if (offset >= subdev->size) {
+			offset -= subdev->size;
+			continue;
+		}
+
+		/* we've found the subdev over which the mapping will reside */
+		if (offset + len > subdev->size)
+			return (unsigned long) -EINVAL;
+
+		if (subdev->get_unmapped_area)
+			return subdev->get_unmapped_area(subdev, len, offset,
+							 flags);
+
+		break;
+	}
+
+	return (unsigned long) -ENOSYS;
+}
+
+/*
  * This function constructs a virtual MTD device by concatenating
  * num_devs MTD devices. A pointer to the new device object is
  * stored to *new_dev upon success. This function does _not_
@@ -741,6 +776,8 @@ struct mtd_info *mtd_concat_create(struc
 
 	concat->mtd.ecc_stats.badblocks = subdev[0]->ecc_stats.badblocks;
 
+	concat->mtd.backing_dev_info = subdev[0]->backing_dev_info;
+
 	concat->subdev[0] = subdev[0];
 
 	for (i = 1; i < num_devs; i++) {
@@ -767,6 +804,15 @@ struct mtd_info *mtd_concat_create(struc
 				concat->mtd.flags |=
 				    subdev[i]->flags & MTD_WRITEABLE;
 		}
+
+		/* only permit direct mapping if the BDIs are all the same
+		 * - copy-mapping is still permitted
+		 */
+		if (concat->mtd.backing_dev_info !=
+		    subdev[i]->backing_dev_info)
+			concat->mtd.backing_dev_info =
+				&default_backing_dev_info;
+
 		concat->mtd.size += subdev[i]->size;
 		concat->mtd.ecc_stats.badblocks +=
 			subdev[i]->ecc_stats.badblocks;
@@ -797,6 +843,7 @@ struct mtd_info *mtd_concat_create(struc
 	concat->mtd.unlock = concat_unlock;
 	concat->mtd.suspend = concat_suspend;
 	concat->mtd.resume = concat_resume;
+	concat->mtd.get_unmapped_area = concat_get_unmapped_area;
 
 	/*
 	 * Combine the erase block size info of the subdevices:
_

Patches currently in -mm which might be from dhowells@redhat.com are

mntput-called-before-dput-in-afs.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
remove-frv-usage-of-flush_tlb_pgtables.patch
include-asm-frv-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
frv-cleanup-struct-irqaction-initializers.patch
fs-afs-possible-cleanups.patch
binfmt_flat-warning-fixes.patch
ecryptfs-add-key-list-structure-search-keyring.patch
64-bit-i_version-afs-fixes.patch
bitops-introduce-lock-ops.patch
mutex-subsystem-synchro-test-module.patch
