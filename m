Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0A32F83B0
	for <mm-commits@vger.kernel.org>; Mon, 15 Dec 2025 00:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765759115; cv=none; b=Fx2Oz+4qVMCGlAfFGzOnITDv+mClXCNkB+AxW0LoS20Juv2kVFFs9Jh+jNqe5KuzGfm9begmg8i1uHxi28aYYqSf4y6hXi3Z+UZOVO9eSa+7xAbQl7lvuLbPhdWlmiCEPsRkzy3+lTuRi2UyXUEYCSU4D27PHSWYMIGsQdYoXug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765759115; c=relaxed/simple;
	bh=n455Vd8kbOciHwCEIUxgiceTLQbdC4ghaQitrH0onwg=;
	h=Date:To:From:Subject:Message-Id; b=XWNw0FChpD0d0ggRMwdnrWeNxzU32pqhH/oatqc7jfcGpV5j4HaeIAhyAixuZTEp3r+nQoa9CyGguPm01nFgTIoc24nWAuiy+9iWjgMOj1S0eA86n/ifDdbrFPlagK923SNUdnaKTLDTf/fHzYAsWelGRLu5lO8BhQ+RDNrnals=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2IjO7g98; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2IjO7g98"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF314C4CEFB;
	Mon, 15 Dec 2025 00:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765759114;
	bh=n455Vd8kbOciHwCEIUxgiceTLQbdC4ghaQitrH0onwg=;
	h=Date:To:From:Subject:From;
	b=2IjO7g98BVHUdWomdOYSqikywcdqvQZWvpShYK9Vck/4b/fYgIXkuK3jP4FoJu9F2
	 IkChthzG9uvrDqB2n291J6rRpJSt4pLEblENQi+vb14t9Hu/xWJfewb3W5kBVtkION
	 fNsmo4F5qRFQhTPNuOP8+HPUT4wK+4CWbQsRtifE=
Date: Sun, 14 Dec 2025 16:38:34 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,glass.su@suse.com,gechangwei@live.cn,heming.zhao@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-detect-released-suballocator-bg-for-fh_to_.patch added to mm-nonmm-unstable branch
Message-Id: <20251215003834.CF314C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: detect released suballocator BG for fh_to_[dentry|parent]
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-detect-released-suballocator-bg-for-fh_to_.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-detect-released-suballocator-bg-for-fh_to_.patch

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
From: Heming Zhao <heming.zhao@suse.com>
Subject: ocfs2: detect released suballocator BG for fh_to_[dentry|parent]
Date: Fri, 12 Dec 2025 15:45:04 +0800

After ocfs2 gained the ability to reclaim suballocator free block group
(BGs), a suballocator block group may be released.  This change causes the
xfstest case generic/426 to fail.

generic/426 expects return value -ENOENT or -ESTALE, but the current code
triggers -EROFS.

Call stack before ocfs2 gained the ability to reclaim bg:

ocfs2_fh_to_dentry //or ocfs2_fh_to_parent
 ocfs2_get_dentry
  + ocfs2_test_inode_bit
  |  ocfs2_test_suballoc_bit
  |   + ocfs2_read_group_descriptor //Since ocfs2 never releases the bg,
  |   |                             //the bg block was always found.
  |   + *res = ocfs2_test_bit //unlink was called, and the bit is zero
  |
  + if (!set) //because the above *res is 0
     status = -ESTALE //the generic/426 expected return value

Current call stack that triggers -EROFS:

ocfs2_get_dentry
 ocfs2_test_inode_bit
  ocfs2_test_suballoc_bit
   ocfs2_read_group_descriptor
    + if reading a released bg, validation fails and triggers -EROFS

How to fix:
Since the read BG is already released, we must avoid triggering -EROFS. 
With this commit, we use ocfs2_read_hint_group_descriptor() to detect the
released BG block.  This approach quietly handles this type of error and
returns -EINVAL, which triggers the caller's existing conversion path to
-ESTALE.

Link: https://lkml.kernel.org/r/20251212074505.25962-3-heming.zhao@suse.com
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Su Yue <glass.su@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/export.c   |    6 ++++--
 fs/ocfs2/suballoc.c |   26 +++++++++++++++++---------
 2 files changed, 21 insertions(+), 11 deletions(-)

--- a/fs/ocfs2/export.c~ocfs2-detect-released-suballocator-bg-for-fh_to_
+++ a/fs/ocfs2/export.c
@@ -74,8 +74,9 @@ static struct dentry *ocfs2_get_dentry(s
 			 * nice
 			 */
 			status = -ESTALE;
-		} else
+		} else if (status != -ESTALE) {
 			mlog(ML_ERROR, "test inode bit failed %d\n", status);
+		}
 		goto unlock_nfs_sync;
 	}
 
@@ -162,8 +163,9 @@ static struct dentry *ocfs2_get_parent(s
 	if (status < 0) {
 		if (status == -EINVAL) {
 			status = -ESTALE;
-		} else
+		} else if (status != -ESTALE) {
 			mlog(ML_ERROR, "test inode bit failed %d\n", status);
+		}
 		parent = ERR_PTR(status);
 		goto bail_unlock;
 	}
--- a/fs/ocfs2/suballoc.c~ocfs2-detect-released-suballocator-bg-for-fh_to_
+++ a/fs/ocfs2/suballoc.c
@@ -3163,7 +3163,7 @@ static int ocfs2_test_suballoc_bit(struc
 	struct ocfs2_group_desc *group;
 	struct buffer_head *group_bh = NULL;
 	u64 bg_blkno;
-	int status;
+	int status, quiet = 0, released;
 
 	trace_ocfs2_test_suballoc_bit((unsigned long long)blkno,
 				      (unsigned int)bit);
@@ -3179,9 +3179,13 @@ static int ocfs2_test_suballoc_bit(struc
 
 	bg_blkno = group_blkno ? group_blkno :
 		   ocfs2_which_suballoc_group(blkno, bit);
-	status = ocfs2_read_group_descriptor(suballoc, alloc_di, bg_blkno,
-					     &group_bh);
-	if (status < 0) {
+	status = ocfs2_read_hint_group_descriptor(suballoc, alloc_di, bg_blkno,
+					     &group_bh, &released);
+	if (released) {
+		quiet = 1;
+		status = -ESTALE;
+		goto bail;
+	} else if (status < 0) {
 		mlog(ML_ERROR, "read group %llu failed %d\n",
 		     (unsigned long long)bg_blkno, status);
 		goto bail;
@@ -3193,7 +3197,7 @@ static int ocfs2_test_suballoc_bit(struc
 bail:
 	brelse(group_bh);
 
-	if (status)
+	if (status && !quiet)
 		mlog_errno(status);
 	return status;
 }
@@ -3213,7 +3217,7 @@ bail:
  */
 int ocfs2_test_inode_bit(struct ocfs2_super *osb, u64 blkno, int *res)
 {
-	int status;
+	int status, quiet = 0;
 	u64 group_blkno = 0;
 	u16 suballoc_bit = 0, suballoc_slot = 0;
 	struct inode *inode_alloc_inode;
@@ -3255,8 +3259,12 @@ int ocfs2_test_inode_bit(struct ocfs2_su
 
 	status = ocfs2_test_suballoc_bit(osb, inode_alloc_inode, alloc_bh,
 					 group_blkno, blkno, suballoc_bit, res);
-	if (status < 0)
-		mlog(ML_ERROR, "test suballoc bit failed %d\n", status);
+	if (status < 0) {
+		if (status == -ESTALE)
+			quiet = 1;
+		else
+			mlog(ML_ERROR, "test suballoc bit failed %d\n", status);
+	}
 
 	ocfs2_inode_unlock(inode_alloc_inode, 0);
 	inode_unlock(inode_alloc_inode);
@@ -3264,7 +3272,7 @@ int ocfs2_test_inode_bit(struct ocfs2_su
 	iput(inode_alloc_inode);
 	brelse(alloc_bh);
 bail:
-	if (status)
+	if (status && !quiet)
 		mlog_errno(status);
 	return status;
 }
_

Patches currently in -mm which might be from heming.zhao@suse.com are

ocfs2-give-ocfs2-the-ability-to-reclaim-suballocator-free-bg.patch
ocfs2-detect-released-suballocator-bg-for-fh_to_.patch

