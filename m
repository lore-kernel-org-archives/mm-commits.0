From: akpm@linux-foundation.org
Subject: + devcgroup-relax-white-list-protection-down-to-rcu.patch added to -mm tree
Date: Sat, 12 Jul 2008 18:54:35 -0700
Message-ID: <200807130154.m6D1sZKq031572@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47917 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752671AbYGMCAY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 Jul 2008 22:00:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, balbir@in.ibm.com, menage@google.com, paulmck@us.ibm.com, serue@us.ibm.com


The patch titled
     devcgroup: relax white-list protection down to RCU
has been added to the -mm tree.  Its filename is
     devcgroup-relax-white-list-protection-down-to-rcu.patch

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
Subject: devcgroup: relax white-list protection down to RCU
From: Pavel Emelyanov <xemul@openvz.org>

Currently this list is protected with a simple spinlock, even for reading
from one.  This is OK, but can be better.

Actually I want it to be better very much, since after replacing the
OpenVZ device permissions engine with the cgroup-based one I noticed, that
we set 12 default device permissions for each newly created container (for
/dev/null, full, terminals, ect devices), and people sometimes have up to
20 perms more, so traversing the ~30-40 elements list under a spinlock
doesn't seem very good.

Here's the RCU protection for white-list - dev_whitelist_item-s are added
and removed under the devcg->lock, but are looked up in permissions
checking under the rcu_read_lock.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/device_cgroup.c |   35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff -puN security/device_cgroup.c~devcgroup-relax-white-list-protection-down-to-rcu security/device_cgroup.c
--- a/security/device_cgroup.c~devcgroup-relax-white-list-protection-down-to-rcu
+++ a/security/device_cgroup.c
@@ -41,6 +41,7 @@ struct dev_whitelist_item {
 	short type;
 	short access;
 	struct list_head list;
+	struct rcu_head rcu;
 };
 
 struct dev_cgroup {
@@ -133,11 +134,19 @@ static int dev_whitelist_add(struct dev_
 	}
 
 	if (whcopy != NULL)
-		list_add_tail(&whcopy->list, &dev_cgroup->whitelist);
+		list_add_tail_rcu(&whcopy->list, &dev_cgroup->whitelist);
 	spin_unlock(&dev_cgroup->lock);
 	return 0;
 }
 
+static void whitelist_item_free(struct rcu_head *rcu)
+{
+	struct dev_whitelist_item *item;
+
+	item = container_of(rcu, struct dev_whitelist_item, rcu);
+	kfree(item);
+}
+
 /*
  * called under cgroup_lock()
  * since the list is visible to other tasks, we need the spinlock also
@@ -161,8 +170,8 @@ static void dev_whitelist_rm(struct dev_
 remove:
 		walk->access &= ~wh->access;
 		if (!walk->access) {
-			list_del(&walk->list);
-			kfree(walk);
+			list_del_rcu(&walk->list);
+			call_rcu(&walk->rcu, whitelist_item_free);
 		}
 	}
 	spin_unlock(&dev_cgroup->lock);
@@ -269,15 +278,15 @@ static int devcgroup_seq_read(struct cgr
 	struct dev_whitelist_item *wh;
 	char maj[MAJMINLEN], min[MAJMINLEN], acc[ACCLEN];
 
-	spin_lock(&devcgroup->lock);
-	list_for_each_entry(wh, &devcgroup->whitelist, list) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(wh, &devcgroup->whitelist, list) {
 		set_access(acc, wh->access);
 		set_majmin(maj, wh->major);
 		set_majmin(min, wh->minor);
 		seq_printf(m, "%c %s:%s %s\n", type_to_char(wh->type),
 			   maj, min, acc);
 	}
-	spin_unlock(&devcgroup->lock);
+	rcu_read_unlock();
 
 	return 0;
 }
@@ -510,8 +519,8 @@ int devcgroup_inode_permission(struct in
 	if (!dev_cgroup)
 		return 0;
 
-	spin_lock(&dev_cgroup->lock);
-	list_for_each_entry(wh, &dev_cgroup->whitelist, list) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(wh, &dev_cgroup->whitelist, list) {
 		if (wh->type & DEV_ALL)
 			goto acc_check;
 		if ((wh->type & DEV_BLOCK) && !S_ISBLK(inode->i_mode))
@@ -527,10 +536,10 @@ acc_check:
 			continue;
 		if ((mask & MAY_READ) && !(wh->access & ACC_READ))
 			continue;
-		spin_unlock(&dev_cgroup->lock);
+		rcu_read_unlock();
 		return 0;
 	}
-	spin_unlock(&dev_cgroup->lock);
+	rcu_read_unlock();
 
 	return -EPERM;
 }
@@ -545,7 +554,7 @@ int devcgroup_inode_mknod(int mode, dev_
 	if (!dev_cgroup)
 		return 0;
 
-	spin_lock(&dev_cgroup->lock);
+	rcu_read_lock();
 	list_for_each_entry(wh, &dev_cgroup->whitelist, list) {
 		if (wh->type & DEV_ALL)
 			goto acc_check;
@@ -560,9 +569,9 @@ int devcgroup_inode_mknod(int mode, dev_
 acc_check:
 		if (!(wh->access & ACC_MKNOD))
 			continue;
-		spin_unlock(&dev_cgroup->lock);
+		rcu_read_unlock();
 		return 0;
 	}
-	spin_unlock(&dev_cgroup->lock);
+	rcu_read_unlock();
 	return -EPERM;
 }
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
linux-next.patch
mark-res_counter_charge_locked-with-__must_check.patch
cgroup-files-clean-up-whitespace-in-struct-cftype.patch
cgroup-files-add-write_string-cgroup-control-file-method.patch
cgroup-files-move-the-release_agent-file-to-use-typed-handlers.patch
cgroups-misc-cleanups-to-write_string-patchset.patch
cgroup-files-move-notify_on_release-file-to-separate-write-handler.patch
cgroup-files-turn-attach_task_by_pid-directly-into-a-cgroup-write-handler.patch
cgroup-files-remove-cpuset_common_file_write.patch
cgroup-files-convert-devcgroup_access_write-into-a-cgroup-write_string-handler.patch
cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler.patch
devcgroup-relax-white-list-protection-down-to-rcu.patch
memcg-make-global-var-read_mostly.patch
memcg-avoid-unnecessary-initialization.patch
memcg-better-migration-handling.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-fix.patch
memcg-remove-refcnt-from-page_cgroup-fix-2.patch
memcg-remove-refcnt-from-page_cgroup-fix-memcg-fix-mem_cgroup_end_migration-race.patch
memcg-remove-refcnt-from-page_cgroup-memcg-fix-shmem_unuse_inode-charging.patch
memcg-handle-swap-cache.patch
memcg-handle-swap-cache-fix.patch
memcg-handle-swap-cache-fix-shmem-page-migration-incorrectness-on-memcgroup.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-helper-function-for-relcaim-from-shmem-memcg-shmem_getpage-release-page-sooner.patch
memcg-helper-function-for-relcaim-from-shmem-memcg-mem_cgroup_shrink_usage-css_put.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-setup-the-memrlimit-controller-memrlimit-correct-mremap-and-move_vma-accounting.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info-memrlimit-fix-mmap_sem-deadlock.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info-memrlimit-fix-sleep-inside-sleeplock-in-mm_update_next_owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memrlimit-improve-fork-and-error-handling.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback-update.patch
sysctl-allow-override-of-proc-sys-net-with-cap_net_admin.patch
pidns-remove-now-unused-kill_proc-function.patch
pidns-remove-now-unused-find_pid-function.patch
pidns-remove-find_task_by_pid-unused-for-a-long-time.patch
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
bsdacct-stir-up-comments-around-acct_process.patch
reiser4.patch

