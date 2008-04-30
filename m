From: akpm@linux-foundation.org
Subject: - sysvipc-use-non-racy-method-for-proc-entries-creation.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:46:55 -0700
Message-ID: <200804300546.m3U5kteh029652@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758593AbYD3FsB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:48:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, Nadia.Derbey@bull.net, adobriyan@gmail.com, ebiederm@xmission.com, peifferp@gmail.com, mm-commits@vger.kernel.org


The patch titled
     sysvipc: use non-racy method for proc entries creation
has been removed from the -mm tree.  Its filename was
     sysvipc-use-non-racy-method-for-proc-entries-creation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysvipc: use non-racy method for proc entries creation
From: "Denis V. Lunev" <den@openvz.org>

Use proc_create_data() to make sure that ->proc_fops and ->data be setup
before gluing PDE to main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Pierre Peiffer <peifferp@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN ipc/util.c~sysvipc-use-non-racy-method-for-proc-entries-creation ipc/util.c
--- a/ipc/util.c~sysvipc-use-non-racy-method-for-proc-entries-creation
+++ a/ipc/util.c
@@ -165,13 +165,12 @@ void __init ipc_init_proc_interface(cons
 	iface->ids	= ids;
 	iface->show	= show;
 
-	pde = create_proc_entry(path,
-				S_IRUGO,        /* world readable */
-				NULL            /* parent dir */);
-	if (pde) {
-		pde->data = iface;
-		pde->proc_fops = &sysvipc_proc_fops;
-	} else {
+	pde = proc_create_data(path,
+			       S_IRUGO,        /* world readable */
+			       NULL,           /* parent dir */
+			       &sysvipc_proc_fops,
+			       iface);
+	if (!pde) {
 		kfree(iface);
 	}
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

