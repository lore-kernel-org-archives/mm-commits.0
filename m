From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-gfs-check-nlink-count.patch removed from -mm tree
Date: Wed, 14 Feb 2007 10:53:03 -0800
Message-ID: <200702141853.l1EIr3mX005770@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39429 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932461AbXBNS4l (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 13:56:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hansendc@us.ibm.com, hch@lst.de, linuxram@us.ibm.com, miklos@szeredi.hu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     r/o bind mounts: [PATCH] gfs: check nlink count
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-gfs-check-nlink-count.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: r/o bind mounts: [PATCH] gfs: check nlink count
From: Dave Hansen <hansendc@us.ibm.com>

Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/inode.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/gfs2/inode.c~r-o-bind-mounts-gfs-check-nlink-count fs/gfs2/inode.c
--- a/fs/gfs2/inode.c~r-o-bind-mounts-gfs-check-nlink-count
+++ a/fs/gfs2/inode.c
@@ -169,6 +169,7 @@ static int gfs2_dinode_in(struct gfs2_in
 	 * to do that.
 	 */
 	ip->i_inode.i_nlink = be32_to_cpu(str->di_nlink);
+	check_nlink(&ip->i_inode);
 	di->di_size = be64_to_cpu(str->di_size);
 	i_size_write(&ip->i_inode, di->di_size);
 	di->di_blocks = be64_to_cpu(str->di_blocks);
_

Patches currently in -mm which might be from hansendc@us.ibm.com are

r-o-bind-mounts-gfs-check-nlink-count.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
r-o-bind-mounts-kill-open-files-traverse-on-remount-ro.patch
