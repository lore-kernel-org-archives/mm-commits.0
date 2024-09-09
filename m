Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D53618030;
	Mon,  9 Sep 2024 22:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725920191; cv=none; b=Veazk58INr4uN3+aSOgWzFCTAQ7NYzdVNYJFNaWukrEru97L/L5zAUG6qXMP34z/9/P+ttlWt0ymLIcyLATaSX+oA6UWTq6soD5P9Ppm5wLRgI5DYSCxcCJkEJypn0NBT7eQ5NongRVEnyvR1g7+TYW9XhECyPA9OvROJOAjR3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725920191; c=relaxed/simple;
	bh=TNgXvKTSFLYhbh3sfKErbPnLIfRyOBy0dpVtIyjty6U=;
	h=Date:To:From:Subject:Message-Id; b=mK7fjJskDfIjqZ68Zp6ffUWN0oAAnd5Oa5uNwiN4rC1NYsruVrX7ofj9/LwqLm8PVOQvotWLo3daWfLspVH/vN8ZfSjYNfCf/lXijbGxBdzJ6ELMNsaM8E8fjXZlRcKLRna7uH8mZf6IEKk+StruAwEp8PYYLK3tcOmLvoEnuCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FURx6TYc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FURx6TYc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC31C4CECB;
	Mon,  9 Sep 2024 22:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725920190;
	bh=TNgXvKTSFLYhbh3sfKErbPnLIfRyOBy0dpVtIyjty6U=;
	h=Date:To:From:Subject:From;
	b=FURx6TYcuzb/pG5LMcenJLiM0PVHc5gWBNt/SbswIr6EAv+KSBf2RW3dmgwpuwZCx
	 IZv5EQsAUZzOxok1NI4slb6G3NoTY9AYJM37OPMXbo8jj/PbhYwujpcO7Dy/GC1cT3
	 ps2ZVk9b6g9qaX8tFAtDASo1QNUhuTkN+17GEBBQ=
Date: Mon, 09 Sep 2024 15:16:29 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,sunjunchao2870@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] ocfs2-fix-null-ptr-deref-when-journal-load-failed.patch removed from -mm tree
Message-Id: <20240909221630.2EC31C4CECB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix null-ptr-deref when journal load failed.
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-null-ptr-deref-when-journal-load-failed.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


