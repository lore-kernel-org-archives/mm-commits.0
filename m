Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4332D2391
	for <mm-commits@vger.kernel.org>; Tue,  9 Dec 2025 19:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765308797; cv=none; b=bsAME1FBBJuMKqmtAUS9624P9isl4hrJQ/5fyPkAMWkWtctxtKk7KwKiBSmPRCkkniLkwx7WpA9CCXleoaCFBFgc7bsUXKGqyeMpTAJyFQ1OYRkDrDhXwiGZqV96sISpofof9vYcqI+/TxpFhzmIbQoFg4xLCt1WHpr1he7Vh1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765308797; c=relaxed/simple;
	bh=gR4SPOJZQkMThOCg9fsBG/WlTltQO1T7hcaB1F6BaEA=;
	h=Date:To:From:Subject:Message-Id; b=A2bArnsF7ml8fHteFF3qi2JDA6g7XufbdoiKNdPk955P2F0X1vTE4RoJlxtySsKT5seDOXDrhyLgtoWZpz3LHUICK9TGzomxC3pKjP2ahLbIYtp8uPbzivnWO/AlLs8rXuBWBJsCABwIRzQp8zc/0bRZvzJ2KNv7GwZCNpKLtyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=glXAro4S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="glXAro4S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED7D5C4CEF5;
	Tue,  9 Dec 2025 19:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765308797;
	bh=gR4SPOJZQkMThOCg9fsBG/WlTltQO1T7hcaB1F6BaEA=;
	h=Date:To:From:Subject:From;
	b=glXAro4S4QqsENKVhS4uVougaDVy6OCGE9mIxozsboyiOEmdlKHhNug+3sC6fyTz2
	 43K4jSDezvJVvhNIyV4/p1/OjKRjwR/s7/nZnNikJznvIrjValcd9ugdYHX8vmc/KH
	 F0234ExbjiCFN+ZQpQyOpOTpAaaCCV7jQP2jxLxQ=
Date: Tue, 09 Dec 2025 11:33:16 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,eadavis@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-check-tl_used-after-reading-it-from-trancate-log-inode.patch removed from -mm tree
Message-Id: <20251209193316.ED7D5C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: check tl_used after reading it from trancate log inode
has been removed from the -mm tree.  Its filename was
     ocfs2-check-tl_used-after-reading-it-from-trancate-log-inode.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


