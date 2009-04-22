From: akpm@linux-foundation.org
Subject: [merged] hugetlbfs-return-negative-error-code-for-bad-mount-option.patch removed from -mm tree
Date: Wed, 22 Apr 2009 11:29:39 -0700
Message-ID: <200904221829.n3MITdeL005743@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753609AbZDVSfe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Apr 2009 14:35:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, stable@kernel.org, wli@holomorphy.com, mm-commits@vger.kernel.org


The patch titled
     hugetlbfs: return negative error code for bad mount option
has been removed from the -mm tree.  Its filename was
     hugetlbfs-return-negative-error-code-for-bad-mount-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlbfs: return negative error code for bad mount option
From: Akinobu Mita <akinobu.mita@gmail.com>

This fixes the following BUG:

# mount -o size=MM -t hugetlbfs none /huge
hugetlbfs: Bad value 'MM' for mount option 'size=MM'
------------[ cut here ]------------
kernel BUG at fs/super.c:996!

Due to

	BUG_ON(!mnt->mnt_sb);

in vfs_kern_mount().

Also, remove unused #include <linux/quotaops.h>

Cc: William Irwin <wli@holomorphy.com>
Cc: <stable@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/hugetlbfs/inode.c~hugetlbfs-return-negative-error-code-for-bad-mount-option fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlbfs-return-negative-error-code-for-bad-mount-option
+++ a/fs/hugetlbfs/inode.c
@@ -26,7 +26,6 @@
 #include <linux/pagevec.h>
 #include <linux/parser.h>
 #include <linux/mman.h>
-#include <linux/quotaops.h>
 #include <linux/slab.h>
 #include <linux/dnotify.h>
 #include <linux/statfs.h>
@@ -842,7 +841,7 @@ hugetlbfs_parse_options(char *options, s
 bad_val:
  	printk(KERN_ERR "hugetlbfs: Bad value '%s' for mount option '%s'\n",
 	       args[0].from, p);
- 	return 1;
+ 	return -EINVAL;
 }
 
 static int
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch

