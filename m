From: akpm@linux-foundation.org
Subject: [wrecked] ocfs2-add-freeze-protection-to-ocfs2_file_splice_write.patch removed from -mm tree
Date: Mon, 08 Apr 2013 11:55:32 -0700
Message-ID: <20130408185532.9BA4231C123@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:48744 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935047Ab3DHSze (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Apr 2013 14:55:34 -0400
Received: by mail-ob0-f201.google.com with SMTP id uz6so1544467obc.4
        for <mm-commits@vger.kernel.org>; Mon, 08 Apr 2013 11:55:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, jlbec@evilplan.org, marco.stornelli@gmail.com, mfasheh@suse.com, nikola.ciprich@linuxbox.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: add freeze protection to ocfs2_file_splice_write()
has been removed from the -mm tree.  Its filename was
     ocfs2-add-freeze-protection-to-ocfs2_file_splice_write.patch

This patch was dropped because other changes were merged, which wrecked this patch

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: ocfs2: add freeze protection to ocfs2_file_splice_write()

ocfs2_file_splice_write() was missed when adding freeze protection to all
write paths. Fix that.

Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Cc: Marco Stornelli <marco.stornelli@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/ocfs2/file.c~ocfs2-add-freeze-protection-to-ocfs2_file_splice_write fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-add-freeze-protection-to-ocfs2_file_splice_write
+++ a/fs/ocfs2/file.c
@@ -2469,6 +2469,9 @@ static ssize_t ocfs2_file_splice_write(s
 			out->f_path.dentry->d_name.len,
 			out->f_path.dentry->d_name.name, len);
 
+	if (!sb_start_file_write(out))
+		return -EAGAIN;
+
 	if (pipe->inode)
 		mutex_lock_nested(&pipe->inode->i_mutex, I_MUTEX_PARENT);
 
@@ -2507,6 +2510,7 @@ static ssize_t ocfs2_file_splice_write(s
 
 		balance_dirty_pages_ratelimited(mapping);
 	}
+	sb_end_write(inode->i_sb);
 
 	return ret;
 }
_

Patches currently in -mm which might be from jack@suse.cz are

linux-next.patch
direct-io-fix-boundary-block-handling.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix-fix.patch

