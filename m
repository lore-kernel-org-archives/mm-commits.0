From: akpm@linux-foundation.org
Subject: + proc-remove-cast-from-memory-allocation.patch added to -mm tree
Date: Tue, 28 Feb 2017 16:59:13 -0800
Message-ID: <58b61ce1.PGYUFBfb7rQ70hhy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60928 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751740AbdCABhz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 20:37:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: me@tobin.cc, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/inode.c:  remove cast from memory allocation
has been added to the -mm tree.  Its filename is
     proc-remove-cast-from-memory-allocation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-remove-cast-from-memory-allocation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-remove-cast-from-memory-allocation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Tobin C. Harding" <me@tobin.cc>
Subject: fs/proc/inode.c:  remove cast from memory allocation

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

proc-remove-cast-from-memory-allocation.patch

