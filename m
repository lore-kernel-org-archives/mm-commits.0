Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A58B33557B
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671910; cv=none; b=WvbiAepbbI/0b8HeQCXfF7x4s7g/GdmxGTQJAxjXbaltETIHwxeP0OanMqHTY1y4wU+So0XORIJ9Ez1T7Lvb1+QZJizskmLAvXnS8CRIi8Y+1F2PsjcpQ/Mw1kZduVYKsGHnc6khakq74oXPRD0ikplT+7mO7TpwzYMEqfK1b0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671910; c=relaxed/simple;
	bh=+NFS87AADAg+o3Xo8oDacUle8d3emoYBG2bVHPG4k2k=;
	h=Date:To:From:Subject:Message-Id; b=h1u4XZE56vz84/SDUjCpvn6tIO0dCBoWUFLX49L6exM6M2Zv2OAaz2+XSepTCppt3kD4AsHHipVNT6wn/w4pFZVek5VaHJLsowNpWbQPQ+XgGZ16kpLnqX5C7K9O0jFr+ftbSvxrgwi+2KbGm8KEhCVps3ezIKnC8YaiOVHw0pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SVEYjPa5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SVEYjPa5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD2FC4CEF7;
	Sat, 28 Mar 2026 04:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671910;
	bh=+NFS87AADAg+o3Xo8oDacUle8d3emoYBG2bVHPG4k2k=;
	h=Date:To:From:Subject:From;
	b=SVEYjPa5WaA3l46K/fkUpOUJrf37gfZyo24iUjdXeIF0WfS5EnqPtsMuL+kA4DpiE
	 MVekBV1RrwzYV66ebcwYZ7lNHXhHC5AU9DPzcltgmfXdU9HX1LLS/9bI5J1o6nqr2D
	 Z0oDIYxCo2yp5m1BQK2th/IDknqvpQCC2XP1ho78=
Date: Fri, 27 Mar 2026 21:25:09 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,heming.zhao@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-fix-deadlock-when-creating-quota-file.patch removed from -mm tree
Message-Id: <20260328042509.DFD2FC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix deadlock when creating quota file
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-deadlock-when-creating-quota-file.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Heming Zhao <heming.zhao@suse.com>
Subject: ocfs2: fix deadlock when creating quota file
Date: Mon, 2 Mar 2026 14:17:05 +0800

syzbot detected a circular locking dependency. the scenarios:

        CPU0                    CPU1
        ----                    ----
   lock(&ocfs2_quota_ip_alloc_sem_key);
                                lock(&ocfs2_sysfile_lock_key[USER_QUOTA_SYSTEM_INODE]);
                                lock(&ocfs2_quota_ip_alloc_sem_key);
   lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);

or:
       CPU0                    CPU1
       ----                    ----
  lock(&ocfs2_quota_ip_alloc_sem_key);
                               lock(&dquot->dq_lock);
                               lock(&ocfs2_quota_ip_alloc_sem_key);
  lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);

Following are the code paths for above scenarios:

path_openat
 ocfs2_create
  ocfs2_mknod
  + ocfs2_reserve_new_inode
  |  ocfs2_reserve_suballoc_bits
  |   inode_lock(alloc_inode) //C0: hold INODE_ALLOC_SYSTEM_INODE
  |    //ocfs2_free_alloc_context(inode_ac) is called at the end of
  |    //caller ocfs2_mknod to handle the release
  |
  + ocfs2_get_init_inode
     __dquot_initialize
      dqget
       ocfs2_acquire_dquot
       + ocfs2_lock_global_qf
       |  down_write(&OCFS2_I(oinfo->dqi_gqinode)->ip_alloc_sem)//A2:grabbing
       + ocfs2_create_local_dquot
          down_write(&OCFS2_I(lqinode)->ip_alloc_sem)//A3:grabbing

