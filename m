Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BD2372ECD;
	Fri, 29 May 2026 04:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028835; cv=none; b=W5Oe6j3jA+dGsLXbXZiyAu5kZOSg4wP2v+WyK8n8UQ9sfpe1J0LxDULhdJki7kVFDcpFemWX+zFWg4r7Wh2koOg1dbj4bKYKbIVVsJP3m+J1ttMwZ3kcmnC/4ylKwEETDe0pBRT7CVt8l29eCv2pBeaNT8CgsFaI1WPC6Msri80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028835; c=relaxed/simple;
	bh=7H3jtJrmGkzHd5U27g4ueC2xm7p/e8Q7gC1xS9vASf0=;
	h=Date:To:From:Subject:Message-Id; b=PTffzlcEuS80Cf+MT3PJ/CFqh6Vnh0HISOtxaUPYz3M7eYiKkAR7Km/89zOm0vbVdha8DyK+SfqP+Jus/nzMLhVW5ynxR1QC9Ppcwx/xuDhz9gPVDCxgtXQ3yd2WqU1d/9TVxaqFsjt92Jord2ZdX7HJfN7uXyvsySraqLcuYCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l1SrQdca; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l1SrQdca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E72D41F00893;
	Fri, 29 May 2026 04:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028834;
	bh=/6480lqJ6RmSTe5TykyJwi6gLJad4vicRL+rezlK/mQ=;
	h=Date:To:From:Subject;
	b=l1SrQdca/Lh5J3qFbbuxGEnMwABQR0ewP4gDhQ4a5I1gXi4dUv7NmWFwfzNr/EVj3
	 wA3DUWcTMyyj8OD5Vi6na9dIi5g1m2vPf7UWPlqlYA3CeaOq9gUMgM/wFxiR4XEK86
	 mRLhWhMnIPOwUT7CJ6f5m2H4aeyIPVIkEd96nhWo=
Date: Thu, 28 May 2026 21:27:13 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,michael.bommarito@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-reject-dinodes-with-non-canonical-i_mode-type.patch removed from -mm tree
Message-Id: <20260529042713.E72D41F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: reject dinodes with non-canonical i_mode type
has been removed from the -mm tree.  Its filename was
     ocfs2-reject-dinodes-with-non-canonical-i_mode-type.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Michael Bommarito <michael.bommarito@gmail.com>
Subject: ocfs2: reject dinodes with non-canonical i_mode type
Date: Tue, 19 May 2026 07:04:02 -0400

Patch series "ocfs2: harden inode validators against forged metadata", v2.

This series adds three structural checks to OCFS2 dinode validation so
malformed on-disk fields are rejected before ocfs2_populate_inode() copies
them into the in-core inode.

The checks cover:

  - i_mode values whose type bits do not name a canonical POSIX file
    type;
  - non-device dinodes whose id1.dev1.i_rdev field is non-zero; and
  - non-inline dinodes that claim non-zero i_size while i_clusters is
    zero, covering directories unconditionally and regular files on
    non-sparse volumes.

The normal read path reports these through ocfs2_error(), matching the
existing suballoc-slot, inline-data, chain-list, and refcount checks.  The
online filecheck path uses the same structural predicates but keeps its
own reporting contract, returning OCFS2_FILECHECK_ERR_INVALIDINO instead
of calling ocfs2_error().


This patch (of 3):

ocfs2_validate_inode_block() currently accepts any non-zero i_mode value. 
ocfs2_populate_inode() then copies that mode verbatim into inode->i_mode
and dispatches on i_mode & S_IFMT to the file/dir/symlink/special_file
iops; an unrecognised type falls through to ocfs2_special_file_iops and
init_special_inode().

Reject dinodes whose type bits do not name one of the seven canonical
POSIX file types.  Use fs_umode_to_ftype(), the same generic file-type
conversion helper OCFS2 already uses for directory entries, so the
accepted inode type set matches the kernel file-type vocabulary instead of
open-coding a local switch.

Apply the same structural check to the online filecheck read path. 
filecheck keeps its own error namespace, so it reports malformed i_mode
through the filecheck logger and OCFS2_FILECHECK_ERR_INVALIDINO instead of
calling ocfs2_error(), but it must not allow a malformed dinode to proceed
into ocfs2_populate_inode().

Link: https://lore.kernel.org/20260519110404.1803902-1-michael.bommarito@gmail.com
Link: https://lore.kernel.org/20260519110404.1803902-2-michael.bommarito@gmail.com
Fixes: b657c95c1108 ("ocfs2: Wrap inode block reads in a dedicated function.")
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Link: https://sashiko.dev/#/patchset/20260517111015.3187935-1-michael.bommarito%40gmail.com
Assisted-by: Claude:claude-opus-4-7
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c |   36 ++++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/inode.c~ocfs2-reject-dinodes-with-non-canonical-i_mode-type
+++ a/fs/ocfs2/inode.c
@@ -13,6 +13,7 @@
 #include <linux/pagemap.h>
 #include <linux/quotaops.h>
 #include <linux/iversion.h>
+#include <linux/fs_dirent.h>
 
 #include <asm/byteorder.h>
 
@@ -64,7 +65,12 @@ static int ocfs2_filecheck_read_inode_bl
 static int ocfs2_filecheck_validate_inode_block(struct super_block *sb,
 						struct buffer_head *bh);
 static int ocfs2_filecheck_repair_inode_block(struct super_block *sb,
-					      struct buffer_head *bh);
+						      struct buffer_head *bh);
+
+static bool ocfs2_valid_inode_mode(umode_t mode)
+{
+	return fs_umode_to_ftype(mode) != FT_UNKNOWN;
+}
 
 void ocfs2_set_inode_flags(struct inode *inode)
 {
@@ -1494,6 +1500,24 @@ int ocfs2_validate_inode_block(struct su
 		goto bail;
 	}
 
+	/*
+	 * Reject dinodes whose i_mode does not name one of the seven
+	 * canonical POSIX file types.  ocfs2_populate_inode() copies
+	 * i_mode verbatim into inode->i_mode and then dispatches via
+	 * switch (mode & S_IFMT) to file/dir/symlink/special_file iops;
+	 * an unrecognised type falls into ocfs2_special_file_iops with
+	 * init_special_inode(), which interprets i_rdev.  Constrain the
+	 * type here so the dispatch only ever sees a value mkfs.ocfs2 /
+	 * VFS can produce.
+	 */
+	if (!ocfs2_valid_inode_mode(le16_to_cpu(di->i_mode))) {
+		rc = ocfs2_error(sb,
+				 "Invalid dinode #%llu: mode 0%o has unknown file type\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le16_to_cpu(di->i_mode));
+		goto bail;
+	}
+
 	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL) {
 		struct ocfs2_inline_data *data = &di->id2.i_data;
 
@@ -1624,6 +1648,15 @@ static int ocfs2_filecheck_validate_inod
 		     (unsigned long long)bh->b_blocknr,
 		     le32_to_cpu(di->i_fs_generation));
 		rc = -OCFS2_FILECHECK_ERR_GENERATION;
+		goto bail;
+	}
+
+	if (!ocfs2_valid_inode_mode(le16_to_cpu(di->i_mode))) {
+		mlog(ML_ERROR,
+		     "Filecheck: invalid dinode #%llu: mode 0%o has unknown file type\n",
+		     (unsigned long long)bh->b_blocknr,
+		     le16_to_cpu(di->i_mode));
+		rc = -OCFS2_FILECHECK_ERR_INVALIDINO;
 	}
 
 bail:
@@ -1812,4 +1845,3 @@ const struct ocfs2_caching_operations oc
 	.co_io_lock		= ocfs2_inode_cache_io_lock,
 	.co_io_unlock		= ocfs2_inode_cache_io_unlock,
 };
-
_

Patches currently in -mm which might be from michael.bommarito@gmail.com are


