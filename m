From: akpm@linux-foundation.org
Subject: - zorro-use-non-racy-method-for-proc-entries-creation.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:47:01 -0700
Message-ID: <200804300547.m3U5l1uJ029667@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758537AbYD3Frl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:47:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, adobriyan@gmail.com, ebiederm@xmission.com, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     zorro: use non-racy method for proc entries creation
has been removed from the -mm tree.  Its filename was
     zorro-use-non-racy-method-for-proc-entries-creation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: zorro: use non-racy method for proc entries creation
From: "Denis V. Lunev" <den@openvz.org>

Use proc_create()/proc_create_data() to make sure that ->proc_fops and ->data
be setup before gluing PDE to main tree.

Add correct ->owner to proc_fops to fix reading/module unloading race.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/zorro/proc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/zorro/proc.c~zorro-use-non-racy-method-for-proc-entries-creation drivers/zorro/proc.c
--- a/drivers/zorro/proc.c~zorro-use-non-racy-method-for-proc-entries-creation
+++ a/drivers/zorro/proc.c
@@ -77,6 +77,7 @@ proc_bus_zorro_read(struct file *file, c
 }
 
 static const struct file_operations proc_bus_zorro_operations = {
+	.owner		= THIS_MODULE,
 	.llseek		= proc_bus_zorro_lseek,
 	.read		= proc_bus_zorro_read,
 };
@@ -136,11 +137,11 @@ static int __init zorro_proc_attach_devi
 	char name[4];
 
 	sprintf(name, "%02x", slot);
-	entry = create_proc_entry(name, 0, proc_bus_zorro_dir);
+	entry = proc_create_data(name, 0, proc_bus_zorro_dir,
+				 &proc_bus_zorro_operations,
+				 &zorro_autocon[slot]);
 	if (!entry)
 		return -ENOMEM;
-	entry->proc_fops = &proc_bus_zorro_operations;
-	entry->data = &zorro_autocon[slot];
 	entry->size = sizeof(struct zorro_dev);
 	return 0;
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

