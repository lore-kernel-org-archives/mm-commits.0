From: akpm@linux-foundation.org
Subject: - arm-use-non-racy-method-for-proc-davinci_clocks-creation.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:47:11 -0700
Message-ID: <200804300547.m3U5lBHU029682@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37584 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758579AbYD3Fro (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:47:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, adobriyan@gmail.com, ebiederm@xmission.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     arm: use non-racy method for /proc/davinci_clocks creation
has been removed from the -mm tree.  Its filename was
     arm-use-non-racy-method-for-proc-davinci_clocks-creation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arm: use non-racy method for /proc/davinci_clocks creation
From: "Denis V. Lunev" <den@openvz.org>

Use proc_create() to make sure that ->proc_fops be setup before gluing PDE to
main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-davinci/clock.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN arch/arm/mach-davinci/clock.c~arm-use-non-racy-method-for-proc-davinci_clocks-creation arch/arm/mach-davinci/clock.c
--- a/arch/arm/mach-davinci/clock.c~arm-use-non-racy-method-for-proc-davinci_clocks-creation
+++ a/arch/arm/mach-davinci/clock.c
@@ -311,11 +311,7 @@ static const struct file_operations proc
 
 static int __init davinci_ck_proc_init(void)
 {
-	struct proc_dir_entry *entry;
-
-	entry = create_proc_entry("davinci_clocks", 0, NULL);
-	if (entry)
-		entry->proc_fops = &proc_davinci_ck_operations;
+	proc_create("davinci_clocks", 0, NULL, &proc_davinci_ck_operations);
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

