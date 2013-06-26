From: akpm@linux-foundation.org
Subject: +
 inode-convert-inode-lru-list-to-generic-lru-list-code-inode-move-inode-to-a-different-list-inside-lock.patch added to -mm tree
Date: Wed, 26 Jun 2013 13:33:50 -0700
Message-ID: <51cb502e.wfTp71LSlu+asE8G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54916 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab3FZUdw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jun 2013 16:33:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, glommer@openvz.org, dchinner@redhat.com, glommer@gmail.com

Subject: + inode-convert-inode-lru-list-to-generic-lru-list-code-inode-move-inode-to-a-different-list-inside-lock.patch added to -mm tree
To: glommer@gmail.com,dchinner@redhat.com,glommer@openvz.org,mhocko@suse.cz
From: akpm@linux-foundation.org
Date: Wed, 26 Jun 2013 13:33:50 -0700


The patch titled
     Subject: inode: move inode to a different list inside lock
has been added to the -mm tree.  Its filename is
     inode-convert-inode-lru-list-to-generic-lru-list-code-inode-move-inode-to-a-different-list-inside-lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Glauber Costa <glommer@gmail.com>
Subject: inode: move inode to a different list inside lock

When removing an element from the lru, this will be done today after the lock
is released. This is a clear mistake, although we are not sure if the bugs we
are seeing are related to this. All list manipulations are done inside the
lock, and so should this one.

Signed-off-by: Glauber Costa <glommer@openvz.org>
Tested-by: Michal Hocko <mhocko@suse.cz>
Cc: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/inode.c~inode-convert-inode-lru-list-to-generic-lru-list-code-inode-move-inode-to-a-different-list-inside-lock fs/inode.c
--- a/fs/inode.c~inode-convert-inode-lru-list-to-generic-lru-list-code-inode-move-inode-to-a-different-list-inside-lock
+++ a/fs/inode.c
@@ -735,9 +735,9 @@ inode_lru_isolate(struct list_head *item
 
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
+	list_move(&inode->i_lru, freeable);
 	spin_unlock(&inode->i_lock);
 
-	list_move(&inode->i_lru, freeable);
 	this_cpu_dec(nr_unused);
 	return LRU_REMOVED;
 }
_

Patches currently in -mm which might be from glommer@gmail.com are

linux-next.patch
inode-convert-inode-lru-list-to-generic-lru-list-code-inode-move-inode-to-a-different-list-inside-lock.patch
list_lru-remove-special-case-function-list_lru_dispose_all.patch
memcg-also-test-for-skip-accounting-at-the-page-allocation-level.patch
memcg-do-not-account-memory-used-for-cache-creation.patch

