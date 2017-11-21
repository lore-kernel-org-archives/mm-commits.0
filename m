From: akpm@linux-foundation.org
Subject: + vfs-remove-might_sleep-from-clear_inode.patch added to -mm tree
Date: Tue, 21 Nov 2017 15:34:25 -0800
Message-ID: <5a14b801.WiYLUskoljHxhuK7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40676 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751290AbdKUXe0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Nov 2017 18:34:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shakeelb@google.com, gthelen@google.com, hannes@cmpxchg.org, jack@suse.cz, mhocko@suse.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: vfs: remove might_sleep() from clear_inode()
has been added to the -mm tree.  Its filename is
     vfs-remove-might_sleep-from-clear_inode.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vfs-remove-might_sleep-from-clear_inode.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vfs-remove-might_sleep-from-clear_inode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: vfs: remove might_sleep() from clear_inode()

7994e6f72543 ("vfs: Move waiting for inode writeback from end_writeback()
to evict_inode()") removed inode_sync_wait() from end_writeback() and
commit dbd5768f87ff ("vfs: Rename end_writeback() to clear_inode()")
renamed end_writeback() to clear_inode().  After these patches there is no
sleeping operation in clear_inode().  So, remove might_sleep() from it.

Link: http://lkml.kernel.org/r/20171108004354.40308-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Greg Thelen <gthelen@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/inode.c~vfs-remove-might_sleep-from-clear_inode fs/inode.c
--- a/fs/inode.c~vfs-remove-might_sleep-from-clear_inode
+++ a/fs/inode.c
@@ -497,7 +497,6 @@ EXPORT_SYMBOL(__remove_inode_hash);
 
 void clear_inode(struct inode *inode)
 {
-	might_sleep();
 	/*
 	 * We have to cycle tree_lock here because reclaim can be still in the
 	 * process of removing the last page (in __delete_from_page_cache())
_

Patches currently in -mm which might be from shakeelb@google.com are

mm-mlock-vmscan-no-more-skipping-pagevecs.patch
vfs-remove-might_sleep-from-clear_inode.patch

