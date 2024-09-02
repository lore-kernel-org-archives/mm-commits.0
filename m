Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630D1187877;
	Mon,  2 Sep 2024 22:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725316158; cv=none; b=tjiLvfgOB/hlUuqSx3Q9m1MXnYXXQG8PfD7V143d1W43QzZuk1NMnjsPsM4oOXGhjIGjchDDPfcrXtJNh9s/365nxsUhEB6JU1lJQmlmZkJAqKQ4fPEPzt7KHG7Fxr/aeh3veM8nqTA08Wo+UCgGDDOdBf2ZvORjT85foQ6VIGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725316158; c=relaxed/simple;
	bh=riqUGujwKdnCXKz96jg3soQh+Z2wQN1hYYjTJ3cRyk0=;
	h=Date:To:From:Subject:Message-Id; b=g/n6MwHzIVdMSb1AorJ2sOlCOAeoWQOyXPOLkV2rq9uT4RC51zgli1d4mM1VGUt5XjmT+mcTLaRnd0nUkVtI8e5OslqvJB2rtKkvDu/T2pCxkb7Vfb8OWgUAWdkeoxgCZzaWDaDocK2gFCryD6GSQZQs6KqqW0TsPvc0h+4lB4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qJI+2+qa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qJI+2+qa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A00C4CEC2;
	Mon,  2 Sep 2024 22:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725316157;
	bh=riqUGujwKdnCXKz96jg3soQh+Z2wQN1hYYjTJ3cRyk0=;
	h=Date:To:From:Subject:From;
	b=qJI+2+qa7Nbsq/Htv1IZxZowvnx/H3bjFnhdYnok8YA6U7rARIV6ClOtxIdM/HAsS
	 Tmvofcy70vm+UytzzlqlVcQx/pH2Lsg4CCddM40M3HdjtyJ0SF/TQO+rnxcE8A04s/
	 My1eKKoMIk714zfpdRFftjjMRTJz/bKHzqX/hjt8=
Date: Mon, 02 Sep 2024 15:29:17 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,ghe@suse.com,gechangwei@live.cn,lizhi.xu@windriver.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-remove-unreasonable-unlock-in-ocfs2_read_blocks.patch added to mm-hotfixes-unstable branch
Message-Id: <20240902222917.D5A00C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: remove unreasonable unlock in ocfs2_read_blocks
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ocfs2-remove-unreasonable-unlock-in-ocfs2_read_blocks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-remove-unreasonable-unlock-in-ocfs2_read_blocks.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

ocfs2-remove-unreasonable-unlock-in-ocfs2_read_blocks.patch
ocfs2-fix-possible-null-ptr-deref-in-ocfs2_set_buffer_uptodate.patch

