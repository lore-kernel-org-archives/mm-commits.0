Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDB12594B1
	for <mm-commits@vger.kernel.org>; Tue,  7 Jan 2025 03:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736218980; cv=none; b=XnplbUs051h7fAtXRVY8m0kTz3g7DPElJFpMsUFHH5JtAZOBSROeuSXH933zlukFtQsg0voYiglDWw0aTeJn3IiN8vMaJBgjxO5GCgHgEaHWjDipjOuK2YxYdmYbTqWVlomm//rnfwgOCQ67pb60qvUnJdBv/MWdufhO2baQfcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736218980; c=relaxed/simple;
	bh=yVipkIwS0bOTnYvTpt6a5FWp8tVPfJIXaCvqgXvVOhM=;
	h=Date:To:From:Subject:Message-Id; b=lnitOFmbXfvoKR6tc4/tR3OXZYcJ9zSYZkVMrPQL6dSDmLUIgQW+4wjezq1MeOyrmU0dR990KT3wuJNFhvnl0GzdCPo/V4VHpxr27GsI3pNyPb52lN/mX9O5aWrjTEhGUOYC3mBW7uCrtA/Bc58Mt528CuRm2h0abl+E/MiI3sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ciLlihnm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ciLlihnm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D789C4CED2;
	Tue,  7 Jan 2025 03:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736218979;
	bh=yVipkIwS0bOTnYvTpt6a5FWp8tVPfJIXaCvqgXvVOhM=;
	h=Date:To:From:Subject:From;
	b=ciLlihnm1ZxuuEkUy+TrKAHEKFGEnprvuVRHOVfGGRNBOOUbWcvZ7yZEr98WrKfaT
	 r157dVlzaj8EL1ocCPguKlgeP6dR11O/o9m8S7bk9lJKSh1XExLqWskusaD7CE5hJm
	 C9x2gdI/CFA8938vdjW5IQfGWAvDdNo/hl++BKSs=
Date: Mon, 06 Jan 2025 19:02:58 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,sunjunchao2870@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-correct-l_next_free_rec-in-online-check.patch added to mm-nonmm-unstable branch
Message-Id: <20250107030259.5D789C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: correct l_next_free_rec in online check
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-correct-l_next_free_rec-in-online-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-correct-l_next_free_rec-in-online-check.patch

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
From: Julian Sun <sunjunchao2870@gmail.com>
Subject: ocfs2: correct l_next_free_rec in online check
Date: Mon, 6 Jan 2025 10:34:32 +0800

Correct the value of l_next_free_rec to l_count during the online check,
as done in the check_el() function in ocfs2_tools.

Link: https://lkml.kernel.org/r/20250106023432.1320904-2-sunjunchao2870@gmail.com
Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/inode.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/fs/ocfs2/inode.c~ocfs2-correct-l_next_free_rec-in-online-check
+++ a/fs/ocfs2/inode.c
@@ -200,6 +200,20 @@ bail:
 	return inode;
 }
 
+static int ocfs2_dinode_has_extents(struct ocfs2_dinode *di)
+{
+	/* inodes flagged with other stuff in id2 */
+	if (di->i_flags & (OCFS2_SUPER_BLOCK_FL | OCFS2_LOCAL_ALLOC_FL |
+			   OCFS2_CHAIN_FL | OCFS2_DEALLOC_FL))
+		return 0;
+	/* i_flags doesn't indicate when id2 is a fast symlink */
+	if (S_ISLNK(di->i_mode) && di->i_size && di->i_clusters == 0)
+		return 0;
+	if (di->i_dyn_features & OCFS2_INLINE_DATA_FL)
+		return 0;
+
+	return 1;
+}
 
 /*
  * here's how inodes get read from disk:
@@ -1547,6 +1561,16 @@ static int ocfs2_filecheck_repair_inode_
 		     le32_to_cpu(di->i_fs_generation));
 	}
 
+	if (ocfs2_dinode_has_extents(di) &&
+	    le16_to_cpu(di->id2.i_list.l_next_free_rec) > le16_to_cpu(di->id2.i_list.l_count)) {
+		di->id2.i_list.l_next_free_rec = di->id2.i_list.l_count;
+		changed = 1;
+		mlog(ML_ERROR,
+		     "Filecheck: reset dinode #%llu: l_next_free_rec to %u\n",
+		     (unsigned long long)bh->b_blocknr,
+		     le16_to_cpu(di->id2.i_list.l_next_free_rec));
+	}
+
 	if (changed || ocfs2_validate_meta_ecc(sb, bh->b_data, &di->i_check)) {
 		ocfs2_compute_meta_ecc(sb, bh->b_data, &di->i_check);
 		mark_buffer_dirty(bh);
_

Patches currently in -mm which might be from sunjunchao2870@gmail.com are

ocfs2-check-el-l_next_free_rec-in-ocfs2_get_clusters_nocache.patch
ocfs2-correct-l_next_free_rec-in-online-check.patch

