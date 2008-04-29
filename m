From: akpm@linux-foundation.org
Subject: + netfilter-assign-pde-data-before-gluing-pde-into-proc-tree.patch added to -mm tree
Date: Tue, 29 Apr 2008 12:45:02 -0700
Message-ID: <200804291945.m3TJj2Y7006403@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50984 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753843AbYD2TpI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 15:45:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: den@openvz.org, adobriyan@openvz.org, ebiederm@xmission.com, kaber@trash.net


The patch titled
     netfilter: assign PDE->data before gluing PDE into /proc tree
has been added to the -mm tree.  Its filename is
     netfilter-assign-pde-data-before-gluing-pde-into-proc-tree.patch

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
Subject: netfilter: assign PDE->data before gluing PDE into /proc tree
From: "Denis V. Lunev" <den@openvz.org>

Simply replace proc_create and further data assigned with proc_create_data.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv4/netfilter/ipt_CLUSTERIP.c |    6 +++---
 net/netfilter/xt_hashlimit.c       |   12 ++++++------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff -puN net/ipv4/netfilter/ipt_CLUSTERIP.c~netfilter-assign-pde-data-before-gluing-pde-into-proc-tree net/ipv4/netfilter/ipt_CLUSTERIP.c
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c~netfilter-assign-pde-data-before-gluing-pde-into-proc-tree
+++ a/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -169,14 +169,14 @@ clusterip_config_init(const struct ipt_c
 
 		/* create proc dir entry */
 		sprintf(buffer, "%u.%u.%u.%u", NIPQUAD(ip));
-		c->pde = proc_create(buffer, S_IWUSR|S_IRUSR,
-				     clusterip_procdir, &clusterip_proc_fops);
+		c->pde = proc_create_data(buffer, S_IWUSR|S_IRUSR,
+					  clusterip_procdir,
+					  &clusterip_proc_fops, c);
 		if (!c->pde) {
 			kfree(c);
 			return NULL;
 		}
 	}
-	c->pde->data = c;
 #endif
 
 	write_lock_bh(&clusterip_lock);
diff -puN net/netfilter/xt_hashlimit.c~netfilter-assign-pde-data-before-gluing-pde-into-proc-tree net/netfilter/xt_hashlimit.c
--- a/net/netfilter/xt_hashlimit.c~netfilter-assign-pde-data-before-gluing-pde-into-proc-tree
+++ a/net/netfilter/xt_hashlimit.c
@@ -237,15 +237,15 @@ static int htable_create_v0(struct xt_ha
 	hinfo->family = family;
 	hinfo->rnd_initialized = 0;
 	spin_lock_init(&hinfo->lock);
-	hinfo->pde = proc_create(minfo->name, 0,
+	hinfo->pde =
+		proc_create_data(minfo->name, 0,
 				 family == AF_INET ? hashlimit_procdir4 :
 						     hashlimit_procdir6,
-				 &dl_file_ops);
+				 &dl_file_ops, hinfo);
 	if (!hinfo->pde) {
 		vfree(hinfo);
 		return -1;
 	}
-	hinfo->pde->data = hinfo;
 
 	setup_timer(&hinfo->timer, htable_gc, (unsigned long )hinfo);
 	hinfo->timer.expires = jiffies + msecs_to_jiffies(hinfo->cfg.gc_interval);
@@ -301,15 +301,15 @@ static int htable_create(struct xt_hashl
 	hinfo->rnd_initialized = 0;
 	spin_lock_init(&hinfo->lock);
 
-	hinfo->pde = proc_create(minfo->name, 0,
+	hinfo->pde =
+		proc_create_data(minfo->name, 0,
 				 family == AF_INET ? hashlimit_procdir4 :
 						     hashlimit_procdir6,
-				 &dl_file_ops);
+				 &dl_file_ops, hinfo);
 	if (hinfo->pde == NULL) {
 		vfree(hinfo);
 		return -1;
 	}
-	hinfo->pde->data = hinfo;
 
 	setup_timer(&hinfo->timer, htable_gc, (unsigned long)hinfo);
 	hinfo->timer.expires = jiffies + msecs_to_jiffies(hinfo->cfg.gc_interval);
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

