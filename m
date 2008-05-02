From: akpm@linux-foundation.org
Subject: - atm-assign-pde-data-before-gluing-pde-into-proc-tree.patch removed from -mm tree
Date: Fri, 02 May 2008 12:44:07 -0700
Message-ID: <200805021944.m42Ji7HI011352@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37258 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933465AbYEBTos (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:44:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, adobriyan@openvz.org, chas@cmf.nrl.navy.mil, davem@davemloft.net, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     atm: assign PDE->data before gluing PDE into /proc tree
has been removed from the -mm tree.  Its filename was
     atm-assign-pde-data-before-gluing-pde-into-proc-tree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atm: assign PDE->data before gluing PDE into /proc tree
From: "Denis V. Lunev" <den@openvz.org>

Simply replace proc_create and further data assigned with proc_create_data. 
proc_atm_dev_ops holds proper referrence.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Chas Williams <chas@cmf.nrl.navy.mil>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/atm/proc.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN net/atm/proc.c~atm-assign-pde-data-before-gluing-pde-into-proc-tree net/atm/proc.c
--- a/net/atm/proc.c~atm-assign-pde-data-before-gluing-pde-into-proc-tree
+++ a/net/atm/proc.c
@@ -417,12 +417,10 @@ int atm_proc_dev_register(struct atm_dev
 		goto err_out;
 	sprintf(dev->proc_name,"%s:%d",dev->type, dev->number);
 
-	dev->proc_entry = proc_create(dev->proc_name, 0, atm_proc_root,
-				      &proc_atm_dev_ops);
+	dev->proc_entry = proc_create_data(dev->proc_name, 0, atm_proc_root,
+					   &proc_atm_dev_ops, dev);
 	if (!dev->proc_entry)
 		goto err_free_name;
-	dev->proc_entry->data = dev;
-	dev->proc_entry->owner = THIS_MODULE;
 	return 0;
 err_free_name:
 	kfree(dev->proc_name);
_

Patches currently in -mm which might be from den@openvz.org are

origin.patch
git-net.patch
powerpc-assign-pde-data-before-gluing-pde-into-proc-tree.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch

