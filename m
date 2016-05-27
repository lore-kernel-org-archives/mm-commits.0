From: akpm@linux-foundation.org
Subject: + reiserfs-avoid-uninitialized-variable-use.patch added to -mm
 tree
Date: Fri, 27 May 2016 13:31:50 -0700
Message-ID: <5748aeb6.fN9D/KJvuQPxmFHi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44482 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbcE0Ubv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 16:31:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, jack@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: reiserfs: avoid uninitialized variable use
has been added to the -mm tree.  Its filename is
     reiserfs-avoid-uninitialized-variable-use.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/reiserfs-avoid-uninitialized-variable-use.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/reiserfs-avoid-uninitialized-variable-use.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: reiserfs: avoid uninitialized variable use

I got this warning on an ARM64 allmodconfig build with gcc-5.3:

fs/reiserfs/ibalance.c: In function 'balance_internal':
fs/reiserfs/ibalance.c:1158:3: error: 'new_insert_key' may be used uninitialized in this function [-Werror=maybe-uninitialized]
   memcpy(new_insert_key_addr, &new_insert_key, KEY_SIZE);

The warning is correct, in fact both new_insert_key and new_insert_ptr are
only updated inside of an if() block, but used at the end of the function.

Looking at how the balance_internal() function gets called, it is clear
that this is harmless because the caller never uses the updated arrays,
they are initialized from balance_leaf_new_nodes() and then passed into
balance_internal().

This has not changed at all since the start of the git history, but
apparently the warning has only recently appeared.

This modifies the function to only update the two argument variables when
the new_insert_key and new_insert_ptr have been updated, to get rid of the
warning.

Link: http://lkml.kernel.org/r/1464380569-3493380-1-git-send-email-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/ibalance.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/reiserfs/ibalance.c~reiserfs-avoid-uninitialized-variable-use fs/reiserfs/ibalance.c
--- a/fs/reiserfs/ibalance.c~reiserfs-avoid-uninitialized-variable-use
+++ a/fs/reiserfs/ibalance.c
@@ -1138,6 +1138,9 @@ int balance_internal(struct tree_balance
 		       S_new);
 
 		/* S_new is released in unfix_nodes */
+
+		memcpy(new_insert_key_addr, &new_insert_key, KEY_SIZE);
+		insert_ptr[0] = new_insert_ptr;
 	}
 
 	n = B_NR_ITEMS(tbSh);	/*number of items in S[h] */
@@ -1153,8 +1156,5 @@ int balance_internal(struct tree_balance
 				       insert_ptr);
 	}
 
-	memcpy(new_insert_key_addr, &new_insert_key, KEY_SIZE);
-	insert_ptr[0] = new_insert_ptr;
