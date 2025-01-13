Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B23825761
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742261; cv=none; b=Q9WRPL2xVlXu1oCv6K/gMbMMxyU1IYNp9KfS5fJU0Yr9tg8MndWA7JmF7vRKB1G3jazzZjE8TQDU6Bhc2/MpKHeHOXQKTQjmi0djeeXxeKAPR45Xaf03ezOb45XFJecM4eiCgPEAu+vGqiUbDCyP+h7n+BPjizVgJ9eugBpMngI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742261; c=relaxed/simple;
	bh=Q+PlX/uervfxKJdJTrGsGpN12hfm4C8ulqGin+uSNd4=;
	h=Date:To:From:Subject:Message-Id; b=VwPrcIWM8AUx3N8XSeZ9g8pJRlCKx8Dr6H/5Yacn/CAs4108DiFsPO//8rWKcH9MxteNt0zI0HYIh0oqTz0pudAlU8Z5pzM/D0n1VcDXeITDRbSAHy3b0vasrCL9MjjAZOkdhZbR0UF1KgiaH/7PSClpEOet8czAI9MhP7t1Gvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IHQ+DwcE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IHQ+DwcE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB42C4CED6;
	Mon, 13 Jan 2025 04:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742260;
	bh=Q+PlX/uervfxKJdJTrGsGpN12hfm4C8ulqGin+uSNd4=;
	h=Date:To:From:Subject:From;
	b=IHQ+DwcErs77etoRzoVphiisv3izHu/n9Uv9ogK8J9M/3kPy4cUMgS6Ev7WF53Jtf
	 45wErC34kDbwRRyYnhueVSdLkMcIqVbhxf/d1RPy6i+8yLoSg1SQVXYL6eJhG2p4Sq
	 3VeS0m7Sek6j2oYG+eNef2a/KSssFqv9mw0NLaF4=
Date: Sun, 12 Jan 2025 20:24:20 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,sunjunchao2870@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-correct-l_next_free_rec-in-online-check.patch removed from -mm tree
Message-Id: <20250113042420.DBB42C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: correct l_next_free_rec in online check
has been removed from the -mm tree.  Its filename was
     ocfs2-correct-l_next_free_rec-in-online-check.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


