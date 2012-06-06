From: akpm@linux-foundation.org
Subject: + btree-catch-null-value-before-it-does-harm.patch added to -mm tree
Date: Wed, 06 Jun 2012 16:22:53 -0700
Message-ID: <20120606232253.E950BA02AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:34034 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759251Ab2FFXWz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2012 19:22:55 -0400
Received: by vbnl22 with SMTP id l22so769514vbn.1
        for <mm-commits@vger.kernel.org>; Wed, 06 Jun 2012 16:22:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joern@logfs.org, roland@purestorage.com


The patch titled
     Subject: btree: catch NULL value before it does harm
has been added to the -mm tree.  Its filename is
     btree-catch-null-value-before-it-does-harm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joern Engel <joern@logfs.org>
Subject: btree: catch NULL value before it does harm

Storing NULL values in the btree is illegal and can lead to memory
corruption and possible other fun as well.  Catch it on insert, instead of
waiting for the inevitable.

Signed-off-by: Joern Engel <joern@logfs.org>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/btree.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/btree.c~btree-catch-null-value-before-it-does-harm lib/btree.c
--- a/lib/btree.c~btree-catch-null-value-before-it-does-harm
+++ a/lib/btree.c
@@ -509,6 +509,7 @@ retry:
 int btree_insert(struct btree_head *head, struct btree_geo *geo,
 		unsigned long *key, void *val, gfp_t gfp)
 {
+	BUG_ON(!val);
 	return btree_insert_level(head, geo, key, val, 1, gfp);
 }
 EXPORT_SYMBOL_GPL(btree_insert);
_
Subject: Subject: btree: catch NULL value before it does harm

Patches currently in -mm which might be from joern@logfs.org are

btree-fix-tree-corruption-in-btree_get_prev.patch
btree-fix-tree-corruption-in-btree_get_prev-fix.patch
btree-catch-null-value-before-it-does-harm.patch

