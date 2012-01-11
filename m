From: akpm@linux-foundation.org
Subject: [merged] btree-export-btree_get_prev-so-modules-can-use-btree_for_each.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:30:51 -0800
Message-ID: <20120111213052.0370B200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:59532 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933921Ab2AKVax (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:30:53 -0500
Received: by mail-ee0-f74.google.com with SMTP id d41so44333eek.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:30:53 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steve@purestorage.com, joern@logfs.org, roland@purestorage.com, mm-commits@vger.kernel.org


The patch titled
     Subject: btree: export btree_get_prev() so modules can use btree_for_each
has been removed from the -mm tree.  Its filename was
     btree-export-btree_get_prev-so-modules-can-use-btree_for_each.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Steve Hodgson <steve@purestorage.com>
Subject: btree: export btree_get_prev() so modules can use btree_for_each

The btree_for_each API is implemented with macros that internally call
btree_get_prev(), so if btree_get_prev() isn't exported then modules fail
to link if they try to use one of the btree_for_each macros.  Since the
rest of the btree API is exported, we should keep things orthogonal and
make this work too.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Steve Hodgson <steve@purestorage.com>
Acked-by: Joern Engel <joern@logfs.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/btree.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/btree.c~btree-export-btree_get_prev-so-modules-can-use-btree_for_each lib/btree.c
--- a/lib/btree.c~btree-export-btree_get_prev-so-modules-can-use-btree_for_each
+++ a/lib/btree.c
@@ -357,6 +357,7 @@ miss:
 	}
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(btree_get_prev);
 
 static int getpos(struct btree_geo *geo, unsigned long *node,
 		unsigned long *key)
_

Patches currently in -mm which might be from steve@purestorage.com are

origin.patch

