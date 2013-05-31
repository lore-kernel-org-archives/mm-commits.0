From: akpm@linux-foundation.org
Subject: +
 ocfs2-should-not-use-le32_add_cpu-to-set-ocfs2_dinode-i_flags.patch added
 to -mm tree
Date: Fri, 31 May 2013 15:25:39 -0700
Message-ID: <51a92363.I89AXMSQekF4CWbt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40984 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757821Ab3EaWZk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 May 2013 18:25:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, shencanquan@huawei.com, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, joseph.qi@huawei.com

Subject: + ocfs2-should-not-use-le32_add_cpu-to-set-ocfs2_dinode-i_flags.patch added to -mm tree
To: joseph.qi@huawei.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,shencanquan@huawei.com
From: akpm@linux-foundation.org
Date: Fri, 31 May 2013 15:25:39 -0700


The patch titled
     Subject: ocfs2: should not use le32_add_cpu to set ocfs2_dinode i_flags
has been added to the -mm tree.  Its filename is
     ocfs2-should-not-use-le32_add_cpu-to-set-ocfs2_dinode-i_flags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: should not use le32_add_cpu to set ocfs2_dinode i_flags

If we use le32_add_cpu to set ocfs2_dinode i_flags, it may lead to the
corresponding flag corrupted.  So we should change it to bitwise and/or
operation.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: shencanquan <shencanquan@huawei.com
Reviewed-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/ocfs2/namei.c~ocfs2-should-not-use-le32_add_cpu-to-set-ocfs2_dinode-i_flags fs/ocfs2/namei.c
--- a/fs/ocfs2/namei.c~ocfs2-should-not-use-le32_add_cpu-to-set-ocfs2_dinode-i_flags
+++ a/fs/ocfs2/namei.c
@@ -522,7 +522,7 @@ static int __ocfs2_mknod_locked(struct i
 
 	fe->i_last_eb_blk = 0;
 	strcpy(fe->i_signature, OCFS2_INODE_SIGNATURE);
-	le32_add_cpu(&fe->i_flags, OCFS2_VALID_FL);
+	fe->i_flags |= cpu_to_le32(OCFS2_VALID_FL);
 	fe->i_atime = fe->i_ctime = fe->i_mtime =
 		cpu_to_le64(CURRENT_TIME.tv_sec);
 	fe->i_mtime_nsec = fe->i_ctime_nsec = fe->i_atime_nsec =
@@ -2044,7 +2044,7 @@ static int ocfs2_orphan_add(struct ocfs2
 		goto leave;
 	}
 
-	le32_add_cpu(&fe->i_flags, OCFS2_ORPHANED_FL);
+	fe->i_flags |= cpu_to_le32(OCFS2_ORPHANED_FL);
 	OCFS2_I(inode)->ip_flags &= ~OCFS2_INODE_SKIP_ORPHAN_DIR;
 
 	/* Record which orphan dir our inode now resides
@@ -2434,7 +2434,7 @@ int ocfs2_mv_orphaned_inode_to_new(struc
 	}
 
 	di = (struct ocfs2_dinode *)di_bh->b_data;
-	le32_add_cpu(&di->i_flags, -OCFS2_ORPHANED_FL);
+	di->i_flags &= ~cpu_to_le32(OCFS2_ORPHANED_FL);
 	di->i_orphaned_slot = 0;
 	set_nlink(inode, 1);
 	ocfs2_set_links_count(di, inode->i_nlink);
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

fs-ocfs2-dlm-dlmrecoveryc-remove-duplicate-declarations.patch
fs-ocfs2-dlm-dlmrecoveryc-dlm_request_all_locks-ret-should-be-int-instead-of-enum.patch
ocfs2-should-not-use-le32_add_cpu-to-set-ocfs2_dinode-i_flags.patch

