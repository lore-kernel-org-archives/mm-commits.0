Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078142288E3
	for <mm-commits@vger.kernel.org>; Mon, 23 Jun 2025 22:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717046; cv=none; b=MYF9nvC7hGnc4167jRWPq/lv9NcmAJ2JkX9apSRO0890OOntKInRlWzYOW+Y/srelYVuZteBzmsVEV7N33Lt1ctQ1se+kABbVQo6uGBYRA509J2vnHgVM/HGWMu+cr5+RGeyaVCQIaBgNvn+MUvEcO7lFjzyayqZthwTJgq8m+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717046; c=relaxed/simple;
	bh=+fzDmn1pOKycMI98zzvUru5i+B15I0ets7JW+gVTVvg=;
	h=Date:To:From:Subject:Message-Id; b=sKp5ebg2v0Rshq4auX9vP7mNggyIDFnd6Sniu4wqWSQ/rKT8UDUaWO34tCIpI5IckMS14Kihnn3W9Rrm6fPtj1n81AKneNZ02LPIj8Im/nvuEvMxpjLOS8XzVxY10xRLMMQHnF8eKZvB/CLbStIifdt3tq+Hr1F2D1vqvNnoQuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sAebhiyo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sAebhiyo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56D4C4CEEA;
	Mon, 23 Jun 2025 22:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750717045;
	bh=+fzDmn1pOKycMI98zzvUru5i+B15I0ets7JW+gVTVvg=;
	h=Date:To:From:Subject:From;
	b=sAebhiyoDU42QesLGu5LPyUPTDqCs9NisdAbifu+oH0Zw9EQ2Xzwh5ENDkQsmw29D
	 HSW18PreDkqwnUyrTTsJqtiCIIWSGUwX2KqChKrwi8QWYu1NS7G8jWbubzcajK2UJG
	 13pqTKGMNtYR9sp8UCgd+fzdg08m7fScu/BlUXdQ=
Date: Mon, 23 Jun 2025 15:17:25 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,jiangqi903@gmail.com,gechangwei@live.cn,penguin-kernel@I-love.SAKURA.ne.jp,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-embed-actual-values-into-ocfs2_sysfile_lock_key-names.patch added to mm-nonmm-unstable branch
Message-Id: <20250623221725.B56D4C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: embed actual values into ocfs2_sysfile_lock_key names
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-embed-actual-values-into-ocfs2_sysfile_lock_key-names.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-embed-actual-values-into-ocfs2_sysfile_lock_key-names.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
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
ocfs2-embed-actual-values-into-ocfs2_sysfile_lock_key-names.patch

