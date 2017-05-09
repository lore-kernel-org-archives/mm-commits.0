From: akpm@linux-foundation.org
Subject: [merged] proc-remove-cast-from-memory-allocation.patch
 removed from -mm tree
Date: Tue, 09 May 2017 11:00:30 -0700
Message-ID: <20170509180030.8Beq_lK1u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34196 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751838AbdEISAb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 14:00:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: me@tobin.cc, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/inode.c: remove cast from memory allocation
has been removed from the -mm tree.  Its filename was
     proc-remove-cast-from-memory-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Tobin C. Harding" <me@tobin.cc>
Subject: fs/proc/inode.c: remove cast from memory allocation

Coccinelle emits WARNING: casting value returned by memory allocation
function to (struct proc_inode *) is useless.

Remove unnecessary cast.

Link: http://lkml.kernel.org/r/1487745720-16967-1-git-send-email-me@tobin.cc
Signed-off-by: Tobin C. Harding <me@tobin.cc>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/inode.c~proc-remove-cast-from-memory-allocation fs/proc/inode.c
--- a/fs/proc/inode.c~proc-remove-cast-from-memory-allocation
+++ a/fs/proc/inode.c
@@ -58,7 +58,7 @@ static struct inode *proc_alloc_inode(st
 	struct proc_inode *ei;
 	struct inode *inode;
 
-	ei = (struct proc_inode *)kmem_cache_alloc(proc_inode_cachep, GFP_KERNEL);
+	ei = kmem_cache_alloc(proc_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	ei->pid = NULL;
_

Patches currently in -mm which might be from me@tobin.cc are


