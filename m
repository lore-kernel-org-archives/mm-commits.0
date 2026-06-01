Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03AC30ACE3
	for <mm-commits@vger.kernel.org>; Mon,  1 Jun 2026 22:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780354531; cv=none; b=fvVDYTaPzIc47lBe05E3LRJc8Ueyrg8mlqIw5rwaFvxnUkpzVFBPJ+SKPLgO5nIExmQ79gqnuhzrTKYfj24rCw8I3klIEk+vq660Jj1hKspwcBCy2KsHKa6N9wUjZc8PACi6Xm6/9aWuuhA3Cn3XXvmwAeK8wI6RVRj6jANhln4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780354531; c=relaxed/simple;
	bh=SGZ5Y/1Rn+I9/riVEM6LaBfVa76SMXWf7RN4Kah6imw=;
	h=Date:To:From:Subject:Message-Id; b=jdN7FxCIkrncIUq21GfjPlwJ9SZQcrHOgNdWkDaLuxMq2ClBDuAH5ymGRWC8Ne2Iqoe6d9FDlXTMTb9ioscmRLWFU+443iU8Y9fD5rwQxedoBp0DaZMOHRgV+Qb5W0v0Qw9szSXXdlf9sPeVKZXGAzy26SU3Yh4tiqk9pK78vnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GuJQl4Y0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GuJQl4Y0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F6E11F00893;
	Mon,  1 Jun 2026 22:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780354529;
	bh=saIP70nkzlSsrTUkojm+abFQCbtZrzKrKa5uEl862NY=;
	h=Date:To:From:Subject;
	b=GuJQl4Y0k9cKF7jHHlk0xrTVyfsRxthB0a7WYzYzMz4HxwrXiZ5sshLQvcIfYRRWV
	 P9CrgpKpRjH5yxqjA5g38KgYUZtyfxw54F1IQnMnpOKQzQN2Dx70oeuRDWxBH5zJKd
	 VB772mLliIyiCew3WZn9xP/tcBtYhU5aGyFOdHGY=
Date: Mon, 01 Jun 2026 15:55:29 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,ginger@gmail.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-race-between-ocfs2_control_install_private-and-ocfs2_control_release.patch added to mm-nonmm-unstable branch
Message-Id: <20260601225529.7F6E11F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix race between ocfs2_control_install_private() and ocfs2_control_release()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-fix-race-between-ocfs2_control_install_private-and-ocfs2_control_release.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-race-between-ocfs2_control_install_private-and-ocfs2_control_release.patch

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
Subject: ocfs2: fix race between ocfs2_control_install_private() and ocfs2_control_release()
Date: Mon, 1 Jun 2026 20:16:18 +0800

Move atomic_inc(&ocfs2_control_opened) and the handshake state update
inside ocfs2_control_lock to close a race window where
ocfs2_control_release() can observe ocfs2_control_opened dropping to zero
(resetting ocfs2_control_this_node and running_proto) while
ocfs2_control_install_private() is about to bump the counter and mark the
connection valid.

Link: https://lore.kernel.org/20260601121618.1263346-1-joseph.qi@linux.alibaba.com
Fixes: 3cfd4ab6b6b4 ("ocfs2: Add the local node id to the handshake.")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reported-by: Ginger <ginger@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/stack_user.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/fs/ocfs2/stack_user.c~ocfs2-fix-race-between-ocfs2_control_install_private-and-ocfs2_control_release
+++ a/fs/ocfs2/stack_user.c
@@ -327,18 +327,14 @@ static int ocfs2_control_install_private
 		ocfs2_control_this_node = p->op_this_node;
 		running_proto.pv_major = p->op_proto.pv_major;
 		running_proto.pv_minor = p->op_proto.pv_minor;
-	}
-
-out_unlock:
-	mutex_unlock(&ocfs2_control_lock);
-
-	if (!rc && set_p) {
-		/* We set the global values successfully */
 		atomic_inc(&ocfs2_control_opened);
 		ocfs2_control_set_handshake_state(file,
 					OCFS2_CONTROL_HANDSHAKE_VALID);
 	}
 
+out_unlock:
+	mutex_unlock(&ocfs2_control_lock);
+
 	return rc;
 }
 
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-add-journal-null-check-in-ocfs2_checkpoint_inode.patch
ocfs2-fix-race-between-ocfs2_control_install_private-and-ocfs2_control_release.patch

