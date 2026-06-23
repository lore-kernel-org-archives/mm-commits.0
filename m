Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABDE834AB14
	for <mm-commits@vger.kernel.org>; Tue, 23 Jun 2026 19:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782241363; cv=none; b=e9e1Ip2WJ/xxHosjPHzdqjJp20DvQOrgGh29a8gl/dwagb8F1/XnTt/Q6iUT8F6XG4E3EjF5vA+rGddLNmWr+6sgH6Kg53LNr2UgJRLvZdTCZlB7u63kIxKnzmvjR6598Rl3qMckZEacjnVWsB2naQ+0hxHfH4ehTjYvPsmmVUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782241363; c=relaxed/simple;
	bh=h/hTgzNvZ5VRbpyTLevHimUoVNysFg58g/OFkiIyyS0=;
	h=Date:To:From:Subject:Message-Id; b=gioeO43JD4bFtVO+4hZ22lGcrQZrMOYWxDgOHTi4sIFVXPI2X49WYZEuD67GJn4drLMpXc1Bn/ru8YmjsJTScCn4W4PiEPSM19xDmvy56YheW6D4XdYQDdWMNFAfRNnhYvz7VJJVsPeaN+rAMC8oRp5cYqds0be/Ljszl9OgHfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z5A7rHGC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z5A7rHGC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44AD21F000E9;
	Tue, 23 Jun 2026 19:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782241362;
	bh=xsfCKGG9cO9DG2zt8vpSmxUobrd3kS8QImefDfUlzoE=;
	h=Date:To:From:Subject;
	b=Z5A7rHGCzr0SSjvUKqB1sCZsGaAB4kOzXevY2AyLgF9+it0Xn7X5WxXQ3whB1VVbE
	 wQ7m55o3Wh1EaVIQmZu5Hwo+P2ElHK+MMDt/BpKQOhqwRsW4bzOhAJlC8c+iQCnWiu
	 C4hyxlaqsbQg08dRUul6NcFhcqnm9HKcJ6XENAdk=
Date: Tue, 23 Jun 2026 12:02:41 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,kartikey406@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-use-inode_lock_nested-for-orphan-dir-locking.patch added to mm-nonmm-unstable branch
Message-Id: <20260623190242.44AD21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: use inode_lock_nested() for orphan dir locking
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-use-inode_lock_nested-for-orphan-dir-locking.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-use-inode_lock_nested-for-orphan-dir-locking.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

ocfs2-use-inode_lock_nested-for-orphan-dir-locking.patch

