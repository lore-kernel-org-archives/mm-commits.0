From: akpm@linux-foundation.org
Subject: - drivers-use-non-racy-method-for-proc-entries-creation-2-rio.patch removed from -mm tree
Date: Wed, 30 Apr 2008 15:25:47 -0700
Message-ID: <200804302225.m3UMPmDt006716@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50750 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762450AbYD3W0s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 18:26:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, a.zummo@towertech.it, adobriyan@gmail.com, bjorn.helgaas@hp.com, bzolnier@gmail.com, dtor@mail.ru, ebiederm@xmission.com, galak@gate.crashing.org, gregkh@suse.de, mche


The patch titled
     drivers: use non-racy method for proc entries creation (2)
has been removed from the -mm tree.  Its filename was
     drivers-use-non-racy-method-for-proc-entries-creation-2-rio.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers: use non-racy method for proc entries creation (2)

diff -puN drivers/rapidio/rio.c~drivers-use-non-racy-method-for-proc-entries-creation-2 drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~drivers-use-non-racy-method-for-proc-entries-creation-2
+++ a/drivers/rapidio/rio.c
@@ -984,11 +984,7 @@ static const struct file_operations proc
 
 static int __init rioresources_init(void)
 {
-	struct proc_dir_entry *entry;
-
-	entry = create_proc_entry("riores", 0, NULL);
-	if (entry)
-		entry->proc_fops = &proc_riores_operations;
+	proc_create("riores", 0, NULL, &proc_riores_operations);
 	return 0;
 }
 __initcall(rioresources_init);


Patches currently in -mm which might be from den@openvz.org are

origin.patch
isdn-hysdn_procconfc-build-fix.patch
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

