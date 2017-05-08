From: akpm@linux-foundation.org
Subject: [patch 009/114] fs/proc/inode.c: remove cast from memory
 allocation
Date: Mon, 08 May 2017 15:54:55 -0700
Message-ID: <20170508225455.CFkvqXu3f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45758 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751828AbdEHWy5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:54:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, me@tobin.cc, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
