From: akpm@linux-foundation.org
Subject: + quota-improve-inode-list-scanning-in-add_dquot_ref.patch added to -mm tree
Date: Tue, 11 Dec 2007 15:43:22 -0800
Message-ID: <200712112343.lBBNhMPw015138@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36317 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751827AbXLKXn6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Dec 2007 18:43:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, gentuu@gmail.com


The patch titled
     quota: improve inode list scanning in add_dquot_ref()
has been added to the -mm tree.  Its filename is
     quota-improve-inode-list-scanning-in-add_dquot_ref.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: quota: improve inode list scanning in add_dquot_ref()
From: Jan Kara <jack@suse.cz>
Return-Path: <jack+f-111207@suse.cz>
Received: from localhost (bix [127.0.0.1])
	by localhost.localdomain (8.12.10/8.12.10) with ESMTP id lBBDiwI9014494
	for <akpm@localhost>; Tue, 11 Dec 2007 05:44:59 -0800
Received: from imap1.linux-foundation.org [207.189.120.55]
	by localhost with IMAP (fetchmail-6.2.5)
	for akpm@localhost (single-drop); Tue, 11 Dec 2007 05:44:59 -0800 (PST)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org [207.189.120.13])
	by imap1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id lBBDhSt8024635
	for <akpm@imap1.linux-foundation.org>; Tue, 11 Dec 2007 05:43:28 -0800
Received: from duck.suse.cz (styx.suse.cz [82.119.242.94])
	by smtp1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id lBBDhLfs019222
	for <akpm@linux-foundation.org>; Tue, 11 Dec 2007 05:43:22 -0800
Received: by duck.suse.cz (Postfix, from userid 1000)
	id 75DA1251B20; Tue, 11 Dec 2007 14:43:19 +0100 (CET)
Date: Tue, 11 Dec 2007 14:43:19 +0100
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, gentuu@gmail.com
Subject: [PATCH] Improve inode list scanning in add_dquot_ref()
Message-ID: <20071211134319.GB8153@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Received-SPF: none (domain of jack+f-111207@suse.cz does not designate permitted sender hosts)
X-MIMEDefang-Filter: lf$Revision: 1.188 $
X-Scanned-By: MIMEDefang 2.53 on 207.189.120.13
X-Spam-Checker-Version: SpamAssassin 3.0.2 (2004-11-16) on bix
X-Spam-Level: 
X-Spam-Status: No, score=-0.4 required=2.0 tests=AWL autolearn=ham 
	version=3.0.2

  Hi,

  attached patch makes add_dquot_ref() quite faster if used on a life
filesystem. It has survived some testing on my machine but there could be
some subtle races I've missed so please leave it in -mm for a while (not
that I'd think that people use quotas with -mm kernels but at least it
should go into vanilla in -rc1...). Thanks.

								Honza

---
We restarted scan of sb->s_inodes list whenever we had to drop inode_lock in
add_dquot_ref(). This leads to overall quadratic running time and thus
add_dquot_ref() can take several minutes when called on a life filesystem.  We
fix the problem by using the fact that inode cannot be removed from s_inodes
list while we hold a reference to it and thus we can safely restart the scan if
we don't drop the reference. Here we use the fact that inodes freshly added to
s_inodes list are already guaranteed to have quotas properly initialized and
the ordering of inodes on s_inodes list does not change so we cannot skip any
inode.  Thanks goes to Nick <gentuu@gmail.com> for analyzing the problem and
testing the fix.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Nick <gentuu@gmail.com>

diff --git a/fs/dquot.c b/fs/dquot.c
index 2809768..ecea4be 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -696,9 +696,8 @@ static int dqinit_needed(struct inode *inode, int type)
 /* This routine is guarded by dqonoff_mutex mutex */
 static void add_dquot_ref(struct super_block *sb, int type)
 {
-	struct inode *inode;
+	struct inode *inode, *old_inode = NULL;
 
-restart:
 	spin_lock(&inode_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		if (!atomic_read(&inode->i_writecount))
@@ -711,12 +710,20 @@ restart:
 		__iget(inode);
 		spin_unlock(&inode_lock);
 
+		if (old_inode)
+			iput(old_inode);
 		sb->dq_op->initialize(inode, type);
-		iput(inode);
-		/* As we may have blocked we had better restart... */
-		goto restart;
+		/* We hold a reference to 'inode' so it couldn't have been
+		 * removed from s_inodes list while we dropped the inode_lock.
+		 * We cannot iput the inode now as we can be holding the last
+		 * reference and we cannot iput it under inode_lock. So we
+		 * keep the reference and iput it later. */
+		old_inode = inode;
+		spin_lock(&inode_lock);
 	}
 	spin_unlock(&inode_lock);
+	if (old_inode)
+		iput(old_inode);
 }
 
 /* Return 0 if dqput() won't block (note that 1 doesn't necessarily mean blocking) */

Patches currently in -mm which might be from jack@suse.cz are

inotify-send-in_attrib-events-when-link-count-changes.patch
inotify-send-in_attrib-events-when-link-count-changes-fix.patch
quota-improve-inode-list-scanning-in-add_dquot_ref.patch
quota-improve-inode-list-scanning-in-add_dquot_ref-fix.patch
jbd2-fix-assertion-failure-in-fs-jbd2-checkpointc.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext4-from-using-iget-and-read_inode-try.patch
