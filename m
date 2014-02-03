From: akpm@linux-foundation.org
Subject: + bcache-use-%zi-to-format-size_t.patch added to -mm tree
Date: Mon, 03 Feb 2014 14:10:41 -0800
Message-ID: <52f013e1.tRne28q9NNNq8So6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46937 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaBCWKm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Feb 2014 17:10:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, geert@linux-m68k.org

Subject: + bcache-use-%zi-to-format-size_t.patch added to -mm tree
To: geert@linux-m68k.org
From: akpm@linux-foundation.org
Date: Mon, 03 Feb 2014 14:10:41 -0800


The patch titled
     Subject: drivers/md/bcache/extents.c: use %zi to format size_t
has been added to the -mm tree.  Its filename is
     bcache-use-%zi-to-format-size_t.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bcache-use-%zi-to-format-size_t.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bcache-use-%zi-to-format-size_t.patch

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
Subject: drivers/md/bcache/extents.c: use %zi to format size_t

drivers/md/bcache/extents.c: In function `btree_ptr_bad_expensive':
drivers/md/bcache/extents.c:196: warning: format `%li' expects type `long int', but argument 4 has type `size_t'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/bcache/extents.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/md/bcache/extents.c~bcache-use-%zi-to-format-size_t drivers/md/bcache/extents.c
--- a/drivers/md/bcache/extents.c~bcache-use-%zi-to-format-size_t
+++ a/drivers/md/bcache/extents.c
@@ -194,7 +194,7 @@ err:
 	mutex_unlock(&b->c->bucket_lock);
 	bch_extent_to_text(buf, sizeof(buf), k);
 	btree_bug(b,
-"inconsistent btree pointer %s: bucket %li pin %i prio %i gen %i last_gc %i mark %llu gc_gen %i",
+"inconsistent btree pointer %s: bucket %zi pin %i prio %i gen %i last_gc %i mark %llu gc_gen %i",
 		  buf, PTR_BUCKET_NR(b->c, k, i), atomic_read(&g->pin),
 		  g->prio, g->gen, g->last_gc, GC_MARK(g), g->gc_gen);
 	return true;
_

Patches currently in -mm which might be from geert@linux-m68k.org are

bcache-use-%zi-to-format-size_t.patch
bcache-drop-l-suffix-when-comparing-ssize_t-with-0.patch

