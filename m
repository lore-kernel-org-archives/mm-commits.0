From: akpm@linux-foundation.org
Subject: - bsdacct-turn-acct-off-for-all-pidns-s-on-umount-time.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:03:03 -0700
Message-ID: <200807252303.m6PN333B003887@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754754AbYGYXGs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:06:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, balbir@in.ibm.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     bsdacct: turn acct off for all pidns-s on umount time
has been removed from the -mm tree.  Its filename was
     bsdacct-turn-acct-off-for-all-pidns-s-on-umount-time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bsdacct: turn acct off for all pidns-s on umount time
From: Pavel Emelyanov <xemul@openvz.org>

All the bsd_acct_strcts with opened accounting are linked into a global
list.  So, the acct_auto_close(_mnt) walks one and drops the accounting
for each.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/acct.c |   28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff -puN kernel/acct.c~bsdacct-turn-acct-off-for-all-pidns-s-on-umount-time kernel/acct.c
--- a/kernel/acct.c~bsdacct-turn-acct-off-for-all-pidns-s-on-umount-time
+++ a/kernel/acct.c
@@ -89,9 +89,11 @@ struct bsd_acct_struct {
 	struct file		*file;
 	struct pid_namespace	*ns;
 	struct timer_list	timer;
+	struct list_head	list;
 };
 
 static DEFINE_SPINLOCK(acct_lock);
+static LIST_HEAD(acct_list);
 
 /*
  * Called whenever the timer says to check the free space.
@@ -188,12 +190,14 @@ static void acct_file_reopen(struct bsd_
 		acct->needcheck = 0;
 		acct->file = NULL;
 		acct->ns = NULL;
+		list_del(&acct->list);
 	}
 	if (file) {
 		acct->file = file;
 		acct->ns = ns;
 		acct->needcheck = 0;
 		acct->active = 1;
+		list_add(&acct->list, &acct_list);
 		/* It's been deleted if it was used before so this is safe */
 		setup_timer(&acct->timer, acct_timeout, (unsigned long)acct);
 		acct->timer.expires = jiffies + ACCT_TIMEOUT*HZ;
@@ -314,13 +318,13 @@ void acct_auto_close_mnt(struct vfsmount
 {
 	struct bsd_acct_struct *acct;
 
-	acct = init_pid_ns.bacct;
-	if (acct == NULL)
-		return;
-
 	spin_lock(&acct_lock);
-	if (acct->file && acct->file->f_path.mnt == m)
-		acct_file_reopen(acct, NULL, NULL);
+restart:
+	list_for_each_entry(acct, &acct_list, list)
+		if (acct->file && acct->file->f_path.mnt == m) {
+			acct_file_reopen(acct, NULL, NULL);
+			goto restart;
+		}
 	spin_unlock(&acct_lock);
 }
 
@@ -335,13 +339,13 @@ void acct_auto_close(struct super_block 
 {
 	struct bsd_acct_struct *acct;
 
-	acct = init_pid_ns.bacct;
-	if (acct == NULL)
-		return;
-
 	spin_lock(&acct_lock);
-	if (acct->file && acct->file->f_path.mnt->mnt_sb == sb)
-		acct_file_reopen(acct, NULL, NULL);
+restart:
+	list_for_each_entry(acct, &acct_list, list)
+		if (acct->file && acct->file->f_path.mnt->mnt_sb == sb) {
+			acct_file_reopen(acct, NULL, NULL);
+			goto restart;
+		}
 	spin_unlock(&acct_lock);
 }
 
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
reiser4.patch

