From: akpm@linux-foundation.org
Subject: - samples-use-non-racy-method-for-proc-marker-example-creation.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:47:03 -0700
Message-ID: <200804300547.m3U5l3iP029670@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38691 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760505AbYD3GMQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, adobriyan@gmail.com, ebiederm@xmission.com, mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     samples: use non-racy method for /proc/marker-example creation
has been removed from the -mm tree.  Its filename was
     samples-use-non-racy-method-for-proc-marker-example-creation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: samples: use non-racy method for /proc/marker-example creation
From: "Denis V. Lunev" <den@openvz.org>

Use proc_create() to make sure that ->proc_fops be setup before gluing PDE to
main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/markers/marker-example.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN samples/markers/marker-example.c~samples-use-non-racy-method-for-proc-marker-example-creation samples/markers/marker-example.c
--- a/samples/markers/marker-example.c~samples-use-non-racy-method-for-proc-marker-example-creation
+++ a/samples/markers/marker-example.c
@@ -33,10 +33,8 @@ static struct file_operations mark_ops =
 static int example_init(void)
 {
 	printk(KERN_ALERT "example init\n");
-	pentry_example = create_proc_entry("marker-example", 0444, NULL);
-	if (pentry_example)
-		pentry_example->proc_fops = &mark_ops;
-	else
+	pentry_example = proc_create("marker-example", 0444, NULL, &mark_ops);
+	if (!pentry_example)
 		return -EPERM;
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

