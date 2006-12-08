From: akpm@osdl.org
Subject: - struct-path-convert-netfilter.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:04:22 -0800
Message-ID: <200612082004.kB8K4MOY002175@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57299 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426260AbWLHUE0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:04:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert netfilter
has been removed from the -mm tree.  Its filename was
     struct-path-convert-netfilter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert netfilter
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 net/ipv4/netfilter/ipt_CLUSTERIP.c |    2 +-
 net/ipv4/netfilter/ipt_recent.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN net/ipv4/netfilter/ipt_CLUSTERIP.c~struct-path-convert-netfilter net/ipv4/netfilter/ipt_CLUSTERIP.c
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c~struct-path-convert-netfilter
+++ a/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -683,7 +683,7 @@ static ssize_t clusterip_proc_write(stru
 {
 #define PROC_WRITELEN	10
 	char buffer[PROC_WRITELEN+1];
-	struct proc_dir_entry *pde = PDE(file->f_dentry->d_inode);
+	struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
 	struct clusterip_config *c = pde->data;
 	unsigned long nodenum;
 
diff -puN net/ipv4/netfilter/ipt_recent.c~struct-path-convert-netfilter net/ipv4/netfilter/ipt_recent.c
--- a/net/ipv4/netfilter/ipt_recent.c~struct-path-convert-netfilter
+++ a/net/ipv4/netfilter/ipt_recent.c
@@ -401,7 +401,7 @@ static int recent_seq_open(struct inode 
 static ssize_t recent_proc_write(struct file *file, const char __user *input,
 				 size_t size, loff_t *loff)
 {
-	struct proc_dir_entry *pde = PDE(file->f_dentry->d_inode);
+	struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
 	struct recent_table *t = pde->data;
 	struct recent_entry *e;
 	char buf[sizeof("+255.255.255.255")], *c = buf;
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

struct-path-convert-netfilter.patch
struct-path-convert-netlink.patch
struct-path-convert-ocfs2.patch
struct-path-convert-openpromfs.patch
struct-path-convert-oprofile.patch
struct-path-convert-parisc.patch
struct-path-convert-pci.patch
struct-path-convert-pcmcia.patch
struct-path-convert-powerpc.patch
struct-path-convert-ppc.patch
struct-path-convert-qnx4.patch
struct-path-convert-ramfs.patch
struct-path-convert-reiserfs.patch
struct-path-convert-romfs.patch
struct-path-convert-s390-drivers.patch
struct-path-convert-s390.patch
struct-path-convert-sbus.patch
struct-path-convert-scsi.patch
struct-path-convert-selinux.patch
struct-path-convert-sh.patch
struct-path-convert-smbfs.patch
struct-path-convert-sound.patch
struct-path-convert-sparc.patch
struct-path-convert-sparc64.patch
struct-path-convert-sunrpc.patch
struct-path-convert-sysv.patch
struct-path-convert-udf.patch
struct-path-convert-ufs.patch
struct-path-convert-unix.patch
struct-path-convert-usb.patch
struct-path-convert-v4l.patch
struct-path-convert-video.patch
struct-path-convert-zorro.patch

