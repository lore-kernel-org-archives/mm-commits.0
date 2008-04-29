From: akpm@linux-foundation.org
Subject: + netfilter-assign-pde-data-before-gluing-pde-into-proc-tree-2.patch added to -mm tree
Date: Tue, 29 Apr 2008 12:46:39 -0700
Message-ID: <200804291946.m3TJkdev006450@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43039 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754161AbYD2TrQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 15:47:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: den@openvz.org, adobriyan@openvz.org, ebiederm@xmission.com, kaber@trash.net


The patch titled
     netfilter: assign PDE->data before gluing PDE into /proc tree (2)
has been added to the -mm tree.  Its filename is
     netfilter-assign-pde-data-before-gluing-pde-into-proc-tree-2.patch

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
Subject: netfilter: assign PDE->data before gluing PDE into /proc tree (2)
From: "Denis V. Lunev" <den@openvz.org>

Replace proc_net_fops_create with proc_create_data.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/netfilter/x_tables.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN net/netfilter/x_tables.c~netfilter-assign-pde-data-before-gluing-pde-into-proc-tree-2 net/netfilter/x_tables.c
--- a/net/netfilter/x_tables.c~netfilter-assign-pde-data-before-gluing-pde-into-proc-tree-2
+++ a/net/netfilter/x_tables.c
@@ -936,25 +936,24 @@ int xt_proto_init(struct net *net, int a
 #ifdef CONFIG_PROC_FS
 	strlcpy(buf, xt_prefix[af], sizeof(buf));
 	strlcat(buf, FORMAT_TABLES, sizeof(buf));
-	proc = proc_net_fops_create(net, buf, 0440, &xt_table_ops);
+	proc = proc_create_data(buf, 0440, net->proc_net, &xt_table_ops,
+				(void *)(unsigned long)af);
 	if (!proc)
 		goto out;
-	proc->data = (void *)(unsigned long)af;
-
 
 	strlcpy(buf, xt_prefix[af], sizeof(buf));
 	strlcat(buf, FORMAT_MATCHES, sizeof(buf));
-	proc = proc_net_fops_create(net, buf, 0440, &xt_match_ops);
+	proc = proc_create_data(buf, 0440, net->proc_net, &xt_match_ops,
+				(void *)(unsigned long)af);
 	if (!proc)
 		goto out_remove_tables;
-	proc->data = (void *)(unsigned long)af;
 
 	strlcpy(buf, xt_prefix[af], sizeof(buf));
 	strlcat(buf, FORMAT_TARGETS, sizeof(buf));
-	proc = proc_net_fops_create(net, buf, 0440, &xt_target_ops);
+	proc = proc_create_data(buf, 0440, net->proc_net, &xt_target_ops,
+				(void *)(unsigned long)af);
 	if (!proc)
 		goto out_remove_matches;
-	proc->data = (void *)(unsigned long)af;
 #endif
 
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
netfilter-assign-pde-data-before-gluing-pde-into-proc-tree-2.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch

