From: akpm@linux-foundation.org
Subject: + ocfs2-fix-a-tiny-case-that-inode-can-not-removed.patch added to -mm tree
Date: Tue, 03 Mar 2015 13:29:30 -0800
Message-ID: <54f627ba.zFhJ4vVDewhsfboY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35944 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756407AbbCCV3b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Mar 2015 16:29:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiangyiwen@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix a tiny case that inode can not removed.
has been added to the -mm tree.  Its filename is
     ocfs2-fix-a-tiny-case-that-inode-can-not-removed.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-a-tiny-case-that-inode-can-not-removed.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-a-tiny-case-that-inode-can-not-removed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: jiangyiwen <jiangyiwen@huawei.com>
Subject: ocfs2: fix a tiny case that inode can not removed.

When running dirop_fileop_racer we found a case that inode
can not removed.

2 nodes, say Node A and Node B, mount the same ocfs2 volume. Create
two dirs /race/1/ and /race/2/ in the filesystem.

Node A                            Node B
rm -r /race/2/
                                  mv /race/1/ /race/2/
call ocfs2_unlink(), get
the EX mode of /race/2/
                                  wait for B unlock /race/2/
decrease i_nlink of /race/2/ to 0,
and add inode of /race/2/ into
orphan dir, unlock /race/2/
                                  got EX mode of /race/2/. because
                                  /race/1/ is dir, so inc i_nlink
                                  of /race/2/ and update into disk,
                                  unlock /race/2/
because i_nlink of /race/2/
is not zero, this inode will
always remain in orphan dir

This patch fixes this case by test whether i_nlink of new dir is zero.

Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN fs/ocfs2/namei.c~ocfs2-fix-a-tiny-case-that-inode-can-not-removed fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-fix-a-tiny-case-that-inode-can-not-removed
+++ a/fs/ocfs2/namei.c
@@ -1291,6 +1291,15 @@ static int ocfs2_rename(struct inode *ol
 	}
 	parents_locked = 1;
 
+	if (!new_dir->i_nlink) {
+		mlog(ML_ERROR, "new dir %llu has been removed, inode %llu "
+				"can not be moved into it.",
+				(unsigned long long)new_dir->i_ino,
+				(unsigned long long)old_inode->i_ino);
+		status = -EACCES;
+		goto bail;
+	}
+
 	/* make sure both dirs have bhs
 	 * get an extra ref on old_dir_bh if old==new */
 	if (!new_dir_bh) {
_

Patches currently in -mm which might be from jiangyiwen@huawei.com are

ocfs2-do-not-use-ocfs2_zero_extend-during-direct-io.patch
ocfs2-fix-a-tiny-case-that-inode-can-not-removed.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages-v3.patch

