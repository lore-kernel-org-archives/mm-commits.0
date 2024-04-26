Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE527811F7
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104453; cv=none; b=FSpPP708gKBaYPDs4hRR4uAgFWveX67RQXzZh81Bg5W5Q6XF1qmDBQ4Z6bZhvIY1cbdXPNDj56GF4YjEoqXtd9zEFWEudwjiHpHJpz122/syQSAG8YGPdW0aUjaqVB7PHzdz8ZlOOy+Toh9ZGn149wo882zdVe01I+zq02k3UcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104453; c=relaxed/simple;
	bh=vvF6CLKh3SSHb271mF9BHWHadv/Zy+J6t27G1ZjLwL8=;
	h=Date:To:From:Subject:Message-Id; b=Ig5M7s6YJ2/nPHV5eniLjZrKWO7jUQQY30PSmsmIuqSyRibmilr9lmpchBeO96K40cVoNdp9vIFXqmodIB6SbD+vVCXzvmy3Se4lbc1bLIwVvXDHlWCh6nUrVe+dfOa5Cff6tdLvHFsf2b75+1yvFfkUiNLw9A72VFUwfiAD+eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RMZAVbJk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RMZAVbJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3302CC116B1;
	Fri, 26 Apr 2024 04:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104453;
	bh=vvF6CLKh3SSHb271mF9BHWHadv/Zy+J6t27G1ZjLwL8=;
	h=Date:To:From:Subject:From;
	b=RMZAVbJkcp+F8qBT/aDU+WcDi3c63iKEOlt8mK/dlIYr6ficexFDCO5otshwBY0Ur
	 /ch47k7VYHNAAHGzaqmu1/xCSjn8k8DqkcyNI80c0gEWsRWu9NqjzGg1Kts9OZZrgh
	 Ly0reSb4iiWI2Jvre4Vka36iGQ1Uv2v2rZqlwLIw=
Date: Thu, 25 Apr 2024 21:07:32 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,glass.su@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-update-inode-ctime-in-ocfs2_fileattr_set.patch removed from -mm tree
Message-Id: <20240426040733.3302CC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: update inode ctime in ocfs2_fileattr_set
has been removed from the -mm tree.  Its filename was
     ocfs2-update-inode-ctime-in-ocfs2_fileattr_set.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


