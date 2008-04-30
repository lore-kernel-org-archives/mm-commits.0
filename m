From: akpm@linux-foundation.org
Subject: - sound-use-non-racy-method-for-proc-driver-snd-page-alloc-creation.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:46:59 -0700
Message-ID: <200804300546.m3U5kx0u029658@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33650 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757246AbYD3Frj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:47:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, adobriyan@gmail.com, ebiederm@xmission.com, perex@suse.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     sound: use non-racy method for /proc/driver/snd-page-alloc creation
has been removed from the -mm tree.  Its filename was
     sound-use-non-racy-method-for-proc-driver-snd-page-alloc-creation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sound: use non-racy method for /proc/driver/snd-page-alloc creation
From: "Denis V. Lunev" <den@openvz.org>

Use proc_create() to make sure that ->proc_fops be setup before gluing PDE to
main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/core/memalloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN sound/core/memalloc.c~sound-use-non-racy-method-for-proc-driver-snd-page-alloc-creation sound/core/memalloc.c
--- a/sound/core/memalloc.c~sound-use-non-racy-method-for-proc-driver-snd-page-alloc-creation
+++ a/sound/core/memalloc.c
@@ -629,9 +629,8 @@ static const struct file_operations snd_
 static int __init snd_mem_init(void)
 {
 #ifdef CONFIG_PROC_FS
-	snd_mem_proc = create_proc_entry(SND_MEM_PROC_FILE, 0644, NULL);
-	if (snd_mem_proc)
-		snd_mem_proc->proc_fops = &snd_mem_proc_fops;
+	snd_mem_proc = proc_create(SND_MEM_PROC_FILE, 0644, NULL,
+				   &snd_mem_proc_fops);
 #endif
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

