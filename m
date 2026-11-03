Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793675997;
	b=GXzA0hcWV4HA5zf4E4pOwf40PVczeba1mmrODXKBllrjuhPjbKWuGfS2BFkaG7z8X5Lx
	 LNuNeZXjAeWxRWMOGCTTTMSuGQL+47uxIsoSyndKt/nPBYzc3X0im/YTcK1RpxCpdnDQQ
	 iZ1Lca24lRqkgJo7FDdskbvB0KiJQv1V4T0DQOK+UuiEmGo4CsDsgiO+n5+aFElyptjSy
	 XJkxa3oSKVa06iurCedXM3YunLuslzSGPfAUfte+D97tuKm5FKbDs45njAG+kgdT4fjby
	 5lTeO17JNXQ8aLpW9rzqH+vQcO8qjZcxePJXZSdGj2whpKmCBdvb0fY+HH+qu6+Lkfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793675997;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=dSjBY2uS4YNJ99QmSyNZKFdoomB6LE54vbYxqtMOg+Y=;
	b=ydQTRcOiROVPTkXixFMIl+gYjB3u3dZPPibn/sEYQctjMeBBh+H6uElyISIj6+RANYEy
	 5z8uAnMwXBUP1G7WW2AGlCPl7wDfIw1CvQ7Ox7Hm53WPalC+a0PZFOpMj39cSEPF0NOw7
	 Ya4JB0I6HoLR4nGutpo8Sd3rSRiVonz03fFdbiaXWAzgWYMdAc2AkfEyUQrgvtof8CC09
	 7y/VG55XkM8D63jbWNPMA+LIfMhr6/kRylz53tYR5FTgAUci1+Q10dy9WhBcUT/mWgLnT
	 GMJVZaY9DHGZUncxLZJLPTjInKN+3csCX/Wz+iwTQR3fbISD7KkIsJlfTvJenITYGKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Krphrw7l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93195606A332;
	Tue,  3 Nov 2026 03:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Krphrw7l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F3F1F000C1;
	Tue,  3 Nov 2026 03:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793675997;
	bh=dSjBY2uS4YNJ99QmSyNZKFdoomB6LE54vbYxqtMOg+Y=;
	h=Date:To:From:Subject;
	b=Krphrw7lSH7j+QbT7B/HNEAFaYfU0Fn7hmrihfxFDY32xByzRT0rZ0tyl6JiPp1py
	 AIxtsVELFF1TOLLMRNzMZDMmzCE73vUnsjcvsW4y9tZVfYdTVX5/NKbaKOT4Y8cIJ2
	 CJaVPd0/rHW5Q76h4Kx0fXtQY6Q3/Op6UP9a4VIg=
Date: Mon, 02 Nov 2026 19:19:56 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mark@fasheh.com,
	joseph.qi@linux.alibaba.com,jlbec@evilplan.org,jjzuming@gmail.com,
	heming.zhao@suse.com,baijiaju1990@gmail.com,zzzccc427@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-hotfixes-stable] ocfs2-cache-the-mount-context-for-dentry-lock-callbacks.patch removed from -mm tree
Message-Id: <20261103031957.37F3F1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: ocfs2: cache the mount context for dentry lock callbacks
has been removed from the -mm tree.  Its filename was
     ocfs2-cache-the-mount-context-for-dentry-lock-callbacks.patch

This patch was dropped because it was merged into the mm-nonmm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Cen Zhang <zzzccc427@gmail.com>
Subject: ocfs2: cache the mount context for dentry lock callbacks
Date: Tue, 20 Oct 2026 22:25:53 +0800

ocfs2_drop_dentry_lock() drops the inode reference before releasing the
DENTRY lock.  This lets inode eviction release the local inode and open
locks before a remote unlink can proceed past the DENTRY lock.

A DLM callback can still arrive before the DENTRY lock has been dropped.
ocfs2_get_dentry_osb() obtains the mount context through dl_inode->i_sb,
which can access a freed inode when the downconvert thread drops the
last inode reference in its post-unlock callback:

  Downconvert thread                     DLM callback thread
  ------------------                     -------------------
  ocfs2_process_blocked_lock()
    ocfs2_dentry_post_unlock()
      ocfs2_dentry_lock_put()
        ocfs2_drop_dentry_lock()
          iput(dl->dl_inode)
          [inode reclaimed after RCU]
                                         ocfs2_blocking_ast()
                                           ocfs2_get_dentry_osb()
                                             dl->dl_inode->i_sb
          ocfs2_simple_drop_lockres()

Store the mount context in the DENTRY lock resource's l_priv field and use
the default mount-context lookup.  Recover the containing dentry lock with
container_of(), as already done for refcount locks, and remove
ocfs2_get_dentry_osb().  ocfs2_dismount_volume() shuts down the DLM before
freeing the mount context, so callbacks can use it without accessing the
inode.  Preserve the existing iput-before-unlock order to avoid delaying
local inode and open lock release until after the DENTRY lock is released.

