Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F410E45D926
	for <mm-commits@vger.kernel.org>; Fri, 18 Sep 2026 05:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789710231; cv=none; b=aYOrjwLtPPQGGrbA1FTg6hkfVF8Klvswp3u/3imYvDkI3ewF3k7iraD08EjGaGAReyCxPOI46VBDXL49JGFyZJZbKMPKnt+QPJaZZLptqGV7ov+RWG7BiDxRrddhkc7CqfE4hMzJeMPHjymCPb+L/zLfqwsUIkMiC1MYtRlZz8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789710231; c=relaxed/simple;
	bh=0k49QMKeU1TB69njqJ4FWQ+Wppn1nzAU5DLU0CjH2Qs=;
	h=Date:To:From:Subject:Message-Id; b=korvw+to0GBoxehrWyNzKAr4+HXBvuKP+cEHKG0TzcNRXv0hZhdqpFroke84pcT6CzVb4FZq3NBVvaY2Z/ql6wUpoKLUBb62IbrIEjXs+BpxqFKCy4r0ankg7TRdoK4Zp+//MWqZgajCYmhQdw+EDQ0iWR9Rm2TeygumT4pJHpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HK/x3n4o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HK/x3n4o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF5AA1F000FF;
	Fri, 18 Sep 2026 05:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789710229;
	bh=b/mGYYgKP92jNw+nhaDdk4gHzL+2QixEbtUToMPGjBw=;
	h=Date:To:From:Subject;
	b=HK/x3n4oqD42Hox0NWimFo0ZPeYDwP2e5q5QpF1yMpFx6mTBqib9pryAr+B1OAZv6
	 htxsMb9VZhAkCeqBzSkkNBE2gEZWK9OjUW52PH774sc64N0pAGXYVaCaubpxRhGsk+
	 2051puwxwHJsycTvSEc+D00AZ0Pw++qNLKtI6J3s=
Date: Thu, 17 Sep 2026 22:43:49 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,lkp@intel.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] ocfs2-make-ocfs2_calc_xattr_init-return-void.patch removed from -mm tree
Message-Id: <20260918054349.BF5AA1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: make ocfs2_calc_xattr_init() return void
has been removed from the -mm tree.  Its filename was
     ocfs2-make-ocfs2_calc_xattr_init-return-void.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: make ocfs2_calc_xattr_init() return void
Date: Fri, 4 Sep 2026 10:37:51 +0800

