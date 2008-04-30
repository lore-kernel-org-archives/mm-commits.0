From: akpm@linux-foundation.org
Subject: - parisc-use-non-racy-method-for-proc-pcxl_dma-creation.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:47:19 -0700
Message-ID: <200804300547.m3U5lJne029694@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57352 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758582AbYD3Fr6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:47:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, adobriyan@gmail.com, ebiederm@xmission.com, grundler@parisc-linux.org, kyle@parisc-linux.org, matthew@wil.cx, mm-commits@vger.kernel.org


The patch titled
     parisc: use non-racy method for /proc/pcxl_dma creation
has been removed from the -mm tree.  Its filename was
     parisc-use-non-racy-method-for-proc-pcxl_dma-creation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: parisc: use non-racy method for /proc/pcxl_dma creation
From: "Denis V. Lunev" <den@openvz.org>

Use proc_create() to make sure that ->proc_fops be setup before gluing PDE to
main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Kyle McMartin <kyle@parisc-linux.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/kernel/pci-dma.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN arch/parisc/kernel/pci-dma.c~parisc-use-non-racy-method-for-proc-pcxl_dma-creation arch/parisc/kernel/pci-dma.c
--- a/arch/parisc/kernel/pci-dma.c~parisc-use-non-racy-method-for-proc-pcxl_dma-creation
+++ a/arch/parisc/kernel/pci-dma.c
@@ -397,10 +397,9 @@ pcxl_dma_init(void)
 			"pcxl_dma_init: Unable to create gsc /proc dir entry\n");
 	else {
 		struct proc_dir_entry* ent;
-		ent = create_proc_entry("pcxl_dma", 0, proc_gsc_root);
-		if (ent)
-			ent->proc_fops = &proc_pcxl_dma_ops;
-		else
+		ent = proc_create("pcxl_dma", 0, proc_gsc_root,
+				  &proc_pcxl_dma_ops);
+		if (!ent)
 			printk(KERN_WARNING
 				"pci-dma.c: Unable to create pcxl_dma /proc entry.\n");
 	}
_

Patches currently in -mm which might be from den@openvz.org are

origin.patch
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

