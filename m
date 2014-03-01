From: akpm@linux-foundation.org
Subject: + ocfs2-flock-drop-cross-node-lock-when-failed-locally.patch
 added to -mm tree
Date: Fri, 28 Feb 2014 16:08:32 -0800
Message-ID: <53112500.JI5WIC4MzYX0/vf+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52729 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbaCAAId (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Feb 2014 19:08:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, wen.gang.wang@oracle.com

Subject: + ocfs2-flock-drop-cross-node-lock-when-failed-locally.patch added to -mm tree
To: wen.gang.wang@oracle.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Fri, 28 Feb 2014 16:08:32 -0800


The patch titled
     Subject: ocfs2: flock: drop cross-node lock when failed locally
has been added to the -mm tree.  Its filename is
     ocfs2-flock-drop-cross-node-lock-when-failed-locally.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-flock-drop-cross-node-lock-when-failed-locally.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-flock-drop-cross-node-lock-when-failed-locally.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wengang Wang <wen.gang.wang@oracle.com>
Subject: ocfs2: flock: drop cross-node lock when failed locally

ocfs2_do_flock() calls ocfs2_file_lock() to get the cross-node clock and
then call flock_lock_file_wait() to compete with local processes.  In case
flock_lock_file_wait() failed, say -ENOMEM, clean up work is not done. 
This patch adds the cleanup --drop the cross-node lock which was just
granted.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/locks.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/ocfs2/locks.c~ocfs2-flock-drop-cross-node-lock-when-failed-locally fs/ocfs2/locks.c
--- a/fs/ocfs2/locks.c~ocfs2-flock-drop-cross-node-lock-when-failed-locally
+++ a/fs/ocfs2/locks.c
@@ -82,6 +82,9 @@ static int ocfs2_do_flock(struct file *f
 	}
 
 	ret = flock_lock_file_wait(file, fl);
+	if (ret) {
+		ocfs2_file_unlock(file);
+	}
 
 out:
 	mutex_unlock(&fp->fp_mutex);
_

Patches currently in -mm which might be from wen.gang.wang@oracle.com are

ocfs2-change-ip_unaligned_aio-to-of-type-mutex-from-atomit_t.patch
ocfs2-dlm-fix-lock-migration-crash.patch
ocfs2-dlm-fix-recovery-hung.patch
ocfs2-flock-drop-cross-node-lock-when-failed-locally.patch

