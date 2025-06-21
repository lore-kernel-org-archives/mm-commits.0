Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B38149C4A;
	Sat, 21 Jun 2025 18:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750531739; cv=none; b=Fh9MhE2ZughoQ+x5uFkEoIQEOwP/pR+SWuz/M1Lm423a1zthrkmCYVhv2rAFDEW4M6lPLqA8vdH9bZTfIw1lCJutlFHROVmNt/dpyG+95ersyaLhAg6KLtBsuqf1ukx5d66C1XcpxlLdqZf30pVciSQziWSlpOnDWL78AJ5zUYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750531739; c=relaxed/simple;
	bh=pKvxx3mN11OuZ4qb6QXI0CIUfgBt6xFSKmmlZNvKa98=;
	h=Date:To:From:Subject:Message-Id; b=W7ZPXfF0J8HXHUIAcqxbvHELZP68QjxTbqQJSUvlIo+j0LuL50lPsBZ7jvNlxjRT8iZXo0/vNdS9shk0kf3WmgK+zYqEHtXk3mzGeptw83GzFdy3oM2ZInmjKRAh/3mtsVaboowuqgoCg7tU5w/SfvdaZgSFsyyF+/ZC03KOrjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z7rKNo3C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z7rKNo3C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80DCCC4CEE7;
	Sat, 21 Jun 2025 18:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750531738;
	bh=pKvxx3mN11OuZ4qb6QXI0CIUfgBt6xFSKmmlZNvKa98=;
	h=Date:To:From:Subject:From;
	b=z7rKNo3CRxBdT88l/X3xwVVPgnnHjVAsJi7LqsxQU69tZSAcSXacsNcM4FXd6hFgZ
	 7Oe6e3I1iJQ+mNIGzjo8Nup6uICsQ/myQY68L1P9/eZrqUj//sqdbteJcFFrdL4K4O
	 s4hBlA1YUO59RF4Y4GCbImxe7NAsWAi1/zas12lQ=
Date: Sat, 21 Jun 2025 11:48:57 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mfasheh@suse.com,junxiao.bi@oracle.com,joseph.qi@huawei.com,jlbec@evilplan.org,jiangyiwen@huawei.com,gechangwei@live.cn,djahchankoike@gmail.com,penguin-kernel@I-love.SAKURA.ne.jp,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-kill-osb-system_file_mutex-lock.patch added to mm-nonmm-unstable branch
Message-Id: <20250621184858.80DCCC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: kill osb->system_file_mutex lock
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-kill-osb-system_file_mutex-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-kill-osb-system_file_mutex-lock.patch

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
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: ocfs2: kill osb->system_file_mutex lock
Date: Sun, 22 Jun 2025 00:56:46 +0900

Since calling _ocfs2_get_system_file_inode() twice with the same arguments
returns the same address, there is no need to serialize
_ocfs2_get_system_file_inode() using osb->system_file_mutex lock.

Kill osb->system_file_mutex lock in order to avoid AB-BA deadlock. 
cmpxchg() will be sufficient for avoiding the inode refcount leak problem
which commit 43b10a20372d ("ocfs2: avoid system inode ref confusion by
adding mutex lock") tried to address.

Link: https://lkml.kernel.org/r/934355dd-a0b1-4e53-93ac-0a7ae7458051@I-love.SAKURA.ne.jp
Reported-by: Diogo Jahchan Koike <djahchankoike@gmail.com>
Closes: https://lkml.kernel.org/r/000000000000ff2d7a0620381afe@google.com
Fixes: 43b10a20372d ("ocfs2: avoid system inode ref confusion by adding mutex lock")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: jiangyiwen <jiangyiwen@huawei.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/ocfs2.h   |    2 --
 fs/ocfs2/super.c   |    2 --
 fs/ocfs2/sysfile.c |    9 +++------
 3 files changed, 3 insertions(+), 10 deletions(-)

--- a/fs/ocfs2/ocfs2.h~ocfs2-kill-osb-system_file_mutex-lock
+++ a/fs/ocfs2/ocfs2.h
@@ -494,8 +494,6 @@ struct ocfs2_super
 	struct rb_root	osb_rf_lock_tree;
 	struct ocfs2_refcount_tree *osb_ref_tree_lru;
 
-	struct mutex system_file_mutex;
-
 	/*
 	 * OCFS2 needs to schedule several different types of work which
 	 * require cluster locking, disk I/O, recovery waits, etc. Since these
--- a/fs/ocfs2/super.c~ocfs2-kill-osb-system_file_mutex-lock
+++ a/fs/ocfs2/super.c
@@ -1997,8 +1997,6 @@ static int ocfs2_initialize_super(struct
 	spin_lock_init(&osb->osb_xattr_lock);
 	ocfs2_init_steal_slots(osb);
 
-	mutex_init(&osb->system_file_mutex);
-
 	atomic_set(&osb->alloc_stats.moves, 0);
 	atomic_set(&osb->alloc_stats.local_data, 0);
 	atomic_set(&osb->alloc_stats.bitmap_data, 0);
--- a/fs/ocfs2/sysfile.c~ocfs2-kill-osb-system_file_mutex-lock
+++ a/fs/ocfs2/sysfile.c
@@ -98,11 +98,9 @@ struct inode *ocfs2_get_system_file_inod
 	} else
 		arr = get_local_system_inode(osb, type, slot);
 
-	mutex_lock(&osb->system_file_mutex);
 	if (arr && ((inode = *arr) != NULL)) {
 		/* get a ref in addition to the array ref */
 		inode = igrab(inode);
-		mutex_unlock(&osb->system_file_mutex);
 		BUG_ON(!inode);
 
 		return inode;
@@ -112,11 +110,10 @@ struct inode *ocfs2_get_system_file_inod
 	inode = _ocfs2_get_system_file_inode(osb, type, slot);
 
 	/* add one more if putting into array for first time */
-	if (arr && inode) {
-		*arr = igrab(inode);
-		BUG_ON(!*arr);
+	if (inode && arr && !*arr && !cmpxchg(&(*arr), NULL, inode)) {
+		inode = igrab(inode);
+		BUG_ON(!inode);
 	}
-	mutex_unlock(&osb->system_file_mutex);
 	return inode;
 }
 
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

ocfs2-kill-osb-system_file_mutex-lock.patch

