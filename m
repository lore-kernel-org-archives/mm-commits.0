From: akpm@linux-foundation.org
Subject: + nommu-add-support-for-direct-mapping-through-mtdconcat.patch added to -mm tree
Date: Wed, 21 Feb 2007 16:38:47 -0800
Message-ID: <200702220038.l1M0clHa031486@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59673 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932694AbXBVAjE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 19:39:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, gavinl@compacsort.com


The patch titled
     NOMMU: add support for direct mapping through mtdconcat if possible
has been added to the -mm tree.  Its filename is
     nommu-add-support-for-direct-mapping-through-mtdconcat.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -740,6 +775,8 @@ struct mtd_info *mtd_concat_create(struc
 
 	concat->mtd.ecc_stats.badblocks = subdev[0]->ecc_stats.badblocks;
 
+	concat->mtd.backing_dev_info = subdev[0]->backing_dev_info;
+
 	concat->subdev[0] = subdev[0];
 
 	for (i = 1; i < num_devs; i++) {
@@ -766,6 +803,15 @@ struct mtd_info *mtd_concat_create(struc
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
@@ -796,6 +842,7 @@ struct mtd_info *mtd_concat_create(struc
 	concat->mtd.unlock = concat_unlock;
 	concat->mtd.suspend = concat_suspend;
 	concat->mtd.resume = concat_resume;
+	concat->mtd.get_unmapped_area = concat_get_unmapped_area;
 
 	/*
 	 * Combine the erase block size info of the subdevices:
_

Patches currently in -mm which might be from dhowells@redhat.com are

frv-no-zone_dma.patch
frv-add-some-missng-lazy-mmu-hooks-for-nommu-mode.patch
git-cpufreq.patch
drivers-media-video-cpia_ppc-dont-use-_work_nar.patch
nommu-present-backing-device-capabilities-for-mtd.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
nommu-generalise-the-handling-of-mtd-specific-superblocks.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
git-parisc.patch
frv-missing-error-defs.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
kill-net-rxrpc-rxrpc_symsc.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
reiser4-get_sb_dev-fix.patch
mutex-subsystem-synchro-test-module.patch
