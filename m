From: akpm@linux-foundation.org
Subject: - bsdacct-turn-the-acct_lock-from-on-the-struct-to-global.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:02:57 -0700
Message-ID: <200807252302.m6PN2vJv003870@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48417 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754902AbYGYXGu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:06:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, balbir@in.ibm.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     bsdacct: turn the acct_lock from on-the-struct to global
has been removed from the -mm tree.  Its filename was
     bsdacct-turn-the-acct_lock-from-on-the-struct-to-global.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bsdacct: turn the acct_lock from on-the-struct to global
From: Pavel Emelyanov <xemul@openvz.org>

Don't use per-bsd-acct-struct lock, but work with a global one.

This lock is taken for short periods, so it doesn't seem it'll become a
bottleneck, but it will allow us to easily avoid many locking difficulties
in the future.

So this is a mostly s/acct_globals.lock/acct_lock/ over the file.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/acct.c |   42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff -puN kernel/acct.c~bsdacct-turn-the-acct_lock-from-on-the-struct-to-global kernel/acct.c
--- a/kernel/acct.c~bsdacct-turn-the-acct_lock-from-on-the-struct-to-global
+++ a/kernel/acct.c
@@ -83,7 +83,6 @@ static void do_acct_process(struct pid_n
  * the cache line to have the data after getting the lock.
  */
 struct bsd_acct_struct {
-	spinlock_t		lock;
 	volatile int		active;
 	volatile int		needcheck;
 	struct file		*file;
@@ -91,8 +90,9 @@ struct bsd_acct_struct {
 	struct timer_list	timer;
 };
 
-static struct bsd_acct_struct acct_globals __cacheline_aligned =
-	{__SPIN_LOCK_UNLOCKED(acct_globals.lock)};
+static DEFINE_SPINLOCK(acct_lock);
+
+static struct bsd_acct_struct acct_globals __cacheline_aligned;
 
 /*
  * Called whenever the timer says to check the free space.
@@ -114,11 +114,11 @@ static int check_free_space(struct file 
 	sector_t resume;
 	sector_t suspend;
 
-	spin_lock(&acct_globals.lock);
+	spin_lock(&acct_lock);
 	res = acct_globals.active;
 	if (!file || !acct_globals.needcheck)
 		goto out;
-	spin_unlock(&acct_globals.lock);
+	spin_unlock(&acct_lock);
 
 	/* May block */
 	if (vfs_statfs(file->f_path.dentry, &sbuf))
@@ -140,7 +140,7 @@ static int check_free_space(struct file 
 	 * If some joker switched acct_globals.file under us we'ld better be
 	 * silent and _not_ touch anything.
 	 */
-	spin_lock(&acct_globals.lock);
+	spin_lock(&acct_lock);
 	if (file != acct_globals.file) {
 		if (act)
 			res = act>0;
@@ -165,7 +165,7 @@ static int check_free_space(struct file 
 	add_timer(&acct_globals.timer);
 	res = acct_globals.active;
 out:
-	spin_unlock(&acct_globals.lock);
+	spin_unlock(&acct_lock);
 	return res;
 }
 
@@ -173,7 +173,7 @@ out:
  * Close the old accounting file (if currently open) and then replace
  * it with file (if non-NULL).
  *
- * NOTE: acct_globals.lock MUST be held on entry and exit.
+ * NOTE: acct_lock MUST be held on entry and exit.
  */
 static void acct_file_reopen(struct file *file)
 {
@@ -201,11 +201,11 @@ static void acct_file_reopen(struct file
 	}
 	if (old_acct) {
 		mnt_unpin(old_acct->f_path.mnt);
-		spin_unlock(&acct_globals.lock);
+		spin_unlock(&acct_lock);
 		do_acct_process(old_ns, old_acct);
 		filp_close(old_acct, NULL);
 		put_pid_ns(old_ns);
-		spin_lock(&acct_globals.lock);
+		spin_lock(&acct_lock);
 	}
 }
 
@@ -235,10 +235,10 @@ static int acct_on(char *name)
 		return error;
 	}
 
-	spin_lock(&acct_globals.lock);
+	spin_lock(&acct_lock);
 	mnt_pin(file->f_path.mnt);
 	acct_file_reopen(file);
-	spin_unlock(&acct_globals.lock);
+	spin_unlock(&acct_lock);
 
 	mntput(file->f_path.mnt); /* it's pinned, now give up active reference */
 
@@ -272,9 +272,9 @@ asmlinkage long sys_acct(const char __us
 	} else {
 		error = security_acct(NULL);
 		if (!error) {
-			spin_lock(&acct_globals.lock);
+			spin_lock(&acct_lock);
 			acct_file_reopen(NULL);
-			spin_unlock(&acct_globals.lock);
+			spin_unlock(&acct_lock);
 		}
 	}
 	return error;
@@ -289,10 +289,10 @@ asmlinkage long sys_acct(const char __us
  */
 void acct_auto_close_mnt(struct vfsmount *m)
 {
-	spin_lock(&acct_globals.lock);
+	spin_lock(&acct_lock);
 	if (acct_globals.file && acct_globals.file->f_path.mnt == m)
 		acct_file_reopen(NULL);
-	spin_unlock(&acct_globals.lock);
+	spin_unlock(&acct_lock);
 }
 
 /**
@@ -304,12 +304,12 @@ void acct_auto_close_mnt(struct vfsmount
  */
 void acct_auto_close(struct super_block *sb)
 {
-	spin_lock(&acct_globals.lock);
+	spin_lock(&acct_lock);
 	if (acct_globals.file &&
 	    acct_globals.file->f_path.mnt->mnt_sb == sb) {
 		acct_file_reopen(NULL);
 	}
-	spin_unlock(&acct_globals.lock);
+	spin_unlock(&acct_lock);
 }
 
 /*
@@ -594,15 +594,15 @@ void acct_process(void)
 	if (!acct_globals.file)
 		return;
 
-	spin_lock(&acct_globals.lock);
+	spin_lock(&acct_lock);
 	file = acct_globals.file;
 	if (unlikely(!file)) {
-		spin_unlock(&acct_globals.lock);
+		spin_unlock(&acct_lock);
 		return;
 	}
 	get_file(file);
 	ns = get_pid_ns(acct_globals.ns);
-	spin_unlock(&acct_globals.lock);
+	spin_unlock(&acct_lock);
 
 	do_acct_process(ns, file);
 	fput(file);
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

