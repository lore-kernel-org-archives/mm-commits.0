From: akpm@linux-foundation.org
Subject: + nilfs2-integrate-sysfs-support-into-driver.patch added to -mm
 tree
Date: Mon, 23 Jun 2014 14:05:39 -0700
Message-ID: <53a896a3.0Xis04SQrKPKJ7Uq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53174 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941AbaFWVFk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jun 2014 17:05:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Vyacheslav.Dubeyko@hgst.com, konishi.ryusuke@lab.ntt.co.jp, mlsemon35@gmail.com, slava@dubeyko.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: integrate sysfs support into driver
has been added to the -mm tree.  Its filename is
     nilfs2-integrate-sysfs-support-into-driver.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-integrate-sysfs-support-into-driver.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-integrate-sysfs-support-into-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vyacheslav Dubeyko <Vyacheslav.Dubeyko@hgst.com>
Subject: nilfs2: integrate sysfs support into driver

This patch integrates creation of sysfs groups and
attributes into NILFS file system driver.

It was found the issue with nilfs_sysfs_{create/delete}_snapshot_group
functions by Michael L. Semon <mlsemon35@gmail.com> in the first
version of the patch:

[ 4928.585682] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:579
[ 4928.585693] in_atomic(): 1, irqs_disabled(): 0, pid: 32676, name: umount.nilfs2
[ 4928.585698] 2 locks held by umount.nilfs2/32676:
[ 4928.585703]  #0:  (&type->s_umount_key#21){++++..}, at: [<790c18e2>] deactivate_super+0x37/0x58
[ 4928.585732]  #1:  (&(&nilfs->ns_cptree_lock)->rlock){+.+...}, at: [<791bf659>] nilfs_put_root+0x23/0x5a
[ 4928.585749] Preemption disabled at:[<791bf659>] nilfs_put_root+0x23/0x5a

[ 4928.585766] CPU: 0 PID: 32676 Comm: umount.nilfs2 Not tainted 3.14.0+ #2
[ 4928.585771] Hardware name: Dell Computer Corporation Dimension 2350/07W080, BIOS A01 12/17/2002
[ 4928.585777]  00000000 00000000 93cdddf8 793ff0bd c14dd780 93cdde20 7904bf38 794d5224
[ 4928.585795]  791bf659 791bf659 00007fa4 c14dda00 00000000 78025360 79552b80 93cdde68
[ 4928.585811]  7940136e 00000000 00000002 c14dd780 79552d10 c14ddc00 93cdde68 00000246
[ 4928.585828] Call Trace:
[ 4928.585842]  [<793ff0bd>] dump_stack+0x4b/0x75
[ 4928.585854]  [<7904bf38>] __might_sleep+0x111/0x16f
[ 4928.585862]  [<791bf659>] ? nilfs_put_root+0x23/0x5a
[ 4928.585870]  [<791bf659>] ? nilfs_put_root+0x23/0x5a
[ 4928.585880]  [<7940136e>] mutex_lock_nested+0x1e/0x3ad
[ 4928.585893]  [<7911186e>] ? sysfs_remove_dir+0x25/0x62
[ 4928.585901]  [<7910fdb8>] kernfs_remove+0x12/0x26
[ 4928.585908]  [<79111886>] sysfs_remove_dir+0x3d/0x62
[ 4928.585918]  [<792953bb>] kobject_del+0x13/0x38
[ 4928.585926]  [<791cabd4>] nilfs_sysfs_delete_snapshot_group+0xb/0xd
[ 4928.585934]  [<791bf660>] nilfs_put_root+0x2a/0x5a
[ 4928.585942]  [<791c3827>] nilfs_detach_log_writer+0x1ab/0x2c1
[ 4928.585953]  [<7906c283>] ? call_rcu+0x17/0x19
[ 4928.585963]  [<790d5c4b>] ? dispose_list+0x27/0x31
[ 4928.585973]  [<791b4312>] nilfs_put_super+0x13/0x68
[ 4928.585980]  [<790c1bc8>] generic_shutdown_super+0x60/0xd1
[ 4928.585988]  [<790c29dd>] kill_block_super+0x1d/0x60
[ 4928.585996]  [<790c188e>] deactivate_locked_super+0x22/0x3f
[ 4928.586096]  [<790c18e9>] deactivate_super+0x3e/0x58
[ 4928.586107]  [<790d95af>] mntput_no_expire+0xe2/0x141
[ 4928.586115]  [<790d94db>] ? mntput_no_expire+0xe/0x141
[ 4928.586123]  [<790dabed>] SyS_oldumount+0x70/0xa5
[ 4928.586131]  [<794050ff>] syscall_call+0x7/0xb

The reason of the issue was placement of
nilfs_sysfs_{create/delete}_snapshot_group() call under
nilfs->ns_cptree_lock protection.  But this protection is unnecessary and
wrong solution.  The second version of the patch fixes this issue.

Reported-by: Michael L. Semon <mlsemon35@gmail.com>
Signed-off-by: Vyacheslav Dubeyko <Vyacheslav.Dubeyko@hgst.com>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Tested-by: Michael L. Semon <mlsemon35@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/Makefile    |    2 +-
 fs/nilfs2/nilfs.h     |    8 ++++++++
 fs/nilfs2/super.c     |    9 ++++++++-
 fs/nilfs2/the_nilfs.c |   16 +++++++++++++++-
 4 files changed, 32 insertions(+), 3 deletions(-)

