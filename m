From: akpm@linux-foundation.org
Subject: [merged] hfsplus-fix-expand-when-not-enough-available-space.patch removed from -mm tree
Date: Mon, 20 Apr 2015 12:19:16 -0700
Message-ID: <55355134.mAsuUFeN6yx2QfT2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40328 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbbDTTMz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:12:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: saproj@gmail.com, anton@tuxera.com, hch@infradead.org, htl10@users.sourceforge.net, slava@dubeyko.com, sougata@tuxera.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: hfsplus: fix expand when not enough available space
has been removed from the -mm tree.  Its filename was
     hfsplus-fix-expand-when-not-enough-available-space.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergei Antonov <saproj@gmail.com>
Subject: hfsplus: fix expand when not enough available space

Fix a bug which is reproduced as follows. Create a file:

 echo abc > test_file

Try to expand the file beyond available space:

 truncate --size=<size exceeding available space> test_file

Since HFS+ does not support file size > allocated size, truncate should
fail.  However, it ends successfully.  The driver returns success despite
having been unable to allocate the requested space for the file.  Also
filesystem check finds an error:

 Checking catalog file.
 Incorrect size for file test_file
 (It should be 469094400 instead of 1000000000)

Add a piece of code analogous to code in the fat driver.  Now a proper
error is returned and filesystem remains consistent.

Signed-off-by: Sergei Antonov <saproj@gmail.com>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>
Reviewed-by: Anton Altaparmakov <anton@tuxera.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Sougata Santra <sougata@tuxera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/inode.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN fs/hfsplus/inode.c~hfsplus-fix-expand-when-not-enough-available-space fs/hfsplus/inode.c
--- a/fs/hfsplus/inode.c~hfsplus-fix-expand-when-not-enough-available-space
+++ a/fs/hfsplus/inode.c
@@ -254,6 +254,12 @@ static int hfsplus_setattr(struct dentry
 	if ((attr->ia_valid & ATTR_SIZE) &&
 	    attr->ia_size != i_size_read(inode)) {
 		inode_dio_wait(inode);
+		if (attr->ia_size > inode->i_size) {
+			error = generic_cont_expand_simple(inode,
+							   attr->ia_size);
+			if (error)
+				return error;
+		}
 		truncate_setsize(inode, attr->ia_size);
 		hfsplus_file_truncate(inode);
 	}
_

Patches currently in -mm which might be from saproj@gmail.com are

origin.patch

