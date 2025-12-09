Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41B52874E1
	for <mm-commits@vger.kernel.org>; Tue,  9 Dec 2025 19:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765308812; cv=none; b=M4n2EOh1Dez1mDcZKGezIBdGcKhm6h0VBNzCv5uICxXxhcFx+c0bgExtjA9ZQ0T0wxthTwZUiigQX7CxYRU9iV66Jf51TisGOV9mJUCPNrQn0pUwVfwQhrpaFIopX0PvlHgsmN0qAak0NSbd34R2GP3IiNGxJesDsKWlKdq99fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765308812; c=relaxed/simple;
	bh=p14VkVY8keWbrmqG6kmvPImIvDa3YSU9GVNM5gc3KU8=;
	h=Date:To:From:Subject:Message-Id; b=iOCSBzVteu8gqVoSBBCIro2QksgbnkABZ1R2O8KPYf/AgQ9BJoCU0L5+ML7wSlhooUOFG3wHsBcA0Z18s6iHlf/r3hynypHYx/UeDg42k1Zm1O71O1GWoCRwl16ouMLFRzDLHwx5Z4/92JyBREJfOX10pj9i1KNahfuRlZaD8Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ff2ko/ia; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ff2ko/ia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8811C4CEF5;
	Tue,  9 Dec 2025 19:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765308812;
	bh=p14VkVY8keWbrmqG6kmvPImIvDa3YSU9GVNM5gc3KU8=;
	h=Date:To:From:Subject:From;
	b=ff2ko/iamOjCEt6SFt8TIJ/10vCDLGG5gR0s/hWKM6gVjEf3iZ62rp3iDuWISL/KA
	 SBqY4bCNh1hCQtTBzAWq7injVgWDGkM1/4Fd+QdaUjnkvuNnfkGOuNWklZ10bGlR4X
	 kKX5e5sst68QN8363q2DJUjOMxT81FmSaFG2SEM4=
Date: Tue, 09 Dec 2025 11:33:32 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-fix-memory-leak-in-ocfs2_merge_rec_left.patch removed from -mm tree
Message-Id: <20251209193332.A8811C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix memory leak in ocfs2_merge_rec_left()
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-memory-leak-in-ocfs2_merge_rec_left.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dmitry Antipov <dmantipov@yandex.ru>
Subject: ocfs2: fix memory leak in ocfs2_merge_rec_left()
Date: Fri, 5 Dec 2025 09:51:59 +0300

In 'ocfs2_merge_rec_left()', do not reset 'left_path' to NULL after
move, thus allowing 'ocfs2_free_path()' to free it before return.

Link: https://lkml.kernel.org/r/20251205065159.392749-1-dmantipov@yandex.ru
Fixes: 677b975282e4 ("ocfs2: Add support for cross extent block")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reported-by: syzbot+cfc7cab3bb6eaa7c4de2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=cfc7cab3bb6eaa7c4de2
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/ocfs2/alloc.c~ocfs2-fix-memory-leak-in-ocfs2_merge_rec_left
+++ a/fs/ocfs2/alloc.c
@@ -3655,7 +3655,6 @@ static int ocfs2_merge_rec_left(struct o
 			 * So we use the new rightmost path.
 			 */
 			ocfs2_mv_path(right_path, left_path);
-			left_path = NULL;
 		} else
 			ocfs2_complete_edge_insert(handle, left_path,
 						   right_path, subtree_index);
_

Patches currently in -mm which might be from dmantipov@yandex.ru are


