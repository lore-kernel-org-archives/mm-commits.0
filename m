From: akpm@linux-foundation.org
Subject: [merged] btree-fix-tree-corruption-in-btree_get_prev.patch removed from -mm tree
Date: Fri, 08 Jun 2012 12:41:37 -0700
Message-ID: <20120608194137.60DB8A022F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:48722 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933226Ab2FHTli (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2012 15:41:38 -0400
Received: by vcbfl13 with SMTP id fl13so203777vcb.1
        for <mm-commits@vger.kernel.org>; Fri, 08 Jun 2012 12:41:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@purestorage.com, joern@logfs.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: btree: fix tree corruption in btree_get_prev()
has been removed from the -mm tree.  Its filename was
     btree-fix-tree-corruption-in-btree_get_prev.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Roland Dreier <roland@purestorage.com>
Subject: btree: fix tree corruption in btree_get_prev()

The memory the parameter __key points to is used as an iterator in
btree_get_prev(), so if we save off a bkey() pointer in retry_key and then
assign that to __key, we'll end up corrupting the btree internals when we
do eg

	longcpy(__key, bkey(geo, node, i), geo->keylen);

to return the key value.  What we should do instead is use longcpy() to
copy the key value that retry_key points to __key.

This can cause a btree to get corrupted by seemingly read-only operations
such as btree_for_each_safe.

[akpm@linux-foundation.org: avoid the double longcpy()]
Signed-off-by: Roland Dreier <roland@purestorage.com>
Acked-by: Joern Engel <joern@logfs.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/btree.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/btree.c~btree-fix-tree-corruption-in-btree_get_prev lib/btree.c
--- a/lib/btree.c~btree-fix-tree-corruption-in-btree_get_prev
+++ a/lib/btree.c
@@ -319,8 +319,8 @@ void *btree_get_prev(struct btree_head *
 
 	if (head->height == 0)
 		return NULL;
-retry:
 	longcpy(key, __key, geo->keylen);
+retry:
 	dec_key(geo, key);
 
 	node = head->node;
@@ -351,7 +351,7 @@ retry:
 	}
 miss:
 	if (retry_key) {
-		__key = retry_key;
+		longcpy(key, retry_key, geo->keylen);
 		retry_key = NULL;
 		goto retry;
 	}
_

Patches currently in -mm which might be from roland@purestorage.com are

origin.patch

