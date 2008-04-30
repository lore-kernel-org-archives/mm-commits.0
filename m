From: akpm@linux-foundation.org
Subject: - cris-use-non-racy-method-for-proc-system_profile-creation.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:47:15 -0700
Message-ID: <200804300547.m3U5lFWO029688@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44297 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758411AbYD3Fru (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:47:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, adobriyan@gmail.com, ebiederm@xmission.com, jesper.nilsson@axis.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     cris: use non-racy method for /proc/system_profile creation
has been removed from the -mm tree.  Its filename was
     cris-use-non-racy-method-for-proc-system_profile-creation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cris: use non-racy method for /proc/system_profile creation
From: "Denis V. Lunev" <den@openvz.org>

Use proc_create() to make sure that ->proc_fops be setup before gluing PDE to
main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/kernel/profile.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/cris/kernel/profile.c~cris-use-non-racy-method-for-proc-system_profile-creation arch/cris/kernel/profile.c
--- a/arch/cris/kernel/profile.c~cris-use-non-racy-method-for-proc-system_profile-creation
+++ a/arch/cris/kernel/profile.c
@@ -75,9 +75,9 @@ __init init_cris_profile(void)
 
 	sample_buffer_pos = sample_buffer;
 
-	entry = create_proc_entry("system_profile", S_IWUSR | S_IRUGO, NULL);
+	entry = proc_create("system_profile", S_IWUSR | S_IRUGO, NULL,
+			    &cris_proc_profile_operations);
 	if (entry) {
-		entry->proc_fops = &cris_proc_profile_operations;
 		entry->size = SAMPLE_BUFFER_SIZE;
 	}
 	prof_running = 1;
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