ocfs2_calc_xattr_init() used to read the default ACL off the parent inode
itself, so it could return an error from ocfs2_xattr_get_nolock().  Commit
bd7c05fb4a47 ("ocfs2: fix circular locking dependency in
ocfs2_init_acl()") moved that lookup before the transaction starts and
deleted the error path, but left the now vestigial 'int ret = 0'
declaration and both 'return ret' statements behind, along with an
unreachable error branch in ocfs2_mknod().

Drop the leftover variable and convert the return type to void, so the
callee states that it always succeeds and the caller no longer carries a
check that can never trigger.

No functional change.

Link: https://lore.kernel.org/20260904023751.3703334-1-joseph.qi@linux.alibaba.com
Fixes: bd7c05fb4a47 ("ocfs2: fix circular locking dependency in ocfs2_init_acl()")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202609040247.8B3lmoqX-lkp@intel.com/
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
---

 fs/ocfs2/namei.c |    9 ++-------
 fs/ocfs2/xattr.c |   13 +++++--------
 fs/ocfs2/xattr.h |    8 ++++----
 3 files changed, 11 insertions(+), 19 deletions(-)

--- a/fs/ocfs2/namei.c~ocfs2-make-ocfs2_calc_xattr_init-return-void
+++ a/fs/ocfs2/namei.c
@@ -336,13 +336,8 @@ static int ocfs2_mknod(struct mnt_idmap
 		goto leave;
 
 	/* calculate meta data/clusters for setting security and acl xattr */
-	status = ocfs2_calc_xattr_init(dir, mode, &si, &want_clusters,
-				       &xattr_credits, &want_meta,
-				       &acl_state);
-	if (status < 0) {
-		mlog_errno(status);
-		goto leave;
-	}
+	ocfs2_calc_xattr_init(dir, mode, &si, &want_clusters, &xattr_credits,
+			      &want_meta, &acl_state);
 
 	/* Reserve a cluster if creating an extent based directory. */
 	if (S_ISDIR(mode) && !ocfs2_supports_inline_data(osb)) {
--- a/fs/ocfs2/xattr.c~ocfs2-make-ocfs2_calc_xattr_init-return-void
+++ a/fs/ocfs2/xattr.c
@@ -635,12 +635,11 @@ int ocfs2_calc_security_init(struct inod
 	return ret;
 }
 
-int ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
-			  struct ocfs2_security_xattr_info *si,
-			  int *want_clusters, int *xattr_credits,
-			  int *want_meta, struct ocfs2_acl_state *acl_state)
+void ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
+			   struct ocfs2_security_xattr_info *si,
+			   int *want_clusters, int *xattr_credits,
+			   int *want_meta, struct ocfs2_acl_state *acl_state)
 {
-	int ret = 0;
 	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
 	int s_size = 0, a_size = 0, acl_len = 0, new_clusters;
 
@@ -662,7 +661,7 @@ int ocfs2_calc_xattr_init(struct inode *
 	}
 
 	if (!(s_size + a_size))
-		return ret;
+		return;
 
 	/*
 	 * The max space of security xattr taken inline is
@@ -728,8 +727,6 @@ int ocfs2_calc_xattr_init(struct inode *
 			}
 		}
 	}
-
-	return ret;
 }
 
 static int ocfs2_xattr_extend_allocation(struct inode *inode,
--- a/fs/ocfs2/xattr.h~ocfs2-make-ocfs2_calc_xattr_init-return-void
+++ a/fs/ocfs2/xattr.h
@@ -59,10 +59,10 @@ int ocfs2_calc_security_init(struct inod
 			     int *, int *, struct ocfs2_alloc_context **);
 
 struct ocfs2_acl_state;
-int ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
-			  struct ocfs2_security_xattr_info *si,
-			  int *want_clusters, int *xattr_credits,
-			  int *want_meta, struct ocfs2_acl_state *acl_state);
+void ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
+			   struct ocfs2_security_xattr_info *si,
+			   int *want_clusters, int *xattr_credits,
+			   int *want_meta, struct ocfs2_acl_state *acl_state);
 
 /*
  * xattrs can live inside an inode, as part of an external xattr block,
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-fix-deadlock-in-inline-data-truncate-transactions.patch
ocfs2-exit-recovery-thread-on-mount-error-path.patch
ocfs2-free-replay-slots-in-ocfs2_recovery_exit.patch
ocfs2-defer-suballocator-block-group-reclaim-to-workqueue.patch
ocfs2-restrict-ocfs2_invalid_slot-suballoc-slot-to-system-inodes.patch
ocfs2-validate-suballoc-bit-during-inode-read.patch
ocfs2-validate-suballoc-slot-and-bit-of-xattr-and-dir-index-blocks.patch
ocfs2-validate-suballoc-slot-and-bit-of-extent-and-refcount-blocks.patch
ocfs2-allow-xattr-bucket-entries-to-span-multiple-blocks.patch
ocfs2-reject-inconsistent-xattr-bucket-during-defrag.patch
ocfs2-skip-uninitialized-lockres-in-ocfs2_mark_lockres_freeing.patch
ocfs2-validate-dr_fs_generation-of-dir-index-root-blocks.patch
ocfs2-validate-dl_blkno-and-dl_fs_generation-of-dir-index-leaf-blocks.patch
ocfs2-retain-all-security-xattrs-during-inode-creation.patch

