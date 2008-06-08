From: akpm@linux-foundation.org
Subject: - devscgroup-relax-task-to-dev_cgroup-conversion.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:48:09 -0700
Message-ID: <200806081948.m58Jm9wi017481@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40446 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754478AbYFHTtK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:49:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, balbir@in.ibm.com, chrisw@sous-sol.org, jmorris@namei.org, menage@google.com, sds@tycho.nsa.gov, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     devscgroup: relax task to dev_cgroup conversion
has been removed from the -mm tree.  Its filename was
     devscgroup-relax-task-to-dev_cgroup-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: devscgroup: relax task to dev_cgroup conversion
From: Pavel Emelyanov <xemul@openvz.org>

Two functions, that need to get a device_cgroup from a task (they are
devcgroup_inode_permission and devcgroup_inode_mknod) make it in a strange
way:

They get a css_set from task, then a subsys_state from css_set, then a
cgroup from the state and then a subsys_state again from the cgroup. 
Besides, the devices_subsys_id is read from memory, whilst there's a
enum-ed constant for it.

Optimize this part a bit:
1. Get the subsys_stats form the task and be done - no 2 extra
   dereferences,
2. Use the device_subsys_id constant, not the value from memory
   (i.e. one less dereference).

Found while preparing 2.6.26 OpenVZ port.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Acked-by: Paul Menage <menage@google.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: James Morris <jmorris@namei.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/device_cgroup.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN security/device_cgroup.c~devscgroup-relax-task-to-dev_cgroup-conversion security/device_cgroup.c
--- a/security/device_cgroup.c~devscgroup-relax-task-to-dev_cgroup-conversion
+++ a/security/device_cgroup.c
@@ -506,7 +506,6 @@ struct cgroup_subsys devices_subsys = {
 
 int devcgroup_inode_permission(struct inode *inode, int mask)
 {
-	struct cgroup *cgroup;
 	struct dev_cgroup *dev_cgroup;
 	struct dev_whitelist_item *wh;
 
@@ -515,8 +514,8 @@ int devcgroup_inode_permission(struct in
 		return 0;
 	if (!S_ISBLK(inode->i_mode) && !S_ISCHR(inode->i_mode))
 		return 0;
-	cgroup = task_cgroup(current, devices_subsys.subsys_id);
-	dev_cgroup = cgroup_to_devcgroup(cgroup);
+	dev_cgroup = css_to_devcgroup(task_subsys_state(current,
+				devices_subsys_id));
 	if (!dev_cgroup)
 		return 0;
 
@@ -547,12 +546,11 @@ acc_check:
 
 int devcgroup_inode_mknod(int mode, dev_t dev)
 {
-	struct cgroup *cgroup;
 	struct dev_cgroup *dev_cgroup;
 	struct dev_whitelist_item *wh;
 
-	cgroup = task_cgroup(current, devices_subsys.subsys_id);
-	dev_cgroup = cgroup_to_devcgroup(cgroup);
+	dev_cgroup = css_to_devcgroup(task_subsys_state(current,
+				devices_subsys_id));
 	if (!dev_cgroup)
 		return 0;
 
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
linux-next.patch
mark-res_counter_charge_locked-with-__must_check.patch
memcg-make-global-var-read_mostly.patch
memcg-avoid-unnecessary-initialization.patch
memcg-better-migration-handling.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-fix.patch
memcg-handle-swap-cache.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
sysctl-allow-override-of-proc-sys-net-with-cap_net_admin.patch
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

