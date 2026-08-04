Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421C841167C
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816286; cv=none; b=bBx6XxfaaxYaxDeotXzeGa01pFk9WpaZuVj89C2zkKF+qx3Qe41E6sIcPXRekqoCuG0ePwo8D4JJqarAI1Rg9IThxVCNv2UhQWi2yW63A4cwDTkbAWF0Rt78tqRSmAILyOmT1NS0yt8JXvV+bDkOVPBX4NOlK8iClFrqZpkKk5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816286; c=relaxed/simple;
	bh=X1hTxFWrs/XNlsDS9l2PduFhXW//K29iTx3T1AjolV4=;
	h=Date:To:From:Subject:Message-Id; b=Qaf6cQRbA158BlQ4QEvXD7+y5RSfEwxzOpaQiBDIpJsun1hycjzRy740w7gDnuOqVY5TXCXlAvuteTbheSVAmq6ysKXQ533XhOZiVwSGQh288vQ98OtLyx1t9uO5huv84aG6ElO/TBFmStGjlA1Ls+HYUG8tmBkZ4lDmWJ8a/UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OcYieaeL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OcYieaeL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9FFE1F000E9;
	Tue,  4 Aug 2026 04:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816284;
	bh=Wh8gcB9K/vhFvFYWPkQN+bssLBwJSPmJYoMbJJU3hlY=;
	h=Date:To:From:Subject;
	b=OcYieaeLvTqqRHNTlfvtFlukPIejufValkE0cPsh2oFf+xId+YbTaw366lP4NgntQ
	 hm/s2qBc2MO6Q4JB7G68cBVv5z1N/Efwmf+Kx5dTd5QXsqWVRuy4KBMHd068T5HQOa
	 KTTtrezIEkO08WtZxq83lOpE3Y5Nf9qO5V9/G9ao=
Date: Mon, 03 Aug 2026 21:04:44 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,kartikey406@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-use-inode_lock_nested-for-orphan-dir-locking.patch removed from -mm tree
Message-Id: <20260804040444.B9FFE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: use inode_lock_nested() for orphan dir locking
has been removed from the -mm tree.  Its filename was
     ocfs2-use-inode_lock_nested-for-orphan-dir-locking.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Deepanshu Kartikey <kartikey406@gmail.com>
Subject: ocfs2: use inode_lock_nested() for orphan dir locking
Date: Sun, 21 Jun 2026 04:42:23 +0530

PREEMPT_RT's rtmutex PI chain walker warns about a lock dependency cycle
when inode_lock(orphan_dir_inode) is called while holding
inode_lock(file_inode):

  ocfs2_file_write_iter()
    inode_lock(file_inode)               [class 0]
      ocfs2_dio_end_io_write()
        ocfs2_del_inode_from_orphan()
          inode_lock(orphan_dir_inode)   [class 0] <- warning!

However this is a false positive.  write_iter() is never called on a
directory, and orphan_dir is always a directory, so these two locks can
never actually conflict in practice.

Fix by using inode_lock_nested(orphan_dir_inode, I_MUTEX_NONDIR2) in all
three places where orphan_dir_inode is locked in namei.c, placing it in a
separate lock class so the rtmutex PI chain walker understands these locks
have distinct roles and does not warn about their ordering.

Link: https://lore.kernel.org/20260620231223.46588-1-kartikey406@gmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Reported-by: syzbot+ce129763ce7d7e914739@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ce129763ce7d7e914739
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/ocfs2/namei.c~ocfs2-use-inode_lock_nested-for-orphan-dir-locking
+++ a/fs/ocfs2/namei.c
@@ -2126,7 +2126,7 @@ static int ocfs2_lookup_lock_orphan_dir(
 		return ret;
 	}
 
-	inode_lock(orphan_dir_inode);
+	inode_lock_nested(orphan_dir_inode, I_MUTEX_NONDIR2);
 
 	ret = ocfs2_inode_lock(orphan_dir_inode, &orphan_dir_bh, 1);
 	if (ret < 0) {
@@ -2725,7 +2725,7 @@ int ocfs2_del_inode_from_orphan(struct o
 		goto bail;
 	}
 
-	inode_lock(orphan_dir_inode);
+	inode_lock_nested(orphan_dir_inode, I_MUTEX_NONDIR2);
 	status = ocfs2_inode_lock(orphan_dir_inode, &orphan_dir_bh, 1);
 	if (status < 0) {
 		inode_unlock(orphan_dir_inode);
@@ -2838,7 +2838,7 @@ int ocfs2_mv_orphaned_inode_to_new(struc
 		goto leave;
 	}
 
-	inode_lock(orphan_dir_inode);
+	inode_lock_nested(orphan_dir_inode, I_MUTEX_NONDIR2);
 
 	status = ocfs2_inode_lock(orphan_dir_inode, &orphan_dir_bh, 1);
 	if (status < 0) {
_

Patches currently in -mm which might be from kartikey406@gmail.com are


