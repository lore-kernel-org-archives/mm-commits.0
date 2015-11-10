From: akpm@linux-foundation.org
Subject: [merged] fs-ncpfs-remove-unnecessary-new_valid_dev-check.patch
 removed from -mm tree
Date: Tue, 10 Nov 2015 12:33:36 -0800
Message-ID: <564254a0.0OUO+UPp/qILyri+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34097 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbbKJUdh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Nov 2015 15:33:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bywxiaobai@163.com, axboe@fb.com, dhowells@redhat.com, fabf@skynet.be, jack@suse.cz, petr@vandrovec.name, tj@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ncpfs/dir.c: remove unnecessary new_valid_dev() check
has been removed from the -mm tree.  Its filename was
     fs-ncpfs-remove-unnecessary-new_valid_dev-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yaowei Bai <bywxiaobai@163.com>
Subject: fs/ncpfs/dir.c: remove unnecessary new_valid_dev() check

new_valid_dev() always returns 1, so the !new_valid_dev() check is not
needed.  Remove it.

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Petr Vandrovec <petr@vandrovec.name>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ncpfs/dir.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/ncpfs/dir.c~fs-ncpfs-remove-unnecessary-new_valid_dev-check fs/ncpfs/dir.c
--- a/fs/ncpfs/dir.c~fs-ncpfs-remove-unnecessary-new_valid_dev-check
+++ a/fs/ncpfs/dir.c
@@ -1165,8 +1165,6 @@ out:
 static int ncp_mknod(struct inode * dir, struct dentry *dentry,
 		     umode_t mode, dev_t rdev)
 {
-	if (!new_valid_dev(rdev))
-		return -EINVAL;
 	if (ncp_is_nfs_extras(NCP_SERVER(dir), NCP_FINFO(dir)->volNumber)) {
 		ncp_dbg(1, "mode = 0%ho\n", mode);
 		return ncp_create_new(dir, dentry, mode, rdev, 0);
_

Patches currently in -mm which might be from bywxiaobai@163.com are


