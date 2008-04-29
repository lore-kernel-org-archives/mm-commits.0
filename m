From: akpm@linux-foundation.org
Subject: + ipv4-assign-pde-data-before-gluing-pde-into-proc-tree.patch added to -mm tree
Date: Tue, 29 Apr 2008 12:45:17 -0700
Message-ID: <200804291945.m3TJjHom006424@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47387 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755557AbYD2TpV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 15:45:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: den@openvz.org, adobriyan@openvz.org, davem@davemloft.net, ebiederm@xmission.com


The patch titled
     ipv4: assign PDE->data before gluing PDE into /proc tree
has been added to the -mm tree.  Its filename is
     ipv4-assign-pde-data-before-gluing-pde-into-proc-tree.patch

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
Subject: ipv4: assign PDE->data before gluing PDE into /proc tree
From: "Denis V. Lunev" <den@openvz.org>

The check for PDE->data != NULL becomes useless after the replacement of
proc_net_fops_create with proc_create_data.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv4/tcp_ipv4.c |   10 +++-------
 net/ipv4/udp.c      |    7 +++----
 2 files changed, 6 insertions(+), 11 deletions(-)

diff -puN net/ipv4/tcp_ipv4.c~ipv4-assign-pde-data-before-gluing-pde-into-proc-tree net/ipv4/tcp_ipv4.c
--- a/net/ipv4/tcp_ipv4.c~ipv4-assign-pde-data-before-gluing-pde-into-proc-tree
+++ a/net/ipv4/tcp_ipv4.c
@@ -2214,9 +2214,6 @@ static int tcp_seq_open(struct inode *in
 	struct tcp_iter_state *s;
 	int err;
 
-	if (unlikely(afinfo == NULL))
-		return -EINVAL;
-
 	err = seq_open_net(inode, file, &afinfo->seq_ops,
 			  sizeof(struct tcp_iter_state));
 	if (err < 0)
@@ -2241,10 +2238,9 @@ int tcp_proc_register(struct net *net, s
 	afinfo->seq_ops.next		= tcp_seq_next;
 	afinfo->seq_ops.stop		= tcp_seq_stop;
 
-	p = proc_net_fops_create(net, afinfo->name, S_IRUGO, &afinfo->seq_fops);
-	if (p)
-		p->data = afinfo;
-	else
+	p = proc_create_data(afinfo->name, S_IRUGO, net->proc_net,
+			     &afinfo->seq_fops, afinfo);
+	if (!p)
 		rc = -ENOMEM;
 	return rc;
 }
diff -puN net/ipv4/udp.c~ipv4-assign-pde-data-before-gluing-pde-into-proc-tree net/ipv4/udp.c
--- a/net/ipv4/udp.c~ipv4-assign-pde-data-before-gluing-pde-into-proc-tree
+++ a/net/ipv4/udp.c
@@ -1605,10 +1605,9 @@ int udp_proc_register(struct net *net, s
 	afinfo->seq_ops.next		= udp_seq_next;
 	afinfo->seq_ops.stop		= udp_seq_stop;
 
-	p = proc_net_fops_create(net, afinfo->name, S_IRUGO, &afinfo->seq_fops);
-	if (p)
-		p->data = afinfo;
-	else
+	p = proc_create_data(afinfo->name, S_IRUGO, net->proc_net,
+			     &afinfo->seq_fops, afinfo);
+	if (!p)
 		rc = -ENOMEM;
 	return rc;
 }
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

