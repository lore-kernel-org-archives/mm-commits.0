Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E9718C924;
	Mon,  9 Sep 2024 22:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725920192; cv=none; b=hpyUuJxa00I3WqjpcAfxjyjBZB4wG+v2qdr3xQvJgifx0tLNDLLkgUkXipeIhfSQvGzE12e17/fsw5FU8rIl8RaFcxkpK4fRCJ1z6Dv97mFjG7cl3zCo1jr2JfgJNJM+SvSGnGFCDeM8oXrlJ98y81eb5Ww7cpF+v+5aM1Ll+Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725920192; c=relaxed/simple;
	bh=1nAcFcFDwn2581E5qzBO3H2D/ZbGg9v4wzAqOUwP2us=;
	h=Date:To:From:Subject:Message-Id; b=b7jcxt4ESLjEUuU88L4sN4qzwZev72nGiny4vgUF0Mbv5Q6qndqG8LAr0snAv5JuSoP3Dn+7m+oXvOOYF6DAWEx29jIjqsLErzlbON/nCUJzhYGuXIEYawQLh/Eb7rLor/tfWC0dF6JECJyJFOeY9uWctE+EHZox+lKiVeoDDhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NUQ/DlFr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NUQ/DlFr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B37C4CECA;
	Mon,  9 Sep 2024 22:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725920191;
	bh=1nAcFcFDwn2581E5qzBO3H2D/ZbGg9v4wzAqOUwP2us=;
	h=Date:To:From:Subject:From;
	b=NUQ/DlFr+heKFxIAe2o+6byTAsYPvSbJ4PIswgRtyHcoePpw52R5H0IIJLGjvhhFc
	 0WC5eAsNAQnpCy+afLyCcnZRqbXRWzydy4NAL6gY8IQl8AK25oWRWAuN2A0HYW+WBE
	 N+i+R2GpzkDWuthtrYqbxDuNZF7B+ytrmiuxOhFc=
Date: Mon, 09 Sep 2024 15:16:30 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,ghe@suse.com,gechangwei@live.cn,lizhi.xu@windriver.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] ocfs2-remove-unreasonable-unlock-in-ocfs2_read_blocks.patch removed from -mm tree
Message-Id: <20240909221631.98B37C4CECA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: remove unreasonable unlock in ocfs2_read_blocks
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-unreasonable-unlock-in-ocfs2_read_blocks.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lizhi Xu <lizhi.xu@windriver.com>
Subject: ocfs2: remove unreasonable unlock in ocfs2_read_blocks
Date: Mon, 2 Sep 2024 10:36:35 +0800

Patch series "Misc fixes for ocfs2_read_blocks", v5.

This series contains 2 fixes for ocfs2_read_blocks().  The first patch fix
the issue reported by syzbot, which detects bad unlock balance in
ocfs2_read_blocks().  The second patch fixes an issue reported by Heming
Zhao when reviewing above fix.


This patch (of 2):

There was a lock release before exiting, so remove the unreasonable unlock.

Link: https://lkml.kernel.org/r/20240902023636.1843422-1-joseph.qi@linux.alibaba.com
Link: https://lkml.kernel.org/r/20240902023636.1843422-2-joseph.qi@linux.alibaba.com
Fixes: cf76c78595ca ("ocfs2: don't put and assigning null to bh allocated outside")
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reported-by: syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ab134185af9ef88dfed5
Tested-by: syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>	[4.20+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/buffer_head_io.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/ocfs2/buffer_head_io.c~ocfs2-remove-unreasonable-unlock-in-ocfs2_read_blocks
+++ a/fs/ocfs2/buffer_head_io.c
@@ -235,7 +235,6 @@ int ocfs2_read_blocks(struct ocfs2_cachi
 		if (bhs[i] == NULL) {
 			bhs[i] = sb_getblk(sb, block++);
 			if (bhs[i] == NULL) {
-				ocfs2_metadata_cache_io_unlock(ci);
 				status = -ENOMEM;
 				mlog_errno(status);
 				/* Don't forget to put previous bh! */
_

Patches currently in -mm which might be from lizhi.xu@windriver.com are


