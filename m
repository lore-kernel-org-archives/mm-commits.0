Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33C1369D61;
	Tue, 19 May 2026 17:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779212714; cv=none; b=drXbxjw1OjOfpZ8RcI0I7+wH4WlDtWqR4MueKJYmKRcE1ag3RsWoOFOM/u9fnIiP2HHG3RmwBzoGt/WjFSL3MBhf+2s7nKasCof7sFKfpct5fjrU3NmDwWM4a+qqBb5J8hFgKwAIZjigWgoz1i2Fq26WkKupTrnqPDCcCq6s594=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779212714; c=relaxed/simple;
	bh=7CPpJYmNLt17L0At4vHa0RkmXAWe4kjKxb/+DkSeZfY=;
	h=Date:To:From:Subject:Message-Id; b=eFN6gXlG+goS2v5kEEMcuLkyLPL4taENLiQRf9cu/dqjU5KIiOtpyJnfl4vEbkQK8pxUi2stfMF0CxSLfwMcd97kYvl1VDlXKr77PJZavEE6e+og6KeEWCjFVBUBzk+w2ZzoqXDj5AHUk12qWWoTod/t6I30I8IxlC+RL9qqjcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sMuhMV0u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sMuhMV0u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFBB2C2BCB3;
	Tue, 19 May 2026 17:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779212713;
	bh=7CPpJYmNLt17L0At4vHa0RkmXAWe4kjKxb/+DkSeZfY=;
	h=Date:To:From:Subject:From;
	b=sMuhMV0uVXThxqoQv47d8gawfxwqAn/SOUYhqR9EBjNHqRaZW74EB8xH6otrKQ8iT
	 vXw/aZ65lvJKAo3iWW2Crf1zpPmVXmxt8Mf5nmy1xvEjRxoW3rcWo0zwI0rI3OsUvV
	 t7CVjNnJJq0mWRuU+n3Yc7ObDIiWXWHci4XAhhAs=
Date: Tue, 19 May 2026 10:45:13 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,michael.bommarito@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-reject-dinodes-with-non-canonical-i_mode-type.patch added to mm-nonmm-unstable branch
Message-Id: <20260519174513.AFBB2C2BCB3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: reject dinodes with non-canonical i_mode type
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-reject-dinodes-with-non-canonical-i_mode-type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-reject-dinodes-with-non-canonical-i_mode-type.patch

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

ocfs2-reject-dinodes-with-non-canonical-i_mode-type.patch
ocfs2-reject-dinodes-whose-i_rdev-disagrees-with-the-file-type.patch
ocfs2-reject-non-inline-dinodes-with-i_size-and-zero-i_clusters.patch

