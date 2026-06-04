Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAAF53BBFA9;
	Thu,  4 Jun 2026 21:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780609811; cv=none; b=I6xtJhbMsEqMY5xsrIOMrCbf6rMHILxiG1n2FDME6kwM6o8Foyrx9RP+gBS+/RHLJlK0sKwKGRv8r9cwYPheenESM3WS7NxIzlJy8jXsPlvxfReSECyIzZwNVUBdiKmOriQtTfDt9oR/9YljNvols3MxrKZ6pMIbjLELOxEdrQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780609811; c=relaxed/simple;
	bh=XoxNY/Ro5SjMStKHXlv7LA9Nzr+Vp8/LfQomRy3lXZg=;
	h=Date:To:From:Subject:Message-Id; b=Fm4OlF6ViY1RPOBHSbCiZVuZyn+Zkrkj7Kc5RJZKbQTI1q0PFfgs+oCcRmeFPFG2cuaFX7v1T5LYh62wqyjs83KgQS90pBYszue8X5OvZSsgwEYHb0lLbgmmAPcOm0ED7qt9Q6Oi596qFCwwlx8G8AbNUr3bUUUEV0THYwRIx5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hKhf1fdo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hKhf1fdo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C781F00893;
	Thu,  4 Jun 2026 21:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780609810;
	bh=zvelieDtYFAo9iruZRI+4leW/PznqPdIgfuOxFmKu0I=;
	h=Date:To:From:Subject;
	b=hKhf1fdo2GHvtrPrbIzxXsawn6OU4k3DY2lznJpnpzlTLog1JZlZVbxqmi85Mpjru
	 EjtvR5m5Qgm5rddLwtBYJ51gb8UxdOaZzjruo0kZNbBxJsCMy0LnXQEtfAaMfzPr6+
	 UmoxHWE6pVogAGN5+eKXVPqhh/fVy86PopoJaeZE=
Date: Thu, 04 Jun 2026 14:50:10 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,farhad.alemi@berkeley.edu,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-add-journal-null-check-in-ocfs2_checkpoint_inode.patch removed from -mm tree
Message-Id: <20260604215010.67C781F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: add journal NULL check in ocfs2_checkpoint_inode()
has been removed from the -mm tree.  Its filename was
     ocfs2-add-journal-null-check-in-ocfs2_checkpoint_inode.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: add journal NULL check in ocfs2_checkpoint_inode()
Date: Sun, 31 May 2026 21:16:45 +0800

During unmount, ocfs2_journal_shutdown() frees the journal and sets
osb->journal to NULL. Later, when VFS evicts remaining cached inodes,
ocfs2_evict_inode() -> ocfs2_clear_inode() -> ocfs2_checkpoint_inode()
-> ocfs2_ci_fully_checkpointed() dereferences osb->journal, causing a
NULL pointer dereference.

Fix this by adding a NULL check for osb->journal in
ocfs2_checkpoint_inode(). If the journal is NULL, it has already been
fully flushed and destroyed during shutdown, so there is nothing to
checkpoint.

Link: https://lore.kernel.org/20260531131645.3650299-1-joseph.qi@linux.alibaba.com
Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Fixes: da5e7c87827e ("ocfs2: cleanup journal init and shutdown")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Tested-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/journal.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/ocfs2/journal.h~ocfs2-add-journal-null-check-in-ocfs2_checkpoint_inode
+++ a/fs/ocfs2/journal.h
@@ -196,6 +196,9 @@ static inline void ocfs2_checkpoint_inod
 	if (ocfs2_mount_local(osb))
 		return;
 
+	if (!osb->journal)
+		return;
+
 	if (!ocfs2_ci_fully_checkpointed(INODE_CACHE(inode))) {
 		/* WARNING: This only kicks off a single
 		 * checkpoint. If someone races you and adds more
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are


