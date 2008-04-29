From: akpm@linux-foundation.org
Subject: + net-assign-pde-data-before-gluing-pde-into-proc-tree.patch added to -mm tree
Date: Tue, 29 Apr 2008 12:45:04 -0700
Message-ID: <200804291945.m3TJj4Bp006406@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753010AbYD2TpI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 15:45:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: den@openvz.org, adobriyan@openvz.org, davem@davemloft.net, ebiederm@xmission.com


The patch titled
     net: assign PDE->data before gluing PDE into /proc tree
has been added to the -mm tree.  Its filename is
     net-assign-pde-data-before-gluing-pde-into-proc-tree.patch

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
Subject: net: assign PDE->data before gluing PDE into /proc tree
From: "Denis V. Lunev" <den@openvz.org>

Simply replace proc_create and further data assigned with proc_create_data. 
Additionally, there is no need to assign NULL to PDE->data after creation,
/proc generic has already done this for us.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/neighbour.c |    5 ++---
 net/core/pktgen.c    |   12 ++++--------
 2 files changed, 6 insertions(+), 11 deletions(-)

diff -puN net/core/neighbour.c~net-assign-pde-data-before-gluing-pde-into-proc-tree net/core/neighbour.c
--- a/net/core/neighbour.c~net-assign-pde-data-before-gluing-pde-into-proc-tree
+++ a/net/core/neighbour.c
@@ -1430,11 +1430,10 @@ void neigh_table_init_no_netlink(struct 
 		panic("cannot create neighbour cache statistics");
 
 #ifdef CONFIG_PROC_FS
-	tbl->pde = proc_create(tbl->id, 0, init_net.proc_net_stat,
-			       &neigh_stat_seq_fops);
+	tbl->pde = proc_create_data(tbl->id, 0, init_net.proc_net_stat,
+				    &neigh_stat_seq_fops, tbl);
 	if (!tbl->pde)
 		panic("cannot create neighbour proc dir entry");
-	tbl->pde->data = tbl;
 #endif
 
 	tbl->hash_mask = 1;
diff -puN net/core/pktgen.c~net-assign-pde-data-before-gluing-pde-into-proc-tree net/core/pktgen.c
--- a/net/core/pktgen.c~net-assign-pde-data-before-gluing-pde-into-proc-tree
+++ a/net/core/pktgen.c
@@ -3570,15 +3570,14 @@ static int pktgen_add_device(struct pktg
 	if (err)
 		goto out1;
 
-	pkt_dev->entry = proc_create(ifname, 0600,
-				     pg_proc_dir, &pktgen_if_fops);
+	pkt_dev->entry = proc_create_data(ifname, 0600, pg_proc_dir,
+					  &pktgen_if_fops, pkt_dev);
 	if (!pkt_dev->entry) {
 		printk(KERN_ERR "pktgen: cannot create %s/%s procfs entry.\n",
 		       PG_PROC_DIR, ifname);
 		err = -EINVAL;
 		goto out2;
 	}
-	pkt_dev->entry->data = pkt_dev;
 #ifdef CONFIG_XFRM
 	pkt_dev->ipsmode = XFRM_MODE_TRANSPORT;
 	pkt_dev->ipsproto = IPPROTO_ESP;
@@ -3628,7 +3627,8 @@ static int __init pktgen_create_thread(i
 	kthread_bind(p, cpu);
 	t->tsk = p;
 
-	pe = proc_create(t->tsk->comm, 0600, pg_proc_dir, &pktgen_thread_fops);
+	pe = proc_create_data(t->tsk->comm, 0600, pg_proc_dir,
+			      &pktgen_thread_fops, t);
 	if (!pe) {
 		printk(KERN_ERR "pktgen: cannot create %s/%s procfs entry.\n",
 		       PG_PROC_DIR, t->tsk->comm);
@@ -3638,8 +3638,6 @@ static int __init pktgen_create_thread(i
 		return -EINVAL;
 	}
 
-	pe->data = t;
-
 	wake_up_process(p);
 
 	return 0;
@@ -3716,8 +3714,6 @@ static int __init pg_init(void)
 		return -EINVAL;
 	}
 
-	pe->data = NULL;
-
 	/* Register us to receive netdevice events */
 	register_netdevice_notifier(&pktgen_notifier_block);
 
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

