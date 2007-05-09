From: akpm@linux-foundation.org
Subject: - proc-remove-pathetic-deleted-warn_on.patch removed from -mm tree
Date: Tue, 08 May 2007 19:46:03 -0700
Message-ID: <200705090246.l492k3B8008807@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969092AbXEICql (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:46:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, mm-commits@vger.kernel.org


The patch titled
     proc: remove pathetic ->deleted WARN_ON
has been removed from the -mm tree.  Its filename was
     proc-remove-pathetic-deleted-warn_on.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: proc: remove pathetic ->deleted WARN_ON
From: Alexey Dobriyan <adobriyan@sw.ru>

WARN_ON(de && de->deleted); is sooo unreliable. Why?

proc_lookup				remove_proc_entry
===========				=================
lock_kernel();
spin_lock(&proc_subdir_lock);
[find proc entry]
spin_unlock(&proc_subdir_lock);
					spin_lock(&proc_subdir_lock);
					[find proc entry]

proc_get_inode
==============
WARN_ON(de && de->deleted);			...

					if (!atomic_read(&de->count))
						free_proc_entry(de);
					else
						de->deleted = 1;

So, if you have some strange oops [1], and doesn't see this WARN_ON it means
nothing.

[1] try_module_get() of module which doesn't exist, two lines below
    should suffice, or not?

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/proc/inode.c~proc-remove-pathetic-deleted-warn_on fs/proc/inode.c
--- a/fs/proc/inode.c~proc-remove-pathetic-deleted-warn_on
+++ a/fs/proc/inode.c
@@ -146,8 +146,6 @@ struct inode *proc_get_inode(struct supe
 {
 	struct inode * inode;
 
-	WARN_ON(de && de->deleted);
-
 	if (de != NULL && !try_module_get(de->owner))
 		goto out_mod;
 
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
2621-rc5-mm3-fix-e1000-compilation.patch
fix-rmmod-read-write-races-in-proc-entries.patch
