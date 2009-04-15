From: akpm@linux-foundation.org
Subject: + hugetlbfs-return-negative-error-code-for-bad-mount-option.patch added to -mm tree
Date: Wed, 15 Apr 2009 15:02:09 -0700
Message-ID: <200904152202.n3FM29VD027144@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53063 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751424AbZDOWIa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Apr 2009 18:08:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, stable@kernel.org, wli@holomorphy.com


The patch titled
     hugetlbfs: return negative error code for bad mount option
has been added to the -mm tree.  Its filename is
     hugetlbfs-return-negative-error-code-for-bad-mount-option.patch

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

hugetlbfs-return-negative-error-code-for-bad-mount-option.patch

