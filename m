From: akpm@linux-foundation.org
Subject: + libfs-allow-error-return-from-simple-attributes.patch added to -mm tree
Date: Fri, 11 Jan 2008 18:30:19 -0800
Message-ID: <200801120230.m0C2UKDA009996@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55482 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752872AbYALCat (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jan 2008 21:30:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, arnd@arndb.de, greg@kroah.com, stefano.brivio@polimi.it, viro@zeniv.linux.org.uk


The patch titled
     libfs: allow error return from simple attributes
has been added to the -mm tree.  Its filename is
     libfs-allow-error-return-from-simple-attributes.patch

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
Subject: libfs: allow error return from simple attributes
From: Christoph Hellwig <hch@lst.de>

Sometimes simple attributes might need to return an error, e.g. for
acquiring a mutex interruptibly.  In fact we have that situation in
spufs already which is the original user of the simple attributes.  This
patch merged the temporarily forked attributes in spufs back into the
main ones and allows to return errors.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: <stefano.brivio@polimi.it>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <greg@kroah.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/kernel/ocd.c                  |   18 +++++++----
 arch/powerpc/platforms/cell/spufs/file.c |    8 ++---
 fs/debugfs/file.c                        |   32 +++++++++++++--------
 fs/libfs.c                               |   21 ++++++++-----
 include/linux/fs.h                       |    2 -
 lib/fault-inject.c                       |   16 ++++++----
 virt/kvm/kvm_main.c                      |   16 +++++-----
 7 files changed, 67 insertions(+), 46 deletions(-)

diff -puN arch/avr32/kernel/ocd.c~libfs-allow-error-return-from-simple-attributes arch/avr32/kernel/ocd.c
--- a/arch/avr32/kernel/ocd.c~libfs-allow-error-return-from-simple-attributes
+++ a/arch/avr32/kernel/ocd.c
@@ -90,25 +90,29 @@ static struct dentry *ocd_debugfs_DC;
 static struct dentry *ocd_debugfs_DS;
 static struct dentry *ocd_debugfs_count;
 
-static u64 ocd_DC_get(void *data)
+static int ocd_DC_get(void *data, u64 *val)
 {
-	return ocd_read(DC);
+	*val = ocd_read(DC);
+	return 0;
 }
-static void ocd_DC_set(void *data, u64 val)
+static int ocd_DC_set(void *data, u64 val)
 {
 	ocd_write(DC, val);
+	return 0;
 }
 DEFINE_SIMPLE_ATTRIBUTE(fops_DC, ocd_DC_get, ocd_DC_set, "0x%08llx\n");
 
-static u64 ocd_DS_get(void *data)
+static int ocd_DS_get(void *data, u64 *val)
 {
-	return ocd_read(DS);
+	*val = ocd_read(DS);
+	return 0;
 }
 DEFINE_SIMPLE_ATTRIBUTE(fops_DS, ocd_DS_get, NULL, "0x%08llx\n");
 
-static u64 ocd_count_get(void *data)
+static int ocd_count_get(void *data, u64 *val)
 {
-	return ocd_count;
+	*val = ocd_count;
+	return 0;
 }
 DEFINE_SIMPLE_ATTRIBUTE(fops_count, ocd_count_get, NULL, "%lld\n");
 
diff -puN arch/powerpc/platforms/cell/spufs/file.c~libfs-allow-error-return-from-simple-attributes arch/powerpc/platforms/cell/spufs/file.c
--- a/arch/powerpc/platforms/cell/spufs/file.c~libfs-allow-error-return-from-simple-attributes
+++ a/arch/powerpc/platforms/cell/spufs/file.c
@@ -454,7 +454,7 @@ static int spufs_cntl_open(struct inode 
 	if (!i->i_openers++)
 		ctx->cntl = inode->i_mapping;
 	mutex_unlock(&ctx->mapping_lock);
-	return spufs_attr_open(inode, file, spufs_cntl_get,
+	return simple_attr_open(inode, file, spufs_cntl_get,
 					spufs_cntl_set, "0x%08lx");
 }
 
@@ -464,7 +464,7 @@ spufs_cntl_release(struct inode *inode, 
 	struct spufs_inode_info *i = SPUFS_I(inode);
 	struct spu_context *ctx = i->i_ctx;
 
-	spufs_attr_release(inode, file);
+	simple_attr_close(inode, file);
 
 	mutex_lock(&ctx->mapping_lock);
 	if (!--i->i_openers)
@@ -476,8 +476,8 @@ spufs_cntl_release(struct inode *inode, 
 static const struct file_operations spufs_cntl_fops = {
 	.open = spufs_cntl_open,
 	.release = spufs_cntl_release,
-	.read = spufs_attr_read,
-	.write = spufs_attr_write,
+	.read = simple_attr_read,
+	.write = simple_attr_write,
 	.mmap = spufs_cntl_mmap,
 };
 
diff -puN fs/debugfs/file.c~libfs-allow-error-return-from-simple-attributes fs/debugfs/file.c
--- a/fs/debugfs/file.c~libfs-allow-error-return-from-simple-attributes
+++ a/fs/debugfs/file.c
@@ -56,13 +56,15 @@ const struct inode_operations debugfs_li
 	.follow_link    = debugfs_follow_link,
 };
 
-static void debugfs_u8_set(void *data, u64 val)
+static int debugfs_u8_set(void *data, u64 val)
 {
 	*(u8 *)data = val;
+	return 0;
 }
-static u64 debugfs_u8_get(void *data)
+static int debugfs_u8_get(void *data, u64 *val)
 {
-	return *(u8 *)data;
+	*val = *(u8 *)data;
+	return 0;
 }
 DEFINE_SIMPLE_ATTRIBUTE(fops_u8, debugfs_u8_get, debugfs_u8_set, "%llu\n");
 
@@ -97,13 +99,15 @@ struct dentry *debugfs_create_u8(const c
 }
 EXPORT_SYMBOL_GPL(debugfs_create_u8);
 
-static void debugfs_u16_set(void *data, u64 val)
+static int debugfs_u16_set(void *data, u64 val)
 {
 	*(u16 *)data = val;
+	return 0;
 }
-static u64 debugfs_u16_get(void *data)
+static int debugfs_u16_get(void *data, u64 *val)
 {
-	return *(u16 *)data;
+	*val = *(u16 *)data;
+	return 0;
 }
 DEFINE_SIMPLE_ATTRIBUTE(fops_u16, debugfs_u16_get, debugfs_u16_set, "%llu\n");
 
@@ -138,13 +142,15 @@ struct dentry *debugfs_create_u16(const 
 }
 EXPORT_SYMBOL_GPL(debugfs_create_u16);
 
-static void debugfs_u32_set(void *data, u64 val)
+static int debugfs_u32_set(void *data, u64 val)
 {
 	*(u32 *)data = val;
+	return 0;
 }
-static u64 debugfs_u32_get(void *data)
+static int debugfs_u32_get(void *data, u64 *val)
 {
-	return *(u32 *)data;
+	*val = *(u32 *)data;
+	return 0;
 }
 DEFINE_SIMPLE_ATTRIBUTE(fops_u32, debugfs_u32_get, debugfs_u32_set, "%llu\n");
 
@@ -179,14 +185,16 @@ struct dentry *debugfs_create_u32(const 
 }
 EXPORT_SYMBOL_GPL(debugfs_create_u32);
 
-static void debugfs_u64_set(void *data, u64 val)
+static int debugfs_u64_set(void *data, u64 val)
 {
 	*(u64 *)data = val;
+	return 0;
 }
 
-static u64 debugfs_u64_get(void *data)
+static int debugfs_u64_get(void *data, u64 *val)
 {
-	return *(u64 *)data;
+	*val = *(u64 *)data;
+	return 0;
 }
 DEFINE_SIMPLE_ATTRIBUTE(fops_u64, debugfs_u64_get, debugfs_u64_set, "%llu\n");
 
diff -puN fs/libfs.c~libfs-allow-error-return-from-simple-attributes fs/libfs.c
--- a/fs/libfs.c~libfs-allow-error-return-from-simple-attributes
+++ a/fs/libfs.c
@@ -583,8 +583,8 @@ int simple_transaction_release(struct in
 /* Simple attribute files */
 
 struct simple_attr {
-	u64 (*get)(void *);
-	void (*set)(void *, u64);
+	int (*get)(void *, u64 *);
+	int (*set)(void *, u64);
 	char get_buf[24];	/* enough to store a u64 and "\n\0" */
 	char set_buf[24];
 	void *data;
@@ -595,7 +595,7 @@ struct simple_attr {
 /* simple_attr_open is called by an actual attribute open file operation
  * to set the attribute specific access operations. */
 int simple_attr_open(struct inode *inode, struct file *file,
-		     u64 (*get)(void *), void (*set)(void *, u64),
+		     int (*get)(void *, u64 *), int (*set)(void *, u64),
 		     const char *fmt)
 {
 	struct simple_attr *attr;
@@ -635,14 +635,20 @@ ssize_t simple_attr_read(struct file *fi
 		return -EACCES;
 
 	mutex_lock(&attr->mutex);
-	if (*ppos) /* continued read */
+	if (*ppos) {		/* continued read */
 		size = strlen(attr->get_buf);
-	else	  /* first read */
+	} else {		/* first read */
+		u64 val;
+		ret = attr->get(attr->data, &val);
+		if (ret)
+			goto out;
+
 		size = scnprintf(attr->get_buf, sizeof(attr->get_buf),
-				 attr->fmt,
-				 (unsigned long long)attr->get(attr->data));
+				 attr->fmt, (unsigned long long)val);
+	}
 
 	ret = simple_read_from_buffer(buf, len, ppos, attr->get_buf, size);
+out:
 	mutex_unlock(&attr->mutex);
 	return ret;
 }
@@ -657,7 +663,6 @@ ssize_t simple_attr_write(struct file *f
 	ssize_t ret;
 
 	attr = file->private_data;
-
 	if (!attr->set)
 		return -EACCES;
 
diff -puN include/linux/fs.h~libfs-allow-error-return-from-simple-attributes include/linux/fs.h
--- a/include/linux/fs.h~libfs-allow-error-return-from-simple-attributes
+++ a/include/linux/fs.h
@@ -2070,7 +2070,7 @@ __simple_attr_check_format(const char *f
 }
 
 int simple_attr_open(struct inode *inode, struct file *file,
-		     u64 (*get)(void *), void (*set)(void *, u64),
+		     int (*get)(void *, u64 *), int (*set)(void *, u64),
 		     const char *fmt);
 int simple_attr_close(struct inode *inode, struct file *file);
 ssize_t simple_attr_read(struct file *file, char __user *buf,
diff -puN lib/fault-inject.c~libfs-allow-error-return-from-simple-attributes lib/fault-inject.c
--- a/lib/fault-inject.c~libfs-allow-error-return-from-simple-attributes
+++ a/lib/fault-inject.c
@@ -134,9 +134,10 @@ bool should_fail(struct fault_attr *attr
 
 #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
 
-static void debugfs_ul_set(void *data, u64 val)
+static int debugfs_ul_set(void *data, u64 val)
 {
 	*(unsigned long *)data = val;
+	return 0;
 }
 
 #ifdef CONFIG_FAULT_INJECTION_STACKTRACE_FILTER
@@ -148,9 +149,10 @@ static void debugfs_ul_set_MAX_STACK_TRA
 }
 #endif /* CONFIG_FAULT_INJECTION_STACKTRACE_FILTER */
 
-static u64 debugfs_ul_get(void *data)
+static int debugfs_ul_get(void *data, u64 *val)
 {
-	return *(unsigned long *)data;
+	*val = *(unsigned long *)data;
+	return 0;
 }
 
 DEFINE_SIMPLE_ATTRIBUTE(fops_ul, debugfs_ul_get, debugfs_ul_set, "%llu\n");
@@ -174,14 +176,16 @@ static struct dentry *debugfs_create_ul_
 }
 #endif /* CONFIG_FAULT_INJECTION_STACKTRACE_FILTER */
 
-static void debugfs_atomic_t_set(void *data, u64 val)
+static int debugfs_atomic_t_set(void *data, u64 val)
 {
 	atomic_set((atomic_t *)data, val);
+	return 0;
 }
 
-static u64 debugfs_atomic_t_get(void *data)
+static int debugfs_atomic_t_get(void *data, u64 *val)
 {
-	return atomic_read((atomic_t *)data);
+	*val = atomic_read((atomic_t *)data);
+	return 0;
 }
 
 DEFINE_SIMPLE_ATTRIBUTE(fops_atomic_t, debugfs_atomic_t_get,
diff -puN virt/kvm/kvm_main.c~libfs-allow-error-return-from-simple-attributes virt/kvm/kvm_main.c
--- a/virt/kvm/kvm_main.c~libfs-allow-error-return-from-simple-attributes
+++ a/virt/kvm/kvm_main.c
@@ -1186,38 +1186,38 @@ static struct notifier_block kvm_cpu_not
 	.priority = 20, /* must be > scheduler priority */
 };
 
-static u64 vm_stat_get(void *_offset)
+static int vm_stat_get(void *_offset, u64 *val)
 {
 	unsigned offset = (long)_offset;
-	u64 total = 0;
 	struct kvm *kvm;
 
+	*val = 0;
 	spin_lock(&kvm_lock);
 	list_for_each_entry(kvm, &vm_list, vm_list)
-		total += *(u32 *)((void *)kvm + offset);
+		*val += *(u32 *)((void *)kvm + offset);
 	spin_unlock(&kvm_lock);
-	return total;
+	return 0;
 }
 
 DEFINE_SIMPLE_ATTRIBUTE(vm_stat_fops, vm_stat_get, NULL, "%llu\n");
 
-static u64 vcpu_stat_get(void *_offset)
+static int vcpu_stat_get(void *_offset, u64 *val)
 {
 	unsigned offset = (long)_offset;
-	u64 total = 0;
 	struct kvm *kvm;
 	struct kvm_vcpu *vcpu;
 	int i;
 
+	*val = 0;
 	spin_lock(&kvm_lock);
 	list_for_each_entry(kvm, &vm_list, vm_list)
 		for (i = 0; i < KVM_MAX_VCPUS; ++i) {
 			vcpu = kvm->vcpus[i];
 			if (vcpu)
-				total += *(u32 *)((void *)vcpu + offset);
+				*val += *(u32 *)((void *)vcpu + offset);
 		}
 	spin_unlock(&kvm_lock);
-	return total;
+	return 0;
 }
 
 DEFINE_SIMPLE_ATTRIBUTE(vcpu_stat_fops, vcpu_stat_get, NULL, "%llu\n");
_

Patches currently in -mm which might be from hch@lst.de are

git-powerpc.patch
git-mips.patch
git-netdev-all.patch
pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int.patch
pcmcia-replace-kio_addr_t-with-unsigned-int-everywhere.patch
git-scsi-misc.patch
git-unionfs.patch
vfs-apply-coding-standards-to-fs-ioctlc.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
vfs-factor-out-three-helpers-for-fibmap-fionbio-fioasync-file-ioctls.patch
git-xfs.patch
clean-up-vmtruncate.patch
vfs-security-rework-inode_getsecurity-and-callers-to.patch
vfs-reorder-vfs_getxattr-to-avoid-unnecessary-calls-to-the-lsm.patch
kernel-add-mutex_lock_killable.patch
vfs-use-mutex_lock_killable-in-vfs_readdir.patch
reiserfs-eliminate-private-use-of-struct-file-in-xattr.patch
rename-open_namei-to-open_pathname-fix.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
r-o-bind-mounts-elevate-write-count-opened-files-oops-fix.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
iget-introduce-a-function-to-register-iget-failure.patch
iget-use-iget_failed-in-afs.patch
iget-use-iget_failed-in-gfs2.patch
iget-stop-affs-from-using-iget-and-read_inode-try.patch
iget-stop-autofs-from-using-iget-and-read_inode.patch
iget-stop-befs-from-using-iget-and-read_inode-try.patch
iget-stop-bfs-from-using-iget-and-read_inode-try.patch
iget-stop-cifs-from-using-iget-and-read_inode-try.patch
iget-stop-efs-from-using-iget-and-read_inode-try.patch
iget-stop-ext2-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-ext4-from-using-iget-and-read_inode-try.patch
iget-stop-fat-from-using-iget-and-read_inode-try.patch
iget-stop-freevxfs-from-using-iget-and-read_inode.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-fix.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-fuse-from-using-iget-and-read_inode-try.patch
iget-stop-hfsplus-from-using-iget-and-read_inode.patch
iget-stop-isofs-from-using-read_inode.patch
iget-stop-isofs-from-using-read_inode-fix-2.patch
iget-stop-jffs2-from-using-iget-and-read_inode.patch
iget-stop-jfs-from-using-iget-and-read_inode-try.patch
iget-stop-the-minix-filesystem-from-using-iget-and.patch
iget-stop-procfs-from-using-iget-and-read_inode.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try.patch
iget-stop-romfs-from-using-iget-and-read_inode.patch
iget-stop-the-sysv-filesystem-from-using-iget-and.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try.patch
iget-stop-openpromfs-from-using-iget-and.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hppfs-from-using-iget-and-read_inode.patch
iget-remove-iget-and-the-read_inode-super-op-as.patch
dont-touch-fs_struct-in-drivers.patch
dont-touch-fs_struct-in-usermodehelper.patch
remove-path_release_on_umount.patch
move-struct-path-into-its-own-header.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch
introduce-path_put.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
introduce-path_get.patch
use-struct-path-in-fs_struct.patch
make-set_fs_rootpwd-take-a-struct-path.patch
introduce-path_get-unionfs.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs.patch
introduce-path_put-unionfs.patch
use-struct-path-in-struct-svc_expkey.patch
d_path-make-seq_path-use-a-struct-path-argument.patch
kill-pt_attached.patch
kill-my_ptrace_child.patch
ptrace_check_attach-remove-unneeded-signal-=-null-check.patch
ext2-remove-unused-ext2_put_inode-prototype.patch
libfs-allow-error-return-from-simple-attributes.patch
libfs-make-simple-attributes-interruptible.patch
libfs-rename-simple_attr_close-to-simple_attr_release.patch
