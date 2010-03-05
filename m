From: akpm@linux-foundation.org
Subject: [merged] driver-core-fix-race-condition-in-get_device_parent.patch removed from -mm tree
Date: Fri, 05 Mar 2010 11:03:18 -0800
Message-ID: <201003051903.o25J3I9n022011@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55030 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754742Ab0CETDh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Mar 2010 14:03:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, cguthrie@mandriva.org, gregkh@suse.de, kay.sievers@vrfy.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     driver-core: fix race condition in get_device_parent()
has been removed from the -mm tree.  Its filename was
     driver-core-fix-race-condition-in-get_device_parent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: driver-core: fix race condition in get_device_parent()
From: Tejun Heo <tj@kernel.org>

sysfs is creating several devices in cuse class concurrently and with
CONFIG_SYSFS_DEPRECATED turned off, it triggers the following oops.

 BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
 IP: [<ffffffff81158b0a>] sysfs_addrm_start+0x4a/0xf0
 PGD 75bb067 PUD 75be067 PMD 0
 Oops: 0000 [#1] PREEMPT SMP
 last sysfs file: /sys/devices/system/cpu/cpu7/topology/core_siblings
 CPU 1
 Modules linked in: cuse fuse
 Pid: 4737, comm: osspd Not tainted 2.6.31-work #77
 RIP: 0010:[<ffffffff81158b0a>]  [<ffffffff81158b0a>] sysfs_addrm_start+0x4a/0xf0
 RSP: 0018:ffff88000042f8f8  EFLAGS: 00010296
 RAX: ffff88000042ffd8 RBX: 0000000000000000 RCX: 0000000000000000
 RDX: 0000000000000000 RSI: ffff880007eef660 RDI: 0000000000000001
 RBP: ffff88000042f918 R08: 0000000000000000 R09: 0000000000000000
 R10: 0000000000000001 R11: ffffffff81158b0a R12: ffff88000042f928
 R13: 00000000fffffff4 R14: 0000000000000000 R15: ffff88000042f9a0
 FS:  00007fe93905a950(0000) GS:ffff880008600000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 CR2: 0000000000000038 CR3: 00000000077c9000 CR4: 00000000000006e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Process osspd (pid: 4737, threadinfo ffff88000042e000, task ffff880007eef040)
 Stack:
  ffff880005da10e8 0000000011cc8d6e ffff88000042f928 ffff880003d28a28
 <0> ffff88000042f988 ffffffff811592d7 0000000000000000 0000000000000000
 <0> 0000000000000000 0000000000000000 ffff88000042f958 0000000011cc8d6e
 Call Trace:
  [<ffffffff811592d7>] create_dir+0x67/0xe0
  [<ffffffff811593a8>] sysfs_create_dir+0x58/0xb0
  [<ffffffff8128ca7c>] ? kobject_add_internal+0xcc/0x220
  [<ffffffff812942e1>] ? vsnprintf+0x3c1/0xb90
  [<ffffffff8128cab7>] kobject_add_internal+0x107/0x220
  [<ffffffff8128cd37>] kobject_add_varg+0x47/0x80
  [<ffffffff8128ce53>] kobject_add+0x53/0x90
  [<ffffffff81357d84>] device_add+0xd4/0x690
  [<ffffffff81356c2b>] ? dev_set_name+0x4b/0x70
  [<ffffffffa001a884>] cuse_process_init_reply+0x2b4/0x420 [cuse]
  ...

The problem is that kobject_add_internal() first adds a kobject to the
kset and then try to create sysfs directory for it.  If the creation
fails, it remove the kobject from the kset.  get_device_parent() accesses
class_dirs kset while only holding class_dirs.list_lock to see whether the
cuse class dir exists.  But when it exists, it may not have finished
initialization yet or may fail and get removed soon.  In the above case,
the former happened so the second one ends up trying to create
subdirectory under NULL sysfs_dirent.

Fix it by grabbing a mutex in get_device_parent().

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Colin Guthrie <cguthrie@mandriva.org>
Cc: Greg KH <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/core.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN drivers/base/core.c~driver-core-fix-race-condition-in-get_device_parent drivers/base/core.c
--- a/drivers/base/core.c~driver-core-fix-race-condition-in-get_device_parent
+++ a/drivers/base/core.c
@@ -601,6 +601,7 @@ static struct kobject *get_device_parent
 	int retval;
 
 	if (dev->class) {
+		static DEFINE_MUTEX(gdp_mutex);
 		struct kobject *kobj = NULL;
 		struct kobject *parent_kobj;
 		struct kobject *k;
@@ -617,6 +618,8 @@ static struct kobject *get_device_parent
 		else
 			parent_kobj = &parent->kobj;
 
+		mutex_lock(&gdp_mutex);
+
 		/* find our class-directory at the parent and reference it */
 		spin_lock(&dev->class->p->class_dirs.list_lock);
 		list_for_each_entry(k, &dev->class->p->class_dirs.list, entry)
@@ -625,20 +628,26 @@ static struct kobject *get_device_parent
 				break;
 			}
 		spin_unlock(&dev->class->p->class_dirs.list_lock);
-		if (kobj)
+		if (kobj) {
+			mutex_unlock(&gdp_mutex);
 			return kobj;
+		}
 
 		/* or create a new class-directory at the parent device */
 		k = kobject_create();
-		if (!k)
+		if (!k) {
+			mutex_unlock(&gdp_mutex);
 			return NULL;
+		}
 		k->kset = &dev->class->p->class_dirs;
 		retval = kobject_add(k, parent_kobj, "%s", dev->class->name);
 		if (retval < 0) {
+			mutex_unlock(&gdp_mutex);
 			kobject_put(k);
 			return NULL;
 		}
 		/* do not emit an uevent for this simple "glue" directory */
+		mutex_unlock(&gdp_mutex);
 		return k;
 	}
 
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch

