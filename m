From: akpm@linux-foundation.org
Subject: [merged]
 reiserfs-fix-new_insert_key-may-be-used-uninitialized.patch removed from
 -mm tree
Date: Wed, 03 Aug 2016 11:13:21 -0700
Message-ID: <57a23441.vRjAGufgxHOl8D1k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33520 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757981AbcHCSNt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:13:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeffm@suse.com, arnd@arndb.de, jack@suse.cz, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: reiserfs: fix "new_insert_key may be used uninitialized ..."
has been removed from the -mm tree.  Its filename was
     reiserfs-fix-new_insert_key-may-be-used-uninitialized.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


