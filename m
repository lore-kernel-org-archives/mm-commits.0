From: akpm@linux-foundation.org
Subject: [to-be-updated]
 bcache-drop-l-suffix-when-comparing-ssize_t-with-0.patch removed from -mm
 tree
Date: Thu, 06 Feb 2014 12:51:22 -0800
Message-ID: <52f3f5ca.6w/gZymQyjmt5TpJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48965 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbaBFUvX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Feb 2014 15:51:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, neilb@suse.de, kmo@daterainc.com, geert@linux-m68k.org

Subject: [to-be-updated] bcache-drop-l-suffix-when-comparing-ssize_t-with-0.patch removed from -mm tree
To: geert@linux-m68k.org,kmo@daterainc.com,neilb@suse.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 06 Feb 2014 12:51:22 -0800


The patch titled
     Subject: drivers/md/bcache/btree.c: drop L-suffix when comparing ssize_t with 0
has been removed from the -mm tree.  Its filename was
     bcache-drop-l-suffix-when-comparing-ssize_t-with-0.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: drivers/md/bcache/btree.c: drop L-suffix when comparing ssize_t with 0

drivers/md/bcache/btree.c: In function `insert_u64s_remaining':
drivers/md/bcache/btree.c:1816: warning: comparison of distinct pointer types lacks a cast

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/bcache/btree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/md/bcache/btree.c~bcache-drop-l-suffix-when-comparing-ssize_t-with-0 drivers/md/bcache/btree.c
--- a/drivers/md/bcache/btree.c~bcache-drop-l-suffix-when-comparing-ssize_t-with-0
+++ a/drivers/md/bcache/btree.c
@@ -1813,7 +1813,7 @@ static size_t insert_u64s_remaining(stru
 	if (b->keys.ops->is_extents)
 		ret -= KEY_MAX_U64S;
 
-	return max(ret, 0L);
+	return max(ret, 0);
 }
 
 static bool bch_btree_insert_keys(struct btree *b, struct btree_op *op,
_

Patches currently in -mm which might be from geert@linux-m68k.org are

bcache-use-%zi-to-format-size_t.patch
bcache-drop-l-suffix-when-comparing-ssize_t-with-0-fix.patch
linux-next.patch