evict
 ocfs2_evict_inode
  ocfs2_delete_inode
   ocfs2_wipe_inode
    + inode_lock(orphan_dir_inode) //B0:hold
    + ...
    + ocfs2_remove_inode
       inode_lock(inode_alloc_inode) //INODE_ALLOC_SYSTEM_INODE
        down_write(&inode->i_rwsem) //C1:grabbing

generic_file_direct_write
 ocfs2_direct_IO
  __blockdev_direct_IO
   dio_complete
    ocfs2_dio_end_io
     ocfs2_dio_end_io_write
     + down_write(&oi->ip_alloc_sem) //A0:hold
     + ocfs2_del_inode_from_orphan
        inode_lock(orphan_dir_inode) //B1:grabbing

Root cause for the circular locking:

DIO completion path:
 holds oi->ip_alloc_sem and is trying to acquire the orphan_dir_inode lock.

evict path:
 holds the orphan_dir_inode lock and is trying to acquire the
 inode_alloc_inode lock.

ocfs2_mknod path:
 Holds the inode_alloc_inode lock (to allocate a new quota file) and is
 blocked waiting for oi->ip_alloc_sem in ocfs2_acquire_dquot().

How to fix:

Replace down_write() with down_write_trylock() in ocfs2_acquire_dquot(). 
If acquiring oi->ip_alloc_sem fails, return -EBUSY to abort the file
creation routine and break the deadlock.

Link: https://lkml.kernel.org/r/20260302061707.7092-1-heming.zhao@suse.com
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reported-by: syzbot+78359d5fbb04318c35e9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=78359d5fbb04318c35e9
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/quota_global.c |   16 +++++++++++++++-
 fs/ocfs2/quota_local.c  |    4 +++-
 2 files changed, 18 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/quota_global.c~ocfs2-fix-deadlock-when-creating-quota-file
+++ a/fs/ocfs2/quota_global.c
@@ -311,11 +311,25 @@ int ocfs2_lock_global_qf(struct ocfs2_me
 	spin_unlock(&dq_data_lock);
 	if (ex) {
 		inode_lock(oinfo->dqi_gqinode);
-		down_write(&OCFS2_I(oinfo->dqi_gqinode)->ip_alloc_sem);
+		if (!down_write_trylock(&OCFS2_I(oinfo->dqi_gqinode)->ip_alloc_sem)) {
+			inode_unlock(oinfo->dqi_gqinode);
+			status = -EBUSY;
+			goto bail;
+		}
 	} else {
 		down_read(&OCFS2_I(oinfo->dqi_gqinode)->ip_alloc_sem);
 	}
 	return 0;
+
+bail:
+	/* does a similar job as ocfs2_unlock_global_qf */
+	ocfs2_inode_unlock(oinfo->dqi_gqinode, ex);
+	brelse(oinfo->dqi_gqi_bh);
+	spin_lock(&dq_data_lock);
+	if (!--oinfo->dqi_gqi_count)
+		oinfo->dqi_gqi_bh = NULL;
+	spin_unlock(&dq_data_lock);
+	return status;
 }
 
 void ocfs2_unlock_global_qf(struct ocfs2_mem_dqinfo *oinfo, int ex)
--- a/fs/ocfs2/quota_local.c~ocfs2-fix-deadlock-when-creating-quota-file
+++ a/fs/ocfs2/quota_local.c
@@ -1224,7 +1224,9 @@ int ocfs2_create_local_dquot(struct dquo
 	int status;
 	u64 pcount;
 
-	down_write(&OCFS2_I(lqinode)->ip_alloc_sem);
+	if (!down_write_trylock(&OCFS2_I(lqinode)->ip_alloc_sem))
+		return -EBUSY;
+
 	chunk = ocfs2_find_free_entry(sb, type, &offset);
 	if (!chunk) {
 		chunk = ocfs2_extend_local_quota_file(sb, type, &offset);
_

Patches currently in -mm which might be from heming.zhao@suse.com are


