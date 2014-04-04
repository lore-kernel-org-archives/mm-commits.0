From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-flock-drop-cross-node-lock-when-failed-locally.patch removed from -mm tree
Date: Fri, 04 Apr 2014 12:30:32 -0700
Message-ID: <533f0858.Xldq2iTnOetVhGQK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42788 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194AbaDDTad (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:30:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.de, jlbec@evilplan.org, wen.gang.wang@oracle.com

Subject: [merged] ocfs2-flock-drop-cross-node-lock-when-failed-locally.patch removed from -mm tree
To: wen.gang.wang@oracle.com,jlbec@evilplan.org,mfasheh@suse.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:30:32 -0700


The patch titled
     Subject: ocfs2: flock: drop cross-node lock when failed locally
has been removed from the -mm tree.  Its filename was
     ocfs2-flock-drop-cross-node-lock-when-failed-locally.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wengang Wang <wen.gang.wang@oracle.com>
Subject: ocfs2: flock: drop cross-node lock when failed locally

ocfs2_do_flock() calls ocfs2_file_lock() to get the cross-node clock and
then call flock_lock_file_wait() to compete with local processes.  In case
flock_lock_file_wait() failed, say -ENOMEM, clean up work is not done. 
This patch adds the cleanup --drop the cross-node lock which was just
granted.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/locks.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/ocfs2/locks.c~ocfs2-flock-drop-cross-node-lock-when-failed-locally fs/ocfs2/locks.c
--- a/fs/ocfs2/locks.c~ocfs2-flock-drop-cross-node-lock-when-failed-locally
+++ a/fs/ocfs2/locks.c
@@ -82,6 +82,8 @@ static int ocfs2_do_flock(struct file *f
 	}
 
 	ret = flock_lock_file_wait(file, fl);
+	if (ret)
+		ocfs2_file_unlock(file);
 
 out:
 	mutex_unlock(&fp->fp_mutex);
_

Patches currently in -mm which might be from wen.gang.wang@oracle.com are

origin.patch

