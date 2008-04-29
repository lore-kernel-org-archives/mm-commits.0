From: akpm@linux-foundation.org
Subject: + netns-assign-pde-data-before-gluing-entry-into-proc-tree.patch added to -mm tree
Date: Tue, 29 Apr 2008 12:55:32 -0700
Message-ID: <200804291955.m3TJtWhd006764@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45470 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750873AbYD2Tzp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 15:55:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: den@openvz.org, adobriyan@openvz.org, ebiederm@xmission.com


The patch titled
     netns: assign PDE->data before gluing entry into /proc tree
has been added to the -mm tree.  Its filename is
     netns-assign-pde-data-before-gluing-entry-into-proc-tree.patch

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
Subject: netns: assign PDE->data before gluing entry into /proc tree
From: "Denis V. Lunev" <den@openvz.org>

In this unfortunate case, proc_mkdir_mode wrapper can't be used anymore and
this is no way to reuse proc_create_data due to nlinks assignment.  So, copy
the code from proc_mkdir and assign PDE->data at the appropriate moment.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c  |   17 +++++++++++++++++
 fs/proc/proc_net.c |   11 -----------
 2 files changed, 17 insertions(+), 11 deletions(-)

diff -puN fs/proc/generic.c~netns-assign-pde-data-before-gluing-entry-into-proc-tree fs/proc/generic.c
--- a/fs/proc/generic.c~netns-assign-pde-data-before-gluing-entry-into-proc-tree
+++ a/fs/proc/generic.c
@@ -641,6 +641,23 @@ struct proc_dir_entry *proc_mkdir_mode(c
 	return ent;
 }
 
+struct proc_dir_entry *proc_net_mkdir(struct net *net, const char *name,
+		struct proc_dir_entry *parent)
+{
+	struct proc_dir_entry *ent;
+
+	ent = __proc_create(&parent, name, S_IFDIR | S_IRUGO | S_IXUGO, 2);
+	if (ent) {
+		ent->data = net;
+		if (proc_register(parent, ent) < 0) {
+			kfree(ent);
+			ent = NULL;
+		}
+	}
+	return ent;
+}
+EXPORT_SYMBOL_GPL(proc_net_mkdir);
+
 struct proc_dir_entry *proc_mkdir(const char *name,
 		struct proc_dir_entry *parent)
 {
diff -puN fs/proc/proc_net.c~netns-assign-pde-data-before-gluing-entry-into-proc-tree fs/proc/proc_net.c
--- a/fs/proc/proc_net.c~netns-assign-pde-data-before-gluing-entry-into-proc-tree
+++ a/fs/proc/proc_net.c
@@ -159,17 +159,6 @@ struct net *get_proc_net(const struct in
 }
 EXPORT_SYMBOL_GPL(get_proc_net);
 
-struct proc_dir_entry *proc_net_mkdir(struct net *net, const char *name,
-		struct proc_dir_entry *parent)
-{
-	struct proc_dir_entry *pde;
-	pde = proc_mkdir_mode(name, S_IRUGO | S_IXUGO, parent);
-	if (pde != NULL)
-		pde->data = net;
-	return pde;
-}
-EXPORT_SYMBOL_GPL(proc_net_mkdir);
-
 static __net_init int proc_net_ns_init(struct net *net)
 {
 	struct proc_dir_entry *netd, *net_statd;
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
netns-assign-pde-data-before-gluing-entry-into-proc-tree.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch

