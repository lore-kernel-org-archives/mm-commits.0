From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-reiser4-remove-is_rdonly-checks.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:34:02 -0800
Message-ID: <200702150834.l1F8Y2WM024673@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39527 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965294AbXBOIeZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:34:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hansendc@us.ibm.com, haveblue@us.ibm.com, hch@lst.de, miklos@szeredi.hu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     r/o bind mounts: reiser4: remove IS_RDONLY() checks
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-reiser4-remove-is_rdonly-checks.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: r/o bind mounts: reiser4: remove IS_RDONLY() checks
From: Dave Hansen <hansendc@us.ibm.com>

This removes all reiser4 users of IS_RDONLY() except for some assert()s, and
reiser4_update_sd().

reiser4_update_sd()'s use appears pretty confined to places already covered by
vfs calls which have already bumped the mnt writer count.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/file/file.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/reiser4/plugin/file/file.c~r-o-bind-mounts-reiser4-remove-is_rdonly-checks fs/reiser4/plugin/file/file.c
--- a/fs/reiser4/plugin/file/file.c~r-o-bind-mounts-reiser4-remove-is_rdonly-checks
+++ a/fs/reiser4/plugin/file/file.c
@@ -1815,7 +1815,8 @@ int mmap_unix_file(struct file *file, st
 	down(&uf_info->write);
 	get_exclusive_access(uf_info);
 
-	if (!IS_RDONLY(inode) && (vma->vm_flags & (VM_MAYWRITE | VM_SHARED))) {
+	if (!__mnt_is_readonly(file->f_vfsmnt) &&
+	    (vma->vm_flags & (VM_MAYWRITE | VM_SHARED))) {
 		/*
 		 * we need file built of extent items. If it is still built of
 		 * tail items we have to convert it. Find what items the file
_

Patches currently in -mm which might be from hansendc@us.ibm.com are

r-o-bind-mounts-reiser4-remove-is_rdonly-checks.patch
