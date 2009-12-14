From: akpm@linux-foundation.org
Subject: [wrecked] compat_ioctl-do-not-hold-bkl-in-handlers.patch removed from -mm tree
Date: Mon, 14 Dec 2009 13:09:47 -0800
Message-ID: <200912142109.nBEL9lJf013779@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37128 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932620AbZLNVJ4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 16:09:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     compat_ioctl: do not hold BKL in handlers
has been removed from the -mm tree.  Its filename was
     compat_ioctl-do-not-hold-bkl-in-handlers.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: compat_ioctl: do not hold BKL in handlers
From: Arnd Bergmann <arnd@arndb.de>

We have always called ioctl conversion handlers under the big kernel lock,
although that is generally not necessary.  In particular it is not needed
for conversion of data structures and for calling sys_ioctl or
do_vfs_ioctl, which will get the BKL again if needed.

Handlers doing more than those two have been moved out, so we can kill off
the BKL from compat_sys_ioctl.  This may significantly improve latencies
with 32 bit applications, and it avoids a common scenario where a thread
acquires the BKL twice.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat_ioctl.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/compat_ioctl.c~compat_ioctl-do-not-hold-bkl-in-handlers fs/compat_ioctl.c
--- a/fs/compat_ioctl.c~compat_ioctl-do-not-hold-bkl-in-handlers
+++ a/fs/compat_ioctl.c
@@ -1823,9 +1823,7 @@ asmlinkage long compat_sys_ioctl(unsigne
 
  found_handler:
 	if (t->handler) {
-		lock_kernel();
 		error = t->handler(fd, cmd, arg, filp);
-		unlock_kernel();
 		goto out_fput;
 	}
 
_

Patches currently in -mm which might be from arnd@arndb.de are

origin.patch
linux-next.patch
mm-uncached-vma-support-with-writenotify.patch
compat_ioctl-do-not-hold-bkl-in-handlers.patch
kfifo-move-struct-kfifo-in-place.patch
kfifo-move-out-spinlock.patch
kfifo-cleanup-namespace.patch
kfifo-rename-kfifo_put-into-kfifo_in-and-kfifo_get-into-kfifo_out.patch
kfifo-add-define_kfifo-and-friends-add-very-tiny-functions.patch
kfifo-add-kfifo_skip-kfifo_from_user-and-kfifo_to_user.patch

