From: akpm@linux-foundation.org
Subject: + powerpc-assign-pde-data-before-gluing-pde-into-proc-tree.patch added to -mm tree
Date: Tue, 29 Apr 2008 12:45:15 -0700
Message-ID: <200804291945.m3TJjFek006421@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34738 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755870AbYD2Tp1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 15:45:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: den@openvz.org, adobriyan@openvz.org, benh@kernel.crashing.org, ebiederm@xmission.com, paulus@au.ibm.com


The patch titled
     powerpc: assign PDE->data before gluing PDE into /proc tree
has been added to the -mm tree.  Its filename is
     powerpc-assign-pde-data-before-gluing-pde-into-proc-tree.patch

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
Subject: powerpc: assign PDE->data before gluing PDE into /proc tree
From: "Denis V. Lunev" <den@openvz.org>

Simply replace proc_create and further data assigned with proc_create_data. 
No need to check for data!=NULL after that.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Paul Mackerras <paulus@au.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/pseries/scanlog.c |   19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff -puN arch/powerpc/platforms/pseries/scanlog.c~powerpc-assign-pde-data-before-gluing-pde-into-proc-tree arch/powerpc/platforms/pseries/scanlog.c
--- a/arch/powerpc/platforms/pseries/scanlog.c~powerpc-assign-pde-data-before-gluing-pde-into-proc-tree
+++ a/arch/powerpc/platforms/pseries/scanlog.c
@@ -55,11 +55,6 @@ static ssize_t scanlog_read(struct file 
         dp = PDE(inode);
  	data = (unsigned int *)dp->data;
 
-	if (!data) {
-		printk(KERN_ERR "scanlog: read failed no data\n");
-		return -EIO;
-	}
-
 	if (count > RTAS_DATA_BUF_SIZE)
 		count = RTAS_DATA_BUF_SIZE;
 
@@ -146,11 +141,6 @@ static int scanlog_open(struct inode * i
 	struct proc_dir_entry *dp = PDE(inode);
 	unsigned int *data = (unsigned int *)dp->data;
 
-	if (!data) {
-		printk(KERN_ERR "scanlog: open failed no data\n");
-		return -EIO;
-	}
-
 	if (data[0] != 0) {
 		/* This imperfect test stops a second copy of the
 		 * data (or a reset while data is being copied)
@@ -168,10 +158,6 @@ static int scanlog_release(struct inode 
 	struct proc_dir_entry *dp = PDE(inode);
 	unsigned int *data = (unsigned int *)dp->data;
 
-	if (!data) {
-		printk(KERN_ERR "scanlog: release failed no data\n");
-		return -EIO;
-	}
 	data[0] = 0;
 
 	return 0;
@@ -200,12 +186,11 @@ static int __init scanlog_init(void)
 	if (!data)
 		goto err;
 
-	ent = proc_create("ppc64/rtas/scan-log-dump", S_IRUSR, NULL,
-			  &scanlog_fops);
+	ent = proc_create_data("ppc64/rtas/scan-log-dump", S_IRUSR, NULL,
+			       &scanlog_fops, data);
 	if (!ent)
 		goto err;
 
-	ent->data = data;
 	proc_ppc64_scan_log_dump = ent;
 
 	return 0;
_

Patches currently in -mm which might be from den@openvz.org are

origin.patch
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
drivers-use-non-racy-method-for-proc-entries-creation-2-rio.patch
sunrpc-assign-pde-data-before-gluing-pde-into-proc-tree.patch
netfilter-assign-pde-data-before-gluing-pde-into-proc-tree.patch
net-assign-pde-data-before-gluing-pde-into-proc-tree.patch
ipv6-assign-pde-data-before-gluing-pde-into-proc-tree.patch
atm-assign-pde-data-before-gluing-pde-into-proc-tree.patch
vlan-assign-pde-data-before-gluing-pde-into-proc-tree.patch
cciss-assign-pde-data-before-gluing-pde-into-proc-tree.patch
powerpc-assign-pde-data-before-gluing-pde-into-proc-tree.patch
ipv4-assign-pde-data-before-gluing-pde-into-proc-tree.patch
netfilter-assign-pde-fops-before-gluing-pde-into-proc-tree.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch

