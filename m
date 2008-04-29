From: akpm@linux-foundation.org
Subject: + netfilter-assign-pde-fops-before-gluing-pde-into-proc-tree.patch added to -mm tree
Date: Tue, 29 Apr 2008 12:45:19 -0700
Message-ID: <200804291945.m3TJjJ3G006427@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41273 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755557AbYD2TpZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 15:45:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: den@openvz.org, adobriyan@openvz.org, ebiederm@xmission.com, kaber@trash.net


The patch titled
     netfilter: assign PDE->fops before gluing PDE into /proc tree
has been added to the -mm tree.  Its filename is
     netfilter-assign-pde-fops-before-gluing-pde-into-proc-tree.patch

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
Subject: netfilter: assign PDE->fops before gluing PDE into /proc tree
From: "Denis V. Lunev" <den@openvz.org>

Replace create_proc_entry with specially created for this purpose proc_create.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/netfilter/nf_conntrack_standalone.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN net/netfilter/nf_conntrack_standalone.c~netfilter-assign-pde-fops-before-gluing-pde-into-proc-tree net/netfilter/nf_conntrack_standalone.c
--- a/net/netfilter/nf_conntrack_standalone.c~netfilter-assign-pde-fops-before-gluing-pde-into-proc-tree
+++ a/net/netfilter/nf_conntrack_standalone.c
@@ -296,11 +296,11 @@ static int nf_conntrack_standalone_init_
 	pde = proc_net_fops_create(&init_net, "nf_conntrack", 0440, &ct_file_ops);
 	if (!pde)
 		goto out_nf_conntrack;
-	pde = create_proc_entry("nf_conntrack", S_IRUGO, init_net.proc_net_stat);
+
+	pde = proc_create("nf_conntrack", S_IRUGO, init_net.proc_net_stat,
+			  &ct_cpu_seq_fops);
 	if (!pde)
 		goto out_stat_nf_conntrack;
-	pde->proc_fops = &ct_cpu_seq_fops;
-	pde->owner = THIS_MODULE;
 	return 0;
 
 out_stat_nf_conntrack:
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

