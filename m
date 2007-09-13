From: akpm@linux-foundation.org
Subject: - add-all-thread-stats-for-taskstats_cmd_attr_tgid.patch removed from -mm tree
Date: Wed, 12 Sep 2007 18:18:50 -0700
Message-ID: <200709130118.l8D1Io6S028103@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44873 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751009AbXIMBS7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Sep 2007 21:18:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guichaz@yahoo.fr, balbir@in.ibm.com, jlan@engr.sgi.com, jlim@sgi.com, nagar@watson.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Add all thread stats for TASKSTATS_CMD_ATTR_TGID
has been removed from the -mm tree.  Its filename was
     add-all-thread-stats-for-taskstats_cmd_attr_tgid.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Add all thread stats for TASKSTATS_CMD_ATTR_TGID
From: "Guillaume Chazarain" <guichaz@yahoo.fr>

Add all thread accounting stats for the global tgid stats.  As a shameless
plug, this fixes iotop -P (http://guichaz.free.fr/misc/iotop.py).

Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Shailabh Nagar <nagar@watson.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Jay Lan <jlan@engr.sgi.com>
Cc: Jonathan Lim <jlim@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |    2 ++
 kernel/tsacct.c    |   22 +++++++++-------------
 2 files changed, 11 insertions(+), 13 deletions(-)

diff -puN kernel/taskstats.c~add-all-thread-stats-for-taskstats_cmd_attr_tgid kernel/taskstats.c
--- a/kernel/taskstats.c~add-all-thread-stats-for-taskstats_cmd_attr_tgid
+++ a/kernel/taskstats.c
@@ -232,6 +232,7 @@ static int fill_tgid(pid_t tgid, struct 
 		memset(stats, 0, sizeof(*stats));
 
 	tsk = first;
+	bacct_add_tsk(stats, first);
 	do {
 		if (tsk->exit_state)
 			continue;
@@ -245,6 +246,7 @@ static int fill_tgid(pid_t tgid, struct 
 
 		stats->nvcsw += tsk->nvcsw;
 		stats->nivcsw += tsk->nivcsw;
+		xacct_add_tsk(stats, tsk);
 	} while_each_thread(first, tsk);
 
 	unlock_task_sighand(first, &flags);
diff -puN kernel/tsacct.c~add-all-thread-stats-for-taskstats_cmd_attr_tgid kernel/tsacct.c
--- a/kernel/tsacct.c~add-all-thread-stats-for-taskstats_cmd_attr_tgid
+++ a/kernel/tsacct.c
@@ -81,8 +81,8 @@ void xacct_add_tsk(struct taskstats *sta
 	struct mm_struct *mm;
 
 	/* convert pages-jiffies to Mbyte-usec */
-	stats->coremem = jiffies_to_usecs(p->acct_rss_mem1) * PAGE_SIZE / MB;
-	stats->virtmem = jiffies_to_usecs(p->acct_vm_mem1) * PAGE_SIZE / MB;
+	stats->coremem += jiffies_to_usecs(p->acct_rss_mem1) * PAGE_SIZE / MB;
+	stats->virtmem += jiffies_to_usecs(p->acct_vm_mem1) * PAGE_SIZE / MB;
 	mm = get_task_mm(p);
 	if (mm) {
 		/* adjust to KB unit */
@@ -90,18 +90,14 @@ void xacct_add_tsk(struct taskstats *sta
 		stats->hiwater_vm    = mm->hiwater_vm * PAGE_SIZE / KB;
 		mmput(mm);
 	}
-	stats->read_char	= p->rchar;
-	stats->write_char	= p->wchar;
-	stats->read_syscalls	= p->syscr;
-	stats->write_syscalls	= p->syscw;
+	stats->read_char	+= p->rchar;
+	stats->write_char	+= p->wchar;
+	stats->read_syscalls	+= p->syscr;
+	stats->write_syscalls	+= p->syscw;
 #ifdef CONFIG_TASK_IO_ACCOUNTING
-	stats->read_bytes	= p->ioac.read_bytes;
-	stats->write_bytes	= p->ioac.write_bytes;
-	stats->cancelled_write_bytes = p->ioac.cancelled_write_bytes;
-#else
-	stats->read_bytes	= 0;
-	stats->write_bytes	= 0;
-	stats->cancelled_write_bytes = 0;
+	stats->read_bytes	+= p->ioac.read_bytes;
+	stats->write_bytes	+= p->ioac.write_bytes;
+	stats->cancelled_write_bytes += p->ioac.cancelled_write_bytes;
 #endif
 }
 #undef KB
_

Patches currently in -mm which might be from guichaz@yahoo.fr are

taskstats-add-all-thread-stats-for-taskstats_cmd_attr_tgid.patch
add-all-thread-stats-for-taskstats_cmd_attr_tgid.patch
sync_sb_inodes-propagate-errors.patch
