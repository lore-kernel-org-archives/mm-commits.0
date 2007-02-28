From: akpm@linux-foundation.org
Subject: - kvm-add-internal-filesystem-for-generating-inodes.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:54:57 -0800
Message-ID: <200702282354.l1SNsvp8031237@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48546 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932740AbXB1Xy7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:54:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     kvm: add internal filesystem for generating inodes
has been removed from the -mm tree.  Its filename was
     kvm-add-internal-filesystem-for-generating-inodes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kvm: add internal filesystem for generating inodes
From: Avi Kivity <avi@qumranet.com>

The kvmfs inodes will represent virtual machines and vcpus, as necessary,
reducing cacheline bouncing due to inodes and filps being shared.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/kvm/kvm_main.c |   33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff -puN drivers/kvm/kvm_main.c~kvm-add-internal-filesystem-for-generating-inodes drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-add-internal-filesystem-for-generating-inodes
+++ a/drivers/kvm/kvm_main.c
@@ -36,6 +36,8 @@
 #include <asm/desc.h>
 #include <linux/sysdev.h>
 #include <linux/cpu.h>
+#include <linux/fs.h>
+#include <linux/mount.h>
 
 #include "x86_emulate.h"
 #include "segment_descriptor.h"
@@ -72,6 +74,9 @@ static struct kvm_stats_debugfs_item {
 
 static struct dentry *debugfs_dir;
 
+#define KVMFS_MAGIC 0x19700426
+struct vfsmount *kvmfs_mnt;
+
 #define MAX_IO_MSRS 256
 
 #define CR0_RESEVED_BITS 0xffffffff1ffaffc0ULL
@@ -2252,6 +2257,18 @@ static struct sys_device kvm_sysdev = {
 
 hpa_t bad_page_address;
 
+static int kvmfs_get_sb(struct file_system_type *fs_type, int flags,
+			const char *dev_name, void *data, struct vfsmount *mnt)
+{
+	return get_sb_pseudo(fs_type, "kvm:", NULL, KVMFS_MAGIC, mnt);
+}
+
+static struct file_system_type kvm_fs_type = {
+	.name		= "kvmfs",
+	.get_sb		= kvmfs_get_sb,
+	.kill_sb	= kill_anon_super,
+};
+
 int kvm_init_arch(struct kvm_arch_ops *ops, struct module *module)
 {
 	int r;
@@ -2328,8 +2345,16 @@ void kvm_exit_arch(void)
 static __init int kvm_init(void)
 {
 	static struct page *bad_page;
-	int r = 0;
+	int r;
+
+	r = register_filesystem(&kvm_fs_type);
+	if (r)
+		goto out3;
 
+	kvmfs_mnt = kern_mount(&kvm_fs_type);
+	r = PTR_ERR(kvmfs_mnt);
+	if (IS_ERR(kvmfs_mnt))
+		goto out2;
 	kvm_init_debug();
 
 	kvm_init_msr_list();
@@ -2346,6 +2371,10 @@ static __init int kvm_init(void)
 
 out:
 	kvm_exit_debug();
+	mntput(kvmfs_mnt);
+out2:
+	unregister_filesystem(&kvm_fs_type);
+out3:
 	return r;
 }
 
@@ -2353,6 +2382,8 @@ static __exit void kvm_exit(void)
 {
 	kvm_exit_debug();
 	__free_page(pfn_to_page(bad_page_address >> PAGE_SHIFT));
+	mntput(kvmfs_mnt);
+	unregister_filesystem(&kvm_fs_type);
 }
 
 module_init(kvm_init)
_

Patches currently in -mm which might be from avi@qumranet.com are

git-kvm.patch
kvm-add-internal-filesystem-for-generating-inodes-tweak.patch
