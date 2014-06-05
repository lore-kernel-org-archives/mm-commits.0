From: akpm@linux-foundation.org
Subject: [merged] ocfs2-limit-printk-when-journal-is-aborted.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:42:44 -0700
Message-ID: <5390c834.MhgTHvYnHkNORVKd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55580 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbaFETmp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:42:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com

Subject: [merged] ocfs2-limit-printk-when-journal-is-aborted.patch removed from -mm tree
To: joseph.qi@huawei.com,jlbec@evilplan.org,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:42:44 -0700


The patch titled
     Subject: ocfs2: limit printk when journal is aborted
has been removed from the -mm tree.  Its filename was
     ocfs2-limit-printk-when-journal-is-aborted.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: limit printk when journal is aborted

Once JBD2_ABORT is set, ocfs2_commit_cache will fail in
ocfs2_commit_thread.  Then it will get into a loop with mass logs.  This
will meaninglessly consume a larger number of resource and may lead to the
system hanging.  So limit printk in this case.

[akpm@linux-foundation.org: document the msleep]
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/journal.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/journal.c~ocfs2-limit-printk-when-journal-is-aborted fs/ocfs2/journal.c
--- a/fs/ocfs2/journal.c~ocfs2-limit-printk-when-journal-is-aborted
+++ a/fs/ocfs2/journal.c
@@ -30,6 +30,7 @@
 #include <linux/kthread.h>
 #include <linux/time.h>
 #include <linux/random.h>
+#include <linux/delay.h>
 
 #include <cluster/masklog.h>
 
@@ -2185,8 +2186,20 @@ static int ocfs2_commit_thread(void *arg
 					 || kthread_should_stop());
 
 		status = ocfs2_commit_cache(osb);
-		if (status < 0)
-			mlog_errno(status);
+		if (status < 0) {
+			static unsigned long abort_warn_time;
+
+			/* Warn about this once per minute */
+			if (printk_timed_ratelimit(&abort_warn_time, 60*HZ))
+				mlog(ML_ERROR, "status = %d, journal is "
+						"already aborted.\n", status);
+			/*
+			 * After ocfs2_commit_cache() fails, j_num_trans has a
+			 * non-zero value.  Sleep here to avoid a busy-wait
+			 * loop.
+			 */
+			msleep_interruptible(1000);
+		}
 
 		if (kthread_should_stop() && atomic_read(&journal->j_num_trans)){
 			mlog(ML_KTHREAD,
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

origin.patch
ocfs2-fix-a-tiny-race-when-running-dirop_fileop_racer.patch
linux-next.patch

