From: akpm@linux-foundation.org
Subject: [merged] btree-catch-null-value-before-it-does-harm.patch removed from -mm tree
Date: Fri, 08 Jun 2012 12:41:39 -0700
Message-ID: <20120608194139.56701A022F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:59737 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933226Ab2FHTlm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2012 15:41:42 -0400
Received: by lbbgp10 with SMTP id gp10so131732lbb.1
        for <mm-commits@vger.kernel.org>; Fri, 08 Jun 2012 12:41:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joern@logfs.org, roland@purestorage.com, mm-commits@vger.kernel.org


The patch titled
     Subject: btree: catch NULL value before it does harm
has been removed from the -mm tree.  Its filename was
     btree-catch-null-value-before-it-does-harm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from joern@logfs.org are

origin.patch

