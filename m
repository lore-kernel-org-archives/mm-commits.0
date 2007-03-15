From: akpm@linux-foundation.org
Subject: - uml-hostfs-fix-double-free.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:55:54 -0800
Message-ID: <200703152155.l2FLtsX4027505@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42233 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbXCOV4H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 17:56:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: blaisorblade@yahoo.it, jdike@addtoit.com, wstearns@pobox.com, mm-commits@vger.kernel.org


The patch titled
     uml: hostfs: fix double free
has been removed from the -mm tree.  Its filename was
     uml-hostfs-fix-double-free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: hostfs: fix double free
From: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>

Fix double free in the error path - when name is assigned into root_inode we
do not own it any more and we must not kfree() it - see patch for details.

Thanks to William Stearns for the initial report.

CC: William Stearns <wstearns@pobox.com>
Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Acked-by: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hostfs/hostfs_kern.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/hostfs/hostfs_kern.c~uml-hostfs-fix-double-free fs/hostfs/hostfs_kern.c
--- a/fs/hostfs/hostfs_kern.c~uml-hostfs-fix-double-free
+++ a/fs/hostfs/hostfs_kern.c
@@ -966,6 +966,9 @@ static int hostfs_fill_sb_common(struct 
 		goto out_put;
 
 	HOSTFS_I(root_inode)->host_filename = name;
+	/* Avoid that in the error path, iput(root_inode) frees again name through
+	 * hostfs_destroy_inode! */
+	name = NULL;
 
 	err = -ENOMEM;
 	sb->s_root = d_alloc_root(root_inode);
@@ -977,7 +980,7 @@ static int hostfs_fill_sb_common(struct 
                 /* No iput in this case because the dput does that for us */
                 dput(sb->s_root);
                 sb->s_root = NULL;
-		goto out_free;
+		goto out;
         }
 
 	return(0);
_

Patches currently in -mm which might be from blaisorblade@yahoo.it are

origin.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
uml-fix-prototypes.patch
git-gccbug.patch
