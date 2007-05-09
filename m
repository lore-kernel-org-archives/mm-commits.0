From: akpm@linux-foundation.org
Subject: - drivers-mdc-use-array_size-macro-when-appropriate.patch removed from -mm tree
Date: Wed, 09 May 2007 14:54:50 -0700
Message-ID: <200705092154.l49LsoWm003203@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53543 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757620AbXEIWJR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 18:09:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darwish.07@gmail.com, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     drivers/md.c: Use ARRAY_SIZE macro when appropriate
has been removed from the -mm tree.  Its filename was
     drivers-mdc-use-array_size-macro-when-appropriate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/md.c: Use ARRAY_SIZE macro when appropriate
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

Use ARRAY_SIZE macro already defined in kernel.h

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Acked-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/md/md.c~drivers-mdc-use-array_size-macro-when-appropriate drivers/md/md.c
--- a/drivers/md/md.c~drivers-mdc-use-array_size-macro-when-appropriate
+++ a/drivers/md/md.c
@@ -33,6 +33,7 @@
 */
 
 #include <linux/module.h>
+#include <linux/kernel.h>
 #include <linux/kthread.h>
 #include <linux/linkage.h>
 #include <linux/raid/md.h>
@@ -2637,8 +2638,7 @@ metadata_store(mddev_t *mddev, const cha
 	minor = simple_strtoul(buf, &e, 10);
 	if (e==buf || (*e && *e != '\n') )
 		return -EINVAL;
-	if (major >= sizeof(super_types)/sizeof(super_types[0]) ||
-	    super_types[major].name == NULL)
+	if (major >= ARRAY_SIZE(super_types) || super_types[major].name == NULL)
 		return -ENOENT;
 	mddev->major_version = major;
 	mddev->minor_version = minor;
@@ -4019,7 +4019,7 @@ static int set_array_info(mddev_t * mdde
 	if (info->raid_disks == 0) {
 		/* just setting version number for superblock loading */
 		if (info->major_version < 0 ||
-		    info->major_version >= sizeof(super_types)/sizeof(super_types[0]) ||
+		    info->major_version >= ARRAY_SIZE(super_types) ||
 		    super_types[info->major_version].name == NULL) {
 			/* maybe try to auto-load a module? */
 			printk(KERN_INFO 
_

Patches currently in -mm which might be from darwish.07@gmail.com are

origin.patch
