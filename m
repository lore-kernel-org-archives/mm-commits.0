From: akpm@linux-foundation.org
Subject: + sunrpc-assign-pde-data-before-gluing-pde-into-proc-tree.patch added to -mm tree
Date: Tue, 29 Apr 2008 12:44:59 -0700
Message-ID: <200804291945.m3TJj0Jj006391@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38862 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755387AbYD2TpR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 15:45:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: den@openvz.org, adobriyan@openvz.org, bfields@fieldses.org, davem@davemloft.net, ebiederm@xmission.com, neilb@suse.de, trond.myklebust@fys.uio.no


The patch titled
     sunrpc: assign PDE->data before gluing PDE into /proc tree
has been added to the -mm tree.  Its filename is
     sunrpc-assign-pde-data-before-gluing-pde-into-proc-tree.patch

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
Subject: sunrpc: assign PDE->data before gluing PDE into /proc tree
From: "Denis V. Lunev" <den@openvz.org>

Simply replace proc_create and further data assigned with proc_create_data.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/cache.c |   15 ++++++---------
 net/sunrpc/stats.c |    8 +-------
 2 files changed, 7 insertions(+), 16 deletions(-)

diff -puN net/sunrpc/cache.c~sunrpc-assign-pde-data-before-gluing-pde-into-proc-tree net/sunrpc/cache.c
--- a/net/sunrpc/cache.c~sunrpc-assign-pde-data-before-gluing-pde-into-proc-tree
+++ a/net/sunrpc/cache.c
@@ -316,31 +316,28 @@ static int create_cache_proc_entries(str
 	cd->proc_ent->owner = cd->owner;
 	cd->channel_ent = cd->content_ent = NULL;
 
-	p = proc_create("flush", S_IFREG|S_IRUSR|S_IWUSR,
-			cd->proc_ent, &cache_flush_operations);
+	p = proc_create_data("flush", S_IFREG|S_IRUSR|S_IWUSR,
+			     cd->proc_ent, &cache_flush_operations, cd);
 	cd->flush_ent = p;
 	if (p == NULL)
 		goto out_nomem;
 	p->owner = cd->owner;
-	p->data = cd;
 
 	if (cd->cache_request || cd->cache_parse) {
-		p = proc_create("channel", S_IFREG|S_IRUSR|S_IWUSR,
-				cd->proc_ent, &cache_file_operations);
+		p = proc_create_data("channel", S_IFREG|S_IRUSR|S_IWUSR,
+				     cd->proc_ent, &cache_file_operations, cd);
 		cd->channel_ent = p;
 		if (p == NULL)
 			goto out_nomem;
 		p->owner = cd->owner;
-		p->data = cd;
 	}
 	if (cd->cache_show) {
-		p = proc_create("content", S_IFREG|S_IRUSR|S_IWUSR,
-				cd->proc_ent, &content_file_operations);
+		p = proc_create_data("content", S_IFREG|S_IRUSR|S_IWUSR,
+				cd->proc_ent, &content_file_operations, cd);
 		cd->content_ent = p;
 		if (p == NULL)
 			goto out_nomem;
 		p->owner = cd->owner;
-		p->data = cd;
 	}
 	return 0;
 out_nomem:
diff -puN net/sunrpc/stats.c~sunrpc-assign-pde-data-before-gluing-pde-into-proc-tree net/sunrpc/stats.c
--- a/net/sunrpc/stats.c~sunrpc-assign-pde-data-before-gluing-pde-into-proc-tree
+++ a/net/sunrpc/stats.c
@@ -224,16 +224,10 @@ EXPORT_SYMBOL_GPL(rpc_print_iostats);
 static inline struct proc_dir_entry *
 do_register(const char *name, void *data, const struct file_operations *fops)
 {
-	struct proc_dir_entry *ent;
-
 	rpc_proc_init();
 	dprintk("RPC:       registering /proc/net/rpc/%s\n", name);
 
-	ent = proc_create(name, 0, proc_net_rpc, fops);
-	if (ent) {
-		ent->data = data;
-	}
-	return ent;
+	return proc_create_data(name, 0, proc_net_rpc, fops, data);
 }
 
 struct proc_dir_entry *
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

