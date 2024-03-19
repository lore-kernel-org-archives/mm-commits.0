Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB76C3BBF4
	for <mm-commits@vger.kernel.org>; Tue, 19 Mar 2024 21:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710882056; cv=none; b=E/elS3Qx2imK7vW0q61IpU47y09sTJbxkVeQWDiwjVOP8UvJwITSc8Nh6r3GxV2P7wlz3oyhwRDFEhLrY2Fg6fRaTy3w7oWywDhm6FPKemM+2ZAhlamPOo2iZ2qq7ZUuFKNWpKBLhh28eaG2MHfbbL8zIUd8/WHu3lqUfpxiU7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710882056; c=relaxed/simple;
	bh=Xgu7D9Ib7+9xnUZ6GfsFmC+nCiUpJycO6maa5o9Ryj8=;
	h=Date:To:From:Subject:Message-Id; b=OSvvrYYDGI0BbZ7GNllmo5u/XprNAJ/gE0D/z/r3vZqoRvokFDVwWbPKShCTCzCsCEbemckL164jpY1GXq047ZHcNy6Xsd7FcDkwleF47NkfMJPM1UOllkYiEsoy8GQP41TOLUpNfxrsIanl0iJEcI2tHgLX2TuE6jeLkGmesSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A8th68+D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A8th68+D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43F94C433F1;
	Tue, 19 Mar 2024 21:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710882056;
	bh=Xgu7D9Ib7+9xnUZ6GfsFmC+nCiUpJycO6maa5o9Ryj8=;
	h=Date:To:From:Subject:From;
	b=A8th68+D3ahn4BulNh+s9xwkmpVDKfWZ4ORzqXAPf+IIx4ylBWEB2DtILkz3Hno1i
	 mKsmnznZOy6PfReK3HcZbSMOiRSwY/9sK9WTTkktPVdjDSghqNLr+ngmatIXoxaEmk
	 hkmoClvxO24xQ79coTVZnZ0gU8FhB/C9ZBa/JzZY=
Date: Tue, 19 Mar 2024 14:00:55 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,glass.su@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-update-inode-ctime-in-ocfs2_fileattr_set.patch added to mm-nonmm-unstable branch
Message-Id: <20240319210056.43F94C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: update inode ctime in ocfs2_fileattr_set
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-update-inode-ctime-in-ocfs2_fileattr_set.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-update-inode-ctime-in-ocfs2_fileattr_set.patch

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
From: Su Yue <glass.su@suse.com>
Subject: ocfs2: update inode ctime in ocfs2_fileattr_set
Date: Mon, 18 Mar 2024 19:56:09 +0800

inode ctime should be updated if ocfs2_fileattr_set is called.

Link: https://lkml.kernel.org/r/20240318115609.3194-1-l@damenly.org
Signed-off-by: Su Yue <glass.su@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/ioctl.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ocfs2/ioctl.c~ocfs2-update-inode-ctime-in-ocfs2_fileattr_set
+++ a/fs/ocfs2/ioctl.c
@@ -125,6 +125,7 @@ int ocfs2_fileattr_set(struct mnt_idmap
 
 	ocfs2_inode->ip_attr = flags;
 	ocfs2_set_inode_flags(inode);
+	inode_set_ctime_current(inode);
 
 	status = ocfs2_mark_inode_dirty(handle, inode, bh);
 	if (status < 0)
_

Patches currently in -mm which might be from glass.su@suse.com are

ocfs2-update-inode-ctime-in-ocfs2_fileattr_set.patch

