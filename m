Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6476033F36D;
	Wed,  7 Oct 2026 02:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338690; cv=none; b=FqIF/G8DV+I/IMaV9nMS+ZxvFrvkcH6TK8OLa44JM9HkTm+0vZbkS5u4BYbdTF8aoEX4EI5Sv2afRGfBbrzr8jy2DWBD289LBaU9fRLuivMTIGv7Vid8QyLDRJlFhCG4ZFRCI8wFqA+Z08+XZ53RKg/Vgcy3Ca2XWk/X2E3OYXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338690; c=relaxed/simple;
	bh=knLzUsjpfq6PBzDzcOIU4qNbXdB02Hxt29bRt23EJfo=;
	h=Date:To:From:Subject:Message-Id; b=GbwD96PwKzXRDb91LokjMr9KixP/Nu0G6vKdUvC7/M6UJTBZX5I736lnV7p+yG642HCROuFwwDXC7ohuPUQFgKxVJtRY7h7nL1H2AOoH8xbWH50KxbhnOaw1+10kTW1cRVsfSAu/JBY1s/1d3gleOyOWT/ZGPb9jWHUmp3ZE8Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KBZ+fquI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KBZ+fquI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8241F0089B;
	Wed,  7 Oct 2026 02:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338689;
	bh=Xz2543Re/MvMVoyaytolaIDHeo1yY7vhMyfS/R5+Tkc=;
	h=Date:To:From:Subject;
	b=KBZ+fquILUuR2+nS7yYadHKL3UDeOIuA2TokbdG04aOyqhaF/EULzUwMF8i7t6d5H
	 F1wrAYRZ4pGusTuEzcXm8TcrnoUUXIDUkHbr2yG4+RttCCHTgsJuSlS38xrstXPUN3
	 VRUb4bk81bz/Kx3KlGqE1GrNUUUUTT0HtzPTPfWE=
Date: Tue, 06 Oct 2026 19:04:48 -0700
To: mm-commits@vger.kernel.org,tangzw515@gmail.com,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-skip-uninitialized-lockres-in-ocfs2_mark_lockres_freeing.patch removed from -mm tree
Message-Id: <20261007020449.3A8241F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: skip uninitialized lockres in ocfs2_mark_lockres_freeing()
has been removed from the -mm tree.  Its filename was
     ocfs2-skip-uninitialized-lockres-in-ocfs2_mark_lockres_freeing.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: skip uninitialized lockres in ocfs2_mark_lockres_freeing()
Date: Thu, 3 Sep 2026 18:47:44 +0800

A hard readonly mount skips ocfs2_dlm_init(), so the per-osb lock
resources are never initialized and osb->cconn stays NULL.  Before commit
550842cc60987 ("ocfs2: fix freeing uninitialized resource on
ocfs2_dlm_shutdown") ocfs2_dismount_volume() only called
ocfs2_dlm_shutdown() when osb->cconn was set.  It now calls it
unconditionally, so unmounting a hard readonly mount drops the osb locks
and takes the never initialized l_lock in ocfs2_mark_lockres_freeing(). 
With lockdep enabled this triggers:

INFO: trying to register non-static key.  The code is fine but needs
lockdep annotation, or maybe you didn't initialize this object before use?
turning off the locking correctness validator.

ocfs2_drop_lock() and ocfs2_lock_res_free() already skip lock resources
without OCFS2_LOCK_INITIALIZED.  Add the same check to
ocfs2_mark_lockres_freeing(), which is reachable before them through
ocfs2_simple_drop_lockres(), so an uninitialized lockres is never touched.

Link: https://lore.kernel.org/20260903104744.2164235-1-joseph.qi@linux.alibaba.com
Fixes: 550842cc6098 ("ocfs2: fix freeing uninitialized resource on ocfs2_dlm_shutdown")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: ZW Tang <tangzw515@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
---

 fs/ocfs2/dlmglue.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/ocfs2/dlmglue.c~ocfs2-skip-uninitialized-lockres-in-ocfs2_mark_lockres_freeing
+++ a/fs/ocfs2/dlmglue.c
@@ -3525,6 +3525,10 @@ void ocfs2_mark_lockres_freeing(struct o
 	struct ocfs2_mask_waiter mw;
 	unsigned long flags, flags2;
 
+	/* We didn't get anywhere near actually using this lockres. */
+	if (!(lockres->l_flags & OCFS2_LOCK_INITIALIZED))
+		return;
+
 	ocfs2_init_mask_waiter(&mw);
 
 	spin_lock_irqsave(&lockres->l_lock, flags);
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-retain-all-security-xattrs-during-inode-creation.patch
ocfs2-restore-erange-check-in-ocfs2_xattr_tree_list_index_block.patch
ocfs2-fix-possible-deadlock-between-nfs_sync_rwlock-and-fs_reclaim.patch

