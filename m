From: akpm@linux-foundation.org
Subject: + nfs-use-proc_create-to-setup-de-proc_fops.patch added to -mm tree
Date: Tue, 15 Apr 2008 16:55:59 -0700
Message-ID: <200804152355.m3FNtx9A022488@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57620 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753120AbYDOX4V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 19:56:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: den@openvz.org, adobriyan@gmail.com, bfields@fieldses.org, ebiederm@xmission.com, trond.myklebust@fys.uio.no


The patch titled
     nfs: use proc_create to setup de->proc_fops
has been added to the -mm tree.  Its filename is
     nfs-use-proc_create-to-setup-de-proc_fops.patch

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
Subject: nfs: use proc_create to setup de->proc_fops
From: "Denis V. Lunev" <den@openvz.org>

Use proc_create() to make sure that ->proc_fops be setup before gluing PDE to
main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/client.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN fs/nfs/client.c~nfs-use-proc_create-to-setup-de-proc_fops fs/nfs/client.c
--- a/fs/nfs/client.c~nfs-use-proc_create-to-setup-de-proc_fops
+++ a/fs/nfs/client.c
@@ -1314,6 +1314,7 @@ static const struct file_operations nfs_
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= seq_release,
+	.owner		= THIS_MODULE,
 };
 
 static int nfs_volume_list_open(struct inode *inode, struct file *file);
@@ -1334,6 +1335,7 @@ static const struct file_operations nfs_
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= seq_release,
+	.owner		= THIS_MODULE,
 };
 
 /*
@@ -1500,20 +1502,16 @@ int __init nfs_fs_proc_init(void)
 	proc_fs_nfs->owner = THIS_MODULE;
 
 	/* a file of servers with which we're dealing */
-	p = create_proc_entry("servers", S_IFREG|S_IRUGO, proc_fs_nfs);
+	p = proc_create("servers", S_IFREG|S_IRUGO,
+			proc_fs_nfs, &nfs_server_list_fops);
 	if (!p)
 		goto error_1;
 
-	p->proc_fops = &nfs_server_list_fops;
-	p->owner = THIS_MODULE;
-
 	/* a file of volumes that we have mounted */
-	p = create_proc_entry("volumes", S_IFREG|S_IRUGO, proc_fs_nfs);
+	p = proc_create("volumes", S_IFREG|S_IRUGO,
+			proc_fs_nfs, &nfs_volume_list_fops);
 	if (!p)
 		goto error_2;
-
-	p->proc_fops = &nfs_volume_list_fops;
-	p->owner = THIS_MODULE;
 	return 0;
 
 error_2:
_

Patches currently in -mm which might be from den@openvz.org are

git-net.patch
proc-introduce-proc_create_data-to-setup-de-data.patch
nfsd-use-proc_create-to-setup-de-proc_fops.patch
nfs-use-proc_create-to-setup-de-proc_fops.patch
afs-use-non-racy-method-for-proc-entries-creation.patch
ext4-use-non-racy-method-for-proc-entries-creation.patch
reiserfs-use-non-racy-method-for-proc-entries-creation.patch
jbd2-use-non-racy-method-for-proc-entries-creation.patch
sysvipc-use-non-racy-method-for-proc-entries-creation.patch
mm-use-non-racy-method-for-proc-swaps-creation.patch
sound-use-non-racy-method-for-proc-driver-snd-page-alloc-creation.patch
zorro-use-non-racy-method-for-proc-entries-creation.patch
samples-use-non-racy-method-for-proc-marker-example-creation.patch
scsi-use-non-racy-method-for-proc-entries-creation.patch
usb-use-non-racy-method-for-proc-entries-creation.patch
s390-use-non-racy-method-for-proc-entries-creation.patch
arm-use-non-racy-method-for-proc-davinci_clocks-creation.patch
avr32-proc-use-non-racy-method-for-proc-tlb-creation.patch
cris-use-non-racy-method-for-proc-system_profile-creation.patch
ia64-use-non-racy-method-for-proc-entries-creation.patch
parisc-use-non-racy-method-for-proc-pcxl_dma-creation.patch
powerpc-use-non-racy-method-for-proc-entries-creation.patch
acpi-use-non-racy-method-for-proc-entries-creation.patch
netdev-use-non-racy-method-for-proc-entries-creation.patch
isdn-use-non-racy-method-for-proc-entries-creation.patch
kernel-use-non-racy-method-for-proc-entries-creation.patch
parisc-use-non-racy-method-for-proc-entries-creation.patch
drivers-use-non-racy-method-for-proc-entries-creation.patch
drivers-use-non-racy-method-for-proc-entries-creation-2.patch
sysctl-merge-equal-proc_sys_read-and-proc_sys_write.patch
sysctl-clean-from-unneeded-extern-and-forward-declarations.patch
sysctl-add-the-permissions-callback-on-the-ctl_table_root.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch

