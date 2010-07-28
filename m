From: akpm@linux-foundation.org
Subject: + random-reorder-struct-entropy_store-to-remove-padding-on-64bits.patch added to -mm tree
Date: Wed, 28 Jul 2010 15:49:13 -0700
Message-ID: <201007282249.o6SMnDKo007011@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750980Ab0G1WuM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Jul 2010 18:50:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@rsk.demon.co.uk, herbert@gondor.hengli.com.au, mpm@selenic.com


The patch titled
     random: reorder struct entropy_store to remove padding on 64bits
has been added to the -mm tree.  Its filename is
     random-reorder-struct-entropy_store-to-remove-padding-on-64bits.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: random: reorder struct entropy_store to remove padding on 64bits
From: Richard Kennedy <richard@rsk.demon.co.uk>

Re-order structure entropy_store to remove 8 bytes of padding on 64 bit
builds, so shrinking this structure from 72 to 64 bytes and allowing it to
fit into one cache line.

mpm sez: I have a vague memory that we reordered things so that the r/w
bits would be on a separate cache line than the r/o bits.  But as we never
added the alignment primitives to actually enforce that, I guess it
doesn't matter much.  

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Acked-by: Matt Mackall <mpm@selenic.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/random.c~random-reorder-struct-entropy_store-to-remove-padding-on-64bits drivers/char/random.c
--- a/drivers/char/random.c~random-reorder-struct-entropy_store-to-remove-padding-on-64bits
+++ a/drivers/char/random.c
@@ -407,8 +407,8 @@ struct entropy_store {
 	struct poolinfo *poolinfo;
 	__u32 *pool;
 	const char *name;
-	int limit;
 	struct entropy_store *pull;
+	int limit;
 
 	/* read-write data: */
 	spinlock_t lock;
_

Patches currently in -mm which might be from richard@rsk.demon.co.uk are

timer_list-remove-alignment-padding-on-64-bit-when-config_timer_stats.patch
buffer_head-remove-redundant-test-from-wait_on_buffer.patch
writeback-reduce-calls-to-global_page_state-in-balance_dirty_pages.patch
random-reorder-struct-entropy_store-to-remove-padding-on-64bits.patch

