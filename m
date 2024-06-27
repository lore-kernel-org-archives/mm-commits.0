Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F88F249F9
	for <mm-commits@vger.kernel.org>; Thu, 27 Jun 2024 21:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719524616; cv=none; b=EbU+njA3UCL4AMCUcP/TV6Lo3gNOpTRjKx6SovxhQ6OfRFB/PmQ3jIUU4HOhhymgisN8WZOXYTbQqsAmVZsRhgORGtNcXTe9BcdsF9zExwtN/r2ZVmH6y7KhGKya1itrmOm/2vRFFcJCO+YBlhxoZgZrB5Ak96Ml20IRNi4RSRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719524616; c=relaxed/simple;
	bh=W5LGdlygXTboMv4qiFPogJWDUGmNhGXFvpxSrBwORLk=;
	h=Date:To:From:Subject:Message-Id; b=HTm8e+vtMQWletiGDVlmb+6J9igAfROCKxvWejIRQNdP2TgSrynLIntyFT0VnBYeS7FvobZkGooY2LBfsL/ZiKxcKumtJdHbm6PG16YEt5rs8zsJJJE7rMPOfVcyPk+Eybdn/WAVvcATm+56Tf+V1zIlYktbkP6Z+mp5Sad60/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iyM8mGa+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iyM8mGa+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9752FC2BBFC;
	Thu, 27 Jun 2024 21:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719524615;
	bh=W5LGdlygXTboMv4qiFPogJWDUGmNhGXFvpxSrBwORLk=;
	h=Date:To:From:Subject:From;
	b=iyM8mGa+3UCKzne96PfkTmX1U+hPKONbYzgzL1YIZhs3mLfkXRv5sM8/pk3YYFWC6
	 jNF9OOQUz15w/kWXMFHGEEAKoEnSNgVKkzzDZW+JdzQVN5f+sm8iWT2h4Y3+en2opd
	 zke0MTHIBCfQE51WSyOIqTr3TywYeINiQWxyql6w=
Date: Thu, 27 Jun 2024 14:43:34 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,yang.lee@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-add-kernel-doc-comments-to-ocfs2_prepare_orphan_dir.patch added to mm-nonmm-unstable branch
Message-Id: <20240627214335.9752FC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs: add kernel-doc comments to ocfs2_prepare_orphan_dir()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fs-add-kernel-doc-comments-to-ocfs2_prepare_orphan_dir.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-add-kernel-doc-comments-to-ocfs2_prepare_orphan_dir.patch

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
From: Yang Li <yang.lee@linux.alibaba.com>
Subject: fs: add kernel-doc comments to ocfs2_prepare_orphan_dir()
Date: Fri, 22 Mar 2024 14:37:18 +0800

This commit adds kernel-doc style comments with complete parameter
descriptions for the function ocfs2_prepare_orphan_dir.

Link: https://lkml.kernel.org/r/20240322063718.88183-1-yang.lee@linux.alibaba.com
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ocfs2/namei.c~fs-add-kernel-doc-comments-to-ocfs2_prepare_orphan_dir
+++ a/fs/ocfs2/namei.c
@@ -2189,8 +2189,10 @@ static int __ocfs2_prepare_orphan_dir(st
  * @osb: ocfs2 file system
  * @ret_orphan_dir: Orphan dir inode - returned locked!
  * @blkno: Actual block number of the inode to be inserted into orphan dir.
+ * @name: Buffer to store the name of the orphan.
  * @lookup: dir lookup result, to be passed back into functions like
  *          ocfs2_orphan_add
+ * @dio: Flag indicating if direct IO is being used or not.
  *
  * Returns zero on success and the ret_orphan_dir, name and lookup
  * fields will be populated.
_

Patches currently in -mm which might be from yang.lee@linux.alibaba.com are

fs-add-kernel-doc-comments-to-ocfs2_prepare_orphan_dir.patch

