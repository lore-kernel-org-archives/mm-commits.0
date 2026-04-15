Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971D53264D4
	for <mm-commits@vger.kernel.org>; Wed, 15 Apr 2026 09:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776244592; cv=none; b=RSDfSyRuPmpSwk8qS8cT7wKLdjdFkGYIMFgNjAu3aqRvqChrfGRO1fI+znpmFdMGfKqDAqUTQvv+wswCszdD6ZAV/gPVYmhy2RWQXBn99x7Svi0dV+EijGj/sj2Vja5QjtrowhYACrSa2EvuqgXju0SHEtGSdQA5RDhR+WGhQpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776244592; c=relaxed/simple;
	bh=lRYbd2uuCJL9Cz6wPOxp8FKH6YtzZBxqB0/LTJMQXkw=;
	h=Date:To:From:Subject:Message-Id; b=dEiUE2vz+W6a4cLdHO0UF5BCN7O7TLZxXqeEbP3WBItd+Q3YpuIp5Kz0UD8R0fcG5P5kBMoW83T23brMCjUgOghXJRF1TAj9HrzpYT1tj8vymo/J1umXBhVkGCM7cl6yPsj/orzdNGsvKCzN0VK1RL34y7pV3CgUhQwp/7iS0Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JGI+Yit5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JGI+Yit5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFAB6C2BCB5;
	Wed, 15 Apr 2026 09:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776244592;
	bh=lRYbd2uuCJL9Cz6wPOxp8FKH6YtzZBxqB0/LTJMQXkw=;
	h=Date:To:From:Subject:From;
	b=JGI+Yit55+DcX87LOn66Q1tzQG6Q3DkrgQazPfmVoxZjfPWofEb8AqwZTeaqBIK16
	 Syi7FKHEa4jYuKgv0aFsT0sOBZwF7t+mAMclQ/6YEAJiULsRmp3baMuBahnglfrcay
	 Fqzcb01Q2Ji3Rvkw6zfqK+mBtRtCK/Pcwtf0qEbE=
Date: Wed, 15 Apr 2026 02:16:28 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-remove-redundant-l_next_free_rec-check-in-__ocfs2_find_path.patch removed from -mm tree
Message-Id: <20260415091631.AFAB6C2BCB5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: remove redundant l_next_free_rec check in __ocfs2_find_path()
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-redundant-l_next_free_rec-check-in-__ocfs2_find_path.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: remove redundant l_next_free_rec check in __ocfs2_find_path()
Date: Fri, 3 Apr 2026 17:08:03 +0800

The l_next_free_rec > l_count check after ocfs2_read_extent_block() in
__ocfs2_find_path() is now redundant, as ocfs2_validate_extent_block()
already performs this validation at block read time.

Remove the duplicate check to avoid maintaining the same validation in two
places.

Link: https://lkml.kernel.org/r/20260403090803.3860971-5-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |   12 ------------
 1 file changed, 12 deletions(-)

--- a/fs/ocfs2/alloc.c~ocfs2-remove-redundant-l_next_free_rec-check-in-__ocfs2_find_path
+++ a/fs/ocfs2/alloc.c
@@ -1878,18 +1878,6 @@ static int __ocfs2_find_path(struct ocfs
 		eb = (struct ocfs2_extent_block *) bh->b_data;
 		el = &eb->h_list;
 
-		if (le16_to_cpu(el->l_next_free_rec) >
-		    le16_to_cpu(el->l_count)) {
-			ocfs2_error(ocfs2_metadata_cache_get_super(ci),
-				    "Owner %llu has bad count in extent list at block %llu (next free=%u, count=%u)\n",
-				    (unsigned long long)ocfs2_metadata_cache_owner(ci),
-				    (unsigned long long)bh->b_blocknr,
-				    le16_to_cpu(el->l_next_free_rec),
-				    le16_to_cpu(el->l_count));
-			ret = -EROFS;
-			goto out;
-		}
-
 		if (func)
 			func(data, bh);
 	}
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are