Link: https://lore.kernel.org/pm-ocfs2-objects-candidate-0012-v9-eeb9084fb29577971229@gmail.com
Fixes: 8ed6b23709b3 ("ocfs2: revert iput deferring code in ocfs2_drop_dentry_lock")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Assisted-by: LLM
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: <jjzuming@gmail.com>
Cc: <stable@vger.kernel.org>
---

 fs/ocfs2/dcache.h  |    5 ++---
 fs/ocfs2/dlmglue.c |   16 ++++------------
 2 files changed, 6 insertions(+), 15 deletions(-)

--- a/fs/ocfs2/dcache.h~ocfs2-cache-the-mount-context-for-dentry-lock-callbacks
+++ a/fs/ocfs2/dcache.h
@@ -17,9 +17,8 @@ struct ocfs2_dentry_lock {
 	u64			dl_parent_blkno;
 
 	/*
-	 * The ocfs2_dentry_lock keeps an inode reference until
-	 * dl_lockres has been destroyed. This is usually done in
-	 * ->d_iput() anyway, so there should be minimal impact.
+	 * The inode reference is dropped before dl_lockres is unlocked.
+	 * Callbacks must not use it to find the mount context during teardown.
 	 */
 	struct inode		*dl_inode;
 	struct ocfs2_lock_res	dl_lockres;
--- a/fs/ocfs2/dlmglue.c~ocfs2-cache-the-mount-context-for-dentry-lock-callbacks
+++ a/fs/ocfs2/dlmglue.c
@@ -58,7 +58,6 @@ struct ocfs2_mask_waiter {
 #endif
 };
 
-static struct ocfs2_super *ocfs2_get_dentry_osb(struct ocfs2_lock_res *lockres);
 static struct ocfs2_super *ocfs2_get_inode_osb(struct ocfs2_lock_res *lockres);
 static struct ocfs2_super *ocfs2_get_file_osb(struct ocfs2_lock_res *lockres);
 static struct ocfs2_super *ocfs2_get_qinfo_osb(struct ocfs2_lock_res *lockres);
@@ -258,7 +257,6 @@ static const struct ocfs2_lock_res_ops o
 };
 
 static const struct ocfs2_lock_res_ops ocfs2_dentry_lops = {
-	.get_osb	= ocfs2_get_dentry_osb,
 	.post_unlock	= ocfs2_dentry_post_unlock,
 	.downconvert_worker = ocfs2_dentry_convert_worker,
 	.flags		= 0,
@@ -309,7 +307,7 @@ static inline struct ocfs2_dentry_lock *
 {
 	BUG_ON(lockres->l_type != OCFS2_LOCK_TYPE_DENTRY);
 
-	return (struct ocfs2_dentry_lock *)lockres->l_priv;
+	return container_of(lockres, struct ocfs2_dentry_lock, dl_lockres);
 }
 
 static inline struct ocfs2_mem_dqinfo *ocfs2_lock_res_qinfo(struct ocfs2_lock_res *lockres)
@@ -610,13 +608,6 @@ static __u64 ocfs2_get_dentry_lock_ino(s
 	return be64_to_cpu(inode_blkno_be);
 }
 
-static struct ocfs2_super *ocfs2_get_dentry_osb(struct ocfs2_lock_res *lockres)
-{
-	struct ocfs2_dentry_lock *dl = lockres->l_priv;
-
-	return OCFS2_SB(dl->dl_inode->i_sb);
-}
-
 void ocfs2_dentry_lock_res_init(struct ocfs2_dentry_lock *dl,
 				u64 parent, struct inode *inode)
 {
@@ -624,6 +615,7 @@ void ocfs2_dentry_lock_res_init(struct o
 	u64 inode_blkno = OCFS2_I(inode)->ip_blkno;
 	__be64 inode_blkno_be = cpu_to_be64(inode_blkno);
 	struct ocfs2_lock_res *lockres = &dl->dl_lockres;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
 	ocfs2_lock_res_init_once(lockres);
 
@@ -652,9 +644,9 @@ void ocfs2_dentry_lock_res_init(struct o
 	memcpy(&lockres->l_name[OCFS2_DENTRY_LOCK_INO_START], &inode_blkno_be,
 	       sizeof(__be64));
 
-	ocfs2_lock_res_init_common(OCFS2_SB(inode->i_sb), lockres,
+	ocfs2_lock_res_init_common(osb, lockres,
 				   OCFS2_LOCK_TYPE_DENTRY, &ocfs2_dentry_lops,
-				   dl);
+				   osb);
 }
 
 static void ocfs2_super_lock_res_init(struct ocfs2_lock_res *res,
_

Patches currently in -mm which might be from zzzccc427@gmail.com are


