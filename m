From: akpm@linux-foundation.org
Subject: + fuse-fix-uninitialized-field-in-fuse_inode.patch added to -mm tree
Date: Thu, 15 Nov 2007 19:27:17 -0800
Message-ID: <200711160327.lAG3RHOR030787@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41584 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756362AbXKPD1i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 22:27:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: muirj@nortel.com, mszeredi@suse.cz


The patch titled
     fuse: fix uninitialized field in fuse_inode
has been added to the -mm tree.  Its filename is
     fuse-fix-uninitialized-field-in-fuse_inode.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

fuse-fix-uninitialized-field-in-fuse_inode.patch
