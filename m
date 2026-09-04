Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37273B14B2
	for <mm-commits@vger.kernel.org>; Fri,  4 Sep 2026 04:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788496603; cv=none; b=RSc79yf/wLeXQOLbySJA1uj90QHW/phs//nRJYIR78SUQ9fg/uSSK7eTfEOTXNBcXLXk0+IZoSVxJnlYE+XOUemwdYm7JloLTT6gayYtrdzFCTzZ12AtPI0+GIAF7+VzDBHOCGgvkAEIBWNBut2WfghqHort2JkInEG3DB40EnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788496603; c=relaxed/simple;
	bh=Ff/b5j7LaqqFDl/e841p4Wyyqxr1dq3wyAwuTVr0YH4=;
	h=Date:To:From:Subject:Message-Id; b=Uu26Rq/2qTXx6gapNqsbD7RpAO/XpRn/QMD/nE4Wr0/6vaCQFE8rwitW9ixiNDXrcKyr5xwSgpXgCEahx9p8EA3hmO8Bm0LRkipRn2b1VcZkh75Oj6HWUDWTGBhUGac1r6d9LVv01Or0Ydpy4p1Jii8/DYKiQNupfs2ZO+VpTWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RMoN46iw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RMoN46iw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E64A1F00A3D;
	Fri,  4 Sep 2026 04:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788496601;
	bh=jEU241X3ncov3if8eXlRwkzDxtaMX4d3Jom5kjZdEOg=;
	h=Date:To:From:Subject;
	b=RMoN46iwoo9b1lxlZJwdFaVzCv7Ts2BJdoYoeQ5bQPbcwlzbJ+NOmQzpklvoso3tY
	 BJS+nF/0QtuWLP1gcyyIQQgNOBZ4P0Dc4KJDivCLC9ejGIYiJgJI11BiKCAWMW2pc7
	 uZZrw3a9Jhsjiwo1n1B4if58xfPDprp0v4+N2Lho=
Date: Thu, 03 Sep 2026 21:36:40 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,lkp@intel.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-make-ocfs2_calc_xattr_init-return-void.patch added to mm-hotfixes-unstable branch
Message-Id: <20260904043641.5E64A1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: make ocfs2_calc_xattr_init() return void
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ocfs2-make-ocfs2_calc_xattr_init-return-void.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-make-ocfs2_calc_xattr_init-return-void.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202609040247.8B3lmoqX-lkp@intel.com/
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

ocfs2-make-ocfs2_calc_xattr_init-return-void.patch
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

