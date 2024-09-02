Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D04918734F;
	Mon,  2 Sep 2024 22:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725315700; cv=none; b=rFLVCJ5hXCjrOm9JW+GG1IAGNSrLojKMr8ISSVb5AG55GRsdSn0jgwp9XAkQFjIMtWg5SgF5r4YEBLcAgSFw2Fwkc+CWeTDNt/ONLuriToa+8ggWq28kHD/a/ygKFSJnQg5Q4mKJgXflW6xRdq6WyGC7bnwj/TNqQHJk5eQSZFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725315700; c=relaxed/simple;
	bh=dK31dFTbWlffb7HRNqG2pSPG8fd8DE1U1nkljqorpTQ=;
	h=Date:To:From:Subject:Message-Id; b=FxXneG6sWNUu0JjtRNjd1HOOw3mNRk+PSNprCz5DGeIP6uTtwzS+qBdrOOFZNnarx4WCZIPyYmy3rxYGNShny5x2gIuec5TwxdLMOk0cR6l6emDLgz6t97kM4iz//RCGPNJOtb4kb6m6yaqg56KphuCEsuK5PE9RuVY0/c6MD98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y7IufcCF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y7IufcCF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73419C4CEC2;
	Mon,  2 Sep 2024 22:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725315698;
	bh=dK31dFTbWlffb7HRNqG2pSPG8fd8DE1U1nkljqorpTQ=;
	h=Date:To:From:Subject:From;
	b=Y7IufcCFHvZnWkbEA3yv0Kjyto8Axi5MDzKS0MZE5IDtkwDyI4rkbznAL1bvQY+5T
	 iiq4bCFAqlJastmae0pSMSNJXGmlv8Zmz+y3dYTTLm8cy1gmjgVpehF8DAJQlakgXd
	 fVXxkTz2SecJ/w69zNBdEwLfW3rip8KHiBHvtNbU=
Date: Mon, 02 Sep 2024 15:21:37 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,sunjunchao2870@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-null-ptr-deref-when-journal-load-failed.patch added to mm-hotfixes-unstable branch
Message-Id: <20240902222138.73419C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix null-ptr-deref when journal load failed.
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ocfs2-fix-null-ptr-deref-when-journal-load-failed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-null-ptr-deref-when-journal-load-failed.patch

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
From: Julian Sun <sunjunchao2870@gmail.com>
Subject: ocfs2: fix null-ptr-deref when journal load failed.
Date: Mon, 2 Sep 2024 11:08:44 +0800

During the mounting process, if journal_reset() fails because of too short
journal, then lead to jbd2_journal_load() fails with NULL j_sb_buffer. 
Subsequently, ocfs2_journal_shutdown() calls
jbd2_journal_flush()->jbd2_cleanup_journal_tail()->
__jbd2_update_log_tail()->jbd2_journal_update_sb_log_tail()
->lock_buffer(journal->j_sb_buffer), resulting in a null-pointer
dereference error.

To resolve this issue, we should check the JBD2_LOADED flag to ensure the
journal was properly loaded.  Additionally, use journal instead of
osb->journal directly to simplify the code.

Link: https://syzkaller.appspot.com/bug?extid=05b9b39d8bdfe1a0861f
Link: https://lkml.kernel.org/r/20240902030844.422725-1-sunjunchao2870@gmail.com
Fixes: f6f50e28f0cb ("jbd2: Fail to load a journal if it is too short")
Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
Reported-by: syzbot+05b9b39d8bdfe1a0861f@syzkaller.appspotmail.com
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/journal.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/ocfs2/journal.c~ocfs2-fix-null-ptr-deref-when-journal-load-failed
+++ a/fs/ocfs2/journal.c
@@ -1055,7 +1055,7 @@ void ocfs2_journal_shutdown(struct ocfs2
 	if (!igrab(inode))
 		BUG();
 
-	num_running_trans = atomic_read(&(osb->journal->j_num_trans));
+	num_running_trans = atomic_read(&(journal->j_num_trans));
 	trace_ocfs2_journal_shutdown(num_running_trans);
 
 	/* Do a commit_cache here. It will flush our journal, *and*
@@ -1074,9 +1074,10 @@ void ocfs2_journal_shutdown(struct ocfs2
 		osb->commit_task = NULL;
 	}
 
-	BUG_ON(atomic_read(&(osb->journal->j_num_trans)) != 0);
+	BUG_ON(atomic_read(&(journal->j_num_trans)) != 0);
 
-	if (ocfs2_mount_local(osb)) {
+	if (ocfs2_mount_local(osb) &&
+	    (journal->j_journal->j_flags & JBD2_LOADED)) {
 		jbd2_journal_lock_updates(journal->j_journal);
 		status = jbd2_journal_flush(journal->j_journal, 0);
 		jbd2_journal_unlock_updates(journal->j_journal);
_

Patches currently in -mm which might be from sunjunchao2870@gmail.com are

ocfs2-fix-null-ptr-deref-when-journal-load-failed.patch

