Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0FC1CD15
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 20:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764274539; cv=none; b=L9mBvC692Cu6SQvCowlS8fU5THK8rkDZa5n4Q5fduCcF8nTSHP++akDKxZQ6FDw6RElGY5sKAuS/cZToUnnmLxy/EidPlqUXlgUafAsS4h3DNIj5wLlTDgBZAUurdKFnpo5An4ZyDnQCWFR7e4SsbAHb6AY+GIgrZdgS00A+DBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764274539; c=relaxed/simple;
	bh=C1cuwwIp0ijuSCxL1PMmsUk0wQ78uC1iH0BgIW5hcVk=;
	h=Date:To:From:Subject:Message-Id; b=cXf/GH74v1zyb+qQhtVPDXCDRLRUBoMhDtoTYTURXicCMrLBmwHrhfmzJ1BT9nQZcOnCj9vrbvse4qlR08S+IQN9R3+F5gs7HtoqNBRjO+ZTtDeSmcBtgskiFDw+wtfgmT+HCSFa7J6aR2uCRqp3I7x3zSniUzttGGLDJ0uQqJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a4UGqanj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a4UGqanj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89EFFC4CEF8;
	Thu, 27 Nov 2025 20:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764274539;
	bh=C1cuwwIp0ijuSCxL1PMmsUk0wQ78uC1iH0BgIW5hcVk=;
	h=Date:To:From:Subject:From;
	b=a4UGqanjyxbIvD7TIlryST1pjW4TUZe1ScN2DrnC8Mlq55FBZi2v9aD0+nF46SeKT
	 7a5Y/ss46C4gHScjyeJqESzHMe2BkTcYdQu2lmF57O6ONQiZBSyLPTUIoAaeAWRNTD
	 Jzh7sQxsTVe21oAThXig14gs81Rd3XHdTPKqGLJE=
Date: Thu, 27 Nov 2025 12:15:39 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,eadavis@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-check-tl_used-after-reading-it-from-trancate-log-inode.patch added to mm-nonmm-unstable branch
Message-Id: <20251127201539.89EFFC4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: check tl_used after reading it from trancate log inode
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-check-tl_used-after-reading-it-from-trancate-log-inode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-check-tl_used-after-reading-it-from-trancate-log-inode.patch

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
From: Edward Adam Davis <eadavis@qq.com>
Subject: ocfs2: check tl_used after reading it from trancate log inode
Date: Thu, 27 Nov 2025 11:26:40 +0800

The fuzz image has a truncate log inode whose tl_used is bigger than
tl_count so it triggers the BUG in ocfs2_truncate_log_needs_flush() [1].

As what the check in ocfs2_truncate_log_needs_flush() does, just do same
check into ocfs2_get_truncate_log_info() when truncate log inode is
reading in so we can bail out earlier.

[1]
(syz.0.17,5491,0):ocfs2_truncate_log_needs_flush:5830 ERROR: bug expression: le16_to_cpu(tl->tl_used) > le16_to_cpu(tl->tl_count)
kernel BUG at fs/ocfs2/alloc.c:5830!
RIP: 0010:ocfs2_truncate_log_needs_flush fs/ocfs2/alloc.c:5827 [inline]
Call Trace:
 ocfs2_commit_truncate+0xb64/0x21d0 fs/ocfs2/alloc.c:7372
 ocfs2_truncate_file+0xca2/0x1420 fs/ocfs2/file.c:509
 ocfs2_setattr+0x1520/0x1b40 fs/ocfs2/file.c:1212
 notify_change+0xc1a/0xf40 fs/attr.c:546
 do_truncate+0x1a4/0x220 fs/open.c:68

Link: https://lkml.kernel.org/r/tencent_B24B1C1BE225DCBA44BB6933AB9E1B1B0708@qq.com
Reported-by: syzbot+f82afc4d4e74d0ef7a89@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f82afc4d4e74d0ef7a89
Tested-by: syzbot+f82afc4d4e74d0ef7a89@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/alloc.c~ocfs2-check-tl_used-after-reading-it-from-trancate-log-inode
+++ a/fs/ocfs2/alloc.c
@@ -6164,7 +6164,7 @@ static int ocfs2_get_truncate_log_info(s
 	struct buffer_head *bh = NULL;
 	struct ocfs2_dinode *di;
 	struct ocfs2_truncate_log *tl;
-	unsigned int tl_count;
+	unsigned int tl_count, tl_used;
 
 	inode = ocfs2_get_system_file_inode(osb,
 					   TRUNCATE_LOG_SYSTEM_INODE,
@@ -6185,8 +6185,10 @@ static int ocfs2_get_truncate_log_info(s
 	di = (struct ocfs2_dinode *)bh->b_data;
 	tl = &di->id2.i_dealloc;
 	tl_count = le16_to_cpu(tl->tl_count);
+	tl_used = le16_to_cpu(tl->tl_used);
 	if (unlikely(tl_count > ocfs2_truncate_recs_per_inode(osb->sb) ||
-		     tl_count == 0)) {
+		     tl_count == 0 ||
+		     tl_used > tl_count)) {
 		status = -EFSCORRUPTED;
 		iput(inode);
 		brelse(bh);
_

Patches currently in -mm which might be from eadavis@qq.com are

ocfs2-check-tl_used-after-reading-it-from-trancate-log-inode.patch

