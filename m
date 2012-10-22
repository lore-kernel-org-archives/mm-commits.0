From: akpm@linux-foundation.org
Subject: + cgroup-fix-invalid-rcu-dereference.patch added to -mm tree
Date: Mon, 22 Oct 2012 12:55:05 -0700
Message-ID: <20121022195506.457DB100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:63526 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab2JVTzH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Oct 2012 15:55:07 -0400
Received: by mail-ye0-f202.google.com with SMTP id r11so223938yen.1
        for <mm-commits@vger.kernel.org>; Mon, 22 Oct 2012 12:55:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jslaby@suse.cz, davej@redhat.com, jmorris@namei.org, lizefan@huawei.com, serge.hallyn@canonical.com, tj@kernel.org, xemul@openvz.org


The patch titled
     Subject: cgroup: fix invalid rcu dereference
has been added to the -mm tree.  Its filename is
     cgroup-fix-invalid-rcu-dereference.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jiri Slaby <jslaby@suse.cz>
Subject: cgroup: fix invalid rcu dereference

Commit ad676077a2ae ("device_cgroup: convert device_cgroup internally to
policy + exceptions") removed rcu locks which are needed in task_devcgroup
called in this chain: devcgroup_inode_mknod OR
__devcgroup_inode_permission -> __devcgroup_inode_permission ->
task_devcgroup -> task_subsys_state -> task_subsys_state_check.

Change the code so that task_devcgroup is safely called with rcu read
lock held.

===============================
[ INFO: suspicious RCU usage. ]
3.6.0-rc5-next-20120913+ #42 Not tainted
-------------------------------
include/linux/cgroup.h:553 suspicious rcu_dereference_check() usage!

other info that might help us debug this:

rcu_scheduler_active = 1, debug_locks = 0
2 locks held by kdevtmpfs/23:
 #0:  (sb_writers){.+.+.+}, at: [<ffffffff8116873f>]
mnt_want_write+0x1f/0x50
 #1:  (&sb->s_type->i_mutex_key#3/1){+.+.+.}, at: [<ffffffff811558af>]
kern_path_create+0x7f/0x170

stack backtrace:
Pid: 23, comm: kdevtmpfs Not tainted 3.6.0-rc5-next-20120913+ #42
Call Trace:
 [<ffffffff810c638d>] lockdep_rcu_suspicious+0xfd/0x130
 [<ffffffff8121541d>] devcgroup_inode_mknod+0x19d/0x240
 [<ffffffff8107bf54>] ? ns_capable+0x44/0x80
 [<ffffffff81156b21>] vfs_mknod+0x71/0xf0
 [<ffffffff813a8332>] handle_create.isra.2+0x72/0x200
 [<ffffffff813a85d4>] devtmpfsd+0x114/0x140
 [<ffffffff813a84c0>] ? handle_create.isra.2+0x200/0x200
 [<ffffffff81093ad6>] kthread+0xd6/0xe0
 [<ffffffff81654f24>] kernel_thread_helper+0x4/0x10
 [<ffffffff8165369d>] ? retint_restore_args+0xe/0xe
 [<ffffffff81093a00>] ? kthread_create_on_node+0x140/0x140
 [<ffffffff81654f20>] ? gs_change+0xb/0xb

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Dave Jones <davej@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: James Morris <jmorris@namei.org>
Cc: Pavel Emelyanov <xemul@openvz.org>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/device_cgroup.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN security/device_cgroup.c~cgroup-fix-invalid-rcu-dereference security/device_cgroup.c
--- a/security/device_cgroup.c~cgroup-fix-invalid-rcu-dereference
+++ a/security/device_cgroup.c
@@ -533,10 +533,10 @@ struct cgroup_subsys devices_subsys = {
  *
  * returns 0 on success, -EPERM case the operation is not permitted
  */
-static int __devcgroup_check_permission(struct dev_cgroup *dev_cgroup,
-					short type, u32 major, u32 minor,
+static int __devcgroup_check_permission(short type, u32 major, u32 minor,
 				        short access)
 {
+	struct dev_cgroup *dev_cgroup;
 	struct dev_exception_item ex;
 	int rc;
 
@@ -547,6 +547,7 @@ static int __devcgroup_check_permission(
 	ex.access = access;
 
 	rcu_read_lock();
+	dev_cgroup = task_devcgroup(current);
 	rc = may_access(dev_cgroup, &ex);
 	rcu_read_unlock();
 
@@ -558,7 +559,6 @@ static int __devcgroup_check_permission(
 
 int __devcgroup_inode_permission(struct inode *inode, int mask)
 {
-	struct dev_cgroup *dev_cgroup = task_devcgroup(current);
 	short type, access = 0;
 
 	if (S_ISBLK(inode->i_mode))
@@ -570,13 +570,12 @@ int __devcgroup_inode_permission(struct 
 	if (mask & MAY_READ)
 		access |= ACC_READ;
 
-	return __devcgroup_check_permission(dev_cgroup, type, imajor(inode),
-					    iminor(inode), access);
+	return __devcgroup_check_permission(type, imajor(inode), iminor(inode),
+			access);
 }
 
 int devcgroup_inode_mknod(int mode, dev_t dev)
 {
-	struct dev_cgroup *dev_cgroup = task_devcgroup(current);
 	short type;
 
 	if (!S_ISBLK(mode) && !S_ISCHR(mode))
@@ -587,7 +586,7 @@ int devcgroup_inode_mknod(int mode, dev_
 	else
 		type = DEV_CHAR;
 
-	return __devcgroup_check_permission(dev_cgroup, type, MAJOR(dev),
-					    MINOR(dev), ACC_MKNOD);
+	return __devcgroup_check_permission(type, MAJOR(dev), MINOR(dev),
+			ACC_MKNOD);
 
 }
_

Patches currently in -mm which might be from jslaby@suse.cz are

cgroup-fix-invalid-rcu-dereference.patch
device_cgroup-rename-deny_all-to-behavior.patch
device_cgroup-stop-using-simple_strtoul.patch
device_cgroup-add-proper-checking-when-changing-default-behavior.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-only-in-direct-reclaim.patch

