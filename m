From: akpm@linux-foundation.org
Subject: [merged]
 fsnotify-use-list_next_entry-in-fsnotify_unmount_inodes.patch removed from
 -mm tree
Date: Fri, 15 Jan 2016 14:31:16 -0800
Message-ID: <56997334.jgvx5siCP+Bz26et%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58954 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbcAOWbQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:31:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@163.com, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/notify/inode_mark.c: use list_next_entry in fsnotify_unmount_inodes
has been removed from the -mm tree.  Its filename was
     fsnotify-use-list_next_entry-in-fsnotify_unmount_inodes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geliang Tang <geliangtang@163.com>
Subject: fs/notify/inode_mark.c: use list_next_entry in fsnotify_unmount_inodes

To make the intention clearer, use list_next_entry instead of list_entry.

Signed-off-by: Geliang Tang <geliangtang@163.com>
Reviewed-by: Jan Kara <jack@suse.cz>
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

mm-swapfilec-use-list_for_each_entry_safe-in-free_swap_count_continuations.patch
mm-move-lru_to_page-to-mm_inlineh.patch
mm-zbud-use-list_last_entry-instead-of-list_tail_entry.patch
hfs-use-list_for_each_entry-in-hfs_cat_delete.patch
kexec-use-list_for_each_entry_safe-in-kimage_free_page_list.patch
rapidio-use-kobj_to_dev.patch
dma-mapping-use-offset_in_page-macro.patch

