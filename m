Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE947361651
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 18:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785522029; cv=none; b=GRfRGNt0w6/1sSxwq+Lj2r9MKP2/G3jtQT2G5/50iZYP3dXVra2VpEVkJFj5nPiu3srdUtUItlX/B1vFcozaY+7jIjF80NON+Iag9mipZfSXjVjwX3pfjDA/tCOuXdWztoTTCXOA/apYy+exnCfU4RADPPOcru3xCFKsfDgZKu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785522029; c=relaxed/simple;
	bh=TDQbT+n18WT337Lb49rW10rpv1uffV0H/2DbtQEwdRE=;
	h=Date:To:From:Subject:Message-Id; b=aGDb7bpB6sLk4TQXN/BvjBAXpVvbh2x6jvag4uOZopieWjWMmr0HyXSwJK+wi9rl5D+FkOQgO+4C2tiJnoWD2807T3CdNSRpMI41Wb63Mj1ygIsK5XcPEg0Genb5m45Sfy8fyn8dmdf17u5NZ+iwO0z95oh00Pi6Rj+JyYstT+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pcVmW7EY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pcVmW7EY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F941F00AC4;
	Fri, 31 Jul 2026 18:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785522028;
	bh=WVcRA3F2y8pdlhmb++QFznZa0AdbaYEfNoPf/6kSS+s=;
	h=Date:To:From:Subject;
	b=pcVmW7EYXedL519rcpAWmlDuuSKAjTGuq0nvkfKi2tQfylaBGk0qMYa/YhPVspgpR
	 qHk7UVNuV7mmRMnKAdBbtw8eB5VPHdoNhIBg3kgmx2eR9RPnr0ZpSmt0aG90t8VK4o
	 vUyXwxUEquE7wW2E9Mbyfn9jkqw66xwB7SfWWkUM=
Date: Fri, 31 Jul 2026 11:20:27 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-circular-locking-dependency-in-reflink.patch added to mm-nonmm-unstable branch
Message-Id: <20260731182028.27F941F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix circular locking dependency in reflink
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-fix-circular-locking-dependency-in-reflink.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-circular-locking-dependency-in-reflink.patch

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
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: fix circular locking dependency in reflink
Date: Fri, 31 Jul 2026 19:34:25 +0800

Lockdep reports a possible deadlock involving ip_alloc_sem,
j_trans_barrier, and ip_xattr_sem:

  Chain exists of:
    &oi->ip_alloc_sem --> &journal->j_trans_barrier --> &oi->ip_xattr_sem

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&oi->ip_xattr_sem);
                                lock(&journal->j_trans_barrier);
                                lock(&oi->ip_xattr_sem);
   lock(&oi->ip_alloc_sem);

  *** DEADLOCK ***

ocfs2_reflink() and ocfs2_try_remove_refcount_tree() acquire ip_xattr_sem
before ip_alloc_sem.  This is the reverse of the established system-wide
ordering where ip_alloc_sem is outer:

  - Write paths (e.g. ocfs2_write_begin_nolock) hold ip_alloc_sem
    and call ocfs2_start_trans(), which takes j_trans_barrier.

  - ocfs2_mknod() calls ocfs2_start_trans() (j_trans_barrier) then
    ocfs2_init_acl(), which takes ip_xattr_sem on the parent dir.

Fix by swapping the lock order in both functions to acquire ip_alloc_sem
before ip_xattr_sem, consistent with the rest of the codebase.

Link: https://lore.kernel.org/20260731113425.4130293-1-joseph.qi@linux.alibaba.com
Fixes: 09bf27a00020 ("ocfs2: Implement ocfs2_reflink.")
Fixes: 8b2c0dba5159 ("ocfs2: Call refcount tree remove process properly.")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reported-by: syzbot+e42eae29bba35810f43c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e42eae29bba35810f43c
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/refcounttree.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/ocfs2/refcounttree.c~ocfs2-fix-circular-locking-dependency-in-reflink
+++ a/fs/ocfs2/refcounttree.c
@@ -955,8 +955,8 @@ int ocfs2_try_remove_refcount_tree(struc
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	struct ocfs2_dinode *di = (struct ocfs2_dinode *)di_bh->b_data;
 
-	down_write(&oi->ip_xattr_sem);
 	down_write(&oi->ip_alloc_sem);
+	down_write(&oi->ip_xattr_sem);
 
 	if (oi->ip_clusters)
 		goto out;
@@ -972,8 +972,8 @@ int ocfs2_try_remove_refcount_tree(struc
 	if (ret)
 		mlog_errno(ret);
 out:
-	up_write(&oi->ip_alloc_sem);
 	up_write(&oi->ip_xattr_sem);
+	up_write(&oi->ip_alloc_sem);
 	return 0;
 }
 
@@ -4292,12 +4292,12 @@ static int ocfs2_reflink(struct dentry *
 		goto out;
 	}
 
-	down_write(&OCFS2_I(inode)->ip_xattr_sem);
 	down_write(&OCFS2_I(inode)->ip_alloc_sem);
+	down_write(&OCFS2_I(inode)->ip_xattr_sem);
 	error = __ocfs2_reflink(old_dentry, old_bh,
 				new_orphan_inode, preserve);
-	up_write(&OCFS2_I(inode)->ip_alloc_sem);
 	up_write(&OCFS2_I(inode)->ip_xattr_sem);
+	up_write(&OCFS2_I(inode)->ip_alloc_sem);
 
 	ocfs2_inode_unlock(inode, 1);
 	ocfs2_rw_unlock(inode, 1);
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-cluster-use-gfp_nofs-for-heartbeat-bio-allocation.patch
ocfs2-cluster-use-an-on-stack-bio-for-the-heartbeat-write.patch
ocfs2-cluster-dont-sleep-while-holding-o2hb_live_lock-in-o2hb_region_pin.patch
ocfs2-cluster-avoid-lock-order-inversion-in-o2hb_region_pin-from-drop_item.patch
ocfs2-cluster-fix-o2hb_dependent_users-leak-on-pin-failure.patch
ocfs2-fix-circular-locking-dependency-in-reflink.patch

