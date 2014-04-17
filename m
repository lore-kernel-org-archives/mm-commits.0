From: akpm@linux-foundation.org
Subject: + ocfs2-limit-printk-when-journal-is-aborted.patch added to -mm
 tree
Date: Thu, 17 Apr 2014 13:18:06 -0700
Message-ID: <535036fe.2z8R4hNYYAirfw9n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59978 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaDQUSH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Apr 2014 16:18:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com

Subject: + ocfs2-limit-printk-when-journal-is-aborted.patch added to -mm tree
To: joseph.qi@huawei.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Thu, 17 Apr 2014 13:18:06 -0700


The patch titled
     Subject: ocfs2: limit printk when journal is aborted
has been added to the -mm tree.  Its filename is
     ocfs2-limit-printk-when-journal-is-aborted.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-limit-printk-when-journal-is-aborted.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-limit-printk-when-journal-is-aborted.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: limit printk when journal is aborted

Once JBD2_ABORT is set, ocfs2_commit_cache will fail in
ocfs2_commit_thread.  Then it will get into a loop with mass logs.  This
will meaninglessly consume a larger number of resource and may lead to the
system hanging.  So limit printk in this case.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/journal.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/journal.c~ocfs2-limit-printk-when-journal-is-aborted fs/ocfs2/journal.c
--- a/fs/ocfs2/journal.c~ocfs2-limit-printk-when-journal-is-aborted
+++ a/fs/ocfs2/journal.c
@@ -30,6 +30,7 @@
 #include <linux/kthread.h>
 #include <linux/time.h>
 #include <linux/random.h>
+#include <linux/delay.h>
 
 #include <cluster/masklog.h>
 
@@ -2185,8 +2186,15 @@ static int ocfs2_commit_thread(void *arg
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
+			msleep_interruptible(1000);
+		}
 
 		if (kthread_should_stop() && atomic_read(&journal->j_num_trans)){
 			mlog(ML_KTHREAD,
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-limit-printk-when-journal-is-aborted.patch
ocfs2-fix-a-tiny-race-when-running-dirop_fileop_racer.patch

