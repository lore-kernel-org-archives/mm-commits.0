From: akpm@linux-foundation.org
Subject: + proc-remove-pathetic-deleted-warn_on.patch added to -mm tree
Date: Thu, 15 Mar 2007 11:53:16 -0800
Message-ID: <200703151853.l2FIrIXX023409@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35798 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932310AbXCOSyC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 14:54:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru


The patch titled
     proc: remove pathetic ->deleted WARN_ON
has been added to the -mm tree.  Its filename is
     proc-remove-pathetic-deleted-warn_on.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -147,8 +147,6 @@ struct inode *proc_get_inode(struct supe
 {
 	struct inode * inode;
 
-	WARN_ON(de && de->deleted);
-
 	if (de != NULL && !try_module_get(de->owner))
 		goto out_mod;
 
_

Patches currently in -mm which might be from adobriyan@sw.ru are

fix-race-between-proc_readdir-and-remove_proc_entry.patch
proc-remove-pathetic-deleted-warn_on.patch
race-between-cat-proc-kallsyms-and-rmmod.patch
