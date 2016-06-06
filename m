From: akpm@linux-foundation.org
Subject: + reiserfs-fix-new_insert_key-may-be-used-uninitialized.patch
 added to -mm tree
Date: Mon, 06 Jun 2016 15:29:11 -0700
Message-ID: <5755f937.uFWdy/7/AHsIt4ic%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38617 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbcFFW3N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jun 2016 18:29:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeffm@suse.com, arnd@arndb.de, jack@suse.cz, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: reiserfs: fix "new_insert_key may be used uninitialized ..."
has been added to the -mm tree.  Its filename is
     reiserfs-fix-new_insert_key-may-be-used-uninitialized.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/reiserfs-fix-new_insert_key-may-be-used-uninitialized.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/reiserfs-fix-new_insert_key-may-be-used-uninitialized.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jeff Mahoney <jeffm@suse.com>
Subject: reiserfs: fix "new_insert_key may be used uninitialized ..."

new_insert_key only makes any sense when it's associated with a
new_insert_ptr, which is initialized to NULL and changed to a buffer_head
when we also initialize new_insert_key.  We can key off of that to avoid
the uninitialized warning.

Link: http://lkml.kernel.org/r/5eca5ffb-2155-8df2-b4a2-f162f105efed@suse.com
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/ibalance.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/reiserfs/ibalance.c~reiserfs-fix-new_insert_key-may-be-used-uninitialized fs/reiserfs/ibalance.c
--- a/fs/reiserfs/ibalance.c~reiserfs-fix-new_insert_key-may-be-used-uninitialized
+++ a/fs/reiserfs/ibalance.c
@@ -1153,8 +1153,9 @@ int balance_internal(struct tree_balance
 				       insert_ptr);
 	}
 
-	memcpy(new_insert_key_addr, &new_insert_key, KEY_SIZE);
 	insert_ptr[0] = new_insert_ptr;
+	if (new_insert_ptr)
+		memcpy(new_insert_key_addr, &new_insert_key, KEY_SIZE);
 
 	return order;
 }
_

Patches currently in -mm which might be from jeffm@suse.com are

reiserfs-fix-new_insert_key-may-be-used-uninitialized.patch

