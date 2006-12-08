From: akpm@osdl.org
Subject: - i386-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:01:58 -0800
Message-ID: <200612082001.kB8K1wGk001933@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56934 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426220AbWLHUB7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:01:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     i386: change uses of f_{dentry, vfsmnt} to use f_path
has been removed from the -mm tree.  Its filename was
     i386-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: change uses of f_{dentry, vfsmnt} to use f_path
From: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>

Change all the uses of f_{dentry,vfsmnt} to f_path.{dentry,mnt} in the i386
arch code.

Signed-off-by: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/cpuid.c |    4 ++--
 arch/i386/kernel/msr.c   |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN arch/i386/kernel/cpuid.c~i386-change-uses-of-f_dentry-vfsmnt-to-use-f_path arch/i386/kernel/cpuid.c
--- a/arch/i386/kernel/cpuid.c~i386-change-uses-of-f_dentry-vfsmnt-to-use-f_path
+++ a/arch/i386/kernel/cpuid.c
@@ -116,7 +116,7 @@ static ssize_t cpuid_read(struct file *f
 	char __user *tmp = buf;
 	u32 data[4];
 	u32 reg = *ppos;
-	int cpu = iminor(file->f_dentry->d_inode);
+	int cpu = iminor(file->f_path.dentry->d_inode);
 
 	if (count % 16)
 		return -EINVAL;	/* Invalid chunk size */
@@ -134,7 +134,7 @@ static ssize_t cpuid_read(struct file *f
 
 static int cpuid_open(struct inode *inode, struct file *file)
 {
-	unsigned int cpu = iminor(file->f_dentry->d_inode);
+	unsigned int cpu = iminor(file->f_path.dentry->d_inode);
 	struct cpuinfo_x86 *c = &(cpu_data)[cpu];
 
 	if (cpu >= NR_CPUS || !cpu_online(cpu))
diff -puN arch/i386/kernel/msr.c~i386-change-uses-of-f_dentry-vfsmnt-to-use-f_path arch/i386/kernel/msr.c
--- a/arch/i386/kernel/msr.c~i386-change-uses-of-f_dentry-vfsmnt-to-use-f_path
+++ a/arch/i386/kernel/msr.c
@@ -172,7 +172,7 @@ static ssize_t msr_read(struct file *fil
 	u32 __user *tmp = (u32 __user *) buf;
 	u32 data[2];
 	u32 reg = *ppos;
-	int cpu = iminor(file->f_dentry->d_inode);
+	int cpu = iminor(file->f_path.dentry->d_inode);
 	int err;
 
 	if (count % 8)
@@ -196,7 +196,7 @@ static ssize_t msr_write(struct file *fi
 	const u32 __user *tmp = (const u32 __user *)buf;
 	u32 data[2];
 	u32 reg = *ppos;
-	int cpu = iminor(file->f_dentry->d_inode);
+	int cpu = iminor(file->f_path.dentry->d_inode);
 	int err;
 
 	if (count % 8)
@@ -216,7 +216,7 @@ static ssize_t msr_write(struct file *fi
 
 static int msr_open(struct inode *inode, struct file *file)
 {
-	unsigned int cpu = iminor(file->f_dentry->d_inode);
+	unsigned int cpu = iminor(file->f_path.dentry->d_inode);
 	struct cpuinfo_x86 *c = &(cpu_data)[cpu];
 
 	if (cpu >= NR_CPUS || !cpu_online(cpu))
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

i386-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
x86_64-change-uses-of-f_dentry.patch
kernel-change-uses-of-f_dentry.patch
mm-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch
9p-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch
affs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
autofs-change-uses-of-f_dentry.patch
autofs4-change-uses-of-f_dentry.patch
configfs-change-uses-of-f_dentry.patch
cifs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
ecryptfs-change-uses-of-f_dentry.patch
xfs-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch

