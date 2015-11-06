From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-add-uuid-to-ocfs2-thread-name-for-problem-analysis.patch removed from -mm tree
Date: Fri, 06 Nov 2015 12:05:55 -0800
Message-ID: <563d0823.Gy4NbcWjE2uZ4wfb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48462 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033333AbbKFUFz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:05:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, ghe@suse.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: add uuid to ocfs2 thread name for problem analysis
has been removed from the -mm tree.  Its filename was
     ocfs2-add-uuid-to-ocfs2-thread-name-for-problem-analysis.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: add uuid to ocfs2 thread name for problem analysis

A node can mount multiple ocfs2 volumes.  And if thread names are same for
each volume/domain, it will bring inconvenience when analyzing problems
because we have to identify which volume/domain the messages belong to.

Since thread name will be printed to messages, so add volume uuid or dlm
name to thread name can benefit problem analysis.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Gang He <ghe@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmdomain.c   |    4 +++-
 fs/ocfs2/dlm/dlmrecovery.c |    2 +-
 fs/ocfs2/dlm/dlmthread.c   |    3 ++-
 fs/ocfs2/dlmglue.c         |    3 ++-
 fs/ocfs2/journal.c         |    4 ++--
 5 files changed, 10 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/dlm/dlmdomain.c~ocfs2-add-uuid-to-ocfs2-thread-name-for-problem-analysis fs/ocfs2/dlm/dlmdomain.c
--- a/fs/ocfs2/dlm/dlmdomain.c~ocfs2-add-uuid-to-ocfs2-thread-name-for-problem-analysis
+++ a/fs/ocfs2/dlm/dlmdomain.c
@@ -1866,6 +1866,7 @@ static int dlm_join_domain(struct dlm_ct
 	int status;
 	unsigned int backoff;
 	unsigned int total_backoff = 0;
+	char wq_name[O2NM_MAX_NAME_LEN];
 
 	BUG_ON(!dlm);
 
@@ -1895,7 +1896,8 @@ static int dlm_join_domain(struct dlm_ct
 		goto bail;
 	}
 
-	dlm->dlm_worker = create_singlethread_workqueue("dlm_wq");
+	snprintf(wq_name, O2NM_MAX_NAME_LEN, "dlm_wq-%s", dlm->name);
+	dlm->dlm_worker = create_singlethread_workqueue(wq_name);
 	if (!dlm->dlm_worker) {
 		status = -ENOMEM;
 		mlog_errno(status);
diff -puN fs/ocfs2/dlm/dlmrecovery.c~ocfs2-add-uuid-to-ocfs2-thread-name-for-problem-analysis fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-add-uuid-to-ocfs2-thread-name-for-problem-analysis
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -205,7 +205,7 @@ int dlm_launch_recovery_thread(struct dl
 	mlog(0, "starting dlm recovery thread...\n");
 
 	dlm->dlm_reco_thread_task = kthread_run(dlm_recovery_thread, dlm,
-						"dlm_reco_thread");
+			"dlm_reco-%s", dlm->name);
 	if (IS_ERR(dlm->dlm_reco_thread_task)) {
 		mlog_errno(PTR_ERR(dlm->dlm_reco_thread_task));
 		dlm->dlm_reco_thread_task = NULL;
diff -puN fs/ocfs2/dlm/dlmthread.c~ocfs2-add-uuid-to-ocfs2-thread-name-for-problem-analysis fs/ocfs2/dlm/dlmthread.c
--- a/fs/ocfs2/dlm/dlmthread.c~ocfs2-add-uuid-to-ocfs2-thread-name-for-problem-analysis
+++ a/fs/ocfs2/dlm/dlmthread.c
@@ -493,7 +493,8 @@ int dlm_launch_thread(struct dlm_ctxt *d
 {
 	mlog(0, "Starting dlm_thread...\n");
 
-	dlm->dlm_thread_task = kthread_run(dlm_thread, dlm, "dlm_thread");
+	dlm->dlm_thread_task = kthread_run(dlm_thread, dlm, "dlm-%s",
+			dlm->name);
 	if (IS_ERR(dlm->dlm_thread_task)) {
 		mlog_errno(PTR_ERR(dlm->dlm_thread_task));
 		dlm->dlm_thread_task = NULL;
diff -puN fs/ocfs2/dlmglue.c~ocfs2-add-uuid-to-ocfs2-thread-name-for-problem-analysis fs/ocfs2/dlmglue.c
--- a/fs/ocfs2/dlmglue.c~ocfs2-add-uuid-to-ocfs2-thread-name-for-problem-analysis
+++ a/fs/ocfs2/dlmglue.c
@@ -2998,7 +2998,8 @@ int ocfs2_dlm_init(struct ocfs2_super *o
 	}
 
 	/* launch downconvert thread */
-	osb->dc_task = kthread_run(ocfs2_downconvert_thread, osb, "ocfs2dc");
+	osb->dc_task = kthread_run(ocfs2_downconvert_thread, osb, "ocfs2dc-%s",
+			osb->uuid_str);
 	if (IS_ERR(osb->dc_task)) {
 		status = PTR_ERR(osb->dc_task);
 		osb->dc_task = NULL;
diff -puN fs/ocfs2/journal.c~ocfs2-add-uuid-to-ocfs2-thread-name-for-problem-analysis fs/ocfs2/journal.c
--- a/fs/ocfs2/journal.c~ocfs2-add-uuid-to-ocfs2-thread-name-for-problem-analysis
+++ a/fs/ocfs2/journal.c
@@ -1090,7 +1090,7 @@ int ocfs2_journal_load(struct ocfs2_jour
 	/* Launch the commit thread */
 	if (!local) {
 		osb->commit_task = kthread_run(ocfs2_commit_thread, osb,
-					       "ocfs2cmt");
+				"ocfs2cmt-%s", osb->uuid_str);
 		if (IS_ERR(osb->commit_task)) {
 			status = PTR_ERR(osb->commit_task);
 			osb->commit_task = NULL;
@@ -1507,7 +1507,7 @@ void ocfs2_recovery_thread(struct ocfs2_
 		goto out;
 
 	osb->recovery_thread_task =  kthread_run(__ocfs2_recovery_thread, osb,
-						 "ocfs2rec");
+			"ocfs2rec-%s", osb->uuid_str);
 	if (IS_ERR(osb->recovery_thread_task)) {
 		mlog_errno((int)PTR_ERR(osb->recovery_thread_task));
 		osb->recovery_thread_task = NULL;
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-dlm-fix-race-between-convert-and-recovery.patch
ocfs2-dlm-fix-race-between-convert-and-recovery-v2.patch
ocfs2-dlm-fix-race-between-convert-and-recovery-v3.patch
ocfs2-dlm-fix-bug-in-dlm_move_lockres_to_recovery_list.patch

