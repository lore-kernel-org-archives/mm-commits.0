From: akpm@linux-foundation.org
Subject: + cleanup-compat-ioctl-handling.patch added to -mm tree
Date: Tue, 10 Apr 2007 15:06:55 -0700
Message-ID: <200704102206.l3AM6tBh018826@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48756 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753961AbXDJWHL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 18:07:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, ak@suse.de, arnd@arndb.de


The patch titled
     cleanup compat ioctl handling
has been added to the -mm tree.  Its filename is
     cleanup-compat-ioctl-handling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cleanup compat ioctl handling
From: Christoph Hellwig <hch@lst.de>

Merge all compat ioctl handling into compat_ioctl.c instead of splitting it
over compat.c and compat_ioctl.c.  This also allows to get rid of ioctl32.h

Signed-off-by: Christoph Hellwig <hch@lst.de>
Looks-good-to: Andi Kleen <ak@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat.c             |  161 ------------------------------------
 fs/compat_ioctl.c       |  169 ++++++++++++++++++++++++++++++++++++--
 fs/internal.h           |   10 --
 include/linux/ioctl32.h |   17 ---
 include/net/sock.h      |    9 --
 5 files changed, 165 insertions(+), 201 deletions(-)

diff -puN fs/compat.c~cleanup-compat-ioctl-handling fs/compat.c
--- a/fs/compat.c~cleanup-compat-ioctl-handling
+++ a/fs/compat.c
@@ -25,10 +25,8 @@
 #include <linux/namei.h>
 #include <linux/file.h>
 #include <linux/vfs.h>
-#include <linux/ioctl32.h>
 #include <linux/ioctl.h>
 #include <linux/init.h>
-#include <linux/sockios.h>	/* for SIOCDEVPRIVATE */
 #include <linux/smb.h>
 #include <linux/smb_mount.h>
 #include <linux/ncp_mount.h>
@@ -46,13 +44,12 @@
 #include <linux/personality.h>
 #include <linux/rwsem.h>
 #include <linux/tsacct_kern.h>
+#include <linux/security.h>
 #include <linux/highmem.h>
 #include <linux/poll.h>
 #include <linux/mm.h>
 #include <linux/eventpoll.h>
 
-#include <net/sock.h>		/* siocdevprivate_ioctl */
-
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
 #include <asm/ioctls.h>
@@ -313,162 +310,6 @@ out:
 	return error;
 }
 
