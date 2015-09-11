From: akpm@linux-foundation.org
Subject: [folded-merged]
 fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch removed from -mm tree
Date: Fri, 11 Sep 2015 13:03:55 -0700
Message-ID: <55f333ab./rP5kvu37jRNahYo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37651 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbbIKUDz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 16:03:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, rostedt@goodmis.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix
has been removed from the -mm tree.  Its filename was
     fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch

This patch was dropped because it was folded into fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix

Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Joe Perches <joe@perches.com>
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

Patches currently in -mm which might be from akpm@linux-foundation.org are

fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix-fix.patch
revert-ocfs2-dlm-use-list_for_each_entry-instead-of-list_for_each.patch

