Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E174765192
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 23:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779145664; cv=none; b=D1i5dad29SF2dPGLcg6rJYYDUnCgY/k14Tj2HIxhmAJth/Ltdu4Ku5xxNGlDRLTdjrZHF+NFB1fBT4Iv32/kD3K2ERKRNaNtQqfE5Kj5S9Pig4shiE9VuXa5rxYaGhcZ9amVN9HqNsZLdxHSMCOvYDIeDKmIYzezePBi2Ctjwow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779145664; c=relaxed/simple;
	bh=/SmIXD5j7m6HW0QMnFS2ABW9O8RxoWxMpKkg1aCXpZI=;
	h=Date:To:From:Subject:Message-Id; b=a5MY4UwOnqelLDo17B9o8hckQxeyRg8kKhaqjSJ4zOVFPSjD8bYSI3yNPtmNgA2YoM6o4C/o55DdJNe8IDpzGIZJW2e1DiDAnfvSLmOFXTWvYUj9sRl1IOuxHOhkoSfXih9HvUYdDDvJNwV6Ska8bikBwVeK68XCrx2jbr4pZwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Yk1GJpme; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Yk1GJpme"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F6DC2BCB7;
	Mon, 18 May 2026 23:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779145663;
	bh=/SmIXD5j7m6HW0QMnFS2ABW9O8RxoWxMpKkg1aCXpZI=;
	h=Date:To:From:Subject:From;
	b=Yk1GJpme96V1htFiVh6TsmEnyfgDncSWjN3J0pTvVB9nrCYPCuRpPNjLSbI7khSSf
	 HlNWalg4C634R21DCyW/znMnuouZ49gl+gsMzExtM3qjk4Cu8OKyhoprNDfMr3peIU
	 cr9TjNjK4FyyaThzcKQuQd6YxCIDTE/OlCJYrt1c=
Date: Mon, 18 May 2026 16:07:42 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,penguin-kernel@I-love.SAKURA.ne.jp,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-kill-osb-system_file_mutex-lock.patch added to mm-nonmm-unstable branch
Message-Id: <20260518230743.70F6DC2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: kill osb->system_file_mutex lock
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-kill-osb-system_file_mutex-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-kill-osb-system_file_mutex-lock.patch

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

ocfs2-kill-osb-system_file_mutex-lock.patch

