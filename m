From: akpm@linux-foundation.org
Subject: - hugetlbfs-use-lib-parser-fix-docs-fix.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:56:23 -0700
Message-ID: <200707162056.l6GKuNYu002088@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44942 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762771AbXGPVRV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:17:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Lee.Schermerhorn@hp.com, lee.schermerhorn@hp.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     hugetlbfs: handle empty options string
has been removed from the -mm tree.  Its filename was
     hugetlbfs-use-lib-parser-fix-docs-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hugetlbfs: handle empty options string
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

I was seeing a null pointer deref in fs/super.c:vfs_kern_mount().
Some file system get_sb() handler was returning NULL mnt_sb with
a non-negative return value.  I also noticed a "hugetlbfs: Bad
mount option:" message in the log.

Turns out that hugetlbfs_parse_options() was not checking for an
empty option string after call to strsep().  On failure,
hugetlbfs_parse_options() returns 1.  hugetlbfs_fill_super() just
passed this return code back up the call stack where
vfs_kern_mount() missed the error and proceeded with a NULL mnt_sb.

Apparently introduced by patch:
	hugetlbfs-use-lib-parser-fix-docs.patch

The problem was exposed by this line in my fstab:

none        /huge       hugetlbfs   defaults    0 0

It can also be demonstrated by invoking mount of hugetlbfs
directly with no options or a bogus option.

This patch:

1) adds the check for empty option to hugetlbfs_parse_options(),
2) enhances the error message to bracket any unrecognized
   option with quotes ,
3) modifies hugetlbfs_parse_options() to return -EINVAL on any
   unrecognized option,
4) adds a BUG_ON() to vfs_kern_mount() to catch any get_sb()
   handler that returns a NULL mnt->mnt_sb with a return value
   >= 0.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    8 +++++---
 fs/super.c           |    1 +
 2 files changed, 6 insertions(+), 3 deletions(-)

diff -puN fs/hugetlbfs/inode.c~hugetlbfs-use-lib-parser-fix-docs-fix fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlbfs-use-lib-parser-fix-docs-fix
+++ a/fs/hugetlbfs/inode.c
@@ -621,6 +621,8 @@ hugetlbfs_parse_options(char *options, s
 
 	while ((p = strsep(&options, ",")) != NULL) {
 		int token;
+		if (!*p)
+			continue;
 
 		token = match_token(p, tokens, args);
 		switch (token) {
@@ -665,8 +667,9 @@ hugetlbfs_parse_options(char *options, s
 			break;
 
 		default:
-			printk(KERN_ERR "hugetlbfs: Bad mount option: %s\n", p);
- 			return 1;
+			printk(KERN_ERR "hugetlbfs: Bad mount option: \"%s\"\n",
+				 p);
+			return -EINVAL;
 			break;
 		}
 	}
@@ -693,7 +696,6 @@ hugetlbfs_fill_super(struct super_block 
 	config.gid = current->fsgid;
 	config.mode = 0755;
 	ret = hugetlbfs_parse_options(data, &config);
-
 	if (ret)
 		return ret;
 
diff -puN fs/super.c~hugetlbfs-use-lib-parser-fix-docs-fix fs/super.c
--- a/fs/super.c~hugetlbfs-use-lib-parser-fix-docs-fix
+++ a/fs/super.c
@@ -884,6 +884,7 @@ vfs_kern_mount(struct file_system_type *
 	error = type->get_sb(type, flags, name, data, mnt);
 	if (error < 0)
 		goto out_free_secdata;
+	BUG_ON(!mnt->mnt_sb);
 
  	error = security_sb_kern_mount(mnt->mnt_sb, secdata);
  	if (error)
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

origin.patch
