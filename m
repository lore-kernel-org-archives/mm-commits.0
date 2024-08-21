Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619B513A3E8
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 21:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724276424; cv=none; b=sJdvC0r2QirrSaE6FQcJaiSWKpoGA5X9NoQ+SrPNwp5lYd7YCXa9gZrcOx5FH0FmAcxW/AdPFtdS5FpehqIGadyCMkzw9h3dxuFPJtnKK9tEjVVazbcb3V5M5CSVABcslH49TFxlU35nA9fHvRzVTlq1YHuuPTRwm2ip5XlEBZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724276424; c=relaxed/simple;
	bh=YC54uMr/aY9r+RKKlfEElqzods5KZXEKBMjug6+F2LM=;
	h=Date:To:From:Subject:Message-Id; b=OyMs29FB+AC2u5F73ZanyvsiS/zDtHYVdW6/HgipkeOD1m4a/1Trp5WRDd1ysare8LPnng8zw8OIxwGIm5IlaisoOHG3lYQ29oB8GzilagIasNkWJPi6RsadeNynEAubw2Q+wktlOp1tRtlaqmhGmEA41ioNBmywASRCp/vL6Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cWLed5k6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cWLed5k6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC743C4AF0E;
	Wed, 21 Aug 2024 21:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724276424;
	bh=YC54uMr/aY9r+RKKlfEElqzods5KZXEKBMjug6+F2LM=;
	h=Date:To:From:Subject:From;
	b=cWLed5k6J3f00j2uwQLMS+SbL+sSa9olluU//LdDbATyXqzSxar0uui35E87UPTO5
	 pL7vnNIs6Nrqqh9yqKs42fmawRys4CaYKSeEonX7Sb5KPXmLFuVa1g8Q7+ocCRhPBq
	 y86OgqPx8T++s8aQRVaBX+is1rlQxQRr5DdDwNMA=
Date: Wed, 21 Aug 2024 14:40:23 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,ghe@suse.com,gechangwei@live.cn,lizhi.xu@windriver.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-remove-unreasonable-unlock.patch added to mm-hotfixes-unstable branch
Message-Id: <20240821214023.DC743C4AF0E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: remove unreasonable unlock
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ocfs2-remove-unreasonable-unlock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-remove-unreasonable-unlock.patch

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
Subject: ocfs2: remove unreasonable unlock
Date: Tue, 20 Aug 2024 17:45:11 +0800

There was a lock release before exiting, so remove the unreasonable
unlock.

Link: https://lkml.kernel.org/r/20240820094512.2228159-1-lizhi.xu@windriver.com
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
Reported-by: syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ab134185af9ef88dfed5
Tested-by: syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/buffer_head_io.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/ocfs2/buffer_head_io.c~ocfs2-remove-unreasonable-unlock
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

ocfs2-remove-unreasonable-unlock.patch
ocfs2-fix-possible-null-ptr-deref-in-ocfs2_set_buffer_uptodate.patch

