From: akpm@linux-foundation.org
Subject: + atm-assign-pde-data-before-gluing-pde-into-proc-tree.patch added to -mm tree
Date: Tue, 29 Apr 2008 12:45:08 -0700
Message-ID: <200804291945.m3TJj9Sp006412@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53342 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755524AbYD2TpS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 15:45:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: den@openvz.org, adobriyan@openvz.org, chas@cmf.nrl.navy.mil, davem@davemloft.net, ebiederm@xmission.com


The patch titled
     atm: assign PDE->data before gluing PDE into /proc tree
has been added to the -mm tree.  Its filename is
     atm-assign-pde-data-before-gluing-pde-into-proc-tree.patch

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
Subject: atm: assign PDE->data before gluing PDE into /proc tree
From: "Denis V. Lunev" <den@openvz.org>

Simply replace proc_create and further data assigned with proc_create_data. 
proc_atm_dev_ops holds proper referrence.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Chas Williams <chas@cmf.nrl.navy.mil>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/atm/proc.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN net/atm/proc.c~atm-assign-pde-data-before-gluing-pde-into-proc-tree net/atm/proc.c
--- a/net/atm/proc.c~atm-assign-pde-data-before-gluing-pde-into-proc-tree
+++ a/net/atm/proc.c
@@ -417,12 +417,10 @@ int atm_proc_dev_register(struct atm_dev
 		goto err_out;
 	sprintf(dev->proc_name,"%s:%d",dev->type, dev->number);
 
-	dev->proc_entry = proc_create(dev->proc_name, 0, atm_proc_root,
-				      &proc_atm_dev_ops);
+	dev->proc_entry = proc_create_data(dev->proc_name, 0, atm_proc_root,
+					   &proc_atm_dev_ops, dev);
 	if (!dev->proc_entry)
 		goto err_free_name;
-	dev->proc_entry->data = dev;
-	dev->proc_entry->owner = THIS_MODULE;
 	return 0;
 err_free_name:
 	kfree(dev->proc_name);
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

