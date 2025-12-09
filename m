Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBFA285C96
	for <mm-commits@vger.kernel.org>; Tue,  9 Dec 2025 19:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765308812; cv=none; b=PIN0JCOTq82Ri7xsC9NWHfQw64qaTAEVKkLHoJdhuvsN/Lu6tgXhUKorMOVQh/x5pQNIYtirANTn+QraU+L8jBfRMn8qdD621I/O5Q9t+jxFj80QGz0LjEMHOGMtfkf8i8GrsSQGHl+kCQ7pMYxFqOJSPOIl9UYHAri/bcogJH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765308812; c=relaxed/simple;
	bh=cc5nwFtvlG8rLtzSXYztM+rBp6J+qnKIFGDxf/0/c2k=;
	h=Date:To:From:Subject:Message-Id; b=NxJ1Id9HYWDSOL8MYKS31Vqo35BfFx7a7rafozdy0wk34qdbog/kOhshftxbDiON62AM6Uy/sq5TT3S2DPD8ey92up1g3sLba30LFduxxb903NiN3baJSKNmWz5zbt+2F6jxrVWtstNHJUyCGpVTXusosx1sg3uEbzac8rJvi7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QgIatMHb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QgIatMHb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 713AAC4CEF5;
	Tue,  9 Dec 2025 19:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765308811;
	bh=cc5nwFtvlG8rLtzSXYztM+rBp6J+qnKIFGDxf/0/c2k=;
	h=Date:To:From:Subject:From;
	b=QgIatMHbZ6cIx1W1zhfdLt9iakPdHoc3GRoBxAjKETlxXfQM577twBKCPfL2rYIly
	 GeLZ6pjVPZdXL3wIL77LlWiQCsoP9CrS2qNAtVWGTyQ5gIKNbMepdnqtAnquMrcg1r
	 7AfwIcmdWe4z6ie7fJGPWNoNY0KId578PhKxwxNk=
Date: Tue, 09 Dec 2025 11:33:30 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,david.hunter.linux@gmail.com,albinbabuvarghese20@gmail.com,eraykrdg1@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-invalidate-inode-if-i_mode-is-zero-after-block-read.patch removed from -mm tree
Message-Id: <20251209193331.713AAC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: invalidate inode if i_mode is zero after block read
has been removed from the -mm tree.  Its filename was
     ocfs2-invalidate-inode-if-i_mode-is-zero-after-block-read.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ahmet Eray Karadag <eraykrdg1@gmail.com>
Subject: ocfs2: invalidate inode if i_mode is zero after block read
Date: Wed, 3 Dec 2025 01:45:08 +0300

A panic occurs in ocfs2_unlink due to WARN_ON(inode->i_nlink == 0) when
handling a corrupted inode with i_mode=0 and i_nlink=0 in memory.

This "zombie" inode is created because ocfs2_read_locked_inode proceeds
even after ocfs2_validate_inode_block successfully validates a block that
structurally looks okay (passes checksum, signature etc.) but contains
semantically invalid data (specifically i_mode=0).  The current validation
function doesn't check for i_mode being zero.

This results in an in-memory inode with i_mode=0 being added to the VFS
cache, which later triggers the panic during unlink.

Prevent this by adding an explicit check for (i_mode == 0, i_nlink == 0,
non-orphan) within ocfs2_validate_inode_block.  If the check is true,
return -EFSCORRUPTED to signal corruption.  This causes the caller
(ocfs2_read_locked_inode) to invoke make_bad_inode(), correctly preventing
the zombie inode from entering the cache.

Link: https://lkml.kernel.org/r/20251202224507.53452-2-eraykrdg1@gmail.com
Co-developed-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Signed-off-by: Albin Babu Varghese <albinbabuvarghese20@gmail.com>
Signed-off-by: Ahmet Eray Karadag <eraykrdg1@gmail.com>
Reported-by: syzbot+55c40ae8a0e5f3659f2b@syzkaller.appspotmail.com
Fixes: https://syzkaller.appspot.com/bug?extid=55c40ae8a0e5f3659f2b
Link: https://lore.kernel.org/all/20251022222752.46758-2-eraykrdg1@gmail.com/T/
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: David Hunter <david.hunter.linux@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ocfs2/inode.c~ocfs2-invalidate-inode-if-i_mode-is-zero-after-block-read
+++ a/fs/ocfs2/inode.c
@@ -1461,6 +1461,14 @@ int ocfs2_validate_inode_block(struct su
 		goto bail;
 	}
 
+	if ((!di->i_links_count && !di->i_links_count_hi) || !di->i_mode) {
+		mlog(ML_ERROR, "Invalid dinode #%llu: "
+			"Corrupt state (nlink = %u or mode = %u) detected!\n",
+		        (unsigned long long)bh->b_blocknr,
+			ocfs2_read_links_count(di), le16_to_cpu(di->i_mode));
+		rc = -EFSCORRUPTED;
+		goto bail;
+	}
 	/*
 	 * Errors after here are fatal.
 	 */
_

Patches currently in -mm which might be from eraykrdg1@gmail.com are