diff -puN fs/nilfs2/Makefile~nilfs2-integrate-sysfs-support-into-driver fs/nilfs2/Makefile
--- a/fs/nilfs2/Makefile~nilfs2-integrate-sysfs-support-into-driver
+++ a/fs/nilfs2/Makefile
@@ -2,4 +2,4 @@ obj-$(CONFIG_NILFS2_FS) += nilfs2.o
 nilfs2-y := inode.o file.o dir.o super.o namei.o page.o mdt.o \
 	btnode.o bmap.o btree.o direct.o dat.o recovery.o \
 	the_nilfs.o segbuf.o segment.o cpfile.o sufile.o \
-	ifile.o alloc.o gcinode.o ioctl.o
+	ifile.o alloc.o gcinode.o ioctl.o sysfs.o
diff -puN fs/nilfs2/nilfs.h~nilfs2-integrate-sysfs-support-into-driver fs/nilfs2/nilfs.h
--- a/fs/nilfs2/nilfs.h~nilfs2-integrate-sysfs-support-into-driver
+++ a/fs/nilfs2/nilfs.h
@@ -320,6 +320,14 @@ int nilfs_gccache_wait_and_mark_dirty(st
 int nilfs_init_gcinode(struct inode *inode);
 void nilfs_remove_all_gcinodes(struct the_nilfs *nilfs);
 
+/* sysfs.c */
+int __init nilfs_sysfs_init(void);
+void nilfs_sysfs_exit(void);
+int nilfs_sysfs_create_device_group(struct super_block *);
+void nilfs_sysfs_delete_device_group(struct the_nilfs *);
+int nilfs_sysfs_create_snapshot_group(struct nilfs_root *);
+void nilfs_sysfs_delete_snapshot_group(struct nilfs_root *);
+
 /*
  * Inodes and files operations
  */
diff -puN fs/nilfs2/super.c~nilfs2-integrate-sysfs-support-into-driver fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~nilfs2-integrate-sysfs-support-into-driver
+++ a/fs/nilfs2/super.c
@@ -1452,13 +1452,19 @@ static int __init init_nilfs_fs(void)
 	if (err)
 		goto fail;
 
-	err = register_filesystem(&nilfs_fs_type);
+	err = nilfs_sysfs_init();
 	if (err)
 		goto free_cachep;
 
+	err = register_filesystem(&nilfs_fs_type);
+	if (err)
+		goto deinit_sysfs_entry;
+
 	printk(KERN_INFO "NILFS version 2 loaded\n");
 	return 0;
 
+deinit_sysfs_entry:
+	nilfs_sysfs_exit();
 free_cachep:
 	nilfs_destroy_cachep();
 fail:
@@ -1468,6 +1474,7 @@ fail:
 static void __exit exit_nilfs_fs(void)
 {
 	nilfs_destroy_cachep();
+	nilfs_sysfs_exit();
 	unregister_filesystem(&nilfs_fs_type);
 }
 
diff -puN fs/nilfs2/the_nilfs.c~nilfs2-integrate-sysfs-support-into-driver fs/nilfs2/the_nilfs.c
--- a/fs/nilfs2/the_nilfs.c~nilfs2-integrate-sysfs-support-into-driver
+++ a/fs/nilfs2/the_nilfs.c
@@ -98,6 +98,7 @@ void destroy_nilfs(struct the_nilfs *nil
 {
 	might_sleep();
 	if (nilfs_init(nilfs)) {
+		nilfs_sysfs_delete_device_group(nilfs);
 		brelse(nilfs->ns_sbh[0]);
 		brelse(nilfs->ns_sbh[1]);
 	}
@@ -641,6 +642,10 @@ int init_nilfs(struct the_nilfs *nilfs,
 	if (err)
 		goto failed_sbh;
 
+	err = nilfs_sysfs_create_device_group(sb);
+	if (err)
+		goto failed_sbh;
+
 	set_nilfs_init(nilfs);
 	err = 0;
  out:
@@ -741,12 +746,13 @@ nilfs_find_or_create_root(struct the_nil
 {
 	struct rb_node **p, *parent;
 	struct nilfs_root *root, *new;
+	int err;
 
 	root = nilfs_lookup_root(nilfs, cno);
 	if (root)
 		return root;
 
-	new = kmalloc(sizeof(*root), GFP_KERNEL);
+	new = kzalloc(sizeof(*root), GFP_KERNEL);
 	if (!new)
 		return NULL;
 
@@ -783,6 +789,12 @@ nilfs_find_or_create_root(struct the_nil
 
 	spin_unlock(&nilfs->ns_cptree_lock);
 
+	err = nilfs_sysfs_create_snapshot_group(new);
+	if (err) {
+		kfree(new);
+		new = NULL;
+	}
+
 	return new;
 }
 
@@ -791,6 +803,8 @@ void nilfs_put_root(struct nilfs_root *r
 	if (atomic_dec_and_test(&root->count)) {
 		struct the_nilfs *nilfs = root->nilfs;
 
+		nilfs_sysfs_delete_snapshot_group(root);
+
 		spin_lock(&nilfs->ns_cptree_lock);
 		rb_erase(&root->rb_node, &nilfs->ns_cptree);
 		spin_unlock(&nilfs->ns_cptree_lock);
_

Patches currently in -mm which might be from Vyacheslav.Dubeyko@hgst.com are

nilfs2-add-sys-fs-nilfs2-features-group.patch
nilfs2-add-sys-fs-nilfs2-device-group.patch
nilfs2-add-sys-fs-nilfs2-device-superblock-group.patch
nilfs2-add-sys-fs-nilfs2-device-segctor-group.patch
nilfs2-add-sys-fs-nilfs2-device-segments-group.patch
nilfs2-add-sys-fs-nilfs2-device-checkpoints-group.patch
nilfs2-add-sys-fs-nilfs2-device-mounted_snapshots-group.patch
nilfs2-add-sys-fs-nilfs2-device-mounted_snapshots-snapshot-group.patch
nilfs2-integrate-sysfs-support-into-driver.patch

