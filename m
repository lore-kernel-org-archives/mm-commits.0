Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AD11C84D7
	for <mm-commits@vger.kernel.org>; Sat,  6 Dec 2025 21:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765057584; cv=none; b=TZe2Fwe4s//3R0LRf6TSiMKPvrk5PDbETd710hBMCNrWZUmPmd9vxYh3XamgFFfSySaSjxekqb8OKjipM3PzwrM3MgJeyX3Oer6BXAB04HezjfYkQL7IwQWmZ1KqABMQBsyP6FrmUgIfT85La/2s3iz++DGMxNdWVok6g5SChfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765057584; c=relaxed/simple;
	bh=+oGzzZLHbM+1ovvXKN8ul+1vTAFPDqvNb6DZdH0+HNc=;
	h=Date:To:From:Subject:Message-Id; b=nu657WXF4Po7x4ysKgmmG8PR+BAuAVhnfvCnkZmWXq2MKMuHsdjb0GKiqaq1wZI9J2okXgSeFdAoaiBn28IEj/re5drb9tw2tJ4eOJ9VK5Oqc57i5O9UrO3JdXEYbnX0faQQg8YNqFuLXxWBTjfFy5jyeHqdPYV30BvSDqyFXG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bCS8J2DT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bCS8J2DT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44AF6C4CEF5;
	Sat,  6 Dec 2025 21:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765057584;
	bh=+oGzzZLHbM+1ovvXKN8ul+1vTAFPDqvNb6DZdH0+HNc=;
	h=Date:To:From:Subject:From;
	b=bCS8J2DTChVW4aohMRG7jmjTzrMelIzi9nzRpljCHH4X8powBese89loFxYaj3MDB
	 58d7Z6C1vSS6q7DDCExTlV/3DE+NCzo0EGMYKR9VS6zp51X/HCOqEpCMduQCt7p7Z6
	 dMaPEsvGnr/X1dRh40HXl8xnPqOVA3/vqMQXCL8o=
Date: Sat, 06 Dec 2025 13:46:23 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,dmantipov@yandex.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-memory-leak-in-ocfs2_merge_rec_left.patch added to mm-nonmm-unstable branch
Message-Id: <20251206214624.44AF6C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix memory leak in ocfs2_merge_rec_left()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-fix-memory-leak-in-ocfs2_merge_rec_left.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-memory-leak-in-ocfs2_merge_rec_left.patch

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

ocfs2-fix-memory-leak-in-ocfs2_merge_rec_left.patch

