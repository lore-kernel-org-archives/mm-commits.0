Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B40C2877F7
	for <mm-commits@vger.kernel.org>; Fri,  6 Mar 2026 23:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772839846; cv=none; b=ED/+lQ/g46Gc4p7aM+fF4V0iBiTjSKbMsoMqOBmD2QLo3JHiIXDrLW0JhU8JvX0pxT3ZB5xd1eIbWavQ5pxLFVb2DaM2dF/erRCPyD1m/SwO8RyrgrFjuevcAEhJyca4tz0Ae2UKC5+VL2Jmbgs2e0pIl/UX0dscSCOeN5D41Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772839846; c=relaxed/simple;
	bh=nrnsXliByJnYXxWpQmCXLlQvSGkijMhHUNDsLnm3fq0=;
	h=Date:To:From:Subject:Message-Id; b=leX2dMyN/6H9FsegFbN8Kw46RRjP5WNiurd44LJio6t8fkNQBTa5U7jZWZMH9eHnxVYjTIohgjlxy9VyNqd54KdM7o03Azz6xuZLt0Tj+b63J09scLR0alb3lWjEm0+mzSH+XRR3Pj8oc8SFq+NGSvPYxm5q2IDbyh3QtJi1aug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VO/ci6dS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VO/ci6dS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8804BC4CEF7;
	Fri,  6 Mar 2026 23:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772839845;
	bh=nrnsXliByJnYXxWpQmCXLlQvSGkijMhHUNDsLnm3fq0=;
	h=Date:To:From:Subject:From;
	b=VO/ci6dS2d41N6Z15TYbSrFKBFVtDdsQq4kVaoXT/7scyxWrXaRXeXk0J+Xa/2z0c
	 cJhSrXyP7rtpRMQNZ6a2lhwMS/cvJZuF3OudQbFIlh/A3Bo5LPZpjyZAA9S5/KzjKK
	 GMA9sjqRHO0SsNJQ/c011YIjUtkc59aggxt+DGpE=
Date: Fri, 06 Mar 2026 15:30:45 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,jiangqi903@gmail.com,heming.zhao@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-possible-deadlock-between-unlink-and-dio_end_io_write.patch added to mm-nonmm-unstable branch
Message-Id: <20260306233045.8804BC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix possible deadlock between unlink and dio_end_io_write
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-fix-possible-deadlock-between-unlink-and-dio_end_io_write.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-possible-deadlock-between-unlink-and-dio_end_io_write.patch

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
Subject: ocfs2: fix possible deadlock between unlink and dio_end_io_write
Date: Fri, 6 Mar 2026 11:22:11 +0800

ocfs2_unlink takes orphan dir inode_lock first and then ip_alloc_sem,
while in ocfs2_dio_end_io_write, it acquires these locks in reverse order.
This creates an ABBA lock ordering violation on lock classes
ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE] and
ocfs2_file_ip_alloc_sem_key.

Lock Chain #0 (orphan dir inode_lock -> ip_alloc_sem):
ocfs2_unlink
  ocfs2_prepare_orphan_dir
    ocfs2_lookup_lock_orphan_dir
      inode_lock(orphan_dir_inode) <- lock A
    __ocfs2_prepare_orphan_dir
      ocfs2_prepare_dir_for_insert
        ocfs2_extend_dir
	  ocfs2_expand_inline_dir
	    down_write(&oi->ip_alloc_sem) <- Lock B

Lock Chain #1 (ip_alloc_sem -> orphan dir inode_lock):
ocfs2_dio_end_io_write
  down_write(&oi->ip_alloc_sem) <- Lock B
  ocfs2_del_inode_from_orphan()
    inode_lock(orphan_dir_inode) <- Lock A

Deadlock Scenario:
  CPU0 (unlink)                     CPU1 (dio_end_io_write)
  ------                            ------
  inode_lock(orphan_dir_inode)
                                    down_write(ip_alloc_sem)
  down_write(ip_alloc_sem)
                                    inode_lock(orphan_dir_inode)

Since ip_alloc_sem is to protect allocation changes, which is unrelated
with operations in ocfs2_del_inode_from_orphan.  So move
ocfs2_del_inode_from_orphan out of ip_alloc_sem to fix the deadlock.

Link: https://lkml.kernel.org/r/20260306032211.1016452-1-joseph.qi@linux.alibaba.com
Link: https://lkml.kernel.org/r/20260306032211.1016452-1-joseph.qi@linux.alibaba.com
Reported-by: syzbot+67b90111784a3eac8c04@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=67b90111784a3eac8c04
Fixes: a86a72a4a4e0 ("ocfs2: take ip_alloc_sem in ocfs2_dio_get_block & ocfs2_dio_end_io_write")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/ocfs2/aops.c~ocfs2-fix-possible-deadlock-between-unlink-and-dio_end_io_write
+++ a/fs/ocfs2/aops.c
@@ -2294,8 +2294,6 @@ static int ocfs2_dio_end_io_write(struct
 		goto out;
 	}
 
-	down_write(&oi->ip_alloc_sem);
-
 	/* Delete orphan before acquire i_rwsem. */
 	if (dwc->dw_orphaned) {
 		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
@@ -2308,6 +2306,7 @@ static int ocfs2_dio_end_io_write(struct
 			mlog_errno(ret);
 	}
 
+	down_write(&oi->ip_alloc_sem);
 	di = (struct ocfs2_dinode *)di_bh->b_data;
 
 	ocfs2_init_dinode_extent_tree(&et, INODE_CACHE(inode), di_bh);
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-fix-possible-deadlock-between-unlink-and-dio_end_io_write.patch

