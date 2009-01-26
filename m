From: akpm@linux-foundation.org
Subject: [merged] sysfs-use-standard-magich-for-sysfs.patch removed from -mm tree
Date: Mon, 26 Jan 2009 11:04:05 -0800
Message-ID: <200901261904.n0QJ454I029516@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37538 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753558AbZAZTEh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jan 2009 14:04:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qhfeng.kernel@gmail.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     sysfs: use standard magic.h for sysfs
has been removed from the -mm tree.  Its filename was
     sysfs-use-standard-magich-for-sysfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysfs: use standard magic.h for sysfs
From: Qinghuang Feng <qhfeng.kernel@gmail.com>

SYSFS_MAGIC has been added into magic.h, so only use that definition in
magic.h to avoid potential consistency problem.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/mount.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/sysfs/mount.c~sysfs-use-standard-magich-for-sysfs fs/sysfs/mount.c
--- a/fs/sysfs/mount.c~sysfs-use-standard-magich-for-sysfs
+++ a/fs/sysfs/mount.c
@@ -17,11 +17,10 @@
 #include <linux/pagemap.h>
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/magic.h>
 
 #include "sysfs.h"
 
-/* Random magic number */
-#define SYSFS_MAGIC 0x62656572
 
 static struct vfsmount *sysfs_mount;
 struct super_block * sysfs_sb = NULL;
_

Patches currently in -mm which might be from qhfeng.kernel@gmail.com are

linux-next.patch

