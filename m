From: akpm@linux-foundation.org
Subject: + ocfs2-fix-a-tiny-case-that-inode-can-not-removed.patch added to -mm tree
Date: Mon, 31 Aug 2015 13:05:28 -0700
Message-ID: <55e4b388.1ZmpW8p9io9+5h1g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49818 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbbHaUF3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 31 Aug 2015 16:05:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiangyiwen@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.com, xuejiufei@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix a tiny case that inode can not removed
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
From: Yiwen Jiang <jiangyiwen@huawei.com>
Subject: ocfs2: fix a tiny case that inode can not removed

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
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Xue jiufei <xuejiufei@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/ocfs2/namei.c~ocfs2-fix-a-tiny-case-that-inode-can-not-removed fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-fix-a-tiny-case-that-inode-can-not-removed
+++ a/fs/ocfs2/namei.c
@@ -1284,6 +1284,11 @@ static int ocfs2_rename(struct inode *ol
 	}
 	parents_locked = 1;
 
+	if (!new_dir->i_nlink) {
+		status = -EACCES;
+		goto bail;
+	}
+
 	/* make sure both dirs have bhs
 	 * get an extra ref on old_dir_bh if old==new */
 	if (!new_dir_bh) {
_

Patches currently in -mm which might be from jiangyiwen@huawei.com are

ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed.patch
ocfs2-fix-a-tiny-case-that-inode-can-not-removed.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch

