Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8EDA3EDE6F
	for <mm-commits@vger.kernel.org>; Tue, 12 May 2026 22:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778624129; cv=none; b=J6IKohsqkeoMUOvaMTpBQO+SwDJzBd5Rm4SZ/9dcaMhXNh7Wrj7qaHSjWPhd/0aF3VcFUFPriczt2Q/cGzeCO5MqlSxcq79L0GYgfygbhZDFLYtd0gOTX5ESQytQANHk5TVucJv2t8b1Cks4SuREVYMx8EvHedEtikeuecHTQoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778624129; c=relaxed/simple;
	bh=8oqu1Scl5E7Y28NyjHzqQF+i0SEVutQ4qqISeuAcvNM=;
	h=Date:To:From:Subject:Message-Id; b=bNMWp3OajL7r0bJl24rzgx0BWx9LPEt0gSGVN94cl+fozT83bZdiBydbJrddFlnousx48E06O5LfX2vRbJSA9dOlBOC8aNHDNayEN2WRQN9yWqujPisFMWzYAmKclCt/irS8mvpMNeY5TGQ3shMuSgd4ZqcOOcE+ZDVhF4RcnP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=exM6CkBk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="exM6CkBk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F65AC2BCB0;
	Tue, 12 May 2026 22:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778624129;
	bh=8oqu1Scl5E7Y28NyjHzqQF+i0SEVutQ4qqISeuAcvNM=;
	h=Date:To:From:Subject:From;
	b=exM6CkBkYlVgL8S+PeqpcAizSaDvxMLgKu521xd2Be4CV74QrTNaEcEBelDzKekrz
	 +wSGteYT+tu+HyZdkE/VnuAQyo+XwG8T6nrZnhN8kV6s4rshlmRcmM5xAWreAZ6tYJ
	 0rytTWFKk7qENbqK2x4ohkCfnVhVFkZO5spEvZA0=
Date: Tue, 12 May 2026 15:15:28 -0700
To: mm-commits@vger.kernel.org,r33s3n6@gmail.com,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,baijiaju1990@gmail.com,gality369@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-validate-inline-xattr-header-before-ibody-lookups.patch added to mm-nonmm-unstable branch
Message-Id: <20260512221529.3F65AC2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: validate inline xattr header before ibody lookups
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-validate-inline-xattr-header-before-ibody-lookups.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-validate-inline-xattr-header-before-ibody-lookups.patch

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
From: ZhengYuan Huang <gality369@gmail.com>
Subject: ocfs2: validate inline xattr header before ibody lookups
Date: Fri, 8 May 2026 16:59:10 +0800

Patch series "ocfs2: validate inline xattr header consumers".

Corrupt i_xattr_inline_size can move the computed inode-body xattr header
outside the dinode block. Several OCFS2 paths then trust xh_count or
xattr entry geometry from that unchecked header.

The reported KASAN splat hits the ibody lookup path:

  BUG: KASAN: use-after-free in ocfs2_xattr_find_entry+0x37b/0x3a0
  ocfs2_xattr_ibody_get()
  ocfs2_xattr_get_nolock()
  ocfs2_calc_xattr_init()

The same unchecked header derivation also exists in the outside-value
probe, ibody remove, inline refcount attach, and inline reflink paths.

This series factors the existing ibody list validation into a shared
helper and then converts the remaining inline-header consumers one at a
time.

Patch layout:

1. validate ibody get/find and reuse the helper in ibody list
2. validate the outside-value probe
3. validate ibody remove
4. validate inline refcount attach
5. validate inline reflink


This patch (of 5):

[BUG]
mknodat() can read past the end of a dinode block when ACL inheritance
walks a corrupted inode-body xattr header. Another report shows the same
unchecked lookup later faulting in the VFS open path after create
returns a garbage status.

KASAN: use-after-free in
ocfs2_xattr_find_entry+0x37b/0x3a0 fs/ocfs2/xattr.c:1078
Read of size 2 at addr ffff88801c520300 by task syz.0.10/360

Trace:
 ...
 ocfs2_xattr_find_entry+0x37b/0x3a0 fs/ocfs2/xattr.c:1078
 ocfs2_xattr_ibody_get fs/ocfs2/xattr.c:1178 [inline]
 ocfs2_xattr_get_nolock+0x2ee/0x1110 fs/ocfs2/xattr.c:1309
 ocfs2_calc_xattr_init+0x716/0xac0 fs/ocfs2/xattr.c:628
 ocfs2_mknod+0x935/0x2400 fs/ocfs2/namei.c:333
 ocfs2_create+0x158/0x390 fs/ocfs2/namei.c:676
 vfs_create fs/namei.c:3493 [inline]
 vfs_create+0x445/0x6f0 fs/namei.c:3477
 do_mknodat+0x2d8/0x5e0 fs/namei.c:4372
 __do_sys_mknodat fs/namei.c:4400 [inline]
 __se_sys_mknodat fs/namei.c:4397 [inline]
 __x64_sys_mknodat+0xb6/0xf0 fs/namei.c:4397
 ...

Another report:
 BUG: unable to handle page fault for address: fffffbfff3e40ec0
 RIP: 0010:__d_entry_type include/linux/dcache.h:414 [inline]
 RIP: 0010:d_can_lookup include/linux/dcache.h:429 [inline]
 RIP: 0010:d_is_dir include/linux/dcache.h:439 [inline]
 RIP: 0010:path_openat+0xe2f/0x2ce0 fs/namei.c:4134

Trace:
 ...
 do_filp_open+0x1f6/0x430 fs/namei.c:4161
 do_sys_openat2+0x117/0x1c0 fs/open.c:1437
 __x64_sys_openat+0x15b/0x220 fs/open.c:1463
 ...

[CAUSE]
ocfs2_xattr_ibody_list() already validates the inline xattr size and
entry count, but ocfs2_xattr_ibody_get() and ocfs2_xattr_ibody_find()
still derive the inline header directly from di->i_xattr_inline_size and
then trust xh_count. A corrupted inline size or entry count can therefore
move the computed header outside the dinode block before get/find start
walking it. That can either make ocfs2_xattr_find_entry() dereference
xs->header->xh_count outside the block or make ocfs2_xattr_get_nolock()
bubble a garbage status back through ocfs2_calc_xattr_init() into the
create/open path.

[FIX]
Factor the existing ibody header geometry checks into a shared helper.
Use it in ocfs2_xattr_ibody_get() and ocfs2_xattr_ibody_find(), and have
ocfs2_xattr_ibody_list() reuse the same helper instead of open-coding
the validation. Reject corrupt ibody metadata with -EFSCORRUPTED before
the lookup path can walk bogus xattr geometry or return a garbage status.

Link: https://lore.kernel.org/20260508085914.61647-1-gality369@gmail.com
Link: https://lore.kernel.org/20260508085914.61647-2-gality369@gmail.com
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: Zixuan Fu <r33s3n6@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/xattr.c |   82 +++++++++++++++++++++++++--------------------
 1 file changed, 47 insertions(+), 35 deletions(-)

--- a/fs/ocfs2/xattr.c~ocfs2-validate-inline-xattr-header-before-ibody-lookups
+++ a/fs/ocfs2/xattr.c
@@ -950,6 +950,41 @@ static int ocfs2_xattr_list_entries(stru
 	return result;
 }
 
+static int ocfs2_xattr_ibody_lookup_header(struct inode *inode,
+					   struct ocfs2_dinode *di,
+					   struct ocfs2_xattr_header **header)
+{
+	u16 xattr_count;
+	size_t max_entries;
+	u16 inline_size = le16_to_cpu(di->i_xattr_inline_size);
+
+	if (inline_size > inode->i_sb->s_blocksize ||
+	    inline_size < sizeof(struct ocfs2_xattr_header)) {
+		ocfs2_error(inode->i_sb,
+			    "Invalid xattr inline size %u in inode %llu\n",
+			    inline_size,
+			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
+		return -EFSCORRUPTED;
+	}
+
+	*header = (struct ocfs2_xattr_header *)
+		((void *)di + inode->i_sb->s_blocksize - inline_size);
+
+	xattr_count = le16_to_cpu((*header)->xh_count);
+	max_entries = (inline_size - sizeof(struct ocfs2_xattr_header)) /
+		      sizeof(struct ocfs2_xattr_entry);
+
+	if (xattr_count > max_entries) {
+		ocfs2_error(inode->i_sb,
+			    "xattr entry count %u exceeds maximum %zu in inode %llu\n",
+			    xattr_count, max_entries,
+			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
+}
+
 int ocfs2_has_inline_xattr_value_outside(struct inode *inode,
 					 struct ocfs2_dinode *di)
 {
@@ -975,39 +1010,13 @@ static int ocfs2_xattr_ibody_list(struct
 	struct ocfs2_xattr_header *header = NULL;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 	int ret = 0;
-	u16 xattr_count;
-	size_t max_entries;
-	u16 inline_size;
 
 	if (!(oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL))
 		return ret;
 
-	inline_size = le16_to_cpu(di->i_xattr_inline_size);
-
-	/* Validate inline size is reasonable */
-	if (inline_size > inode->i_sb->s_blocksize ||
-	    inline_size < sizeof(struct ocfs2_xattr_header)) {
-		ocfs2_error(inode->i_sb,
-			    "Invalid xattr inline size %u in inode %llu\n",
-			    inline_size,
-			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
-		return -EFSCORRUPTED;
-	}
-
-	header = (struct ocfs2_xattr_header *)
-		 ((void *)di + inode->i_sb->s_blocksize - inline_size);
-
-	xattr_count = le16_to_cpu(header->xh_count);
-	max_entries = (inline_size - sizeof(struct ocfs2_xattr_header)) /
-		       sizeof(struct ocfs2_xattr_entry);
-
-	if (xattr_count > max_entries) {
-		ocfs2_error(inode->i_sb,
-			    "xattr entry count %u exceeds maximum %zu in inode %llu\n",
-			    xattr_count, max_entries,
-			    (unsigned long long)OCFS2_I(inode)->ip_blkno);
-		return -EFSCORRUPTED;
-	}
+	ret = ocfs2_xattr_ibody_lookup_header(inode, di, &header);
+	if (ret)
+		return ret;
 
 	ret = ocfs2_xattr_list_entries(inode, header, buffer, buffer_size);
 
@@ -1200,8 +1209,9 @@ static int ocfs2_xattr_ibody_get(struct
 		return -ENODATA;
 
 	xs->end = (void *)di + inode->i_sb->s_blocksize;
-	xs->header = (struct ocfs2_xattr_header *)
-			(xs->end - le16_to_cpu(di->i_xattr_inline_size));
+	ret = ocfs2_xattr_ibody_lookup_header(inode, di, &xs->header);
+	if (ret)
+		return ret;
 	xs->base = (void *)xs->header;
 	xs->here = xs->header->xh_entries;
 
@@ -2726,12 +2736,14 @@ static int ocfs2_xattr_ibody_find(struct
 
 	xs->xattr_bh = xs->inode_bh;
 	xs->end = (void *)di + inode->i_sb->s_blocksize;
-	if (oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL)
-		xs->header = (struct ocfs2_xattr_header *)
-			(xs->end - le16_to_cpu(di->i_xattr_inline_size));
-	else
+	if (oi->ip_dyn_features & OCFS2_INLINE_XATTR_FL) {
+		ret = ocfs2_xattr_ibody_lookup_header(inode, di, &xs->header);
+		if (ret)
+			return ret;
+	} else {
 		xs->header = (struct ocfs2_xattr_header *)
 			(xs->end - OCFS2_SB(inode->i_sb)->s_xattr_inline_size);
+	}
 	xs->base = (void *)xs->header;
 	xs->here = xs->header->xh_entries;
 
_

Patches currently in -mm which might be from gality369@gmail.com are

ocfs2-reject-inconsistent-inode-size-before-truncate.patch
ocfs2-dont-bug_on-an-invalid-journal-dinode.patch
ocfs2-validate-inline-xattr-header-before-ibody-lookups.patch
ocfs2-validate-inline-xattr-header-before-checking-outside-values.patch
ocfs2-validate-inline-xattr-header-before-ibody-remove.patch
ocfs2-validate-inline-xattr-header-before-inline-refcount-attach.patch
ocfs2-validate-inline-xattr-header-before-reflinking-inline-xattrs.patch

