From: akpm@linux-foundation.org
Subject: - fuse-fix-uninitialized-field-in-fuse_inode.patch removed from -mm tree
Date: Fri, 30 Nov 2007 16:22:54 -0800
Message-ID: <200712010022.lB10MsEO031954@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34905 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757166AbXLAA1O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 19:27:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: muirj@nortel.com, mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     fuse: fix uninitialized field in fuse_inode
has been removed from the -mm tree.  Its filename was
     fuse-fix-uninitialized-field-in-fuse_inode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fuse: fix uninitialized field in fuse_inode
From: John Muir <muirj@nortel.com>

I found problems accessing (executing) previously existing files, until
I did chmod on them (or setattr).

If the fi->attr_version is not initialized, then it could be
larger than fc->attr_version until a setattr is executed, and as a
result the inode attributes would never be set.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/inode.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/fuse/inode.c~fuse-fix-uninitialized-field-in-fuse_inode fs/fuse/inode.c
--- a/fs/fuse/inode.c~fuse-fix-uninitialized-field-in-fuse_inode
+++ a/fs/fuse/inode.c
@@ -56,6 +56,7 @@ static struct inode *fuse_alloc_inode(st
 	fi->i_time = 0;
 	fi->nodeid = 0;
 	fi->nlookup = 0;
+	fi->attr_version = 0;
 	INIT_LIST_HEAD(&fi->write_files);
 	fi->forget_req = fuse_request_alloc();
 	if (!fi->forget_req) {
_

Patches currently in -mm which might be from muirj@nortel.com are

origin.patch
