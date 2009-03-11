From: akpm@linux-foundation.org
Subject: [merged] kernel-userc-fix-a-memory-leak-when-freeing-up-non-init-usernamespaces-users.patch removed from -mm tree
Date: Wed, 11 Mar 2009 11:09:45 -0700
Message-ID: <200903111809.n2BI9jY5019989@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42703 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752519AbZCKSLl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Mar 2009 14:11:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhaval@linux.vnet.ibm.com, serue@linux.vnet.ibm.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     kernel/user.c: fix a memory leak when freeing up non-init usernamespaces users
has been removed from the -mm tree.  Its filename was
     kernel-userc-fix-a-memory-leak-when-freeing-up-non-init-usernamespaces-users.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/user.c: fix a memory leak when freeing up non-init usernamespaces users
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>

We were returning early in the sysfs directory cleanup function if the
user belonged to a non init usernamespace.  Due to this a lot of the
cleanup was not done and we were left with a leak.  Fix the leak.

Reported-by: Serge Hallyn <serue@linux.vnet.ibm.com>
Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Tested-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/user.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN kernel/user.c~kernel-userc-fix-a-memory-leak-when-freeing-up-non-init-usernamespaces-users kernel/user.c
--- a/kernel/user.c~kernel-userc-fix-a-memory-leak-when-freeing-up-non-init-usernamespaces-users
+++ a/kernel/user.c
@@ -286,14 +286,12 @@ int __init uids_sysfs_init(void)
 /* work function to remove sysfs directory for a user and free up
  * corresponding structures.
  */
-static void remove_user_sysfs_dir(struct work_struct *w)
+static void cleanup_user_struct(struct work_struct *w)
 {
 	struct user_struct *up = container_of(w, struct user_struct, work);
 	unsigned long flags;
 	int remove_user = 0;
 
-	if (up->user_ns != &init_user_ns)
-		return;
 	/* Make uid_hash_remove() + sysfs_remove_file() + kobject_del()
 	 * atomic.
 	 */
@@ -312,9 +310,11 @@ static void remove_user_sysfs_dir(struct
 	if (!remove_user)
 		goto done;
 
-	kobject_uevent(&up->kobj, KOBJ_REMOVE);
-	kobject_del(&up->kobj);
-	kobject_put(&up->kobj);
+	if (up->user_ns == &init_user_ns) {
+		kobject_uevent(&up->kobj, KOBJ_REMOVE);
+		kobject_del(&up->kobj);
+		kobject_put(&up->kobj);
+	}
 
 	sched_destroy_user(up);
 	key_put(up->uid_keyring);
@@ -335,7 +335,7 @@ static void free_user(struct user_struct
 	atomic_inc(&up->__count);
 	spin_unlock_irqrestore(&uidhash_lock, flags);
 
-	INIT_WORK(&up->work, remove_user_sysfs_dir);
+	INIT_WORK(&up->work, cleanup_user_struct);
 	schedule_work(&up->work);
 }
 
_

Patches currently in -mm which might be from dhaval@linux.vnet.ibm.com are

origin.patch
cgroup-css-id-support-remove-rcu_read_lock-from-css_get_next.patch

