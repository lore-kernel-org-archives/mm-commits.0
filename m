From: akpm@linux-foundation.org
Subject: [merged] bcache-use-%zi-to-format-size_t.patch removed from -mm
 tree
Date: Tue, 11 Feb 2014 11:23:28 -0800
Message-ID: <52fa78b0.YgfAbtTwkttJaV7d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40867 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927AbaBKTX2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Feb 2014 14:23:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, neilb@suse.de, kmo@daterainc.com, geert@linux-m68k.org

Subject: [merged] bcache-use-%zi-to-format-size_t.patch removed from -mm tree
To: geert@linux-m68k.org,kmo@daterainc.com,neilb@suse.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 11 Feb 2014 11:23:28 -0800


The patch titled
     Subject: drivers/md/bcache/extents.c: use %zi to format size_t
has been removed from the -mm tree.  Its filename was
     bcache-use-%zi-to-format-size_t.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: drivers/md/bcache/extents.c: use %zi to format size_t

drivers/md/bcache/extents.c: In function `btree_ptr_bad_expensive':
drivers/md/bcache/extents.c:196: warning: format `%li' expects type `long int', but argument 4 has type `size_t'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Neil Brown <neilb@suse.de>
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

origin.patch
linux-next.patch

