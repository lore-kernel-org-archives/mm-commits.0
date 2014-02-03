From: akpm@linux-foundation.org
Subject: + bcache-drop-l-suffix-when-comparing-ssize_t-with-0.patch added
 to -mm tree
Date: Mon, 03 Feb 2014 14:10:42 -0800
Message-ID: <52f013e2.TXDWEpixEAXa3Bhe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46939 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaBCWKn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Feb 2014 17:10:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, geert@linux-m68k.org

Subject: + bcache-drop-l-suffix-when-comparing-ssize_t-with-0.patch added to -mm tree
To: geert@linux-m68k.org
From: akpm@linux-foundation.org
Date: Mon, 03 Feb 2014 14:10:42 -0800


The patch titled
     Subject: drivers/md/bcache/btree.c: drop L-suffix when comparing ssize_t with 0
has been added to the -mm tree.  Its filename is
     bcache-drop-l-suffix-when-comparing-ssize_t-with-0.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bcache-drop-l-suffix-when-comparing-ssize_t-with-0.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bcache-drop-l-suffix-when-comparing-ssize_t-with-0.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: drivers/md/bcache/btree.c: drop L-suffix when comparing ssize_t with 0

drivers/md/bcache/btree.c: In function `insert_u64s_remaining':
drivers/md/bcache/btree.c:1816: warning: comparison of distinct pointer types lacks a cast

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
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
bcache-drop-l-suffix-when-comparing-ssize_t-with-0.patch

