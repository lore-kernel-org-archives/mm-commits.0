Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF71372EF7
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028832; cv=none; b=ruCR7Aj1jq8+lJeDoRDYZJQbjNCYkhcHaky5afwo2BgkO81OIYsspgGILo7UaIbqb/qi9vZuMgnvDwAAOt9rFAvYHhf5RbliLEYN6M2354TUH/aQ9/H32DQWPTOJ/cvk2Ooq0BzCHGikCPv0PGNB+7KEshM+8LqX7COVUuKwVGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028832; c=relaxed/simple;
	bh=MHs8fMImEUm+TRL5ixJK0M3hACrdK3TjXDVOnVFzQSI=;
	h=Date:To:From:Subject:Message-Id; b=IyPr92QuX8eBIcFDATQGVoIK8PHZqffOtf3pUk2CAdNsiUT55lm2G2S1K73hg4ZmxRmxNJih27Ff75EiBqyXjAy2dDctk0eJOvi3MzgDZkKU5xZJWToHoueermK9RkD6M0okmIT3WMRLRyxj3l2RISxrc/nUHul9OBgsxXALjBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q18JLvtH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q18JLvtH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56CA71F00893;
	Fri, 29 May 2026 04:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028831;
	bh=nS4I30NrwNizvSNULkvDLc9mjLbHz0tDj1P5ceJ98GE=;
	h=Date:To:From:Subject;
	b=Q18JLvtHEJO6pVwOzwhy5EHxhvVTHEE9ZGgwfHSRz7teOEaDYzPW7n+JNrnxH/+WV
	 LC2vLfFs4YOq8ZUegPW1RPCveCl0FPlWpBvu3MYA+/tiwLgK1tPy11Hl9PrzF86Nhy
	 C8BVm94b63YQD+aPHin6AQLoN/lckAwsWtMuRsqY=
Date: Thu, 28 May 2026 21:27:10 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,penguin-kernel@I-love.SAKURA.ne.jp,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-kill-osb-system_file_mutex-lock.patch removed from -mm tree
Message-Id: <20260529042711.56CA71F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: kill osb->system_file_mutex lock
has been removed from the -mm tree.  Its filename was
     ocfs2-kill-osb-system_file_mutex-lock.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: ocfs2: kill osb->system_file_mutex lock
Date: Mon, 18 May 2026 13:23:40 +0900

Commit 43b10a20372d ("ocfs2: avoid system inode ref confusion by adding
mutex lock") tried to avoid a refcount leak caused by allowing multiple
threads to call igrab(inode).  But addition of osb->system_file_mutex made
locking dependency complicated and is causing lockdep to warn about
possibility of AB-BA deadlock.

Since _ocfs2_get_system_file_inode() returns the same inode for the same
input arguments, we don't need to serialize
_ocfs2_get_system_file_inode().  What we need to make sure is that
igrab(inode) is called for only once().  Therefore, replace
osb->system_file_mutex with cmpxchg()-based locking.

Link: https://lore.kernel.org/fea8d1fd-afb0-4302-a560-c202e2ef7afd@I-love.SAKURA.ne.jp
Fixes: 43b10a20372d ("ocfs2: avoid system inode ref confusion by adding mutex lock")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/ocfs2.h   |    2 --
 fs/ocfs2/super.c   |    2 --
 fs/ocfs2/sysfile.c |    9 +++------
 3 files changed, 3 insertions(+), 10 deletions(-)

--- a/fs/ocfs2/ocfs2.h~ocfs2-kill-osb-system_file_mutex-lock
+++ a/fs/ocfs2/ocfs2.h
@@ -494,8 +494,6 @@ struct ocfs2_super
 	struct rb_root	osb_rf_lock_tree;
 	struct ocfs2_refcount_tree *osb_ref_tree_lru;
 
-	struct mutex system_file_mutex;
-
 	/*
 	 * OCFS2 needs to schedule several different types of work which
 	 * require cluster locking, disk I/O, recovery waits, etc. Since these
--- a/fs/ocfs2/super.c~ocfs2-kill-osb-system_file_mutex-lock
+++ a/fs/ocfs2/super.c
@@ -1997,8 +1997,6 @@ static int ocfs2_initialize_super(struct
 	spin_lock_init(&osb->osb_xattr_lock);
 	ocfs2_init_steal_slots(osb);
 
-	mutex_init(&osb->system_file_mutex);
-
 	atomic_set(&osb->alloc_stats.moves, 0);
 	atomic_set(&osb->alloc_stats.local_data, 0);
 	atomic_set(&osb->alloc_stats.bitmap_data, 0);
--- a/fs/ocfs2/sysfile.c~ocfs2-kill-osb-system_file_mutex-lock
+++ a/fs/ocfs2/sysfile.c
@@ -98,11 +98,9 @@ struct inode *ocfs2_get_system_file_inod
 	} else
 		arr = get_local_system_inode(osb, type, slot);
 
-	mutex_lock(&osb->system_file_mutex);
 	if (arr && ((inode = *arr) != NULL)) {
 		/* get a ref in addition to the array ref */
 		inode = igrab(inode);
-		mutex_unlock(&osb->system_file_mutex);
 		BUG_ON(!inode);
 
 		return inode;
@@ -112,11 +110,10 @@ struct inode *ocfs2_get_system_file_inod
 	inode = _ocfs2_get_system_file_inode(osb, type, slot);
 
 	/* add one more if putting into array for first time */
-	if (arr && inode) {
-		*arr = igrab(inode);
-		BUG_ON(!*arr);
+	if (inode && arr && !*arr && !cmpxchg(&(*arr), NULL, inode)) {
+		inode = igrab(inode);
+		BUG_ON(!inode);
 	}
-	mutex_unlock(&osb->system_file_mutex);
 	return inode;
 }
 
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are


