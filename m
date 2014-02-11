From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly.patch removed from -mm
 tree
Date: Tue, 11 Feb 2014 11:23:38 -0800
Message-ID: <52fa78ba.fd3wdPf0rYi0N9gm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40891 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935AbaBKTXj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Feb 2014 14:23:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, younger.liucn@gmail.com

Subject: [merged] ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly.patch removed from -mm tree
To: younger.liucn@gmail.com,jlbec@evilplan.org,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 11 Feb 2014 11:23:38 -0800


The patch titled
     Subject: ocfs2: fix ocfs2_sync_file() if filesystem is readonly
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Younger Liu <younger.liucn@gmail.com>
Subject: ocfs2: fix ocfs2_sync_file() if filesystem is readonly

If filesystem is readonly, there is no need to flush drive's caches or
force any uncommitted transactions.

[akpm@linux-foundation.org: return -EROFS, not 0]
Signed-off-by: Younger Liu <younger.liucn@gmail.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/ocfs2/file.c~ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly
+++ a/fs/ocfs2/file.c
@@ -185,6 +185,9 @@ static int ocfs2_sync_file(struct file *
 			      file->f_path.dentry->d_name.name,
 			      (unsigned long long)datasync);
 
+	if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))
+		return -EROFS;
+
 	err = filemap_write_and_wait_range(inode->i_mapping, start, end);
 	if (err)
 		return err;
_

Patches currently in -mm which might be from younger.liucn@gmail.com are

origin.patch

