Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147FD1E5201;
	Sun, 31 May 2026 19:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780255683; cv=none; b=ZF2JAEPG/uiVmCJiuRRx5Oi+sdwZiYHVLnGLdT8xerXnp9oTTIMQ0FVxSiVacU5pRy1jmKYOcMnO2WR6NZheK3NMN83RNujwJb6HCWaQi6ExgncJJERZvl+OBiKCT82+OnE2qNyPJMCk4v93dqDjTKvzU6ZUkFsc/wEoqOYK5DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780255683; c=relaxed/simple;
	bh=CTnkmAQnkA5SfpvH8+lu4xi8MRjux2507e8Tk3nsyyg=;
	h=Date:To:From:Subject:Message-Id; b=OMCyu1wsvWm30BZNFhXcZ/pGWhiu3qNweVGP3SwPWQ04sIpO4nCX+sSY47E0geRCxgDYaFyF0azxKI50QZO1Fmqd6jT4Wm+G/N/zyWb/vpk/tsuB3RdHb+HshtgXGcuuJu5QMsDKMh2uxDVGvxVFeC8ka7fhcfOUQ2MB+uYx3dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DEeRh9zG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DEeRh9zG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9AD1F00893;
	Sun, 31 May 2026 19:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780255681;
	bh=heSCjggVhJx5Aki8OPuK2xH50XETOW+MNUOoWifCJe0=;
	h=Date:To:From:Subject;
	b=DEeRh9zGMXV7MSdu2zLgVMoiWglXrdW2wYywmyhW73k4VbzGNiJdzM6ua6Zjgh/sv
	 QNyGxaH3j+q9HjTuDxIntM3JAZWF+YNx00MsenSb30dBaHSRUFcGaandSzHo4htmq2
	 heax4Pv8u65LnhodntHC2zvGxFjqFVtNRpSEWetU=
Date: Sun, 31 May 2026 12:28:01 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,farhad.alemi@berkeley.edu,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-add-journal-null-check-in-ocfs2_checkpoint_inode.patch added to mm-nonmm-unstable branch
Message-Id: <20260531192801.AE9AD1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: add journal NULL check in ocfs2_checkpoint_inode()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-add-journal-null-check-in-ocfs2_checkpoint_inode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-add-journal-null-check-in-ocfs2_checkpoint_inode.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
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

ocfs2-add-journal-null-check-in-ocfs2_checkpoint_inode.patch

