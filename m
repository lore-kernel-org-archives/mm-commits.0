From: akpm@linux-foundation.org
Subject: + kvm-add-internal-filesystem-for-generating-inodes.patch added to -mm tree
Date: Wed, 21 Feb 2007 18:20:53 -0800
Message-ID: <200702220220.l1M2KrG7001682@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33944 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378AbXBVCU4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 21:20:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avi@qumranet.com


The patch titled
     kvm: add internal filesystem for generating inodes
has been added to the -mm tree.  Its filename is
     kvm-add-internal-filesystem-for-generating-inodes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

kvm-mmu-add-missing-dirty-page-tracking-cases.patch
kvm-move-virtualization-deactivation-from-cpu_dead.patch
kvm-cosmetics.patch
kvm-vmx-hack-set_cr0_no_modeswitch-to-actually-do.patch
kvm-use-array_size-macro-instead-of-manual-calculation.patch
kvm-use-page_private-set_page_private-apis.patch
kvm-add-msr-based-hypercall-api.patch
kvm-add-host-hypercall-support-for-vmx.patch
kvm-add-hypercall-host-support-for-svm.patch
kvm-wire-up-hypercall-handlers-to-a-central.patch
kvm-svm-init-cr0-with-the-wp-bit-set.patch
kvm-svm-intercept-smi-to-handle-it-at-host-level.patch
kvm-more-0-null-conversions.patch
kvm-add-internal-filesystem-for-generating-inodes.patch
kvm-add-internal-filesystem-for-generating-inodes-tweak.patch
kvm-create-an-inode-per-virtual-machine.patch
kvm-rename-some-kvm_dev_ioctl_-functions-to.patch
kvm-move-kvm_vm_ioctl_create_vcpu-around.patch
kvm-per-vcpu-inodes.patch
kvm-bump-api-version.patch
