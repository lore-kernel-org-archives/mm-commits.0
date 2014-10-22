From: akpm@linux-foundation.org
Subject: + ncpfs-return-proper-error-from-ncp_ioc_setroot-ioctl.patch
 added to -mm tree
Date: Wed, 22 Oct 2014 14:00:02 -0700
Message-ID: <54481ad2.ANVGsU8xJup8KjMx%akpm__4287.34881938926$1414011623$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57810 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932270AbaJVVAH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Oct 2014 17:00:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, petr@vandrovec.name, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ncpfs: return proper error from NCP_IOC_SETROOT ioctl
has been added to the -mm tree.  Its filename is
     ncpfs-return-proper-error-from-ncp_ioc_setroot-ioctl.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ncpfs-return-proper-error-from-ncp_ioc_setroot-ioctl.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ncpfs-return-proper-error-from-ncp_ioc_setroot-ioctl.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
bitmap-fix-undefined-shift-in-__bitmap_shift_leftright.patch
fallocate-create-fan_modify-and-in_modify-events.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
ocfs2-fix-xattr-check-in-ocfs2_get_xattr_nolock.patch
ocfs2-remove-bogus-test-from-ocfs2_read_locked_inode.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
ncpfs-return-proper-error-from-ncp_ioc_setroot-ioctl.patch
mm-add-strictlimit-knob-v2.patch

