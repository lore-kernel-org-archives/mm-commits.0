From: akpm@linux-foundation.org
Subject: + sysfs-use-standard-magich-for-sysfs.patch added to -mm tree
Date: Thu, 15 Jan 2009 15:55:58 -0800
Message-ID: <200901152355.n0FNtwkS023783@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60211 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753841AbZAOX4B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Jan 2009 18:56:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: qhfeng.kernel@gmail.com, greg@kroah.com


The patch titled
     sysfs: use standard magic.h for sysfs
has been added to the -mm tree.  Its filename is
     sysfs-use-standard-magich-for-sysfs.patch

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

btrfs-squashfs-move-btrfs-and-squashfstos-magic-number-to-linux-magich.patch
linux-next.patch
sysfs-use-standard-magich-for-sysfs.patch