-/* ioctl32 stuff, used by sparc64, parisc, s390x, ppc64, x86_64, MIPS */
-
-#define IOCTL_HASHSIZE 256
-static struct ioctl_trans *ioctl32_hash_table[IOCTL_HASHSIZE];
-
-static inline unsigned long ioctl32_hash(unsigned long cmd)
-{
-	return (((cmd >> 6) ^ (cmd >> 4) ^ cmd)) % IOCTL_HASHSIZE;
-}
-
-static void ioctl32_insert_translation(struct ioctl_trans *trans)
-{
-	unsigned long hash;
-	struct ioctl_trans *t;
-
-	hash = ioctl32_hash (trans->cmd);
-	if (!ioctl32_hash_table[hash])
-		ioctl32_hash_table[hash] = trans;
-	else {
-		t = ioctl32_hash_table[hash];
-		while (t->next)
-			t = t->next;
-		trans->next = NULL;
-		t->next = trans;
-	}
-}
-
-static int __init init_sys32_ioctl(void)
-{
-	int i;
-
-	for (i = 0; i < ioctl_table_size; i++) {
-		if (ioctl_start[i].next != 0) { 
-			printk("ioctl translation %d bad\n",i); 
-			return -1;
-		}
-
-		ioctl32_insert_translation(&ioctl_start[i]);
-	}
-	return 0;
-}
-
-__initcall(init_sys32_ioctl);
-
-static void compat_ioctl_error(struct file *filp, unsigned int fd,
-		unsigned int cmd, unsigned long arg)
-{
-	char buf[10];
-	char *fn = "?";
-	char *path;
-
-	/* find the name of the device. */
-	path = (char *)__get_free_page(GFP_KERNEL);
-	if (path) {
-		fn = d_path(filp->f_path.dentry, filp->f_path.mnt, path, PAGE_SIZE);
-		if (IS_ERR(fn))
-			fn = "?";
-	}
-
-	sprintf(buf,"'%c'", (cmd>>24) & 0x3f);
-	if (!isprint(buf[1]))
-		sprintf(buf, "%02x", buf[1]);
-	compat_printk("ioctl32(%s:%d): Unknown cmd fd(%d) "
-			"cmd(%08x){%s} arg(%08x) on %s\n",
-			current->comm, current->pid,
-			(int)fd, (unsigned int)cmd, buf,
-			(unsigned int)arg, fn);
-
-	if (path)
-		free_page((unsigned long)path);
-}
-
-asmlinkage long compat_sys_ioctl(unsigned int fd, unsigned int cmd,
-				unsigned long arg)
-{
-	struct file *filp;
-	int error = -EBADF;
-	struct ioctl_trans *t;
-	int fput_needed;
-
-	filp = fget_light(fd, &fput_needed);
-	if (!filp)
-		goto out;
-
-	/* RED-PEN how should LSM module know it's handling 32bit? */
-	error = security_file_ioctl(filp, cmd, arg);
-	if (error)
-		goto out_fput;
-
-	/*
-	 * To allow the compat_ioctl handlers to be self contained
-	 * we need to check the common ioctls here first.
-	 * Just handle them with the standard handlers below.
-	 */
-	switch (cmd) {
-	case FIOCLEX:
-	case FIONCLEX:
-	case FIONBIO:
-	case FIOASYNC:
-	case FIOQSIZE:
-		break;
-
-	case FIBMAP:
-	case FIGETBSZ:
-	case FIONREAD:
-		if (S_ISREG(filp->f_path.dentry->d_inode->i_mode))
-			break;
-		/*FALL THROUGH*/
-
-	default:
-		if (filp->f_op && filp->f_op->compat_ioctl) {
-			error = filp->f_op->compat_ioctl(filp, cmd, arg);
-			if (error != -ENOIOCTLCMD)
-				goto out_fput;
-		}
-
-		if (!filp->f_op ||
-		    (!filp->f_op->ioctl && !filp->f_op->unlocked_ioctl))
-			goto do_ioctl;
-		break;
-	}
-
-	for (t = ioctl32_hash_table[ioctl32_hash(cmd)]; t; t = t->next) {
-		if (t->cmd == cmd)
-			goto found_handler;
-	}
-
-	if (S_ISSOCK(filp->f_path.dentry->d_inode->i_mode) &&
-	    cmd >= SIOCDEVPRIVATE && cmd <= (SIOCDEVPRIVATE + 15)) {
-		error = siocdevprivate_ioctl(fd, cmd, arg);
-	} else {
-		static int count;
-
-		if (++count <= 50)
-			compat_ioctl_error(filp, fd, cmd, arg);
-		error = -EINVAL;
-	}
-
-	goto out_fput;
-
- found_handler:
-	if (t->handler) {
-		lock_kernel();
-		error = t->handler(fd, cmd, arg, filp);
-		unlock_kernel();
-		goto out_fput;
-	}
-
- do_ioctl:
-	error = vfs_ioctl(filp, fd, cmd, arg);
- out_fput:
-	fput_light(filp, fput_needed);
- out:
-	return error;
-}
-
 static int get_compat_flock(struct flock *kfl, struct compat_flock __user *ufl)
 {
 	if (!access_ok(VERIFY_READ, ufl, sizeof(*ufl)) ||
diff -puN fs/compat_ioctl.c~cleanup-compat-ioctl-handling fs/compat_ioctl.c
--- a/fs/compat_ioctl.c~cleanup-compat-ioctl-handling
+++ a/fs/compat_ioctl.c
@@ -57,7 +57,6 @@
 #include <linux/serial.h>
 #include <linux/if_tun.h>
 #include <linux/ctype.h>
-#include <linux/ioctl32.h>
 #include <linux/syscalls.h>
 #include <linux/i2c.h>
 #include <linux/i2c-dev.h>
@@ -65,7 +64,6 @@
 #include <linux/atalk.h>
 #include <linux/blktrace_api.h>
 
-#include <net/sock.h>          /* siocdevprivate_ioctl */
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci.h>
 #include <net/bluetooth/rfcomm.h>
@@ -474,7 +472,7 @@ static int bond_ioctl(unsigned int fd, u
 	};
 }
 
-int siocdevprivate_ioctl(unsigned int fd, unsigned int cmd, unsigned long arg)
+static int siocdevprivate_ioctl(unsigned int fd, unsigned int cmd, unsigned long arg)
 {
 	struct ifreq __user *u_ifreq64;
 	struct ifreq32 __user *u_ifreq32 = compat_ptr(arg);
@@ -2384,6 +2382,16 @@ lp_timeout_trans(unsigned int fd, unsign
 	return sys_ioctl(fd, cmd, (unsigned long)tn);
 }
 
+
+typedef int (*ioctl_trans_handler_t)(unsigned int, unsigned int,
+					unsigned long, struct file *);
+
+struct ioctl_trans {
+	unsigned long cmd;
+	ioctl_trans_handler_t handler;
+	struct ioctl_trans *next;
+};
+
 #define HANDLE_IOCTL(cmd,handler) \
 	{ (cmd), (ioctl_trans_handler_t)(handler) },
 
@@ -2396,7 +2404,7 @@ lp_timeout_trans(unsigned int fd, unsign
 	{ (cmd), (ioctl_trans_handler_t)sys_ioctl },
 
 
-struct ioctl_trans ioctl_start[] = {
+static struct ioctl_trans ioctl_start[] = {
 /* compatible ioctls first */
 COMPATIBLE_IOCTL(0x4B50)   /* KDGHWCLK - not in the kernel, but don't complain */
 COMPATIBLE_IOCTL(0x4B51)   /* KDSHWCLK - not in the kernel, but don't complain */
@@ -3445,4 +3453,155 @@ COMPATIBLE_IOCTL(LPGETFLAGS)
 HANDLE_IOCTL(LPSETTIMEOUT, lp_timeout_trans)
 };
 
-int ioctl_table_size = ARRAY_SIZE(ioctl_start);
+#define IOCTL_HASHSIZE 256
+static struct ioctl_trans *ioctl32_hash_table[IOCTL_HASHSIZE];
+
+static inline unsigned long ioctl32_hash(unsigned long cmd)
+{
+	return (((cmd >> 6) ^ (cmd >> 4) ^ cmd)) % IOCTL_HASHSIZE;
+}
+
+static void compat_ioctl_error(struct file *filp, unsigned int fd,
+		unsigned int cmd, unsigned long arg)
+{
+	char buf[10];
+	char *fn = "?";
+	char *path;
+
+	/* find the name of the device. */
+	path = (char *)__get_free_page(GFP_KERNEL);
+	if (path) {
+		fn = d_path(filp->f_path.dentry, filp->f_path.mnt, path, PAGE_SIZE);
+		if (IS_ERR(fn))
+			fn = "?";
+	}
+
+	sprintf(buf,"'%c'", (cmd>>24) & 0x3f);
+	if (!isprint(buf[1]))
+		sprintf(buf, "%02x", buf[1]);
+	compat_printk("ioctl32(%s:%d): Unknown cmd fd(%d) "
+			"cmd(%08x){%s} arg(%08x) on %s\n",
+			current->comm, current->pid,
+			(int)fd, (unsigned int)cmd, buf,
+			(unsigned int)arg, fn);
+
+	if (path)
+		free_page((unsigned long)path);
+}
+
+asmlinkage long compat_sys_ioctl(unsigned int fd, unsigned int cmd,
+				unsigned long arg)
+{
+	struct file *filp;
+	int error = -EBADF;
+	struct ioctl_trans *t;
+	int fput_needed;
+
+	filp = fget_light(fd, &fput_needed);
+	if (!filp)
+		goto out;
+
+	/* RED-PEN how should LSM module know it's handling 32bit? */
+	error = security_file_ioctl(filp, cmd, arg);
+	if (error)
+		goto out_fput;
+
+	/*
+	 * To allow the compat_ioctl handlers to be self contained
+	 * we need to check the common ioctls here first.
+	 * Just handle them with the standard handlers below.
+	 */
+	switch (cmd) {
+	case FIOCLEX:
+	case FIONCLEX:
+	case FIONBIO:
+	case FIOASYNC:
+	case FIOQSIZE:
+		break;
+
+	case FIBMAP:
+	case FIGETBSZ:
+	case FIONREAD:
+		if (S_ISREG(filp->f_path.dentry->d_inode->i_mode))
+			break;
+		/*FALL THROUGH*/
+
+	default:
+		if (filp->f_op && filp->f_op->compat_ioctl) {
+			error = filp->f_op->compat_ioctl(filp, cmd, arg);
+			if (error != -ENOIOCTLCMD)
+				goto out_fput;
+		}
+
+		if (!filp->f_op ||
+		    (!filp->f_op->ioctl && !filp->f_op->unlocked_ioctl))
+			goto do_ioctl;
+		break;
+	}
+
+	for (t = ioctl32_hash_table[ioctl32_hash(cmd)]; t; t = t->next) {
+		if (t->cmd == cmd)
+			goto found_handler;
+	}
+
+	if (S_ISSOCK(filp->f_path.dentry->d_inode->i_mode) &&
+	    cmd >= SIOCDEVPRIVATE && cmd <= (SIOCDEVPRIVATE + 15)) {
+		error = siocdevprivate_ioctl(fd, cmd, arg);
+	} else {
+		static int count;
+
+		if (++count <= 50)
+			compat_ioctl_error(filp, fd, cmd, arg);
+		error = -EINVAL;
+	}
+
+	goto out_fput;
+
+ found_handler:
+	if (t->handler) {
+		lock_kernel();
+		error = t->handler(fd, cmd, arg, filp);
+		unlock_kernel();
+		goto out_fput;
+	}
+
+ do_ioctl:
+	error = vfs_ioctl(filp, fd, cmd, arg);
+ out_fput:
+	fput_light(filp, fput_needed);
+ out:
+	return error;
+}
+
+static void ioctl32_insert_translation(struct ioctl_trans *trans)
+{
+	unsigned long hash;
+	struct ioctl_trans *t;
+
+	hash = ioctl32_hash (trans->cmd);
+	if (!ioctl32_hash_table[hash])
+		ioctl32_hash_table[hash] = trans;
+	else {
+		t = ioctl32_hash_table[hash];
+		while (t->next)
+			t = t->next;
+		trans->next = NULL;
+		t->next = trans;
+	}
+}
+
+static int __init init_sys32_ioctl(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ioctl_start); i++) {
+		if (ioctl_start[i].next != 0) {
+			printk("ioctl translation %d bad\n",i);
+			return -1;
+		}
+
+		ioctl32_insert_translation(&ioctl_start[i]);
+	}
+	return 0;
+}
+__initcall(init_sys32_ioctl);
diff -puN fs/internal.h~cleanup-compat-ioctl-handling fs/internal.h
--- a/fs/internal.h~cleanup-compat-ioctl-handling
+++ a/fs/internal.h
@@ -9,8 +9,6 @@
  * 2 of the License, or (at your option) any later version.
  */
 
-#include <linux/ioctl32.h>
-
 struct super_block;
 
 /*
@@ -42,14 +40,6 @@ static inline int sb_is_blkdev_sb(struct
 extern void __init chrdev_init(void);
 
 /*
- * compat_ioctl.c
- */
-#ifdef CONFIG_COMPAT
-extern struct ioctl_trans ioctl_start[];
-extern int ioctl_table_size;
-#endif
-
-/*
  * namespace.c
  */
 extern int copy_mount_options(const void __user *, unsigned long *);
diff -puN include/linux/ioctl32.h~cleanup-compat-ioctl-handling /dev/null
--- a/include/linux/ioctl32.h
+++ /dev/null
@@ -1,17 +0,0 @@
-#ifndef IOCTL32_H
-#define IOCTL32_H 1
-
-#include <linux/compiler.h>	/* for __deprecated */
-
-struct file;
-
-typedef int (*ioctl_trans_handler_t)(unsigned int, unsigned int,
-					unsigned long, struct file *);
-
-struct ioctl_trans {
-	unsigned long cmd;
-	ioctl_trans_handler_t handler;
-	struct ioctl_trans *next;
-};
-
-#endif
diff -puN include/net/sock.h~cleanup-compat-ioctl-handling include/net/sock.h
--- a/include/net/sock.h~cleanup-compat-ioctl-handling
+++ a/include/net/sock.h
@@ -1373,15 +1373,6 @@ static inline void sock_valbool_flag(str
 extern __u32 sysctl_wmem_max;
 extern __u32 sysctl_rmem_max;
 
-#ifdef CONFIG_NET
-int siocdevprivate_ioctl(unsigned int fd, unsigned int cmd, unsigned long arg);
-#else
-static inline int siocdevprivate_ioctl(unsigned int fd, unsigned int cmd, unsigned long arg)
-{
-	return -ENODEV;
-}
-#endif
-
 extern void sk_init(void);
 
 #ifdef CONFIG_SYSCTL
_

Patches currently in -mm which might be from hch@lst.de are

git-cifs.patch
git-ocfs2.patch
mm-move-common-segment-checks-to-separate-helper-function-v7.patch
mm-move-common-segment-checks-to-separate-helper-function-v7-tidy.patch
simplify-the-stacktrace-code.patch
allow-access-to-proc-pid-fd-after-setuid.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
freevxfs-possible-null-pointer-dereference-fix.patch
vfs-remove-superflous-sb-==-null-checks.patch
nameic-remove-utterly-outdated-comment.patch
move-die-notifier-handling-to-common-code.patch
move-die-notifier-handling-to-common-code-fixes.patch
move-die-notifier-handling-to-common-code-fixes-2.patch
move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all.patch
move-die-notifier-handling-to-common-code-fix.patch
remove-do_sync_file_range.patch
remove-artificial-software-max_loop-limit.patch
merge-compat_ioctlh-into-compat_ioctlc.patch
cleanup-compat-ioctl-handling.patch
make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
change-libfs-sb-creation-routines-to-avoid-collisions-with-their-root-inodes.patch
aio-is-unlikely.patch
kprobes-use-hlist_for_each_entry.patch
kprobes-codingstyle-cleanups.patch
kprobes-kretprobes-simplifcations.patch
revoke-special-mmap-handling.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
ps3fb-thread-updates.patch
ps3av-thread-updates.patch
ps3fb-kill-superfluous-zero-initializations.patch
ps3av-misc-updates.patch
