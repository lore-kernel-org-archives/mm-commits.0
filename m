Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598E6286D60
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752127182; cv=none; b=LXwCCmsgVFLWgZqureCphiQ1iw9q/aQ3cZMiePrDFX5uNmBmjeDtsxdftUXxE4fxim2G/KgpJMJABA+VFBCDyjv0VpEjlFqchO51+UBXr9tysxuvDsJWU/vi580NXMNl1yALSA40GFKyi3cIBAS0mNHG8YSqnnBL4DmqAW6Au9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752127182; c=relaxed/simple;
	bh=B8Bv/xthBIqpYBBqBqSrmIp4bGh8+8oz/JS5eAGc2N8=;
	h=Date:To:From:Subject:Message-Id; b=FvBJxjMHib+MhpLLOO+Z0IO2NoBwc4LVb8tPFaNfZHaqccp3RzZcWqHGv5gL3rZXY5bEMRERQRriaCk/2a1YxotuME9C1VcxOEeXbLaPPuA3WqDdAVEfFNlF3Bwhk/zY/tQzh4vrJg5iFsmz45JOrzFNSUoxvE33AAzYKSzavow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jfgLdm19; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jfgLdm19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C208C4CEE3;
	Thu, 10 Jul 2025 05:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752127182;
	bh=B8Bv/xthBIqpYBBqBqSrmIp4bGh8+8oz/JS5eAGc2N8=;
	h=Date:To:From:Subject:From;
	b=jfgLdm19r0aCuFxKwZX6FMumcn7z+s56YUBOO08HGO2Vu7QU8Odt9NCOiMneb/PRd
	 rS45zxSjHDGJO2NibCEtAc8Ojw6T3sYY4PIb+SHPXbkRLbgZdxJvtfMAFDPgurUrnC
	 eHjkX6CEwkjWbAeM9ndUrbPtpgUGVG5dNcJp7wNc=
Date: Wed, 09 Jul 2025 22:59:40 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,penguin-kernel@I-love.SAKURA.ne.jp,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-embed-actual-values-into-ocfs2_sysfile_lock_key-names.patch removed from -mm tree
Message-Id: <20250710055942.2C208C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: embed actual values into ocfs2_sysfile_lock_key names
has been removed from the -mm tree.  Its filename was
     ocfs2-embed-actual-values-into-ocfs2_sysfile_lock_key-names.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: ocfs2: embed actual values into ocfs2_sysfile_lock_key names
Date: Mon, 23 Jun 2025 23:54:20 +0900

Since lockdep_set_class() uses stringified key name via macro, calling
lockdep_set_class() with an array causes lockdep warning messages to
report variable name than actual index number.

Change ocfs2_init_locked_inode() to pass actual index number for better
readability of lockdep reports.  This patch does not change behavior.

Before:

  Chain exists of:
    &ocfs2_sysfile_lock_key[args->fi_sysfile_type] --> jbd2_handle --> &oi->ip_xattr_sem

   Possible unsafe locking scenario:

         CPU0                    CPU1
         ----                    ----
    lock(&oi->ip_xattr_sem);
                                 lock(jbd2_handle);
                                 lock(&oi->ip_xattr_sem);
    lock(&ocfs2_sysfile_lock_key[args->fi_sysfile_type]);

   *** DEADLOCK ***

After:

  Chain exists of:
    &ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE] --> jbd2_handle --> &oi->ip_xattr_sem

   Possible unsafe locking scenario:

         CPU0                    CPU1
         ----                    ----
    lock(&oi->ip_xattr_sem);
                                 lock(jbd2_handle);
                                 lock(&oi->ip_xattr_sem);
    lock(&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]);

   *** DEADLOCK ***

Link: https://lkml.kernel.org/r/29348724-639c-443d-bbce-65c3a0a13a38@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c |   70 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 66 insertions(+), 4 deletions(-)

--- a/fs/ocfs2/inode.c~ocfs2-embed-actual-values-into-ocfs2_sysfile_lock_key-names
+++ a/fs/ocfs2/inode.c
@@ -50,8 +50,6 @@ struct ocfs2_find_inode_args
 	unsigned int	fi_sysfile_type;
 };
 
-static struct lock_class_key ocfs2_sysfile_lock_key[NUM_SYSTEM_INODES];
-
 static int ocfs2_read_locked_inode(struct inode *inode,
 				   struct ocfs2_find_inode_args *args);
 static int ocfs2_init_locked_inode(struct inode *inode, void *opaque);
