From: akpm@linux-foundation.org
Subject: + vfs-mountinfo-mm-fix.patch added to -mm tree
Date: Thu, 13 Mar 2008 15:50:38 -0700
Message-ID: <200803132250.m2DMocWJ004532@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50412 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756687AbYCMW43 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Mar 2008 18:56:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, haveblue@us.ibm.com, hch@lst.de, linuxram@us.ibm.com, viro@zeniv.linux.org.uk


The patch titled
     vfs: mountinfo -mm fix
has been added to the -mm tree.  Its filename is
     vfs-mountinfo-mm-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: mountinfo -mm fix
From: Miklos Szeredi <mszeredi@suse.cz>

The read-only flag showing got broken by the ro-bind patches going in
and out of -mm.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/namespace.c~vfs-mountinfo-mm-fix fs/namespace.c
--- a/fs/namespace.c~vfs-mountinfo-mm-fix
+++ a/fs/namespace.c
@@ -800,9 +800,9 @@ static int show_mountinfo(struct seq_fil
 	seq_dentry(m, mnt->mnt_root, " \t\n\\");
 	seq_putc(m, ' ');
 	seq_path(m, &mnt_path, " \t\n\\");
+	seq_puts(m, mnt->mnt_flags & MNT_READONLY ? " ro" : " rw");
 	show_mnt_opts(m, mnt);
-	seq_putc(m, ' ');
-	seq_puts(m, __mnt_is_readonly(mnt) ? " ro" : " rw");
+	seq_puts(m, sb->s_flags & MS_RDONLY ? " ro" : " rw");
 	show_sb_opts(m, sb);
 	if (sb->s_op->show_options)
 		err = sb->s_op->show_options(m, mnt);
_

Patches currently in -mm which might be from mszeredi@suse.cz are

vfs-create-proc-pid-mountinfo.patch
vfs-mountinfo-mm-fix.patch
vfs-pnode-cleanup.patch
vfs-mountinfo-stable-peer-group-id.patch
vfs-mountinfo-show-dominating-group-id.patch
vfs-optimization-to-proc-pid-mountinfo-patch.patch
vfs-mountinfo-only-show-mounts-under-tasks-root.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-2.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-3.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-4.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs-fix.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse-fix.patch
mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit-fix.patch
mm-bdi-move-statistics-to-debugfs.patch

