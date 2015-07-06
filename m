From: akpm@linux-foundation.org
Subject: [obsolete]
 fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch removed from -mm tree
Date: Mon, 06 Jul 2015 12:45:36 -0700
Message-ID: <559adae0.gTRd/knTmzeYJCMb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59351 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339AbbGFTph (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:45:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, joe@perches.com, rostedt@goodmis.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: nsfs: fix for seq_printf() API change
has been removed from the -mm tree.  Its filename was
     fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: nsfs: fix for seq_printf() API change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Joe Perches <joe@perches.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nsfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/nsfs.c~fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix fs/nsfs.c
--- a/fs/nsfs.c~fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix
+++ a/fs/nsfs.c
@@ -142,7 +142,8 @@ static int nsfs_show_path(struct seq_fil
 	struct inode *inode = d_inode(dentry);
 	const struct proc_ns_operations *ns_ops = dentry->d_fsdata;
 
-	return seq_printf(seq, "%s:[%lu]", ns_ops->name, inode->i_ino);
+	seq_printf(seq, "%s:[%lu]", ns_ops->name, inode->i_ino);
+	return 0;
 }
 
 static const struct super_operations nsfs_ops = {
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

userfaultfd-uapi-add-missing-include-typesh.patch
userfaultfd-activate-syscall-fix.patch
linux-next.patch
kernel-forkc-export-kernel_thread-to-modules.patch

