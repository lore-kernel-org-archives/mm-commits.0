From: akpm@linux-foundation.org
Subject: + bsdacct-turn-acct-off-for-all-pidns-s-on-umount-time.patch added to -mm tree
Date: Thu, 15 May 2008 19:45:11 -0700
Message-ID: <200805160245.m4G2jB3X022913@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52938 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753842AbYEPCpv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 22:45:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, balbir@in.ibm.com, ebiederm@xmission.com


The patch titled
     bsdacct: turn acct off for all pidns-s on umount time
has been added to the -mm tree.  Its filename is
     bsdacct-turn-acct-off-for-all-pidns-s-on-umount-time.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
mark-res_counter_charge_locked-with-__must_check.patch
memcg-make-global-var-read_mostly.patch
memcg-avoid-unnecessary-initialization.patch
memcg-better-migration-handling.patch
bsdacct-rename-acct_blbls-to-bsd_acct_struct.patch
pidns-use-kzalloc-when-allocating-new-pid_namespace-struct.patch
pidns-add-the-struct-bsd_acct_struct-pointer-on-pid_namespace-struct.patch
bsdacct-truthify-a-comment-near-acct_process.patch
bsdacct-make-check-timer-accept-a-bsd_acct_struct-argument.patch
bsdacct-turn-the-acct_lock-from-on-the-struct-to-global.patch
bsdacct-make-internal-code-work-with-passed-bsd_acct_struct-not-global.patch
bsdacct-switch-from-global-bsd_acct_struct-instance-to-per-pidns-one.patch
bsdacct-turn-acct-off-for-all-pidns-s-on-umount-time.patch
bsdacct-account-dying-tasks-in-all-relevant-namespaces.patch
reiser4.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

