From: akpm@linux-foundation.org
Subject: + vfs-add-cond_resched_lock-while-scanning-dentry-lru-lists.patch added to -mm tree
Date: Mon, 23 Jun 2008 19:11:50 -0700
Message-ID: <200806240211.m5O2BoA1027854@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35359 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756793AbYFXCLy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 22:11:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: k-makita@np.css.fujitsu.com, viro@zeniv.linux.org.uk


The patch titled
     vfs: add cond_resched_lock while scanning dentry LRU lists
has been added to the -mm tree.  Its filename is
     vfs-add-cond_resched_lock-while-scanning-dentry-lru-lists.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: add cond_resched_lock while scanning dentry LRU lists
From: Kentaro Makita <k-makita@np.css.fujitsu.com>

Add cond_resched_lock(&dcache_lock) while scanning LRU lists on
superblocks in __shrink_dcache_sb()

Signed-off-by: Kentaro Makita <k-makita@np.css.fujitsu.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/dcache.c~vfs-add-cond_resched_lock-while-scanning-dentry-lru-lists fs/dcache.c
--- a/fs/dcache.c~vfs-add-cond_resched_lock-while-scanning-dentry-lru-lists
+++ a/fs/dcache.c
@@ -483,6 +483,7 @@ restart:
 				if (--cnt == 0)
 					break;
 			}
+			cond_resched_lock(&dcache_lock);
 		}
 	}
 	while (!list_empty(&tmp)) {
_

Patches currently in -mm which might be from k-makita@np.css.fujitsu.com are

fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries.patch
fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix.patch
vfs-fix-coding-style-in-dcachec.patch
vfs-add-cond_resched_lock-while-scanning-dentry-lru-lists.patch

