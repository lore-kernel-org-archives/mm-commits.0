Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772D122B584;
	Sat, 28 Mar 2026 04:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671938; cv=none; b=oyJ6nhxfwpGfyeOCW0aY8/S/VDNBsXIvznfRQs+n7pBsGTnfJWRPtnEliPsAWbPvf/sX3JNOhuqwLBvhONCzEzLbWtQ6TqCsLYBSqb2xCnkR95kJNX3O7O2BLIZGIJly10jqqEsez2G2oZ987n+Alj65IjZNZkxWKJxA2Xa9PiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671938; c=relaxed/simple;
	bh=SlCuBuHDC/zKAJvacDmF/zTzx1G5Jg3AziCrqIMrOwg=;
	h=Date:To:From:Subject:Message-Id; b=F0Cz1DgZ1Yk43lYnbzQ0YNb5UFkclSNrO1PLYfppmn2ymTbfnRAL0B4RW/Ql6CEXxQcLV9mV6arLFlGP3ASLlH3LcCzfzKJ1daQbtYRzqTpZ5cB12gSHMObpsLaIzvoTPRzuJcBvaSi+ohFLa0+U6hHVnLePpCrFFVfH8dN49zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zA6BIe56; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zA6BIe56"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EBBAC4CEF7;
	Sat, 28 Mar 2026 04:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671938;
	bh=SlCuBuHDC/zKAJvacDmF/zTzx1G5Jg3AziCrqIMrOwg=;
	h=Date:To:From:Subject:From;
	b=zA6BIe56+RKgdOyCFX8SjBldVIHd6m44hZz0BCd2We2E44r1liY5RlxTqAsVpI86B
	 Cl3MiCwsug7xQPfDqOE1CPhwICYQBE+SSk4G1g/VYsvsTWZTF5vt+11OXdVBwGhq00
	 RbVoz3/cT48/XDVoHQA4kp2dX+RWkYlDbF6w74/c=
Date: Fri, 27 Mar 2026 21:25:37 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,jiangqi903@gmail.com,heming.zhao@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-fix-possible-deadlock-between-unlink-and-dio_end_io_write.patch removed from -mm tree
Message-Id: <20260328042538.4EBBAC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix possible deadlock between unlink and dio_end_io_write
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-possible-deadlock-between-unlink-and-dio_end_io_write.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: <stable@vger.kernel.org>
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


