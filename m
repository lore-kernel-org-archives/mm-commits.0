From: akpm@linux-foundation.org
Subject: + usb-use-non-racy-method-for-proc-entries-creation.patch added to -mm tree
Date: Tue, 15 Apr 2008 16:56:21 -0700
Message-ID: <200804152356.m3FNuL3e022528@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59895 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753270AbYDOX42 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 19:56:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: den@openvz.org, adobriyan@gmail.com, ebiederm@xmission.com, gregkh@suse.de


The patch titled
     usb: use non-racy method for proc entries creation
has been added to the -mm tree.  Its filename is
     usb-use-non-racy-method-for-proc-entries-creation.patch

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
Subject: usb: use non-racy method for proc entries creation
From: "Denis V. Lunev" <den@openvz.org>

Use proc_create()/proc_create_data() to make sure that ->proc_fops and ->data
be setup before gluing PDE to main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/at91_udc.c |   11 ++---------
 drivers/usb/gadget/omap_udc.c |    7 ++-----
 drivers/usb/host/sl811-hcd.c  |   10 +---------
 3 files changed, 5 insertions(+), 23 deletions(-)

diff -puN drivers/usb/gadget/at91_udc.c~usb-use-non-racy-method-for-proc-entries-creation drivers/usb/gadget/at91_udc.c
--- a/drivers/usb/gadget/at91_udc.c~usb-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/usb/gadget/at91_udc.c
@@ -231,6 +231,7 @@ static int proc_udc_open(struct inode *i
 }
 
 static const struct file_operations proc_ops = {
+	.owner		= THIS_MODULE,
 	.open		= proc_udc_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -239,15 +240,7 @@ static const struct file_operations proc
 
 static void create_debug_file(struct at91_udc *udc)
 {
-	struct proc_dir_entry *pde;
-
-	pde = create_proc_entry (debug_filename, 0, NULL);
-	udc->pde = pde;
-	if (pde == NULL)
-		return;
-
-	pde->proc_fops = &proc_ops;
-	pde->data = udc;
+	udc->pde = proc_create_data(debug_filename, 0, NULL, &proc_ops, udc);
 }
 
 static void remove_debug_file(struct at91_udc *udc)
diff -puN drivers/usb/gadget/omap_udc.c~usb-use-non-racy-method-for-proc-entries-creation drivers/usb/gadget/omap_udc.c
--- a/drivers/usb/gadget/omap_udc.c~usb-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/usb/gadget/omap_udc.c
@@ -2504,6 +2504,7 @@ static int proc_udc_open(struct inode *i
 }
 
 static const struct file_operations proc_ops = {
+	.owner		= THIS_MODULE,
 	.open		= proc_udc_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -2512,11 +2513,7 @@ static const struct file_operations proc
 
 static void create_proc_file(void)
 {
-	struct proc_dir_entry *pde;
-
-	pde = create_proc_entry (proc_filename, 0, NULL);
-	if (pde)
-		pde->proc_fops = &proc_ops;
+	proc_create(proc_filename, 0, NULL, &proc_ops);
 }
 
 static void remove_proc_file(void)
diff -puN drivers/usb/host/sl811-hcd.c~usb-use-non-racy-method-for-proc-entries-creation drivers/usb/host/sl811-hcd.c
--- a/drivers/usb/host/sl811-hcd.c~usb-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/usb/host/sl811-hcd.c
@@ -1506,15 +1506,7 @@ static const char proc_filename[] = "dri
 
 static void create_debug_file(struct sl811 *sl811)
 {
-	struct proc_dir_entry *pde;
-
-	pde = create_proc_entry(proc_filename, 0, NULL);
-	if (pde == NULL)
-		return;
-
-	pde->proc_fops = &proc_ops;
-	pde->data = sl811;
-	sl811->pde = pde;
+	sl811->pde = proc_create_data(proc_filename, 0, NULL, &proc_ops, sl811);
 }
 
 static void remove_debug_file(struct sl811 *sl811)
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

