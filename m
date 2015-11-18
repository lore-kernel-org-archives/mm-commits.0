From: akpm@linux-foundation.org
Subject: + fsnotify-use-list_next_entry-in-fsnotify_unmount_inodes.patch
 added to -mm tree
Date: Tue, 17 Nov 2015 16:39:22 -0800
Message-ID: <564bc8ba.9RCIIBvuJbYNZuQ9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49691 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbbKRAjW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Nov 2015 19:39:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@163.com, jack@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/notify/inode_mark.c: use list_next_entry in fsnotify_unmount_inodes
has been added to the -mm tree.  Its filename is
     fsnotify-use-list_next_entry-in-fsnotify_unmount_inodes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fsnotify-use-list_next_entry-in-fsnotify_unmount_inodes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fsnotify-use-list_next_entry-in-fsnotify_unmount_inodes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geliang Tang <geliangtang@163.com>
Subject: fs/notify/inode_mark.c: use list_next_entry in fsnotify_unmount_inodes

To make the intention clearer, use list_next_entry instead of list_entry.

Signed-off-by: Geliang Tang <geliangtang@163.com>
Cc: Jan Kara <jack@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/inode_mark.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/notify/inode_mark.c~fsnotify-use-list_next_entry-in-fsnotify_unmount_inodes fs/notify/inode_mark.c
--- a/fs/notify/inode_mark.c~fsnotify-use-list_next_entry-in-fsnotify_unmount_inodes
+++ a/fs/notify/inode_mark.c
@@ -199,8 +199,7 @@ void fsnotify_unmount_inodes(struct supe
 				break;
 			}
 			spin_unlock(&next_i->i_lock);
-			next_i = list_entry(next_i->i_sb_list.next,
-						struct inode, i_sb_list);
+			next_i = list_next_entry(next_i, i_sb_list);
 		}
 
 		/*
_

Patches currently in -mm which might be from geliangtang@163.com are

fsnotify-use-list_next_entry-in-fsnotify_unmount_inodes.patch
mm-vmalloc-use-list_nextfirst_entry.patch

