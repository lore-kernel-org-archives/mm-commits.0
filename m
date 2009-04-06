From: akpm@linux-foundation.org
Subject: [merged] kernel-cgroupc-kfreenull-is-legal.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:34:13 -0700
Message-ID: <200904061934.n36JYDjI011504@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34239 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757213AbZDFTgq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:36:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jj@chaosbits.net, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     kernel/cgroup.c: kfree(NULL) is legal
has been removed from the -mm tree.  Its filename was
     kernel-cgroupc-kfreenull-is-legal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/cgroup.c: kfree(NULL) is legal
From: Jesper Juhl <jj@chaosbits.net>

Reduces object file size a bit:

Before:
$ size kernel/cgroup.o
   text    data     bss     dec     hex filename
  21593    7804    4924   34321    8611 kernel/cgroup.o
After:
$ size kernel/cgroup.o
   text    data     bss     dec     hex filename
  21537    7744    4924   34205    859d kernel/cgroup.o

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN kernel/cgroup.c~kernel-cgroupc-kfreenull-is-legal kernel/cgroup.c
--- a/kernel/cgroup.c~kernel-cgroupc-kfreenull-is-legal
+++ a/kernel/cgroup.c
@@ -923,8 +923,7 @@ static int cgroup_remount(struct super_b
 	if (opts.release_agent)
 		strcpy(root->release_agent_path, opts.release_agent);
  out_unlock:
-	if (opts.release_agent)
-		kfree(opts.release_agent);
+	kfree(opts.release_agent);
 	mutex_unlock(&cgroup_mutex);
 	mutex_unlock(&cgrp->dentry->d_inode->i_mutex);
 	return ret;
@@ -1027,15 +1026,13 @@ static int cgroup_get_sb(struct file_sys
 	/* First find the desired set of subsystems */
 	ret = parse_cgroupfs_options(data, &opts);
 	if (ret) {
-		if (opts.release_agent)
-			kfree(opts.release_agent);
+		kfree(opts.release_agent);
 		return ret;
 	}
 
 	root = kzalloc(sizeof(*root), GFP_KERNEL);
 	if (!root) {
-		if (opts.release_agent)
-			kfree(opts.release_agent);
+		kfree(opts.release_agent);
 		return -ENOMEM;
 	}
 
_

Patches currently in -mm which might be from jj@chaosbits.net are

origin.patch

