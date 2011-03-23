From: akpm@linux-foundation.org
Subject: [merged] sys_swapon-move-setting-of-error-nearer-use.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:37:28 -0700
Message-ID: <201103232041.p2NKf4a7028598@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33216 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933396Ab1CWUln (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:41:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, emunson@mgebm.net, hughd@google.com, jj@chaosbits.net, kamezawa.hiroyu@jp.fujitsu.com, penberg@kernel.org, mm-commits@vger.kernel.org


The patch titled
     sys_swapon: move setting of error nearer use
has been removed from the -mm tree.  Its filename was
     sys_swapon-move-setting-of-error-nearer-use.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sys_swapon: move setting of error nearer use
From: Cesar Eduardo Barros <cesarb@cesarb.net>

Move the setting of the error variable nearer the goto in a few places.

Avoids calling PTR_ERR() if not IS_ERR() in two places, and makes the
error condition more explicit in two other places.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
Reviewed-by: Jesper Juhl <jj@chaosbits.net>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN mm/swapfile.c~sys_swapon-move-setting-of-error-nearer-use mm/swapfile.c
--- a/mm/swapfile.c~sys_swapon-move-setting-of-error-nearer-use
+++ a/mm/swapfile.c
@@ -1916,14 +1916,14 @@ SYSCALL_DEFINE2(swapon, const char __use
 		return PTR_ERR(p);
 
 	name = getname(specialfile);
-	error = PTR_ERR(name);
 	if (IS_ERR(name)) {
+		error = PTR_ERR(name);
 		name = NULL;
 		goto bad_swap_2;
 	}
 	swap_file = filp_open(name, O_RDWR|O_LARGEFILE, 0);
-	error = PTR_ERR(swap_file);
 	if (IS_ERR(swap_file)) {
+		error = PTR_ERR(swap_file);
 		swap_file = NULL;
 		goto bad_swap_2;
 	}
@@ -1932,17 +1932,17 @@ SYSCALL_DEFINE2(swapon, const char __use
 	mapping = swap_file->f_mapping;
 	inode = mapping->host;
 
-	error = -EBUSY;
 	for (i = 0; i < nr_swapfiles; i++) {
 		struct swap_info_struct *q = swap_info[i];
 
 		if (q == p || !q->swap_file)
 			continue;
-		if (mapping == q->swap_file->f_mapping)
+		if (mapping == q->swap_file->f_mapping) {
+			error = -EBUSY;
 			goto bad_swap;
+		}
 	}
 
-	error = -EINVAL;
 	if (S_ISBLK(inode->i_mode)) {
 		bdev = bdgrab(I_BDEV(inode));
 		error = blkdev_get(bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL,
@@ -1966,6 +1966,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 			goto bad_swap;
 		}
 	} else {
+		error = -EINVAL;
 		goto bad_swap;
 	}
 
_

Patches currently in -mm which might be from cesarb@cesarb.net are

origin.patch

