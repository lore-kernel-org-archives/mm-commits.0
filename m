Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDDC3264D4
	for <mm-commits@vger.kernel.org>; Wed, 15 Apr 2026 09:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776244624; cv=none; b=azVcPy7O6sQ9bf3QkoD03gC8lAbwhBmDPSfEyArhNo4IatsPgk0M0+kfXEmh0pn0TyUhR5LQU5Yj6aErY2iiOseKdcNqp7rbOYOLdYogRFmXAkoUCPDVv6dgDyeGhFeNNPrvdhStso0IE6edbkzaoHaB1AzH4Ixyi2NdiirIzzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776244624; c=relaxed/simple;
	bh=qwwLWbSSJptDZob8U1fQtk1gfbqJWhhG8uo/0Bmv97I=;
	h=Date:To:From:Subject:Message-Id; b=XI3Vgxgo4NeDa5jdCz0KrhCjmPXgEqSRr+82D0Oeye7D/TfaASiW+tjbKc8nje7KVW8MxQXV/x4tsxup9l90dOfF2p6/X9hVlGrgO7e6pU19ek27jfwcZhbaoomMhHV/rSoqhWW5DbW9LI8fEJL/w+Fs2dq2hfL/BJmNgCDr1hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FW4ZlRS6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FW4ZlRS6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288F5C19424;
	Wed, 15 Apr 2026 09:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776244624;
	bh=qwwLWbSSJptDZob8U1fQtk1gfbqJWhhG8uo/0Bmv97I=;
	h=Date:To:From:Subject:From;
	b=FW4ZlRS6wKdrX6WzjQUiItoA7a6mD27sycirgUo2cbeYisTHf1dywBhrPCZT8R8ZJ
	 HGQGiBvgMy4FBGwpgCmVHqIuds74JfIU+yumcKUWfNhwnV4ZvrbRBZwvwybh6oGWeN
	 2a3i+R4Vc//ADL/Z3+dZ4TyqnkvC8bDdz0f+30TM=
Date: Wed, 15 Apr 2026 02:17:01 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,gality369@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-validate-group-add-input-before-caching.patch removed from -mm tree
Message-Id: <20260415091704.288F5C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: validate group add input before caching
has been removed from the -mm tree.  Its filename was
     ocfs2-validate-group-add-input-before-caching.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ZhengYuan Huang <gality369@gmail.com>
Subject: ocfs2: validate group add input before caching
Date: Fri, 10 Apr 2026 10:02:08 +0800

[BUG]
OCFS2_IOC_GROUP_ADD can trigger a BUG_ON in
ocfs2_set_new_buffer_uptodate():

kernel BUG at fs/ocfs2/uptodate.c:509!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
RIP: 0010:ocfs2_set_new_buffer_uptodate+0x194/0x1e0 fs/ocfs2/uptodate.c:509
Code: ffffe88f 42b9fe4c 89e64889 dfe8b4df
Call Trace:
 ocfs2_group_add+0x3f1/0x1510 fs/ocfs2/resize.c:507
 ocfs2_ioctl+0x309/0x6e0 fs/ocfs2/ioctl.c:887
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __x64_sys_ioctl+0x197/0x1e0 fs/ioctl.c:583
 x64_sys_call+0x1144/0x26a0 arch/x86/include/generated/asm/syscalls_64.h:17
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x93/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x7bbfb55a966d

[CAUSE]
ocfs2_group_add() calls ocfs2_set_new_buffer_uptodate() on a
user-controlled group block before ocfs2_verify_group_and_input()
validates that block number. That helper is only valid for newly
allocated metadata and asserts that the block is not already present in
the chosen metadata cache. The code also uses INODE_CACHE(inode) even
though the group descriptor belongs to main_bm_inode and later journal
accesses use that cache context instead.

[FIX]
Validate the on-disk group descriptor before caching it, then add it to
the metadata cache tracked by INODE_CACHE(main_bm_inode). Keep the
validation failure path separate from the later cleanup path so we only
remove the buffer from that cache after it has actually been inserted.
This keeps the group buffer lifetime consistent across validation,
journaling, and cleanup.

Link: https://lkml.kernel.org/r/20260410020209.3786348-1-gality369@gmail.com
Fixes: 7909f2bf8353 ("[PATCH 2/2] ocfs2: Implement group add for online resize")
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/resize.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/fs/ocfs2/resize.c~ocfs2-validate-group-add-input-before-caching
+++ a/fs/ocfs2/resize.c
@@ -508,14 +508,14 @@ int ocfs2_group_add(struct inode *inode,
 		goto out_unlock;
 	}
 
-	ocfs2_set_new_buffer_uptodate(INODE_CACHE(inode), group_bh);
-
 	ret = ocfs2_verify_group_and_input(main_bm_inode, fe, input, group_bh);
 	if (ret) {
 		mlog_errno(ret);
 		goto out_free_group_bh;
 	}
 
+	ocfs2_set_new_buffer_uptodate(INODE_CACHE(main_bm_inode), group_bh);
+
 	trace_ocfs2_group_add((unsigned long long)input->group,
 			       input->chain, input->clusters, input->frees);
 
@@ -523,7 +523,7 @@ int ocfs2_group_add(struct inode *inode,
 	if (IS_ERR(handle)) {
 		mlog_errno(PTR_ERR(handle));
 		ret = -EINVAL;
-		goto out_free_group_bh;
+		goto out_remove_cache;
 	}
 
 	cl_bpc = le16_to_cpu(fe->id2.i_chain.cl_bpc);
@@ -577,9 +577,11 @@ int ocfs2_group_add(struct inode *inode,
 out_commit:
 	ocfs2_commit_trans(osb, handle);
 
-out_free_group_bh:
+out_remove_cache:
 	if (ret < 0)
-		ocfs2_remove_from_cache(INODE_CACHE(inode), group_bh);
+		ocfs2_remove_from_cache(INODE_CACHE(main_bm_inode), group_bh);
+
+out_free_group_bh:
 	brelse(group_bh);
 
 out_unlock:
_

Patches currently in -mm which might be from gality369@gmail.com are


