From: akpm@linux-foundation.org
Subject: [merged]
 ncpfs-return-proper-error-from-ncp_ioc_setroot-ioctl.patch removed from -mm tree
Date: Thu, 11 Dec 2014 11:05:59 -0800
Message-ID: <5489eb17.35RwuTaz0/y538/j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45726 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758127AbaLKTGB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:06:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, petr@vandrovec.name, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ncpfs: return proper error from NCP_IOC_SETROOT ioctl
has been removed from the -mm tree.  Its filename was
     ncpfs-return-proper-error-from-ncp_ioc_setroot-ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: ncpfs: return proper error from NCP_IOC_SETROOT ioctl

If some error happens in NCP_IOC_SETROOT ioctl, the appropriate error
return value is then (in most cases) just overwritten before we return. 
This can result in reporting success to userspace although error happened.
This bug was introduced by commit 2e54eb96e2c8 ("BKL: Remove BKL from
ncpfs").  Propagate the errors correctly.

Coverity id: 1226925.

Fixes: 2e54eb96e2c80 ("BKL: Remove BKL from ncpfs")
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Petr Vandrovec <petr@vandrovec.name>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ncpfs/ioctl.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/ncpfs/ioctl.c~ncpfs-return-proper-error-from-ncp_ioc_setroot-ioctl fs/ncpfs/ioctl.c
--- a/fs/ncpfs/ioctl.c~ncpfs-return-proper-error-from-ncp_ioc_setroot-ioctl
+++ a/fs/ncpfs/ioctl.c
@@ -447,7 +447,6 @@ static long __ncp_ioctl(struct inode *in
 						result = -EIO;
 					}
 				}
-				result = 0;
 			}
 			mutex_unlock(&server->root_setup_lock);
 
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
befs-remove-dead-code.patch
linux-next.patch
fallocate-create-fan_modify-and-in_modify-events.patch
fsnotify-unify-inode-and-mount-marks-handling.patch
fsnotify-remove-destroy_list-from-fsnotify_mark.patch
mm-add-strictlimit-knob-v2.patch

