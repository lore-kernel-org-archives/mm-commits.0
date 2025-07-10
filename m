Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C80286D60
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752127168; cv=none; b=cMWxvnowo28OoH9jNeJ5iY5jmAHufIEyZOsW57hrqKl/+nn8n0CHA34MpauCuTmLK/QIXgEzXkLcT6WEbgGs/pQpOM1DWMg/tv5EEFvtSKu/pvFRA3ffGCh7bU06MTDYVeOX9ERwkWBW6J1b3tI/I9C6rHU6bGCdPVl/QsfjYaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752127168; c=relaxed/simple;
	bh=lxSoKoO7OgwWRi1el7YmoVxTrE+9amHrO/povz4A3H4=;
	h=Date:To:From:Subject:Message-Id; b=heSZyq/0iuq8u6e5QJdlyUPQPBVhO+R6y/f950JFEB+wJewiLOChllNjAfr6WlQsxQgI/T0G7x92SbRfNM5RlOaxLeAtDKUwNow4d9yfZ/2PXu74l+wQv+5xoaasToUYLqjOfq4WV/zlWMDKWi6LbO1fPf+c6j3twZlv6/7DhFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VGGBwKl+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VGGBwKl+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5FCC4CEE3;
	Thu, 10 Jul 2025 05:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752127167;
	bh=lxSoKoO7OgwWRi1el7YmoVxTrE+9amHrO/povz4A3H4=;
	h=Date:To:From:Subject:From;
	b=VGGBwKl+ene5Y44Q3b6C5J6Q5z1hPrkWAEZuhVKzvrLlLcBRrmVQu9Rk1c7zyRYdr
	 2SdEWIfUGM+GtQG9fZ33uZSHHoyvsN+AknajDY5MALlJxifqC7j0hh/3IQc8F33qHI
	 HS2sMK3+NwdiJzYU+gnpMvvA0PJMtf8JMTBtu6Eo=
Date: Wed, 09 Jul 2025 22:59:27 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,glass.su@suse.com,gechangwei@live.cn,leo.lilong@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-remove-redundant-null-check-in-rename-path.patch removed from -mm tree
Message-Id: <20250710055927.8A5FCC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: remove redundant NULL check in rename path
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-redundant-null-check-in-rename-path.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Long Li <leo.lilong@huawei.com>
Subject: ocfs2: remove redundant NULL check in rename path
Date: Tue, 17 Jun 2025 09:25:34 +0800

The code checks newfe_bh for NULL after it has already been dereferenced
to access b_data.  This NULL check is unnecessary for two reasons:

1. If ocfs2_inode_lock() succeeds (returns >= 0), newfe_bh is guaranteed
   to be valid.
2. We've already dereferenced newfe_bh to access b_data, so it must be
   non-NULL at this point.

Remove the redundant NULL check in the trace_ocfs2_rename_over_existing()
call to improve code clarity.

Link: https://lkml.kernel.org/r/20250617012534.3458669-1-leo.lilong@huawei.com
Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Su Yue <glass.su@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/namei.c~ocfs2-remove-redundant-null-check-in-rename-path
+++ a/fs/ocfs2/namei.c
@@ -1452,8 +1452,8 @@ static int ocfs2_rename(struct mnt_idmap
 		newfe = (struct ocfs2_dinode *) newfe_bh->b_data;
 
 		trace_ocfs2_rename_over_existing(
-		     (unsigned long long)newfe_blkno, newfe_bh, newfe_bh ?
-		     (unsigned long long)newfe_bh->b_blocknr : 0ULL);
+		     (unsigned long long)newfe_blkno, newfe_bh,
+		     (unsigned long long)newfe_bh->b_blocknr);
 
 		if (S_ISDIR(new_inode->i_mode) || (new_inode->i_nlink == 1)) {
 			status = ocfs2_prepare_orphan_dir(osb, &orphan_dir,
_

Patches currently in -mm which might be from leo.lilong@huawei.com are