@@ -250,14 +248,77 @@ bail:
 static int ocfs2_init_locked_inode(struct inode *inode, void *opaque)
 {
 	struct ocfs2_find_inode_args *args = opaque;
+#ifdef CONFIG_LOCKDEP
+	static struct lock_class_key ocfs2_sysfile_lock_key[NUM_SYSTEM_INODES];
 	static struct lock_class_key ocfs2_quota_ip_alloc_sem_key,
 				     ocfs2_file_ip_alloc_sem_key;
+#endif
 
 	inode->i_ino = args->fi_ino;
 	OCFS2_I(inode)->ip_blkno = args->fi_blkno;
-	if (args->fi_sysfile_type != 0)
+#ifdef CONFIG_LOCKDEP
+	switch (args->fi_sysfile_type) {
+	case BAD_BLOCK_SYSTEM_INODE:
+		break;
+	case GLOBAL_INODE_ALLOC_SYSTEM_INODE:
+		lockdep_set_class(&inode->i_rwsem,
+				  &ocfs2_sysfile_lock_key[GLOBAL_INODE_ALLOC_SYSTEM_INODE]);
+		break;
+	case SLOT_MAP_SYSTEM_INODE:
+		lockdep_set_class(&inode->i_rwsem,
+				  &ocfs2_sysfile_lock_key[SLOT_MAP_SYSTEM_INODE]);
+		break;
+	case HEARTBEAT_SYSTEM_INODE:
+		lockdep_set_class(&inode->i_rwsem,
+				  &ocfs2_sysfile_lock_key[HEARTBEAT_SYSTEM_INODE]);
+		break;
+	case GLOBAL_BITMAP_SYSTEM_INODE:
+		lockdep_set_class(&inode->i_rwsem,
+				  &ocfs2_sysfile_lock_key[GLOBAL_BITMAP_SYSTEM_INODE]);
+		break;
+	case USER_QUOTA_SYSTEM_INODE:
+		lockdep_set_class(&inode->i_rwsem,
+				  &ocfs2_sysfile_lock_key[USER_QUOTA_SYSTEM_INODE]);
+		break;
+	case GROUP_QUOTA_SYSTEM_INODE:
+		lockdep_set_class(&inode->i_rwsem,
+				  &ocfs2_sysfile_lock_key[GROUP_QUOTA_SYSTEM_INODE]);
+		break;
+	case ORPHAN_DIR_SYSTEM_INODE:
+		lockdep_set_class(&inode->i_rwsem,
+				  &ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
+		break;
+	case EXTENT_ALLOC_SYSTEM_INODE:
 		lockdep_set_class(&inode->i_rwsem,
-			&ocfs2_sysfile_lock_key[args->fi_sysfile_type]);
+				  &ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]);
+		break;
+	case INODE_ALLOC_SYSTEM_INODE:
+		lockdep_set_class(&inode->i_rwsem,
+				  &ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]);
+		break;
+	case JOURNAL_SYSTEM_INODE:
+		lockdep_set_class(&inode->i_rwsem,
+				  &ocfs2_sysfile_lock_key[JOURNAL_SYSTEM_INODE]);
+		break;
+	case LOCAL_ALLOC_SYSTEM_INODE:
+		lockdep_set_class(&inode->i_rwsem,
+				  &ocfs2_sysfile_lock_key[LOCAL_ALLOC_SYSTEM_INODE]);
+		break;
+	case TRUNCATE_LOG_SYSTEM_INODE:
+		lockdep_set_class(&inode->i_rwsem,
+				  &ocfs2_sysfile_lock_key[TRUNCATE_LOG_SYSTEM_INODE]);
+		break;
+	case LOCAL_USER_QUOTA_SYSTEM_INODE:
+		lockdep_set_class(&inode->i_rwsem,
+				  &ocfs2_sysfile_lock_key[LOCAL_USER_QUOTA_SYSTEM_INODE]);
+		break;
+	case LOCAL_GROUP_QUOTA_SYSTEM_INODE:
+		lockdep_set_class(&inode->i_rwsem,
+				  &ocfs2_sysfile_lock_key[LOCAL_GROUP_QUOTA_SYSTEM_INODE]);
+		break;
+	default:
+		WARN_ONCE(1, "Unknown sysfile type %d\n", args->fi_sysfile_type);
+	}
 	if (args->fi_sysfile_type == USER_QUOTA_SYSTEM_INODE ||
 	    args->fi_sysfile_type == GROUP_QUOTA_SYSTEM_INODE ||
 	    args->fi_sysfile_type == LOCAL_USER_QUOTA_SYSTEM_INODE ||
@@ -267,6 +328,7 @@ static int ocfs2_init_locked_inode(struc
 	else
 		lockdep_set_class(&OCFS2_I(inode)->ip_alloc_sem,
 				  &ocfs2_file_ip_alloc_sem_key);
+#endif
 
 	return 0;
 }
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

ocfs2-kill-osb-system_file_mutex-lock.patch

