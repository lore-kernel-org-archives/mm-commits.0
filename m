From: akpm@linux-foundation.org
Subject: + ocfs2-check-existence-of-old-dentry-in-ocfs2_link.patch added
 to -mm tree
Date: Thu, 26 Dec 2013 14:36:42 -0800
Message-ID: <52bcaf7a.J0OUh2+Vt961XCez%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39190 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab3LZWgn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Dec 2013 17:36:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, xuejiufei@huawei.com

Subject: + ocfs2-check-existence-of-old-dentry-in-ocfs2_link.patch added to -mm tree
To: xuejiufei@huawei.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Thu, 26 Dec 2013 14:36:42 -0800


The patch titled
     Subject: ocfs2: check existence of old dentry in ocfs2_link()
has been added to the -mm tree.  Its filename is
     ocfs2-check-existence-of-old-dentry-in-ocfs2_link.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-check-existence-of-old-dentry-in-ocfs2_link.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-check-existence-of-old-dentry-in-ocfs2_link.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xue jiufei <xuejiufei@huawei.com>
Subject: ocfs2: check existence of old dentry in ocfs2_link()

System call linkat first calls user_path_at(), check the existence of old
dentry, and then calls vfs_link()->ocfs2_link() to do the actual work. 
There may exist a race when Node A create a hard link for file while node
B rm it.

         Node A                          Node B
user_path_at()
  ->ocfs2_lookup(),
find old dentry exist
                                rm file, add inode say inodeA
                                to orphan_dir

call ocfs2_link(),create a
hard link for inodeA.

                                rm the link, add inodeA to orphan_dir
                                again

When orphan_scan work start, it calls ocfs2_queue_orphans() to do the main
work.  It first tranverses entrys in orphan_dir, linking all inodes in
this orphan_dir to a list look like this:

	inodeA->inodeB->...->inodeA

When tranvering this list, it will fall into loop, calling iput() again
and again.  And finally trigger BUG_ON(inode->i_state & I_CLEAR).

Signed-off-by: joyce <xuejiufei@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN fs/ocfs2/namei.c~ocfs2-check-existence-of-old-dentry-in-ocfs2_link fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-check-existence-of-old-dentry-in-ocfs2_link
+++ a/fs/ocfs2/namei.c
@@ -644,6 +644,7 @@ static int ocfs2_link(struct dentry *old
 	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
 	struct ocfs2_dir_lookup_result lookup = { NULL, };
 	sigset_t oldset;
+	u64 old_de_ino;
 
 	trace_ocfs2_link((unsigned long long)OCFS2_I(inode)->ip_blkno,
 			 old_dentry->d_name.len, old_dentry->d_name.name,
@@ -665,6 +666,18 @@ static int ocfs2_link(struct dentry *old
 		err = -ENOENT;
 		goto out;
 	}
+
+	err = ocfs2_lookup_ino_from_name(dir, old_dentry->d_name.name,
+			old_dentry->d_name.len, &old_de_ino);
+	if (err) {
+		err = -ENOENT;
+		goto out;
+	}
+
+	if (old_de_ino != OCFS2_I(inode)->ip_blkno) {
+		err = -ENOENT;
+		goto out;
+	}
 
 	err = ocfs2_check_dir_for_entry(dir, dentry->d_name.name,
 					dentry->d_name.len);
_

Patches currently in -mm which might be from xuejiufei@huawei.com are

ocfs2-check-existence-of-old-dentry-in-ocfs2_link.patch

